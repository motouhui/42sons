package Person
{
	import Person.Strategy.CalmStrategy;

	public class CalmPerson extends Person
	{
		public function CalmPerson()
		{
			super();
			super.Strategy = new CalmStrategy();
		}
	}
}