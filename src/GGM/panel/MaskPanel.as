package GGM.panel
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import GGM.skin.GameSkin;

	public class MaskPanel extends Sprite
	{
		public function MaskPanel()
		{
//			this.graphics.beginFill(0,1);
//			this.graphics.drawCircle(
//				0,0,
//				80);
//			this.graphics.endFill();
			
//			this.cacheAsBitmap = true;
			
			var mist:Bitmap = new Bitmap(GameSkin.mist_bitmapdata);
			
			mist.width = 200;
			mist.height = mist.width;
			
			mist.cacheAsBitmap = true;
			
			this.addChild(mist);
		}
	}
}