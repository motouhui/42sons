package Util
{
	import flash.geom.Point;
	
	import flexunit.framework.Assert;
	
	public class UtilTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testCross():void
		{
			Assert.assertTrue(Util.Util.cross(0, 0, 1, 1, 1, 1));
			Assert.assertTrue(Util.Util.cross(0, 0, 2, 3, 4, 3));
			Assert.assertFalse(Util.Util.cross(0, 0, 1, 3, 4, 3));
		}
		
		[Test]
		public function testDistance():void
		{
			Assert.assertTrue(Util.Util.Distance(0, 0, 3, 4) == 5);
		}
		
		[Test]
		public function testInView():void
		{
			Assert.assertTrue(Util.Util.inView(0, 0, 5, 0, 5));
		}
		
		[Test]
		public function testPlace():void
		{
			var p:Point = Util.Util.place(0, 0, 3, 4, 10);
			Assert.assertTrue(p.x == 6);
			Assert.assertTrue(p.y == 8);
			
			p = Util.Util.place(3, 4, 0, 0, 10);
			Assert.assertTrue(p.x == -3);
			Assert.assertTrue(p.y == -4);
		}
	}
}