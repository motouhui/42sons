package 
{
    import com.sina.microblog.MicroBlog;
    import com.sina.microblog.events.MicroBlogErrorEvent;
    import com.sina.microblog.events.MicroBlogEvent;
    
    public class Chaos
    {
        var _mb:MicroBlog = new MicroBlog();
        
        public function Chaos()
        {
            _mb.consumerKey = "1746009255"; //申请的App Key
            _mb.consumerSecret = "9d80797613ae15d33e52f6acaa121c75"; //申请的App Secrect
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
            
            testAPI();
        }
        
        protected function testAPI():void
        {
            _mb.addEventListener("getUidResult", getUidResult);
            _mb.addEventListener("getUidError", getUidError);
            _mb.callWeiboAPI(randomKey(), "2/account/get_uid", null, "GET", "getUidResult", "getUidError"); 
        }
        
        // get uid callbacks
        private function getUidResult(e:MicroBlogEvent):void
        {
            trace(e.result.uid); //按照线上文档返回格式格式： {"uid":"3456676543"}
            
            getUserInfo(e.result.uid);
            
            _mb.addEventListener("getFriendsResult", getFriendsResult);
            _mb.addEventListener("getFriendsError", getFriendsError);
            _mb.callWeiboAPI(randomKey(), "2/friendships/friends", {"uid":e.result.uid, "count":200}, "GET", "getFriendsResult", "getFriendsError");
            
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
            var resultHandlerName:String = "getUserInfoResult" + randomNumber(1000,9999);
            var errorHandlerName:String = "getUserInfoError" + randomNumber(1000,9999);
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
            printObject(e.result);
        }
        private function getUserInfoError(e:MicroBlogErrorEvent):void
        {
            trace(e.type);
            trace(e.message);
        }
        
        // get friends callbacks
        private function getFriendsResult(e:MicroBlogEvent):void
        {
            trace("getFriendsResult");
            printObject(e.result);
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
            var map:Object = new Object();
            while (arr.length < 5) {
                var idx:int = randomNumber(0, e.result.ids.length - 1);
                var uid = e.result.ids[idx];
                if (!map[uid]) { // distinct
                    map[uid] = true
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