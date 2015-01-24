package GGM.util
{
	import flash.geom.Point;
	
	import GGM.avatar.AvatarBase;

	/**
	 * 计算用户点的 
	 * @author LionelZhangz
	 * 
	 */	
	public class AvatarMoveUtil
	{
		
		public function AvatarMoveUtil()
		{
		}
		
		public static function getPlayerMovePoint2(player:AvatarBase):Point
		{
			var p:Point;
			if (player.x == 0 && player.y == 0) {
				p = player.Step.knockLeftUpCornerDirection();
			} else if (player.x == 0 && player.y == GameStageData.rangeHeight) {
				p = player.Step.knockLeftDownCornerDirection();
			} else if (player.x == GameStageData.rangeWidth && player.y == 0) {
				p = player.Step.knockRightUpCornerDirection();
			} else if (player.x == GameStageData.rangeWidth && player.y == GameStageData.rangeHeight) {
				p = player.Step.knockRightDownCornerDirection();
			} else if (player.x == 0) {
				p = player.Step.knockLeftWallDirection();
			} else if (player.x == GameStageData.rangeWidth) {
				p = player.Step.knockRightWallDirection();
			} else if (player.y == 0) {
				p = player.Step.knockUpWallDirection();
			} else if (player.y == GameStageData.rangeHeight) {
				p = player.Step.knockDownWallDirection();
			} else {
				p = player.Step.direction();
			}
			
			player.x += p.x * player.moveStep;
			player.y += p.y * player.moveStep;
			player.x = player.x < 0 ? 0 : player.x;
			player.x = player.x > GameStageData.rangeWidth - player.avatar.width ? GameStageData.rangeWidth - player.avatar.width : player.x;
			player.y = player.y < 40 ? 40 : player.y;
			player.y = player.y > GameStageData.rangeHeight - player.avatar.height ? GameStageData.rangeHeight - player.avatar.height : player.y;
			
			return p;
		}
		
		/**
		 * 获取用户移动的数据 
		 * 
		 */		
		public static function getPlayerMovePoint(player:AvatarBase,moveDir:String):void
		{
			var p:Point;
			if (moveDir === "up") {
				p = new Point(0, -1);
			} else if (moveDir === "down") {
				p = new Point(0, 1);
			} else if (moveDir === "left") {
				p = new Point(-1, 0);
			} else {
				p = new Point(1, 0);
			}
			
			player.x += p.x * player.moveStep;
			player.y += p.y * player.moveStep;
			player.x = player.x < 0 ? 0 : player.x;
			player.x = player.x > GameStageData.rangeWidth - player.avatar.width ? GameStageData.rangeWidth - player.avatar.width : player.x;
			player.y = player.y < 40 ? 40 : player.y;
			player.y = player.y > GameStageData.rangeHeight - player.avatar.height ? GameStageData.rangeHeight - player.avatar.height : player.y;
//			switch(moveDir)
//			{
//				case "up":
//				{
//					if(player.y >0)
//					{
//						player.y = player.y - player.moveStep < 0?0:player.y - player.moveStep;
//					}
//				}
//					break;
//				case "down":
//				{
//					if(player.y + player.height <= GameStageData.rangeHeight)
//					{
//						player.y = player.y + player.moveStep > GameStageData.rangeHeight?GameStageData.rangeHeight:player.y + player.moveStep;
//					}
//				}
//					break;
//				case "left":
//				{
//					if(player.x > 0)
//					{
//						player.x = player.x - player.moveStep < 0? 0:player.x - player.moveStep;
//					}
//				}
//					break;
//				case "right":
//				{
//					if(player.x + player.width < GameStageData.rangeWidth)
//					{
//						player.x = player.x + player.moveStep >GameStageData.rangeWidth? GameStageData.rangeWidth:player.x + player.moveStep;
//					}
//				}
//					break;
//			}
		}
	}
}