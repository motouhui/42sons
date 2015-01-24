package GGM.panel
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import GGM.skin.GameSkin;
	
	import morn.core.components.Button;
	
	/**
	 *  
	 * @author LionelZhangz
	 * 
	 */	
	public class RetryPanel extends Sprite
	{
		
		public function RetryPanel()
		{
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0,0,50);
			this.graphics.endFill();
			
			var avatar:Bitmap = new Bitmap(GameSkin.avatar_bitmapdata);
			avatar.width = 25;
			avatar.height = 50;
			avatar.x = -12;
			avatar.y = 0;
			this.addChild(avatar);
			
			var retryBtn:Button = new Button("button","retry");
			retryBtn.x = -35;
			retryBtn.y = -30;
			this.addChild(retryBtn);
			
			retryBtn.addEventListener(MouseEvent.CLICK,retryHandler);
		}
		
		/**
		 * 重试 
		 * @param event
		 * 
		 */		
		protected function retryHandler(event:MouseEvent):void
		{
			dispatchEvent(event);
		}
	}
}