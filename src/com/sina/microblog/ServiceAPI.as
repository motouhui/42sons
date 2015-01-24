package com.sina.microblog
{
	public class ServiceAPI
	{
		/////////////////////////////////////////////////////////////
		//////// 微博 —— 读取接口
		/////////////////////////////////////////////////////////////
		public static const PUBLIC_TIMELINE:String = "statuses/public_timeline";
		public static const FRIENDS_TIMELINE:String = "statuses/friends_timeline";
		public static const FRIENDS_TIMELINE_IDS:String = "statuses/friends_timeline/ids";
		public static const HOME_TIMELINE:String = "statuses/home_timeline";		
		public static const USER_TIMELINE:String = "statuses/user_timeline";		
		public static const USER_TIMELINE_IDS:String = "statuses/user_timeline/ids";		
		public static const REPOST_TIMELINE:String = "statuses/repost_timeline";		
		public static const REPOST_TIMELINE_IDS:String = "statuses/repost_timeline/ids";		
		public static const REPOST_BY_ME:String = "statuses/repost_by_me";
		public static const MENTIONS:String = "statuses/mentions";
		public static const MENTIONS_IDS:String = "statuses/mentions/ids";		
		public static const BILATERAL_TIMELINE:String = "statuses/bilateral_timeline";		
		public static const STATUSES_SHOW:String = "statuses/show";		
		public static const QUERYMID:String = "statuses/querymid";
		public static const QUERYID:String = "statuses/queryid";		
		public static const REPOST_DAILY:String = "statuses/hot/repost_daily";		
		public static const REPOST_WEEKLY:String = "statuses/hot/repost_weekly";		
		public static const COMMENTS_DAILY:String = "statuses/hot/comments_daily";		
		public static const COMMENTS_WEEKLY:String = "statuses/hot/comments_weekly";
		public static const COUNT:String = "statuses/count";
		
		/////////////////////////////////////////////////////////////
		//////// 微博 —— 写入接口
		/////////////////////////////////////////////////////////////
		public static const REPOST:String = "statuses/repost";		
		public static const DESTROY:String = "statuses/destroy";		
		public static const UPDATE:String = "statuses/update";		
		public static const UPLOAD:String = "statuses/upload";		
		public static const UPLOAD_URL_TEXT:String = "statuses/upload_url_text";
		public static const EMOTIONS:String = "emotions";
		
		/////////////////////////////////////////////////////////////
		//////// 评论 —— 读取接口
		/////////////////////////////////////////////////////////////
		public static const COMMENTS_SHOW:String = "comments/show";		
		public static const COMMENTS_BY_ME:String = "comments/by_me";		
		public static const COMMENTS_TO_ME:String = "comments/to_me";		
		public static const COMMENTS_TIMELINE:String = "comments/timeline";		
		public static const COMMENTS_MENTIONS:String = "comments/mentions";
		public static const COMMENTS_SHOW_BATCH:String = "comments/show_batch";
		
		
		
		
		public static const GET_UID:String = "account/get_uid";
		
		public function ServiceAPI()
		{
			
		}
	}
}