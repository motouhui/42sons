package com.sina.microblog.data
{

	/**
	 * MicroBlogUser是一个数据封装类(Value Object)，该类代表一个微博用户
	 */ 
	public class MicroBlogUser
	{
		/**
		 * 用户ID
		 */ 
		public var id:String;
		
		/**
		 * 微博昵称
		 */  
		public var screenName:String;
		
		/**
		 * 友好显示名称
		 */ 
		public var name:String;
		/**
		 * 省份ID
		 */ 
		public var province:uint;
		/**
		 * 城市ID
		 */ 
		public var city:uint;
		
		/**
		 * 用户所在地
		 */ 
		public var location:String;
		/**
		 * 用户描述
		 */ 
		public var description:String;
		
		/**
		 * 用户博客地址
		 */ 
		public var url:String;
		
		/**
		 * 头像图片地址
		 */ 
		public var profileImageUrl:String;
		
		/**
		 * 用户个性化域名 
		 */
		public var domain:String;
		
		/**
		 * 性别
		 */ 
		public var gender:String;
		
		/**
		 * 粉丝数量
		 */ 
		public var followersCount:uint;
		
		/**
		 * 关注（好友）数量
		 */ 
		public var friendsCount:uint;
		/**
		 * 已发表微博数量
		 */ 
		public var statusesCount:uint;
		/**
		 * 已收藏微博数量
		 */ 
		public var favouritesCount:uint;
		/**
		 * 用户注册日期
		 */ 
		public var createdAt:Date;
		
		/**
		 * 该用户是否follow当前用户
		 */ 
		public var following:Boolean;
		
		/**
		 * 是否允许任何人给我发私信
		 */
		public var allowAllActMsg:Boolean;
		
		/**
		 * 是否允许带有地理信息
		 */ 
		public var geoEnabled:Boolean;
		
		/**
		 * 是否为认证用户
		 */ 
		public var verified:Boolean;
		
		
		/**
		 * 是否允许所有人对我的微博进行评论
		 */
		public var allowAllComment:Boolean;
		
		/**
		 * 用户大头像地址
		 */
		public var avatarLarge:String;
		
		/**
		 * 认证原因
		 */
		public var verifiedReason:String;
		
		/**
		 * 该用户是否关注当前登录用户
		 */
		public var followMe:Boolean;
		
		/**
		 * 用户的在线状态，0：不在线、1：在线
		 */
		public var onlineStatus:uint;
		
		/**
		 * 用户的互粉数
		 */
		public var biFollowersCount:uint;
		
		/**
		 * 用户当前的状态 （最近一条微博）
		 */ 
		public var status:MicroBlogStatus;
		
		/**
		 * @private
		 */ 
		public function MicroBlogUser(user:Object)
		{
			if(user.id) this.id = user["id"];
			this.screenName = user["screen_name"];
			this.name = user["name"];
			this.province = uint(user["province"]);
			this.city = uint(user["city"]);
			this.location = user["location"];
			this.description = user["description"];
			this.url = user["url"];
			this.profileImageUrl = user["profile_image_url"];
			this.domain = user["domain"];
			this.gender = user["gender"];
			this.followersCount = uint(user["followers_count"]);
			this.friendsCount = uint(user["friends_count"]);
			this.statusesCount = uint(user["statuses_count"]);
			this.favouritesCount = uint(user["favourites_count"]);
			this.createdAt = MicroBlogDataUtil.resolveDate(user["created_at"]);
			this.following = user["following"];
			this.allowAllActMsg = user["allow_all_act_msg"];
			this.geoEnabled = user["geo_enabled"];
			this.verified = user["verified"];
			this.allowAllComment = user["allow_all_comment"];
			this.avatarLarge = user["avatar_large"];
			this.verifiedReason = user["verified_reason"];
			this.followMe = user["follow_me"];
			this.onlineStatus = uint(user["online_status"]);
			this.biFollowersCount = uint(user["bi_followers_count"]);			
			
			if(user["status"] != null)
			{
				if ( user["status"]["text"] != "")status = new MicroBlogStatus(user.status[0]);
			}
		}
		
	}
}