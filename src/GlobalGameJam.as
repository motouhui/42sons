package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
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
	
	import Person.Alliance;
	import Person.IPerson;
	
	import Util.Util;
	
	import morn.core.components.Label;
	
	[SWF(width="800",height="600",backgroundColor="0")]
	public class GlobalGameJam extends Sprite
	{
		
		/**
		 * 视野 
		 */		
		private static const LOOK_AT_RANGE:int = 100;
		
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
		
		public function GlobalGameJam()
		{
			App.init(this);
			
			App.asset.cacheBitmapData("button",GameSkin.button_bitmapdata);
			
			_hero = new AvatarBase(GameSkin.avatar_bitmapdata,2,AvatarBase.PERSON_TYPE_CRAZY_ATTACK,"SNAKE",24,36);
			
			
			_keyDownDict = new Dictionary();
			
			_mapSpr = new MapPanel();
			this.addChild(_mapSpr);
			
			
			this._playerInfo= new PlayerInfoView();
			this.addChild(_playerInfo);
			
			_mapSpr.y = _playerInfo.y + _playerInfo.height;
			
			//初始化数据
			initData();
			
			
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
		private function initData():void
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
			
			_hero.filters = [new GlowFilter(0x00ff00)];
			
			_mapSpr.filters = null;
			_mapSpr.addChild(_hero);
			
			for(i = 0 ;i < 200; i++)
			{
				var player:AvatarBase = new AvatarBase(
					AvatarSkin.AVATAR_LIST[i % 45],
					int(Math.random()*5 + 1),
					AvatarBase.PERSON_TYPE_CRAZY_ATTACK,
					"刘德华"+i,
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
			_hero.setUnderAttack(false);
			
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
			
			initData();
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
			}
			if(this._keyDownDict[Keyboard.RIGHT]== true||this._keyDownDict[Keyboard.D] == true)
			{
				AvatarMoveUtil.getPlayerMovePoint(
					_hero,"right");
				ischange = true;
			}
			
			//刷新视野
			if(ischange == true)
				_refreshLookAt();
			
			if(ischange == true)
			{
				//刷新人物的移动范围
				for each( var player:AvatarBase in _playerList)
				{
					var rand:int = Math.random() * 4;
					switch(rand)
					{
						case 0:
						{
							AvatarMoveUtil.getPlayerMovePoint(
								player,"up");
						}
							break;
						case 1:
						{
							AvatarMoveUtil.getPlayerMovePoint(
								player,"down");
						}
							break;
						case 2:
						{
							AvatarMoveUtil.getPlayerMovePoint(
								player,"left");
						}
							break;
						case 3:
						{
							AvatarMoveUtil.getPlayerMovePoint(
								player,"right");
						}
							break;
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
			this._playerList.push(_hero);
			
			this._playerInfo.setNowHp(_hero.perData.getLife());
			
			//结盟的列表
			var alignDict:Dictionary = new Dictionary();;
			
			var i:int,j:int;
			for(i = 0;i < this._playerList.length ;i++)
			{
				for(j = 0 ; j < this._playerList.length ;j++)
				{
					if(i == j)
					{
						continue;
					}
					
					var firPer:AvatarBase = this._playerList[i];
					//已经阵亡，无需计算
					if(!firPer.perData.isLive())
					{
						continue;
					}
					var secPer:AvatarBase = this._playerList[j];
					
					if(!secPer.perData.isLive())
					{
						continue;
					}
					
					firPer.setUnderAttack(false);
					secPer.setUnderAttack(false);
					
					//判断是否结盟了
					var isAlign:Boolean = false;
					
					//其中一个人已经加入团队要被删除，后面的人不需要再跟他比对了
					if(firPer._delType == AvatarBase.DEL_CAZ_JOIN_TEAM || secPer._delType == AvatarBase.DEL_CAZ_JOIN_TEAM)
					{
						continue;
					}
					if(alignDict[firPer.nickName + "_" + secPer.nickName] != true)
					{
						//判断是否在视野内
						if(Util.Util.inView(firPer.x,firPer.y,secPer.x ,secPer.y,LOOK_AT_RANGE))
						{
							//个人对个人判断是否要结盟
							if(!firPer.isTeam&&!secPer.isTeam)
							{
								if(firPer.perData.judgeAlign(secPer.perData))
								{
									//主角永远是队长
									if(secPer == _hero)
									{
										secPer.isTeam = true;
										
										firPer._delType = AvatarBase.DEL_CAZ_JOIN_TEAM;
										firPer.killByWho = secPer.nickName;
										//添加到需要删除的队列里面
										needRemovePersonIndexList.push(firPer);
										
										//添加团队数据
										secPer.perData.doAlign(firPer.perData);
									}
									else
									{
										
										firPer.isTeam = true;
										
										secPer._delType = AvatarBase.DEL_CAZ_JOIN_TEAM;
										secPer.killByWho = secPer.nickName;
										
										//添加到需要删除的队列里面
										needRemovePersonIndexList.push(secPer);
										
										//添加团队数据
										firPer.perData.doAlign(secPer.perData);
										
									}
									
									//结盟
									_playerInfo.noticePanel.addNotice(
										"player <font size='14' color='#0xffffff'>" + 
										firPer.nickName + " AND player <font size='14' color='#0xffffff'>" +
										secPer.nickName + " align");
									
									alignDict[firPer.nickName + "_" + secPer.nickName] = true;
									alignDict[secPer.nickName + "_" + firPer.nickName] = true;
									
									isAlign = true;
								}
							}
								//团队与团队之间
							else if(firPer.isTeam && secPer.isTeam)
							{
								if(secPer.perData.judgeAlign(firPer.perData))
								{
//									if(secPer == _hero)
//									{
//										secPer.perData.doAlign(firPer.perData);
//									}
//									else
//									{
//										firPer.perData.doAlign(secPer.perData);
//									}
									isAlign = true;
									
									alignDict[firPer.nickName + "_" + secPer.nickName] = true;
									alignDict[secPer.nickName + "_" + firPer.nickName] = true;
								}
							}
							else
							{
								//如果第一个是团队
								if(firPer.isTeam)
								{
									if(firPer.perData.judgeAlign(secPer.perData))
									{
										if(secPer == _hero)
										{
											secPer.isTeam = true;
											
											//如果主角碰到团队，是他把团队吸纳过来，而不是团队吸纳他
											for each(var perData:IPerson in Alliance(firPer.perData).getMembers())
											{
												secPer.perData.doAlign(perData);
											}
											firPer._delType = AvatarBase.DEL_CAZ_JOIN_TEAM;
											
											//添加到需要删除的队列里面
											needRemovePersonIndexList.push(firPer);
										}
										else
										{
											firPer.perData.doAlign(secPer.perData);
											
											secPer._delType = AvatarBase.DEL_CAZ_JOIN_TEAM;
											
											//添加到需要删除的队列里面
											needRemovePersonIndexList.push(secPer);
										}
										
										isAlign = true;
										
										alignDict[firPer.nickName + "_" + secPer.nickName] = true;
										alignDict[secPer.nickName + "_" + firPer.nickName] = true;
									}
								}
								else if(secPer.isTeam)
								{
									
									if(secPer.perData.judgeAlign(firPer.perData))
									{
										if(firPer == _hero)
										{
											firPer.isTeam = true;
											
											//如果主角碰到团队，是他把团队吸纳过来，而不是团队吸纳他
											for each(var secPerData:IPerson in Alliance(secPer.perData).getMembers())
											{
												firPer.perData.doAlign(secPerData);
											}
											secPer._delType = AvatarBase.DEL_CAZ_JOIN_TEAM;
											
											//添加到需要删除的队列里面
											needRemovePersonIndexList.push(secPer);
										}
										else
										{
											secPer.perData.doAlign(firPer.perData);
											
											firPer._delType = AvatarBase.DEL_CAZ_JOIN_TEAM;
											
											//添加到需要删除的队列里面
											needRemovePersonIndexList.push(firPer);
											
											isAlign = true;
											
											alignDict[firPer.nickName + "_" + secPer.nickName] = true;
											alignDict[secPer.nickName + "_" + firPer.nickName] = true;
										}
									}
								}
							}
							
							//如果前面联盟过的话先不进行攻击，等到下一回合
							if(!isAlign)
							{
								//如果要进行攻击
								if(firPer.perData.judgeAttack(secPer.perData))
								{
									//判断是否两个人已经碰上了
									if(Util.Util.cross(firPer.x,firPer.y,5,secPer.x ,secPer.y,5))
									{
										var beforeFirPerLife:int = firPer.perData.getLife();
										var beforeSecPerLife:int = secPer.perData.getLife();
										firPer.perData.doAttack(secPer.perData);
										
										//在小人头上显示掉血标记
										if(beforeFirPerLife != firPer.perData.getLife())
										{
											if(firPer.nickName == _hero.nickName)
											{
												_mapSpr.filters=[new GlowFilter(0xff0000,1,6,6,10)];
											}
											firPer.setUnderAttack(true);
										}
										
										if(beforeSecPerLife != secPer.perData.getLife())
										{
											if(secPer.nickName == _hero.nickName)
											{
												_mapSpr.filters=[new GlowFilter(0xff0000,1,6,6,10)];
											}
											secPer.setUnderAttack(true);
										}
										
										//如果参与战争的人当中有玩家则要去设置血条
										if(_hero == firPer || _hero == secPer)
										{
											this._playerInfo.setNowHp(_hero.perData.getLife());
										}
										
										//第一个角色阵亡
										if(!firPer.perData.isLive())
										{
											//主角死亡game over
											if(firPer == _hero)
											{
												this.playGameOver();
												return;
											}
											firPer._delType = AvatarBase.DEL_CAZ_DIE;
											firPer.killByWho = secPer.nickName;
											needRemovePersonIndexList.push(firPer);
										}
										
										//第二个角色阵亡
										if(!secPer.perData.isLive())
										{
											//主角死亡game over
											if(secPer == _hero)
											{
												this.playGameOver();
												return;
											}
											secPer._delType = AvatarBase.DEL_CAZ_DIE;
											secPer.killByWho = firPer.nickName;
											needRemovePersonIndexList.push(secPer);
										}
									}
										//否则就追杀他
									else
									{
										
									}
									
								}
							}
						}
					}
				}
			}
			
			//如果主角还没死先把主角加回来
			_playerList.splice(_playerList.indexOf(this._hero),1);
			
			//移除失败者
			_removeLoser(needRemovePersonIndexList);
			
			//更新血条
			for each(var avatarBase:AvatarBase in _playerList)
			{
				avatarBase.updatehpBar();
			}
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
						"player<font size='30' color='#0xffffff'>" + 
						avatar.nickName + 
						"</font> killed by <font size='30' color='#0xffffff'>" + avatar.killByWho + "</font>");
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