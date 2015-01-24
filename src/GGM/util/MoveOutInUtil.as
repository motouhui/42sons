package GGM.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class MoveOutInUtil extends Sprite
	{
		///////////////////////////////////////////////////
		// Static Variable
		///////////////////////////////////////////////////
		/**
		 * 向左移动 
		 */		
		public static const MOVE_LEFT:int = 0;
		/**
		 * 向右移动 
		 */		
		public static const MOVE_RIGHT:int = 1;
		/**
		 * 向上移动 
		 */		
		public static const MOVE_TOP:int = 2;
		/**
		 * 向下移动 
		 */		
		public static const MOVE_BOTTOM:int = 3;
		/**
		 * 开始向左移动 
		 */		
		public static const STATE_BEGIN_MOVE_LEFT:int = 10;
		/**
		 * 开始向右移动 
		 */		
		public static const STATE_BEGIN_MOVE_RIGHT:int = 11;
		/**
		 * 开始向上移动 
		 */		
		public static const STATE_BEGIN_MOVE_TOP:int = 12;
		/**
		 * 开始向下移动 
		 */		
		public static const STATE_BEGIN_MOVE_BOTTOM:int = 13;
		
		/**
		 * 向左移动完毕 
		 */		
		public static const STATE_MOVE_LEFT_OVER:int = 20;
		/**
		 * 向右移动完毕 
		 */		
		public static const STATE_MOVE_RIGHT_OVER:int = 21;
		/**
		 * 向上移动完毕 
		 */		
		public static const STATE_MOVE_TOP_OVER:int = 22;
		/**
		 * 向下移动完毕 
		 */		
		public static const STATE_MOVE_BOTTOM_OVER:int = 23;
		/**
		 *面板的移动速度 
		 */		
		private var _moveSpeed:int = 0;
		
		///////////////////////////////////////////////////
		// Constructor
		///////////////////////////////////////////////////
		public function MoveOutInUtil(spr:DisplayObject,moveSpeed:int = -1)
		{
			
			//设置移动时间
			if(moveSpeed == -1)
			{
				_moveSpeed = RightPanelInOutInfo.CLOSE_PANEL_TIME;
			}
			else
			{
				_moveSpeed = moveSpeed;
			}
			
			//设置要移动的面板
			_sorPanel = spr;
			
			//显示是关闭状态
			_isShow = false;
		}
		
		///////////////////////////////////////////////////
		// Variable
		///////////////////////////////////////////////////
		/**
		 * 原始面板 
		 */		
		private var _sorPanel:DisplayObject;
		/**
		 * 起始点 
		 */		
		private var _beginLoc:Number;
		/**
		 * 目标点 
		 */		
		private var _endLoc:Number;
		/**
		 * 移动类型 
		 */		
		private var _type:int;
		/**
		 * 时间副本 
		 */		
		private var _beforeTime:Number;
		/**
		 * 是否显示 
		 */
		private var _isShow:Boolean;
		public function get isShow():Boolean
		{
			return _isShow;
		}
		public function set isShow(value:Boolean):void
		{
			_isShow = value;
		}
		
		
		///////////////////////////////////////////////////
		// Method
		///////////////////////////////////////////////////
		
		/**
		 * 得到当前控制的面板 
		 * @return 
		 * 
		 */		
		public function getSorPanel():DisplayObject
		{
			return _sorPanel;
		}
		/**
		 * 移动面板  [回调方法 state:String]
		 * @param beginLoc 初始位置 
		 * @param endLoc 目标位置
		 * @param invokeData 回调数据
		 * @param type 移动类型
		 * 
		 */		
		public function movePanel(
			beginLoc:Number,
			endLoc:Number,
			type:int
		):void
		{
			//			if(beginLoc == endLoc)
			//				return;
			
			
			//设置起始点和目标点
			_beginLoc = beginLoc;
			_endLoc = endLoc;
			
			_type = type;
			
			//初始化变量
			_init();
			
			
			//添加帧监听
			this.addEventListener(Event.ENTER_FRAME,enterframeHandler);
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		private function _init():void
		{
			_beforeTime = -1;
		}
		
		/**
		 * 帧监听事件 
		 * @param event
		 * 
		 */		
		private function enterframeHandler(event:Event):void
		{
			var inOut:RightPanelInOutInfo;
			
			switch(_type )
			{
				case MoveOutInUtil.MOVE_LEFT:
				{
					if(_beforeTime == -1)
						_beforeTime = getTimer();
					inOut = 
						new RightPanelInOutInfo(
							_moveSpeed,
							_beginLoc - _endLoc
						);
					_sorPanel.x = _beginLoc - 
						RightPanelInOutInfo.calcuDis(getTimer() - _beforeTime);
					
					if(_sorPanel.x <= _endLoc )
					{
						_sorPanel.x = _endLoc;
						_beforeTime = -1;
						
						this.removeEventListener(Event.ENTER_FRAME,enterframeHandler);
						
						
						//向左移动完毕之后，显示设置为ture
						_isShow = true;
					}
				}
					break;
				
				case MoveOutInUtil.MOVE_RIGHT:
				{
					if(_beforeTime == -1)
						_beforeTime = getTimer();
					inOut = 
						new RightPanelInOutInfo(
							_moveSpeed,
							_endLoc - _beginLoc
						);
					_sorPanel.x = _beginLoc + 
						RightPanelInOutInfo.calcuDis(getTimer() - _beforeTime);
					
					if(_sorPanel.x >= _endLoc )
					{
						_sorPanel.x = _endLoc;
						_beforeTime = -1;
						this.removeEventListener(Event.ENTER_FRAME,enterframeHandler);
						
						
						//向右移动完毕之后，显示设置为false
						_isShow = false;
					}
				}
					break;
				
				case MoveOutInUtil.MOVE_TOP:
				{
					if(_beforeTime == -1)
						_beforeTime = getTimer();
					inOut = 
						new RightPanelInOutInfo(
							_moveSpeed,
							_beginLoc - _endLoc
						);
					_sorPanel.y = _beginLoc - 
						RightPanelInOutInfo.calcuDis(getTimer() - _beforeTime);
					
					if(_sorPanel.y <= _endLoc )
					{
						_sorPanel.y = _endLoc;
						_beforeTime = -1;
						
						this.removeEventListener(Event.ENTER_FRAME,enterframeHandler);
						
						
						_isShow = true;
					}
				}
					break;
				case MoveOutInUtil.MOVE_BOTTOM:
				{
					if(_beforeTime == -1)
						_beforeTime = getTimer();
					inOut = 
						new RightPanelInOutInfo(
							_moveSpeed,
							_endLoc - _beginLoc  
						);
					_sorPanel.y = _beginLoc + 
						RightPanelInOutInfo.calcuDis(getTimer() - _beforeTime);
					
					if(_sorPanel.y >= _endLoc )
					{
						_sorPanel.y = _endLoc;
						_beforeTime = -1;
						
						this.removeEventListener(Event.ENTER_FRAME,enterframeHandler);
						
						
						_isShow = false;
					}
					
				}
					break;
			}
		}
	}
}