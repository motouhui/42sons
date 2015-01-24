package GGM.panel
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import GGM.skin.GameSkin;

	/**
	 * 地图 
	 * @author LionelZhangz
	 * 
	 */	
	public class MapPanel extends Sprite
	{
		public function MapPanel()
		{
		}
		
		/**
		 * 刷新边界 
		 */		
		public function refreshRange(rangeW:int,rangeH:int):void
		{
//			this.graphics.clear();
//			this.graphics.beginFill(0);
//			this.graphics.drawRect(0,0,rangeW,rangeH);
//			this.graphics.endFill();
			
			var bitmap:Bitmap = new Bitmap(GameSkin.field_bitmapdata);
			bitmap.width = 800;
			this.addChild(bitmap);
			
			for(var i:int = 0 ; i< 50;i++)
			{
				var tree:Bitmap = new Bitmap(GameSkin.tree_bitmapdata);
				tree.width = 14;
				tree.height = 17;
				
				tree.x = Math.random() * 800;
				tree.y = Math.random() * 600;
				this.addChild(tree);
			}
		}
		
		public function drawMask(spr:Sprite):void
		{
			this.mask = spr;
		}
	}
}