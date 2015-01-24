package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import GGM.avatar.AvatarBase;
	import GGM.panel.MapPanel;
	import GGM.panel.PlayerInfoView;
	import GGM.panel.RetryPanel;
	import GGM.skin.AvatarSkin;
	import GGM.skin.GameSkin;
	import GGM.util.AvatarMoveUtil;
	import GGM.util.GameStageData;
	import GGM.util.MoveOutInUtil;
	import GGM.util.PlayerBattleUtil;
	
	import Util.Util;
	
	import morn.core.components.Label;
	
	[SWF(width="800",height="600",backgroundColor="0")]
	public class GlobalGameJam extends Sprite
	{
		
		/**
		 * 视野 
		 */		
		public static const LOOK_AT_RANGE:int = 100;
		
		/**
		 * 主角
		 */		
		private var _hero:AvatarBase;
		
		/**
		 * 按键按下的列表 
		 */		
		private var _keyDownDict:Dictionary;
		
		/**
		 * 玩家列表 
		 */		
		private var _playerList:Vector.<AvatarBase>;
		
		/**
		 * 用户信息面板 
		 */		
		private var _playerInfo:PlayerInfoView;
		
		/**
		 * 重试面板 
		 */		
		private var _retryPanel:RetryPanel;
		
		/**
		 * 遮罩层 
		 */		
		private var _mapSpr:MapPanel;
		
		/**
		 * 游戏结束文字 
		 */		
		private var _lblGameOver:Label;
		/**
		 * 游戏结束文字 
		 */		
		private var _lblWin:Label;
		
		/**
		 * 玩家战斗处理类 
		 */		
		private var _playerBattleUtil:PlayerBattleUtil;
		
		private var _weiboMe:Object; // init args group generated by weibo info
		private var _weiboPlayers:Array;  // init args groups array generated by weibo info
		
		public function GlobalGameJam()
		{
			App.init(this);
			
			App.asset.cacheBitmapData("button",GameSkin.button_bitmapdata);
			
			// 拉取微博数据
			var chaos:Chaos = new Chaos(genesisCallback);
			
		}
		
		private function genesisCallback(hero, players:Array):void
		{
			_weiboMe = hero;
			_weiboPlayers = players
			
			_hero = new AvatarBase(
				AvatarSkin.AVATAR_LIST[_weiboMe.avatar],
				_weiboMe.speed,
				_weiboMe.type,
				_weiboMe.name,
				24,36
			);
			
			_keyDownDict = new Dictionary();
			
			_mapSpr = new MapPanel();
			this.addChild(_mapSpr);
			
			
			this._playerInfo= new PlayerInfoView();
			this.addChild(_playerInfo);
			
			_mapSpr.y = _playerInfo.y + _playerInfo.height;
			
			//初始化数据
			initData(players);
			
			//初始化玩家战斗类
			_playerBattleUtil = new PlayerBattleUtil(_hero,this._playerInfo,this.playGameOver);
			
			App.stage.addEventListener(KeyboardEvent.KEY_DOWN,_pushKeyHandler);
			App.stage.addEventListener(KeyboardEvent.KEY_UP,_keyUphandler);
			
			this.addEventListener(Event.ENTER_FRAME,_enterFrameHandler);
			
			_lblGameOver = new Label();
			_lblGameOver.size = 80;
			_lblGameOver.color = 0xff0000;
			_lblGameOver.text = "GAME OVER";
			_lblGameOver.x = (this.width - _lblGameOver.width)>>1;
			_lblGameOver.y = (this.height - _lblGameOver.height)>>1;
			_lblGameOver.visible = false;
			this.addChild(_lblGameOver);
			
			_lblWin = new Label();
			_lblWin.size = 80;
			_lblWin.color = 0xffffff;
			_lblWin.text = "YOU WIN?";
			_lblWin.x = (this.width - _lblWin.width)>>1;
			_lblWin.y = (this.height - _lblWin.height)>>1;
			_lblWin.visible = false;
			this.addChild(_lblWin);
			
			
			_retryPanel = new RetryPanel();
			this.addChild(_retryPanel);
			_retryPanel.visible = false;
			_retryPanel.x = (this.width - _retryPanel.width)>>1;
			_retryPanel.y = (this.height - _retryPanel.height)/2 - 20;
			
			
			//			playGameOver();
		}
		
		/**
		 * 初始化数据 
		 * 
		 */		
		private function initData(args:Array):void
		{
			//刷新边界
			refreshRange(800,550);
			
			var i:int;
			
			if(_playerList)
			{
				for(i = 0;i< _playerList.length ;i++ )
				{
					if(_mapSpr.contains(_playerList[i]))
						_mapSpr.removeChild(_playerList[i]);
				}
				_playerList.length = 0;
			}
			
			_playerList = new Vector.<AvatarBase>();
			
//			_hero.filters = [new GlowFilter(0x00ff00)];
			
			_mapSpr.filters = null;
			_mapSpr.addChild(_hero);
			
			for each(var group:Object in args)
			{
				trace(group.avatar, group.speed, group.type, group.name);
				
				var player:AvatarBase = new AvatarBase(
					AvatarSkin.AVATAR_LIST[group.avatar],
					group.speed,
					group.type,
					group.name,
					24,36
				);
				
				_mapSpr.addChild(player);
				player.x = Math.random() * 800;
				player.y = Math.random() * 500;
				
				player.setPerData(
					{
						life:100,
						align:int(Math.random() * 10),
						endurance:int(Math.random()*10),
						power:int(Math.random()*10),
						speed:int(Math.random()*10),
						lust:int(Math.random()*2 + 8)
					});
				
				
				_playerList.push(player);
				
				//清空消息
				_playerInfo.noticePanel.clearNotice();
				
			}
			
			
			_hero.x =200;//(this.width - _hero.width)>>1;
			_hero.y = 200;//(this.height - _hero.height)>>1;
			
			_hero.setPerData({
				life:100,
				align:int(Math.random() * 10),
				endurance:int(Math.random()*10),
				power:int(Math.random()*10),
				speed:int(Math.random()*10),
				lust:int(Math.random()*2 + 8),
				isHero:true
			});
			
			_hero.updatehpBar();
			
			_playerInfo.setNowHp(_hero.perData.getLife());
			
			_refreshLookAt();
			
			//刷新血量上限
			_playerInfo.refreshMaxHp();
			
			_playerInfo.setLeftPerson(_playerList.length + 1);
		}
		
		/**
		 * 播放游戏结束动画 
		 * 
		 */		
		private function playGameOver():void
		{
			_lblGameOver.y = -_lblGameOver.height;
			_lblGameOver.visible = true;
			
			var moveUtil:MoveOutInUtil = new MoveOutInUtil(_lblGameOver,700);
			moveUtil.movePanel(
				_lblGameOver.y,
				(this.height - _lblGameOver.height)/2,
				MoveOutInUtil.MOVE_BOTTOM);
			
			this._mapSpr.visible = false;
			
			this._hero.visible = false;
			
			_retryPanel.visible = true;
			
			_retryPanel.addEventListener(MouseEvent.CLICK,retryCilckHandler);
		}
		
		/**
		 * 播放游戏结束动画 
		 * 
		 */		
		private function playWin():void
		{
			_lblWin.y = -_lblWin.height;
			_lblWin.visible = true;
			
			var moveUtil:MoveOutInUtil = new MoveOutInUtil(_lblWin,700);
			moveUtil.movePanel(
				_lblWin.y,
				(this.height - _lblWin.height)/2,
				MoveOutInUtil.MOVE_BOTTOM);
			
			this._mapSpr.visible = false;
			
			this._hero.visible = false;
			
			_retryPanel.visible = true;
			
			_retryPanel.addEventListener(MouseEvent.CLICK,retryCilckHandler);
		}
		
		/**
		 * 重试 
		 * @param event
		 * 
		 */		
		protected function retryCilckHandler(event:MouseEvent):void
		{
			
			this._mapSpr.visible = true;
			
			this._hero.visible = true;
			
			_retryPanel.visible = false;
			
			_lblGameOver.visible = false;
			
			_lblWin.visible = false;
			
			initData(_weiboPlayers);
		}
		
		protected function _enterFrameHandler(event:Event):void
		{
			var ischange:Boolean= false;
			if(this._keyDownDict[Keyboard.UP]== true||this._keyDownDict[Keyboard.W] == true)
			{
				AvatarMoveUtil.getPlayerMovePoint(
					_hero,"up");
				ischange = true;
				
			}
			if(this._keyDownDict[Keyboard.DOWN]== true||this._keyDownDict[Keyboard.S] == true)
			{
				AvatarMoveUtil.getPlayerMovePoint(
					_hero,"down");
				ischange = true;
			}
			if(this._keyDownDict[Keyboard.LEFT]== true||this._keyDownDict[Keyboard.A] == true)
			{
				AvatarMoveUtil.getPlayerMovePoint(
					_hero,"left");
				ischange = true;
				_hero.avatar.bitmapData = Util.Util.flipBitmapData(_hero.BITMAP_DATA);
			}
			if(this._keyDownDict[Keyboard.RIGHT]== true||this._keyDownDict[Keyboard.D] == true)
			{
				AvatarMoveUtil.getPlayerMovePoint(
					_hero,"right");
				ischange = true;
				_hero.avatar.bitmapData = _hero.BITMAP_DATA;
			}
			
			//刷新视野
			if(ischange == true)
				_refreshLookAt();
			
			if(ischange == true)
			{
				//刷新人物的移动范围
				for each( var player:AvatarBase in _playerList)
				{
					var direction:Point = AvatarMoveUtil.getPlayerMovePoint2(player);
					if (direction.x > 0) { // right
						player.avatar.bitmapData = player.BITMAP_DATA;
					} else if (direction.x < 0) {
						player.avatar.bitmapData = Util.Util.flipBitmapData(player.BITMAP_DATA);
					}
				}
			}
			//判断人物关系进行更新
			if(ischange)
			{
				_checkBattleResult();
			}
		}
		
		private function _checkBattleResult():void
		{
			//需要移除的人物
			var needRemovePersonIndexList:Vector.<AvatarBase>= new Vector.<AvatarBase>();;
			
			//先把用着自己也加进去
			this._playerList.unshift(_hero);
			
			//玩家更新当前血量
			this._playerInfo.setNowHp(_hero.perData.getLife());
			
			//获取玩家与玩家之间的关系
			this._playerBattleUtil.getPlayersRelationShip(this._playerList);
			
			//根据关系表，处理出玩家与玩家之间的策略
			needRemovePersonIndexList =  this._playerBattleUtil.processWhenPlayerCross(this._playerList);
			
			//当前主角死了
			if(needRemovePersonIndexList == null)
			{
				return;
			}
			
			//如果主角还没死先把主角加回来
			_playerList.splice(_playerList.indexOf(this._hero),1);
			
			//移除失败者
			_removeLoser(needRemovePersonIndexList);
			
			//更新血条
			for each(var avatarBase:AvatarBase in _playerList)
			{
				avatarBase.updatehpBar();
				avatarBase.changeState(0);
			}
			
			//更新英雄的血条
			_hero.updatehpBar();
			
			_playerInfo.updateTeamList(_hero);
			
		}
		
		/**
		 * 移除失败者 
		 * 
		 */		
		private function _removeLoser(needRemovePersonIndexList:Vector.<AvatarBase>):void
		{
			for each(var avatar:AvatarBase in needRemovePersonIndexList)
			{
				//删除人
				_playerList.splice(_playerList.indexOf(avatar),1);
				
				if(avatar && _mapSpr.contains(avatar))
					_mapSpr.removeChild(avatar);
				
				//因为死亡而被删除才会显示死亡通知
				if(avatar._delType == AvatarBase.DEL_CAZ_DIE)
				{
					_playerInfo.noticePanel.addNotice(
						"player<font size='14' color='#0xffffff'>" + 
						avatar.nickName + 
						"</font> killed by <font size='14' color='#0xffffff'>" + avatar.killByWho + "</font>");
				}
				
				avatar = null;
			}
			
			_playerInfo.setLeftPerson(_playerList.length + 1);
			
			if(_playerList.length == 0)
			{
				playWin();
			}
		}
		
		protected function _keyUphandler(event:KeyboardEvent):void
		{
			
			_keyDownDict[event.keyCode]= false;
		}
		
		/**
		 * 刷新边界 
		 */		
		public function refreshRange(rangeW:int,rangeH:int):void
		{
			GameStageData.rangeWidth = rangeW;
			GameStageData.rangeHeight = rangeH;
			
			_mapSpr.refreshRange(rangeW,rangeH);
		}
		/**
		 * 按下按键 
		 * @param event
		 * 
		 */		
		protected function _pushKeyHandler(event:KeyboardEvent):void
		{
			_keyDownDict[event.keyCode] = true;
		}
		/**
		 * 刷新视野 
		 * 
		 */		
		private function  _refreshLookAt():void
		{
			var spr:Sprite = new Sprite();
			
			spr.graphics.beginFill(0,1);
			spr.graphics.drawCircle(
				_hero.x + _hero.width/2,
				_hero.y + _hero.height/2 + 50,
				LOOK_AT_RANGE);
			
			spr.graphics.endFill();
//			_mapSpr.drawMask(spr);
		}
	}
}