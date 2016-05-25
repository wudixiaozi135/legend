package com.view.gameWindow.scene.entity
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapTeleportCfgData;
    import com.model.configData.cfgdata.MstDigCfgData;
    import com.model.configData.cfgdata.NpcCfgData;
    import com.model.configData.cfgdata.PetCfgData;
    import com.model.configData.cfgdata.PlantCfgData;
    import com.model.configData.cfgdata.SceneEffectCfgData;
    import com.model.configData.cfgdata.TrailerCfgData;
    import com.model.configData.cfgdata.TrapCfgData;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
    import com.view.gameWindow.mainUi.subuis.displaySetting.DisplaySettingConst;
    import com.view.gameWindow.mainUi.subuis.displaySetting.DisplaySettingManager;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.mainUi.subuis.progress.ActionProgressData;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.buff.BuffDataManager;
    import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
    import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.team.data.TeamStatus;
    import com.view.gameWindow.panel.panels.trailer.TrailerConst;
    import com.view.gameWindow.scene.GameSceneManager;
    import com.view.gameWindow.scene.entity.constants.ActionTypes;
    import com.view.gameWindow.scene.entity.constants.Direction;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.constants.PlantStates;
    import com.view.gameWindow.scene.entity.constants.TrapEffectHideConst;
    import com.view.gameWindow.scene.entity.constants.TrapTypes;
    import com.view.gameWindow.scene.entity.constants.ViewTile;
    import com.view.gameWindow.scene.entity.entityInfoLabel.interf.IEntityInfoLabel;
    import com.view.gameWindow.scene.entity.entityItem.DropItem;
    import com.view.gameWindow.scene.entity.entityItem.Entity;
    import com.view.gameWindow.scene.entity.entityItem.FirstHero;
    import com.view.gameWindow.scene.entity.entityItem.FirstPlayer;
    import com.view.gameWindow.scene.entity.entityItem.FirstTrailer;
    import com.view.gameWindow.scene.entity.entityItem.Hero;
    import com.view.gameWindow.scene.entity.entityItem.LivingUnit;
    import com.view.gameWindow.scene.entity.entityItem.Monster;
    import com.view.gameWindow.scene.entity.entityItem.NpcDynamic;
    import com.view.gameWindow.scene.entity.entityItem.NpcStatic;
    import com.view.gameWindow.scene.entity.entityItem.Pet;
    import com.view.gameWindow.scene.entity.entityItem.Plant;
    import com.view.gameWindow.scene.entity.entityItem.Player;
    import com.view.gameWindow.scene.entity.entityItem.SceneAnimation;
    import com.view.gameWindow.scene.entity.entityItem.Teleporter;
    import com.view.gameWindow.scene.entity.entityItem.Trailer;
    import com.view.gameWindow.scene.entity.entityItem.Trap;
    import com.view.gameWindow.scene.entity.entityItem.Unit;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IDropItem;
    import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.scene.entity.entityItem.interf.IHero;
    import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
    import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPlant;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
    import com.view.gameWindow.scene.entity.entityItem.interf.ITrailer;
    import com.view.gameWindow.scene.entity.entityItem.interf.ITrap;
    import com.view.gameWindow.scene.entity.utils.EntityUtils;
    import com.view.gameWindow.scene.map.SceneMapManager;
    import com.view.gameWindow.scene.map.utils.MapTileUtils;
    import com.view.gameWindow.scene.stateAlert.TaskAlert;
    import com.view.gameWindow.scene.viewItem.SceneViewItem;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.HttpServiceUtil;
    import com.view.gameWindow.util.UtilColorMatrixFilters;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.newMir.NewMirMediator;
    import com.view.selectRole.SelectRoleDataManager;
    
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    /**
	 * 场景元素显示管理类
	 * @author Administrator
	 */	
	public class EntityLayerManager extends DataManagerBase
	{
		private static var _instance:EntityLayerManager;
		public static function getInstance():EntityLayerManager
		{
			if (!_instance)
			{
				_instance = new EntityLayerManager(new PrivateClass());
			}
			return _instance;
		}
		
		private var _showOtherPlayer:Boolean = true;
		private var isFirst:Boolean = false;
		private var _firstPlayer:FirstPlayer;
		private var _myHero:Hero;
		private var _myPet:Pet;
		private var _myTrailer:FirstTrailer;
		private var _playerDic:Dictionary;
		private var _heroDic:Dictionary;
		private var _petDic:Dictionary;
		private var _trailerDic:Dictionary;
		private var _monsterDic:Dictionary;
		private var _plantDic:Dictionary;
		private var _staticNpcDic:Dictionary;
		private var _dynamicNpcDic:Dictionary;
		private var _teleporterDic:Dictionary;
		private var _trapDic:Dictionary;
		private var _sceneAnimationDic:Dictionary;
		private var _dropItemDic:Dictionary;
		private var _sceneEffectDic:Dictionary;
		private var _entityLayer:Sprite;
		private var _entityInfoLabelLayer:Sprite;
		
		private var _lastInViewEntities:Vector.<Entity>;
		private var _inViewEntities:Vector.<Entity>;
		private var _inViewDynamicEntitiesDic:Dictionary;
		private var _inViewStaticEntitiesDic:Dictionary;
		private var _disapareEntitiesDic:Dictionary;
		private var _apearEntitiesDic:Dictionary;
		
		private var _width:int;
		private var _height:int;
		private var _hideDesignation:Boolean = false;//隐藏称号
		private var _hideFactionName:Boolean = false;//隐藏所有帮派名称
		private var _hideWing:Boolean = false;//隐藏翅膀
		private var _hideWeaponEffect:Boolean = false;//隐藏武器特效
		
		
		private var _isDropEquipChanged:Boolean;
		private var _isDropOtherChanged:Boolean;
		private var _equipDropDict:Dictionary = new Dictionary(true);
		private var _otherDropDict:Dictionary = new Dictionary(true);
		private var _dropEquipList:Array;
		private var _dropOtherList:Array;

        private const circleRoundFirstPlayerColors:Vector.<int> = new <int>[0x0000ff, 0x990000, 0x0033ff, 0x006600];
		
		public function get dropOtherListForPickUp():Array
		{
			if(_isDropOtherChanged)
			{
				_dropOtherList = [];
				
				var item:IDropItem;
				
				for each(item in _otherDropDict)
				{
					_dropOtherList.push(item);
				}
				
				_isDropOtherChanged = false;
			}
			
			return _dropOtherList;
		}
		
		public function get dropEquipListForPickUp():Array
		{
			if(_isDropEquipChanged)
			{
				_dropEquipList = [];
				
				var item:IDropItem;
				for each(item in _equipDropDict)
				{
					_dropEquipList.push(item);
				}
				
				_isDropEquipChanged = false;
			}
			
			return _dropEquipList;
		}
		
		private var _circleRoundFirstPlayer:Sprite;
		
		public function EntityLayerManager(pc:PrivateClass)
		{
			super();
			if (!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_ENTER_MAP,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ENTITY_INTO_MAP,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LEAVE_MAP,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_PLAYER_STATUS,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HERO_STATUS,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MOVE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_INSTANT_MOVE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_UNIT_BASIC_DATA,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_PLANT_BASIC_DATA,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_BUFF_HP_MP_CHANGE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CORPSE_MONSTER_DIG_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TRAP_STATE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SKILL_KNOCK, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SKILL_KNOCK_END, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SKILL_PUSHBACK, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SKILL_PUSHBACK_END, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BEGIN_GATHER,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BEGIN_CORPSE_MONSTER_DIG,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BEGIN_MINE,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_TOUCH_TRAP,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_DROP_ITEM_PICKED,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_PET_STATUS,this);
		}
		
		public function clearInstace():void
		{
			_instance = null;
		}
		
		public function init(layer:Sprite, labelLayer:Sprite):void
		{
			_entityLayer = layer;
			_entityInfoLabelLayer = labelLayer;
			
			_inViewEntities = new Vector.<Entity>();
			_lastInViewEntities = new Vector.<Entity>();
			_inViewDynamicEntitiesDic = new Dictionary();
			_inViewStaticEntitiesDic = new Dictionary();
			_disapareEntitiesDic = new Dictionary();
			_apearEntitiesDic = new Dictionary();
			
			_playerDic = new Dictionary();
		}
		
		public function resize(width:int, height:int):void
		{
			_width = width;
			_height = height;
		}
		
		/**开始怪物尸体挖掘*/
		public function requestBeginCorpseMonsterDig(entityId:int,cfgDt:MstDigCfgData):void
		{
			/*var isCtrlKeyDown:Boolean = GameSceneManager.getInstance().isCtrlKeyDown;
			if(!isCtrlKeyDown)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.MST_DIG_0001);
				return;
			}*/
			var manager:BagDataManager = BagDataManager.instance;
			if(manager.remainCellNum < 1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.MST_DIG_0004);
				return
			}
			if(cfgDt.coin && (manager.coinBind+manager.coinUnBind) < cfgDt.coin)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.GOLD_COIN + StringConst.MST_DIG_0005);
				return
			}
			if(cfgDt.bind_gold && manager.goldBind < cfgDt.bind_gold)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.INCOME_0005 + StringConst.MST_DIG_0005);
				return
			}
			var count:int = manager.getItemNumById(cfgDt.item_cost);
			if(cfgDt.item_cost && cfgDt.itemCfgDt && count < cfgDt.item_count)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,cfgDt.itemCfgDt.name + StringConst.MST_DIG_0005);
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(entityId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BEGIN_CORPSE_MONSTER_DIG,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_ENTER_MAP:
					/*trace("SM_ENTER_MAP");*/
					NewMirMediator.getInstance().hideCreateRole();
					NewMirMediator.getInstance().hideSelectRole();
					smEnterMap(data);
					if(!isFirst)
					{
						isFirst = true;
						NewMirMediator.getInstance().gameWindow.showMainUI();
						//没考虑双帐号 测试 //还有，这个触发条件真的有用吗？
						GuideSystem.instance.updateLoginState();
						HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP8,1);
					}
					break;
				case GameServiceConstants.SM_ENTITY_INTO_MAP:
					addEntity(data);
					break;
				case GameServiceConstants.SM_LEAVE_MAP:
					removeEntity(data);
					break;
				case GameServiceConstants.SM_PLAYER_STATUS:
					resolvePlayerStatus(data);
					break;
				case GameServiceConstants.SM_HERO_STATUS:
					resolveHeroStatus(data);
					break;
				case GameServiceConstants.SM_PET_STATUS:
					resolvePetStatus(data);
					break;
				case GameServiceConstants.SM_MOVE:
					entityMove(data);
					break;
				case GameServiceConstants.SM_INSTANT_MOVE:
					entityInstanceMove(data);
					break;
				case GameServiceConstants.SM_UNIT_BASIC_DATA:
					resolveUnitBasicData(data);
					break;
				case GameServiceConstants.SM_PLANT_BASIC_DATA:
					resolvePlantBasicData(data);
					break;
				case GameServiceConstants.CM_BEGIN_GATHER:
				case GameServiceConstants.CM_BEGIN_CORPSE_MONSTER_DIG:
					replyBeginGather(data,proc);
					break;
				case GameServiceConstants.CM_BEGIN_MINE:
					replyBeginMining(data);
					break;
				case GameServiceConstants.CM_TOUCH_TRAP:
					replyBeginTouchTrap(data);
					break;
				case GameServiceConstants.SM_TRAP_STATE:
					dealTrapState(data);
					break;
				case GameServiceConstants.SM_BUFF_HP_MP_CHANGE:
					dealHpMp(data);
					break;
				case GameServiceConstants.SM_CORPSE_MONSTER_DIG_INFO:
					dealMstDigInfo(data);
					break;
				case GameServiceConstants.SM_SKILL_KNOCK:
					dealSkillKnock(data);
					break;
				case GameServiceConstants.SM_SKILL_KNOCK_END:
					dealSkillKnockEnd(data);
					break;
				case GameServiceConstants.SM_SKILL_PUSHBACK:
					dealSkillPushBack(data);
					break;
				case GameServiceConstants.SM_SKILL_PUSHBACK_END:
					dealSkillPushBackEnd(data);
					break;
				case GameServiceConstants.SM_DROP_ITEM_PICKED:
					dealPickDropItem(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealPickDropItem(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var type:int = data.readByte();
			var tmpid:int = data.readInt();
			var sid:int = data.readInt();
			var count:int = data.readInt();
			FlyEffectMediator.instance.doFlyReceiveThing(entityId,type,sid,tmpid);
		}
		
		private function dealHpMp(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var hpGain:int = data.readInt();
			var mpGain:int = data.readInt();
			var livingUnit:ILivingUnit = getEntityFormAll(entityId) as ILivingUnit;
			if (!livingUnit)
			{
				return;
			}
			if(hpGain)
			{
				livingUnit.showStateAlert(hpGain,0);
			}
			if(mpGain)
			{
				livingUnit.showStateAlert(mpGain,-1);
			}
		}
		
		private function dealTrapState(data:ByteArray):void
		{
			var entityId:int = data.readInt();//4字节有符号整形，机关的唯一id
			var state:int = data.readByte();//1字节有符号整形，机关的状态，1为空闲，2为启动
			var trap:Trap = _trapDic[entityId];
			trap.state = state;
			if(state == TrapTypes.TS_WORK)
			{
				if(trap.trapType == TrapCfgData.TRAP_TYPE_MINING)
				{
					if(Unit(firstPlayer).currentAcionId != ActionTypes.MINING)
					{
						firstPlayer.direction = Direction.getDirectionByTile(firstPlayer.tileX, firstPlayer.tileY, trap.tileX, trap.tileY);
						firstPlayer.mining();
						firstPlayer.changeModel();
						PanelMediator.instance.openPanel(PanelConst.TYPE_MINING,true,entityId);
					}
				}
			}
		}
		
		public function smEnterMap(data:ByteArray):void
		{
			var mapId:int = data.readInt();
			var startX:int = data.readInt();
			var startY:int = data.readInt();
			
			GameSceneManager.getInstance().switchMap(mapId, startX, startY);
			var miniMap:MiniMap = MainUiMediator.getInstance().miniMap as MiniMap;
			if(miniMap)
			{
				miniMap.showMiniMap(mapId, startX, startY);
			}
			var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP);
			if(panel)
			{
				panel.update();
			}
		}
		
 		public function get firstPlayer():IFirstPlayer
		{
			return _firstPlayer;
		}
		
		public function get myHero():IHero
		{
			return _myHero;
		}
		
		public function getMonsterAt(tileX:int,tileY:int):IMonster
		{
			for each(var m:IMonster in _monsterDic)
			{
				if(m.tileX == tileX && m.tileY == tileY)
				{
					return m;
				}
			}
			
			return null;
		}
		
		public function getEntity(type:int, id:int):IEntity
		{
			switch (type)
			{
				case EntityTypes.ET_PLAYER:
					return _playerDic[id];
				case EntityTypes.ET_MONSTER:
					return _monsterDic[id];
				case EntityTypes.ET_PLANT:
					return _plantDic[id];
				case EntityTypes.ET_HERO:
					return _heroDic[id];
				case EntityTypes.ET_PET:
					return _petDic[id];
				case EntityTypes.ET_TELEPORTER:
					return _teleporterDic[id];
				case EntityTypes.ET_NPC:
					return _staticNpcDic[id] || _dynamicNpcDic[id];
				case EntityTypes.ET_TRAP:
					return _trapDic[id];
				case EntityTypes.ET_TRAILER:
					return _trailerDic[id];
				case EntityTypes.ET_DROPITEM:
					return _dropItemDic[id];
			}
			return null;
		}
		
		public function getAllLivingUnit():Vector.<Dictionary>
		{
			var livingUnits:Vector.<Dictionary> = new Vector.<Dictionary>();
			livingUnits.push(_playerDic);
			livingUnits.push(_monsterDic);
			livingUnits.push(_heroDic);
			livingUnits.push(_petDic);
			return livingUnits;
		}
		
		public function getAllStaticNpcs():Dictionary
		{
			return _staticNpcDic;
		}
		
		public function getAllDynamicNpcs():Dictionary
		{
			return _dynamicNpcDic;
		}
		
		public function getEntityFormAll(id:int):IEntity
		{
			return _playerDic[id] || _monsterDic[id] || _plantDic[id] || _heroDic[id] || _petDic[id] || _teleporterDic[id] || _trailerDic[id] || _staticNpcDic[id] || _dynamicNpcDic[id] || _trapDic[id] || _dropItemDic[id];
		}

		public function getPlayerByCidSid(cid:int, sid:int):Player
        {
            for each (var player:Player in _playerDic)
            {
				if (player.cid == cid && player.sid == sid)
				{
                    return player;
                }
            }
            return null;
        }
		
		public function isPlayerOnPosExcept(tileX:int, tileY:int, cid:int, sid:int):Boolean
		{
			for each (var player:IPlayer in _playerDic)
			{
				if (player.tileX == tileX && player.tileY == tileY && (player.cid != cid || player.sid != sid))
				{
					return true;
				}
			}
			return false;
		}
		
		public function addEntity(data:ByteArray):void
		{
			var count:int = data.readShort();
			while (count-- > 0)
			{
				var type:int = data.readByte();
				if (type == EntityTypes.ET_PLAYER)
				{
					addPlayer(data);
				}
				else if (type == EntityTypes.ET_HERO)
				{
					addHero(data);
				}
				else if (type == EntityTypes.ET_PET)
				{
					addPet(data);
				}
				else if (type == EntityTypes.ET_TRAILER)
				{
					addTrailer(data);
				}
				else if (type == EntityTypes.ET_MONSTER)
				{
					addMonster(data);
				}
				else if (type == EntityTypes.ET_PLANT)
				{
					addPlant(data);
				}
				else if (type == EntityTypes.ET_TRAP)
				{
					addTrap(data);
				}
				else if (type == EntityTypes.ET_DROPITEM)
				{
					addDropItem(data);
				}
			}
		}
		
		private function addPlayer(data:ByteArray):void
		{
			var player:Player;
			var entityId:int = data.readInt();
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			if (cid == SelectRoleDataManager.getInstance().selectCid && sid == SelectRoleDataManager.getInstance().selectSid)
			{
				if (!_firstPlayer)
				{
					_firstPlayer = new FirstPlayer();
				}
				player = _firstPlayer;
			}
			else if (_disapareEntitiesDic[EntityTypes.ET_PLAYER] != null && _disapareEntitiesDic[EntityTypes.ET_PLAYER][entityId] != null)
			{
				player = _disapareEntitiesDic[EntityTypes.ET_PLAYER][entityId];
				delete _disapareEntitiesDic[EntityTypes.ET_PLAYER][entityId];
			}
			else if (_playerDic[entityId] != null)
			{
				player = _playerDic[entityId];
			}
			else
			{
				player = new Player();
			}
			player.entityId = entityId;
			player.cid = cid;
			player.sid = sid;
			player.entityName =data.readUTF();//name
			data.readByte();//head
			player.sex = data.readByte();//sex
			player.job = data.readByte();//job;
			player.vip = data.readByte();//vip;
			player.reincarn = data.readByte();//reincarn;
			player.level = data.readShort();//level;
			player.tileX = data.readShort();//tileX
			player.tileY = data.readShort();//tileY
			player.targetTileX = data.readShort();//targettileX
			player.targetTileY = data.readShort();//targettileY
			player.direction = data.readByte();
			player.hp = data.readInt();
			player.maxHp = data.readInt();//血量上限
			player.speed = data.readShort();
			player.teamStatus = data.readByte();
			player.teamMemberCount = data.readByte();
			player.familyId = data.readInt();
			player.familySid = data.readInt();
			player.familyName = data.readUTF();
			player.familyPositionName=data.readUTF();
			player.position=data.readInt();
			player.stallStatue = data.readByte();
			player.specialAction = data.readByte();
			var gatherId0:int = data.readInt();//采集物id
			var gatherId1:int = data.readInt();//怪物挖掘尸体id
			var mapMineX:int = data.readShort();
			var mapMineY:int = data.readShort();
			var trapId:int = data.readInt();
			player.pkValue = data.readInt();
			player.isGrey = data.readByte();
			player.pkCamp = data.readByte();
			player.isHide = data.readInt();//时装隐藏状态
			player.cloth = data.readInt();//yifu
			player.weapon = data.readInt();//wuqi
			player.shield = data.readInt();//dunpai
            player.wing = data.readInt();//翅膀
			player.fashion = data.readInt();//时装
            player.hair = data.readInt();//斗笠
//			player.wing = data.readInt();//翅膀
			data.readInt();//足迹
			player.magicWeapon = data.readInt();
			_playerDic[player.entityId] = player;
            var isTarpMe:Boolean = isTarpMine(trapId);
			//处理采集、挖掘
            var gatherId:int = gatherId0 || gatherId1 || (!isTarpMe ? trapId : 0);
			dealGather(gatherId,player);
			//处理采矿
            if (isTarpMe && (mapMineX == -1 || mapMineY == -1))
			{
				var mineTile:Point = getMineTile(trapId);
				mapMineX = mineTile.x;
				mapMineY = mineTile.y;
			}
			dealMining(mapMineX,mapMineY,player);
			var isEqual:Boolean = ActivityDataManager.instance.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_SEA_SIDE);
			if (isEqual)
			{
				player.hideEffects();
				player.isTitleShow = false;
				player.hideHp();
				player.hideHpTile();
				player.isShowHp = true;
				player.isShowTitle = true;
			}
			else
			{
                var allHide:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_OTHER_PLAYER_DESIGNATION);//是否隐藏了玩家称号（此处指官职）
				player.showEffects();
				if (player is FirstPlayer)
				{
					player.isTitleShow = true;
				} else
				{
					player.isTitleShow = !allHide;
				}
				player.showHp();
				player.showHpTitle();
				player.isShowHp = false;
				player.isShowTitle = false;
			}
			if (cid == SelectRoleDataManager.getInstance().selectCid && sid == SelectRoleDataManager.getInstance().selectSid)
			{
				if(MainUiMediator.getInstance().roleHead)
				{
					MainUiMediator.getInstance().roleHead.updateBuff();
				}
			}
			notifyData(GameServiceConstants.SM_ENTITY_INTO_MAP,player);
		}
		
		private function addHero(data:ByteArray):void
		{
			var heroId:int = data.readInt();
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var hero:Hero = null;
			if (_heroDic[heroId])
			{
				hero = _heroDic[heroId];
			}
			else if (_disapareEntitiesDic[EntityTypes.ET_HERO] != null && _disapareEntitiesDic[EntityTypes.ET_HERO][heroId] != null)
			{
				hero = _disapareEntitiesDic[EntityTypes.ET_HERO][heroId];
				delete _disapareEntitiesDic[EntityTypes.ET_HERO][heroId];
			}
			else
			{
				if(cid == SelectRoleDataManager.getInstance().selectCid && sid == SelectRoleDataManager.getInstance().selectSid)
				{
					hero = _myHero = new FirstHero();
				}
				else
				{
					hero = new Hero();
				}
			}
			hero.entityId = heroId;
			hero.ownerId = cid;
			hero.sid = sid;
			hero.entityName=data.readUTF()+StringConst.NPC_TASK_PANEL_0004;
			hero.job = data.readByte();//job
			hero.sex = data.readByte();//sex
			var isNotShowBornEffect:int = data.readByte();
			data.readByte();//reincarn
			hero.level = data.readShort();//level
			data.readInt();//exp;
			hero.tileX = data.readShort();
			hero.tileY = data.readShort();
			hero.targetTileX = data.readShort();
			hero.targetTileY = data.readShort();
			hero.hp = data.readInt();
			hero.maxHp = data.readInt();//maxhp
			data.readInt();//mp
			data.readInt();//maxmp;
			hero.speed = data.readShort();
			hero.cloth = data.readInt();//cloth base id
			hero.weapon = data.readInt();//weapon base id
			hero.fashionId=data.readInt();
			if (isNotShowBornEffect <= 0)
			{
				hero.showBornEffect();
			}
			_heroDic[hero.entityId] = hero;
		}
		
		private function addPet(data:ByteArray):void
		{
			var petEntityId:int = data.readInt();//entityId
			var petCfgId:int = data.readInt();
			var sid:int = data.readInt();
			var cid:int = data.readInt();
			var name:String = data.readUTF();
			var heroId:int = data.readInt();
			var pet:Pet = null;
			if (_petDic[petEntityId])
			{
				pet = _petDic[petEntityId];
			}
			else if (_disapareEntitiesDic[EntityTypes.ET_PET] != null && _disapareEntitiesDic[EntityTypes.ET_PET][petEntityId] != null)
			{
				pet = _disapareEntitiesDic[EntityTypes.ET_PET][petEntityId];
				delete _disapareEntitiesDic[EntityTypes.ET_PET][petEntityId];
			}
			else
			{
				pet = new Pet();
				if(cid == SelectRoleDataManager.getInstance().selectCid && sid == SelectRoleDataManager.getInstance().selectSid && heroId <= 0)
				{
					_myPet = pet;
				}
			}
			if(heroId>0)
				name = name+StringConst.NPC_TASK_PANEL_0004;
			var cfg:PetCfgData = ConfigDataManager.instance.petCfgData(petCfgId);
			pet.entityName = name+StringConst.NPC_TASK_PANEL_0005+cfg.name;
			pet.grade = data.readShort();//阶数
			var isNotShowBornEffect:int = data.readByte();
			pet.ownId = cid;
			pet.sid = sid;
			pet.entityId = petEntityId;
			pet.petId = petCfgId;
			pet.level = data.readShort();
			pet.exp = data.readInt();
			pet.tileX = data.readShort();
			pet.tileY = data.readShort();
			pet.targetTileX = data.readShort();
			pet.targetTileY = data.readShort();
			pet.hp = data.readInt();
			pet.maxHp = data.readInt();//maxhp
			pet.speed = data.readShort();
			if (isNotShowBornEffect <= 0)
			{
				pet.showBornEffect();
			}
			_petDic[petEntityId] = pet;
		}
		
		private function addTrailer(data:ByteArray):void
		{
			var trailerEntityId:int = data.readInt();
			var trailerId:int = data.readInt();
			var ownerCid:int = data.readInt();
			var ownerSid:int = data.readInt();
			if(ownerCid == SelectRoleDataManager.getInstance().selectCid && ownerSid == SelectRoleDataManager.getInstance().selectSid)
			{
				if (_trailerDic[trailerEntityId] == null)
				{
					_myTrailer = _trailerDic[trailerEntityId] = new FirstTrailer();
				}
			}
			else
			{
				if (_trailerDic[trailerEntityId] == null)
				{
					_trailerDic[trailerEntityId] = new Trailer();
				}
			}
			var trailer:ITrailer = _trailerDic[trailerEntityId];
			trailer.entityId = trailerEntityId;
			trailer.trailerId = trailerId;
			trailer.ownerCid = ownerCid;
			trailer.ownerSid = ownerSid;
			trailer.ownerName = data.readUTF();
			var trailerCfgData:TrailerCfgData = ConfigDataManager.instance.trailerCfgData(trailer.trailerId);
			trailer.entityName=HtmlUtils.createHtmlStr(TrailerConst.colors[trailerCfgData.quality-1],trailerCfgData.name+"("+trailer.ownerName+")");
			trailer.tileX = data.readShort();
			trailer.tileY = data.readShort();
			trailer.targetTileX = data.readShort();
			trailer.targetTileY = data.readShort();
			trailer.hp = data.readInt();
			trailer.speed = data.readShort();
		}
		
		private function addMonster(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var monster:Monster = null;
			if (_monsterDic[entityId])
			{
				monster = _monsterDic[entityId];
			}
			else if (_disapareEntitiesDic[EntityTypes.ET_MONSTER] != null && _disapareEntitiesDic[EntityTypes.ET_MONSTER][entityId] != null)
			{
				monster = _disapareEntitiesDic[EntityTypes.ET_MONSTER][entityId];
				delete _disapareEntitiesDic[EntityTypes.ET_MONSTER][entityId];
			}
			else
			{
				monster = new Monster();
			}
			monster.entityId = entityId;
			monster.monsterId = data.readInt();
			monster.tileX = data.readShort();//tileX
			monster.tileY = data.readShort();//tileY
			monster.targetTileX = data.readShort();//targettileX
			monster.targetTileY = data.readShort();//targettileY
			monster.hp = data.readInt();
			monster.speed = data.readShort();
			monster.side = data.readByte();
			monster.endTime = data.readInt();//怪物消失时间
			monster.killerCid = data.readInt();//killerCid角色id
			monster.killerSid = data.readInt();//killerSid服务器id
			monster.digCount = dealDigCount(data);//dig time
			_monsterDic[monster.entityId] = monster;
			
			checkBoss(monster);
		}
		
		private function checkBoss(monster:Monster):void
		{
			if(SceneMapManager.getInstance().mapId==541)
			{
				return;
			}
			var alertBoss:Boolean = SceneMapManager.getInstance().alertBoss;
			if(alertBoss==false&&monster.mstCfgData.quality==3)
			{
				alertBoss=true;
				TaskAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(StringConst.BOSS_PANEL_0045,0xfef5e3,3,24));
			}
		}
		
		private function dealDigCount(data:ByteArray):int
		{
			var selectCid:int = SelectRoleDataManager.getInstance().selectCid;
			var selectSid:int = SelectRoleDataManager.getInstance().selectSid;
			var count:int = data.readShort();//循环数，表示挖掘者数量，2字节有符号整形
			var digCount:int;
			while (count--)
			{
				var cid:int = data.readInt();//cid,角色id，4字节有符号整形
				var sid:int = data.readInt();//sid,服务器id，4字节有符号整形
				var digCountTemp:int = data.readByte();//挖掘次数，1字节有符号整形
				if(selectCid == cid && selectSid == sid)
				{
					digCount = digCountTemp;
				}
			}
			return digCount;
		}
		
		private function addPlant(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var plant:Plant = null;
			if (_plantDic[entityId])
			{
				plant = _plantDic[entityId];
			}
			else if (_disapareEntitiesDic[EntityTypes.ET_PLANT] != null && _disapareEntitiesDic[EntityTypes.ET_PLANT][entityId] != null)
			{
				plant = _disapareEntitiesDic[EntityTypes.ET_PLANT][entityId];
				delete _disapareEntitiesDic[EntityTypes.ET_PLANT][entityId];
			}
			else
			{
				plant = new Plant();
			}
			plant.entityId = entityId;
			plant.plantId = data.readInt();
			plant.tileX = data.readShort();
			plant.tileY = data.readShort();
			plant.state = data.readByte();
			_plantDic[plant.entityId] = plant;
		}
		
		private function addTrap(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var trap:Trap = null;
			if (_plantDic[entityId])
			{
				trap = _trapDic[entityId];
			}
			else if (_disapareEntitiesDic[EntityTypes.ET_TRAP] != null && _disapareEntitiesDic[EntityTypes.ET_TRAP][entityId] != null)
			{
				trap = _disapareEntitiesDic[EntityTypes.ET_TRAP][entityId];
				delete _disapareEntitiesDic[EntityTypes.ET_TRAP][entityId];
			}
			else
			{
				trap = new Trap();
			}
			trap.entityId = entityId;
			trap.trapId = data.readInt();
			trap.tileX = data.readShort();
			trap.tileY = data.readShort();
			trap.state = data.readByte();
			_trapDic[trap.entityId] = trap;
		}
		
		private function addDropItem(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var dropItem:DropItem = null;
			if (_dropItemDic[entityId])
			{
				dropItem = _dropItemDic[entityId];
			}
			else if (_disapareEntitiesDic[EntityTypes.ET_DROPITEM] != null && _disapareEntitiesDic[EntityTypes.ET_DROPITEM][entityId] != null)
			{
				dropItem = _disapareEntitiesDic[EntityTypes.ET_DROPITEM][entityId];
				delete _disapareEntitiesDic[EntityTypes.ET_DROPITEM][entityId];
			}
			else
			{
				dropItem = new DropItem();
			}
			dropItem.entityId = entityId;
			dropItem.itemId = data.readInt();
			dropItem.itemType = data.readByte();
			dropItem.itemCount = data.readInt();
			dropItem.isNotShowBornEffect = data.readByte();
			dropItem.ownerTeamId = data.readInt();
			dropItem.ownerCid = data.readInt();
			dropItem.ownerSid = data.readInt();
			dropItem.tileX = data.readShort();
			dropItem.tileY = data.readShort();
			dropItem.loadPic();
			dropItem.setTheName();
			_dropItemDic[dropItem.entityId] = dropItem;
			
			storeDropItemForPickUp(dropItem,true);
		}
		
		private function storeDropItemForPickUp(dropItem:IDropItem,isAdd:Boolean):void
		{
			
			if(isAdd)
			{
				if(dropItem.itemType == SlotType.IT_EQUIP)
				{
					_equipDropDict[dropItem.entityId] = dropItem;
					_isDropEquipChanged = true;
				}
				else
				{
					_otherDropDict[dropItem.entityId] = dropItem;
					_isDropOtherChanged = true;
				}
			}
			else
			{
				if(dropItem.itemType == SlotType.IT_EQUIP)
				{
					delete _equipDropDict[dropItem.entityId];
					_isDropEquipChanged = true;
				}
				else
				{
					delete _otherDropDict[dropItem.entityId];
					_isDropOtherChanged = true;
				}
			}
		}
		
		public function removeEntity(data:ByteArray):void
		{
			var count:int = data.readShort();
			while (count-- > 0)
			{
				var type:int = data.readByte();
				var id:int = data.readInt();
				if (!_disapareEntitiesDic[type])
				{
					_disapareEntitiesDic[type] = new Dictionary();
				}
				if (type == EntityTypes.ET_PLAYER)
				{
					if (!_firstPlayer || _firstPlayer.entityId != id)
					{
						var player:Player = _playerDic[id];
						delete _playerDic[id];
						if (player)
						{
							_disapareEntitiesDic[type][id] = player;
						}
						clearBuff(player);
					}
				}
				else if (type == EntityTypes.ET_HERO)
				{
					var hero:Hero = _heroDic[id];
					delete _heroDic[id];
					if (hero)
					{
						_disapareEntitiesDic[type][id] = hero;
						if (_myHero == hero)
						{
							_myHero = null;
						}
						clearBuff(hero);
					}
				}
				else if (type == EntityTypes.ET_PET)
				{
					var pet:Pet = _petDic[id];
					delete _petDic[id];
					if (pet)
					{
						_disapareEntitiesDic[type][id] = pet;
						if (_myPet == pet)
						{
							_myPet = null;
						}
						clearBuff(pet);
					}
				}
				else if (type == EntityTypes.ET_MONSTER)
				{
					var monster:Monster = _monsterDic[id];
					delete _monsterDic[id];
					if (monster)
					{
						if(monster.mstCfgData.quality == 3)
						{
							SceneMapManager.getInstance().alertBoss=false;
						}
						_disapareEntitiesDic[type][id] = monster;
						clearBuff(monster);
					}
				}
				else if (type == EntityTypes.ET_PLANT)
				{
				//	trace("entityId:"+id+"采集物消除");
					var plant:Plant = _plantDic[id];
					delete _plantDic[id];
					if (plant)
					{
						_disapareEntitiesDic[type][id] = plant;
					}
				}
				else if (type == EntityTypes.ET_TRAP)
				{
					var trap:Trap = _trapDic[id];
					delete _trapDic[id];
					if (trap)
					{
						_disapareEntitiesDic[type][id] = trap;
					}
				}
				else if (type == EntityTypes.ET_TRAILER)
				{
					var trailer:Trailer = _trailerDic[id];
					delete _trailerDic[id];
					if (trailer)
					{
						_disapareEntitiesDic[type][id] = trailer;
						if(trailer == _myTrailer)
						{
							_myTrailer = null;
						}
					}
				}
				else if (type == EntityTypes.ET_DROPITEM)
				{
					var dropItem:DropItem = _dropItemDic[id];
					delete _dropItemDic[id];
					if (dropItem)
					{
						_disapareEntitiesDic[type][id] = dropItem;
						
						storeDropItemForPickUp(dropItem,false);
					}
				}
			}
		}
		
		public function resolvePlayerStatus(data:ByteArray):void
		{
			var id:int = data.readInt();
			var player:Player = _playerDic[id];
			if (player)
			{
				player.vip = data.readByte();
				player.reincarn = data.readByte();//转生次数
				player.level = data.readShort();
				player.hp = data.readInt();//血量
				player.maxHp = data.readInt();//血量最大值
				player.speed = data.readShort();//速度
				player.teamStatus = data.readByte();
				player.teamMemberCount = data.readByte();
				player.familyId = data.readInt();
				player.familySid = data.readInt();
				player.familyName = data.readUTF();
				player.familyPositionName=data.readUTF();
				player.familyRelation=data.readByte();
				player.position=data.readInt();
				player.stallStatue = data.readByte();
				player.direction = data.readByte();
				player.specialAction = data.readByte();
				var gatherId0:int = data.readInt();//采集物id
				var gatherId1:int = data.readInt();//挖掘尸体id
				var mapMineX:int = data.readShort();
				var mapMineY:int = data.readShort();
				var trapId:int = data.readInt();
				player.pkValue = data.readInt();
				player.isGrey = data.readByte();
				player.pkCamp = data.readByte();
				player.isHide = data.readInt();//时装隐藏状态
				player.cloth = data.readInt();
				player.weapon = data.readInt();
				player.shield = data.readInt();
                player.wing = data.readInt();//翅膀
				player.fashion = data.readInt();//时装
                player.hair = data.readInt();//斗笠
//				player.wing = data.readInt();//由原来翅膀变为装备翅膀
				data.readInt();//足迹
				player.magicWeapon = data.readInt();
				player.changeModel();
                var isTarpMe:Boolean = isTarpMine(trapId);
                var gatherId:int = gatherId0 || gatherId1 || (!isTarpMe ? trapId : 0);
                if (isTarpMe && (mapMineX == -1 || mapMineY == -1))
				{
					var mineTile:Point = getMineTile(trapId);
					mapMineX = mineTile.x;
					mapMineY = mineTile.y;
				}
				//处理进度条
				if(player == firstPlayer)
				{
					if(gatherId != 0)
					{
					}
					else if(mapMineX != -1 && mapMineY != -1)
					{
					}
					else
					{
						switchActionProgress(0);
					}
				}
				//处理采集、挖掘
				dealGather(gatherId,player);
				//处理采矿
				dealMining(mapMineX,mapMineY,player);
			}
		}
		
		private function dealGather(gatherId:int,player:Player):void
		{
			//trace("||||||||||||||||\nfirstPlayer.entityId:"+firstPlayer.entityId+"\nplayer.entityId:"+player.entityId+"\ngatherId:"+gatherId+"\nplayer.currentAcionId:"+player.currentAcionId+"\n|||||||||||||||||");
			if(gatherId != 0 && player.currentAcionId != ActionTypes.GATHER)
			{
				var entity:IEntity = getEntityFormAll(gatherId);
				if(entity)
				{
					player.direction = Direction.getDirectionByTile(player.tileX, player.tileY, entity.tileX, entity.tileY);
					player.gather();
				}
			}	
			else if(gatherId == 0 && player.currentAcionId == ActionTypes.GATHER)
			{
				player.idle();
			}
		}
		/**机关是否为机关矿*/
		private function isTarpMine(entityId:int):Boolean
		{
			var trap:Trap = getEntity(EntityTypes.ET_TRAP,entityId) as Trap;
			return trap && trap.trapType == TrapCfgData.TRAP_TYPE_MINING;
		}
		
		private function getMineTile(trapMineId:int):Point
		{
			var point:Point;
			var entity:IEntity = getEntity(EntityTypes.ET_TRAP,trapMineId);
			if(entity)
			{
				point = new Point(entity.tileX,entity.tileY);
			}
			else
			{
				point = new Point(-1,-1);
			}
			return point;
		}
		
		private function dealMining(mapMineX:int,mapMineY:int,player:Player):void
		{
			var manager:PanelMediator = PanelMediator.instance;
			if((mapMineX != -1 && mapMineY != -1))
			{
				player.direction = Direction.getDirectionByTile(player.tileX, player.tileY, mapMineX, mapMineY);
				if(player.currentAcionId != ActionTypes.MINING)
				{
					player.mining();
					player.changeModel();
				}
				if(player == firstPlayer)
				{
					if(!manager.openedPanel(PanelConst.TYPE_MINING))
					{
						manager.openPanel(PanelConst.TYPE_MINING);
					}
				}
			}
			else
			{
				if(player.currentAcionId == ActionTypes.MINING)
				{
					player.idle();
					player.changeModel();
				}
				if(player == firstPlayer)
				{
					manager.closePanel(PanelConst.TYPE_MINING);
				}
			}
		}
		
		private function switchActionProgress(totalTime:int,strTxt:String = ""):void
		{
			if(totalTime)
			{
				ActionProgressData.strTxt = strTxt;
				ActionProgressData.totalTime = totalTime;
				notify(ActionProgressData.START);//开始读条
			}
			else
			{
				notify(ActionProgressData.OVER);//结束读条
			}
		}
		
		public function resolveHeroStatus(data:ByteArray):void
		{
			var heroId:int = data.readInt();
			var cid:int = data.readInt();
			var hero:Hero = _heroDic[heroId];
			if (hero)
			{
				hero = _heroDic[heroId];
				hero.entityId = heroId;
				hero.ownerId = cid;
				hero.sid = data.readInt();//sid
				hero.entityName=data.readUTF()+StringConst.NPC_TASK_PANEL_0004;
				hero.job = data.readByte();//job
				hero.sex = data.readByte();//sex
				data.readByte();//isNotShowBornEffect
				data.readByte();//grade
				hero.level = data.readShort();//level
				data.readInt();//exp;
				hero.tileX = data.readShort();
				hero.tileY = data.readShort();
				hero.targetTileX = data.readShort();
				hero.targetTileY = data.readShort();
				hero.hp = data.readInt();
				data.readInt();//maxhp
				data.readInt();//mp
				data.readInt();//maxmp;
				hero.speed = data.readShort();
				hero.cloth = data.readInt();//cloth base id
				hero.weapon = data.readInt();//weapon base id
				hero.fashionId=data.readInt();
				hero.changeModel();
			}
		}
		
		private function resolvePetStatus(data:ByteArray):void
		{
			var petEntityId:int = data.readInt();//entityId
			var petCfgId:int = data.readInt();
			var sid:int = data.readInt();
			var cid:int = data.readInt();
			var name:String = data.readUTF();
			var heroId:int = data.readInt();
			var pet:Pet =_petDic[petEntityId];
			if(pet)
			{
				if(heroId>0)
					name = name+StringConst.NPC_TASK_PANEL_0004;
				var cfg:PetCfgData = ConfigDataManager.instance.petCfgData(petCfgId);
				pet.entityName = name+StringConst.NPC_TASK_PANEL_0005+cfg.name;
				pet.grade = data.readShort();//阶数
				var isNotShowBornEffect:int = data.readByte();
				pet.ownId = cid;
				pet.sid = sid;
				pet.entityId = petEntityId;
				pet.petId = petCfgId;
				pet.level = data.readShort();
				pet.exp = data.readInt();
				pet.tileX = data.readShort();
				pet.tileY = data.readShort();
				pet.targetTileX = data.readShort();
				pet.targetTileY = data.readShort();
				pet.hp = data.readInt();
				pet.maxHp = data.readInt();//maxhp
				pet.speed = data.readShort();
				pet.refreshName();
			}
		}
		
		public function resolveUnitBasicData(data:ByteArray):void
		{
			var id:int = data.readInt();
			var type:int = data.readByte();
			var hp:int;
			var maxHp:int;
			var sp:int;
			var livingUnit:ILivingUnit = getEntity(type, id) as ILivingUnit;
			if (livingUnit)
			{
				hp = data.readInt();
				maxHp = data.readInt();
				sp = data.readShort();
				livingUnit.hp = hp;
				livingUnit.maxHp = maxHp;
				livingUnit.speed = sp;
				if (livingUnit.hp > 0 && hp <= 0)
				{
					livingUnit.die();
				}
				if(livingUnit is FirstPlayer)
				{
					RoleDataManager.instance.attrHp = hp;
					RoleDataManager.instance.attrMaxHp = maxHp;
					PanelMediator.instance.refreshPanel(PanelConst.TYPE_ROLE_PROPERTY);
					
					if(MainUiMediator.getInstance().bottomBar)
					{
						MainUiMediator.getInstance().bottomBar.refreshHpMp();
					}
					
					//添加死亡复活弹窗
					if(livingUnit.hp <= 0)
					{
						AutoJobManager.getInstance().selectEntity = null;
						AutoJobManager.getInstance().reset();
						GameSceneManager.getInstance().resetBarKeyDowns();
						MainUiMediator.getInstance().addMaskLayer();
						PanelMediator.instance.openPanel(PanelConst.TYPE_DEAD_REVIVE);
					}
				}
				var hero:Hero = livingUnit as Hero;
				if(hero && hero.ownerId == SelectRoleDataManager.getInstance().selectCid && hero.sid == SelectRoleDataManager.getInstance().selectSid)
				{
					if(MainUiMediator.getInstance().heroHead)
					{
						MainUiMediator.getInstance().heroHead.refreshHp(hp,maxHp);
					}
				}
				var selectEntity:IEntity = AutoJobManager.getInstance().selectEntity;
				if(livingUnit.entityType == EntityTypes.ET_MONSTER || livingUnit.entityType == EntityTypes.ET_HERO || livingUnit.entityType == EntityTypes.ET_PLAYER||livingUnit.entityType == EntityTypes.ET_PET
				||livingUnit.entityType==EntityTypes.ET_TRAILER)
				{
					livingUnit.showHp(true);
					livingUnit.showHpTitle(true);
				}
			}
		}
		
		public function resolvePlantBasicData(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var state:int = data.readByte();
			var plant:Plant = getEntity(EntityTypes.ET_PLANT,entityId) as Plant;
			if(plant && plant.isShow)
			{
				plant.state = state;
				/*trace("设置entityId:"+entityId+"的采集物状态:"+state);*/
			}
			if(state == PlantStates.PS_CORPSE)
			{
				LivingUnit(firstPlayer).idle();
			}
		}
		
		public function replyBeginGather(data:ByteArray,proc:int):void
		{
			var entityId:int = data.readInt();
			var entity:IEntity = getEntityFormAll(entityId);
			if(entity && entity.isShow)
			{
				var strText:String = "";
				if(proc == GameServiceConstants.CM_BEGIN_GATHER)
				{
					var plantId:int = (entity as IPlant).plantId;
					var cfgDt:PlantCfgData = ConfigDataManager.instance.plantCfgData(plantId);
					strText = cfgDt ? cfgDt.display : StringConst.ACTION_PROGRESS_0001;
				}
				else if(proc == GameServiceConstants.CM_BEGIN_CORPSE_MONSTER_DIG)
				{
					strText = StringConst.ACTION_PROGRESS_0002;
				}
				switchActionProgress(entity.totalTime,strText);
			}
		}
		
		public function replyBeginMining(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var entity:IEntity = getEntityFormAll(entityId);
			if(entity && entity.isShow)
			{
				var totalTime:int = entity.totalTime;
				var trapId:int = (entity as ITrap).trapId;
				var cfgDt:TrapCfgData = ConfigDataManager.instance.trapCfgData(trapId);
				var strText:String = cfgDt && cfgDt.display ? cfgDt.display : StringConst.ACTION_PROGRESS_0003;
				switchActionProgress(totalTime ? totalTime : ActionProgressData.MINING_TIME_MAP,strText);
			}
			else
			{
				switchActionProgress(ActionProgressData.MINING_TIME_MAP,StringConst.ACTION_PROGRESS_0003);
			}
		}
		
		private function replyBeginTouchTrap(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var trap:Trap = getEntity(EntityTypes.ET_TRAP,entityId) as Trap;
			if(trap && trap.isShow && trap.trapType != TrapCfgData.TRAP_TYPE_MINING && trap.state == TrapTypes.TS_WORK)
			{
				var cfgDt:TrapCfgData = ConfigDataManager.instance.trapCfgData(trap.trapId);
				if(cfgDt.trigger_type == TrapCfgData.TRIGGER_TYPE_READING)
				{
					var totalTime:int = trap.totalTime;
					var strText:String = cfgDt ? cfgDt.display : StringConst.ACTION_PROGRESS_0003;
					switchActionProgress(totalTime ? totalTime : ActionProgressData.MINING_TIME_MAP,strText);
				}
			}
		}
		
		public function dealMstDigInfo(data:ByteArray):void
		{
			var entityId:int = data.readInt();//怪物的唯一id，4字节有符号整形
			var digCount:int = dealDigCount(data);//挖掘次数
			var endTime:int = data.readInt();//怪物消失的unix时间戳，4字节有符号整形
			var mst:Monster = getEntity(EntityTypes.ET_MONSTER,entityId) as Monster;
			if(mst && mst.isShow)
			{
				var manager:SelectRoleDataManager = SelectRoleDataManager.getInstance();
				mst.killerCid = manager.selectCid;
				mst.killerSid = manager.selectSid;
				mst.digCount = digCount;
				mst.endTime = endTime;
				mst.updateDigCount();
			}
			LivingUnit(firstPlayer).idle();
		}
		
		private function dealSkillKnock(data:ByteArray):void
		{
			var entityKnockId:int = data.readInt();
			var knockCurrentTileX:int = data.readShort();
			var knockCurrentTileY:int = data.readShort();
			var knockNextTileX:int = data.readShort();
			var knockNextTileY:int = data.readShort();
			var knockTargetTileX:int = data.readShort();
			var knockTargetTileY:int = data.readShort();
			var dir:int = data.readByte();
			var entityKnockedId:int = data.readInt();
			var knockedTileX:int = data.readShort();
			var knockedTileY:int = data.readShort();
			var speed:int = data.readShort();
			var knocker:ILivingUnit = getEntityFormAll(entityKnockId) as ILivingUnit;
			var knockee:ILivingUnit = getEntityFormAll(entityKnockedId) as ILivingUnit;
			if (knocker)
			{
				if (knocker == firstPlayer)
				{
					var targetPos:Point = null;
					var dicVector:Vector.<Dictionary> = EntityLayerManager.getInstance().getAllLivingUnit();
					var pos:Point = MapTileUtils.getAroundTile(knockNextTileX, knockNextTileY, firstPlayer.direction);
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
				}
				if (find)
				{
					knocker.knockTo(knockCurrentTileX, knockCurrentTileY, knockNextTileX, knockNextTileY, knockNextTileX, knockNextTileY, knockee != null);
				}
				else
				{
					knocker.knockTo(knockCurrentTileX, knockCurrentTileY, knockNextTileX, knockNextTileY, knockTargetTileX, knockTargetTileY, knockee != null);
				}
			}
			else
			{
				knocker.knockTo(knockCurrentTileX, knockCurrentTileY, knockNextTileX, knockNextTileY, knockTargetTileX, knockTargetTileY, knockee != null);
			}
			if (knockee)
			{
				knockee.knockedTo(knockedTileX, knockedTileY, speed);
			}
		}
		
		private function dealSkillKnockEnd(data:ByteArray):void
		{
			var entityKnockId:int = data.readInt();
			var knockCurrentTileX:int = data.readShort();
			var knockCurrentTileY:int = data.readShort();
			var entityKnockedId:int = data.readInt();
			var knocker:ILivingUnit = getEntityFormAll(entityKnockId) as ILivingUnit;
			var knockee:ILivingUnit = getEntityFormAll(entityKnockedId) as ILivingUnit;
			if (knocker)
			{
				knocker.knockTo(knockCurrentTileX, knockCurrentTileY, knockCurrentTileX, knockCurrentTileY, knockCurrentTileX, knockCurrentTileY, true);
			}
			if (knockee)
			{
				knockee.knockedTo(0, 0, 0);
			}
			if(knocker && knocker is FirstPlayer)
			{
				AutoJobManager.getInstance().dealKnockAttack(knockee);
			}
		}
		
		private function dealSkillPushBack(data:ByteArray):void
		{
			var entityId:int = data.readInt();
			var nextTileX:int = data.readShort();
			var nextTileY:int = data.readShort();
			var speed:int = data.readShort();
			var pushee:ILivingUnit = getEntityFormAll(entityId) as ILivingUnit;
			if (pushee)
			{
				pushee.pushBackTo(nextTileX, nextTileY, speed);
			}
		}
		
		private function dealSkillPushBackEnd(data:ByteArray):void
		{
			var entityPusheeId:int = data.readInt();
			var pushee:ILivingUnit = getEntityFormAll(entityPusheeId) as ILivingUnit;
			if (pushee)
			{
				pushee.pushBackTo(0, 0, 0);
			}
		}
		
		public function entityMove(data:ByteArray):void
		{
			var id:int = data.readInt();
			var type:int = data.readByte();
			
			if (type != EntityTypes.ET_PLAYER || !_firstPlayer || id != _firstPlayer.entityId)
			{
				var livingUnit:ILivingUnit = getEntity(type, id) as ILivingUnit;
				if (livingUnit)
				{
					livingUnit.targetTileX = data.readShort();
					livingUnit.targetTileY = data.readShort();
					if (livingUnit.entityType == EntityTypes.ET_PLAYER)
					{
						var player:IPlayer = livingUnit as IPlayer;
						if (player.tileDistance(player.targetTileX, player.targetTileY) < AutoJobManager.RUN_DIST)
						{
							player.walk();
						}
						else
						{
							player.run();
						}
					}
					else
					{
						livingUnit.run();
					}
				}
			}
		}
		
		public function entityInstanceMove(data:ByteArray):void
		{
			var id:int = data.readInt();
			var type:int = data.readByte();
			var reason:int = 0;
			if (type == EntityTypes.ET_PLAYER)
			{
				var player:Player = _playerDic[id];
				if (player)
				{
					player.tileX = data.readShort();
					player.tileY = data.readShort();
					reason = data.readByte();
					player.targetTileX = player.tileX;
					player.targetTileY = player.tileY;
					
					if(player == _firstPlayer)
					{
						AutoSystem.instance.stopAutoEx();
						notifyData(GameServiceConstants.SM_INSTANT_MOVE,player);
					}
				}
			}
			else if (type == EntityTypes.ET_HERO)
			{
				var hero:Hero = _heroDic[id];
				if (hero)
				{
					hero.tileX = data.readShort();
					hero.tileY = data.readShort();
					reason = data.readByte();
					hero.targetTileX = hero.tileX;
					hero.targetTileY = hero.tileY;
				}
			}
			else if (type == EntityTypes.ET_PET)
			{
				var pet:Pet = _petDic[id];
				if (pet)
				{
					pet.tileX = data.readShort();
					pet.tileY = data.readShort();
					reason = data.readByte();
					pet.targetTileX = pet.tileX;
					pet.targetTileY = pet.tileY;
				}
			}
			else if (type == EntityTypes.ET_MONSTER)
			{
				var monster:Monster = _monsterDic[id];
				if (monster)
				{
					monster.tileX = data.readShort();
					monster.tileY = data.readShort();
					reason = data.readByte();
					monster.targetTileX = pet.tileX;
					monster.targetTileY = pet.tileY;
				}
			}
		}
		
		public function switchMap(mapId:int):void
		{
			clearAllEntities();
			
			initNpcs(mapId);
			initTeleporters(mapId);
			initSceneAnimations(mapId);
		}
		
		private function clearBuff(entity:IEntity):void
		{
			if(entity)
			{
				BuffDataManager.instance.removeTarget(entity.entityType,entity.entityId);
			}
		}
		
		private function clearAllEntities():void
		{
			for each (var player:Player in _playerDic)
			{
				if (player != _firstPlayer)
				{
					player.destory();
					
					clearBuff(player);
				}
			}
			_playerDic = new Dictionary();
			for each (var hero:Hero in _heroDic)
			{
				hero.destory();
				clearBuff(hero);
			}
			_heroDic = new Dictionary();
			for each (var pet:Pet in _petDic)
			{
				pet.destory();
				clearBuff(pet);
			}
			_petDic = new Dictionary();
			for each (var monster:Monster in _monsterDic)
			{
				monster.destory();
				clearBuff(monster);
			}
			_monsterDic = new Dictionary();
			for each (var trailer:Trailer in _trailerDic)
			{
				trailer.destory();
			}
			_trailerDic = new Dictionary();
			for each (var plant:Plant in _plantDic)
			{
				plant.destory();
			}
			_plantDic = new Dictionary();
			for each (var staticNpc:NpcStatic in _staticNpcDic)
			{
				staticNpc.destory();
			}
			_staticNpcDic = new Dictionary();
			for each (var dynamicNpc:NpcDynamic in _dynamicNpcDic)
			{
				dynamicNpc.destory();
			}
			_dynamicNpcDic = new Dictionary();
			for each (var teleporter:Teleporter in _teleporterDic)
			{
				teleporter.destory();
			}
			_teleporterDic = new Dictionary();
			for each (var trap:Trap in _trapDic)
			{
				trap.destory();
			}
			_trapDic = new Dictionary();
			for each (var sceneAnimation:SceneAnimation in _sceneAnimationDic)
			{
				sceneAnimation.destory();
			}
			_sceneAnimationDic = new Dictionary();
			for each (var dropItem:DropItem in _dropItemDic)
			{
				dropItem.destory();
				
				storeDropItemForPickUp(dropItem,false);
			}
			_dropItemDic = new Dictionary();
			_inViewDynamicEntitiesDic = new Dictionary();
			_inViewStaticEntitiesDic = new Dictionary();
			for each (var entities:Dictionary in _disapareEntitiesDic)
			{
				for each (var entity:IEntity in entities)
				{
					if (entity)
					{
						entity.destory();
					}
				}
			}
			_disapareEntitiesDic = new Dictionary();
			_apearEntitiesDic = new Dictionary();
		}
		
		private function initNpcs(mapId:int):void
		{
			for each(var npcConfig:NpcCfgData in ConfigDataManager.instance.npcCfgDatas(mapId))
			{
				if (npcConfig.damagable == 0)
				{
					if(npcConfig.dynamic)
					{
						var npcD:NpcDynamic = new NpcDynamic(npcConfig);
						_dynamicNpcDic[npcD.entityId] = npcD;
					}
					else
					{
						var npcS:NpcStatic = new NpcStatic(npcConfig);
						_staticNpcDic[npcS.entityId] = npcS;
					}
				}
			}
		}
		
		private function initTeleporters(mapId:int):void
		{
			for each(var teleporterConfig:MapTeleportCfgData in ConfigDataManager.instance.mapTeleporterCfgDatas(mapId))
			{
				var teleporter:Teleporter = new Teleporter(teleporterConfig);
				_teleporterDic[teleporterConfig.id] = teleporter;
			}
		}
		
		private function initSceneAnimations(mapId:int):void
		{
			for each(var sceneAnimationCfg:SceneEffectCfgData in ConfigDataManager.instance.sceneEffectCfgData(mapId))
			{
				var sceneAnimation:SceneAnimation = new SceneAnimation(sceneAnimationCfg);
				_sceneAnimationDic[sceneAnimationCfg.id] = sceneAnimation;
			}
		}
		
		public function update(timeDiff:int):void
		{
			if (_firstPlayer)
			{
				var allDynamicEntities:Vector.<Entity> = new Vector.<Entity>();
				var allStaticEntities:Vector.<Entity> = new Vector.<Entity>();
				var allLivingUnits:Vector.<LivingUnit> = new Vector.<LivingUnit>();
                var allHide:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_ALL);
                var allOtherPlayer:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_OTHER_PLAYER);
                var allOtherPlayerHero:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_OTHER_HERO);
                var allMonster:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_ALL_MONSTER);
                var nameInHead:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.NAME_IN_MIDDLE);

                var hideDesignation:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_OTHER_PLAYER_DESIGNATION);
                var hideWing:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_WING);
                var hideWeaponEffect:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_WEAPON_EFFECT);
                var hideSkillEffect:Boolean = DisplaySettingManager.instance.hideSkillEffect(DisplaySettingConst.HIDE_ALL_SKILL_EFFECT);

				//隐藏全部帮派名称
                var hideFactionName:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_FACTION_NAME);

				//检查是否是同一个队伍
                var hideTeamMember:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_SAME_TEAM_MEMBER);

				//检查是否是同一个帮派
                var hideFactionMember:Boolean = DisplaySettingManager.instance.getDisplaySettingState(DisplaySettingConst.HIDE_SAME_FACTION_MEMBER);

				var finalHideModel:Boolean = false;//最终是否隐藏人物模型
				for each (var player:Player in _playerDic)
				{
					if (!showOtherPlayer && player != _firstPlayer)
					{
						continue;
					}
					if (player is FirstPlayer)
					{
                        if (player.nameInBody != nameInHead)
						{
                            player.nameInBody = nameInHead;
						}
					}
					//隐藏称号（官职）
					if (player != _firstPlayer)
					{
						if (_hideDesignation != hideDesignation)
						{
							_hideDesignation = hideDesignation;
							player.isTitleShow = !_hideDesignation;
						}
						finalHideModel = allOtherPlayer;
						if (hideSkillEffect)
						{
							player.hideEffects();
						}
						else
						{
							player.showEffects();
						}
						if (_hideWing != hideWing)
						{
							_hideWing = hideWing;
						}
						if (_hideWeaponEffect != hideWeaponEffect)
						{
							_hideWeaponEffect = hideWeaponEffect;
							player.hideWeaponEffect = _hideWeaponEffect;
						}
						if (allHide == false)
						{
							if (_hideWing)
							{
								if (player.isWingShow)
								{
									player.isWingShow = !hideWing;
									player.changeModel();
								}
							}
							else
							{
								if (player.isWingShow == false)
								{
									player.isWingShow = !hideWing;
									player.changeModel();
								}
							}
						}
					}
					if (_hideFactionName != hideFactionName)
					{
						_hideFactionName = hideFactionName;
					}
					player.isFamilyNameShow = !_hideFactionName;


					if (hideTeamMember)
					{
						if (_firstPlayer.teamStatus != TeamStatus.TS_FREE)
						{//自己有队伍
							if (player.teamStatus != TeamStatus.TS_FREE)
							{
								if (player != _firstPlayer)
								{
									var isSameTeam:Boolean = TeamDataManager.instance.checkInSameTeam(player.cid, player.sid);
									if (isSameTeam)
									{
										finalHideModel = hideTeamMember;
									}
								}
							}
						}
					}

					if (hideFactionMember)
					{
						if (_firstPlayer.familyId > 0)
						{//自己有帮派
							if (player != _firstPlayer)
							{
								var isSameFaction:Boolean = SchoolElseDataManager.getInstance().checkInSameSchool(player.cid, player.sid);
								if (isSameFaction)
									finalHideModel = hideFactionMember;
							}
						}
					}
					if (player != _firstPlayer)
					{
						player.isHideModel = finalHideModel;
					}
					allLivingUnits.push(player);
					if(showOtherPlayer || player == _firstPlayer)
					{
						allDynamicEntities.push(player);
					}
				}
				for each (var hero:Hero in _heroDic)
				{
					if (hero != _myHero)
					{
						if (allOtherPlayerHero) continue;
					}
					allLivingUnits.push(hero);
					if(showOtherPlayer || hero == _myHero)
					{
                        if (hero == _myHero)
                        {
                            if (hero.nameInBody != nameInHead)
                            {
                                hero.nameInBody = nameInHead;
                            }
                        }
						allDynamicEntities.push(hero);
					}
				}
				for each (var pet:Pet in _petDic)
				{
					if (pet != _myPet)
					{
						if (pet.isHideModel != allMonster)
							pet.isHideModel = allMonster;
					}
					allLivingUnits.push(pet);
					if(showOtherPlayer || pet == _myPet)
					{
						allDynamicEntities.push(pet);
					}
				}
				for each (var trailer:Trailer in _trailerDic)
				{
					allLivingUnits.push(trailer);
					if (showOtherPlayer || trailer == _myTrailer)
					{
						allDynamicEntities.push(trailer);
					}
				}
				for each (var monster:Monster in _monsterDic)
				{
					if (monster.isHideModel != allMonster)
					{
						monster.isHideModel = allMonster;
					}
					allLivingUnits.push(monster);
					allDynamicEntities.push(monster);
				}
				for each (var plant:Plant in _plantDic)
				{
					allDynamicEntities.push(plant);
				}
				for each (var staticNpc:NpcStatic in _staticNpcDic)
				{
					allStaticEntities.push(staticNpc);
				}
				for each (var npcDynamic:NpcDynamic in _dynamicNpcDic)
				{
					allStaticEntities.push(npcDynamic);
				}
				for each (var teleporter:Teleporter in _teleporterDic)
				{
					var b:Boolean = isTeleportShow();
					if(b)
					{
						allStaticEntities.push(teleporter);
					}
				}
				function isTeleportShow():Boolean
				{
					var manager:ActivityDataManager = ActivityDataManager.instance;
					var isInLW:Boolean = manager.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_LOONG_WAR);
					var isKill:Boolean = manager.currentActvDataAtMap ? manager.currentActvDataAtMap.step > 1 : false;
					var isInDgn:Boolean = DgnDataManager.instance.isInDgn;
					var isFinish:Boolean = DgnGoalsDataManager.instance.isFinish;
					return ((teleporter.entityId != LoongWarDataManager.TELEPROT_ID || !isInLW) && (!teleporter.isHide || (teleporter.isHide && (!isInDgn || (isInDgn && isFinish))))) || 
							(teleporter.entityId == LoongWarDataManager.TELEPROT_ID && isInLW && !isKill);
				}
				for each (var trap:Trap in _trapDic)
				{
					allDynamicEntities.push(trap);
				}
				for each (var sceneAnimation:SceneAnimation in _sceneAnimationDic)
				{
					allStaticEntities.push(sceneAnimation);
				}
				for each (var dropItem:DropItem in _dropItemDic)
				{
					allDynamicEntities.push(dropItem);
				}
				
				var scene:GameSceneManager = GameSceneManager.getInstance();
				var centerTileX:int;
				var centerTileY:int;
				var cameraCenterPos:Point = scene.cameraCenterPos;
				if(scene.isCameraAnchor)
				{
					centerTileX = cameraCenterPos.x/MapTileUtils.TILE_WIDTH;
					centerTileY = cameraCenterPos.y/MapTileUtils.TILE_HEIGHT;
				}
				else
				{
					centerTileX = _firstPlayer.tileX;
					centerTileY = _firstPlayer.tileY;
				}
				
				_inViewEntities = new Vector.<Entity>();
				updateDynamicEntities(timeDiff, centerTileX, centerTileY, allDynamicEntities);
				updateStaticEntities(timeDiff, cameraCenterPos.x / MapTileUtils.TILE_WIDTH, cameraCenterPos.y / MapTileUtils.TILE_HEIGHT, allStaticEntities);
				updateDispareEntities(timeDiff);
				updateAllEntitiesPos(timeDiff, allLivingUnits);
				allDynamicEntities.length = 0;
				allLivingUnits.length = 0;
				_inViewEntities.sort(EntityUtils.sortOnY);
				clearAndAddSortedEntitys();
				if (_firstPlayer.stallStatue != RoleDataManager.instance.stallStatue)
				{
					_firstPlayer.stallStatue = RoleDataManager.instance.stallStatue;
				}
			}
		}
		
		public function updateFirstPlayerPos(timeOffset:int):void
		{
			if (_firstPlayer)
			{
				_firstPlayer.updatePos(timeOffset);
			}
		}
		
		private function updateDynamicEntities(timeDiff:int, centerTileX:int, centerTileY:int, allDynamicEntities:Vector.<Entity>):void
		{
			var newInViewEntitiesDic:Dictionary = new Dictionary();
			var posCount:Dictionary = new Dictionary();
			var entity:IEntity;
            var displayState:Boolean = DisplaySettingManager.instance.hideSkillEffect(DisplaySettingConst.HIDE_FIRE_WALL_EFFECT);
			var count:int = 0;
			var col:int = SceneMapManager.getInstance().mapWidth / MapTileUtils.TILE_WIDTH;
			for each (entity in allDynamicEntities)
			{
				var isMustShow:Boolean = entity == _firstPlayer || entity == _myHero || entity == _myPet || entity == _myTrailer;
				if ((Math.abs(entity.tileX - centerTileX) <= ViewTile.W && Math.abs(entity.tileY - centerTileY) <= ViewTile.H) && (count < 300 || isMustShow))
				{
					if ((entity.entityType == EntityTypes.ET_PLAYER || entity.entityType == EntityTypes.ET_HERO) && !isMustShow)
					{
						var index:int = entity.tileY * col + entity.tileX;
						if (posCount[index])
						{
							if (posCount[index] > 3)
							{
								continue;
							}
							++posCount[index];
						}
						else
						{
							posCount[index] = 1;
						}
					}
					++count;
					entity.updateFrame(timeDiff);
					_inViewEntities.push(entity);
					
					if (!newInViewEntitiesDic[entity.entityType])
					{
						newInViewEntitiesDic[entity.entityType] = new Dictionary();
					}
					newInViewEntitiesDic[entity.entityType][entity.entityId] = entity;
					
					if (_disapareEntitiesDic[entity.entityType] && _disapareEntitiesDic[entity.entityType][entity.entityId])
					{
						delete _disapareEntitiesDic[entity.entityType][entity.entityId];
						if (_inViewDynamicEntitiesDic[entity.entityType])
						{
							delete _inViewDynamicEntitiesDic[entity.entityType][entity.entityId];
						}
					}
					
					if (_inViewDynamicEntitiesDic[entity.entityType] && _inViewDynamicEntitiesDic[entity.entityType][entity.entityId])
					{
						delete _inViewDynamicEntitiesDic[entity.entityType][entity.entityId];
					}
					else
					{
						if (entity is Trap)
						{
							var tempTrap:Trap = entity as Trap;
							if (tempTrap.triggerType == TrapEffectHideConst.FIRE_WALL_EFFECT)
							{//火墙特殊化
								tempTrap.useSmallAvatarShow = displayState;
							}
						}
						entity.show();
						if (!_apearEntitiesDic[entity.entityType])
						{
							_apearEntitiesDic[entity.entityType] = new Dictionary();
						}
						_apearEntitiesDic[entity.entityType][entity.entityId] = entity;
					}
				}
			}
			var entities:Dictionary;
			for each (entities in _inViewDynamicEntitiesDic)
			{
				for each (entity in entities)
				{
					if (entity)
					{
						if (!_disapareEntitiesDic[entity.entityType])
						{
							_disapareEntitiesDic[entity.entityType] = new Dictionary();
						}
						_disapareEntitiesDic[entity.entityType][entity.entityId] = entity;
						if (_apearEntitiesDic[entity.entityType])
						{
							delete _apearEntitiesDic[entity.entityType][entity.entityId];
						}
					}
				}
			}
			_inViewDynamicEntitiesDic = newInViewEntitiesDic;
			for each (entities in _apearEntitiesDic)
			{
				for each (entity in entities)
				{
					if (entity)
					{
						entity.alpha += 0.02 * timeDiff / SceneViewItem.FRAME_TIME;
						if (entity.alpha >= 1)
						{
							entity.alpha = 1;
							delete _apearEntitiesDic[entity.entityType][entity.entityId];
						}
					}
				}
			}
			for each (entities in _disapareEntitiesDic)
			{
				for each (entity in entities)
				{
					if (entity)
					{
						entity.alpha -= 0.02 * timeDiff / SceneViewItem.FRAME_TIME;
						if (entity.alpha <= 0)
						{
							delete _disapareEntitiesDic[entity.entityType][entity.entityId];
							if (entity.entityType == EntityTypes.ET_PLAYER && !_playerDic[entity.entityId] || entity.entityType == EntityTypes.ET_HERO && !_heroDic[entity.entityId] ||
								entity.entityType == EntityTypes.ET_PET && !_petDic[entity.entityId] || entity.entityType == EntityTypes.ET_TRAILER && !_trailerDic[entity.entityId] ||
								entity.entityType == EntityTypes.ET_MONSTER && !_monsterDic[entity.entityId] || entity.entityType == EntityTypes.ET_PLANT && !_plantDic[entity.entityId] ||
								entity.entityType == EntityTypes.ET_DROPITEM && !_dropItemDic[entity.entityId] || entity.entityType == EntityTypes.ET_TRAP && !_trapDic[entity.entityId])
							{
								entity.destory();
							}
							else
							{
								entity.hide();
							}
						}
						else
						{
							_inViewEntities.push(entity);
						}
					}
				}
			}
		}
		
		private function updateStaticEntities(timeDiff:int, centerTileX:int, centerTileY:int, allStaticEntities:Vector.<Entity>):void
		{
			var viewWidthTile:int = _width / (2 * MapTileUtils.TILE_WIDTH) + 2;
			var viewHeightTile:int = _height / (2 * MapTileUtils.TILE_HEIGHT) + 5;
			var newInViewEntitiesDic:Dictionary = new Dictionary();
			var entity:IEntity;
			for each (entity in allStaticEntities)
			{
				if (Math.abs(entity.tileX - centerTileX) <= viewWidthTile  && Math.abs(entity.tileY - centerTileY) <= viewHeightTile)
				{
					entity.updateFrame(timeDiff);
					_inViewEntities.push(entity);
					
					if (!newInViewEntitiesDic[entity.entityType])
					{
						newInViewEntitiesDic[entity.entityType] = new Dictionary();
					}
					newInViewEntitiesDic[entity.entityType][entity.entityId] = entity;
					
					if (_inViewStaticEntitiesDic[entity.entityType] && _inViewStaticEntitiesDic[entity.entityType][entity.entityId])
					{
						delete _inViewStaticEntitiesDic[entity.entityType][entity.entityId];
					}
					else
					{
						entity.show();
					}
				}
			}
			var entities:Dictionary;
			for each (entities in _inViewStaticEntitiesDic)
			{
				for each (entity in entities)
				{
					if (entity)
					{
						entity.hide();
					}
				}
			}
			_inViewStaticEntitiesDic = newInViewEntitiesDic;
		}
		
		private function updateDispareEntities(timeDiff:int):void
		{
			for each (var dic:Dictionary in _disapareEntitiesDic)
			{
				for each (var entity:IEntity in dic)
				{
					entity.updateFrame(timeDiff);
				}
			}
		}
		
		private function updateAllEntitiesPos(timeDiff:int, allLivingUnits:Vector.<LivingUnit>):void
		{
			for each (var livingUnit:LivingUnit in allLivingUnits)
			{
				if (livingUnit != _firstPlayer)
				{
					livingUnit.updatePos(timeDiff);
				}
			}
		}
		
		private function clearAndAddSortedEntitys():void
		{
			var newEntityLength:int = _inViewEntities.length;
			var oldEntityLength:int = _lastInViewEntities.length;
			
			var i:int;
			var iInfoLabel:int = 0;
			for (i = 0; i < newEntityLength; ++i)
			{
				var entity:Entity = _inViewEntities[i];
				if (!_entityLayer.contains(entity))
				{
					_entityLayer.addChildAt(entity, i);
					++oldEntityLength;
				}
				else if (_entityLayer.getChildIndex(entity) != i)
				{
					_entityLayer.setChildIndex(entity, i);
				}
				var infoLabel:Sprite = entity.infoLabel;
				if (infoLabel)
				{
					if (!_entityInfoLabelLayer.contains(infoLabel))
					{
						_entityInfoLabelLayer.addChildAt(infoLabel, iInfoLabel);
					}
					else if (_entityInfoLabelLayer.getChildIndex(infoLabel) != iInfoLabel)
					{
						_entityInfoLabelLayer.setChildIndex(infoLabel, iInfoLabel);
					}
					++iInfoLabel;
				}
			}
			while (i < oldEntityLength)
			{
				if (_entityLayer.getChildAt(i))
				{
					_entityLayer.removeChildAt(i);
				}
				--oldEntityLength;
			}
			while (_entityInfoLabelLayer.numChildren > iInfoLabel)
			{
				_entityInfoLabelLayer.removeChildAt(iInfoLabel);
			}
			_lastInViewEntities = _inViewEntities;
		}
		
		public function getEntityUnderMouse():IEntity
		{
			var i:int;
			var length:int;
			length = _entityInfoLabelLayer.numChildren;
			for (i = length - 1; i >= 0; --i)
			{
				var entityInfoLabel:IEntityInfoLabel = _entityInfoLabelLayer.getChildAt(i) as IEntityInfoLabel;
				if (entityInfoLabel && entityInfoLabel.entityId && entityInfoLabel.isMouseOn())
				{
					var entity:IEntity = getEntityFormAll(entityInfoLabel.entityId);
					return entity;
				}
			}
			length = _lastInViewEntities.length;
			for (i = length - 1; i >= 0; --i)
			{
				entity = _lastInViewEntities[i];
				if (entity.isMouseOn())
				{
					return entity;
				}
			}
			return null;
		}
		
		public function refreshStaticNpcTaskEffect():void
		{
			var staticNpc:NpcStatic;
			for each(staticNpc in _staticNpcDic)
			{
				staticNpc.showTaskEffect();
			}
			var npcD:NpcDynamic;
			for each(npcD in _dynamicNpcDic)
			{
				npcD.showTaskEffect();
			}
		}
		
		public function changeNpcDynamicMode():void
		{
			var npcD:NpcDynamic;
			for each(npcD in _dynamicNpcDic)
			{
				npcD.changeMode();
			}
		}
		
		public function refreshPlayerTitle():void
		{
			var player:Player;
			for each(player in _playerDic)
			{
				player.initUpHeadContent();
			}
		}

		public function get monsterDic():Dictionary
		{
			return _monsterDic;
		}

		public function get dropItemDic():Dictionary
		{
			return _dropItemDic;
		}

		public function get playerDic():Dictionary
		{
			return _playerDic;
		}

		public function get plantDic():Dictionary
		{
			return _plantDic;
		}
		
		public function get trapDic():Dictionary
		{
			return _trapDic;
		}
		
		public function get inViewEntities():Vector.<Entity>
		{
			return _inViewEntities; 
		}
		
		public function get myPet():Pet
		{
			return _myPet;
		}

		public function get showOtherPlayer():Boolean
		{
			return _showOtherPlayer;
		}

		public function set showOtherPlayer(value:Boolean):void
		{
			_showOtherPlayer = value;
		}

		public function get myTrailer():FirstTrailer
		{
			return _myTrailer;
		}
		
		public function drowCircleRoundFirstPlayer(type:int):void
		{
			if(!_firstPlayer)
			{
				return;
			}
			if(!_circleRoundFirstPlayer)
			{
				var filter:GlowFilter = UtilColorMatrixFilters["DGN_TOWER_"+type];
				_circleRoundFirstPlayer = new Sprite();
				var color:int = circleRoundFirstPlayerColors[type];
				_circleRoundFirstPlayer.graphics.lineStyle(1,color,.7);
				_circleRoundFirstPlayer.graphics.drawEllipse(-10*MapTileUtils.TILE_WIDTH,-10*MapTileUtils.TILE_HEIGHT,20*MapTileUtils.TILE_WIDTH,20*MapTileUtils.TILE_HEIGHT);
				_circleRoundFirstPlayer.graphics.endFill();
				_circleRoundFirstPlayer.filters = [filter];
				_circleRoundFirstPlayer.blendMode = BlendMode.ADD;
				_circleRoundFirstPlayer.x = _firstPlayer.pixelX;
				_circleRoundFirstPlayer.y = _firstPlayer.pixelY;
				_entityLayer.addChild(_circleRoundFirstPlayer);
			}
		}
		
		public function cleanCircleRoundFirstPlayer():void
		{
			if(_circleRoundFirstPlayer)
			{
				if(_circleRoundFirstPlayer.parent)
				{
					_circleRoundFirstPlayer.parent.removeChild(_circleRoundFirstPlayer);
				}
				_circleRoundFirstPlayer = null;
			}
		}
	}
}

class PrivateClass{}