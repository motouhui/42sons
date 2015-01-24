package com.sina.microblog
{
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.sina.microblog.events.WeiboServiceEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class WeiboService extends EventDispatcher
	{
		//更换成你的app key
		private var _appKey:String;
		//更换成你的app secrect
		private var _appSecrect:String;
		//更换成你自己的部署的代理接口地址
		private var _proxyURI:String;
		
		private var _mb:MicroBlog;
		
		/**
		 * 确认是否自动保存token到本地ShareObject 
		 */		
		private var _save_token:Boolean = false;
		
		private var _hasLogin:Boolean = false;
		
		/**
		 * 接口调用队列
		 * PS:
		 * 1、weibo flash sdk原生不支持同时多次调用同一个接口 
		 * 2、虽然weibo service对此功能进行支持，但是请注意开放平台的调用请求限制
		 * 详见：http://open.weibo.com
		 */		
		private var _apiCallSequence:Dictionary = new Dictionary();
		
		
		/**
		 * 对于OAuth2版本的Weibo Flash sdk二次封装。
		 * 使用weibo flash sdk的通用接口将所有开放平台的接口进行强类型封装，包括事件及返回
		 * 
		 * @param appKey
		 * @param appSecrect
		 * @param proxyURI
		 * 
		 */		
		public function WeiboService(appKey:String, appSecrect:String, proxyURI:String = "")
		{
			_mb = new MicroBlog();
			_mb.consumerKey = appKey;
			_mb.consumerSecret = appSecrect;
			_mb.proxyURI = proxyURI;
		}
		
		/**
		 * 
		 * @param user
		 * @param pass
		 * @param save_token		是否自动保存token到本地ShareObject
		 */		
		public function login(user:String = null, pass:String = null):void
		{
//			_save_token = save_token;
			_mb.login(user, pass);
			_mb.addEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
		}
		
		private function onLoginResult(e:Event):void
		{			
			_hasLogin = true;
			_mb.removeEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
			dispatchEvent(e.clone());
		}
		
		/////////////////////////////////////////////////////////////
		//////// 微博 —— 读取接口
		/////////////////////////////////////////////////////////////
		
		/**
		 * 获取最新的公共微博  
		 * 可匿名调用，无需授权登陆
		 * @param count			单页返回的记录条数，默认为50
		 * @param page			返回结果的页码，默认为1。
		 * @param base_app		是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
		 * 
		 */		
		public function publicTimeline(count:int = 50, page:int = 1, base_app:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.PUBLIC_TIMELINE,
				params : {count: count, page: page, base_app:base_app}, 
				method : "GET",
				rE : WeiboServiceEvent.PUBLIC_TIMELINE_RESULT,
				eE : WeiboServiceEvent.PUBLIC_TIMELINE_ERROR
			};
			addToAPICallingSequence(obj, true);
		}
		
		public function homeTimeline(since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, base_app:int = 0, feature:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.HOME_TIMELINE,
					params : {since_id: since_id, max_id: max_id, count: count, page: page, base_app:base_app, feature: feature}, 
					method : "GET",
					rE : WeiboServiceEvent.HOME_TIMELINE_RESULT,
					eE : WeiboServiceEvent.HOME_TIMELINE_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		public function friendsTimeline(since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, base_app:int = 0, feature:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.FRIENDS_TIMELINE,
					params : {since_id: since_id, max_id: max_id, count: count, page: page, base_app:base_app, feature: feature}, 
					method : "GET",
					rE : WeiboServiceEvent.FRIENDS_TIMELINE_RESULT,
					eE : WeiboServiceEvent.FRIENDS_TIMELINE_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		public function friendsTimelineIds(since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, base_app:int = 0, feature:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.FRIENDS_TIMELINE_IDS,
					params : {since_id: since_id, max_id: max_id, count: count, page: page, base_app:base_app, feature: feature}, 
					method : "GET",
					rE : WeiboServiceEvent.FRIENDS_TIMELINE_IDS_RESULT,
					eE : WeiboServiceEvent.FRIENDS_TIMELINE_IDS_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		public function userTimeline(uid:String = null, screen_name:String = null, since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, base_app:int = 0, feature:int = 0, trim_user:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.USER_TIMELINE,
					params : {since_id: since_id, max_id: max_id, count: count, page: page, base_app:base_app, feature: feature, trim_user: trim_user}, 
					method : "GET",
					rE : WeiboServiceEvent.USER_TIMELINE_RESULT,
					eE : WeiboServiceEvent.USER_TIMELINE_ERROR
			};
			if(uid != null && uid != "") obj.params.uid = uid;
			else if(screen_name != null && screen_name != "") obj.params.screen_name = screen_name;
			addToAPICallingSequence(obj);
		}
		
		public function userTimelineIds(uid:String = null, screen_name:String = null, since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, base_app:int = 0, feature:int = 0, trim_user:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.USER_TIMELINE_IDS,
					params : {since_id: since_id, max_id: max_id, count: count, page: page, base_app:base_app, feature: feature, trim_user: trim_user}, 
					method : "GET",
					rE : WeiboServiceEvent.USER_TIMELINE_IDS_RESULT,
					eE : WeiboServiceEvent.USER_TIMELINE_IDS_ERROR
			};
			if(uid != null && uid != "") obj.params.uid = uid;
			else if(screen_name != null && screen_name != "") obj.params.screen_name = screen_name;
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 
		 * @param id					需要查询的微博ID。
		 * @param since_id			若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
		 * @param max_id				若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
		 * @param count				单页返回的记录条数，默认为50。
		 * @param page				返回结果的页码，默认为1。
		 * @param filter_by_author	作者筛选类型，0：全部、1：我关注的人、2：陌生人，默认为0。
		 * 
		 */		
		public function repostTimeline(id:String, since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, filter_by_author:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.REPOST_TIMELINE,
					params : {id: id, since_id: since_id, max_id: max_id, count: count, page: page, filter_by_author: filter_by_author}, 
					method : "GET",
					rE : WeiboServiceEvent.REPOST_TIMELINE_RESULT,
					eE : WeiboServiceEvent.REPOST_TIMELINE_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		public function repostTimelineIds(id:String, since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, filter_by_author:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.REPOST_TIMELINE_IDS,
					params : {id: id, since_id: since_id, max_id: max_id, count: count, page: page, filter_by_author: filter_by_author}, 
					method : "GET",
					rE : WeiboServiceEvent.REPOST_TIMELINE_IDS_RESULT,
					eE : WeiboServiceEvent.REPOST_TIMELINE_IDS_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 获取当前用户最新转发的微博列表 
		 * @param since_id	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
		 * @param max_id		若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
		 * @param count		单页返回的记录条数，默认为50。
		 * @param page		返回结果的页码，默认为1。
		 * 
		 */		
		public function repostByMe(since_id:String = "0", max_id:String = "0", count:int = 50, page:int = 1):void
		{
			var obj:Object = {
				uri : ServiceAPI.REPOST_BY_ME,
					params : {since_id: since_id, max_id: max_id, count: count, page: page}, 
					method : "GET",
					rE : WeiboServiceEvent.REPOST_BY_ME_RESULT,
					eE : WeiboServiceEvent.REPOST_BY_ME_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 *  
		 * @param since_id
		 * @param max_id
		 * @param count
		 * @param page
		 * @param filter_by_author
		 * @param filter_by_source
		 * @param filter_by_type
		 * 
		 */		
		public function mentions(since_id:String = "0", max_id:String = "0", count:int = 50, page:int = 1, filter_by_author:int = 0, filter_by_source:int = 0, filter_by_type:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.MENTIONS,
					params : {since_id: since_id, max_id: max_id, count: count, page: page, filter_by_author: filter_by_author, filter_by_source: filter_by_source, filter_by_type: filter_by_type}, 
					method : "GET",
					rE : WeiboServiceEvent.MENTIONS_RESULT,
					eE : WeiboServiceEvent.MENTIONS_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		public function mentionsIds(since_id:String = "0", max_id:String = "0", count:int = 50, page:int = 1, filter_by_author:int = 0, filter_by_source:int = 0, filter_by_type:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.MENTIONS_IDS,
					params : {since_id: since_id, max_id: max_id, count: count, page: page, filter_by_author: filter_by_author, filter_by_source: filter_by_source, filter_by_type: filter_by_type}, 
					method : "GET",
					rE : WeiboServiceEvent.MENTIONS_IDS_RESULT,
					eE : WeiboServiceEvent.MENTIONS_IDS_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 获取双向关注用户的最新微博 
		 * @param since_id
		 * @param max_id
		 * @param count
		 * @param page
		 * @param base_app
		 * @param feature
		 * 
		 */		
		public function bilateralTimeline(since_id:String = "0", max_id:String = "0", count:int = 50, page:int = 1, base_app:int = 0, feature:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.BILATERAL_TIMELINE,
					params : {since_id: since_id, max_id: max_id, count: count, page: page, filter_by_author: base_app, feature: feature}, 
					method : "GET",
					rE : WeiboServiceEvent.BILATERAL_TIMELINE_RESULT,
					eE : WeiboServiceEvent.BILATERAL_TIMELINE_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 根据微博ID获取单条微博内容
		 * @param id
		 * 
		 */		
		public function statusShow(id:String):void
		{
			var obj:Object = {
				uri : ServiceAPI.STATUSES_SHOW,
					params : {id: id}, 
					method : "GET",
					rE : WeiboServiceEvent.STATUSES_SHOW_RESULT,
					eE : WeiboServiceEvent.STATUSES_SHOW_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 通过微博（评论、私信）ID获取其MID
		 * @param id			需要查询的微博（评论、私信）ID，批量模式下，用半角逗号分隔，最多不超过20个。
		 * @param type		获取类型，1：微博、2：评论、3：私信，默认为1。
		 * @param is_batch	是否使用批量模式，0：否、1：是，默认为0。
		 * 
		 */		
		public function querymid(id:String, type:int = 1, is_batch:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.QUERYMID,
					params : {id: id, type:type, is_batch: is_batch}, 
					method : "GET",
					rE : WeiboServiceEvent.QUERYMID_RESULT,
					eE : WeiboServiceEvent.QUERYMID_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 通过微博（评论、私信）MID获取其ID
		 * @param mid		需要查询的微博（评论、私信）MID，批量模式下，用半角逗号分隔，最多不超过20个。
		 * @param type		获取类型，1：微博、2：评论、3：私信，默认为1。
		 * @param is_batch	是否使用批量模式，0：否、1：是，默认为0。
		 * @param inbox		仅对私信有效，当MID类型为私信时用此参数，0：发件箱、1：收件箱，默认为0 。
		 * @param isBase62	MID是否是base62编码，0：否、1：是，默认为0。
		 * 
		 */		
		public function queryid(mid:String, type:int = 1, is_batch:int = 0, inbox:int = 0, isBase62:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.QUERYID,
					params : {mid: mid, type:type, is_batch: is_batch, inbox: inbox, isBase62: isBase62}, 
					method : "GET",
					rE : WeiboServiceEvent.QUERYID_RESULT,
					eE : WeiboServiceEvent.QUERYID_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 按天返回热门微博转发榜的微博列表 
		 * @param count
		 * @param base_app
		 * 
		 */		
		public function repostDaily(count:int = 20, base_app:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.REPOST_DAILY,
					params : {count: count, base_app: base_app}, 
					method : "GET",
					rE : WeiboServiceEvent.REPOST_DAILY_RESULT,
					eE : WeiboServiceEvent.REPOST_DAILY_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 按周返回热门微博转发榜的微博列表 
		 * @param count
		 * @param base_app
		 * 
		 */		
		public function repostWeekly(count:int = 20, base_app:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.REPOST_WEEKLY,
					params : {count: count, base_app: base_app}, 
					method : "GET",
					rE : WeiboServiceEvent.REPOST_WEEKLY_RESULT,
					eE : WeiboServiceEvent.REPOST_WEEKLY_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 按天返回热门微博评论榜的微博列表
		 * @param count
		 * @param base_app
		 * 
		 */		
		public function commentsDaily(count:int = 20, base_app:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.COMMENTS_DAILY,
					params : {count: count, base_app: base_app}, 
					method : "GET",
					rE : WeiboServiceEvent.COMMENTS_DAILY_RESULT,
					eE : WeiboServiceEvent.COMMENTS_DAILY_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		public function commentsWeekly(count:int = 20, base_app:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.COMMENTS_WEEKLY,
					params : {count: count, base_app: base_app}, 
					method : "GET",
					rE : WeiboServiceEvent.COMMENTS_WEEKLY_RESULT,
					eE : WeiboServiceEvent.COMMENTS_WEEKLY_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 批量获取指定微博的转发数评论数
		 * @param ids	需要获取数据的微博ID，多个之间用逗号分隔，最多不超过100个。
		 * 
		 */		
		public function count(ids:String):void
		{
			var obj:Object = {
				uri : ServiceAPI.COUNT,
					params : {ids: ids}, 
					method : "GET",
					rE : WeiboServiceEvent.COUNT_RESULT,
					eE : WeiboServiceEvent.COUNT_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/////////////////////////////////////////////////////////////
		//////// 微博 —— 写入接口
		/////////////////////////////////////////////////////////////	
		/**
		 * 转发一条微博
		 * @param id
		 * @param status
		 * @param is_comment
		 * 
		 */		
		public function repost(id:String, status:String = null, is_comment:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.REPOST,
					params : {id: id, is_comment: is_comment}, 
					method : "POST",
					rE : WeiboServiceEvent.REPOST_RESULT,
					eE : WeiboServiceEvent.REPOST_ERROR
			};
			if(status != null) obj.params.status = status;
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 根据微博ID删除指定微博 
		 * @param id
		 * 
		 */		
		public function destroy(id:String):void
		{
			var obj:Object = {
				uri : ServiceAPI.DESTROY,
					params : {id: id}, 
					method : "POST",
					rE : WeiboServiceEvent.DESTROY_RESULT,
					eE : WeiboServiceEvent.DESTROY_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 发布一条新微博
		 * @param status			要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
		 * @param lat			纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
		 * @param long			经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
		 * @param annotations	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
		 * 
		 */		
		public function update(status:String, lat:String = "0.0", long:String = "0.0", annotations:String = ""):void
		{
			var obj:Object = {
				uri : ServiceAPI.UPDATE,
					params : {status: status, lat: lat, long: long, annotations: annotations}, 
					method : "POST",
					rE : WeiboServiceEvent.UPDATE_RESULT,
					eE : WeiboServiceEvent.UPDATE_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 上传图片并发布一条新微博
		 * @param status			要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
		 * @param pic			要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
		 * @param lat			纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
		 * @param long			经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
		 * @param annotations	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
		 * 
		 */		
		public function upload(status:String, pic:ByteArray, lat:String = "0.0", long:String = "0.0", annotations:String = ""):void
		{
			var obj:Object = {
				uri : ServiceAPI.UPLOAD,
					params : {status: status, pic: pic, lat: lat, long: long, annotations: annotations}, 
					method : "POST",
					rE : WeiboServiceEvent.UPLOAD_RESULT,
					eE : WeiboServiceEvent.UPLOAD_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * <b>高级接口（需要授权）</b>
		 * 指定一个图片URL地址抓取后上传并同时发布一条新微博 
		 * @param status
		 * @param url
		 * @param lat
		 * @param long
		 * @param annotations
		 * 
		 */		
		public function uploadUrlText(status:String, url:String, lat:String = "0.0", long:String = "0.0", annotations:String = ""):void
		{
			var obj:Object = {
				uri : ServiceAPI.UPLOAD_URL_TEXT,
					params : {status: status, url: url, lat: lat, long: long, annotations: annotations}, 
					method : "POST",
					rE : WeiboServiceEvent.UPLOAD_URL_TEXT_RESULT,
					eE : WeiboServiceEvent.UPLOAD_URL_TEXT_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		/**
		 * 获取微博官方表情的详细信息
		 * @param type		表情类别，face：普通表情、ani：魔法表情、cartoon：动漫表情，默认为face。
		 * @param language	语言类别，cnname：简体、twname：繁体，默认为cnname。
		 * 
		 */		
		public function emotions(type:String = "face", language:String = "cnname"):void
		{
			var obj:Object = {
				uri : ServiceAPI.EMOTIONS,
					params : {type: type, language: language}, 
					method : "GET",
					rE : WeiboServiceEvent.EMOTIONS_RESULT,
					eE : WeiboServiceEvent.EMOTIONS_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		
		/////////////////////////////////////////////////////////////
		//////// 评论 —— 读取接口
		/////////////////////////////////////////////////////////////		
		public function commentsShow(id:String, since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, filter_by_author:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.COMMENTS_SHOW,
					params : {id: id, since_id: since_id, max_id: max_id, count: count, page: page, filter_by_author: filter_by_author}, 
					method : "GET",
					rE : WeiboServiceEvent.COMMENTS_SHOW_RESULT,
					eE : WeiboServiceEvent.COMMENTS_SHOW_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		public function commentsByMe(id:String, since_id:int = 0, max_id:int = 0, count:int = 50, page:int = 1, filter_by_author:int = 0):void
		{
			var obj:Object = {
				uri : ServiceAPI.COMMENTS_BY_ME,
					params : {id: id, since_id: since_id, max_id: max_id, count: count, page: page, filter_by_author: filter_by_author}, 
					method : "GET",
					rE : WeiboServiceEvent.COMMENTS_BY_ME_RESULT,
					eE : WeiboServiceEvent.COMMENTS_BY_ME_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		
		
		/**
		 * 调用接口API_GET_UID，即：account/get_uid
		 * 成功事件类型：ServiceEvent.GET_UID_RESULT
		 * 失败时间类型：ServiceEvent.GET_UID_ERROR
		 */		
		public function getUID():void
		{
			var obj:Object = {
				uri : ServiceAPI.GET_UID,
					params : null, 
					method : "GET",
					rE : WeiboServiceEvent.GET_UID_RESULT,
					eE : WeiboServiceEvent.GET_UID_ERROR
			};
			addToAPICallingSequence(obj);
		}
		
		
		
		/**
		 * 添加到调用api队列 
		 * @param obj			api调用参数
		 * @param anonymousAPI	是否为匿名api
		 * 
		 */		
		public function addToAPICallingSequence(obj:Object, anonymousAPI:Boolean = false):void
		{
			if(!_hasLogin && !anonymousAPI)
			{
				throw new ErrorEvent(ErrorEvent.ERROR, false, false, "请先授权登陆");
				return;
			}
			
			if(_apiCallSequence[obj.rE] == null)
			{
				_apiCallSequence[obj.rE] = [];
				_apiCallSequence[obj.eE] = [];
			}
			_apiCallSequence[obj.rE].push(obj);
			_apiCallSequence[obj.eE].push(obj);
			
			if(_apiCallSequence[obj.rE].length == 1)
			{
				_mb.callWeiboAPI(obj.uri, obj.params, obj.method, obj.rE, obj.eE);
				_mb.addEventListener(obj.rE,  onApiCallResult);
				_mb.addEventListener(obj.eE, onApiCallError);
			}				
		}
		
		private function onApiCallError(e:MicroBlogErrorEvent):void
		{
			dispatchEvent(e.clone());
			checkSequence(e.type);
		}
		
		private function onApiCallResult(e:MicroBlogEvent):void
		{
			dispatchEvent(e.clone());
			checkSequence(e.type);
		}
		
		private function checkSequence(key:String):void
		{
			var obj:Object = _apiCallSequence[key][0];
			_apiCallSequence[obj.rE].shift();
			_apiCallSequence[obj.eE].shift();
			
			if(_apiCallSequence[obj.rE].length >= 1)		
			{
				_mb.callWeiboAPI(obj.uri, obj.params, obj.method, obj.rE, obj.eE);
			}else{
				_mb.removeEventListener(obj.rE,  onApiCallResult);
				_mb.removeEventListener(obj.eE, onApiCallError);
			}
		}

		/**
		 * 确认是否已经登陆成功 
		 */
		public function get hasLogin():Boolean
		{
			return _hasLogin;
		}
		
	}
	
}