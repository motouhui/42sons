package GGM.panel
{
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import morn.core.components.Label;

	/**
	 * 进度条 
	 * @author LionelZhangz
	 * 
	 */	
	public class ProcessBar extends Sprite
	{
		
		public function ProcessBar(maxVal:int)
		{
			this._maxVal = maxVal;
			
			this.graphics.beginFill(0);
			this.graphics.drawRoundRect(0,0,maxVal,10,6,6);
			this.graphics.endFill();
			
			_nowSpr = new Sprite();
			
			this.addChild(_nowSpr);
			
			
			_txtVal = new Label();
			_txtVal.y = -4;
			_txtVal.color = 0xffffff;
			_txtVal.width = 100;
			_txtVal.height = 20;
			_txtVal.align = TextFormatAlign.CENTER;
			
			this.addChild(_txtVal);
			
		}
		
		/**
		 * 最大值 
		 */		
		private var _maxVal:int;
		
		/**
		 * 当前值 
		 */		
		private var _nowSpr:Sprite;
		
		/**
		 * 显示值 
		 */		
		private var _txtVal:Label;
		
		/**
		 * 设置当前值 
		 * @param val
		 * 
		 */		
		public function setNowVal(val:int):void
		{
			_nowSpr.graphics.clear();
			_nowSpr.graphics.beginFill(0xff0000);
			_nowSpr.graphics.drawRoundRect(0,0,val,10,6,6);
			_nowSpr.graphics.endFill();
			
			if(val > this._maxVal)
			{
				this._maxVal = val;
			}
			
			this.graphics.beginFill(0);
			this.graphics.drawRoundRect(0,0,_maxVal,10,6,6);
			this.graphics.endFill();
			
			_txtVal.text = val+ "/" + this._maxVal;
		}
	}
}