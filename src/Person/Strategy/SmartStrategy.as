package Person.Strategy
{
	import Person.IPerson;
	
	public class SmartStrategy implements IStrategy
	{
		
		public function judgeAlign(person:IPerson, person:IPerson):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function judgeAttack(person:IPerson, person:IPerson):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function judgeChase(person:IPerson, person:IPerson):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function judgeWantAlign(person1:IPerson, person2:IPerson):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
	}
}