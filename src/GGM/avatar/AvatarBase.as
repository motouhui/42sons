package GGM.avatar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import Person.Alliance;
	import Person.CrazyAttackPerson;
	import Person.IPerson;
	
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
			}
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
		public var _delType:String;
		
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
		
		/**
		 * 是否在被攻击？ 
		 * @param isAttack
		 * @return 
		 * 
		 */		
		public function setUnderAttack(isAttack:Boolean):void
		{
			underAttackImg.visible = isAttack;
		}
		
	}
}