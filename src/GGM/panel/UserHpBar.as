package GGM.panel
{
	public class UserHpBar extends ProcessBar
	{
		public function UserHpBar(maxVal:int)
		{
			super(maxVal);
		}
		
		
		override public function refreshMaxVal():void
		{
			// TODO Auto Generated method stub
			super.refreshMaxVal();
		}
		
		override public function setNowVal(val:int):void
		{
			mNowSpr.graphics.clear();
			mNowSpr.graphics.beginFill(0xff0000);
			mNowSpr.graphics.drawRoundRect(0,0,val,4,6,6);
			mNowSpr.graphics.endFill();
			
			if(val > this.mMaxVal)
			{
				this.mMaxVal = val;
			}
			
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRoundRect(0,0,mMaxVal,4,6,6);
			this.graphics.endFill();
		}
		
		public function setMaxVal(val:int):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRoundRect(0,0,val,4,6,6);
			this.graphics.endFill();
		}
		
	}
}