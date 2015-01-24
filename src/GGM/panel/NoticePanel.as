package GGM.panel
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.getTimer;

	/**
	 * 消息面板
	 * @author LionelZhangz
	 * 
	 */	
	public class NoticePanel extends Sprite
	{
		/**
		 * 渐变隐藏的时间 
		 */		
		private static const JIAN_BIAN_HIDE:int = 1000;
		
		/**
		 * 停留的时间 
		 */		
		private static const STAY_TIME:int = 1000;
		/**
		 * 渐变显示的时间 
		 */		
		private static const JIAN_BIAN_SHOW:int = 1000;
		
		private var _beforeTime:Number;
		
		public function NoticePanel()
		{
			_strList = new Vector.<String>();
			
			_isPlay = false;
			
			_text = new TextField();
			_text.width = 400;
			_text.filters =[ new GlowFilter(0xff0000)];
			this.addChild(_text);
			
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			//如果没有播放的话
			if(!_isPlay)
			{
				if(_strList.length > 0)
				{
					var str:String = _strList.pop();
					
					this._isPlay = true;
					
					_text.htmlText = str;
					
					_beforeTime = getTimer();
					this.addEventListener(Event.ENTER_FRAME,jianbianShowHandler);
					
				}
			}
		}
		/**
		 * 渐渐显示 
		 * @param event
		 * 
		 */		
		protected function jianbianShowHandler(event:Event):void
		{
			if(getTimer() - _beforeTime >= JIAN_BIAN_SHOW)
			{
				_text.alpha = 1;
				this.removeEventListener(Event.ENTER_FRAME,jianbianShowHandler);
				
				_beforeTime = getTimer();
				this.addEventListener(Event.ENTER_FRAME,jianbianhideHandler);
				return;
			}
			
			_text.alpha = (getTimer() - _beforeTime)/JIAN_BIAN_SHOW * 1.0;
			_text.visible = true;
			
		}
		
		protected function jianbianhideHandler(event:Event):void
		{
			if(getTimer() - _beforeTime >= STAY_TIME)
			{
				if(getTimer() - _beforeTime- STAY_TIME >= JIAN_BIAN_HIDE)
				{
					_text.alpha = 0;
					_text.visible = false;
					
					this.removeEventListener(Event.ENTER_FRAME,jianbianhideHandler);
					
					this._isPlay = false;
					
					return;
				}
				
				_text.alpha = 1.0 -(getTimer() - _beforeTime - STAY_TIME)/JIAN_BIAN_HIDE * 1.0;
			}
		}
		
		/**
		 * 消息的队列 
		 */		
		private var _strList:Vector.<String>;
		
		/**
		 * 显示文字类 
		 */		
		private var _text:TextField;
		
		/**
		 * 当前是否已经正在播放 
		 */		
		private var _isPlay:Boolean;
		
		public function addNotice(str:String):void
		{
			_strList.push(str);
		}
		
		public function clearNotice():void
		{
			_strList.length = 0;
			_text.visible = false;
			_beforeTime = -1;
		}
	}
}