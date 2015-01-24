package Person
{
	import Person.Strategy.TimidStrategy;

	public class TimidPerson extends Person
	{
		public function TimidPerson()
		{
			super();
			super.Strategy = new TimidStrategy;
		}
	}
}