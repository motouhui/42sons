package com.sina.microblog.events
{
	import flash.events.Event;

	/**
	 * 所有对新浪微博API的请求会以事件的形式返回给调用者。当API请求出现错误时，MicroBlog类会派发MicroBlogErrorEvent事件.
	 * 
	 * <p>每个MicroBlogErrorEvent事件都有一个message属性用于保存错误信息。</br>
	 * API请求与事件的对应关系请参照MicroBlog类的文档。</p>
	 * 
	 * @see com.sina.microblog.MicroBlog
	 */ 	
	public class MicroBlogErrorEvent extends Event
	{
		public static const LOGIN_ERROR:String = "loginError";
		
		public static const UPDATE_STATUS_ERROR:String = "updateStatusError";
		
		/**
		 * 调用avatarUpload接口失败
		 */
		public static const AVATAR_UPDATE_ERROR:String = "avatarUpdateError";
		
		public static const NET_WORK_ERROR:String = "networkError";
		
		/**
		 * 请求失败后返回的错误信息
		 */ 
		public var message:String;
		
		/**
		 * 状态值
		 */
		public var code:int;
		
		public function MicroBlogErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:MicroBlogErrorEvent = new MicroBlogErrorEvent(type, bubbles, cancelable);
			e.message = message;
			e.code = code;
			return e;
		}
		
	}
}