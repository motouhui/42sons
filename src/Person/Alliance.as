package Person
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import Person.Strategy.AllianceStrategy;
	import Person.Strategy.IStrategy;
	
	import Util.Constants;
	import Util.Util;
	
	public class Alliance implements IPerson
	{		
		private var _persons:Vector.<IPerson>;
		
		private var _ishero:Boolean = false;
		
		private var _speed:int;
		private var _align:int;
		private var _battlelust:int;
		private var _power:int;
		private var _endurance:int;
		private var _life:int;
		
		private var _x:int;
		private var _y:int;
		private var _viewRadius:int = Util.Constants.DEFAULT_VIEW_RADIUS;
		
		private var _strategy:IStrategy = null;
		
		public function Alliance()
		{
			_strategy = new AllianceStrategy();
			_persons = new Vector.<IPerson>();
		}

		private var _name:String = null;
		
		public function getName():String
		{
			return this._name;
		}
		
		public function setName(name:String):IPerson
		{
			this._name = name;
			return this;
		}
		
		private var _bitmap:BitmapData = null;

		public function setBitmapData(bitmap:BitmapData):IPerson 
		{
			this._bitmap = bitmap;
			return this;	
		}
		
		public function getBitmapData():BitmapData
		{
			return this._bitmap;
		}
		
		public function isHero():Boolean
		{
			return this._ishero;
		}
		
		public function setHero():IPerson
		{
			this._ishero = true;
			return this;
		}
		
		public function getMembers():Vector.<IPerson>
		{
			return this._persons;
		}
		
		public function onlyone():Boolean
		{
			return _persons.length == 1;
		}
		
		public function nobody():Boolean
		{
			return _persons.length == 0;
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
		
		public function isLive():Boolean
		{
			return this._life > 0;
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
			for each(var person:IPerson in _persons) {
				person.setX(x).setY(y);
			}
			this._x = x;
			this._y = y;
		}
		
		private function doReset():void
		{
			this._life = 0;
			this._power = 0;
			this._speed = int.MAX_VALUE;
			this._endurance= int.MAX_VALUE;
			this._align = 0;
			this._battlelust = 0;
			for each(var person:IPerson in _persons) {
				this._life += person.getLife();
				this._power += person.getPower();
				this._speed = this._speed > person.getSpeed() ? person.getSpeed() : this._speed;
				this._endurance = this._endurance > person.getSpeed() ? person.getSpeed() : this._speed;
				this._align += person.getAlign();
				this._battlelust += person.getBattleLust();
			}
			if (_persons.length < Util.Constants.MAX_ALLIANCE_MEMBERS) {
				this._align /= _persons.length;
			} else {
				this._align = 1;
			}
			this._battlelust = this._battlelust / _persons.length;
			for each(var x:IPerson in _persons) {
				x.setBattleLust(this._battlelust);
			}
		}
		
		public function doKickout(person:IPerson):void
		{
			_persons.splice(_persons.indexOf(person), 1);
			person.setDead();
			this.doReset();
		}
		
		public function doAlign(person:IPerson):void
		{
			if (person is Person) {
				person.setAlliance(this);
				_persons.push(person);
				if (_persons.length == Util.Constants.MAX_ALLIANCE_MEMBERS + 1) {
					var minindex:int = 0;
					var minpower:int = _persons[0].getPower();
					for(var i:int = 1; i < _persons.length; i++) {
						if (minpower > _persons[i].getPower() && _persons[i].isHero() == false) {
							minindex = i;
							minpower = _persons[i].getPower();
						}
					}
					_persons[minindex].setDead();
					_persons.splice(minindex, 1);
				}
				this.doReset();
			} else {
				// allinace vs allinace
				var alliance:Alliance = Alliance(person);
				for (var ii:int = 0; ii < _persons.length; ii++) {
					if (_persons[ii].isHero()) {
						continue;
					}
					if (Math.random() > 0.5) {
						var tmp:IPerson = _persons[ii];
						var ops:Vector.<IPerson> = alliance.getMembers();
						var index:int = int(Math.random() * ops.length); 
						if (ops[index].isHero()) {
							continue;
						}
						_persons[ii] = ops[index];
						ops[index] = tmp;
					}
				}
				
				for each(var p:IPerson in _persons) {
					p.setAlign(p.getAlign() - 1);	
				}
				for each(var pp:IPerson in alliance.getMembers()) {
					pp.setAlign(pp.getAlign() - 1);
				}
				
				
				this.doReset();
				alliance.doReset();
			}
		}
		
		public function doAttack(person:IPerson):void
		{	
			var dlt:int = this._power - person.getPower();
			if (dlt < 0) {
				this.decLife(dlt);
			} else {
				person.decLife(dlt);
				var maxlust:int = Util.Constants.getMaxBattleLust();
				this._battlelust = this._battlelust < Util.Constants.getMaxBattleLust() ? 
					this._battlelust + 1 : Util.Constants.getMaxBattleLust();
				for (var i:int = 0; i < _persons.length; i++) {
					_persons[i].setBattleLust(this._battlelust);
				}
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
		
		public function setDead():IPerson
		{
			this._life = 0;
			for each(var person:IPerson in this._persons) {
				person.setDead();
			}
			return this;
		}
		
		public function decLife(x:int):IPerson
		{
			var xx:int = x;
			this._life -= x;
			this._battlelust = this._battlelust > Util.Constants.getMinBattleLust() ? 
				this._battlelust - 1 : Util.Constants.getMinBattleLust();
			for each(var z:IPerson in _persons) {
				z.setBattleLust(this._battlelust);
			}
			if (this._life <= 0) {
				return this.setDead();
			}
			while (x) {
				var flag:Boolean = false;
				for (var index:int = 0; index < this._persons.length && x > 0; index++) {
					if (this._persons[index].getLife() > 1) {
						this._persons[index].decLife(1);
						x--;
						flag = true;
					}
				}
				if (flag == false) break;
			}
			
			if (x >= 0) {
				var i:int;
				for (i = 0; i < this._persons.length && x > 0; i++) {
					if (this._persons[i].isHero() == false) {
						this._persons[i].setDead();
						x--;
					}
				}
				
				this._persons.sort(function(person1:IPerson, person2:IPerson):int {
					return person1.getLife() - person2.getLife();
				});
				while(this._persons.length > 0) {
					if(!this._persons[0].isLive())
					{
						var person:IPerson = this._persons.shift();
						person.setDead();
					} else {
						break;
					}
				}
			}
			
			return this;
		}
		
		public function getAlliance():IPerson
		{
			return this;
		}
		
		public function setAlliance(person:IPerson):IPerson
		{
			return this;
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
	}
}