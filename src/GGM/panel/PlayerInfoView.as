package GGM.panel
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import GGM.avatar.AvatarBase;
	import GGM.skin.GameSkin;
	
	import Person.Alliance;
	import Person.IPerson;

	/**
	 * 用户信息面板 
	 * @author LionelZhangz
	 * 
	 */	
	public class PlayerInfoView extends Sprite
	{
		
		public function PlayerInfoView()
		{
			
			_bg = new Bitmap(GameSkin.playerinfoBg_bitmapdata);
			_bg.width = 800;
			_bg.height = 50;
			this.addChild(_bg);
			
			avatar = new Bitmap(GameSkin.avatar_bitmapdata);
			this.addChild(avatar);
			avatar.width = 25;
			avatar.height = 50;
			
			hpBar = new ProcessBar(100);
//			this.addChild(hpBar);
			
			hpBar.x = avatar.width;
			hpBar.y = 3;
			
			hpBar.setNowVal(50);
			
			noticePanel = new NoticePanel();
			
			noticePanel.x = 350;
			noticePanel.y = 20;
			this.addChild(noticePanel);
			
			leftPlayerTxt = new TextField();
			this.addChild(leftPlayerTxt);
			leftPlayerTxt.x = hpBar.x + hpBar.width + 10;
			leftPlayerTxt.filters = [new GlowFilter(0)]
			leftPlayerTxt.y = 30;
			leftPlayerTxt.x = 750 ;
			
			_teamInfoList = new Vector.<AvatarInfo>(3,true);
			
			for(var i:int =0 ;i < _teamInfoList.length ; i++)
			{
				_teamInfoList[i] = new AvatarInfo();
				_teamInfoList[i].visible = false;
				this.addChild(_teamInfoList[i]);
			}
			
			
		}
		
		/**
		 * 头像 
		 */		
		private var avatar:Bitmap;
		
		/**
		 * 背景条 
		 */		
		private var _bg:Bitmap;
		
		/**
		 * 信息面板 
		 */		
		public var noticePanel:NoticePanel;
		
		/**
		 * 血条 
		 */		
		private var hpBar:ProcessBar;
		
		/**
		 * 剩下玩家的数量文字 
		 */		
		private var leftPlayerTxt:TextField;
		
		/**
		 * 队伍人物数据 
		 */		
		private var _teamInfoList:Vector.<AvatarInfo>;
		
		override public function get height():Number
		{
			return _bg.height;
		}
		
		public function setNowHp(val:int):void
		{
//			trace(val);
			this.hpBar.setNowVal(val < 0?0:val);
		}
		
		public function refreshMaxHp():void
		{
			this.hpBar.refreshMaxVal();
		}
		
		/**
		 * 设置剩余人数 
		 * @param val
		 * 
		 */		
		public function setLeftPerson(val:int):void
		{
			leftPlayerTxt.htmlText = "<font size='12' color='#ffffff'>left:</font><font size='12' color='#00ff00'>" + val + "</font>"
		}
		
		/**
		 * 更新 队伍列表数据
		 * @param hero
		 * 
		 */		
		public function updateTeamList(hero:AvatarBase):void
		{
			var i:int;
			if(hero.perData is Alliance)
			{
				var data:Vector.<IPerson> = Alliance(hero.perData).getMembers();
				
				for(i = 0 ; i < _teamInfoList.length;i++)
				{
					if(i >= data.length)
					{
						_teamInfoList[i].visible = false;
					}
					else
					{
						_teamInfoList[i].setData(data[i]);
						_teamInfoList[i].visible = true;
						_teamInfoList[i].x = i* (_teamInfoList[i].width + 5);
						_teamInfoList[i].y = 0;
					}
				}
			}
			else
			{
				for(i = 0 ; i < _teamInfoList.length;i++)
				{
					if(i >= 1)
					{
						_teamInfoList[i].visible = false;
					}
					else
					{
						_teamInfoList[i].setData(hero.perData);
						_teamInfoList[i].visible = true;
						_teamInfoList[i].x = i* (_teamInfoList[i].width + 5);
						_teamInfoList[i].y = 0;
					}
				}
			}
		}
		
	}
}