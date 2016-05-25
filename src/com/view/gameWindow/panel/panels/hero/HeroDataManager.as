package com.view.gameWindow.panel.panels.hero
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipBaptizeSuiteCfgData;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.EquipDegreeCfgData;
    import com.model.configData.cfgdata.EquipPolishCfgData;
    import com.model.configData.cfgdata.EquipRecycleCfgData;
    import com.model.configData.cfgdata.EquipRefinedCostCfgData;
    import com.model.configData.cfgdata.EquipResolveCfgData;
    import com.model.configData.cfgdata.EquipStrengthenSuiteCfgData;
    import com.model.configData.cfgdata.HeroMeridiansCfgData;
    import com.model.configData.cfgdata.HeroReincarnAttrCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.LevelCfgData;
    import com.model.configData.cfgdata.UselessSellCfgData;
    import com.model.consts.ConstHeroMode;
    import com.model.consts.ConstStorage;
    import com.model.consts.RolePropertyConst;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.common.ModelEvents;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.hero.tab1.bag.HeroBagCellClickHandle;
    import com.view.gameWindow.panel.panels.hero.tab1.equip.activate.HeroEquipActivateData;
    import com.view.gameWindow.panel.panels.hero.tab2.HeroUpgradeData;
    import com.view.gameWindow.panel.panels.hero.tab3.chest.HeroFashionChest;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.PageListData;
    import com.view.gameWindow.util.SayUtil;
    import com.view.gameWindow.util.ServerTime;
    import com.view.gameWindow.util.UtilGetCfgData;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import flash.utils.getTimer;
    
    import mx.utils.StringUtil;

    public class HeroDataManager extends DataManagerBase
	{
		private static var _instance:HeroDataManager;
		
		public static function get instance():HeroDataManager
		{
			if(!_instance)
				_instance = new HeroDataManager(new PrivateClass());
			return _instance;
		}
		public static const totalCellNum:int = 30;
		public static const TYPE_EXCHANGE:int = 100000;
		public static const pageTotal:int=4;
		
		public var isHeroExist:Boolean;
		private var _isExchange:Boolean;
		public var mode:int;
		public var oldLv:int;
		public var oldRe:int;//转生等级
        public var name:String = "", head:int, sex:int, job:int, grade:int, lv:int = 0, exp:int, lvExp:int, love:int, fightPower:int, lastX:int, lastY:int, scaleW:int, scaleH:int;
		public var attrHp:int,attrMaxHp:int,attrMp:int,attrMaxMp:int,angry:int,angryMax:int;
		public var minPhscDmg:int,maxPhscDmg:int,minMgcDmg:int,maxMgcDmg:int,minTrailDmg:int,maxTrailDmg:int,minPhscDfns:int,maxPhscDfns:int,minMgcDfns:int,maxMgcDfns:int;
		public var recoveryHp:int,recoveryMp:int,weightBearing:int;
		public var synergyAttackPower:int;
		public var equipDatas:Vector.<EquipData>;
		public var isEquipInited:Boolean = false;
		public var numCelUnLock:int;
		public var bagCellDatas:Vector.<BagData>;
		public var saleHP:int=80;
		
		public var heroActivateData:HeroEquipActivateData;
		
		private var _usedCellData:BagData;
		private var _usedCellEquipData:EquipData;
		private var _usedCellSlot:int;
		public var hpAutoNum:int;
		public var basicId:int;
		public var lastHideTime:int;//英雄上次收起时间
		public var lastDeadTime:int;//英雄上次死亡时间
		public var selectTab:int=0;
		public var heroUpgradeData:HeroUpgradeData;
		public var heroFashionChes:Array;
		public var heroChestPage:PageListData;
		/**整理操作冷却结束时间*/
		private var _sortCDOverTime:int;
		
		public static const HIDE:int = 30;
		public static const DEAD:int = 60;
		public function get isBattleReady():Boolean
		{
			var serveTime:int = ServerTime.time;
			var t0:int = serveTime - lastHideTime;
			var t1:int = serveTime - lastDeadTime;
			
			return t0 >= HIDE && t1 >= DEAD;
		}
//		/**英雄是否出战*/
//		public function get isBattle():Boolean
//		{
//			return mode == ConstHeroMode.HM_HOLD || mode == ConstHeroMode.HM_ACTIVE || mode == ConstHeroMode.HM_IDLE;
//		}
		/**获得出战或隐藏时对应的模式隐藏或出战模式*/
		public function get modeOpposite():int
		{
			var value:int;
			switch(mode)
			{
				case ConstHeroMode.HM_ACTIVE:
					value = ConstHeroMode.HM_HIDE_ACTIVE;
					break;
				case ConstHeroMode.HM_HOLD:
					value = ConstHeroMode.HM_HIDE_HOLD;
					break;
				case ConstHeroMode.HM_IDLE:
					value = ConstHeroMode.HM_HIDE_IDLE;
					break;
				case ConstHeroMode.HM_HIDE_ACTIVE:
					value = ConstHeroMode.HM_ACTIVE;
					break;
				case ConstHeroMode.HM_HIDE_HOLD:
					value = ConstHeroMode.HM_HOLD;
					break;
				case ConstHeroMode.HM_HIDE_IDLE:
					value = ConstHeroMode.HM_IDLE;
					break;
				default:
					value = ConstHeroMode.HM_ACTIVE;
					break;
			}
			return value;
		}
		
		public function HeroDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			heroActivateData=new HeroEquipActivateData();
			equipDatas = new Vector.<EquipData>();
			heroUpgradeData=new HeroUpgradeData();
			heroFashionChes=[];
			heroChestPage=new PageListData(pageTotal);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HERO_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HERO_BASIC_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_HERO_GRADE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HERO_CHEST_QUERY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HERO_AUTO_PUTON_EQUIPS,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_HERO_GRADE_MERIDIANS,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_ENTER_HERO_GRADE_DUNGEON,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_CONDITION_NOT_ENOUGH,this);
		}
		
		public function requestChangeHeroMode(mode:int):void
		{
			var _byteArray:ByteArray = new ByteArray();
			_byteArray.endian = Endian.LITTLE_ENDIAN;
			_byteArray.writeInt(mode);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHANGE_HERO_MODE,_byteArray);
		}
		
		public function recoverActivityMode():void
		{
			if(isHeroFight())
			{
				if(mode == ConstHeroMode.HM_HOLD)
				{
					requestChangeHeroMode(ConstHeroMode.HM_ACTIVE);
				}
			}
			else
			{
				if(mode == ConstHeroMode.HM_HIDE_HOLD)
				{
					requestChangeHeroMode(ConstHeroMode.HM_HIDE_ACTIVE);
				}
			}
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		public var isChangeForAutoDrug:Boolean = false;
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_HERO_INFO:
					readData(data);
					isChangeForAutoDrug = true;
					break;
				case GameServiceConstants.SM_HERO_BASIC_INFO:
					resolveHeroBasicInfo(data);
					break;
				case GameServiceConstants.SM_QUERY_HERO_GRADE:
					resolveHeroUpgrade(data);
					break;
				case GameServiceConstants.ERR_CONDITION_NOT_ENOUGH:
					Alert.warning(StringConst.HERO_UPGRADE_1014);
					break;
				case GameServiceConstants.CM_HERO_GRADE_MERIDIANS:
					dealHeroGradeMeridians(data);
					break;
				case GameServiceConstants.SM_HERO_CHEST_QUERY:
					dealHeroChestQuery(data);
					break;
				case GameServiceConstants.SM_HERO_UPGRADE_EQUIP_TIME_END:
					
					break;
				case GameServiceConstants.SM_HERO_AUTO_PUTON_EQUIPS:
					SayUtil.heroSayEquip();
					break;
				case GameServiceConstants.CM_ENTER_HERO_GRADE_DUNGEON:
					Alert.message(StringConst.HERO_UPGRADE_1023);
					break;

				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		public function itemUsed():void
		{
			super.resolveData(GameServiceConstants.SM_HERO_UPGRADE_EQUIP_TIME_END,null);
		}
		
		private function dealHeroChestQuery(data:ByteArray):void
		{
			fashionId = data.readInt();
			heroFashionChes.splice(0,heroFashionChes.length);
			var count:int = data.readInt();
			while(count>0)
			{
				var equipId:int = data.readInt();
				heroFashionChes.push(equipId);
				count--;
			}
			heroChestPage.changeList(heroFashionChes);
		}
		
		private function dealHeroGradeMeridians(data:ByteArray):void
		{
			var iscomple:int=data.readByte();
			if(iscomple==1)
			{
				Alert.message(StringConst.HERO_UPGRADE_1015);
			}else
			{
				var heroMeridiansCfgData:HeroMeridiansCfgData = ConfigDataManager.instance.heroMeridiansCfgData(heroUpgradeData.grade,heroUpgradeData.meridians+1);
				Alert.message(StringUtil.substitute(StringConst.HERO_UPGRADE_1016,heroMeridiansCfgData.cost_hero_exp*0.5));
			}
		}
		
		private function resolveHeroUpgrade(data:ByteArray):void
		{
			heroUpgradeData.grade=data.readByte();
			heroUpgradeData.meridians=data.readInt();
			heroUpgradeData.exp=data.readInt();
		}
		
		private var _useHandler:HeroBagCellClickHandle;
		public function requestUseItem(data:BagData,showTip:Boolean = false):void
		{
			if(!_useHandler)
			{
				_useHandler = new HeroBagCellClickHandle(null);
			}
			
			_useHandler.dealUseWear(data,showTip);
		}
		
		public function requestData():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_HERO_INFO,byteArray);
		}
		
		public function requestActivate():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HERO_EQUIP_UPGRADE,byteArray);
		}
		
		public function requestInsertExp():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HERO_EQUIP_INTO_EXP,byteArray);
		}
		
		public function resolveHeroBasicInfo(data:ByteArray):void
		{
			var oldBattle:Boolean = isHeroFight();
			head = data.readByte();
			mode = data.readByte();
			sex = data.readByte();
			job = data.readByte();
			oldRe = grade;
			grade = data.readByte();
			oldLv = lv;
			lv = data.readShort();
			basicId = data.readInt();//英雄官印的baseid
			love = data.readShort();
			attrHp = data.readInt();
			attrMaxHp = data.readInt();
			lastHideTime = data.readInt();
			lastDeadTime = data.readInt();
			
			if(!isHeroExist)
			{
				isHeroExist = true;
				notify(ModelEvents.HERO_BATTLE_MODE_CHANGE);
				return;
			}
			var newBattle:Boolean = isHeroFight();
			if(newBattle != oldBattle)
			{
				notify(ModelEvents.HERO_BATTLE_MODE_CHANGE);
			}
		}
		
		private function readData(data:ByteArray):void
		{
			readEquipInfos(data);
//			readEquipUpgradeInfos(data);
			readAttributeInfos(data);
			readBagInfos(data);
			
			if(!isHeroExist)
			{
				isHeroExist = true;
				notify(ModelEvents.HERO_BATTLE_MODE_CHANGE);
			}
		}
		
		public function updateShowRecycleShow():void
		{
			notify(ModelEvents.HERO_RECYCLE_CHANGE);
		}
		
		private function readEquipInfos(data:ByteArray):void
		{
			var i:int,l:int;
			l = ConstEquipCell.HP_TOTAL;
			equipDatas.length = 0;
			for(i=0;i<l;i++)
			{
				var equipData:EquipData = new EquipData();
				equipData.id = data.readInt();
				equipData.bornSid = data.readInt();
				equipData.slot = i;
				equipData.storageType = ConstStorage.ST_HERO_EQUIP;
				equipDatas.push(equipData);
			}
			
			isEquipInited = true;
		}
		
		private function readEquipUpgradeInfos(data:ByteArray):void
		{
				heroActivateData.grade=1;//当前阶
				heroActivateData.order=1;//当前顺序
		}
		
		public var accurate:int,bloodPercent:int,devilPercent:int,criticalHits:int,bloodLev:int,devilLev:int;
		public var criticalHitsHurt:int,paralysis:int,yiSheng:int,lucky:int,skiller:int,ghostSkiller:int;
		public var curse:int,beastSkiller:int,devilSkiller:int,mtgtnThro:int,hurtReflction:int,heartHurt:int,attackSpeed:int,speed:int;
		
		public var sacred:int,phscDmgMtgtn:int,agile:int,magicEvasion:int,tenacity:int,mgcDmgMtgtn:int,mgcDodge:int;
		public var defenceLuck:int,prlzRsstc:int,heartAside:int,reflctionLev:int,defencePercent:int,defence:int,reflctionPercent:int;
		
		public var lifeRecover:int,paralysisReplay:int,skillBloodReplay:int,magicRecover:int,drugReplay:int,skillBlue:int,poisonReplay:int,revive:int;
		
		public var skillMonstersMoney:int,skillMonstersExp:int,getTreasurePercent:int,dress:int;
		
		public var gainRate:int,captureSkillRate:int,angerRecoverSpeed:int,damageLower:int,damageUpper:int,damageFromHeroRateDown:int,damageToWarriorRateUp:int,damageFromWarriorRateDown:int,
				   damageToMagicRateUp:int,damageFromMagicRateDown:int,damageToWizardRateUp:int,damageFromWizardRateDown:int,damageToMonsterRateUp:int,
				   damageFromMonsterRateDown:int,damageToBossRateUp:int,damageFromBossRateDown:int;
		
		public var inForce:int,inForceMax:int,inForceRecovery:int,inForceDmgMtgtn:int;
		//属性池
		public var attrPool:Dictionary;

		public var fashionId:int;
		public var currentSelectChest:HeroFashionChest;
		public var fashionUse:Boolean=true;
		public static const MAX_STRENGTHEN_LEVEL:Number=51;
		public static const MAX_BAPTIZE_LEVEL:Number=20;
		
		/**判断转生、等级是否满足*/
		public function checkReincarnLevel(reincarnValue:int,levelValue:int):Boolean
		{
			var boolean:Boolean = grade > reincarnValue || (grade == reincarnValue && lv >= levelValue) as Boolean;
			return boolean;
		}
		
		private function readAttributeInfos(data:ByteArray):void
		{
			head = data.readByte();
			mode=data.readByte();//模式
			sex = data.readByte();
			job = data.readByte();
			oldRe = grade;
			grade = data.readByte();
			oldLv = lv;
			lv = data.readShort();
			doLvUp(oldLv,lv,oldRe,grade);
            lastX = data.readInt();//英雄图标上次X位置
            lastY = data.readInt();//英雄图标上次Y位置
            scaleW = data.readInt();
            scaleH = data.readInt();
			
			basicId = data.readInt();//英雄官印的baseid
			exp = data.readInt();
			love = data.readShort();//爱慕度
			fightPower = data.readInt();//战斗力
			hpAutoNum=data.readByte();  //回血数
			
			heroActivateData.grade=data.readInt();//当前阶
			heroActivateData.order=data.readInt();//当前顺序
			heroActivateData.exp=data.readInt();
			heroActivateData.timer=data.readInt();
			fashionId=data.readInt();
			
			attrHp = data.readInt();
			attrMaxHp = data.readInt();
			attrMp = data.readInt();
			attrMaxMp = data.readInt();
			inForce = data.readInt();//内力
			inForceMax = data.readInt();//内力上限
			angry = data.readShort();//怒气
			minPhscDmg = data.readInt();//最小物理伤害
			maxPhscDmg = data.readInt();//最大物理伤害
			minMgcDmg = data.readInt();//最小魔法伤害
			maxMgcDmg = data.readInt();//最大魔法伤害
			minTrailDmg = data.readInt();//最小道术伤害
			maxTrailDmg = data.readInt();//最大道术伤害
			minPhscDfns = data.readInt();//最小物理防御
			maxPhscDfns = data.readInt();//最大物理防御
			minMgcDfns = data.readInt();//最小魔法防御
			maxMgcDfns = data.readInt();//最大魔法防御
			accurate = data.readShort();//准确
			agile = data.readShort();//敏捷
			magicEvasion=data.readShort();//魔法免伤
			criticalHits = data.readShort();//暴击
			criticalHitsHurt=data.readInt();//暴击伤害
			tenacity=data.readShort();//韧性
			heartHurt=data.readShort();//会心一击
			heartAside=data.readShort();//会心闪避
			lucky = data.readShort();//幸运
			defenceLuck = data.readShort();//抵抗幸运
			curse = data.readShort();//诅咒
			sacred=data.readShort();//神圣
			attackSpeed = data.readShort();//攻击速度
			recoveryHp = data.readShort();//回血速度
			recoveryMp = data.readShort();//回蓝速度
			poisonReplay=data.readShort();//中毒回复
			weightBearing = data.readShort();//负重
			speed = data.readShort();//速度
			phscDmgMtgtn = data.readShort();//物理免伤
			mgcDmgMtgtn = data.readShort();//模仿免伤
			mtgtnThro = data.readShort();//免伤穿透
			hurtReflction = data.readShort();//伤害增益
			paralysis=data.readShort();//麻痹几率
			prlzRsstc = data.readShort();//抗麻痹几率
			paralysisReplay=data.readShort();//麻痹恢复
			synergyAttackPower = data.readShort();//合击威力
			reflctionPercent=data.readShort();//反射
			reflctionLev=data.readShort();//反射率
			defencePercent=data.readShort();//格挡
			defence=data.readInt();//格挡值
			bloodPercent=data.readShort();//吸血几率
			bloodLev=data.readShort();//吸血比例
			devilPercent=data.readShort();//吸魔几率
			devilLev=data.readShort();//吸魔比例
			skillBloodReplay=data.readInt();//击杀回血
			skillBlue = data.readInt();//击杀回魔
			drugReplay=data.readShort();//药效增益
			revive=data.readShort();//复活增益
			yiSheng=data.readShort();//抑生
			skiller=data.readShort();//人形怪杀手
			beastSkiller=data.readShort();//野兽杀手
			ghostSkiller=data.readShort();//亡灵杀手
			devilSkiller=data.readShort();//恶魔杀手
			getTreasurePercent = data.readShort();//打宝几率
			gainRate = data.readShort();// 探测宝物几率
			captureSkillRate = data.readShort();// 吸取技力几率
			skillMonstersMoney=data.readShort();// 杀怪金钱
			skillMonstersExp=data.readShort();// 杀怪经验
			angerRecoverSpeed = data.readShort();// 怒气恢复速度
			damageLower = data.readShort();// 攻击下限
			damageUpper = data.readShort();// 攻击上限
			damageFromHeroRateDown = data.readShort();//受英雄伤害减少
			damageToWarriorRateUp = data.readShort();// 对战士伤害增加
			damageFromWarriorRateDown = data.readShort();// 受战士伤害减少
			damageToMagicRateUp = data.readShort();// 对法师伤害增加
			damageFromMagicRateDown = data.readShort();// 受法师伤害减少
			damageToWizardRateUp = data.readShort();// 对道士伤害增加
			damageFromWizardRateDown = data.readShort();// 受道士伤害减少
			damageToMonsterRateUp = data.readShort();// 对怪物伤害增加
			damageFromMonsterRateDown = data.readShort();// 受怪物伤害减少
			damageToBossRateUp = data.readShort();// 对BOSS伤害增加
			damageFromBossRateDown = data.readShort();// 受BOSS伤害减少
			inForceRecovery = data.readInt();//内力回复
			inForceDmgMtgtn = data.readShort();//内力免伤
			
			refreshAttrPool();
		}
		
		private function doLvUp(oldLv:int, lv:int, oldRe:int,reincarn:int):void
		{
			if(oldLv != lv||oldRe!=reincarn)
			{
				TaskDataManager.instance.refreshOnDoingTasks(false);
				TaskDataManager.instance.refreshCanReceiveTask();
			}
		}
		/**刷新属性池*/
		private function refreshAttrPool():void
		{
			if(!attrPool)
			{
				attrPool = new Dictionary();
			}
			
			attrPool[RolePropertyConst.ROLE_PROPERTY_LIFE_UPPER_ID] = attrMaxHp;//生命上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_UPPER_ID] = attrMaxMp;//生命上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_PHSICAL_ATTACK_LOWER_ID] = minPhscDmg;//物理攻击下限
			attrPool[RolePropertyConst.ROLE_PROPERTY_PHYSICAL_ATTACK_UPPER_ID] = maxPhscDmg;//物理攻击下限
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_LOWER_ID] = minMgcDmg;//魔法攻击下限
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_UPPER_ID] = maxMgcDmg;//魔法攻击上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_LOWER_ID] = minTrailDmg;//道术攻击下限
			attrPool[RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_UPPER_ID] = maxTrailDmg;//道术攻击上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_PHYSICAl_DEFENSE_LOWER_ID] = minPhscDfns;//物理防御下限
			attrPool[RolePropertyConst.ROLE_PROPERTY_PHYSICAL_DEFENSE_UPPER_ID] = maxPhscDfns;//物理防御上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_DEFENSE_LOWER_ID] = minMgcDfns;//魔法防御下限
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_DEFENSE_UPPER_ID] = maxMgcDfns;//魔法防御上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_ACCURATE_ID] = accurate;//准确
			attrPool[RolePropertyConst.ROLE_PROPERTY_AGILE_ID] = agile;//敏捷
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_EVASION_ID] = magicEvasion;//魔法闪避
			attrPool[RolePropertyConst.ROLE_PROPERTY_CRIT_ID] = criticalHits;//暴击
			attrPool[RolePropertyConst.ROLE_PROPERTY_CRIT_HURT_ID] = criticalHitsHurt;//暴击伤害
			attrPool[RolePropertyConst.ROLE_PROPERTY_RESILIENCE_ID] = tenacity;//韧性
			attrPool[RolePropertyConst.ROLE_PROPERTY_HEART_HURT_ID] = heartHurt;//会心一击
			attrPool[RolePropertyConst.ROLE_PROPERTY_HEART_EVASION_ID] = heartAside;//会心闪避
			attrPool[RolePropertyConst.ROLE_PROPERTY_LUCKY_ID] = lucky;//幸运
			attrPool[RolePropertyConst.ROLE_PROPERTY_ANTI_LUCKY_ID] = defenceLuck;//抵抗幸运;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMNATION_ID] = curse;//诅咒;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HOLY_ID] = sacred;//神圣;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ATTACK_SPEED_ID] = attackSpeed;//攻击速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_BLOOD_RETURN_ID] = recoveryHp;//回血速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_RETURN_ID] = recoveryMp;//回蓝速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ANTI_POISON_ID] = poisonReplay;//中毒回复;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HEAVY_ID] = weightBearing;//负重;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MOVE_SPEED_ID] = speed;//速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_WU_LI_MIAN_SHANG_ID] = phscDmgMtgtn;//物理免伤;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MO_FA_MIAN_SHANG_ID] = mgcDmgMtgtn;//魔法免伤;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MIAN_SHANG_CHUAN_TOU_ID] = mtgtnThro;//免伤穿透;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_UP] = hurtReflction;//伤害增益;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MA_BI_RATE_ID] = paralysis;//麻痹几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MA_BI_KANG_XING_ID] = prlzRsstc;//抗麻痹几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MA_BI_RECOVER] = paralysisReplay;//麻痹回复;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HE_JI_WEI_LI_ID] = synergyAttackPower;//合击威力;
			attrPool[RolePropertyConst.ROLE_PROPERTY_REFLECT_ID] = reflctionPercent;//反射;
			attrPool[RolePropertyConst.ROLE_PROPERTY_REFLECT_RATE_ID] = reflctionLev;//反射率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_PARRY_ID] = defencePercent;//格挡;
			attrPool[RolePropertyConst.ROLE_PROPERTY_PARRY_VALUE_ID] = defence;//格挡值;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HP_DRAIN_ID] = bloodPercent;//吸血几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HP_DRAIN_RATE_ID] = bloodLev;//吸血比例;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MP_DRAIN_ID] = devilPercent;//吸魔几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MP_DRAIN_RATE_ID] = devilLev;//吸魔比例;
			attrPool[RolePropertyConst.ROLE_PROPERTY_KILL_HP_RECOVER_ID] = skillBloodReplay;//击杀回血;
			attrPool[RolePropertyConst.ROLE_PROPERTY_KILL_MP_RECOVER_ID] = skillBlue;//击杀回蓝;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DRUG_INTENSIFY_ID] = drugReplay;//药效增益;
			attrPool[RolePropertyConst.ROLE_PROPERTY_REVIVE_HP_UP] = revive;//复活增益;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ANTI_HP_RECOVER_ID] = yiSheng;//抑生;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HUMANOID_KILLER_ID] = skiller;//人形怪杀手;
			attrPool[RolePropertyConst.ROLE_PROPERTY_BEAST_KILLER_ID] = beastSkiller;//野兽杀手;
			attrPool[RolePropertyConst.ROLE_PROPERTY_GHOST_KILLER_ID] = ghostSkiller;//亡灵杀手;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DEVIL_KILLER_ID] = devilSkiller;//恶魔杀手;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ITEM_RROP_RATE_ID] = getTreasurePercent;//打宝几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_GAIN_RATE_ID] = gainRate;// 探测宝物几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_CAPTURE_SKILL_RATE] = captureSkillRate;// 吸取技力几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_KILL_MONSTER_MONEY_ID] = skillMonstersMoney;// 杀怪金钱;
			attrPool[RolePropertyConst.ROLE_PROPERTY_KILL_MONSTER_EXPERIENCE_ID] = skillMonstersExp;// 杀怪经验;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ANGER_RECOVER_SPEED] = angerRecoverSpeed;// 怒气恢复速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_LOWER] = damageLower;// 攻击下限;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_UPPER] = damageUpper;// 攻击上限;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_TO_WARRIOR_RATE_UP] = damageToWarriorRateUp;// 对战士伤害增加;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_FROM_WARRIOR_RATE_DOWN] = damageFromWarriorRateDown;// 受战士伤害减少;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_TO_MAGIC_RATE_UP] = damageToMagicRateUp;// 对法师伤害增加;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_FROM_MAGIC_RATE_DOWN] = damageFromMagicRateDown;// 受法师伤害减少;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_TO_WIZARD_RATE_UP] = damageToWizardRateUp;// 对道士伤害增加;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_FROM_WIZARD_RATE_DOWN] = damageFromWizardRateDown;// 受道士伤害减少;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_TO_MONSTER_RATE_UP] = damageToMonsterRateUp;// 对怪物伤害增加;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_TO_BOSS_RATE_UP] = damageFromMonsterRateDown;// 受怪物伤害减少;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_FROM_MONSTER_RATE_DOWN] = damageToBossRateUp;// 对BOSS伤害增加;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_FROM_BOSS_RATE_DOWN] = damageFromBossRateDown;// 受BOSS伤害减少;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAX_INTERNAL_FORCE_ID] = inForceMax;//内力上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_INTERNAL_FORCE_RECOVER_ID] = inForceRecovery;//内力回复
			attrPool[RolePropertyConst.ROLE_PROPERTY_INTERNAL_FORCE_AVOIDENCE_ID] = inForceDmgMtgtn;//内力免伤
			attrPool[RolePropertyConst.ROLE_PROPERTY_HP_ID] = attrHp;//生命值
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_ID] = attrMp;//魔法值
			attrPool[RolePropertyConst.ROLE_PROPERTY_NU_QI_ID] = angry;//魔法值
			attrPool[RolePropertyConst.ROLE_INTERNAL_FORCE_ID] = inForce;//内力值
		}
		
		private var _remainCellNum:int;

		public function get remainCellNum():int
		{
			return _remainCellNum;
		}

		private var _lastRemainCellNum:int = -1;
		
		private var _needShowRecycleGuide:Boolean = false;
		public var numRecycleShown:int = 0;
		//放在包裹数据刷新后
		private function checkCellNumChange():void
		{
			if(_lastRemainCellNum!=_remainCellNum)
			{
				needShowRecycleGuide = false;
				
				if(_remainCellNum <= 4 && _remainCellNum >= 0 && numRecycleShown == 0)
				{
					BagDataManager.instance.checkRecycleNum(false);
				}
			}
			_lastRemainCellNum = _remainCellNum;
		}
		
		private function readBagInfos(data:ByteArray):void
		{
			numCelUnLock = data.readByte();
			bagCellDatas = new Vector.<BagData>(totalCellNum,true);
			var readShort:int = data.readByte();
			if(numCelUnLock == readShort)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0031);
			}
			
			_remainCellNum = numCelUnLock - readShort;
			
			while(readShort--)
			{
				var bagData:BagData = new BagData();
				bagData.slot = data.readByte();
				bagData.id = data.readInt();
				bagData.bornSid = data.readInt();
				bagData.type = data.readByte();
				bagData.count = data.readShort();
				bagData.bind = data.readByte();
				bagData.storageType = ConstStorage.ST_HERO_BAG;
				bagCellDatas[bagData.slot] = bagData;
				/*trace("接收包裹信息，格子："+cellId+"，id："+id+"，类型："+type);*/
			}
			
			checkCellNumChange();
		}
		
		public function updateRecycleGuide():void
		{
			notify(GameServiceConstants.SM_HERO_BASIC_INFO);
		}
		
		
		/**英雄出战*/
		public function isHeroFight():Boolean
		{
			return mode == ConstHeroMode.HM_HOLD || mode == ConstHeroMode.HM_IDLE || mode == ConstHeroMode.HM_ACTIVE;
		}
		/**提示包裹已满*/
		public function promptBagPacked():void
		{
			/*if(!_remainCellNum)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0023);
				var manager:KeySellDataManager = KeySellDataManager.instance;
				manager.dealBagItems();
				if(!manager.datas || !manager.datas.length)
				{
					return;
				}
				PanelMediator.instance.openPanel(PanelConst.TYPE_KEY_SELL);
			}*/
		}
		/**
		 * 根据格子获取对应装备的战斗力，空格子战斗力为0
		 * @param slot
		 * @return 
		 */		
		public function getEquipPower(slot:int):Number
		{
			var equipData:EquipData = equipDatas.length > slot ? equipDatas[slot] : null;
			if(equipData&&equipData.id && equipData.bornSid)
			{
				var fightPowerEquiped:Number = 0;
				if(equipData.memEquipData){
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid,equipData.id);
					memEquipData.isHero = true;
					return memEquipData.getTotalFightPower();
				}
			}
			return 0;
		}
		/**
		 * 交换背包格数据
		 * @param cellId1当前格
		 * @param cellId2目标格
		 */		
		public function exchangeBagCellData(cellId1:int,cellId2:int):void
		{
			var infos1:BagData,infos2:BagData;
			infos1 = bagCellDatas[cellId1];
			infos2 = bagCellDatas[cellId2];
			if(infos2 && infos1.id == infos2.id && infos1.type == infos2.type && infos1.bind == infos2.bind)//同一种东西
			{
				bagCellDatas[cellId1] = null;
				bagCellDatas[cellId2].count = infos1.count + infos2.count;
			}
			else
			{
				bagCellDatas[cellId1] = infos2;
				bagCellDatas[cellId2] = infos1;
			}
		}
		
		public function get usedCellData():BagData
		{
			var _usedCellData2:BagData = _usedCellData;
			_usedCellData = null;
			return _usedCellData2;
		}
		
		public function setUsedCellData(cellId:int):void
		{
			_usedCellData = bagCellDatas[cellId];
		}
		
		public function getBagCellDataByIdType(id:int, type:int, bornSid:int):BagData
		{
			for each(var bagCellData:BagData in bagCellDatas)
			{
				if(bagCellData && bagCellData.id == id && bagCellData.type == type && bagCellData.bornSid == bornSid)
				{
					return bagCellData;
				}
			}
			return null;
		}
		/**
		 * 取第一个空的格子
		 * @return 若无空格子返回-1
		 */		
		public function getFirstEmptyCellId():int
		{
			var i:int,l:int;
			l = bagCellDatas.length;
			for(i=0;i<l;i++)
			{
				var bagData:BagData = bagCellDatas[i];
				if(!bagData)
				{
					return i;
				}
			}
			return -1;
		}
		
		public function getRecycleEquipDatas():Vector.<BagData>
		{
			var bagCellData:BagData,vector:Vector.<BagData>;
			vector = new Vector.<BagData>();
			for each(bagCellData in bagCellDatas)
			{
				if(bagCellData && bagCellData.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagCellData.bornSid,bagCellData.id);
					if(!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if(!equipCfgData)
					{
						continue;
					}
					var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type,equipCfgData.quality,equipCfgData.level);
					if(equipRecycleCfgData)
					{
						vector.push(bagCellData);
					}
				}
			}
			return vector;
		}
		
		public function getResolveEquipDatas():Vector.<BagData>
		{
			var bagCellData:BagData,vector:Vector.<BagData>;
			vector = new Vector.<BagData>();
			for each(bagCellData in bagCellDatas)
			{
				if(bagCellData && bagCellData.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagCellData.bornSid,bagCellData.id);
					if(!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if(!equipCfgData)
					{
						continue;
					}
					var cfgData:EquipResolveCfgData = ConfigDataManager.instance.equipResolveCfgData(memEquipData.baseId);
					if(cfgData)
					{
						vector.push(bagCellData);
					}
				}
			}
			return vector;
		}
		
		public function getAndUsedCellEquipData():EquipData
		{
			var data:EquipData = _usedCellEquipData;
			_usedCellEquipData = null;
			return data;
		}
		/**
		 * 交换装备格数据
		 * @param cellId1当前格
		 * @param cellId2目标格
		 */		
		public function exchangeEquipCellPicId(cellId1:int,cellId2:int):void
		{
			var equipData:EquipData = equipDatas[cellId1];
			equipDatas[cellId1] = equipDatas[cellId2];
			equipDatas[cellId2] = equipData;
		}
		
		/**
		 * 获取道具数量
		 * @param type 道具类型
		 * @param bind -1：都获取，0：不绑定，1：绑定
		 * @param dt 最后一个道具单元格数据
		 * @return
		 */
		public function getItemNumByType(type:int, bind:int = -1, dt:BagData = null):int
		{
			var bagCellData:BagData,num:int;
			for each(bagCellData in bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_ITEM)
				{
					var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(bagCellData.id);
					if (!itemCfgData || itemCfgData.type != type)
					{
						continue;
					}
					if(bind == -1 || (bind != -1 && bagCellData.bind == bind))
					{
						num += bagCellData.count;
						if (dt)
						{
							dt.copyForm(bagCellData);
						}
					}
				}
			}
			return num;
		}
		
		public function setUsedCellOnlyId(slot:int):void
		{
			_usedCellEquipData = equipDatas[slot];
			_usedCellSlot = slot;
		}
		
		public function get usedCellSlot():int
		{
			var _usedCellSlot2:int = _usedCellSlot;
			_usedCellSlot = -1;
			return _usedCellSlot2;
		}
		
		public function getBagCellData(cellId:int):BagData
		{
			return bagCellDatas[cellId];
		}
		
		public function getBagDataById(id:int):BagData
		{
			for each(var tmp:BagData in bagCellDatas)
			{
				if(tmp && tmp.id == id)
				{
					return tmp;
				}
			}
			return null;
		}
		/**
		 * 获取道具数量
		 * @param id 道具id
		 * @param bind -1：都获取，0：不绑定，1：绑定
		 * @return 
		 */		
		public function getItemNumById(id:int,bind:int = -1):int
		{
			var bagCellData:BagData,num:int;
			for each(bagCellData in bagCellDatas)
			{
				if(bagCellData && bagCellData.type == SlotType.IT_ITEM && bagCellData.id == id)
				{
					if(bind == -1 || (bind != -1 && bagCellData.bind == bind))
					{
						num += bagCellData.count;
					}
				}
			}
			return num;
		}
		
		public function getHeroBagDataById(id:int):BagData
		{
			for each(var bgData:BagData in bagCellDatas)
			{
				if(bgData&&bgData.id==id)
				{
					return bgData;
				}
			}
			return null;
		}
		
		/**
		 * 获取某道具所占格子的数量
		 * @param id 道具id
		 * @param bind -1：都获取，0：不绑定，1：绑定
		 * @return 
		 */	
		public function getItemsNumById(id:int,bind:int=-1):Vector.<BagData>
		{
			var bagCellData:BagData;
			var bagCellDataVec:Vector.<BagData>=new Vector.<BagData>;
			for each(bagCellData in bagCellDatas)
			{
				if(bagCellData && bagCellData.type == SlotType.IT_ITEM && bagCellData.id == id)
				{
					if(bagCellData.bind == bind)
					{
						bagCellDataVec.push(bagCellData);
					}
				}
			}
			return bagCellDataVec;
		}
		
		
		/**是否开启交换模式，交换模式为角色包裹与英雄包裹的快速交换*/
		public function get isExchange():Boolean
		{
			return _isExchange;
		}
		/**
		 * @private
		 */
		public function set isExchange(value:Boolean):void
		{
			_isExchange = value;
			notify(TYPE_EXCHANGE);
		}
		/**整理操作剩余的冷却时间*/
		public function get sortCDTime():int
		{
			return (_sortCDOverTime - getTimer())*.001;
		}
		/**
		 * @private
		 */
		public function set sortCDTime(value:int):void
		{
			_sortCDOverTime = getTimer() + value*1000;
		}
		
		public function getCanStrengthenEquips():Array
		{
			var equipArr:Array = [];
			
			for each(var quipData:EquipData in equipDatas)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(quipData.bornSid,quipData.id);
				if(!memEquipData)
				{
					continue;
				}
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if(!equipCfgData)
				{
					continue;
				}
				if(equipCfgData.strengthen > 0 && memEquipData.strengthen <= equipCfgData.strengthen)
				{
					equipArr.push(quipData);
				}
			}
			return equipArr;
		}
		/**
		 * 获取可以打磨的装备列表
		 * @return 
		 */		
		public function getCanPolishEquips():Array
		{
			var array:Array = new Array();
			var dt:EquipData;
			for each(dt in equipDatas)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(dt.bornSid,dt.id);
				if(!memEquipData)
				{
					continue;
				}
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if(!equipCfgData)
				{
					continue;
				}
				if(equipCfgData.strengthen <= 0)
				{
					continue;
				}
				var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
				if(!equipPolishCfgData || memEquipData.strengthen < equipPolishCfgData.equipstrong_limit)
				{
					continue;
				}
				array.push(dt);
			}
			return array;
		}
		/**
		 * 获取可以强化的装备列表 
		 * @return 
		 */		
		public function getCanStrengthBagEquips():Array
		{
			var equipArr:Array = [];
			for each(var bagCellData:BagData in bagCellDatas)
			{
				if(bagCellData && bagCellData.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagCellData.bornSid,bagCellData.id);
					if(!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if(!equipCfgData)
					{
						continue;
					}
					if(equipCfgData.strengthen > 0 && memEquipData.strengthen <= equipCfgData.strengthen)
					{
						equipArr.push(bagCellData);
					}
				}
			}
			return equipArr;
		}
		/**
		 * 获取可以打磨的装备列表
		 * @return 
		 */		
		public function getCanPolishBagEquips():Array
		{
			var array:Array = new Array();
			var dt:BagData;
			for each(dt in bagCellDatas)
			{
				if (dt && dt.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(dt.bornSid,dt.id);
					if(!memEquipData)
					{
						continue;
					}
					var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
					if(!equipPolishCfgData || memEquipData.strengthen < equipPolishCfgData.equipstrong_limit)
					{
						continue;
					}
					array.push(dt);
				}
			}
			return array;
		}
		/**
		 * 获取所有可转移的装备
		 * @param type 0：未选择装备，非0：已选择装备的类型，使用ConstEquipCell中的类型
		 * @param onlyId 选择的原装备的唯一id
		 * @param filter 1：全选，2转移强化/打磨属性，3转移随机属性
		 * @param memEquipDataSelect 已选装备数据
		 * @return 
		 */
		public function getExtendEquipDatas(type:int,onlyId:int,filter:int,memEquipDataSelect:MemEquipData):Vector.<EquipData>
		{
			var lvStrength:int = memEquipDataSelect ? memEquipDataSelect.strengthen : 0;
			var lvEquip:int = memEquipDataSelect && memEquipDataSelect.equipCfgData ? memEquipDataSelect.equipCfgData.level : 0;
			var quality:int = memEquipDataSelect && memEquipDataSelect.equipCfgData ? memEquipDataSelect.equipCfgData.quality : 0;
			var lvPolish:int = memEquipDataSelect ? memEquipDataSelect.polish : 0;
			var attrRdCount:int = memEquipDataSelect ? memEquipDataSelect.attrRdCount : 0;
			var equipData:EquipData,vector:Vector.<EquipData>;
			vector = new Vector.<EquipData>();
			for each(equipData in equipDatas)
			{
				if(equipData)
				{
					if(equipData.id == onlyId)
					{
						continue;
					}
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid,equipData.id);
					if(!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if(!equipCfgData)
					{
						continue;
					}
					if(!equipCfgData.strengthen)
					{
						continue;
					}
					if(type && type != equipCfgData.type)
					{
						continue;
					}
					if(quality && quality > equipCfgData.quality)
					{
						continue;
					}
					if(quality && quality == equipCfgData.quality && lvEquip && lvEquip > equipCfgData.level)
					{
						continue;
					}
					var isUnsatisfy:Boolean = isUnsatisfySP(filter,lvStrength,lvPolish,memEquipData);
					if(isUnsatisfy)
					{
						continue;
					}
					var isUnsatisfyRd1:Boolean = isUnsatisfyRd(filter, attrRdCount, memEquipData);
					if (isUnsatisfyRd1)
					{
						continue;
					}
					vector.push(equipData);
				}
			}
			return vector;
		}
		/**
		 * 获取所有可转移的装备
		 * @param type 0：未选择装备，非0：已选择装备的类型，使用ConstEquipCell中的类型
		 * @param onlyId 选择的原装备的唯一id
		 * @param filter 1：全选，2转移强化/打磨属性，3转移随机属性
		 * @param memEquipDataSelect 已选装备数据
		 * @return 
		 */
		public function getExtendEquipDatas1(type:int,onlyId:int,filter:int,memEquipDataSelect:MemEquipData):Vector.<BagData>
		{
			var lvStrength:int = memEquipDataSelect ? memEquipDataSelect.strengthen : 0;
			var lvEquip:int = memEquipDataSelect && memEquipDataSelect.equipCfgData ? memEquipDataSelect.equipCfgData.level : 0;
			var quality:int = memEquipDataSelect && memEquipDataSelect.equipCfgData ? memEquipDataSelect.equipCfgData.quality : 0;
			var lvPolish:int = memEquipDataSelect ? memEquipDataSelect.polish : 0;
			var attrRdCount:int = memEquipDataSelect ? memEquipDataSelect.attrRdCount : 0;
			var bagData:BagData,vector:Vector.<BagData>;
			vector = new Vector.<BagData>();
			for each(bagData in bagCellDatas)
			{
				if(bagData && bagData.type == SlotType.IT_EQUIP)
				{
					if(bagData.id == onlyId)
					{
						continue;
					}
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagData.bornSid,bagData.id);
					if(!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if(!equipCfgData)
					{
						continue;
					}
					if(!equipCfgData.strengthen)
					{
						continue;
					}
					if(type && type != equipCfgData.type)
					{
						continue;
					}
					if(quality && quality > equipCfgData.quality)
					{
						continue;
					}
					if(quality && quality == equipCfgData.quality && lvEquip && lvEquip > equipCfgData.level)
					{
						continue;
					}
					var isUnsatisfy:Boolean = isUnsatisfySP(filter,lvStrength,lvPolish,memEquipData);
					if(isUnsatisfy)
					{
						continue;
					}
					var isUnsatisfyRd1:Boolean = isUnsatisfyRd(filter, attrRdCount, memEquipData);
					if (isUnsatisfyRd1)
					{
						continue;
					}
					vector.push(bagData);
				}
			}
			return vector;
		}
		/**强化/打磨条件不满足*/
		private function isUnsatisfySP(filter:int,lvStrength:int,lvPolish:int,memEquipData:MemEquipData):Boolean
		{
			var boolean:Boolean = (filter == 1 || filter == 2);
			var boolean2:Boolean = !lvStrength && !memEquipData.strengthen;
			var boolean3:Boolean = lvStrength && (lvStrength < memEquipData.strengthen || (lvStrength == memEquipData.strengthen && lvPolish <= memEquipData.polish));
			return boolean && (boolean2 || boolean3);
		}
		/**随机属性条件不满足*/
		private function isUnsatisfyRd(filter:int,attrRdCount:int,memEquipData:MemEquipData):Boolean
		{
			var boolean:Boolean = filter == 1 || filter == 3;
			var boolean2:Boolean = !attrRdCount && !memEquipData.attrRdCount;
			var boolean3:Boolean = attrRdCount && attrRdCount > memEquipData.attrRdCount;
			return boolean && (boolean2 || boolean3);
		}
		
		public function getDegreeEquipDatas():Vector.<EquipData>
		{
			var equipData:EquipData,vector:Vector.<EquipData>;
			vector = new Vector.<EquipData>();
			for each(equipData in equipDatas)
			{
				if(equipData)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid,equipData.id);
					if(!memEquipData)
					{
						continue;
					}
					var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
					if(!equipDegreeCfgData)
					{
						continue;
					}
					vector.push(equipData);
				}
			}
			return vector;
		}
		
		public function getRefinedEquipDatas():Vector.<EquipData>
		{
			var vector:Vector.<EquipData> = new Vector.<EquipData>();
			var dt:EquipData;
			for each(dt in equipDatas)
			{
				if(dt)
				{
					var memEquipData:MemEquipData = dt.memEquipData;
					if(!memEquipData)
					{
						continue;
					}
					var equipRefinedCostCfgData:EquipRefinedCostCfgData = memEquipData.equipRefinedCostCfgData;
					if(!equipRefinedCostCfgData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = memEquipData.equipCfgData;
					if(!equipCfgData)
					{
						continue
					}
					if(equipCfgData.job && equipCfgData.job != job)
					{
						continue;
					}
					if(!memEquipData.attrRdCount)
					{
						continue;
					}
					vector.push(dt);
				}
			}
			return vector;
		}
		/**获取所有可一键出售的道具*/
		public function getKeySellDatas():Vector.<BagData>
		{
			var worldLevel:int = WelfareDataMannager.instance.worldLevel;
			var uselessSellCfgDatas:Vector.<UselessSellCfgData> = ConfigDataManager.instance.uselessSellCfgDatas(lv,worldLevel);
			if(!uselessSellCfgDatas.length)
			{
				return null;
			}
			var vector:Vector.<BagData> = new Vector.<BagData>();
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			var data:BagData,sellData:UselessSellCfgData;
			for each(data in bagCellDatas)
			{
				if(!data)
				{
					continue;
				}
				for each(sellData in uselessSellCfgDatas)
				{
					if(data.type == SlotType.IT_EQUIP)
					{
						var equipCfgData:EquipCfgData = utilGetCfgData.GetEquipCfgData(data.id,data.bornSid);
						if(!equipCfgData)
						{
							continue;
						}
						if(equipCfgData.id == sellData.item_id)
						{
							var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(data.bornSid,data.id);
							var isFightPowerHigher:Boolean = BagDataManager.instance.isFightPowerHigher(memEquipData);
							if(!isFightPowerHigher)
							{
								vector.push(data);
							}
						}
					}
					else
					{
						if(data.id == sellData.item_id)
						{
							vector.push(data);
						}
					}
				}
			}
			return vector;
		}
		
		public function requestHeroUpgradeData():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_HERO_GRADE,byteArray);
		}
		
		public function activateNode():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HERO_GRADE_MERIDIANS,byteArray);
		}
		
		public function enterHeroUpgardeDun():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_HERO_GRADE_DUNGEON,byteArray);
		}
		
		public function heroChestQuery():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HERO_CHEST_QUERY,byteArray);
		}
		
		public function requestUseImage(id:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HERO_CHEST_USE,byteArray);
		}
		
		public function checkEquipStrengLevel(slot:int, level:int):Boolean
		{
			if(equipDatas[slot].memEquipData!=null)
			{
				if(equipDatas[slot].memEquipData.strengthen>=level)
				{
					return true;
				}
			}
			return false;
		}
		
		public function getCurStrengthenLevelCfgData():EquipStrengthenSuiteCfgData
		{
			var minLevel:Number = getStrengthenMinLevel();
			while(minLevel>0)
			{
				var equipStrengthenSuicCfg:EquipStrengthenSuiteCfgData = ConfigDataManager.instance.equipStrengthenSuitCfg(minLevel);
				if(equipStrengthenSuicCfg!=null)
				{
					return equipStrengthenSuicCfg;
				}
				minLevel--;
			}
			return null;
		}
		
		public function getNextStrengthenLevelCfgData():EquipStrengthenSuiteCfgData
		{
			var minLevel:Number = getStrengthenMinLevel()+1;
			while(minLevel<MAX_STRENGTHEN_LEVEL)
			{
				var equipStrengthenSuicCfg:EquipStrengthenSuiteCfgData = ConfigDataManager.instance.equipStrengthenSuitCfg(minLevel);
				if(equipStrengthenSuicCfg!=null)
				{
					return equipStrengthenSuicCfg;
				}
				minLevel++;
			}
			return null;
		}
		
		/**
		 *获取装备的最小强化等级 
		 * */
		public function getStrengthenMinLevel():Number
		{
			var strengs:Array=[];
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.slot>ConstEquipCell.HP_XIEZI)
					continue;
				if(quipData.memEquipData==null)
				{
					strengs.push(0);
				}else
				{
					strengs.push(quipData.memEquipData.strengthen);
				}
			}
			strengs.sort(Array.NUMERIC);
			return strengs[0];
		}
		
		public function checkEquipBaptizeLevel(slot:int, level:int):Boolean
		{
			if(equipDatas[slot].memEquipData!=null)
			{
				if(equipDatas[slot].memEquipData.attrRdMinStar>=level)
				{
					return true;
				}
			}
			return false;
		}
		
		public function getCurBaptizeLevelCfgData():EquipBaptizeSuiteCfgData
		{
			var minLevel:Number = getBaptizeMinLevel();
			while(minLevel>0)
			{
				var equipBaptizeSuicCfg:EquipBaptizeSuiteCfgData = ConfigDataManager.instance.equipBaptizeSuitCfg(minLevel);
				if(equipBaptizeSuicCfg!=null)
				{
					return equipBaptizeSuicCfg;
				}
				minLevel--;
			}
			return null;
		}
		
		private function getBaptizeMinLevel():Number
		{
			var baptizes:Array=[];
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.slot>ConstEquipCell.HP_XIEZI)
					continue;
				if(quipData.memEquipData==null)
				{
					baptizes.push(0);
				}else
				{
					baptizes.push(quipData.memEquipData.attrRdMaxStar);
				}
			}
			baptizes.sort(Array.NUMERIC);
			return baptizes[0];
		}
		
		public function getNextBaptizeLevelCfgData():EquipBaptizeSuiteCfgData
		{
			var minLevel:Number = getBaptizeMinLevel()+1;
			while(minLevel<MAX_BAPTIZE_LEVEL)
			{
				var equipBaptizeSuicCfg:EquipBaptizeSuiteCfgData = ConfigDataManager.instance.equipBaptizeSuitCfg(minLevel);
				if(equipBaptizeSuicCfg!=null)
				{
					return equipBaptizeSuicCfg;
				}
				minLevel++;
			}
			return null;
		}
		
		public function getCurReincarnLevelCfgData():HeroReincarnAttrCfgData
		{
			var minLevel:Number =heroUpgradeData.grade ;
			while(minLevel>0)
			{
				var heroReincarnSuitCfg:HeroReincarnAttrCfgData = ConfigDataManager.instance.heroReincarnSuitCfg(minLevel);
				if(heroReincarnSuitCfg!=null)
				{
					return heroReincarnSuitCfg;
				}
				minLevel--;
			}
			return null;
		}
		
		public function getNextREincarnLevelCfgData():HeroReincarnAttrCfgData
		{
			var minLevel:Number =heroUpgradeData.grade +1;
			while(minLevel<MAX_STRENGTHEN_LEVEL)
			{
				var heroReincarnSuitCfg:HeroReincarnAttrCfgData = ConfigDataManager.instance.heroReincarnSuitCfg(minLevel);
				if(heroReincarnSuitCfg!=null)
				{
					return heroReincarnSuitCfg;
				}
				minLevel++;
			}
			return null;
		}
		
		public function checkEquipQualityByType(type:int,quality:int):Boolean
		{
			var equipData:EquipData;
			for each(equipData in equipDatas)
			{
				if(equipData)
				{
					var memEquipData:MemEquipData = equipData.memEquipData;
					if(!memEquipData)
					{
						return false;
					}
					var equipCfgData:EquipCfgData = memEquipData.equipCfgData;
					if(!equipCfgData)
					{
						return false;
					}
					if(type == equipCfgData.type)
					{
						if(equipCfgData.quality==quality)
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
		public function checkEquuiplvByType(type:int,lv:int):Boolean
		{
			var equipData:EquipData;
			for each(equipData in equipDatas)
			{
				if(equipData)
				{
					var memEquipData:MemEquipData = equipData.memEquipData;
					if(!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = memEquipData.equipCfgData;
					if(!equipCfgData)
					{
						continue;
					}

					if(type == equipCfgData.type)
					{
						var level:int=equipCfgData.level;
						if(equipCfgData.quality!=1)
						{
							level+=30;
						}
						if(level>=lv)
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * 判断传入的背包格子装备战斗力是否比装备着的装备好
		 */
		public function isBagFightPowerHigher(bagData:BagData):Boolean
		{
			var memEquipData:MemEquipData = bagData.memEquipData;
			var equipCfgData:EquipCfgData = memEquipData ? memEquipData.equipCfgData : null;
			if (!equipCfgData)
			{
				trace("in BagDataManager.isBagFightPowerHigher 不存在id 2");
				return false;
			}
			if (equipCfgData.job && equipCfgData.job != job)
			{
				trace("in BagDataManager.isBagFightPowerHigher 职业不对");
				return false;
			}
			if (equipCfgData.sex && equipCfgData.sex != sex)
			{
				trace("in BagDataManager.isBagFightPowerHigher 性别不对");
				return false;
			}
			if (equipCfgData.level > lv)
			{
				trace("in BagDataManager.isBagFightPowerHigher 等级不够");
				return false;
			}
			if (!isFightPowerHigher(memEquipData))
			{
				trace("in BagDataManager.isBagFightPowerHigher 战斗力没有身上的高");
				return false;
			}
			return true;
		}
		
		/**
		 * 判断传入的装备战斗力是否比装备着的装备好
		 * @param equipCfgData
		 * @return
		 */
		public function isFightPowerHigher(memEquipData:MemEquipData):Boolean
		{
			if(!memEquipData)
			{
				return false;
			}
			if(memEquipData.equipCfgData.entity!=0&&memEquipData.equipCfgData.entity!=EntityTypes.ET_HERO)return false;
			var fightPower:Number = 0, fightPowerEquiped:Number = 0;
			memEquipData.isHero = true;
			fightPower = memEquipData.getTotalFightPower();
			var slot:int = ConstEquipCell.getHeroEquipSlot(memEquipData.equipCfgData.type);
			if (slot != -1)
			{
				fightPowerEquiped = getEquipPower(slot);
				fightPower -= fightPowerEquiped;
			}
			if (fightPower > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getPositionChopId():int
		{
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.slot==ConstEquipCell.HP_XUNZHANG && quipData.memEquipData)
					return quipData.memEquipData.baseId;
			}
			return 0;
		}
		
		public function getEquipCellById(id:int):Boolean
		{
			var data:EquipData
			for(var i:int = 0;i<equipDatas.length;i++)
			{
				data = equipDatas[i];
				if(data.memEquipData&&data.memEquipData.baseId == id)
					return true;
			}
			return false;
		}
		
		public function getChannelsNum():int
		{
			var heroMeridiansCfgData:HeroMeridiansCfgData;
			var xp:int = heroUpgradeData.exp;
			var count:int;
			var index:int = heroUpgradeData.meridians;
			while(xp>0)
			{
				if(index == 10)
					break;
				heroMeridiansCfgData = ConfigDataManager.instance.heroMeridiansCfgData(heroUpgradeData.grade,index+1);
				if(heroMeridiansCfgData.bi_condition == ConditionConst.CHOP)
				{
					if(getPositionChopId()<int(heroMeridiansCfgData.bi_request) || xp<heroMeridiansCfgData.cost_hero_exp)
					{
						break;
					}
				}
				else if(heroMeridiansCfgData.bi_condition==ConditionConst.EQUIP)
				{
					var split:Array = heroMeridiansCfgData.bi_equip.split("|");
					var equipId:int;
					for(var i:int = 0;i<split.length;i++)
					{
						var split2:Array = (split[i] as String).split(":");
						if(split2[3] ==job && (split2[4] == sex||split2[4] ==0))
						{
							equipId = split2[0];
						}
					}
					if(equipId == 0)
						break;
					else
					{
						var hasEquip:Boolean=getEquipCellById(equipId);
						if(!hasEquip||xp<heroMeridiansCfgData.cost_hero_exp)
						{
							break;
						}
					}
				}
				else{
					if(xp<heroMeridiansCfgData.cost_hero_exp)
					{
						break;
					}
					
				}
				count++;
				xp-=heroMeridiansCfgData.cost_hero_exp;
				index++;
			}
			return count;
		}
		
		public function getCanWearEquipNum():int
		{
			var count:int;
			if(!bagCellDatas)return 0;
			for(var i:int = 0;i<bagCellDatas.length;i++)
			{
				if(bagCellDatas[i]&&isBagFightPowerHigher(bagCellDatas[i]))
					count++;
			}
			return count;
		}
		
		public function getRings():int
		{
			for each(var data:EquipData in equipDatas)
			{
				if(data&&data.slot == ConstEquipCell.HP_HUANJIE&&data.memEquipData)
					return data.memEquipData.baseId;
			}
			return 0;
		}
		
		public function get needShowRecycleGuide():Boolean
		{
			return _needShowRecycleGuide;
		}
		
		public function set needShowRecycleGuide(value:Boolean):void
		{
			if(_needShowRecycleGuide != value)
			{
				_needShowRecycleGuide = value;
			}
		}
		
		public function isExpFull():Boolean
		{
			var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
			if(levelCfgData && exp >= levelCfgData.hero_exp*10)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		/**
		 * 加上要增加的经验，经验是否溢出
		 * @param expAdd 要增加的经验
		 * @return 
		 */	
		public function isExpOver(expAdd:int):Boolean
		{
			var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
			if(levelCfgData && levelCfgData.hero_grade > grade && exp + expAdd > levelCfgData.hero_exp)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**获取英雄身上等级超过_lv的装备的个数*/
		public function getEquipLvNum(_lv:int):int
		{
			var count:int;
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.slot>ConstEquipCell.HP_XIEZI)
					continue;
				if(quipData.memEquipData==null)
					continue;
				if(quipData.memEquipData.equipCfgData.level>=_lv)
					count++;
			}
			return count;
		}
		
		/**获取英雄身上强化等级超过_lv的装备的个数*/
		public function getEquipStrengthenLvNum(_lv:int):int
		{
			var count:int;
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.slot>ConstEquipCell.HP_XIEZI)
					continue;
				if(quipData.memEquipData==null)
					continue;
				if(quipData.memEquipData.strengthen>=_lv)
					count++;
			}
			return count;
		}
		
	}
}
class PrivateClass{}