package GGM.util
{
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
		
		/**
		 * 获取用户移动的数据 
		 * 
		 */		
		public static function getPlayerMovePoint(player:AvatarBase,moveDir:String):void
		{
			switch(moveDir)
			{
				case "up":
				{
					if(player.y >0)
					{
						player.y = player.y - player.moveStep < 0?0:player.y - player.moveStep;
					}
				}
					break;
				case "down":
				{
					if(player.y + player.height <= GameStageData.rangeHeight)
					{
						player.y = player.y + player.moveStep > GameStageData.rangeHeight?GameStageData.rangeHeight:player.y + player.moveStep;
					}
				}
					break;
				case "left":
				{
					if(player.x > 0)
					{
						player.x = player.x - player.moveStep < 0? 0:player.x - player.moveStep;
					}
				}
					break;
				case "right":
				{
					if(player.x + player.width < GameStageData.rangeWidth)
					{
						player.x = player.x + player.moveStep >GameStageData.rangeWidth? GameStageData.rangeWidth:player.x + player.moveStep;
					}
				}
					break;
			}
		}
	}
}