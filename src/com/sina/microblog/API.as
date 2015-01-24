package com.sina.microblog
{
	/**
	 * @private
	 * 所有微博开放平台api的地址配置 
	 * @author qidonghui
	 * 
	 */	
	public class API
	{	
		public static const API_BASE_URL:String = "https://api.weibo.com/";
		
		public static const CONNECT_COMP:String = API_BASE_URL + "flash/connect.htm";
		
		public static const OAUTH_AUTHORIZE_REQUEST_URL:String = API_BASE_URL + "oauth2/authorize";
		public static const OAUTH_ACCESS_TOKEN_REQUEST_URL:String=API_BASE_URL + "oauth2/access_token";
		
		public static const STATUS_UPDATE:String = "2/statuses/update";
		public static const STATUS_UPLOAD:String = "2/statuses/upload";
		public static const STATUS_UPLOAD_URL_TEXT:String = "2/statuses/upload_url_text";
		public static const ACCOUNT_AVATAR_UPLOAD:String = "2/account/avatar/upload";
		
		public function API()
		{
			
		}
	}
}