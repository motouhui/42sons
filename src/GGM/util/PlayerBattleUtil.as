package GGM.util
{
	import flash.utils.Dictionary;
	
	import GGM.avatar.AvatarBase;
	import GGM.panel.PlayerInfoView;
	
	import Person.Alliance;
	import Person.IPerson;
	
	import Util.Util;
	
	/**
	 * 玩家对垒的结果处理数据
	 * @author LionelZhangz
	 * 
	 */	
	public class PlayerBattleUtil
	{
		/**
		 * 未知状态 
		 */
		public static const STATE_UNKOWN:int = 0;
		
		/**
		 * 友好状态
		 */
		public static const STATE_FRIENDLY:int = 1;
		
		/**
		 * 敌对状态 
		 */		
		public static const STATE_BATTLE:int = 2;
		
		public function PlayerBattleUtil(hero:AvatarBase,playerInfo:PlayerInfoView,gameOverFunc:Function)
		{
			//初始化关系表
			_playerToPlayerDict = new Dictionary();
			
			//设置英雄
			this._hero = hero;
			
			//设置数据
			this._playerInfo = playerInfo;
			
			//设置游戏结束方法
			this._gameOverFunc = gameOverFunc;
		}
		
		/**
		 * 玩家关系网字典 
		 */		
		private static var _playerToPlayerDict:Dictionary;
		
		/**
		 * 游戏结束的方法 
		 */		
		private var _gameOverFunc:Function;
		
		/**
		 * 主角的数据 
		 */		
		private var _hero:AvatarBase;
		
		/**
		 * 显示消息用 
		 */		
		private var _playerInfo:PlayerInfoView;
		
		/**
		 * 设置当前俩人的关系 
		 * @param firKey
		 * @param secKey
		 * @param dict
		 * @param state
		 * 
		 */		
		public static function setRelation(firKey:String,secKey:String,state:int):void
		{
			_playerToPlayerDict[firKey + "_" + secKey] = state;
			_playerToPlayerDict[secKey + "_" + firKey] = state;
		}
		
		/**
		 * 检测当前两个玩家的关系 
		 * @param firKey
		 * @param secKey
		 * @param dict
		 * @return 
		 * 
		 */		
		public static function checkRealation(firKey:String,secKey:String):int
		{
			return _playerToPlayerDict[firKey + "_" + secKey];
		}
		
		
		/**
		 * 获取玩家关系网 
		 * 
		 */		
		public function getPlayersRelationShip(_playerList:Vector.<AvatarBase>):void
		{
			//获取所有玩家的关系表(友好，敌对，未知)
			var i:int,j:int;
			for(i = 0;i < _playerList.length ;i++)
			{
				for(j = 0 ; j < _playerList.length ;j++)
				{
					if(i == j)
					{
						continue;
					}
					
					var firPer:AvatarBase = _playerList[i];
					//					//已经阵亡，无需计算
					//					if(!firPer.perData.isLive())
					//					{
					//						continue;
					//					}
					var secPer:AvatarBase = _playerList[j];
					//					
					//					if(!secPer.perData.isLive())
					//					{
					//						continue;
					//					}
					//					
					//					//判断是否结盟了
					//					var isAlign:Boolean = false;
					//					
					//					//其中一个人已经加入团队要被删除，后面的人不需要再跟他比对了
					//					if(firPer._delType == AvatarBase.DEL_CAZ_JOIN_TEAM || secPer._delType == AvatarBase.DEL_CAZ_JOIN_TEAM)
					//					{
					//						continue;
					//					}
					//如果当前两个玩家的关系是处于未知状态
					if(_playerToPlayerDict[firPer.nickName + "_" + secPer.nickName] == PlayerBattleUtil.STATE_UNKOWN)
					{
						//判断是否在视野内
						if(Util.Util.inView(firPer.x,firPer.y,secPer.x ,secPer.y,GlobalGameJam.LOOK_AT_RANGE))
						{
							//如果愿意结盟则设置当前状态为友好状态否则则为敌对状态
							if(firPer.perData.judgeAlign(secPer.perData))
							{
								
								//设置友好状态
								PlayerBattleUtil.setRelation(
									firPer.nickName,
									secPer.nickName,
									PlayerBattleUtil.STATE_FRIENDLY);
							}
							else
							{
								//设置敌对状态
								PlayerBattleUtil.setRelation(
									firPer.nickName,
									secPer.nickName,
									PlayerBattleUtil.STATE_BATTLE);
							}
						}
					}
					else
					{
						//如果当前两个玩家的状态不是未知，那在视野外之后要重置状态为未知
						if(!Util.Util.inView(firPer.x,firPer.y,secPer.x ,secPer.y,GlobalGameJam.LOOK_AT_RANGE))
						{
							//设置未知状态
							PlayerBattleUtil.setRelation(
								firPer.nickName,
								secPer.nickName,
								PlayerBattleUtil.STATE_UNKOWN);
						}
					}
				}
			}
		}
		
		/**
		 * 处理当玩家相遇的的问题 
		 * 
		 */		
		public function processWhenPlayerCross(_playerList:Vector.<AvatarBase>):Vector.<AvatarBase>
		{
			var needRemovePersonIndexList:Vector.<AvatarBase> = new Vector.<AvatarBase>();
			
			var i:int,j:int;
			for(i = 0;i < _playerList.length ;i++)
			{
				for(j = 0 ; j < _playerList.length ;j++)
				{
					if(i == j)
					{
						continue;
					}
					var firPer:AvatarBase = _playerList[i];
					var secPer:AvatarBase = _playerList[j];
					
					//如果两军见面了
					if(Util.Util.cross(firPer.x,firPer.y,5,secPer.x ,secPer.y,5))
					{
						
						//获取两个玩家的关系
						var state:int = PlayerBattleUtil.checkRealation(
							firPer.nickName,
							secPer.nickName
						);
						
						//如果两个玩家的关系为友好则结盟
						if(state == PlayerBattleUtil.STATE_FRIENDLY)
						{
							//如果个人对个人
							if(!firPer.isTeam&&!secPer.isTeam)
							{
								//英雄永远是主动的
								var tempFirPer:AvatarBase = secPer == _hero?secPer:firPer;
								var tempSecPer:AvatarBase = secPer == _hero?firPer:secPer;
								
								tempFirPer.isTeam = true;
								tempSecPer._delType = AvatarBase.DEL_CAZ_JOIN_TEAM;
								tempSecPer.killByWho = tempFirPer.nickName;
								
								needRemovePersonIndexList.push(tempSecPer);
								
								//添加团队数据
								tempFirPer.perData.doAlign(tempSecPer.perData);
								
								//结盟
								_playerInfo.noticePanel.addNotice(
									"player <font size='14' color='#0xffffff'>" + 
									tempFirPer.nickName + " AND player <font size='14' color='#0xffffff'>" +
									tempSecPer.nickName + " align");
								
								//清除他俩的状态
								setRelation(tempFirPer.nickName,tempSecPer.nickName,PlayerBattleUtil.STATE_UNKOWN);
							}
								//团队与团队之间
							else if(firPer.isTeam && secPer.isTeam)
							{
								if(secPer == _hero)
								{
									secPer.perData.doAlign(firPer.perData);
								}
								else
								{
									firPer.perData.doAlign(secPer.perData);
								}
							}
							else
							{
								//如果第一个是团队
								if(firPer.isTeam)
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
									
									//结盟
									_playerInfo.noticePanel.addNotice(
										"player <font size='14' color='#0xffffff'>" + 
										firPer.nickName + " AND player <font size='14' color='#0xffffff'>" +
										secPer.nickName + " align");
									
									//清除他俩的状态
									setRelation(firPer.nickName,secPer.nickName,PlayerBattleUtil.STATE_UNKOWN);
								}
								else if(secPer.isTeam)
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
										
									}
									//清除他俩的状态
									setRelation(firPer.nickName,secPer.nickName,PlayerBattleUtil.STATE_UNKOWN);
								}
							}
						}
							//如果两家是打算战斗的
						else if(state == PlayerBattleUtil.STATE_BATTLE)
						{
							//首先确保战斗双放都没有被移除
							if(firPer._delType == "default" && secPer._delType == "default")
							{
								//判断是否能攻击
								if(firPer.perData.judgeAttack(secPer.perData))
								{
									//进行攻击
									firPer.perData.doAttack(secPer.perData);
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
										_gameOverFunc.call();
										return null;
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
										_gameOverFunc.call();
										return null;
									}
									secPer._delType = AvatarBase.DEL_CAZ_DIE;
									secPer.killByWho = firPer.nickName;
									needRemovePersonIndexList.push(secPer);
								}
							}
							
						}
					}
				}
			}
			
			return needRemovePersonIndexList;
		}
	}
}