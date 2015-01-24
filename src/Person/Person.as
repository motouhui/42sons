package Person
{
	import flash.geom.Point;
	
	import Person.Strategy.IStrategy;
	
	import Util.Constants;
	import Util.Util;
	
	public class Person implements IPerson
	{
		private var _ishero:Boolean = false;
		
		private var _x:int;
		private var _y:int;
		
		private var _viewRadius:int = Util.Constants.DEFAULT_VIEW_RADIUS;
		
		private var _speed:int;
		private var _align:int;
		private var _battlelust:int;
		private var _power:int;
		private var _endurance:int;
		private var _life:int;
		
		private var _strategy:IStrategy;
		public function get Strategy():IStrategy
		{
			return this._strategy;
		}
		public function set Strategy(s:IStrategy):void
		{
			this._strategy = s;
		}
		
		private var _belongto:IPerson;
		
		public function Person()
		{
			super();
			_strategy = null;
			_belongto = null;
		}
		
		public function isHero():Boolean
		{
			return this._ishero;
		}
		
		public function setHero():IPerson
		{
			this._ishero = false;
			return this; 
		}
		
		public function getSpeed():int
		{
			return this._speed;
		}
		
		public function setSpeed(speed:int):IPerson
		{
			this._speed = speed;
			return this;
		}
		
		public function getAlign():int
		{
			return this._align;
		}
		
		public function setAlign(align:int):IPerson
		{
			this._align = align;
			return this;
		}
		
		public function getBattleLust():int
		{
			return this._battlelust;
		}
		
		public function setBattleLust(lust:int):IPerson
		{
			this._battlelust = lust;
			return this;
		}
		
		public function getPower():int
		{
			return this._power;
		}
		
		public function setPower(power:int):IPerson
		{
			this._power = power;
			return this;
		}
		
		public function getEndurance():int
		{
			return this._endurance;
		}
		
		public function setEndurance(endurance:int):IPerson
		{
			this._endurance = endurance;
			return this;
		}
		
		public function getLife():int
		{
			return this._life;
		}
		
		public function setLife(life:int):IPerson
		{
			this._life = life;
			return this;
		}
		
		public function decLife(x:int):IPerson
		{
			this._life -= x;
			this._battlelust = this._battlelust > Util.Constants.getMinBattleLust() ? 
				this._battlelust - 1 : Util.Constants.getMinBattleLust();
			return this;
		}
		
		public function isLive():Boolean
		{
			return this._life > 0;
		}
		
		public function setDead():IPerson
		{
			this._life = 0;
			return this;
		}
		
		public function getAlliance():IPerson
		{
			return this._belongto;
		}
		
		public function setAlliance(person:IPerson):IPerson
		{
			this._belongto = person;
			return this;
		}
		
		public function getX():int
		{
			return this._x;
		}
		
		public function getY():int
		{
			return this._y;
		}
		
		public function setX(x:int):IPerson
		{
			this._x = x;
			return this;
		}
		
		public function setY(y:int):IPerson
		{
			this._y = y;
			return this;
		}
		
		public function getRadius():int
		{
			return this._viewRadius;
		}
		
		public function doMove(x:int, y:int):void
		{
			this._x = x;
			this._y = y;
		}
		
		public function judgeWantAlign(person:IPerson):Boolean
		{
			return this._strategy.judgeWantAlign(this, person);
		}
		
		public function judgeAlign(person:IPerson):Boolean
		{
			return this._strategy.judgeAlign(this, person);
		}
		
		public function judgeAttack(person:IPerson):Boolean
		{
			return this._strategy.judgeAttack(this, person);
		}
		
		public function judgeChase(person:IPerson):Boolean
		{
			return this._strategy.judgeChase(this, person);
		}
		
		public function doKickout(person:IPerson):void
		{			
		}
		
		public function doAlign(person:IPerson):void
		{
		}
		
		public function doAttack(person:IPerson):void
		{
			var dlt:int = this._power - person.getPower();
			if (dlt < 0) {
				this.decLife(dlt);
			} else {
				person.decLife(dlt);
				var maxlust:int = Util.Constants.getMaxBattleLust();
				this._battlelust = this._battlelust < maxlust ? this._battlelust + 1 : maxlust;
			}
		}
		
		public function doChase(person:IPerson):void
		{
			var dist:Number = Util.Util.Distance(this.getX(), this.getY(), person.getX(), person.getY());
			if (dist <= this.getSpeed() * this.getEndurance() - person.getSpeed() * person.getEndurance()) {
				doMove(person.getX(), person.getY());
				doAttack(person);
			} else {
				var p:Point = Util.Util.place(person.getX(), person.getY(), this.getX(), this.getY(), this.getSpeed() * this.getEndurance());	
				doMove(p.x, p.y);
			}
		}
		
		public function doEscape(person:IPerson):void
		{
			var p:Point = Util.Util.place(this.getX(), this.getY(), person.getX(), person.getY(), this.getSpeed() * this.getEndurance());	
			doMove(p.x, p.y);
		}
	}
}