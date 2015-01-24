package Person.Strategy
{
	import Person.IPerson;
	
	public class TimidStrategy implements IStrategy
	{
		public function TimidStrategy()
		{
		}
		
		public function judgeWantAlign(person1:IPerson, person2:IPerson):Boolean
		{
			return true;	
		}
		
		public function judgeAlign(person1:IPerson, person2:IPerson):Boolean
		{	
			return person1.judgeWantAlign(person2) && person2.judgeWantAlign(person1);
		}
		
		public function judgeAttack(person1:IPerson, person2:IPerson):Boolean
		{
			return false;
		}
		
		public function judgeChase(person1:IPerson, person2:IPerson):Boolean
		{
			// never chase
			return false;
		}
	}
}