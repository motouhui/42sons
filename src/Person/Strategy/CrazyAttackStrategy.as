package Person.Strategy
{
	import Person.IPerson;
	
	import Util.Constants;
	import Util.Util;
	
	public class CrazyAttackStrategy implements IStrategy
	{
		public function CrazyAttackStrategy()
		{
		}
		
		public function judgeWantAlign(person1:IPerson, person2:IPerson):Boolean
		{
			if (person1.getPower() <= person2.getPower()) return true;
			if (Math.random() <= 1.0 * person2.getAlign() / Util.Constants.MAX_PERSON_ALIGN) return true;
			return false;
		}
		
		public function judgeAlign(person1:IPerson, person2:IPerson):Boolean
		{
			return person1.judgeWantAlign(person2) && person2.judgeWantAlign(person1);
		}
		
		public function judgeAttack(person1:IPerson, person2:IPerson):Boolean
		{
			return person1.getPower() > person2.getPower();
		}
		
		public function judgeChase(person1:IPerson, person2:IPerson):Boolean
		{
		    var dist:Number = Util.Util.Distance(person1.getX(), person1.getY(), person2.getX(), person2.getY());
			var x:int = person1.getSpeed() * person1.getEndurance() - person2.getSpeed() * person2.getEndurance();
			return x >= dist ? true : false;
		}
		
	}
}