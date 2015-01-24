package Util
{
	public class Constants
	{
		public static const DEFAULT_VIEW_RADIUS:int = 3;
		public static const MAX_ALLIANCE_MEMBERS:int = 3;
		
		public static const MAX_PERSON_LIFE:int = 100;
		public static const MAX_PERSON_ALIGN:int = 100;
		public static const MAX_PERSON_SPEED:int = 10;
		public static const MAX_PERSON_ENDURANCE:int = 10;
		public static const MAX_PERSON_BATTLE_LUST:int = 10;
		public static const MAX_PERSON_ATTACK:int = 10;
		
		public static function getMaxBattleLust():int
		{
			return int(MAX_PERSON_BATTLE_LUST * 4.0 / 5);	
		}
		
		public static function getMinBattleLust():int
		{
			return 1;
		}
	}
}