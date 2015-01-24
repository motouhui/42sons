package Person
{	
	import Person.Strategy.CrazyAttackStrategy;

	public class CrazyAttackPerson extends Person
	{		
		public function CrazyAttackPerson()
		{
			super();
			super.Strategy = new CrazyAttackStrategy();
		}
	}
}