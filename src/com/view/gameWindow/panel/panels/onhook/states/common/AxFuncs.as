package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.core.getDictElement;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.ItemTypeCfgData;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.JobConst;
	import com.model.consts.MapConst;
	import com.model.consts.MapPKMode;
	import com.model.consts.SlotType;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.boss.BossData;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.buff.BuffData;
	import com.view.gameWindow.panel.panels.buff.BuffDataManager;
	import com.view.gameWindow.panel.panels.map.MapDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.onhook.DrugCfg;
	import com.view.gameWindow.panel.panels.onhook.IBattleField;
	import com.view.gameWindow.panel.panels.onhook.states.drug.ChooseRightDrugIntent;
	import com.view.gameWindow.panel.panels.onhook.states.map.AutoMap;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillData;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskCondition;
	import com.view.gameWindow.panel.panels.task.item.TaskItem;
	import com.view.gameWindow.panel.panels.team.TeamDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.constants.RunTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IDropItem;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.map.path.MapPathManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	import com.view.gameWindow.scene.skillDeal.SkillDealManager;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	/**
	 * logic & map
	 * @author wqhk
	 * 2014-10-8
	 */
	public class AxFuncs
	{
		
		public static function stopAutoTask():void
		{
			TaskDataManager.instance.setAutoTask(false,"AxFuncs::stopAutoTask");
			AutoJobManager.getInstance().reset(true);
		}
		
		public static function startAutoTask():void
		{
			TaskDataManager.instance.setAutoTask(true,"AxFuncs::startAutoTask");
		}
		
		public static function directMove(pixelX:int, pixelY:int, isReset:Boolean = true):void
		{
			AutoJobManager.getInstance().directMove(pixelX, pixelY, RunTypes.RT_NORMAL, isReset);
		}
		/**
		 * tp 传送点. MapTeleportCfgData 
		 */
		public static function getTpList(curMapId:int,targetMapId:int):Array
		{
			return AutoMap.getTeleportList(curMapId,targetMapId);
		}
		
		public static function get selectEntity():IEntity
		{
			return AutoJobManager.getInstance().selectEntity;
		}
		
		public static function set selectEntity(value:IEntity):void
		{
			AutoJobManager.getInstance().selectEntity = value;
		}
		
		public static function isBlock(x:int,y:int):Boolean
		{
			var player:IFirstPlayer = firstPlayer;
			return !MapPathManager.getInstance().isWalkable(x, y, player.cid, player.sid);
		}
		
		public static function get battleField():IBattleField
		{
			return AutoSystem.instance.battleField;
		}
		
		public static function getEntity(entityType:int,entityId:int):IEntity
		{
			return EntityLayerManager.getInstance().getEntity(entityType,entityId);
		}
		
		public static function get firstPlayer():IFirstPlayer
		{
			return EntityLayerManager.getInstance().firstPlayer;
		}
		
		public static function get isCfgReady():Boolean
		{
			return AutoDataManager.instance.isReady;
		}
		
		public static function setTarget(entityId:int,entityType:int,plusId:int = 0):void
		{
			AutoSystem.instance.setTarget(entityId,entityType,plusId);
		}
		
		public static function moveToMapMonster(mapMonster:MapMonsterCfgData):void
		{
			if(mapMonster)
			{
				var pos:Point = getCanMoveLct(mapMonster.x,mapMonster.y);
				
				if(pos)
				{
					AutoFuncs.move(firstPlayer, pos.x, pos.y, 0);
				}
				else
				{
					Alert.show2(StringUtil.substitute("地图{0}, {1}, {2} 上的怪map monster {3} 不可通过",mapMonster.map_id,mapMonster.x,mapMonster.y,mapMonster.id));
				}
			}
		}
		
		
		public static function getMstsInMap(mapId:int):Array
		{
			var msts:Dictionary = ConfigDataManager.instance.mapMstCfgDataByMap(mapId);
			
			var re:Array = [];
			for each(var mapMst:MapMonsterCfgData in msts)
			{
				var dict:Dictionary = ConfigDataManager.instance.monsterCfgDatas(mapMst.monster_group_id);
				
				var mst:MonsterCfgData = getDictElement(dict);
				
				if(mst && mst.show_in_map)
				{
					re.push(mst);
				}
			}
			
			return re;
		}
		
		/**
		 * 增益技能 作用在自己身上
		 */
		public static function isSkillBeneficial(skill:SkillCfgData):Boolean
		{
			return skill.beneficial == SkillConstants.BENEFICIAL_TRUE; 
		}
		
		public static function setDrugIntent(intent:ChooseRightDrugIntent,cfg:DrugCfg):void
		{
			if(!cfg)
			{
				return;
			}
			
			if(cfg.isOpen)
			{
				if(cfg.isDescent)
				{
					intent.drugList = cfg.drugs;
				}
				else
				{
					intent.drugList = cfg.revDrugs;
				}
				
				intent.cdSecond = cfg.cd;
				intent.rateConditon = cfg.percent/100;
			}
			else
			{
				intent.drugList = [];
			}
		}
		
		public static function isAtPixel(entity:ILivingUnit):Boolean
		{
			return entity.targetPixelX == entity.pixelX &&
					entity.targetPixelY == entity.pixelY;
		}
		
		public static function isInDangerousPlace(mapId:int,tileX:int,tileY:int):Boolean
		{
			var mapCfg:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			if(mapCfg.pk_mode != MapPKMode.PEACE)
			{
				var type:int = MapDataManager.instance.getRegionType(tileX,tileY);
				
				return type != MapPKMode.PEACE;
			}
			
			return false;
		}
		

		/**
		 * @return 1 成功
		 */
		public static function useBagItem(item:int,num:int):int
		{
			var bag:BagDataManager = BagDataManager.instance;
			
			return bag.requestUseItem(item,num);
		}
		
		/**
		 * 不拐弯是否可直接抵达
		 */
		public static function isPassRoad(x:int,y:int,tX:int,tY:int):Boolean
		{
			var map:MapPathManager = MapPathManager.getInstance();
			var dis:int = 0;
			var stepX:int;
			var stepY:int;
			var dX:int = Math.abs(tX - x);
			var dY:int = Math.abs(tY - y);
			if(x == tX)
			{
				stepX = 0;
				stepY = tY > y ? 1 : -1;
				dis = dY;
			}
			else if(y == tY)
			{
				stepX = tX > x ? 1 : -1;
				stepY = 0;
				dis = dX;
			}
			else if(dX == dY)
			{
				stepX = tX > x ? 1 : -1;
				stepY = tY > y ? 1 : -1;
				dis = dX;
			}
			else
			{
				return false;
			}
			
			var player:IFirstPlayer = firstPlayer;
			while(dis>0)
			{
				x += stepX;
				y += stepY;
				if(!map.isWalkable(x, y, player.cid, player.sid))
				{
					return false;
				}
				--dis;
			}
			
			return true;
		}
		
		public static function isItem(type:int):Boolean
		{
			return type != ItemType.IT_MONEY && 
					type != ItemType.IT_MONEY_BIND &&
					type != ItemType.IT_GOLD && 
					type != ItemType.IT_GOLD_BIND;
		}
		
		
		public static function isBagFull():Boolean
		{
//			return BagDataManager.instance.getFirstEmptyCellId() == -1;
			return BagDataManager.instance.remainCellNum == 0;
		}
		
		public static function isDropItemValueType(item:IEntity):Boolean
		{
			var drop:IDropItem = item as IDropItem;
			
			if(!drop)
			{
				return false;
			}
			
			var isValue:Boolean = false;
			if(drop.itemType == SlotType.IT_ITEM)
			{
				var cfgItem:ItemCfgData = ConfigDataManager.instance.itemCfgData(drop.itemId);
				isValue = cfgItem.type >= ItemType.IT_EXP && cfgItem.type <= ItemType.IT_EXPLOIT;
			}
			
			return isValue;
		}
		
		//只捡自己掉落的东西
		public static  function dropItemFilter(item:IEntity):Boolean
		{
			var drop:IDropItem = item as IDropItem;
			
			if(!drop)
			{
				return false;
			}
			
			var player:IFirstPlayer = AxFuncs.firstPlayer;
			var isOwn:Boolean = (drop.ownerCid == 0 && drop.ownerSid == 0)
								|| (drop.ownerCid == player.cid && drop.ownerSid == player.sid)
								|| (drop.ownerTeamId == TeamDataManager.instance.teamId);
			var isFull:Boolean = isBagFull();
			var isCoin:Boolean = false;
			var isDrug:Boolean = false;
			var isMaterial:Boolean = false;
			var isEquip:Boolean = false;
			var cfgItem:ItemCfgData;
			var cfgEquip:EquipCfgData;
			if(drop.itemType == SlotType.IT_ITEM)
			{
				cfgItem = ConfigDataManager.instance.itemCfgData(drop.itemId);
				isCoin = cfgItem.type == ItemType.IT_MONEY || cfgItem.type == ItemType.IT_MONEY_BIND;
				
				var cfgType:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(cfgItem.type);
				isDrug = cfgType.type == ItemType.ITEM_TYPE_DRUG;
				isMaterial = cfgType.type == ItemType.ITEM_TYPE_MATERIAL;
			}
			else if(drop.itemType == SlotType.IT_EQUIP)
			{
				isEquip = true;
				cfgEquip = ConfigDataManager.instance.equipCfgData(drop.itemId);
			}
			
			var autoDataManager:AutoDataManager = AutoDataManager.instance;
			var re:Boolean =	drop.isShow
								&& (isEquip || autoDataManager.isPickUpOther || isCoin || isDrug || isMaterial)
								&& (!isFull || isCoin)//bag full
								&& (!isCoin || autoDataManager.isPickUpCoin) //coin
								&& (!isDrug || autoDataManager.isPickUpDrug && cfgItem.level >= autoDataManager.pickUpDrugLv)//drug
								&& (!isMaterial || autoDataManager.isPickUpMaterial)//meterial
								&& (!isEquip || autoDataManager.isPickUpEquip && cfgEquip.quality >= autoDataManager.pickUpEquipQuality && cfgEquip.level >= autoDataManager.pickUpEquipLv)//equip
								&& isOwn 
								&& isInBattlefield(item);
			
			return re;
		}
		
		public static function isDrugTp():Boolean
		{
			return AutoDataManager.instance.isTP;
		}
		
		public static function isRevive():Boolean
		{
			return AutoDataManager.instance.isRevive;
		}
		
		public static function isTimeTp():Boolean
		{
			return AutoDataManager.instance.isTime;
		}
		
		public static function timeTp():int
		{
			return AutoDataManager.instance.timeMin*60;
		}
		
		public static function useTp():int
		{
			var self:IPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (self.hp <= 0)
			{
				return 0;
			}
			
			var bag:BagDataManager = BagDataManager.instance;
			return bag.requestUseItem(ConfigAuto.ITEM_TP,1);
		}
		
		public static function useRevive():void
		{
			var bag:BagDataManager = BagDataManager.instance;
//			return bag.requestUseItem(ConfigAuto.ITEM_REVIVE,1);
			
			var num:int = bag.getItemNumById(ConfigAuto.ITEM_REVIVE);
			
			if(num>0)
			{
				AutoSystem.instance.dispatchEvent(new Event("revive"));
			}
		}
		
		public static function get starFightPos():Point
		{
			return new Point(AutoSystem.instance.startFightTileX,AutoSystem.instance.startFightTileY);
		}
		
		//是否在攻击范围中 （严格来说是 在战斗半径中是否在可跑到entity所在的位置）
		public static function isInBattlefield(entity:IEntity):Boolean
		{
			var startX:int = AutoSystem.instance.startFightTileX;
			var startY:int = AutoSystem.instance.startFightTileY;
			
			//全屏的时都可以走
			if(AutoDataManager.instance.isFullMapRange)
			{
				return true;
			}
			
			if(!battleField)
			{
				return false;
			}
			
			return battleField.isInField(entity.tileX,entity.tileY);
			
			//原先的寻路已经去掉
//			var dis:int = entity.tileDistance(startX,startY);
//			var radius:int = AutoDataManager.instance.battlefieldRadius;
//				
//			if(dis <= radius)
//			{
//				return true;
////				if(isPassRoad(startX,startY,entity.tileX,entity.tileY))
////				{
////					return true;
////				}
////				else
////				{
////					var fieldLeft:int = startX - radius;
////					var fieldTop:int = startY - radius;
////					var fieldRight:int = startX + radius;
////					var fieldBottom:int = startY + radius;
////						
////					var mapId:int = SceneMapManager.getInstance().mapId;
////					var mapRange:Rectangle = getMapRect(mapId);
////					
////					var path:Array = findPath(new Point(startX,startY),new Point(entity.tileX,entity.tileY),
////										Math.max(fieldLeft,mapRange.left),Math.max(fieldTop,mapRange.top),Math.min(fieldRight,mapRange.right),Math.min(fieldBottom,mapRange.bottom));
////					
////					if(path)
////					{
////						return true;
////					}
////				}
//			}
//			
//			return false;
		}
		
		public static function findPath(startTile:Point, targetTile:Point, topLeftX:int, topLeftY:int, bottomRightX:int, bottomRightY:int, tileDist:int):Array
		{
			return MapPathManager.getInstance().findPath(startTile,targetTile,topLeftX,topLeftY,bottomRightX,bottomRightY, tileDist);
		}
		
		
		public static function findMapMonster(mapId:int,groupId:int):MapMonsterCfgData
		{
			var cfgDatas:Dictionary = ConfigDataManager.instance.mapMstCfgDatas(groupId);
			var mapMstfgData:MapMonsterCfgData;
			var tileX:int;
			var tileY:int;
			for each(mapMstfgData in cfgDatas)
			{
				if(mapMstfgData.map_id == mapId)
				{
					//					tileX = (Math.random()*2-1)*mapMstfgData.h_radius+mapMstfgData.x;
					//					tileY = (Math.random()*2-1)*mapMstfgData.v_radius+mapMstfgData.y;
					//					return new Point(tileX,tileY);
					return mapMstfgData;
				}
			}
			
			return null;
		}
		
		public static function getCurMapId():int
		{
			return SceneMapManager.getInstance().mapId;
		}
		
		public static function isBossPriority():Boolean
		{
			return getCurMapId() == MapConst.EMOGUANGCHANG;
		}
		
		public static function isBossAttack():Boolean
		{
			return AutoSystem.instance.isBossAttack;
		}
		
		/**
		 * 注意目前的数据只有恶魔广场</br>
		 * 返回hp大于0的boss的MapMonsterCfgData数据
		 */
		public static function getMapBossList():Array
		{
			var bossList:Vector.<BossData> = BossDataManager.instance.getBossInfoByMapId(getCurMapId());
			bossList = bossList.filter(bossMonsterFilterForArr);
			var re:Array = null;
			for each(var boss:BossData in bossList)
			{
				if(boss.hp > 0)
				{
					if(!re)
					{
						re = [];
					}
					re.push(boss.mapMstCfgData)
				}
			}
			
			return re;
		}
		
		/**
		 * 地图上可见的,有血量的，可以攻击的monster
		 */
		public static function monsterFilter(m:ILivingUnit):Boolean
		{
			var player:IFirstPlayer = AxFuncs.firstPlayer;
			
			if(m)
			{
				if(m is IMonster && isInBattlefield(m) && m.isEnemy /*&& m.isShow*/ && m.hp>0)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function enemyLivingFilter(m:ILivingUnit):Boolean
		{
			return m && m.isEnemy && m.hp > 0;
		}
		
		public static function bossMonsterFilterForArr(data:*,index:int,list:*):Boolean
		{
			return data.hp > 0;
		}
		
		//只有恶魔广场会
		public static function bossMonsterFilter(m:ILivingUnit):Boolean
		{
			if(monsterFilter(m))
			{
				var monster:IMonster = IMonster(m);
				var mcfg:MonsterCfgData  = monster.mstCfgData;
				
				var bossList:Vector.<BossData> = BossDataManager.instance.getBossInfoByMapId(getCurMapId());
				
				for each(var boss:BossData in bossList)
				{
					if(boss.hp > 0 && boss.mapMstCfgData.monster_group_id == mcfg.group_id)
					{
						return true;
					}
				}
				
				return false;
			}
			return false;
		}
		
		public static function taskMonsterFilter(m:ILivingUnit):Boolean
		{
			if(monsterFilter(m))
			{
				var monster:IMonster = IMonster(m);
				var mcfg:MonsterCfgData  = monster.mstCfgData;
				var tasks:Dictionary = TaskDataManager.instance.onDoingTasks;
				var taskMonsterGroups:Array = [];
				for each(var task:TaskItem in tasks)
				{
					if(!task.completed)
					{
						var cfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(task.id);
						
						if(cfg && (cfg.condition == TaskCondition.TC_MONSTER_GROUP || cfg.condition == TaskCondition.TC_MONSTER_RANDOM))
						{
							var parsed:Array = cfg.request.split(":");
							if(parsed && parsed.length>0)
							{
								if(mcfg.group_id == parseInt(parsed[0]))
								{
									return true;
								}
							}
						}
					}
				}
			}
			return false;
		}
		
		public static function findNearestMapMonster(startX:int,startY:int,dict:*):MapMonsterCfgData
		{
			var minDis:int = int.MAX_VALUE;
			var target:MapMonsterCfgData = null;
			for each(var m:MapMonsterCfgData in dict)
			{
				if(m.count <= 0)
				{
					continue;
				}
				
				
				var dis:int = MapTileUtils.tileDistance(startX,startY,m.x,m.y);
				
				if(dis == 0)
				{
					return m;
				}
				else if(dis<minDis)
				{
					minDis = dis;
					target = m;
				}
			}
			
			return target;
		}
		
		public static function findNearestLivingUnit(attacker:IPlayer,dict:*,filter:Function):ILivingUnit
		{
			var minDis:int = int.MAX_VALUE;
			var target:ILivingUnit = null;
			for each(var m:ILivingUnit in dict)
			{
				if(!filter(m))
				{
					continue;
				}
				var dis:int = attacker.tileDistance(m.tileX,m.tileY);
				
				if(dis == 0)
				{
					return m;
				}
				else if(dis<minDis)
				{
					minDis = dis;
					target = m;
				}
			}
			
			return target;
		}
		
		public static function getMp():int
		{
			return RoleDataManager.instance.attrMp;
		}
		
		/**
		 * 简单检测是单攻还是群攻 魔法是否够 是否可以释放
		 */
		public static function checkSkill(attacker:IPlayer,target:IEntity,skillGroupId:int):SkillCfgData
		{
			var readySkill:SkillCfgData = AxFuncs.getCDReadySkill(attacker,skillGroupId,target);
			var num:int = 0;
			var threhold:int = 2;
			if(readySkill)
			{
				if(readySkill.mp_cost>AxFuncs.getMp())
				{
					return null;
				}
				
				if(readySkill.type == SkillConstants.HJ)
				{
					if(!target)
					{
						return null;
					}
					
					var hero:IEntity = EntityLayerManager.getInstance().myHero;
					
					if(hero && hero.isShow)
					{
						return readySkill;
					}
					
					return null;
				}
				else if(readySkill.beneficial == SkillConstants.BENEFICIAL_TRUE)
				{
					return readySkill;
				}
				else if(readySkill.range == SkillConstants.RANGE_SELF)
				{
					return readySkill;
				}
				else if(readySkill.range == SkillConstants.RANGE_SINGLE)
				{
					return readySkill;
				}
				else if(readySkill.range == SkillConstants.RANGE_LINE)//直线 现在直接算单攻  不然还要判断方向
				{
					return readySkill;
				}
				else 
				{
					if(attacker == target)
					{
						return readySkill;
					}
					
					for each(var monster:IMonster in EntityLayerManager.getInstance().monsterDic)
					{
						if(AxFuncs.monsterFilter(monster) && monster.tileDistance(target.tileX,target.tileY)<=1)
						{
							++num;
						}
						
						if(num>=threhold)
						{
							return readySkill;
						}
					}
				}
			}
			
			return null;
		}
		
		public static function selectTriggerSkillBuff():BuffData
		{
			var buff:BuffData = BuffDataManager.instance.triggerSkillBuff;
			
			return buff;
		}
		
		public static function getSkillCfg(skillId:int):SkillCfgData
		{
			return ConfigDataManager.instance.skillCfgData1(skillId);
		}
		
		public static function selectSkill(attacker:IPlayer,target:IEntity,fightList:Array,autoList:Array,defaultId:int,filter:Function = null):SkillCfgData
		{
			var skillList:Array = autoList.concat(fightList);
			
//			if(skillList)
//			{
//				skillList.sortOn("order",Array.NUMERIC);
//			}
			
			var skill:SkillCfgData = null;
			var skillId:int;
			
			var skillCfgList:Array = [];
			for each(skillId in skillList)
			{
				skill = SkillDataManager.instance.skillCfgData(skillId);
				if(skill)
				{
					skillCfgList.push(skill);
				}
			}
			
			if(skillCfgList.length > 0)
			{
				skillCfgList.sortOn("order",Array.NUMERIC);
			}
			
			skill = null;
			var skillCfg:SkillCfgData;
			for each(skillCfg in skillCfgList)
			{
				skill = checkSkill(attacker,target,skillCfg.group_id);
				
				if(skill)
				{
					if(filter != null)
					{
						if(!filter(skill))
						{
							skill = null;
							continue;
						}
					}
					break;
				}
			}
			
			//			if(!skill)
			//			{
			//				skillList = autoList;
			//				for each(skillId in skillList)
			//				{
			//					skill = checkSkill(attacker,target,skillId);
			//				}
			//			}
			
			if(!skill)
			{
				skill = checkSkill(attacker,target,defaultId);
				
				if(skill && filter != null)
				{
					if(!filter(skill))
					{
						skill = null;
					}
				}
			}
			
			//判断 有公共cd的僵直  没公共cd不用判断僵直
			if(skill && !skill.no_public_cd && AxFuncs.isRigor())
			{
				return null;
			}
			
			return skill;
		}
		
		/**
		 * 挂机技能
		 */
		public static function getSkillFight(job:int):Array
		{
			var re:Array = [];
			
			var skill:int = AutoDataManager.instance.multiTargetSkill;
			if(skill>0)
			{
				re.push(skill);
			}
			skill = AutoDataManager.instance.oneTargetSkill;
			if(skill>0)
			{
				re.push(skill);
			}
			
			return re;
		}
		
		public static function isInLine(startX:int,startY:int,targetX:int,targetY:int):Boolean
		{
			var dy:int = Math.abs(targetY-startY);
			var dx:int = Math.abs(targetX-startX);
			
			return dy == dx || dx == 0 || dy == 0;
				
		}
		
		/**
		 * 自动技能
		 */
		public static function getSkillAuto(job:int):Array
		{
//			switch(job)
//			{
//				case JobConst.TYPE_ZS:
//					return ConfigAuto.SKILL_AUTO_ZS;
//					break;
//				case JobConst.TYPE_FS:
//					return ConfigAuto.SKILL_AUTO_FS;
//					break;
//				case JobConst.TYPE_DS:
//					return ConfigAuto.SKILL_AUTO_DS;
//					break;
//			}
//			
//			return null;
			
			var autoSkills:Array = AutoDataManager.instance.selectedAutoSkillList;
			return autoSkills;
		}
		
		public static function getSkillDefault(job:int):int
		{
			switch(job)
			{
				case JobConst.TYPE_ZS:
					return ConfigAuto.SKILL_DEFAULT_ZS;
					break;
				case JobConst.TYPE_FS:
					return ConfigAuto.SKILL_DEFAULT_FS;
					break;
				case JobConst.TYPE_DS:
					return ConfigAuto.SKILL_DEFAULT_DS;
					break;
			}
			
			return ConfigAuto.SKILL_DEFAULT_ZS;
		}
		
		public static function getCDReadySkill(attacker:IPlayer,id:int,target:IEntity = null):SkillCfgData
		{
//			var publicCoolDown:int = RoleDataManager.instance.pulbicCoolDown;
//			if(getTimer() - RoleDataManager.instance.lastSkillTime < pulbicCoolDown)
//			{
//				return null;
//			}
			
			var skillData:SkillData = SkillDataManager.instance.skillData(id);
			
			if(!skillData || skillData.level <= 0)
			{
				return null;
			}
			var skillCfgData:SkillCfgData = SkillDataManager.instance.skillCfgData(skillData.group_id);
			
			var publicCoolDown:int = RoleDataManager.instance.pulbicCoolDown;
			//0 才是表示有公共cd
			if(skillCfgData.no_public_cd == 0 &&  getTimer() - AutoJobManager.getInstance().lastSkillTime < publicCoolDown)
			{
				return null;
			}
			
			if(skillCfgData.no_public_cd == 0 && isFrozen(attacker) && isknocking(attacker))
			{
				return null;
			}
			
			if(!SkillDataManager.instance.checkSkillCd(skillCfgData))
			{
				return null;
			}
			
			//合击
			if(skillCfgData.type == SkillConstants.HJ && !SkillDataManager.instance.checkJointSkillReady())
			{
				return null;
			}
			
			if(SkillDataManager.instance.checkSkillSummonRemain(skillData.group_id))
			{
				return null;	
			}
			
			//改过配置后    太消耗性能
//			skillCfgData = ConfigDataManager.instance.skillCfgData(attacker.job, attacker.entityType, skillData.group_id, skillData.level);
			
			if(skillCfgData && skillCfgData.buff_id > 0)
			{
				if(skillCfgData.beneficial == SkillConstants.BENEFICIAL_TRUE)
				{
					//判断自己身上的buff
					if(SkillDataManager.instance.checkSkillBuffRemain(skillData.group_id,attacker.entityId,attacker.entityType))
					{
						return null;
					}
				}
				else
				{
					if(target.entityType == EntityTypes.ET_TRAILER)//镖车不上buff
					{
						return null;
					}
					
					//判断目标身上的buff
					if(SkillDataManager.instance.checkSkillBuffRemain(skillData.group_id,target.entityId,target.entityType))
					{
						return null;
					}
				}
			}
			
			return skillCfgData;
		}
		
		private static function isknocking(attacker:IPlayer):Boolean
		{
			var t:IFirstPlayer = attacker ? attacker as IFirstPlayer : firstPlayer;
			if(t)
			{
				return t.knocking;
			}
			
			return false;
		}
		
		public static function isSkillInDist(attacker:IPlayer,targetTileX:int,targetTileY:int,skill:SkillCfgData):Boolean
		{
			var dis:int = attacker.tileDistance(targetTileX,targetTileY);
			
			if(dis>0 && dis<=skill.dist)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function getMapRect(mapId:int):Rectangle
		{
			var mapConfig:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			var mapRows:int = Math.floor(mapConfig.height/MapTileUtils.TILE_HEIGHT);
			var mapCols:int = Math.floor(mapConfig.width/MapTileUtils.TILE_WIDTH);
			
			return new Rectangle(0,0,mapCols,mapRows);
		}
		
		/**
		 * 当前地图离目标点 radius 格矩形中的格子（随机）
		 */
		public static function getNearCanMoveLct(tileX:int,tileY:int,radius:int = 1):Point
		{
			var points:Vector.<Point> = new Vector.<Point>();
			var mapPath:MapPathManager = MapPathManager.getInstance();
			var i:int,j:int;
			
			var mapRect:Rectangle = getMapRect(getCurMapId());
			
			var player:IFirstPlayer = firstPlayer;
			for(i=tileX-radius;i<=tileX+radius;i++)
			{
				for(j=tileY-radius;j<=tileY+radius;j++)
				{
					if(i == tileX && j == tileY)
					{
						continue;
					}
					
					if(mapRect.contains(i,j) && mapPath.isWalkable(i, j, player.cid, player.sid))
					{
						var point:Point = new Point()
						point.x = i;
						point.y = j;
						points.push(point);
					}
				}
			}
			
			if(points.length == 0)
			{
				return null;
			}
			
			var index:int = Math.random()*points.length;
			point = points[index];
			
			return point;
		}
		
		public static function getCanMoveLct(tileX:int,tileY:int):Point
		{
			var mapPath:MapPathManager = MapPathManager.getInstance();
			
			var pos:Point = new Point(tileX,tileY);
			
			var player:IFirstPlayer = firstPlayer;
			if(mapPath.isWalkable(tileX, tileY, player.cid, player.sid))
			{
				return pos;
			}
			
			var max:int = 6;
			var count:int = 1;
			
			while(count <= max)
			{
				pos = getNearCanMoveLct(tileX,tileY,count);
				if(pos)
				{
					return pos;
				}
				count += 2;
			}
			
//			return pos;
			return null;
		}
		
		public static function isFixedTarget(entity:IEntity):Boolean
		{
			return AutoSystem.instance.isFixedTarget(entity.entityType,entity.entityId);
		}
		
		/**
		 * 和searcher同地图的，距离最近的IEntity
		 */
		public static function findNearestEntity(searcher:IPlayer,dict:*,filter:Function = null):IEntity
		{
			var minDis:int = int.MAX_VALUE;
			var target:IEntity = null;
			for each(var m:IEntity in dict)
			{
				if(!m.isShow)
				{
					continue;
				}
				
				if(filter!= null && !filter(m))
				{
					continue;
				}
				
				var dis:int = searcher.tileDistance(m.tileX,m.tileY);
				
				if(dis == 0)
				{
					return m;
				}
				else if(dis<minDis)
				{
					minDis = dis;
					target = m;
				}
			}
			
			return target;
		}
		
		public static function setLastSkillTime(no_public_cd:int):void
		{
//			RoleDataManager.instance.lastSkillTime = getTimer();
			AutoJobManager.getInstance().setLastSkillTime(no_public_cd == 1);
		}
		
		/**
		 * 是否在动作硬直时间中
		 * @return 
		 */		
		public static function isRigor():Boolean
		{
//			var time:int = getTimer() - RoleDataManager.instance.lastSkillTime;
//			return time < AutoJobManager.RIGOR_TIME;
			
			return AutoJobManager.getInstance().checkRigor();
		}
		
		/**
		 * 冰冻 && 麻痹
		 */
		public static function isFrozen(attacker:ILivingUnit = null):Boolean
		{
			var t:ILivingUnit = attacker ? attacker : firstPlayer;
			if(t)
			{
				return t.isFrozen || t.isPalsy;
			}
			
			return false;
		}
		
		public static function isPlayerAt(mapId:int,x:int,y:int):Boolean
		{
			if(!firstPlayer)
			{
				return false;
			}
			return SceneMapManager.getInstance().mapId == mapId &&
					x == firstPlayer.tileX && y == firstPlayer.tileY;
		}
		
		/**
		 * @param isTrigger 触发类技能
		 */
		public static function attack(attacker:IPlayer,target:ILivingUnit,skillCfg:SkillCfgData,isTrigger:Boolean = false):void
		{
			if(attacker != target)
			{
				attacker.direction = Direction.getDirectionByTile(attacker.tileX, attacker.tileY, target.tileX, target.tileY);
			}
			
			/*trace("AxFuncs.attack(attacker, target, skillCfg, isTrigger) 使用技能："+skillCfg.name);*/
			
			if(isTrigger)
			{
				AsFuncs.sendTiggerSkill(skillCfg.id,attacker.direction,attacker.tileX,attacker.tileY,SkillConstants.SKILL_TARGET_TYPE_TARGET,target.entityId,target.entityType);
			}
			else
			{
				if(skillCfg.type == SkillConstants.HJ)
				{
					SkillDealManager.instance.sendJiontSkillPrepare((target.hp > 0 ? 1 : 0),target.entityId,target.entityType);
				}
				else
				{
					AsFuncs.sendAttack(skillCfg.group_id,attacker.direction,attacker.tileX,attacker.tileY,SkillConstants.SKILL_TARGET_TYPE_TARGET,target.entityId,target.entityType);
				}
			}
			
			
			if(skillCfg.type != SkillConstants.HJ)
			{
				AxFuncs.setLastSkillTime(skillCfg.no_public_cd);
				
				if(skillCfg.action_type == SkillConstants.ACTION_TYPE_PATTACK)
				{
					attacker.pAttack();
				}
				else if(skillCfg.action_type == SkillConstants.ACTION_TYPE_MATTACK)
				{
					attacker.mAttack();
				}
				
				var targets:Vector.<ILivingUnit> = new Vector.<ILivingUnit>();
				targets.push(target);
				SkillDealManager.instance.addEffects(skillCfg, attacker, new Point(attacker.tileX, attacker.tileY), targets , new Point(target.tileX, target.tileY));
				
				if(!isTrigger)
				{
					SkillDataManager.instance.skillDone(skillCfg.group_id);
				}
			}
			
			var clickSkillGroupId:int = ActionBarDataManager.instance.clickSkillGroupId;
			ActionBarDataManager.instance.clickSkillGroupId = clickSkillGroupId == skillCfg.group_id ? 0 : clickSkillGroupId;
		}
	}
}