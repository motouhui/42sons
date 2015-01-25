package
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import GGM.avatar.AvatarBase;
	import GGM.panel.MapPanel;
	import GGM.panel.MaskPanel;
	import GGM.panel.PlayerInfoView;
	import GGM.panel.RetryPanel;
	import GGM.skin.AvatarSkin;
	import GGM.skin.GameSkin;
	import GGM.util.AvatarMoveUtil;
	import GGM.util.GameStageData;
	import GGM.util.MoveOutInUtil;
	import GGM.util.PlayerBattleUtil;
	
	import Util.Constants;
	import Util.Util;
	
	import morn.core.components.Button;
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
		private var _lblGameOver:Bitmap;
		/**
		 * 游戏结束文字 
		 */		
		private var _lblWin:Bitmap;
		
		/**
		 * 玩家战斗处理类 
		 */		
		private var _playerBattleUtil:PlayerBattleUtil;
		
		private var _weiboMe:Object; // init args group generated by weibo info
		private var _weiboPlayers:Array;  // init args groups array generated by weibo info
		private var _englishNames:Vector.<String>;
		
		/**
		 * 开始游戏面板 
		 */		
		private var _gameStartPanel:Sprite = new Sprite();
		
		public function GlobalGameJam()
		{
			App.init(this);
			
//			MonsterDebugger.initialize(this);
			
			App.asset.cacheBitmapData("button",GameSkin.button_bitmapdata);
			App.asset.cacheBitmapData("button_weibo",GameSkin.button_weibo_bitmapdata);
			App.asset.cacheBitmapData("button_guest",GameSkin.button_guest_bitmapdata);
			
			_englishNames = Util.Util.getRandomItemFormVector(Util.Constants.ENGLISH_NAMES, 50);
			
			_gameStartPanel.addChild(new Bitmap(GameSkin.startBg_bitmapdata));
			
			var startButton:Button = new Button();
			startButton.skin = "button_weibo";
			startButton.width = 180;
			startButton.height = 60;
			startButton.x = 400 - startButton.width / 2;
			startButton.y = 340 - startButton.height / 2;
			_gameStartPanel.addChild(startButton);
			startButton.addEventListener(MouseEvent.CLICK, startButtonEventHandler);
			
			var guestButton:Button = new Button();
			guestButton.skin = "button_guest";
			guestButton.width = 180;
			guestButton.height = 60;
			guestButton.x = startButton.x;
			guestButton.y = startButton.y + startButton.height + 30;
			guestButton.addEventListener(MouseEvent.CLICK, guestButtonEventHandler);
			
			_gameStartPanel.addChild(guestButton);
			this.addChild(_gameStartPanel);
		}
		
		private function startButtonEventHandler(event:MouseEvent):void
		{
			// 拉取微博数据
			var chaos:Chaos = new Chaos(genesisCallback);
		}
		
		private function guestButtonEventHandler(event:MouseEvent):void
		{
			// 随机拼装数据
			
			var guestHeroGroup:Object = generateRandomArgsGroup(49);
			var guestPlayerGroups:Array = new Array();
			for (var i:int = 0; i < 41; i++) {
				guestPlayerGroups.push(generateRandomArgsGroup(i));
			}
			genesisCallback(guestHeroGroup, guestPlayerGroups);
		}
		
		private function generateRandomArgsGroup(i:int):Object
		{
			return {
				avatar:int(Math.random() * 45),
				speed:int(Math.random() * 5 + 1),
				type:AvatarBase.getPlayerTypeByNumber(int(Math.random() * 3)),
					name:_englishNames[i]
			};
		}
		
		private function genesisCallback(hero, players:Array):void
		{
			_weiboMe = hero;
			_weiboPlayers = players
			
			
			_keyDownDict = new Dictionary();
			
			this._gameStartPanel.visible = false;
			
			_mapSpr = new MapPanel();
			this.addChild(_mapSpr);
			
			
			this._playerInfo= new PlayerInfoView();
			this.addChild(_playerInfo);
			
			_mapSpr.y = _playerInfo.y + _playerInfo.height;
			
			//初始化数据
			initData(players);
			
			
			App.stage.addEventListener(KeyboardEvent.KEY_DOWN,_pushKeyHandler);
			App.stage.addEventListener(KeyboardEvent.KEY_UP,_keyUphandler);
			
			this.addEventListener(Event.ENTER_FRAME,_enterFrameHandler);
			
			_retryPanel = new RetryPanel();
			this.addChild(_retryPanel);
			_retryPanel.visible = false;
			_retryPanel.x = (800 - _retryPanel.width)/2;
			_retryPanel.y = (550 - _retryPanel.height)/2;
			
			_lblGameOver = new Bitmap(GameSkin.gameover_btmapdata);
			_lblGameOver.x = (800 - _lblGameOver.width)>>1;
			_lblGameOver.y = (550 - _lblGameOver.height)>>1;
			_lblGameOver.visible = false;
			this.addChild(_lblGameOver);
			
			_lblWin = new Bitmap(GameSkin.youwin_btmapdata);
			_lblWin.x = (800 - _lblWin.width)>>1;
			_lblWin.y = (550 - _lblWin.height)>>1;
			_lblWin.visible = false;
			this.addChild(_lblWin);
			
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
			
			
			_hero = new AvatarBase(
				AvatarSkin.AVATAR_LIST[_weiboMe.avatar],
				_weiboMe.speed,
				_weiboMe.type,
				_weiboMe.name,
				24,36
			);
			
			//初始化玩家战斗类
			_playerBattleUtil = new PlayerBattleUtil(_hero,this._playerInfo,this.playGameOver);
			
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
						align:int(Math.random() * Util.Constants.MAX_PERSON_ALIGN + 1),
						endurance:int(Math.random() * Util.Constants.MAX_PERSON_ENDURANCE + 1),
						power:int(Math.random() * Util.Constants.MAX_PERSON_ATTACK + 1),
						speed:int(Math.random() * Util.Constants.MAX_PERSON_SPEED + 1),
						lust:int(Math.random()*2 + 8)
					});
				
				player.updatehpBar();
				
				
				_playerList.push(player);
				
				//清空消息
				_playerInfo.noticePanel.clearNotice();
				
			}
			
			
			_hero.x =200;//(this.width - _hero.width)>>1;
			_hero.y = 200;//(this.height - _hero.height)>>1;
			
			_hero.setPerData({
				life:100,
				align:int(Math.random() * Util.Constants.MAX_PERSON_ALIGN + 1),
				endurance:int(Math.random() * Util.Constants.MAX_PERSON_ENDURANCE + 1),
				power:int(Math.random() * Util.Constants.MAX_PERSON_ATTACK + 1),
				speed:int(Math.random() * Util.Constants.MAX_PERSON_SPEED + 1),
				lust:int(Math.random() * 2 + 8),
				isHero:true
			});
			
			_hero.updatehpBar();
			
			_playerInfo.setNowHp(_hero.perData.getLife());
			
			_refreshLookAt();
			
			//刷新血量上限
			_playerInfo.refreshMaxHp();
			
			_playerInfo.setLeftPerson(_playerList.length + 1);
			
			_playerInfo.updateTeamList(_hero);
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
						"player<font size='14' color='#ffffff'>" + 
						avatar.nickName + 
						"</font> killed by <font size='14' color='#ffffff'>" + avatar.killByWho + "</font>");
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
		
		private var maskPanel:MaskPanel;
		
		/**
		 * 
		 */		
		private var _spr:Sprite;
		
		/**
		 * 遮罩图片 
		 */		
		private var mist:Bitmap;
		/**
		 * 刷新视野 
		 * 
		 */		
		private function  _refreshLookAt():void
		{
			if(!_spr)
			{
				_spr = new Sprite();
				
				_spr.graphics.beginFill(0,1);
				_spr.graphics.drawCircle(
					0,0,
					142);
				_spr.graphics.endFill();
				
				
				mist= new Bitmap(GameSkin.mist_bitmapdata);
				
				mist.width = 320;
				mist.height = mist.width;
				
				mist.cacheAsBitmap = true;
				
				this.addChildAt(mist,2);
				
				_spr.cacheAsBitmap = true;
				this.addChildAt(_spr,0);
				//				maskPanel.cacheAsBitmap = true;
				
			}
			
			_spr.x = _hero.x+ _hero.width/2;
			_spr.y = _hero.y + _hero.height/2 + 50;
			
			mist.x = _hero.x - _hero.width/2 - 140;
			mist.y =  _hero.y - _hero.height/2 - 70;
			
			_mapSpr.drawMask(_spr);
		}
	}
}