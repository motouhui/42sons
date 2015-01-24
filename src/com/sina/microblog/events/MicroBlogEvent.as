package com.sina.microblog.events
{
	import flash.events.Event;

	/**
	 * 所有对新浪微博API的请求会以事件的形式返回给调用者.当API请求正常返回时，MicroBlog类会派发MicroBlogEvent事件.
	 * 
	 * <p>每个MicroBlogEvent事件都有一个result属性用于保存响应的数据。</br>
	 * API请求与事件的对应关系请参照MicroBlog类的文档。</p>
	 * 
	 * @see com.sina.microblog.MicroBlog
	 */ 
	public class MicroBlogEvent extends Event
	{
		/**
		 * 登陆成功后发出的事件,并将OAuth认证相关的几个数据抛出。对应result对象内容:
		 * {"access_token":String, "expires_in":String, "refresh_token":String} 
		 */	
		public static const LOGIN_RESULT:String = "loginResult";
		
		/**
		 * 发布微博成功，成功调用updateStatu接口。
		 * result类型为MicroBlogStatus类型 
		 */		
		public static const UPDATE_STATUS_RESULT:String = "updateStatusResult";
		
		/**
		 * 成功更新头像，即成功调用avatarUpload接口。
		 * reslut类型为MicroBlogUser类型
		 */
		public static const AVATAR_UPDATE_RESULT:String = "avatarUpdateResult"
		
		/**
		 * 请求所返回后的结果。
		 * 返回值的具体内容请参照MicroBlog类的文档。
		 * 
		 * @see com.sina.microblog.Microblog
		 */ 
		public var result:Object;
		/**
		 * 当请求返回的结果集支持分页时，该属性标识指向下一个页面的指针。
		 * 并不是所有的MicroBlogEvent都会使用这个属性。
		 * 
		 * @see com.sina.microblog.Microblog
		 */ 
		public var nextCursor:Number;
		/**
		 * 当请求返回的结果集支持分页时，该属性标识指向上一个页面的指针。
		 * 并不是所有的MicroBlogEvent都会使用这个属性。
		 * 
		 * @see com.sina.microblog.Microblog
		 */ 
		public var previousCursor:Number;
		
		public function MicroBlogEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:MicroBlogEvent = new MicroBlogEvent(type, bubbles, cancelable);
			e.result = result;
			e.previousCursor = previousCursor;
			e.nextCursor = nextCursor;
			return e;
		}
		
	}
}