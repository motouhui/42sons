package com.sina.microblog
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.sina.microblog.utils.StringEncoders;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class MicroBlog extends EventDispatcher
	{
		private static const MULTIPART_FORMDATA:String="multipart/form-data; boundary=";
		private static const CONTENT_DISPOSITION_BASIC:String='Content-Disposition: form-data; name="$name"';
		private static const CONTENT_TYPE_JPEG:String="Content-Type: image/pjpeg";
		private static const CONTENT_TRANSFER_ENCODING:String="Content-Transfer-Encoding: binary";	
		
		private var _consumerKey:String = "";
		private var _consumerSecret:String = "";
		private var _access_token:String = "";
		private var _expires_in:String = "";
		private var _refresh_token:String = "";
		private var _source:String = "";
		private var _pin:String="";
		private var _verifier:String = "";
		private var _xauthUser:String = "";
		private var _xauthPass:String = "";
		
		private var xauthLoader:URLLoader;
		
		///登录的时候临时建立的频道
		private var _localConnectionChanel:String;
		///获取anywheretoken值的连接
		private var _conn:LocalConnection;
		
		private var serviceLoader:Dictionary = new Dictionary();
		private var loaderMap:Dictionary = new Dictionary();
		
		private var _proxyURI:String;
		private var _isSecureDomain:Boolean = true;
		
		/**
		 * 测试数据
		 * @private
		 */
		public var _testData:String;
		
		private var _jsonFunName:String = "decode";
		
		public function MicroBlog()
		{
			
		}
		
		///////////////////////////////////
		// Event Handler
		///////////////////////////////////
		/**
		 * 客户端登陆成功的事件 
		 * @param e
		 * 
		 */		
		private function xauthLoader_onComplete(e:Event):void
		{
			var result:String = xauthLoader.data as String;
			if (result.length > 0)
			{
				_xauthPass = _xauthUser = "";
				
//				var resultObj:Object = JSON.decode(result); //为了避开Fp11和之前的冲突		
				var decoder:JSONDecoder = new JSONDecoder( result )
				var resultObj:Object = decoder.getValue();
				
				this.access_token = resultObj["access_token"];
				this.expires_in = resultObj["expires_in"];
				this.refresh_token = resultObj["refresh_token"];	
				//trace(access_token + "::" + expires_in + "::" + refresh_token);			
				var loginEvt:MicroBlogEvent = new MicroBlogEvent(MicroBlogEvent.LOGIN_RESULT);
				loginEvt.result = {"access_token": this.access_token, "expires_in": this.expires_in, "refresh_token": this.refresh_token};
				dispatchEvent(loginEvt);
			}
		}
		
		private function loader_onComplete(event:Event):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var processor:Object=loaderMap[loader];
			var dataStr:String = loader.data as String;
			
			if ( dataStr.length  <= 0 )
			{
				var ioError:MicroBlogErrorEvent = new MicroBlogErrorEvent(MicroBlogErrorEvent.NET_WORK_ERROR);
				ioError.message = "The network error";
				dispatchEvent(ioError);
				return;
			}
			
			_testData = dataStr;
			
//			trace("========================================" + processor.resultEvent);
//			trace(_testData);
//			trace("========================================");
			
			var decoder:JSONDecoder = new JSONDecoder( dataStr );//为了避开Fp11和之前的冲突
			var result:Object = decoder.getValue();
			
			if (result["error"]  != null)
			{
				var error:MicroBlogErrorEvent = new MicroBlogErrorEvent(processor.errorEvent);
				error.message = "Error " + result.error_code + " : " + result.error + ",description:" + result.error_description;
				error.code = result.error_code;
				dispatchEvent(error);
			}else{
				var e:MicroBlogEvent = new MicroBlogEvent(processor.resultEvent);
				e.result = processor.dataFunc(result);
				e.nextCursor=Number(result.next_cursor);
				e.previousCursor=Number(result.previous_cursor);
				dispatchEvent(e);
			}
		}
		
		private function loader_onError(event:IOErrorEvent):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var processor:Object=loaderMap[loader];
			var error:MicroBlogErrorEvent=new MicroBlogErrorEvent(processor.errorEvent);
			error.message=event.text;
			dispatchEvent(error);
		}
		
		private function loader_onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		private function xauthLoader_onError(evt:IOErrorEvent):void 
		{
			var e:MicroBlogErrorEvent = new MicroBlogErrorEvent(MicroBlogErrorEvent.LOGIN_ERROR);
			e.message = xauthLoader.data;
			dispatchEvent(e);
		}
		
		/**
		 * 使用localConnection从登陆组件传入token相关信息 
		 * @param access_token
		 * @param expires_in
		 * @param refresh_token
		 */		
		public function loginResult(access_token:String, expires_in:String, refresh_token:String):void
		{			
			//trace(access_token + "::" + expires_in + "::" + refresh_token);	
			_access_token = access_token;
			_expires_in = expires_in;
			_refresh_token = refresh_token;
			
			var loginEvt:MicroBlogEvent = new MicroBlogEvent(MicroBlogEvent.LOGIN_RESULT);
			loginEvt.result = {"access_token": this.access_token, "expires_in": this.expires_in, "refresh_token": this.refresh_token};
			dispatchEvent(loginEvt);
		}
		
		///////////////////////////////////
		// Weibo API
		///////////////////////////////////
		/**
		 *  
		 * @param userName
		 * @param password
		 * @param useStandardOAuth
		 * 
		 */		
		public function login(userName:String=null, password:String=null):void
		{		
			_xauthUser = _xauthPass = "";
			if (userName != null && password != null) 
			{
				_xauthUser = userName;
				_xauthPass = password;
				if (null == xauthLoader)
				{
					xauthLoader = new URLLoader();
					xauthLoader.addEventListener(Event.COMPLETE, xauthLoader_onComplete, false, 0, true);
					xauthLoader.addEventListener(IOErrorEvent.IO_ERROR, xauthLoader_onError, false, 0, true);
					xauthLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError, false, 0, true);
				}		
				var xval:URLVariables = new URLVariables();
				xval.client_id = _consumerKey;
				xval.client_secret = _consumerSecret;
				xval.grant_type = "password";
				xval.username = _xauthUser;
				xval.password = _xauthPass;			
				var xurl:String = API.OAUTH_ACCESS_TOKEN_REQUEST_URL;
				var xreq:URLRequest = new URLRequest(xurl);
				xreq.method = URLRequestMethod.POST;
				xreq.data = xval;
				xauthLoader.load(xreq);
				return;
			}else{
				_localConnectionChanel = _source + Math.round(Math.random() * 1000000);	
				_conn = new LocalConnection();
				_conn.client = this;
				_conn.connect("_" + String(_localConnectionChanel));
				_conn.allowDomain("*");
				var url:String = API.OAUTH_AUTHORIZE_REQUEST_URL + "?client_id=" + _source;
				//url += "&redirect_uri=" + API.CONNECT_COMP;
				url += "&state=" + _localConnectionChanel; //登陆的频道会通过这个state传回callback.htm页面中。并使用localconnection去连接
				url += "&display=flash";	
				url += "&response_type=token";
				
				if (ExternalInterface.available && (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn"))
				{
					try {
						ExternalInterface.call("window.open", url,'newwindow','height=450,width=600,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no, z-look=yes, alwaysRaised=yes');
					}catch (err:Error) {
						navigateToURL(new URLRequest(url), "_blank");
					}
				}else {
					navigateToURL(new URLRequest(url), "_blank");
				}
			}
		}
		
		/**
		 * 发布一条新微博 
		 * @param status		要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
		 * @param pic			要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
		 * @param picName		文件名称，带文件后缀 
		 * @param pic_url		图片的URL地址，必须以http开头。 
		 * @param lat			纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
		 * @param long			经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。 
		 * @param annotations	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
		 */		
		public function updateStatus(status:String, pic:ByteArray=null, picName:String = "", pic_url:String = "", lat:Number = NaN, long:Number = NaN, annotations:String = ""):void
		{
			var req:URLRequest;
			var params:Object = {};
			if ( status ) params.status = status;			
			if (!isNaN(lat)) params.lat = lat;
			if (!isNaN(long)) params.long = long;
			if (annotations != "") params.annotations = annotations;
			var uri:String;
			if(pic != null){
				if(picName == "") picName = "pic.jpg";
				uri = API.STATUS_UPLOAD;
				addProcessor(uri, processGeneralApi, MicroBlogEvent.UPDATE_STATUS_RESULT, MicroBlogErrorEvent.UPDATE_STATUS_ERROR);
				if(_isSecureDomain){
					req = getMicroBlogRequest(API.API_BASE_URL + uri + ".json", params, URLRequestMethod.POST);
				}else{
					req = getMicroBlogRequest(_proxyURI + "?uri=" + uri + "&method=" + URLRequestMethod.POST, params, URLRequestMethod.POST);
				}
				var boundary:String=makeBoundary();
				req.contentType = MULTIPART_FORMDATA + boundary;		
				req.data = makeMultipartPostData(boundary, "pic", picName, pic, req.data);
			}else if(pic_url != ""){
				uri = API.STATUS_UPLOAD_URL_TEXT;
				params.url = pic_url;
				if(_isSecureDomain){
					req = getMicroBlogRequest(API.API_BASE_URL + uri + ".json", params, URLRequestMethod.POST)
				}else{
					req = getMicroBlogRequest(_proxyURI + "?uri=" + uri + "&method=" + URLRequestMethod.POST, params, URLRequestMethod.POST);
				}
				addProcessor(uri, processGeneralApi, MicroBlogEvent.UPDATE_STATUS_RESULT, MicroBlogErrorEvent.UPDATE_STATUS_ERROR);
			}else{
				uri = API.STATUS_UPDATE;
				if(_isSecureDomain){
					req = getMicroBlogRequest(API.API_BASE_URL + uri + ".json", params, URLRequestMethod.POST)
				}else{
					req = getMicroBlogRequest(_proxyURI + "?uri=" + uri + "&method=" + URLRequestMethod.POST, params, URLRequestMethod.POST);
				}
				addProcessor(uri, processGeneralApi, MicroBlogEvent.UPDATE_STATUS_RESULT, MicroBlogErrorEvent.UPDATE_STATUS_ERROR);
			}
			executeRequest(uri, req);
		}
		
		/**
		 * 更新当前登录用户的头像
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.AVATAR_UPDATE_RESULT</b><br/>
		 * </p>
		 * 
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroBlogErrorEvent.AVATAR_UPDATE_ERROR</b></p>
		 * 
		 * @param	pic	头像图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
		 */
		public function avatarUpload(pic:ByteArray):void
		{
			var req:URLRequest;
			var params:Object = { };
			var uri:String = API.ACCOUNT_AVATAR_UPLOAD;
			addProcessor(uri, processGeneralApi, MicroBlogEvent.AVATAR_UPDATE_RESULT, MicroBlogErrorEvent.AVATAR_UPDATE_ERROR);
			if(_isSecureDomain){
				req = getMicroBlogRequest(API.API_BASE_URL + uri + ".json", params, URLRequestMethod.POST);
			}else{
				req = getMicroBlogRequest(_proxyURI + "?uri=" + uri + "&file=image&method=post", params, URLRequestMethod.POST);
			}
			var boundary:String=makeBoundary();
			req.contentType = MULTIPART_FORMDATA + boundary;		
			req.data = makeMultipartPostData(boundary, "image", "avatar.jpg", pic, req.data);
			executeRequest(uri, req);
		}
		
		public function callWeiboAPI(name:String, uri:String, params:Object = null, method:String = "GET", resultEventType:String = "callWeiboApiResult", errorEventType:String = "callWeiboApiError"):void
		{
			addProcessor(name, processGeneralApi, resultEventType, errorEventType);
			if (params == null) var params:Object = { };
			var baKey:String = "";
			for(var key:* in params)
			{
				if(params[key] is ByteArray)
				{
					baKey = key;
					break;
				}
			}
			if(baKey != "")
			{
				var file:ByteArray = params[key];
				delete(params[key]);
			}
			
			var req:URLRequest;
			if(_isSecureDomain){
				req = getMicroBlogRequest(API.API_BASE_URL + uri + ".json", params, method);
			}else{
				req = getMicroBlogRequest(_proxyURI + "?uri=" + uri + "&file=" + baKey + "&method=" + method, params, URLRequestMethod.POST);
			}
			if(baKey != "")
			{
				var boundary:String=makeBoundary();
				req.contentType = MULTIPART_FORMDATA + boundary;		
				req.data = makeMultipartPostData(boundary, baKey, "demo.jpg", file, req.data);
			}		
			executeRequest(name, req);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * consumerKey是一个只写属性，用于验证客户端的合法性，
		 * 必须在调用login之前将其设置为合适值.
		 * @param value
		 * 
		 */		
		public function set consumerKey(value:String):void
		{
			_consumerKey = value;
			_source = value;
		}
		
		/**
		 * consumerSecret是一个只写属性，用于和consumerKey一起验证客户端的合法性，
		 * 必须在调用login之前将其设置为合适值.
		 * @param value
		 * 
		 */		
		public function set consumerSecret(value:String):void
		{
			_consumerSecret = value;
		}
		
		public function get access_token():String{ return _access_token; }
		public function set access_token(value:String):void
		{
			_access_token = value;
		}
		
		public function get expires_in():String{ return _expires_in; }
		public function set expires_in(value:String):void
		{
			_expires_in = value;
		}
		
		public function get refresh_token():String{ return _refresh_token; }
		public function set refresh_token(value:String):void
		{
			_refresh_token = value;
		}
		
		/**
		 * source是标识客户端来源.必须设置为新浪认证的应用程序id 
		 * @return 
		 * 
		 */		
		public function get source():String { return _source; }
		public function set source(value:String):void
		{
			_source = value;
			_consumerKey = value;
		}
		
		public function get pin():String { return _pin; }
		public function set pin(value:String):void
		{
			_pin = value;
		}
		
		/**
		 * 微博秀的特殊需求创建，用于获取用户信息的标识，使用用户帐号的创建时间编码获得 
		 * 微博特殊应用的认证标识，例如微博秀，
		 * @return 
		 * 
		 */		
		public function get verifier():String { return _verifier; }
		public function set verifier(value:String):void
		{
			_verifier = value;
		}
		
		
		public function get proxyURI():String{ return _proxyURI; }
		public function set proxyURI(value:String):void
		{
			_proxyURI = value;
			_isSecureDomain = (_proxyURI == "");
		}
		
		///////////////////////////////////
		// Data Process Function
		///////////////////////////////////		
		private function processGeneralApi(value:Object):Object
		{
			return value;
		}
		
		protected function processStatus(value:Object):MicroBlogStatus
		{
			return new MicroBlogStatus(value);
		}
		
		protected function processUser(value:Object):MicroBlogUser
		{
			return new MicroBlogUser(value);
		}
		
		
		///////////////////////////////////
		// Util Function
		///////////////////////////////////	
		protected function addProcessor(name:String, dataProcess:Function, resultEventType:String, errorEventType:String):void
		{
			if (null == serviceLoader[name])
			{
				var loader:URLLoader=new URLLoader();
				loader.addEventListener(Event.COMPLETE, loader_onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
				serviceLoader[name]=loader;
				loaderMap[loader]={dataFunc: dataProcess, resultEvent: resultEventType, errorEvent: errorEventType};
			}
		}
		
		protected function getMicroBlogRequest(url:String, params:Object = null, requestMethod:String="GET"):URLRequest
		{
			requestMethod = String(requestMethod).toUpperCase();
			var req:URLRequest;		
			if ( null == params ) params = { };		
			params.source = this._consumerKey;		
			if(access_token != "") params.access_token = access_token;
			if(requestMethod == URLRequestMethod.GET){
				url+=makeGETParamString(params);
				req = new URLRequest(url)
			}else if(requestMethod == URLRequestMethod.POST){
				req = new URLRequest(url)
				var val:URLVariables = new URLVariables();
				for (var key:* in params)
				{
					val[key] = params[key];
				}
				req.data = val;
			}	
			req.method=requestMethod;
			return req;
		}
		
		protected function executeRequest(name:String, req:URLRequest):void
		{
			var urlLoader:URLLoader = serviceLoader[name] as URLLoader;
			urlLoader.load(req);
		}
		
		protected function makeGETParamString(parameters:Object):String
		{
			var paramStr:String=makeParamsToUrlString(parameters);
			if (paramStr.length > 0) paramStr="?" + paramStr;
			return paramStr;
		}
		
		protected function makeParamsToUrlString(params:Object):String
		{
			var retParams:Array=[];			
			for (var param:String in params)
			{
				retParams.push(param + "=" + params[param].toString());
			}
			retParams.sort();
			return retParams.join("&");
		}
		
		protected function encodeMsg(status:String):String
		{
			var source:String = status;
			var pattern1:RegExp = new RegExp('^[ ]+|[ ]+$', 'g');
			source = source.replace(pattern1, '');		
			var pattern2:RegExp = new RegExp('[ \n\t\r]', 'g');
			source = source.replace(pattern2, ' ');				
			var pattern3:RegExp = /( )+/g;
			source = source.replace(pattern3, ' ');			
			return StringEncoders.urlEncodeSpecial(source);
		}
		
		protected function makeMultipartPostData(boundary:String, imgFieldName:String, filename:String, imgData:ByteArray, params:Object):Object
		{
			var req:URLRequest=new URLRequest();
			var postData:ByteArray=new ByteArray();
			postData.endian=Endian.BIG_ENDIAN;
			var value:String;
			if (params)
			{
				for (var name:String in params)
				{
					boundaryPostData(postData, boundary);
					addLineBreak(postData);
					postData.writeUTFBytes(CONTENT_DISPOSITION_BASIC.replace("$name", name));
					addLineBreak(postData);
					addLineBreak(postData);
					postData.writeUTFBytes(params[name]);
					addLineBreak(postData);
				}
			}
			
			boundaryPostData(postData, boundary);
			addLineBreak(postData);
			postData.writeUTFBytes(CONTENT_DISPOSITION_BASIC.replace("$name", imgFieldName) + '; filename="' + filename + '"');
			addLineBreak(postData);
			postData.writeUTFBytes(CONTENT_TYPE_JPEG);
			addLineBreak(postData);
			addLineBreak(postData);
			postData.writeBytes(imgData, 0, imgData.length);
			addLineBreak(postData);
			
			boundaryPostData(postData, boundary);
			addDoubleDash(postData);
			
			postData.position=0;
			return postData;
		}
		
		protected function boundaryPostData(data:ByteArray, boundary:String):void
		{
			var len:int=boundary.length;
			addDoubleDash(data);
			for (var i:int=0; i < len; ++i)
			{
				data.writeByte(boundary.charCodeAt(i));
			}
		}
		
		protected function addDoubleDash(data:ByteArray):void
		{
			data.writeShort(0x2d2d);
		}
		
		protected function addLineBreak(data:ByteArray):void
		{
			data.writeShort(0x0d0a);
		}
		
		protected function makeBoundary():String
		{
			var boundary:String="";
			for (var i:int=0; i < 13; i++)
			{
				boundary+=String.fromCharCode(int(97 + Math.random() * 25));
			}
			boundary="---------------------------" + boundary;
			return boundary;
		}		
	}
}