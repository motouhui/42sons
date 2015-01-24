package Person.Strategy
{
	import Person.IPerson;
	
	import Util.Constants;
	import Util.Util;
	
	public class CalmStrategy implements IStrategy
	{
		
		public function judgeWantAlign(person1:IPerson, person2:IPerson):Boolean
		{
			if (person1.getPower() <= person2.getPower()) {
				return true;
			}
			var minspeed:int = person1.getSpeed() > person2.getSpeed() ? person2.getSpeed() : person1.getSpeed();
			var minendurance:int = person1.getEndurance() > person2.getEndurance() ? person2.getEndurance() : person1.getEndurance();
			if (person1.getSpeed() * person1.getEndurance() >= minspeed * minendurance) true;
			return Math.random() <= 1.0 * person1.getAlign() / Util.Constants.MAX_PERSON_ALIGN;
		}
		
		public function judgeAlign(person1:IPerson, person2:IPerson):Boolean
		{
			return person1.judgeWantAlign(person2) && person2.judgeWantAlign(person1); 
		}
		
		public function judgeAttack(person1:IPerson, person2:IPerson):Boolean
		{
			if (person1.getPower() > person2.getPower()) {
				return Math.random() <= 1.0 * person1.getBattleLust() / Util.Constants.MAX_PERSON_BATTLE_LUST;
			}
			return false;
		}
		
		public function judgeChase(person1:IPerson, person2:IPerson):Boolean
		{
			if (person1.getPower() <= person2.getPower()) {
				return false;
			}
			if (Util.Util.Distance(person1.getX(), person1.getY(), 
				person2.getX(), person2.getY()) <= person1.getSpeed() * person1.getEndurance() - 
				person2.getSpeed() * person2.getEndurance()) {
				return true;
			}
			return false;
		}
	}
}