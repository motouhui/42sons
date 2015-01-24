package Person
{
	import Person.Strategy.SmartStrategy;
	
	public class SmartPerson extends Person
	{
		public function SmartPerson()
		{
			super();
			super.Strategy = new SmartStrategy();
		}
	}
}