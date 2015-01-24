package Person
{
	import flash.display.BitmapData;

	public interface IPerson
	{
		function isHero():Boolean;
		function setHero():IPerson;
		
		function setBitmapData(bitmap:BitmapData):IPerson;
		function getBitmapData():BitmapData;
		
		function getSpeed():int; // 0-10
		function setSpeed(speed:int):IPerson;
		function getAlign():int; // 0-10
		function setAlign(align:int):IPerson;
		function getBattleLust():int; // 0-10
		function setBattleLust(lust:int):IPerson;
		function getPower():int; // 0-10
		function setPower(power:int):IPerson;
		function getEndurance():int; // 1-10
		function setEndurance(endurance:int):IPerson;
		function getLife():int;   // 0-100
		function setLife(life:int):IPerson;
		
		// location
		function getX():int;
		function getY():int;
		function setX(x:int):IPerson;
		function setY(y:int):IPerson;
		function getRadius():int;
		
		function getAlliance():IPerson;
		function setAlliance(person:IPerson):IPerson;
		
		function isLive():Boolean;
		function setDead():IPerson;
		function decLife(x:int):IPerson;
		
		function judgeWantAlign(person:IPerson):Boolean;
		function judgeAlign(person:IPerson):Boolean;
		function judgeAttack(person:IPerson):Boolean;
		function judgeChase(person:IPerson):Boolean;
		
		function doMove(x:int, y:int):void;
		function doAlign(person:IPerson):void;
		function doKickout(person:IPerson):void;
		function doAttack(person:IPerson):void;
		function doChase(person:IPerson):void;
		function doEscape(person:IPerson):void;
	}
}