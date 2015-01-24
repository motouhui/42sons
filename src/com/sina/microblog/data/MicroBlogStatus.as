package com.sina.microblog.data
{
	/**
	 * MicroBlogStatus是一个数据封装类(Value Object)，该类代表一条微博
	 */ 
	public class MicroBlogStatus
	{
		/**
		 * 当该条微博作为对其他微博的转发时，该属性指向其转发的微博对象
		 */ 
		public var repost:MicroBlogStatus;
		
		/**
		 * 字符串型的微博ID
		 */ 
		public var idstr:String;
		
		/**
		 * 微博的创建时间
		 */ 
		public var createdAt:Date;
		/**
		 * 微博的ID
		 */ 
		public var id:String;
		/**
		 * 微博的内容
		 */ 
		public var text:String;
		/**
		 * 微博的来源
		 */ 
		public var source:String;
		/**
		 * 标识该条微博是否被收藏
		 */ 
		public var isFavorited:Boolean;
		/**
		 * 标识该条微博是否被截断
		 */ 
		public var isTruncated:Boolean;
		
		/**
		 * 回复ID
		 */ 
		public var inReplyToStatusID:String;
		
		/**
		 * 回复人UID
		 */ 
		public var inReplyToUserID:String;
		/**
		 * 回复人昵称
		 */ 
		public var inReplyToScreenName:String;
		
		/**
		 * 微博MID
		 */ 
		public var mid:String;
		
		/**
		 * 微博附带图片的缩略版本的URL
		 */ 
		public var thumbPicUrl:String;
		/**
		 * 微博附带图片的中等尺寸版本的URL
		 */ 
		public var bmiddlePicUrl:String;
		/**
		 * 微博附带图片的原始尺寸版本的URL
		 */ 
		public var originalPicUrl:String;
		
		/**
		 * 转发数
		 */
		public var repostsCount:uint;
		
		/**
		 * 评论数
		 */
		public var commentsCount:uint;
		
		/**
		 * 微博附加注释信息
		 */
		public var annotations:Array;
		
		/**
		 * 地理信息字段
		 */
		public var geo:Object;
		
		
		/**
		 * 发出该条微博的用户对象
		 */ 
		public var user:MicroBlogUser;

		/**
		 * @private
		 */ 
		public function MicroBlogStatus(status:Object)
		{
			this.idstr = status["idstr"];
			this.createdAt = MicroBlogDataUtil.resolveDate(status["created_at"]);
			this.id = status["id"];
			this.text = status["text"];
			this.source = status["source"];
			this.isFavorited = status["favorited"];
			this.isTruncated = status["truncated"];
			this.inReplyToStatusID = status["in_reply_to_status_id"];
			this.inReplyToUserID = status["in_reply_to_user_id"];
			this.inReplyToScreenName = status["in_reply_to_screen_name"];
			this.mid = status["mid"];
			this.bmiddlePicUrl = status["bmiddle_pic"];
			this.originalPicUrl = status["original_pic"];
			this.thumbPicUrl = status["thumbnail_pic"];
			this.repostsCount = uint(status["reposts_count"]);
			this.commentsCount = uint(status["comments_count"]);
			this.annotations = status["annotations"] as Array;
			this.geo = status["geo"] as Object;
			this.user = new MicroBlogUser(status["user"]);
			if(status["retweeted_status"] != null)
			{
				this.repost = new MicroBlogStatus(status["retweeted_status"]);
			}
		}
	}
}