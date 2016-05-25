package com.view.gameWindow.panel.panels.onhook
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.MapConst;
	import com.pattern.state.IState;
	import com.pattern.state.StateMachine;
	import com.pattern.state.StateTimeMachine;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AuFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.CDState;
	import com.view.gameWindow.panel.panels.onhook.states.common.ConfigAuto;
	import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
	import com.view.gameWindow.panel.panels.onhook.states.common.OneCallState;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.panel.panels.onhook.states.drug.AutoUseDrug;
	import com.view.gameWindow.panel.panels.onhook.states.drug.CheckAutoUseGiftState;
	import com.view.gameWindow.panel.panels.onhook.states.drug.CheckEquipDur;
	import com.view.gameWindow.panel.panels.onhook.states.drug.CheckHPState;
	import com.view.gameWindow.panel.panels.onhook.states.drug.CheckMPState;
	import com.view.gameWindow.panel.panels.onhook.states.drug.CheckTPState;
	import com.view.gameWindow.panel.panels.onhook.states.drug.ChooseRightDrugIntent;
	import com.view.gameWindow.panel.panels.onhook.states.fight.AttackPkState;
	import com.view.gameWindow.panel.panels.onhook.states.fight.AttackState;
	import com.view.gameWindow.panel.panels.onhook.states.fight.AutoAttack;
	import com.view.gameWindow.panel.panels.onhook.states.fight.AutoSkill;
	import com.view.gameWindow.panel.panels.onhook.states.fight.CheckAutoFight;
	import com.view.gameWindow.panel.panels.onhook.states.fight.SpellAutoSkillState;
	import com.view.gameWindow.panel.panels.onhook.states.map.AutoMap;
	import com.view.gameWindow.panel.panels.onhook.states.move.AutoMove;
	import com.view.gameWindow.panel.panels.onhook.states.pickUp.AutoPickUp;
	import com.view.gameWindow.panel.panels.onhook.states.pickUp.CheckAroundDropItem;
	import com.view.gameWindow.panel.panels.onhook.states.pickUp.CheckDigState;
	import com.view.gameWindow.panel.panels.onhook.states.pickUp.CheckMineState;
	import com.view.gameWindow.panel.panels.onhook.states.quest.DoQuestState;
	import com.view.gameWindow.panel.panels.onhook.states.target.AutoTarget;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.Monster;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.movie.MovieManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	/**
	 * 不包括任务 ，任务方面看TaskAutoHandover&AutoDoTask
	 * @see com.view.gameWindow.panel.panels.task.TaskAutoHandover 
	 * @see com.view.gameWindow.scene.entity.entityItem.autoJob.AutoDoTask
	 * @author wqhk
	 * 2014-9-27
	 */
	public class AutoSystem extends EventDispatcher
	{
		public var tempStop:Boolean = false;
		public var isBossAttack:Boolean = false;
		private var _autoAddHp:AutoUseDrug;
		private var _autoAddHpX:AutoUseDrug;
		private var _autoAddMp:AutoUseDrug;
		private var _autoAddMpX:AutoUseDrug;
		
		private var _useHPIntent:ChooseRightDrugIntent;
		private var _useHPIntentX:ChooseRightDrugIntent;
		private var _useMPIntent:ChooseRightDrugIntent;
		private var _useMPIntentX:ChooseRightDrugIntent;
		
		private var _autoHPTP:StateTimeMachine;
		private var _autoRepairOil:StateTimeMachine;
		
		private var _autoAttack:AutoAttack;
		private var _autoSkill:AutoSkill;
		private var _autoMove:AutoMove;
		private var _autoPickUp:AutoPickUp;
		
		private var _autoMap:AutoMap;
		private var _autoTarget:AutoTarget;
		private var _isAutoFight:Boolean = false;
		private var _fightPlace:int;
		//起始点 确定范围用
		private var _startFightTileX:int;
		private var _startFightTileY:int;

		private var lastAutoFightTime:int;
		private var lastDeadTime:int = 0;
		private var _battlefield:IBattleField;
		
		private var _dig:StateMachine;
		private var _mine:StateTimeMachine;
		private var _autoUseGift:StateTimeMachine;
		private var _autoCheckFight:StateTimeMachine;
		
		private var _waitingState:WaitingState;
		
		private static var _instance:AutoSystem;

		public function get waitingState():WaitingState
		{
			if(!_waitingState)
			{
				_waitingState = new WaitingState();
			}
			
			return _waitingState;
		}

		public static function get instance():AutoSystem
		{
			if(!_instance)
			{
				_instance = new AutoSystem();
			}
			
			return _instance;
		}
		
		public function AutoSystem()
		{
			//药品配置
			AutoDataManager.instance.initDrugCfg();
			
			//药品
			_autoAddHp = new AutoUseDrug;
			_autoAddHp.init(new CheckHPState());
			_useHPIntent = new ChooseRightDrugIntent();
			
			_autoAddHpX = new AutoUseDrug;
			_autoAddHpX.init(new CheckHPState());
			_useHPIntentX = new ChooseRightDrugIntent();
			
			_autoAddMp = new AutoUseDrug;
			_autoAddMp.init(new CheckMPState());
			_useMPIntent = new ChooseRightDrugIntent();
			
			_autoAddMpX = new AutoUseDrug;
			_autoAddMpX.init(new CheckMPState());
			_useMPIntentX = new ChooseRightDrugIntent();
			
			_autoHPTP = new StateTimeMachine(500);
			_autoHPTP.init(new CheckTPState());
			
			_autoRepairOil = new StateTimeMachine(5000);
			_autoRepairOil.init(new CheckEquipDur());
			
			//攻击
			_autoAttack = new AutoAttack();
			_autoAttack.init(waitingState);
			
			_autoSkill = new AutoSkill();
			_autoSkill.init(new SpellAutoSkillState());
		
			//同地图移动
			_autoMove = new AutoMove();
			_autoMove.init(waitingState);
			
			//拾取
			_autoPickUp = new AutoPickUp();
			_autoPickUp.init(waitingState);
			
			//不同地图移动
			_autoMap = new AutoMap();
			_autoMap.init(waitingState);
			
			//
			_autoTarget = new AutoTarget();
			_autoTarget.init(waitingState);
			
			//
			_dig = new StateMachine();
			_dig.init(waitingState);
			
			//
			_mine = new StateTimeMachine(100);
			_mine.init(waitingState);
			
			_autoUseGift = new StateTimeMachine(1000);
			_autoUseGift.init(new CheckAutoUseGiftState());
			
			_autoCheckFight = new  StateTimeMachine(1000);
			_autoCheckFight.init(_waitingState);
		}
		
		public function startCheckFight():void
		{
			_autoCheckFight.init(new CheckAutoFight());
		}
		
		public function stopCheckFight():void
		{
			_autoCheckFight.init(_waitingState);
		}
		
		/**
		 * 在副本通关后执行一次
		 */
		public function startPickUpBeforeTask():void
		{
			stopAuto();
			_autoPickUp.init(new CheckAroundDropItem(new DoQuestState()));
		}
		
		public function startPickUpOnce():void
		{
			_autoPickUp.init(new CheckAroundDropItem(new WaitingState()));
		}
		
		public function isAutoMove():Boolean
		{
			if(_autoMove && _autoMove.curState is WaitingState)
			{
				return false;
			}
			
			return true;
		}
		
		public function isAutoAttack():Boolean
		{
			if(_autoAttack && _autoAttack.curState is WaitingState)
			{
				return false;
			}
			
			return true;
		}
		
		public function isAutoAttackPk():Boolean
		{
			if(_autoAttack && _autoAttack.curState is AttackPkState)
			{
				return true;
			}
			
			return false;
		}
		
		public function isAutoMap():Boolean
		{
			if(_autoMap && _autoMap.curState is WaitingState)
			{
				return false;
			}
			
			return true;
		}
		
		public function isAutoPickUp():Boolean
		{
			if(_autoPickUp && !(_autoPickUp.curState is WaitingState))
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 包括自动杀怪和自动拾取
		 */
		public function isAutoFight():Boolean
		{
			return _isAutoFight;
		}
		
		public function stopAutoTarget():void
		{
			_autoTarget.init(waitingState);
		}
		
		/**
		 * @param immediate 为true时 物品也不捡取直接结束
		 */
		public function stopAutoFight(fightPlace:int = 0,immediate:Boolean=true):void
		{
			if(fightPlace!= FightPlace.FIGHT_PLACE_ALL && fightPlace != _fightPlace)
			{
				return;
			}
			
			_isAutoFight = false;
			
			AutoFuncs.stopAttack();
			AutoFuncs.stopMap();
			
			if(immediate)
			{
				_autoPickUp.init(waitingState);
			}
			else
			{
				//因为上面停止移动了，所以要再检查遍
				_autoPickUp.init(new CheckAroundDropItem());
			}
			
			this.dispatchEvent(new Event("updateAutoFight"));
		}
		
		private var lastDownTime:int;
		
		/**
		 * @return 1 stop寻路  2 stop战斗
		 */
		public function onMouseDown():int
		{
			var interval:int = 10000;
			var code:int = 0;
			var curTime:int = getTimer();
			if(isAutoMap())
			{
				if(curTime - lastDownTime < interval)
				{
					stopAuto();
					lastDownTime = 0;
				}
				else
				{
					code = 1;
					lastDownTime = curTime;
				}
			}
			else if(isAutoFight())
			{
				/*if(curTime - lastDownTime < interval)//自动战斗不用点两次取消，所以注释掉
				{*/
					stopAuto();
					/*lastDownTime = 0;
				}
				else
				{
					code = 2;
					lastDownTime = curTime;
				}*/
			}
			else if(isAutoAttack())
			{
				AutoFuncs.stopAttack();
				AutoFuncs.stopMove();
			}
			else if(isAutoPickUp())
			{
				stopAuto();
			}
			
			return code;
		}
		
		/**
		 * stop all
		 */
		public function stopAutoEx():void
		{
			AxFuncs.stopAutoTask();
			stopAuto();
		}
		
		public function stopAuto(immediate:Boolean=true):void
		{
			stopAutoFight(0,immediate);
			stopAutoTarget();
			_dig.init(waitingState);
			_mine.init(waitingState);
		}
		
		public function stopAutoMap():void
		{
			_autoMap.init(waitingState);
			stopAutoMove();
		}
		
		public function stopAutoMove():void
		{
			AutoFuncs.stopMove();
		}
		
		
		private var fixedType:int;
		private var fixedId:int;
		
		public function startIndepentAttack(entityType:int,entityId:int):void
		{
			stopAuto();
			AutoJobManager.getInstance().reset();
			
			var state:IState;
			
			if(entityType != EntityTypes.ET_MONSTER)
			{
				state = new AttackPkState(AxFuncs.firstPlayer,
								AxFuncs.getEntity(entityType,entityId) as ILivingUnit,
								AxFuncs.enemyLivingFilter,waitingState);
			}
			else
			{
				state = new AttackState(AxFuncs.firstPlayer,
								AxFuncs.getEntity(entityType,entityId) as ILivingUnit,
								AxFuncs.enemyLivingFilter,new OneCallState(startPickUpOnce,null,waitingState,1000));
			}
			
			fixedType = entityType;
			fixedId = entityId;
			
			if(_autoAttack)
			{
				_autoAttack.init(state);
			}
		}
		
		public function isFixedTarget(type:int,id:int):Boolean
		{
			return fixedType == type && fixedId == id;
		}
		
		public function toDig(monsterGroupId:int):void
		{
			_dig.init(new CheckDigState(monsterGroupId));
		}
		
		/**
		 * 自动攻击+自动拾取 
		 * @param isConsideRange 为了电影后自动开启打怪新加的参数， 因为如果是用默认的全屏打怪模式 开启战斗后会去寻各个怪物刷新点。
		 *  PickUp中也用到这个参数 是因为有可能东西还没捡起就进入了电影，然后电影关了后进入战斗会去先拾取，拾取后再次进入打怪状态，参数需要传入。
		 * 
		 * @param isBossAttak 现在去掉功能了。只要在 MapConst.EMOGUANGCHANG 就是先boss
		 */
		public function startAutoFight(fightPlace:int,isConsideRange:Boolean = true,isBossAttack:Boolean = false):void
		{
			if(!isCanAutoFight)
			{
				return;
			}
			
			stopAuto();
			AutoJobManager.getInstance().reset();
			
			this.isBossAttack = isBossAttack;
			_fightPlace = fightPlace;
			_isAutoFight = true;
			
			_startFightTileX = AxFuncs.firstPlayer.tileX;
			_startFightTileY = AxFuncs.firstPlayer.tileY;
			
			setBattlefield(_startFightTileX,_startFightTileY);
			
			AutoFuncs.startAttack(isConsideRange);
			
			_autoPickUp.init(new CheckAroundDropItem(null,isConsideRange));
			
			resetAutoFightTime();
			
			this.dispatchEvent(new Event("updateAutoFight"));
		}
		
		public function get isCanAutoFight():Boolean
		{
			var isCover:Boolean = MovieManager.instance.checkCover();
			
			return !isCover;
		}
		
		public function get battleField():IBattleField
		{
			return _battlefield;
		}
		
		private function setBattlefield(startX:int,startY:int):void
		{
			if(!_battlefield)
			{
				_battlefield = new MapBattleField();
			}
			
			_battlefield.startFight(startX,startY,ConfigAuto.FIGHT_RADIUS);
		}
		
		/**
		 * 当改变设置中的选项 和时间时需要重置
		 */
		public function resetAutoFightTime():void
		{
			lastAutoFightTime = getTimer();
		}
		
		/**
		 * 同地图的移动
		 */
		public function startAutoMove(tileX:int, tileY:int, targetTileDist:int):void
		{
			AutoFuncs.move(EntityLayerManager.getInstance().firstPlayer, tileX, tileY, targetTileDist);
		}
		
		/**
		 * 会寻找传送点传送的移动
		 */
		public function startAutoMap(mapId:int,tileX:int,tileY:int):void
		{
			_autoMap.setDestination(SceneMapManager.getInstance().mapId,mapId,tileX,tileY);
		}
		
		/**
		 * 会寻找传送点传送的移动
		 */
		public function startAutoMapEx(mapId:int,tileX:int,tileY:int,tpList:Array):void
		{
			_autoMap.setDestination(SceneMapManager.getInstance().mapId,mapId,tileX,tileY,tpList);
		}
		
		/**
		 * 怪物 npc 找到后执行相应操作
		 */
		public function setTarget(entityId:int,entityType:int,plusId:int = 0):void
		{
			_autoTarget.setTarget(entityId,entityType,plusId);
		}
		
		/**
		 * target 只是指通过setTarget设置的目标
		 */
		public function isRunningToMonster(monsterGroupId:int):Boolean
		{
			if(!_autoTarget)
			{
				return false;
			}
			if(_autoTarget.curState is WaitingState)
			{
				return false;
			}
			
			var mst:MapMonsterCfgData = _autoTarget.monsterTarget;
			
			if(!mst)
			{
				return false;
			}
			
			return  mst.monster_group_id == monsterGroupId;
		}
		
		/**
		 * 这里只判断了 自动战斗中的攻击
		 */
		public function isFightingAtMonster(monsterGroupId:int):Boolean
		{
			if(isAutoFight())
			{
				if(!AxFuncs.selectEntity)
				{
					return false;
				}
				
				var monster:Monster = AxFuncs.selectEntity as Monster;
				
				if(!monster)
				{
					return false;
				}
				
				var cfg:MonsterCfgData = ConfigDataManager.instance.monsterCfgData(monster.monsterId);
				
				return  cfg.group_id == monsterGroupId;
			}
			
			return false;
		}
		
		public function checkTpTime():Boolean
		{
			if(AxFuncs.isTimeTp())
			{
				var time:int = getTimer();
				var sec:int = (time - lastAutoFightTime)/1000;
				if(sec>=AxFuncs.timeTp())
				{
					return true;
				}
			}
			
			return false;
		}
		
		
		/**
		* 是否活着
		*/
		private function checkLiving():Boolean
		{
			var self:IPlayer = EntityLayerManager.getInstance().firstPlayer;
			
			if (self.hp <= 0)
			{
				//关闭自动寻路打怪
				stopAuto();
				
				//等复活面板弹出
				if(lastDeadTime == 0)
				{
					lastDeadTime = getTimer();
				}
				//复活
				if(AxFuncs.isRevive())
				{
					if(getTimer() - lastDeadTime>3000)
					{
						AxFuncs.useRevive();
						lastDeadTime = getTimer();//防止连续调用
					}
				}
			}
			else
			{
				lastDeadTime = 0;
			}
			
			return self.hp > 0;
		}
		
		/**
		 * 是否传送
		 */
		private function checkTP():void
		{
			//到时间传送
			
			if(isAutoFight())
			{
				if(checkTpTime())
				{
					if(AxFuncs.useTp())
					{
						stopAutoFight();
					}
				}
				
				if(AxFuncs.isDrugTp())
				{
					var id:int;
					var drug:* = null;
					var list:Array = _useHPIntent.drugList.concat(_useHPIntentX.drugList);
					for each(id in list)
					{
						drug = BagDataManager.instance.getItemById(id);
						if(drug)
						{
							break;
						}
					}
					
					if(!drug && AxFuncs.useTp())
					{
						stopAutoFight();
					}
				}
			}
		}
		
		/**
		 * 一些初始化设置
		 */
		private function checkInit():void
		{
			AutoDataManager.instance.setJob(RoleDataManager.instance.job);
			AutoDataManager.instance.checkLearnedSkills();
		}
		
		private var _isStop:Boolean = false;
		public function pause():void
		{
			_isStop = true;
		}
		
		public function resume():void
		{
			_isStop = false;
		}
		
		public function run():void
		{
			if(_isStop)
			{
				return;
			}
			
			if(!AxFuncs.isCfgReady)
			{
				return;
			}
			
			if(!AxFuncs.firstPlayer)
			{
				return;
			}
			
			checkInit();
			checkLiving();
			checkTP();
			
			//修改药品设置
			AxFuncs.setDrugIntent(_useHPIntent,AutoDataManager.instance.hpCfg);
			AxFuncs.setDrugIntent(_useHPIntentX,AutoDataManager.instance.hpXCfg);
			AxFuncs.setDrugIntent(_useMPIntent,AutoDataManager.instance.mpCfg);
			AxFuncs.setDrugIntent(_useMPIntentX,AutoDataManager.instance.mpXCfg);
			
			//各状态执行
			_autoAddHp.next(_useHPIntent);
			_autoAddHpX.next(_useHPIntentX);
			_autoAddMp.next(_useMPIntent);
			_autoAddMpX.next(_useMPIntentX);
			
			_autoHPTP.next();
			_autoRepairOil.next();
			
			_autoSkill.next();
			_autoAttack.next();
			_autoPickUp.next();
			
			_autoMap.next();
			_autoTarget.next();
			_dig.next();
			_mine.next();
			_autoUseGift.next();
			_autoCheckFight.next();
			
			//放最后 前面会有距离的判断
			_autoMove.next();
			
			
			//自动战斗
			if(!isAutoFight())
			{
				AuFuncs.showFightEffect(false);
			}
			else
			{
				AuFuncs.showFightEffect(true);
			}
			
		}
		
		/**
		 * 不要单独使用 
		 */
		public function toMine():void
		{
			_mine.init(new CDState(0.05,new CheckMineState()));
		}
		
		/**
		 * 点击怪物攻击时 战士有的技能需要自动释放
		 */
		public function getNormalSkill(target:IEntity):int
		{
			var attacker:IPlayer = AxFuncs.firstPlayer;
			
			if(attacker.job == JobConst.TYPE_ZS)
			{
				var skill:SkillCfgData = AxFuncs.selectSkill(attacker,target,[],
																AxFuncs.getSkillAuto(attacker.job),
																AxFuncs.getSkillDefault(attacker.job));
				
				return skill ? skill.group_id : AxFuncs.getSkillDefault(attacker.job);
			}
			
			return AxFuncs.getSkillDefault(attacker.job);
		}
		
		
		public function isAuto():Boolean
		{
			var autoAttack:Boolean = isAutoAttack();
			/*trace("AutoSystem.isAuto() isAutoAttack："+isAutoAttack);*/
			var autoPickUp:Boolean = isAutoPickUp();
			/*trace("AutoSystem.isAuto() isAutoPickUp:"+isAutoPickUp);*/
			var autoMap:Boolean = isAutoMap();
			/*trace("AutoSystem.isAuto() isAutoMap:"+isAutoMap);*/
			var isDig:Boolean = isAutoDig();
			var isMine:Boolean = isAutoMine();
			return autoAttack || autoPickUp || autoMap || isDig || isMine;
		}
		
		public function isAutoMine():Boolean
		{
			return !(_mine.curState is WaitingState);
		}
		
		public function isAutoDig():Boolean
		{
			return !(_dig.curState is WaitingState);
		}
		
		public function get startFightTileX():int
		{
			return _startFightTileX;
		}
		
		public function get startFightTileY():int
		{
			return _startFightTileY;
		}
	}
}