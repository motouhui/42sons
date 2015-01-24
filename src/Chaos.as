package 
{
    import com.sina.microblog.MicroBlog;
    import com.sina.microblog.events.MicroBlogErrorEvent;
    import com.sina.microblog.events.MicroBlogEvent;
    
    import GGM.avatar.AvatarBase;
    
    public class Chaos
    {
		private static const NUMBER_OF_PLAYERS:int = 42;
		
        private var _mb:MicroBlog = new MicroBlog();
		private var _uidMap:Object = new Object(); // 临时存放微博用户id的哈希表，用来去重
		private var _myUid:String = ""; // 玩家自己的微博 id
		private var _me:Object; // 微博拉到的玩家自己的object
		private var _initUsers:Array = new Array(); // 微博拉倒的用户object的集合
		private var _initGamePlayers:Array = new Array(); // 用来初始化游戏里每个NPC的必要属性参数集合
		private var _afterGenesisCallback:Function; // Chaos创世完成后调用的回调
		private var _tempNumberOfPlayers:int = NUMBER_OF_PLAYERS;

        
        public function Chaos(callback:Function)
        {
			_afterGenesisCallback = callback;
			
            _mb.consumerKey = "1621585982"; //申请的App Key
            _mb.consumerSecret = "9ecb38499979eb668a9b0b0ef0687acf"; //申请的App Secrect
            _mb.proxyURI = "http://flashsdk.sinaapp.com/proxy/proxy.php"; //写你自己部署的代理接口地址
            
            _mb.addEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
            _mb.login();
        }
        
        /*
        * 成功登录，获取到access_token，expires_in和refresh_token
        */
        protected function onLoginResult(e:MicroBlogEvent):void
        {
            _mb.removeEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
            trace(e.result["access_token"] + "::" + e.result["expires_in"] + "::" + e.result["refresh_token"]);  
            
            getMyUid();
        }
        
        protected function getMyUid():void
        {
            _mb.addEventListener("getUidResult", getUidResult);
            _mb.addEventListener("getUidError", getUidError);
            _mb.callWeiboAPI(randomKey(), "2/account/get_uid", null, "GET", "getUidResult", "getUidError"); 
        }
        
        // get uid callbacks
        private function getUidResult(e:MicroBlogEvent):void
        {
            trace(e.result.uid); //按照线上文档返回格式格式： {"uid":"3456676543"}
			_myUid = e.result.uid;
            
            getUserInfo(e.result.uid);
            
            _mb.addEventListener("getFriendsResult", getFriendsResult);
            _mb.addEventListener("getFriendsError", getFriendsError);
            _mb.callWeiboAPI(randomKey(), "2/friendships/friends/ids", {"uid":e.result.uid, "count":5000}, "GET", "getFriendsResult", "getFriendsError");
            
            _mb.addEventListener("getBilateralResult", getBilateralResult);
            _mb.addEventListener("getBilateralError", getBilateralError);
            _mb.callWeiboAPI(randomKey(), "2/friendships/friends/bilateral/ids", {"uid":e.result.uid, "count":2000}, "GET", "getBilateralResult", "getBilateralError");
        }
        private function getUidError(e:MicroBlogErrorEvent):void
        {
            trace(e.message);
        }
        
        // get user info
        private function getUserInfo(uid:String):void
        {
            var resultHandlerName:String = "getUserInfoResult" + uid;
            var errorHandlerName:String = "getUserInfoError" + uid;
            trace("resultHandlerName", uid, resultHandlerName);
            trace("errorHandlerName", uid, errorHandlerName);
            _mb.addEventListener(resultHandlerName, getUserInfoResult);
            _mb.addEventListener(errorHandlerName, getUserInfoError);
            _mb.callWeiboAPI(randomKey(), "2/users/show", {"uid":uid}, "GET", resultHandlerName, errorHandlerName);
        }
        
        // get user info callbacks
        private function getUserInfoResult(e:MicroBlogEvent):void
        {
            trace(e.type);
			var uid:String = e.type.replace("getUserInfoResult", "");
			if (uid == _myUid) {
            	printObject(e.result);
				_me = e.result;
			} else {
				_initUsers.push(e.result);
			}
			// 查看初始化是否全部完成
			trace(_initUsers.length, _tempNumberOfPlayers);
			if (_me && _initUsers.length >= _tempNumberOfPlayers){
				trace("initializing DONE!!!")
				initGamePeople();
			}
        }
        private function getUserInfoError(e:MicroBlogErrorEvent):void
        {
            trace(e.type);
            trace(e.message);
			// 如果请求失败了一个，那就不取42个，只取41个就好。
			// getUserInfoResult会根据_tempNumberOfPlayers的数量决定是否完成全部数据抓取
			_tempNumberOfPlayers--;
        }
        
        // get friends callbacks
        private function getFriendsResult(e:MicroBlogEvent):void
        {
            trace("getFriendsResult");
			printObject(e.result);
			var arr:Array = new Array();
			var map:Object = new Object();
			while (arr.length < NUMBER_OF_PLAYERS / 2) {
				var idx:int = randomNumber(0, e.result.ids.length - 1);
				var uid:String = e.result.ids[idx];
				if (!map[uid]) { // distinct
					map[uid] = true
					arr.push(uid);
				}
			}
			for each (var id:String in arr) {
				getUserInfo(id);
			}
        }
        private function getFriendsError(e:MicroBlogErrorEvent):void
        {
            trace("getFriendsError");
            trace(e.message);
        }
        
        // get bilateral callbacks
        private function getBilateralResult(e:MicroBlogEvent):void
        {
            trace("getBilateralResult");
            printObject(e.result);
            var arr:Array = new Array();
            while (arr.length < NUMBER_OF_PLAYERS / 2) {
                var idx:int = randomNumber(0, e.result.ids.length - 1);
                var uid:String = e.result.ids[idx];
                if (!_uidMap[uid]) { // distinct
                    _uidMap[uid] = true
                    arr.push(uid);
                }
            }
            for each (var id:String in arr) {
                getUserInfo(id);
            }
        }
        private function getBilateralError(e:MicroBlogErrorEvent):void
        {
            trace("getBilateralError");
            trace(e.message);
        }
        
        
        private function initGamePeople():void
		{
			trace("init people with weibo users information");
			for each (var weiboUser:Object in _initUsers) {
				trace("got user", weiboUser.name);
				_initGamePlayers.push(generateArgsGroupByWeiboUser(weiboUser));
			}
			// 完成数据拉取，继续游戏初始化
			_afterGenesisCallback(generateArgsGroupByWeiboUser(_me), _initGamePlayers);
		}
		
		private function generateArgsGroupByWeiboUser(weiboUser:Object):Object
		{
			var avatar:int = Math.abs(weiboUser.id % 45);
			var speed:int = Math.abs(weiboUser.id % 5) + 1;
			var type:String;
			switch(Math.abs(weiboUser.id) % 3) {
				case 0: type = AvatarBase.PERSON_TYPE_CRAZY_ATTACK; break;
				case 1: type = AvatarBase.PERSON_TYPE_CALM; break;
				case 2: type = AvatarBase.PERSON_TYPE_TIMID; break;
				default: type = AvatarBase.PERSON_TYPE_CALM;
			}
			var name:String = weiboUser.name;
			return {"avatar":avatar,"speed":speed,"type":type,"name":name};
		}
        
        private function printObject(object:Object):void
        {
            for (var key:String in object) {
                trace("    " + key + " : " + object[key]);
            }
            trace(" ");
        }
        
        /** 
         * Generates a truly "random" number
         * @return Random Number
         */ 
        private function randomNumber(low:Number=0, high:Number=1):Number
        {
            var num:Number = Math.floor(Math.random() * (1+high-low)) + low;
            trace(num + "")
            return num;
        }
        
        private function randomKey():String
        {
            return "KEY" + Math.floor(Math.random() * (1+99999-10000)) + 10000;
        }
        
    }
}