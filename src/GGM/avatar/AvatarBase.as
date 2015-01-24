package GGM.avatar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	import GGM.panel.UserHpBar;
	
	import Person.Alliance;
	import Person.CalmPerson;
	import Person.CrazyAttackPerson;
	import Person.IPerson;
	import Person.Person;
	import Person.Step;
	import Person.TimidPerson;
	
	import morn.core.components.Label;
	
	/**
	 * 人物基础类 
	 * @author LionelZhangz
	 * 
	 */	
	public class AvatarBase extends Sprite
	{
		
		/**
		 * 死亡后被删除 
		 */		
		public static const DEL_CAZ_DIE:String = "DEL_CAZ_DIE";
		
		/**
		 * 加入队伍后被删除 
		 */		
		public static const DEL_CAZ_JOIN_TEAM:String = "DEL_CAZ_JOIN_TEAM";
		
		/**
		 * 疯狂攻击人物 
		 */		
		public static const PERSON_TYPE_CRAZY_ATTACK:String = "PERSON_TYPE_CRAZY_ATTACK";
		/**
		 * 冷静的人物
		 */
		public static const PERSON_TYPE_CALM:String = "PERSON_TYPE_CALM";
		/**
		 * 软弱的人物
		 */
		public static const PERSON_TYPE_TIMID:String = "PERSON_TYPE_TIMID";
		
		public function AvatarBase(res:BitmapData,moveStep:int,type:String,nickName:String,width:int = -1,height:int = -1)
		{
			avatar = new Bitmap(res);
			
			if(width != -1)
				avatar.width = width;
			if(height != -1)
				avatar.height = height;
			
			underAttackImg = new Bitmap(new BitmapData(5,5,false,0xff0000));
			this.addChild(underAttackImg);
			underAttackImg.y = avatar.y - underAttackImg.height;
			underAttackImg.visible = false;
			
			this.moveStep = moveStep;
			
			this.addChild(avatar);
			
			this.perType = type;
			
			//判断人物类型
			_checkType(type);
			
			this.nickName = nickName;
			
			this.isTeam = false;
			
			this.txtUserName = new Label(this.nickName);
			this.txtUserName.color = 0xff0000;
			this.txtUserName.size = 12;
			this.txtUserName.filters = [new GlowFilter(0xffff00)];
			this.addChild(this.txtUserName);
			this.txtUserName.y = this.avatar.y - this.txtUserName.height;
			this.txtUserName.x = (avatar.width - this.txtUserName.width)>>1;
			
			txtUserName.toolTip = "nickName:" +  this.nickName + "\n Power:" + perData.getPower();
			
			_userHpBar = new UserHpBar(10);
			this.addChild(_userHpBar);
			this._userHpBar.x = (avatar.width - this._userHpBar.width)>>1;
			this._userHpBar.y = this.txtUserName.y - this._userHpBar.height +7;
			
			//同意图标
			_agreeIcon = new Bitmap(new BitmapData(5,10,false,0x00ff00));
			_agreeIcon.visible =false;
			this.addChild(_agreeIcon);
			
			//拒绝图标
			_refusalIcon = new Bitmap(new BitmapData(5,10,false,0xff0000));
			_refusalIcon.visible =false;
			this.addChild(_refusalIcon);
			
			_agreeIcon.x = this.avatar.width/2;
			_agreeIcon.y = _userHpBar.y - _agreeIcon.height;
			
			this.perData.setBitmapData(res);
			this.perData.setName(nickName);
		}
		
		/**
		 * 判断人物类型 
		 * @param type
		 * 
		 */		
		private function _checkType(type:String):void
		{
			switch(type)
			{
				//疯狂攻击
				case AvatarBase.PERSON_TYPE_CRAZY_ATTACK:
				{
					this.perData = new CrazyAttackPerson();
				}
					break;
				//冷静
				case AvatarBase.PERSON_TYPE_CALM:
				{
					this.perData = new CalmPerson();
				}
					break;
				//懦弱
				case AvatarBase.PERSON_TYPE_TIMID:
				{
					this.perData = new TimidPerson();
				}
					break;
			}
		}
		
		private var _step:Person.Step = new Person.Step();
		public function get Step():Person.Step
		{
			return this._step;
		}
		
		/**
		 * 人物类型 
		 */		
		public var perType:String;
		
		/**
		 * 人物图像 
		 */		
		public var avatar:Bitmap;
		
		/**
		 * 步长 
		 */		
		public var moveStep:int;
		
		/**
		 * 被删除的情况 
		 */		
		public var _delType:String = "default";
		
		/**
		 * 人物名称 
		 */		
		public var nickName:String;
		
		/**
		 * 人物数据 
		 */		
		public var perData:IPerson;
		
		/**
		 * 被谁杀死的 
		 */		
		public var killByWho:String;
		
		/**
		 * 头顶标签 
		 */		
		private var txtUserName:Label;
		
		/**
		 * 头顶血条 
		 */		
		private var _userHpBar:UserHpBar;
		
		/**
		 * 头顶图标 
		 */		
		private var _agreeIcon:Bitmap;
		
		/**
		 * 头顶图标 
		 */		
		private var _refusalIcon:Bitmap;
		
		
		/**
		 * 是否是个团队 
		 */
		private var _isTeam:Boolean;
		
		public function get isTeam():Boolean
		{
			return _isTeam;
		}
		
		/**
		 * @private
		 */
		public function set isTeam(value:Boolean):void
		{
			_isTeam = value;
			
			//如果变成一个团队的话
			if(_isTeam)
			{
				var tempPerson:IPerson = this.perData;
				this.perData = null;
				
				//生成团队
				this.perData = new Alliance();
				
				//把自己的数据添加进去
				this.perData.doAlign(tempPerson);
			}
		}
		
		
		/**
		 * 被攻击时的图片 
		 */		
		public var underAttackImg:Bitmap= new Bitmap();
		
		
		override public function get width():Number
		{
			return avatar.width;
		}
		
		override public function get height():Number
		{
			return avatar.height;
		}
		
		/**
		 * 设置人物数据 
		 * @param perData
		 * 
		 */		
		public function setPerData(data:Object):void
		{
			this.perData.setLife(data.life);
			this.perData.setAlign(data.align);
			this.perData.setEndurance(data.endurance);
			this.perData.setPower(data.power);
			this.perData.setSpeed(data.speed);
			this.perData.setBattleLust(data.lust);
			if(data.isHero)
			{
				this.perData.setHero();
			}
		}
		
		public function updatehpBar():void
		{
			this._userHpBar.setNowVal(this.perData.getLife()/10);
			
			this._userHpBar.x = (avatar.width - this._userHpBar.width)>>1;
		}
		
		/**
		 * 改变状态 
		 * 
		 */		
		public function changeState(state:int):void
		{
			switch(state)
			{
				case 1:
				{
					this._agreeIcon.visible =true;
					this._refusalIcon.visible = false;
				}
					break;
				case 2:
				{
					this._agreeIcon.visible = false;
					this._refusalIcon.visible = true;
				}
					break;
				case 0:
				{
					this._agreeIcon.visible = false;
					this._refusalIcon.visible = false;
				}
			}
		}
		
	}
}