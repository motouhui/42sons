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
			App.asset.cacheBitmapData("button_retry",GameSkin.button_retry_btmapdata);
			
			this.graphics.beginFill(0xeeeeee);
			this.graphics.drawRect(0, 0, 800, 550);
			this.graphics.endFill();
			
			var avatar:Bitmap = new Bitmap(GameSkin.avatar_bitmapdata);
			avatar.width = 24;
			avatar.height = 36;
			this.addChild(avatar);
			
			var retryBtn:Button = new Button("button_retry");
			this.addChild(retryBtn);
			
			avatar.x = this.width / 2 - 12;
			avatar.y = this.height / 2 - 18;
			retryBtn.x = this.width / 2 - retryBtn.width / 2;
			retryBtn.y = this.height / 2 - retryBtn.height - 40;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawCircle(avatar.x + avatar.width/2, avatar.y + avatar.height/2, 200);
			this.graphics.endFill();
			
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