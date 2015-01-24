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
			this.mMaxVal = maxVal;
			
			this.graphics.beginFill(0);
			this.graphics.drawRoundRect(0,0,maxVal,10,6,6);
			this.graphics.endFill();
			
			mNowSpr = new Sprite();
			
			this.addChild(mNowSpr);
			
			
			mTxtVal = new Label();
			mTxtVal.y = -4;
			mTxtVal.color = 0xffffff;
			mTxtVal.width = 100;
			mTxtVal.height = 20;
			mTxtVal.align = TextFormatAlign.CENTER;
			
			this.addChild(mTxtVal);
			
		}
		
		/**
		 * 最大值 
		 */		
		protected var mMaxVal:int;
		
		/**
		 * 当前值 
		 */		
		protected var mNowSpr:Sprite;
		
		/**
		 * 显示值 
		 */		
		protected var mTxtVal:Label;
		
		/**
		 * 设置当前值 
		 * @param val
		 * 
		 */		
		public function setNowVal(val:int):void
		{
			mNowSpr.graphics.clear();
			mNowSpr.graphics.beginFill(0xff0000);
			mNowSpr.graphics.drawRoundRect(0,0,val,10,6,6);
			mNowSpr.graphics.endFill();
			
			if(val > this.mMaxVal)
			{
				this.mMaxVal = val;
			}
			
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRoundRect(0,0,mMaxVal,10,6,6);
			this.graphics.endFill();
			
			mTxtVal.text = val+ "/" + this.mMaxVal;
		}
		
		public function refreshMaxVal():void
		{
			this.mMaxVal = 100;
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRoundRect(0,0,mMaxVal,10,6,6);
			this.graphics.endFill();
		}
	}
}