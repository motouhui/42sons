package Person.Strategy
{
	import Person.IPerson;

	public interface IStrategy
	{
		function judgeWantAlign(person1:IPerson, person2:IPerson):Boolean;
		function judgeAlign(person:IPerson, person:IPerson):Boolean;
		function judgeAttack(person:IPerson, person:IPerson):Boolean;
		function judgeChase(person:IPerson, person:IPerson):Boolean;		
	}
}