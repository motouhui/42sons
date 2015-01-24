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
		private static var NUMBER_OF_GRASS_1:Number = 100;
		private static var NUMBER_OF_GRASS_2:Number = 120;
		private static var NUMBER_OF_ROCK_1:Number = 30;
		private static var NUMBER_OF_ROCK_2:Number = 60;
		
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
			bitmap.height = 600;
			bitmap.width = 800;
			this.addChild(bitmap);
			
			for(var i:int = 0 ; i< NUMBER_OF_GRASS_1;i++)
			{
				var grass:Bitmap = new Bitmap(GameSkin.grass01_bitmapdata);
				grass.width = 14;
				grass.height = 4;
				
				grass.x = Math.random() * 800;
				grass.y = Math.random() * 600;
				this.addChild(grass);
			}
			for(var i2:int = 0; i2< NUMBER_OF_GRASS_2; i2++)
			{
				var grass2:Bitmap = new Bitmap(GameSkin.grass02_bitmapdata);
				grass2.width = 10;
				grass2.height = 4;
				
				grass2.x = Math.random() * 800;
				grass2.y = Math.random() * 600;
				this.addChild(grass2);
			}
			for(var i3:int = 0 ; i3< NUMBER_OF_ROCK_1;i3++)
			{
				var rock:Bitmap = new Bitmap(GameSkin.rock01_bitmapdata);
				rock.width = 30;
				rock.height = 24;
				
				rock.x = Math.random() * 800;
				rock.y = Math.random() * 600;
				this.addChild(rock);
			}
			for(var i4:int = 0 ; i4< NUMBER_OF_ROCK_2;i4++)
			{
				var rock2:Bitmap = new Bitmap(GameSkin.rock02_bitmapdata);
				rock2.width = 16;
				rock2.height = 10;
				
				rock2.x = Math.random() * 800;
				rock2.y = Math.random() * 600;
				this.addChild(rock2);
			}
		}
		
		public function drawMask(spr:Sprite):void
		{
			this.mask = spr;
		}
	}
}