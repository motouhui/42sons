package
{
	import Array;
	
	import Util.UtilTest;
	
	import flash.display.Sprite;
	
	import flexunit.flexui.FlexUnitTestRunnerUIAS;
	
	public class FlexUnitApplication extends Sprite
	{
		public function FlexUnitApplication()
		{
			onCreationComplete();
		}
		
		private function onCreationComplete():void
		{
			var testRunner:FlexUnitTestRunnerUIAS=new FlexUnitTestRunnerUIAS();
			testRunner.portNumber=8765; 
			this.addChild(testRunner); 
			testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "KillerAg");
		}
		
		public function currentRunTestSuite():Array
		{
			var testsToRun:Array = new Array();
			testsToRun.push(Util.UtilTest);
			return testsToRun;
		}
	}
}