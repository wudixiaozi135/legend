package com.view.gameWindow.scene.entity.entityItem.autoJob
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.JobCfgData;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.configData.cfgdata.TrapCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.StringConst;
	import com.pattern.Observer.Observe;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.buff.BuffData;
	import com.view.gameWindow.panel.panels.buff.BuffDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.prompt.Panel2BtnPromptData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.panel.panels.stall.StallDataManager;
	import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncItem;
	import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncs;
	import com.view.gameWindow.panel.panels.task.npctask.NpcTaskPanelData;
	import com.view.gameWindow.panel.panels.trans.PanelTransData;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.GameSceneManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.constants.RunTypes;
	import com.view.gameWindow.scene.entity.constants.SpecialActionTypes;
	import com.view.gameWindow.scene.entity.entityItem.Entity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IDropItem;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstTrailer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IHero;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.gameWindow.scene.entity.entityItem.interf.INpcStatic;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPet;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.ITeleporter;
	import com.view.gameWindow.scene.entity.entityItem.interf.ITrailer;
	import com.view.gameWindow.scene.entity.entityItem.interf.ITrap;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.map.path.MapPathManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	import com.view.gameWindow.scene.skillDeal.SkillDealManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	public class AutoJobManager extends Observe
	{
		private static var _instance:AutoJobManager;
		public static function getInstance():AutoJobManager
		{
			if (!_instance)
			{
				_instance = new AutoJobManager(new PrivateClass());
			}
			return _instance;
		}
		
		public static const TO_PLAYER_TILE_DIST0:int = 0;
		public static const TO_PLAYER_TILE_DIST:int = 1;
		public static const TO_NPC_TILE_DIST:int = 2;
		public static const TO_TRAP_TILE_DIST:int = 1;
		public static const TO_PLANT_TILE_DIST:int = 1;
		public static const TO_MONSTER_TILE_DIST0:int = 0;
		public static const TO_MONSTER_TILE_DIST1:int = 1;
		public static const TO_MONSTER_DIG_TILE_DIST:int = 1;
		public static const TO_TELEPORT_TILE_DIST:int = 0;
		public static const TO_DROPITEM_TILE_DIST:int = 0;
		public static const TO_MINE_TILE_DIST:int = 2;
		
		public static const RUN_DIST:int = 2;
		public static const WALK_DIST:int = 1;
		
		private var _inMapPath:Array;
		private var _overEntity:IEntity;
		private var _selectEntity:IEntity;
		private var _autoTargetEntity:IEntity;
		private var _targetTileX:int;
		private var _targetTileY:int;
		private var _lastSkillTime:int;
		private var _autoFindPath:AutoFindPath;
		private var _autoKillMst:AutoKillMst;
		private var _autoCollectPlant:AutoCollectPlant;
		private var _autoDoTask:AutoDoTask;
		private var _lastCheckDropItemTime:int;
		private var _stayOnDropItemId:int;
		/**重叠移动目标点（像素位置）*/
		private var _overLapMoveLct:Point;
		
		public function AutoJobManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_lastSkillTime = 0;
			_autoFindPath = new AutoFindPath();
			_autoKillMst = new AutoKillMst();
			_autoCollectPlant = new AutoCollectPlant();
			_autoDoTask = new AutoDoTask();
		}
		
		public function update():void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if(_overLapMoveLct)
			{
				if(firstPlayer.knocking)
				{
					_overLapMoveLct = null;
				}
				else
				{
					var tileDistance:Number = firstPlayer.pixelDistance(_overLapMoveLct.x,_overLapMoveLct.y);
					if(tileDistance > .01)
					{
						return;
					}
					_autoTargetEntity = _selectEntity;
					_overLapMoveLct = null;
				}
			}
			_autoDoTask.doTask();
			_autoFindPath.gotoAutoTarget();
			_autoFindPath.checkFlagShow();
			_autoKillMst.killingMst();
			_autoCollectPlant.collectPlant();
			if (_autoTargetEntity && !_autoTargetEntity.isShow 
					&& _autoTargetEntity.entityType != EntityTypes.ET_NPC 
					&& _autoTargetEntity.entityType != EntityTypes.ET_PLANT)
			{
				_autoTargetEntity = null;
				_inMapPath = null;
				resetTargetTile();
				return;
			}
			if (_autoTargetEntity && (_targetTileX != _autoTargetEntity.tileX || _targetTileY != _autoTargetEntity.tileY))
			{
				if (checkRigor())
				{
					return;
				}
				runTo(_autoTargetEntity.tileX, _autoTargetEntity.tileY, _autoTargetEntity.tileDistToReach);
				return;
			}
			var boolean:Boolean = checkReachEntity();
			var targetTile:Point = null;
			if (!boolean)
			{
				if (_inMapPath && _inMapPath.length > 0)
				{
					if (firstPlayer.targetPixelX == firstPlayer.pixelX && firstPlayer.targetPixelY == firstPlayer.pixelY)
					{
						var pathTile:Point = _inMapPath[0];
						if (firstPlayer.tileDistance(pathTile.x, pathTile.y) == 0)
						{
							_inMapPath.shift();
						}
						if (_inMapPath.length > 0)
						{
							pathTile = _inMapPath[0];
							var targetTileX:int = firstPlayer.tileX;
							var targetTileY:int = firstPlayer.tileY;
							if (firstPlayer.tileDistance(pathTile.x, pathTile.y) < RUN_DIST)
							{
								if(_inMapPath.length == 1)
								{
									var dx:int = pathTile.x - targetTileX;
									var dy:int = pathTile.y - targetTileY;
									targetTileX += dx == 0 ? 0 : (dx < 1 ? -1 : 1);
									targetTileY += dy == 0 ? 0 : (dy < 1 ? -1 : 1);
									targetTile = new Point(targetTileX, targetTileY);
								}
								else
								{
									targetTile = pathTile;
								}
							}
							else
							{
								var xOffset:int = pathTile.x - firstPlayer.tileX;
								var yOffset:int = pathTile.y - firstPlayer.tileY;
								if (xOffset != 0)
								{
									targetTileX += xOffset / Math.abs(xOffset) * RUN_DIST;
								}
								if (yOffset != 0)
								{
									targetTileY += yOffset / Math.abs(yOffset) * RUN_DIST;
								}
								targetTile = new Point(targetTileX, targetTileY);
							}
						}
						else
						{
							//移动到目标移动终点时检测一次是否有可拾取物品
							searchDropItem();
						}
					}
				}
				if (targetTile)
				{
					//押镖： 等待镖车
					var myTrailer:IFirstTrailer = EntityLayerManager.getInstance().myTrailer;
					if(myTrailer)
					{
						var dis:int = myTrailer.tileDistance(firstPlayer.tileX,firstPlayer.tileY);
						if(dis > 8)
						{
							needWaiting = true;
						}
						else if(dis < 3)
						{
							needWaiting = false;
						}
					}
					else
					{
						needWaiting = false;
					}
					
					if(!needWaiting)
					{
						firstPlayer.targetTileX = targetTile.x;
						firstPlayer.targetTileY = targetTile.y;
						
						if (firstPlayer.tileDistance(targetTile.x, targetTile.y) > WALK_DIST)
						{
							firstPlayer.run();
						}
						else
						{
							firstPlayer.walk();
						}
						
						sendServerMove();
					}
					
					_autoFindPath.newEffect();
				}
			}
			else
			{
				_autoFindPath.destroyEffect();
			}
			
			if(_stayOnDropItemId/* && !_autoTargetEntity*/)
			{
				updatePickDropItem();
			}
			checkLeaveNpc();
		}
		
		private var needWaiting:Boolean = false;
		
		/**检查离开NPC<br>若过远则关闭面板*/
		private function checkLeaveNpc():void
		{
			var clickNpcOpenPanelType:String = NpcFuncs.clickNpcOpenPanelType;
			var mediator:PanelMediator = PanelMediator.instance;
			if(clickNpcOpenPanelType && mediator.openedPanel(clickNpcOpenPanelType))
			{
				var clickNpcId:int = NpcFuncs.clickNpcId;
				var clickNpcTileX:int = NpcFuncs.clickNpcTileX;
				var clickNpcTileY:int = NpcFuncs.clickNpcTileY;
				var mapId:int = SceneMapManager.getInstance().mapId;
				var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(clickNpcId);
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				var tileDist:int = firstPlayer.tileDistance(clickNpcTileX, clickNpcTileY);
				if(!npcCfgData || npcCfgData.mapid != mapId || tileDist > TO_NPC_TILE_DIST)
				{
					mediator.closePanel(clickNpcOpenPanelType);
					NpcFuncs.clickNpcOpenPanelType = "";
				}
			}
		}
		
		private function updatePickDropItem():void
		{
			var nowTime:int = getTimer();
			if(nowTime - _lastCheckDropItemTime > 100)
			{
				_lastCheckDropItemTime = nowTime;
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				var entity:IEntity = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_DROPITEM,_stayOnDropItemId);
				if(entity)
				{
					if(Math.abs(entity.pixelX - firstPlayer.pixelX) < 1 && Math.abs(entity.pixelY - firstPlayer.pixelY) < 1)
					{
						sendPickDropitem(_stayOnDropItemId);
						_stayOnDropItemId = 0;
					}
				}
			}
		}
		
		private function sendPickDropitem(entityId:int):void
		{
			/*var entity:IEntity = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_DROPITEM,entityId);
			var isValue:Boolean =AxFuncs.isDropItemValueType(entity);
			
			if(!isValue && BagDataManager.instance.remainCellNum == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0028);	
				return;
			}*/

			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(entityId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_PICK_DROPITEM,byteArray);
		}
		
		private function checkReachEntity():Boolean
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var tileDist:int = 0;
			
			if (_autoTargetEntity)
			{
				if (_autoTargetEntity.entityType == EntityTypes.ET_TELEPORTER)
				{
					tileDist = firstPlayer.tileDistance(_autoTargetEntity.tileX, _autoTargetEntity.tileY);
					if (tileDist <= 0)
					{
						var teleporter:ITeleporter = _autoTargetEntity as ITeleporter;
						if(!canTeleport(teleporter.teleportId))
						{
							_autoTargetEntity = null;
							resetTargetTile();
							_inMapPath = null;
							return true;
						}
						
						if(PanelTransData.vip && PanelTransData.gold_bind)
						{
							Panel2BtnPromptData.strSureBtn = StringConst.TRANS_PANEL_0030;
							Panel2BtnPromptData.strCancelBtn = StringConst.TRANS_PANEL_0031;
							Panel2BtnPromptData.strContent = StringConst.TRANS_PANEL_0032.replace("X",PanelTransData.vip).replace("XX",PanelTransData.gold_bind);
							Panel2BtnPromptData.funcBtn = function():void
							{
								sendServerSwitchMap(teleporter.teleportId);
								PanelMediator.instance.closePanel(PanelConst.TYPE_2BTN_PROMPT);
							};
							PanelMediator.instance.openPanel(PanelConst.TYPE_2BTN_PROMPT);
							_autoTargetEntity = null;
							resetTargetTile();
							_inMapPath = null;
							return true;
						}
						sendServerSwitchMap(teleporter.teleportId);
						_autoTargetEntity = null;
						resetTargetTile();
						_inMapPath = null;
						return true;
					}
				}
				else if (isCanUseSkillTarget(_autoTargetEntity))
				{
					var player:IPlayer = _autoTargetEntity as IPlayer;
					if(player && player.specialAction == SpecialActionTypes.PSA_LAY)
					{
						if(!checkReachPushOil(player))
						{
							return false;
						}
						else
						{
							return true;
						}
					}
					else if(isStallStatue(_autoTargetEntity))
					{
						if(!checkReachStallStatue(player))
						{
							return false;
						}
						else
						{
							return true;
						}
					}
					else
					{
						var livingUnit:ILivingUnit = _autoTargetEntity as ILivingUnit;
						var isTrailer:Boolean = livingUnit.entityType == EntityTypes.ET_TRAILER;
						if (!isTrailer && livingUnit.hp > 0 || (isTrailer && livingUnit.hp > 1))
						{
							if(firstPlayer.knocking)
							{
								tileDist = firstPlayer.tileDistance(_autoTargetEntity.tileX, _autoTargetEntity.tileY);
								if (tileDist <= 0)
								{
									var moveLct:Point = getNearCanMoveLct();
									_overLapMoveLct = MapTileUtils.tileToPixel(moveLct.x,moveLct.y);
									directMove(_overLapMoveLct.x, _overLapMoveLct.y, RunTypes.RT_NORMAL, false);
									return false;
								}
							}
							if (checkRigor() || firstPlayer.isPalsy || firstPlayer.isFrozen)
							{
								return false;
							}
							var buffTriggerSkillId:int = BuffDataManager.instance.buffTriggerSkillId;
							var skillGroupId:int = ActionBarDataManager.instance.getCurrentSkillGroupId(_autoTargetEntity);
							var id:int = buffTriggerSkillId || skillGroupId;
							var type:int = buffTriggerSkillId ? 1 : 0;
							return useSkillDeal(livingUnit,id,type,false);
						}
					}
				}
				else if (_autoTargetEntity.entityType == EntityTypes.ET_MONSTER && (_autoTargetEntity as IMonster).hp <= 0)
				{
					var mst:IMonster = _autoTargetEntity as IMonster;
					if(!(mst && mst.canDig))
					{
						return false;
					}
					if (firstPlayer && firstPlayer.pixelX != firstPlayer.targetPixelX || firstPlayer.pixelY != firstPlayer.targetPixelY)
					{
						return false;
					}
					tileDist = firstPlayer.tileDistance(_autoTargetEntity.tileX, _autoTargetEntity.tileY);
					if (tileDist <= TO_MONSTER_DIG_TILE_DIST)
					{
						firstPlayer.targetTileX = firstPlayer.tileX;
						firstPlayer.targetTileY = firstPlayer.tileY;
						if(tileDist == 0)
						{
							firstPlayer.direction = Direction.getDirectionByTile(firstPlayer.tileX, firstPlayer.tileY, _autoTargetEntity.tileX, _autoTargetEntity.tileY);
						}
						sendServerMove();
						if(firstPlayer.currentAcionId != ActionTypes.MINING)
						{
							EntityLayerManager.getInstance().requestBeginCorpseMonsterDig(mst.entityId,mst.mstDigCfgData);
						}
						_autoTargetEntity = null;
						resetTargetTile();
						_inMapPath = null;
						return true;
					}
					return false;
				}
				else if (_autoTargetEntity.entityType == EntityTypes.ET_NPC)
				{
					tileDist = firstPlayer.tileDistance(_autoTargetEntity.tileX, _autoTargetEntity.tileY);
					if (tileDist <= TO_NPC_TILE_DIST)
					{
						firstPlayer.targetTileX = firstPlayer.tileX;
						firstPlayer.targetTileY = firstPlayer.tileY;
						
						sendServerMove();
						
						var staticNpc:INpcStatic = _autoTargetEntity as INpcStatic;
						var isShowTaskPanel:Boolean = true;
						var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
						if(panel && NpcTaskPanelData.npcId == staticNpc.entityId)
						{
							isShowTaskPanel = false;
						}
						if (isShowTaskPanel)
						{
							var clickNpcOpenPanelType:String = NpcFuncs.clickNpcOpenPanelType;
							if(clickNpcOpenPanelType != "")
							{
								PanelMediator.instance.closePanel(clickNpcOpenPanelType);
								NpcFuncs.clickNpcOpenPanelType = "";
							}
							var npcFuncs:NpcFuncs = new NpcFuncs();
							var allTasks:Vector.<NpcFuncItem> = npcFuncs.getAllTasks(staticNpc.entityId);
							if(allTasks.length)
							{
								npcFuncs.clickFunc(allTasks,staticNpc,firstPlayer);
							}
							else
							{
								var npcConfig:NpcCfgData = ConfigDataManager.instance.npcCfgData(staticNpc.entityId);
								var items:Vector.<NpcFuncItem> = npcFuncs.getFuncItems(npcConfig.func, npcConfig.func_extra, staticNpc.entityId);
								if(items.length > 0)
								{
									npcFuncs.clickFunc(items,staticNpc,firstPlayer);
								}
								else
								{
									npcFuncs.openStaticNpcPanel(staticNpc);
								}
							}
						}
						NpcFuncs.clickNpcId = _autoTargetEntity.entityId;
						NpcFuncs.clickNpcTileX = _autoTargetEntity.tileX;
						NpcFuncs.clickNpcTileY = _autoTargetEntity.tileY;
						notifyData(ModelEvents.NOTICE_REACH_NPC,_autoTargetEntity.entityId);
						reset();
						return true;
					}
				}
				else if(_autoTargetEntity.entityType == EntityTypes.ET_DROPITEM)
				{
					tileDist = firstPlayer.tileDistance(_autoTargetEntity.tileX, _autoTargetEntity.tileY);
					if (tileDist <= 0)
					{
						firstPlayer.targetTileX = firstPlayer.tileX;
						firstPlayer.targetTileY = firstPlayer.tileY;
						sendServerMove();
						sendPickDropitem(_autoTargetEntity.entityId);
						_autoTargetEntity = null;
						resetTargetTile();
						_inMapPath = null;
						return true;
					}
				}
				else if(_autoTargetEntity.entityType == EntityTypes.ET_PLANT)
				{
					tileDist = firstPlayer.tileDistance(_autoTargetEntity.tileX, _autoTargetEntity.tileY);
					if (tileDist <= TO_PLANT_TILE_DIST)
					{
						firstPlayer.targetTileX = firstPlayer.tileX;
						firstPlayer.targetTileY = firstPlayer.tileY;
						if(_inMapPath && _inMapPath.length > 0)
						{
							var stop:Point = _inMapPath[_inMapPath.length - 1];
							stop.x = firstPlayer.tileX;
							stop.y = firstPlayer.tileY;
						}
						else if(firstPlayer.isArriveTarget()) //只有到终点再判断  不然和后端同步会有问题
						{
							firstPlayer.direction = Direction.getDirectionByTile(firstPlayer.tileX, firstPlayer.tileY, _autoTargetEntity.tileX, _autoTargetEntity.tileY);
							sendServerMove();
							if(firstPlayer.currentAcionId != ActionTypes.GATHER)
							{
								sendBeginGather(_autoTargetEntity.entityId);
							}
							_autoTargetEntity = null;
							/*resetTargetTile(); */
							_inMapPath = null;
							return true;
						}
					}
				}
				else if(_autoTargetEntity.entityType == EntityTypes.ET_TRAP)
				{
					var dist:int;
					var trap:ITrap = _autoTargetEntity as ITrap;
					dist = TO_TRAP_TILE_DIST;
					tileDist = firstPlayer.tileDistance(_autoTargetEntity.tileX, _autoTargetEntity.tileY);
					if (tileDist <= dist)
					{
						firstPlayer.targetTileX = firstPlayer.tileX;
						firstPlayer.targetTileY = firstPlayer.tileY;
						if (firstPlayer.isArriveTarget())
						{
							sendServerMove();
							sendTrigger(trap);
							_autoTargetEntity = null;
							resetTargetTile();
							_inMapPath = null;
							return true;
						}
					}
				}
			}
			var boolean:Boolean = checkReachTile();
			return boolean;
		}
		
		public function isCanUseSkillTarget(entity:IEntity):Boolean
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if(!firstPlayer)
			{
				return false;
			}
			
			return (entity.entityType == EntityTypes.ET_PLAYER && entity.entityId != firstPlayer.entityId) || 
				(entity.entityType == EntityTypes.ET_HERO/* && ((entity as IHero).ownerId != firstPlayer.cid || (entity as IHero).sid != firstPlayer.sid)*/) ||//袁凯提的需求改为所有英雄都可以被自己攻击
				(entity.entityType == EntityTypes.ET_PET && ((entity as IPet).ownId != firstPlayer.cid || (entity as IPet).sid != firstPlayer.sid)) ||
				(entity.entityType == EntityTypes.ET_TRAILER && ((entity as ITrailer).ownerCid != firstPlayer.cid || (entity as ITrailer).ownerSid != firstPlayer.sid)) ||
				(entity.entityType == EntityTypes.ET_MONSTER && (entity as IMonster).hp > 0);
		}
		
		public function isStallStatue(entity:IEntity):Boolean
		{
			if (entity.entityType == EntityTypes.ET_PLAYER)
			{
				var player:IPlayer = entity as IPlayer;
				if (player.stallStatue)
				{//如果他人已经摆摊
					return true;
				}
			}
			return false
		}
		
		private function checkReachPushOil(livingUnit:ILivingUnit):Boolean
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (firstPlayer && firstPlayer.pixelX != firstPlayer.targetPixelX || firstPlayer.pixelY != firstPlayer.targetPixelY)
			{
				return false;
			}
			var tileDist:int = 0;
			tileDist = firstPlayer.tileDistance(livingUnit.tileX, livingUnit.tileY);
			if (tileDist <= 0)
			{
				firstPlayer.targetTileX = firstPlayer.tileX;
				firstPlayer.targetTileY = firstPlayer.tileY;
				
				if (firstPlayer.isArriveTarget())
				{
					sendServerMove();
					if(firstPlayer.specialAction != SpecialActionTypes.PSA_PUSH_OIL)
					{
						ActivityDataManager.instance.seaFeastDataManager.sendMassage();
					}
					_autoTargetEntity = null;
					resetTargetTile();
					_inMapPath = null;
					trace("AutoJobManager.checkReachPushOil(livingUnit) 发送推油");
					return true;
				}
			}
			return false;
		}
		
		private function checkReachStallStatue(player:IPlayer):Boolean
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (firstPlayer && firstPlayer.pixelX != firstPlayer.targetPixelX || firstPlayer.pixelY != firstPlayer.targetPixelY)
			{
				return false;
			}
			var tileDist:int = firstPlayer.tileDistance(player.tileX, player.tileY);
			if (tileDist <= TO_PLAYER_TILE_DIST)
			{
				firstPlayer.targetTileX = firstPlayer.tileX;
				firstPlayer.targetTileY = firstPlayer.tileY;
				
				if (firstPlayer.isArriveTarget())
				{
					sendServerMove();
					StallDataManager.instance.viewOtherStallInfo(player.cid, player.sid);
					_autoTargetEntity = null;
					resetTargetTile();
					_inMapPath = null;
					return true;
				}
			}
			return false;
		}
		
		private function sendTrigger(trap:ITrap):void
		{
			var isEqual:Boolean = ActivityDataManager.instance.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_SEA_SIDE);
			if (isEqual)
			{
				ActivityDataManager.instance.seaFeastDataManager.sendWatermelon();
			}
			else
			{
				var cfgDt:TrapCfgData = ConfigDataManager.instance.trapCfgData(trap.trapId);
				if(cfgDt && cfgDt.item_cost_id && cfgDt.item_cost_count)
				{
					var count:int = BagDataManager.instance.getItemNumById(cfgDt.item_cost_id);
					count += HeroDataManager.instance.getItemNumById(cfgDt.item_cost_id);
					if(count < cfgDt.item_cost_count)
					{
						var itemCfgData:ItemCfgData = cfgDt.itemCfgData;
						Alert.message((itemCfgData ? itemCfgData.name : StringConst.TRAP_TIP_0001) + StringConst.TRAP_TIP_0002);
						return;
					}
				}
				var entityId:int = trap.entityId;
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeInt(entityId);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_TOUCH_TRAP,byteArray);
			}
		}
		
		private function getNearCanMoveLct():Point
		{
			var points:Vector.<Point> = new Vector.<Point>();
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var mapPath:MapPathManager = MapPathManager.getInstance();
			var tileX:int = firstPlayer.tileX;
			var tileY:int = firstPlayer.tileY;
			var i:int,j:int;
			for(i=tileX-1;i<=tileX+1;i++)
			{
				for(j=tileY-1;j<=tileY+1;j++)
				{
					if(i == tileX && j == tileY)
					{
						continue;
					}
					if(mapPath.isWalkable(i, j, firstPlayer.cid, firstPlayer.sid))
					{
						var point:Point = new Point();
						point.x = i;
						point.y = j;
						points.push(point);
					}
				}
			}
			var index:int = Math.random()*points.length;
			point = points[index];
			return point;
		}
		/**
		 * 
		 * @param entity 目标
		 * @param id 技能组id或技能id
		 * @param type 0：技能组id，1：技能id
		 * @param isRollTipShow 由于需要在AttackPkState及AttackState调用改方法，且为帧调用，所以提示不需要显示
		 * @return 
		 */		
		public function useSkillDeal(target:IEntity,id:int,type:int = 0,isRollTipShow:Boolean = true):Boolean
		{
			var isEqual:Boolean = ActivityDataManager.instance.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_SEA_SIDE);
			if(isEqual)
			{
				return true;
			}
			var skillCfgData:SkillCfgData;
			if(type)
			{
				skillCfgData = ConfigDataManager.instance.skillCfgData1(id);
			}
			else
			{
				skillCfgData = SkillDataManager.instance.skillCfgData(id);
			}
			if (!skillCfgData)
			{
				return true;
			}
			var pulbicCoolDown:int = RoleDataManager.instance.pulbicCoolDown;
			if(!skillCfgData.no_public_cd && getTimer() - _lastSkillTime < pulbicCoolDown)
			{
				return true;
			}
			if (!SkillDataManager.instance.checkSkillCd(skillCfgData))
			{
				if(isRollTipShow)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.PROMPT_PANEL_0026);
				}
				return true;
			}
			if (!SkillDataManager.instance.checkSkillMpCost(skillCfgData))
			{
				if(isRollTipShow)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.PROMPT_PANEL_0025);
				}
				return true;
			}
			var targetTile:Point;
			if(!target)
			{
				targetTile = GameSceneManager.getInstance().mouseTile;
			}
			else
			{
				targetTile = new Point(target.tileX,target.tileY);
			}
			//
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (skillCfgData.range != SkillConstants.RANGE_SELF)
			{
				var checkDistance1:int = checkDistance(skillCfgData.dist, targetTile);
				if (checkDistance1 == 1)//位置重叠
				{
					return true;
				}
				else if (checkDistance1 == -1)//超出攻击距离
				{
					if(target && skillCfgData.target_type != SkillConstants.SKILL_TARGET_TYPE_GROUND)
					{
						if(isRollTipShow)
						{
							Alert.warning(StringConst.WARNING_SKILL_TOO_FAR);
						}
						return false;
					}
					else
					{
						if(skillCfgData.target_type == SkillConstants.SKILL_TARGET_TYPE_GROUND)
						{
							target = null;
						}
						maxTile(skillCfgData.dist,targetTile);
					}
				}
				var tileToPixel:Point = MapTileUtils.tileToPixel(targetTile.x, targetTile.y);
				if (!(skillCfgData.special == SkillConstants.SPECIAL_KNOCK && !target))
				{
					firstPlayer.direction = Direction.getDirectionByPixel(firstPlayer.pixelX, firstPlayer.pixelY, tileToPixel.x, tileToPixel.y, firstPlayer.direction);
				}
			}
			//
			sendServerMove();
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeByte(firstPlayer.direction);
			byteArray.writeShort(firstPlayer.tileX);
			byteArray.writeShort(firstPlayer.tileY);
			if(target)
			{
				byteArray.writeByte(SkillConstants.SKILL_TARGET_TYPE_TARGET);
				byteArray.writeInt(target.entityId);
				byteArray.writeByte(target.entityType);
			}
			else
			{
				byteArray.writeByte(SkillConstants.SKILL_TARGET_TYPE_GROUND);
				byteArray.writeShort(targetTile.x);
				byteArray.writeShort(targetTile.y);
			}
			var proc:int = type ? GameServiceConstants.CM_DO_TRIGGER_SKILL : GameServiceConstants.CM_DO_UNIT_SKILL;
			ClientSocketManager.getInstance().asyncCall(proc, byteArray);
			//
			_inMapPath = null;
			setLastSkillTime(Boolean(skillCfgData.no_public_cd));
			dealUseknock(skillCfgData,firstPlayer);
			//
			if(skillCfgData.action_type == SkillConstants.ACTION_TYPE_PATTACK)
			{
				firstPlayer.pAttack();
			}
			else if(skillCfgData.action_type == SkillConstants.ACTION_TYPE_MATTACK)
			{
				firstPlayer.mAttack();
			}
			//
			var targets:Vector.<ILivingUnit> = new Vector.<ILivingUnit>();
			targets.push(target);
			SkillDealManager.instance.addEffects(skillCfgData, firstPlayer, new Point(firstPlayer.tileX, firstPlayer.tileY), targets, targetTile);
			//
			SkillDataManager.instance.skillDone(skillCfgData.group_id);
			//
			var clickSkillGroupId:int = ActionBarDataManager.instance.clickSkillGroupId;
			ActionBarDataManager.instance.clickSkillGroupId = clickSkillGroupId == skillCfgData.group_id ? 0 : clickSkillGroupId;
			/*trace("AutoJobManager.useSkillDeal(entity, livingUnit, skillCfgData) 使用技能:"+skillCfgData.name+"，通知服务器，时间："+getTimer());*/
			return true;
		}
		/**
		 * 判断距离
		 * @param dist
		 * @param targetTile
		 * @return -1：超出攻击距离，1：位置重叠，0：正常
		 */		
		private function checkDistance(dist:int,targetTile:Point):int
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var tileDist:int = firstPlayer.tileDistance(targetTile.x, targetTile.y) - dist;
			if (tileDist <= 0)
			{
				if (firstPlayer.targetTileX != firstPlayer.tileX)
				{
					firstPlayer.targetTileX = firstPlayer.tileX;
				}
				if (firstPlayer.targetTileY != firstPlayer.tileY)
				{
					firstPlayer.targetTileY = firstPlayer.tileY;
				}
				
				if (firstPlayer.pixelX != firstPlayer.targetPixelX || firstPlayer.pixelY != firstPlayer.targetPixelY)
				{
					return 1;
				}
			}
			else
			{
				if(!inMapPath)
				{
					resetTargetTile();
				}
				return -1;
			}
			return 0;
		}
		/**
		 * 获得可释放技能的最远距离
		 * @param dist
		 * @param tile
		 */		
		private function maxTile(dist:int,tile:Point):void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var dx:int = tile.x - firstPlayer.tileX;
			var dy:int = tile.y - firstPlayer.tileY;
			var sx:int = dx ? dx/Math.abs(dx) : 0;
			var sy:int = dy ? dy/Math.abs(dy) : 0;
			var k:Number = dx ? dy/dx : 0;
			var absk:Number = Math.abs(k);
			if(absk == 1 || absk == 0)
			{
				tile.x = firstPlayer.tileX + sx*dist;
				tile.y = firstPlayer.tileY + sy*dist;
			}
			else if(absk > 1)
			{
				tile.x = firstPlayer.tileX + Math.round(sy*dist/k);
				tile.y = firstPlayer.tileY + sy*dist;
			}
			else if(absk < 1)
			{
				tile.x = firstPlayer.tileX + sx*dist;
				tile.y = firstPlayer.tileY + Math.round(sx*dist*k);
			}
		}
		/**处理使用野蛮冲撞*/
		private function dealUseknock(skillCfgData:SkillCfgData,firstPlayer:IFirstPlayer):void
		{
			if (skillCfgData.special == SkillConstants.SPECIAL_KNOCK)
			{
				var mapPathManager:MapPathManager = MapPathManager.getInstance();
				if (mapPathManager.ready)
				{
					var nTile:int = skillCfgData.special_param;
					var targetPos:Point = null;
					var pos:Point = MapTileUtils.getAroundTile(firstPlayer.tileX, firstPlayer.tileY, firstPlayer.direction);
					var dicVector:Vector.<Dictionary> = EntityLayerManager.getInstance().getAllLivingUnit();
					while (mapPathManager.isWalkable(pos.x, pos.y, firstPlayer.cid, firstPlayer.sid) && nTile-- > 0)
					{
						var find:Boolean = false;
						for each (var dic:Dictionary in dicVector)
						{
							for each (var livingUnit:ILivingUnit in dic)
							{
								if (livingUnit != firstPlayer && livingUnit.tileX == pos.x && livingUnit.tileY == pos.y)
								{
									find = true;
									break;
								}
							}
							if (find)
							{
								break;
							}
						}
						if (find)
						{
							break;
						}
						targetPos = pos;
						pos = MapTileUtils.getAroundTile(pos.x, pos.y, firstPlayer.direction);
					}
					if (targetPos && (targetPos.x != firstPlayer.tileX || targetPos.y != firstPlayer.tileY))
					{
						firstPlayer.startKnock();
						firstPlayer.knockTo(firstPlayer.tileX, firstPlayer.tileY, targetPos.x, targetPos.y, targetPos.x, targetPos.y, false);
					}
				}
			}
		}
		
		public function dealKnockAttack(target:IEntity):void
		{
			if(target)
			{
				selectEntity = target;
			}
			if(!_selectEntity)
			{
				return;
			}
			if(AutoSystem.instance.isAuto())
			{
				return;
			}
			if(_selectEntity.entityType == EntityTypes.ET_PLAYER)
			{
				var isWithoutShift:Boolean = AutoDataManager.instance.isWithoutShift;
				if(isWithoutShift)
				{
					AutoSystem.instance.startIndepentAttack(_selectEntity.entityType,_selectEntity.entityId);
				}
			}
			else
			{
				AutoSystem.instance.startIndepentAttack(_selectEntity.entityType,_selectEntity.entityId);
			}
		}
		
		public function setLastSkillTime(no_public_cd:Boolean = false):void
		{
			_lastSkillTime = no_public_cd ? _lastSkillTime : getTimer();
			/*trace("AutoJobManager.setLastSkillTime(no_public_cd) _lastSkillTime:"+_lastSkillTime);*/
		}
		
		public function get lastSkillTime():int
		{
			return _lastSkillTime;
		}
		
		public function useSkill(skillGroupId:int):void
		{
			var skillCfgData:SkillCfgData = SkillDataManager.instance.skillCfgData(skillGroupId);
			if (!skillCfgData)
			{
				return;
			}
			if(skillCfgData.group_id == SkillConstants.ZS_CSJS || skillCfgData.group_id == SkillConstants.ZS_BYWD)
			{
				switchZSSkill(skillCfgData);
				return;
			}
			ActionBarDataManager.instance.clickSkillGroupId = skillCfgData.group_id;
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (!skillCfgData.no_public_cd && (checkRigor() || firstPlayer.isPalsy || firstPlayer.isFrozen))
			{
				/*trace("AutoJobManager.useSkill(skillGroupId)");*/
				return;
			}
			var isAutoFight:Boolean = AutoSystem.instance.isAutoFight();
			var isMagicLocking:Boolean = AutoDataManager.instance.isMagicLocking;
			var lu:ILivingUnit = selectEntity as ILivingUnit;
			if(!isAutoFight && !(isMagicLocking && lu && lu.isEnemy && lu.hp > 0))
			{
				if(_overEntity && _overEntity.isShow && _overEntity.selectable)
				{
					selectEntity = _overEntity;
					if (skillCfgData.special != SkillConstants.SPECIAL_KNOCK)//野蛮冲撞在冲撞结束后设置自动攻击
					{
						AutoSystem.instance.startIndepentAttack(selectEntity.entityType,selectEntity.entityId);
					}
				}
			}
			if (skillCfgData.range == SkillConstants.RANGE_SELF)//若技能作用目标是自己
			{
				useSkillDeal(firstPlayer,skillCfgData.group_id);
			}
			else
			{
				if (!_selectEntity || !_selectEntity.isShow)//若当前无选中的目标
				{
					/*RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HEJI_PANEL_0004);
					return;*/
					useSkillDeal(null,skillCfgData.group_id);
				}
				else
				{
					/*_autoTargetEntity = null;*///主动使用技能不打断自动攻击目标状态
					resetTargetTile();
					if (isCanUseSkillTarget(_selectEntity))
					{
						var livingUnit:ILivingUnit = _selectEntity as ILivingUnit;
						if (livingUnit.hp > 0)
						{
							if(skillCfgData.center == SkillConstants.CENTER_MOUSE)
							{
								useSkillDeal(null,skillCfgData.group_id);
							}
							else
							{
								useSkillDeal(_selectEntity,skillCfgData.group_id);
							}
						}
						else
						{
							_selectEntity.setSelected(false);
							_selectEntity = null;
						}
					}
					else
					{
						useSkillDeal(null,skillCfgData.group_id);
					}
				}
			}
		}
		/**开关战士技能<br>刺杀剑术、半月弯刀*/
		public function switchZSSkill(skillCfgData:SkillCfgData):void
		{
			var manager:AutoDataManager = AutoDataManager.instance;
			if(skillCfgData.group_id == SkillConstants.ZS_CSJS)
			{
				manager.changeQuickSetState(1);
			}
			else if(skillCfgData.group_id == SkillConstants.ZS_BYWD)
			{
				manager.changeQuickSetState(0);
			}
			manager.sendCfg();
		}
		
		public function useSkillByShift(direction:int):void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if(checkRigor() || firstPlayer.isPalsy || firstPlayer.isFrozen)
			{
				return;
			}
			var pulbicCoolDown:int = RoleDataManager.instance.pulbicCoolDown;
			if(getTimer() - _lastSkillTime < pulbicCoolDown)
			{
				return;
			}
			var skillCfgData:SkillCfgData;
			if(firstPlayer.job == JobConst.TYPE_ZS)
			{
				var buff:BuffData = AxFuncs.selectTriggerSkillBuff();
				skillCfgData = buff ? AxFuncs.getSkillCfg(buff.specialTriggerSkill) : null;
				var aroundTile:Point = MapTileUtils.getAroundTile(firstPlayer.tileX,firstPlayer.tileY,direction);
				var target:Entity = new Entity();
				target.tileX = aroundTile.x;
				target.tileY = aroundTile.y;
				if(skillCfgData)
				{
					var isTrigger:Boolean;//目标格是否有怪物
					for each(var monster:IMonster in EntityLayerManager.getInstance().monsterDic)
					{
						if(AxFuncs.monsterFilter(monster) && monster.tileDistance(target.tileX,target.tileY)<=0)
						{
							isTrigger = true;
							break;
						}
					}
					isTrigger ? null : skillCfgData = null;
				}
				if(!skillCfgData)//若无烈火剑法可释放
				{
					skillCfgData = AxFuncs.selectSkill(firstPlayer,target,
						AxFuncs.getSkillFight(firstPlayer.job),
						AxFuncs.getSkillAuto(firstPlayer.job),
						AxFuncs.getSkillDefault(firstPlayer.job),
						function (cfgDt:SkillCfgData):Boolean
						{
							if(cfgDt.group_id == SkillConstants.ZS_CSJS || cfgDt.group_id == SkillConstants.ZS_BYWD)
							{
								return true;
							}
							else
							{
								return false;
							}
						});
				}
			}
			if(!skillCfgData)//若无刺杀或半月可释放
			{
				var skillGroupId:int = ActionBarDataManager.instance.getNormalSkillGroupId();
				skillCfgData = SkillDataManager.instance.skillCfgData(skillGroupId);
			}
			if(!skillCfgData)
			{
				return;
			}
			if(!SkillDataManager.instance.checkSkillCd(skillCfgData))
			{
				return;
			}
			firstPlayer.direction = direction;
			/*sendServerMove();*/
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(skillCfgData.group_id);
			byteArray.writeByte(direction);
			byteArray.writeShort(firstPlayer.tileX);
			byteArray.writeShort(firstPlayer.tileY);
			byteArray.writeByte(SkillConstants.SKILL_TARGET_TYPE_SHIFT);
			var proc:int = isTrigger ? GameServiceConstants.CM_DO_TRIGGER_SKILL : GameServiceConstants.CM_DO_UNIT_SKILL;
			ClientSocketManager.getInstance().asyncCall(proc, byteArray);
			_inMapPath = null;
			setLastSkillTime();
			
			if(skillCfgData.action_type == SkillConstants.ACTION_TYPE_PATTACK)
			{
				firstPlayer.pAttack();
			}
			else if(skillCfgData.action_type == SkillConstants.ACTION_TYPE_MATTACK)
			{
				firstPlayer.mAttack();
			}
			/*trace("技能"+skillCfgData.name+"执行一次攻击，时间："+getTimer());*/
			SkillDealManager.instance.addEffects(skillCfgData, firstPlayer, new Point(firstPlayer.tileX, firstPlayer.tileY), null, null);
			SkillDataManager.instance.skillDone(skillGroupId);
		}
		
		public function useJointSkill():void
		{
			//判断先决条件
			var isHeroFight:Boolean = HeroDataManager.instance.isHeroFight();
			if(!isHeroFight)
			{
				Alert.warning(StringConst.HEJI_PANEL_0007);
				return;
			}
			var manager:HejiSkillDataManager = HejiSkillDataManager.instance;
			if(!manager.isAngryFull)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HEJI_PANEL_0003);
				return;
			}
			if(!AutoSystem.instance.isAutoFight())//挂机中，不提供划过目标选中功能
			{
				if(_overEntity && _overEntity.isShow && _overEntity.selectable)
				{
					selectEntity = _overEntity;
				}
			}
			if(!_selectEntity || !_selectEntity.isShow)//若当前无选中的目标
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HEJI_PANEL_0004);
				return;
			}
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (firstPlayer.isPalsy || firstPlayer.isFrozen)
			{
				return;
			}
			if(!isCanUseSkillTarget(_selectEntity))
			{
				Alert.warning(StringConst.HEJI_PANEL_0006);
				return;
			}
			if(_selectEntity.entityType == EntityTypes.ET_HERO && ((_selectEntity as IHero).ownerId == firstPlayer.cid && (_selectEntity as IHero).sid == firstPlayer.sid))//对自己的英雄使用合击
			{
				Alert.warning(StringConst.HEJI_PANEL_0009);
				return;
			}
			//
			var livingUnit:ILivingUnit = _selectEntity as ILivingUnit;
			if (livingUnit.hp > 0)
			{
				trace("AutoJobManager.useJointSkill() 执行一次合击");
				SkillDealManager.instance.sendJiontSkillPrepare(1,_selectEntity.entityId,_selectEntity.entityType);
				if(!_autoTargetEntity)
				{
					if(AutoSystem.instance.isAutoFight())
					{
						return;
					}
					if(_selectEntity.entityType == EntityTypes.ET_PLAYER)
					{
						var isWithoutShift:Boolean = AutoDataManager.instance.isWithoutShift;
						if(isWithoutShift)
						{
							AutoSystem.instance.startIndepentAttack(_selectEntity.entityType,_selectEntity.entityId);
						}
					}
					else
					{
						AutoSystem.instance.startIndepentAttack(_selectEntity.entityType,_selectEntity.entityId);
					}
				}
			}
			else
			{
				SkillDealManager.instance.sendJiontSkillPrepare(0);
				_selectEntity.setSelected(false);
				_selectEntity = null;
			}
		}
		
		/**
		 * @return needRun
		 */
		internal function runTo(tileX:int, tileY:int, tileDist:int):Boolean
		{
			if(_targetTileX == tileX && _targetTileY == tileY)
			{
				return false;
			}
			_targetTileX = tileX;
			_targetTileY = tileY;
			var targetTile:Point = new Point(_targetTileX, _targetTileY);
			var mapId:int = SceneMapManager.getInstance().mapId;
			var mapConfig:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			var mapRows:int = Math.floor(mapConfig.height/MapTileUtils.TILE_HEIGHT);
			var mapCols:int = Math.floor(mapConfig.width/MapTileUtils.TILE_WIDTH);
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (firstPlayer && firstPlayer.hp > 0)
			{
				var firstPlayerTile:Point = MapTileUtils.pixelToTile(firstPlayer.pixelX, firstPlayer.pixelY);
				var mapPathManager:MapPathManager = MapPathManager.getInstance();
				_inMapPath = mapPathManager.findPath(firstPlayerTile, targetTile, 0, 0, mapCols, mapRows, tileDist);
				if (_inMapPath && _inMapPath.length > 0)
				{
					firstPlayer.targetPixelX = firstPlayer.pixelX;
					firstPlayer.targetPixelY = firstPlayer.pixelY;
				}
				else
				{
					Alert.warning(StringConst.MAP_PANEL_NO_PATH);
					return false;
				}
			}
			
			return true;
		}
		
		private function checkReachTile():Boolean
		{
			var manager:MapPathManager = MapPathManager.getInstance();
			var isMine:Boolean = manager.isMine(_targetTileX,_targetTileY);
			if(isMine)
			{
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				var tileDist:int = firstPlayer.tileDistance(_targetTileX, _targetTileY);
				if (tileDist <= TO_MINE_TILE_DIST)
				{
					sendBeginMining(_targetTileX,_targetTileY);
					_autoTargetEntity = null;
					resetTargetTile();
					_inMapPath = null;
					return true;
				}
			}
			return false;
		}
		
		public function directMove(pixelX:int, pixelY:int, runType:int, isReset:Boolean = true):void
		{
			if (checkRigor())
			{
				return;
			}
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (!firstPlayer || firstPlayer.hp <= 0 || firstPlayer.isPalsy || firstPlayer.isFrozen)
			{
				return;
			}
			var dir:int = Direction.getDirectionByPixel(firstPlayer.pixelX, firstPlayer.pixelY, pixelX, pixelY, firstPlayer.direction);
			if (dir != firstPlayer.direction && (firstPlayer.pixelX != firstPlayer.targetPixelX || firstPlayer.pixelY != firstPlayer.targetPixelY))
			{
				return;
			}
			var xOffset:int = Direction.getOffsetXByDir(dir);
			var yOffset:int = Direction.getOffsetYByDir(dir);
			var nextTileX:int = firstPlayer.tileX + xOffset;
			var nextTileY:int = firstPlayer.tileY + yOffset;
			var walkable:Boolean = false;
			var mapPathManager:MapPathManager = MapPathManager.getInstance();
			if (mapPathManager.isWalkable(nextTileX, nextTileY, firstPlayer.cid, firstPlayer.sid))
			{
				walkable = true;
				if (runType == RunTypes.RT_FORCE_RUN || runType == RunTypes.RT_NORMAL && (Math.abs(pixelX - firstPlayer.pixelX) > MapTileUtils.TILE_WIDTH * 2 || Math.abs(pixelY - firstPlayer.pixelY) > MapTileUtils.TILE_HEIGHT * 2))
				{
					var runTileX:int = nextTileX + xOffset;
					var runTileY:int = nextTileY + yOffset;
					if (mapPathManager.isWalkable(runTileX, runTileY, firstPlayer.cid, firstPlayer.sid))
					{
						nextTileX = runTileX;
						nextTileY = runTileY;
					}
				}
			}
			else
			{
				var rotate:int = Direction.getRoateDirToPos(dir, firstPlayer.pixelX, firstPlayer.pixelY, pixelX, pixelY);
				var newDir:int = (dir + rotate + Direction.TOTAL_DIRECTION) % Direction.TOTAL_DIRECTION;
				nextTileX = firstPlayer.tileX + Direction.getOffsetXByDir(newDir);
				nextTileY = firstPlayer.tileY + Direction.getOffsetYByDir(newDir);
				if (mapPathManager.isWalkable(nextTileX, nextTileY, firstPlayer.cid, firstPlayer.sid))
				{
					walkable = true;
				}
				else
				{
					newDir = (dir - rotate + Direction.TOTAL_DIRECTION) % Direction.TOTAL_DIRECTION;
					nextTileX = firstPlayer.tileX + Direction.getOffsetXByDir(newDir);
					nextTileY = firstPlayer.tileY + Direction.getOffsetYByDir(newDir);
					if (mapPathManager.isWalkable(nextTileX, nextTileY, firstPlayer.cid, firstPlayer.sid))
					{
						walkable = true;
					}
					else
					{
						newDir = (dir + rotate * 2 + Direction.TOTAL_DIRECTION) % Direction.TOTAL_DIRECTION;
						nextTileX = firstPlayer.tileX + Direction.getOffsetXByDir(newDir);
						nextTileY = firstPlayer.tileY + Direction.getOffsetYByDir(newDir);
						if (mapPathManager.isWalkable(nextTileX, nextTileY, firstPlayer.cid, firstPlayer.sid))
						{
							walkable = true;
						}
					}
				}
			}
			if(isReset)
			{
				_autoTargetEntity = null;
				resetTargetTile();
				_autoFindPath.reset();
				_autoFindPath.destroyEffect();
				_autoKillMst.reset();
				_autoCollectPlant.reset();
			}
			if (walkable)
			{
				_autoTargetEntity = null;
				resetTargetTile();
				_inMapPath = null;
				firstPlayer.targetTileX = _targetTileX = nextTileX;
				firstPlayer.targetTileY = _targetTileY = nextTileY;
				if (firstPlayer.tileDistance(nextTileX, nextTileY) > WALK_DIST)
				{
					firstPlayer.run();
				}
				else
				{
					firstPlayer.walk();
				}
				sendServerMove();
				searchDropItem();
			}
		}
		
		private function searchDropItem():void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var dropItemDic:Dictionary,dropItem:IDropItem;
			dropItemDic = EntityLayerManager.getInstance().dropItemDic;
			for each(dropItem in dropItemDic)
			{
				if(dropItem.tileX == firstPlayer.targetTileX && dropItem.tileY == firstPlayer.targetTileY)
				{
					_stayOnDropItemId = dropItem.entityId;
					break;
				}
			}
		}
		
		public function runToTile(tileX:int, tileY:int, tileDist:int):void
		{
			if (checkRigor())
			{
				return;
			}
			_autoTargetEntity = null;
			resetTargetTile();
			runTo(tileX, tileY, tileDist);
		}
		
		public function runToEntity(entity:IEntity):void
		{
			if (checkRigor())
			{
				return;
			}
			var isRun:Boolean = false;
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (entity.entityType == EntityTypes.ET_TELEPORTER/* && (Math.abs(firstPlayer.tileX - entity.tileX) > 0 || Math.abs(firstPlayer.tileY - entity.tileY) > 0)*/)
			{
				isRun = true;
			}
			else if (entity.entityType == EntityTypes.ET_NPC)
			{
				isRun = true;
			}
			else if ((entity.entityType == EntityTypes.ET_MONSTER || (entity.entityType == EntityTypes.ET_PLAYER && entity.entityId != firstPlayer.entityId)))
			{
				if((entity as ILivingUnit).isEnemy || (entity.entityType == EntityTypes.ET_PLAYER && (entity as IPlayer).specialAction == SpecialActionTypes.PSA_LAY))
				{
					isRun = true;
				}
			}
			else if(entity.entityType == EntityTypes.ET_HERO && ((entity as IHero).ownerId != firstPlayer.cid || (entity as IHero).sid != firstPlayer.sid))
			{
				isRun = true;
			}
			else if(entity.entityType == EntityTypes.ET_PET && ((entity as IPet).ownId != firstPlayer.cid || (entity as IPet).sid != firstPlayer.sid))
			{
				isRun = true;
			}
			else if(entity.entityType == EntityTypes.ET_TRAILER && ((entity as ITrailer).ownerCid != firstPlayer.cid || (entity as ITrailer).ownerSid != firstPlayer.sid))
			{
				isRun = true;
			}
			else if (entity.entityType == EntityTypes.ET_DROPITEM)
			{
				isRun = true;
			}
			else if (entity.entityType == EntityTypes.ET_PLANT)
			{
				isRun = true;
			}
			else if (entity.entityType == EntityTypes.ET_TRAP)
			{
				isRun = true;
			}
			if (isRun)
			{
				_autoTargetEntity = entity;
				runTo(_autoTargetEntity.tileX, _autoTargetEntity.tileY, _autoTargetEntity.tileDistToReach);
			}
		}
		
		public function isRunningToNpc(npcId:int):Boolean
		{
			if(_autoFindPath && _autoFindPath.targetId)
			{
				if(_autoFindPath.targetId == npcId && _autoFindPath.targetType == EntityTypes.ET_NPC)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else if(_autoTargetEntity)
			{
				if(_autoTargetEntity.entityId == npcId && _autoTargetEntity.entityType == EntityTypes.ET_NPC)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			
			
			return false;
		}
		
		/**
		 * 是否在动作硬直时间中
		 * @return 
		 */		
		public function checkRigor():Boolean
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (firstPlayer)
			{
				var jobCfgData:JobCfgData = ConfigDataManager.instance.jobCfgDatasById(firstPlayer.job);
				if (jobCfgData)
				{
					var tick:int = getTimer();
					if (tick - _lastSkillTime < jobCfgData.rigor)
					{
						return true;
					}
					return firstPlayer.knocking || firstPlayer.beKnocking || tick - firstPlayer.lastBeKnockTick < jobCfgData.rigor;
				}
			}
			return false;
		}
		
		public function reset(isClearMovingFlag:Boolean = false):void
		{
			_autoTargetEntity = null;
			resetTargetTile();
			_inMapPath = null;
			_autoFindPath.reset();
			if(isClearMovingFlag)
			{
				_autoFindPath.destroyEffect();
			}
			_autoKillMst.reset();
			_autoCollectPlant.reset();
			_overLapMoveLct = null;
		}
		
		public function resetOverLapMoveLct():void
		{
			_overLapMoveLct = null;
		}
		
		private function resetTargetTile():void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if(firstPlayer==null)return;
			_targetTileX = firstPlayer.tileX;
			_targetTileY = firstPlayer.tileY;
		}
		
		public function sendServerMove():void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeShort(firstPlayer.tileX);
			byteArray.writeShort(firstPlayer.tileY);
			byteArray.writeShort(firstPlayer.targetTileX);
			byteArray.writeShort(firstPlayer.targetTileY);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE, byteArray);
		}
		
		public function sendBeginGather(plantEntityId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(plantEntityId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BEGIN_GATHER, byteArray);
		}
		
		public function sendServerSwitchMap(teleportId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(teleportId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SWITCH_MAP, byteArray);
		}
		
		public function sendBeginMining(tileX:int,tileY:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(tileX);
			byteArray.writeInt(tileY);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BEGIN_MINE, byteArray);
		}
		
		/**
		 *传送点是否满足条件传送 
		 * @param teleportId
		 * @return 
		 * 
		 */		
		private function canTeleport(teleportId:int):Boolean
		{
			var mapTeleportCfg:MapTeleportCfgData = ConfigDataManager.instance.mapTeleporterCfgData(teleportId);
			var mapRegionCfg:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(mapTeleportCfg.region_to);
			var mapCfg:MapCfgData = ConfigDataManager.instance.mapCfgData(mapRegionCfg.map_id);
			if(mapCfg.reincarn > RoleDataManager.instance.reincarn)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DUNGEON_PANEL_0024);
				return false;
			}
			else if(mapCfg.reincarn == RoleDataManager.instance.reincarn)
			{
				if(mapCfg.level > RoleDataManager.instance.lv)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DUNGEON_PANEL_0024);
					return false;
				}
				else
				{
					if(mapTeleportCfg.vip > VipDataManager.instance.lv)
					{
						if(mapTeleportCfg.bind_gold > BagDataManager.instance.goldBind)
						{
							RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0023);
							return false;
						}
					}
				}
			}
			else
			{
				if(mapTeleportCfg.vip > VipDataManager.instance.lv)
				{
					if(mapTeleportCfg.bind_gold > BagDataManager.instance.goldBind)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0023);
						return false;
					}
				}
			}
			PanelTransData.vip = mapTeleportCfg.vip;
			PanelTransData.gold_bind = mapTeleportCfg.bind_gold;
			return true;
		}
		
		public function get targetEntity():IEntity
		{
			return _autoTargetEntity;
		}
		/**设置自动寻路目标（entity）*/
		public function setAutoTargetData(targetId:int,targetType:int):void
		{
			_autoFindPath.reset();
			_autoFindPath.targetId = targetId;
			_autoFindPath.targetType = targetType;
			_autoFindPath.newEffect();
		}
		/**设置自动寻路目标（位置）*/
		public function setAutoFindPathPos(targetPos:Point, targetMapId:int, targetTileDist:int):void
		{
			_autoFindPath.reset();
			_autoFindPath.setTargetPos(targetPos, targetMapId, targetTileDist);
			_autoFindPath.newEffect();
		}
		
		internal function setAutoKillMstId(mstGroupId:int):void
		{
			_autoKillMst.mstGroupId = mstGroupId;
		}
		
		internal function setAutoCollectPlantId(plantGroupId:int):void
		{
			_autoCollectPlant.plantGroupId= plantGroupId;
		}
		
		public function get inMapPath():Array
		{
			return _inMapPath;
		}

		public function get selectEntity():IEntity
		{
			return _selectEntity;
		}

		public function set selectEntity(value:IEntity):void
		{
			if(_selectEntity)
			{
				_selectEntity.setSelected(false);
			}
			if(value)
			{
				value.setSelected(true);
			}
			_selectEntity = value;
			MainUiMediator.getInstance().playHp.refreshHp();
		}

		public function get overEntity():IEntity
		{
			return _overEntity;
		}

		public function set overEntity(value:IEntity):void
		{
			if(_overEntity)
			{
				_overEntity.setOver(false);
			}
			if(value)
			{
				value.setOver(true);
			}
			_overEntity = value;
		}
		
		public function isAutoPath():Boolean
		{
			return _inMapPath && _inMapPath.length > 0;
		}
	}
}

class PrivateClass{}