package com.view.gameWindow.panel.panels.roleProperty
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipBaptizeSuiteCfgData;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.EquipDegreeCfgData;
    import com.model.configData.cfgdata.EquipExchangeCfgData;
    import com.model.configData.cfgdata.EquipPolishCfgData;
    import com.model.configData.cfgdata.EquipRefinedCostCfgData;
    import com.model.configData.cfgdata.EquipStrengthenSuiteCfgData;
    import com.model.configData.cfgdata.JobCfgData;
    import com.model.configData.cfgdata.LevelCfgData;
    import com.model.configData.cfgdata.WingUpgradeCfgData;
    import com.model.consts.ConstStorage;
    import com.model.consts.JobConst;
    import com.model.consts.RolePropertyConst;
    import com.model.dataManager.DataManagerBase;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.convert.ConvertDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
    import com.view.gameWindow.panel.panels.roleProperty.role.HideFactionData;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.panel.panels.thingNew.equipAlert.EquipCanWearManager;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    public class RoleDataManager extends DataManagerBase
	{
		private static var _instance:RoleDataManager;
		private static function hideFun():void{}
		public static function get instance():RoleDataManager
		{
			if(!_instance)
				_instance = new RoleDataManager(hideFun);
			return _instance;
		}
		public var oldLv:int;
		public var oldRe:int;
		public var name:String,head:int,sex:int,job:int,reincarn:int=0,lv:int=0,exp:int,lvExp:int;
		public var attrHp:int,attrMaxHp:int,attrMp:int,attrMaxMp:int,angry:int,angryMax:int;
		public var minPhscDmg:int,maxPhscDmg:int,minMgcDmg:int,maxMgcDmg:int,minTrailDmg:int,maxTrailDmg:int,minPhscDfns:int,maxPhscDfns:int,minMgcDfns:int,maxMgcDfns:int;
		public var accurate:int,agile:int,magicEvasion:int,criticalHits:int,lucky:int,curse:int,attackSpeed:int,recoveryHp:int,recoveryMp:int,weightBearing:int;
		public var speed:int,phscDmgMtgtn:int,mgcDmgMtgtn:int,mtgtnThro:int,prlzRsstc:int,synergyAttackPower:int;
		public var reputation:int;//声望
		public var heartHits:int;//会心一击
		public var hurtReflction:int;//伤害增益
		public var pkValue:int;
		
		public var equipDatas:Vector.<EquipData>;
		public var fightNum:int;
		public var oldFightNum:int;
		private var _usedCellEquipData:EquipData;
		private var _usedCellSlot:int;
		public var selectTab:int;
        public var isExpStoneState:int;
		//攻击属性
		public var txtCriticalHitsHurt:int,txtParalysis:int,txtBloodPercent:int,txtBloodLev:int,txtDevilPercent:int,txtDevilLev:int;
		public var txtSkiller:int,txtBeastSkiller:int,txtGhostSkiller:int,txtDevilSkiller:int,txtYiSheng:int;
		//防御属性
		public var txtSacred:int,txtTenacity:int,txtHeartAside:int,txtMagicAside:int;
		public var txtReflctionPercent:int,txtReflctionLev:int,txtDefencePercent:int,txtDefence:int,txtDefenceLuck:int;
		//回复属性
		public var txtLifeReplay:int,txtMagicReplay:int,txtPoisonReplay:int,txtParalysisReplay:int,txtDrugReplay:int,txtRevive:int;
		public var txtSkillBloodReplay:int,txtSkillBlue:int;
		//其他属性
		public var txtSkillMonstersMoney:int,txtSkillMonstersExp:int,txtGetTreasurePercent:int;
		
		public var gainRate:int,captureSkillRate:int,angerRecoverSpeed:int,damageLower:int,damageUpper:int,damageFromHeroRateDown:int,damageToWarriorRateUp:int,damageFromWarriorRateDown:int,
				   damageToMagicRateUp:int,damageFromMagicRateDown:int,damageToWizardRateUp:int,damageFromWizardRateDown:int,damageToMonsterRateUp:int,
				   damageFromMonsterRateDown:int,damageToBossRateUp:int,damageFromBossRateDown:int;
		//属性池
		public var attrPool:Dictionary;
		
		public var recGoldCount:int;
		public var loginCount:int;
		public var isCanFly:int;
		
		public var position:int;
		public var baseId:int;
		public var merit:int;
		public var stallStatue:int;//人物的摆摊状态
		public var shendunzhili:int;
		/**跳至的怒气值*/
		public var hideFactionData:HideFactionData;
		public var jumpAngry:int;
		public static const HLZX:int = 0;
		public static const HUANJIE:int = 2;
		public static const DUNPAI:int = 1;
		
		public function RoleDataManager(fun:Function)
		{
			super();
			if(fun != hideFun)
				throw new Error("该类使用单例模式");
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHR_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ANGRY_CHANGE,this);
			
			attrPool = new Dictionary();
			equipDatas = new Vector.<EquipData>();
			hideFactionData = new HideFactionData();
			_usedCellSlot = -1;
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_ANGRY_CHANGE:
					dealSmAngryChange(data);
					break;
				case GameServiceConstants.SM_CHR_INFO:
					readData(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
            EquipCanWearManager.instance.update(proc);
		}
		
		private function dealSmAngryChange(data:ByteArray):void
		{
			jumpAngry = data.readInt();//怒气值
		}
		
		public var isEquipInited:Boolean = false;
		
		private function readData(data:ByteArray):void
		{
			var i:int,l:int;
			var isHide:int;
			l = ConstEquipCell.CP_TOTAL;
			equipDatas.length = 0;
			oldFightNum = fightNum;
			for(i=0;i<l;i++)
			{
				var equipData:EquipData = new EquipData();
				equipData.id = data.readInt();
				equipData.bornSid = data.readInt();
				equipData.slot = i;
				equipData.storageType = ConstStorage.ST_CHR_EQUIP;
				equipDatas.push(equipData);
			}
			isEquipInited = true;
			name = data.readUTF();
			head = data.readByte();
			sex = data.readByte();
			job = data.readByte();
			oldRe = reincarn;
			reincarn = data.readByte();
			oldLv = lv;
			lv = data.readShort();
			doLvUP(oldLv,lv,oldRe,reincarn);
			position = data.readInt();//角色的官位
			baseId = data.readInt();//角色官印的baseid
			merit = data.readInt();//功勋值
			stallStatue = data.readByte();//摆摊状态
			EntityLayerManager.getInstance().refreshStaticNpcTaskEffect();
            isExpStoneState = data.readByte();//是否是经验玉使用状态
			exp = data.readInt();
			reputation = data.readInt();//声望
			shendunzhili = data.readInt();//神盾之力
			
			pkValue = data.readInt();
			fightNum = data.readInt();//战斗力
			isHide = data.readInt();//时装隐藏状态
			hideFactionData.setData(isHide);
			//
			attrHp = data.readInt();
			attrMaxHp = data.readInt();
			attrMp = data.readInt();
			attrMaxMp = data.readInt();
			angry = data.readShort();//怒气
			angryMax = 1000;
			getLastAttack();
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
			magicEvasion = data.readShort();//魔法闪避
			criticalHits = data.readShort();//暴击
			txtCriticalHitsHurt = data.readInt();//暴击伤害
			txtTenacity = data.readShort();//韧性
			heartHits = data.readShort();//会心一击
			txtHeartAside = data.readShort();//会心闪避
			lucky = data.readShort();//幸运
			txtDefenceLuck = data.readShort();//抵抗幸运
			curse = data.readShort();//诅咒
			txtSacred = data.readShort();//神圣
			attackSpeed = data.readShort();//攻击速度
			recoveryHp = data.readShort();//回血速度
			recoveryMp = data.readShort();//回蓝速度
			txtPoisonReplay = data.readShort();//中毒回复
			weightBearing = data.readShort();//负重
			speed = data.readShort();//速度
			phscDmgMtgtn = data.readShort();//物理免伤
			mgcDmgMtgtn = data.readShort();//魔法免伤
			mtgtnThro = data.readShort();//免伤穿透
			hurtReflction = data.readShort();//伤害增益
			txtParalysis = data.readShort();//麻痹几率
			prlzRsstc = data.readShort();//抗麻痹几率
			txtParalysisReplay = data.readShort();//麻痹回复
			synergyAttackPower = data.readShort();//合击威力
			txtReflctionPercent = data.readShort();//反射
			txtReflctionLev = data.readShort();//反射率
			txtDefencePercent = data.readShort();//格挡
			txtDefence = data.readInt();//格挡值
			txtBloodPercent = data.readShort();//吸血几率
			txtBloodLev = data.readShort();//吸血比例
			txtDevilPercent = data.readShort();//吸魔几率
			txtDevilLev = data.readShort();//吸魔比例
			txtSkillBloodReplay = data.readInt();//击杀回血
			txtSkillBlue = data.readInt();//击杀回蓝
			txtDrugReplay = data.readShort();//药效增益
			txtRevive = data.readShort();//复活增益
			txtYiSheng = data.readShort();//抑生
			txtSkiller = data.readShort();//人形怪杀手
			txtBeastSkiller = data.readShort();//野兽杀手
			txtGhostSkiller = data.readShort();//亡灵杀手
			txtDevilSkiller = data.readShort();//恶魔杀手
			txtGetTreasurePercent = data.readShort();//打宝几率
			gainRate = data.readShort();// 探测宝物几率
			captureSkillRate = data.readShort();// 吸取技力几率
			txtSkillMonstersMoney=data.readShort();// 杀怪金钱
			txtSkillMonstersExp=data.readShort();// 杀怪经验
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
			
			recGoldCount = data.readInt();//充值元宝数
			loginCount = data.readShort();//登录天数
			isCanFly = data.readShort();//飞鞋   0 为不能 fly
			/*trace("RoleDataManager.readData(data) angry:"+angry+",time:"+getTimer());*/
			refreshAttrPool();
			
			BagDataManager.instance.checkRecycleNum();
			BagDataManager.instance.checkRecycleNum(false);
		}
		
		private function getLastAttack():void
		{
			// TODO Auto Generated method stub
			if(job == JobConst.TYPE_ZS)
				oldFightNum = maxPhscDmg;
			else if(job == JobConst.TYPE_FS)
				oldFightNum = maxMgcDmg;
			else if(job == JobConst.TYPE_DS)
				oldFightNum = maxTrailDmg;
		}
		
//		//任务用 用完会马上清状态
//		public var isLvChange:Boolean = false;
		
		private function doLvUP(oldLv:int, lv:int, oldRe:int,reincarn:int):void
		{
			if(oldLv == 0 && lv != 1)
			{
				if(reincarn == 0)
				{
					GuideSystem.instance.updateLevelState(EntityTypes.ET_PLAYER,lv,reincarn,false);
				}
			}
			else if(oldLv < lv)
			{
				if(reincarn == 0) //暂时不判断转生后的引导
				{
					for(var i:int = oldLv + 1;i <= lv; ++i)
					{
						GuideSystem.instance.updateLevelState(EntityTypes.ET_PLAYER,i,reincarn,true);
					}
				}
				
//				isLvChange = true;
			}
			if(oldLv != lv)
			{
				TaskDataManager.instance.refreshOnDoingTasks(false);
				TaskDataManager.instance.refreshCanReceiveTask();
				TaskDataManager.instance.refreshVirtualTasks();
			}
		}
		/**刷新属性池*/
		private function refreshAttrPool():void
		{
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
			attrPool[RolePropertyConst.ROLE_PROPERTY_CRIT_HURT_ID] = txtCriticalHitsHurt;//暴击伤害
			attrPool[RolePropertyConst.ROLE_PROPERTY_RESILIENCE_ID] = txtTenacity;//韧性
			attrPool[RolePropertyConst.ROLE_PROPERTY_HEART_HURT_ID] = heartHits;//会心一击
			attrPool[RolePropertyConst.ROLE_PROPERTY_HEART_EVASION_ID] = txtHeartAside;//会心闪避
			attrPool[RolePropertyConst.ROLE_PROPERTY_LUCKY_ID] = lucky;//幸运
			attrPool[RolePropertyConst.ROLE_PROPERTY_ANTI_LUCKY_ID] = txtDefenceLuck;//抵抗幸运;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMNATION_ID] = curse;//诅咒;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HOLY_ID] = txtSacred;//神圣;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ATTACK_SPEED_ID] = attackSpeed;//攻击速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_BLOOD_RETURN_ID] = recoveryHp;//回血速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_RETURN_ID] = recoveryMp;//回蓝速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ANTI_POISON_ID] = txtPoisonReplay;//中毒回复;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HEAVY_ID] = weightBearing;//负重;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MOVE_SPEED_ID] = speed;//速度;
			attrPool[RolePropertyConst.ROLE_PROPERTY_WU_LI_MIAN_SHANG_ID] = phscDmgMtgtn;//物理免伤;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MO_FA_MIAN_SHANG_ID] = mgcDmgMtgtn;//魔法免伤;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MIAN_SHANG_CHUAN_TOU_ID] = mtgtnThro;//免伤穿透;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DAMAGE_UP] = hurtReflction;//伤害增益;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MA_BI_RATE_ID] = txtParalysis;//麻痹几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MA_BI_KANG_XING_ID] = prlzRsstc;//抗麻痹几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MA_BI_RECOVER] = txtParalysisReplay;//麻痹回复;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HE_JI_WEI_LI_ID] = synergyAttackPower;//合击威力;
			attrPool[RolePropertyConst.ROLE_PROPERTY_REFLECT_ID] = txtReflctionPercent;//反射;
			attrPool[RolePropertyConst.ROLE_PROPERTY_REFLECT_RATE_ID] = txtReflctionLev;//反射率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_PARRY_ID] = txtDefencePercent;//格挡;
			attrPool[RolePropertyConst.ROLE_PROPERTY_PARRY_VALUE_ID] = txtDefence;//格挡值;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HP_DRAIN_ID] = txtBloodPercent;//吸血几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HP_DRAIN_RATE_ID] = txtBloodLev;//吸血比例;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MP_DRAIN_ID] = txtDevilPercent;//吸魔几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_MP_DRAIN_RATE_ID] = txtDevilLev;//吸魔比例;
			attrPool[RolePropertyConst.ROLE_PROPERTY_KILL_HP_RECOVER_ID] = txtSkillBloodReplay;//击杀回血;
			attrPool[RolePropertyConst.ROLE_PROPERTY_KILL_MP_RECOVER_ID] = txtSkillBlue;//击杀回蓝;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DRUG_INTENSIFY_ID] = txtDrugReplay;//药效增益;
			attrPool[RolePropertyConst.ROLE_PROPERTY_REVIVE_HP_UP] = txtRevive;//复活增益;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ANTI_HP_RECOVER_ID] = txtYiSheng;//抑生;
			attrPool[RolePropertyConst.ROLE_PROPERTY_HUMANOID_KILLER_ID] = txtSkiller;//人形怪杀手;
			attrPool[RolePropertyConst.ROLE_PROPERTY_BEAST_KILLER_ID] = txtBeastSkiller;//野兽杀手;
			attrPool[RolePropertyConst.ROLE_PROPERTY_GHOST_KILLER_ID] = txtGhostSkiller;//亡灵杀手;
			attrPool[RolePropertyConst.ROLE_PROPERTY_DEVIL_KILLER_ID] = txtDevilSkiller;//恶魔杀手;
			attrPool[RolePropertyConst.ROLE_PROPERTY_ITEM_RROP_RATE_ID] = txtGetTreasurePercent;//打宝几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_GAIN_RATE_ID] = gainRate;// 探测宝物几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_CAPTURE_SKILL_RATE] = captureSkillRate;// 吸取技力几率;
			attrPool[RolePropertyConst.ROLE_PROPERTY_KILL_MONSTER_MONEY_ID] = txtSkillMonstersMoney;// 杀怪金钱;
			attrPool[RolePropertyConst.ROLE_PROPERTY_KILL_MONSTER_EXPERIENCE_ID] = txtSkillMonstersExp;// 杀怪经验;
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
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAX_INTERNAL_FORCE_ID] = 0;//内力上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_INTERNAL_FORCE_RECOVER_ID] = 0;//内力上限
			attrPool[RolePropertyConst.ROLE_PROPERTY_INTERNAL_FORCE_AVOIDENCE_ID] = 0;//内力免伤
			attrPool[RolePropertyConst.ROLE_PROPERTY_HP_ID] = attrHp;//生命值
			attrPool[RolePropertyConst.ROLE_PROPERTY_MAGIC_ID] = attrMp;//魔法值
			attrPool[RolePropertyConst.ROLE_PROPERTY_NU_QI_ID] = angry;//魔法值
			attrPool[RolePropertyConst.ROLE_INTERNAL_FORCE_ID] = 0;//内力值
			attrPool[RolePropertyConst.ROLE_INTERNAL_PKVALUE_ID] = pkValue;
		}
		
		public function getRoleMaxAttack():int
		{
			// TODO Auto Generated method stub
			if(job == JobConst.TYPE_ZS)
				return maxPhscDmg;
			else if(job == JobConst.TYPE_FS)
				return maxMgcDmg;
			else if(job == JobConst.TYPE_DS)
				return maxTrailDmg;
			return 0;
		}
		
		/**判断转生、等级是否满足*/
		public function checkReincarnLevel(reincarnValue:int,levelValue:int):Boolean
		{
			var boolean:Boolean = reincarn > reincarnValue || (reincarn == reincarnValue && lv >= levelValue) as Boolean;
			return boolean;
		}
		
		public function equiped(onlyId:int, bornSid:int):Boolean
		{
			for (var i:int = 0; i < equipDatas.length; ++i)
			{
				var equipData:EquipData = equipDatas[i];
				if (equipData.id == onlyId && equipData.bornSid == bornSid)
				{
					return true;
				}
			}
			return false;
		}

        /*
         * ConstEquipCell
         * */
        public function getEquipCountByType(type:int):int
        {
            var count:int = 0;
            for (var i:int = 0; i < equipDatas.length; ++i)
            {
                var equipData:EquipData = equipDatas[i];
                if (equipData.memEquipData)
                {
                    if (equipData.memEquipData.equipCfgData)
                    {
                        if (equipData.memEquipData.equipCfgData.type == type)
                        {
                            count++;
                        }
                    }
                }
            }
            return count;
        }

		public function getEquipCellDataById(id:int):EquipData
		{
			for each(var equipCellData:EquipData in equipDatas)
			{
				if (equipCellData&&equipCellData.memEquipData && equipCellData.memEquipData.baseId == id)
				{
					return equipCellData;
				}
			}
			return null;
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
		
		public function getAndUsedCellEquipData():EquipData
		{
			var data:EquipData = _usedCellEquipData;
			_usedCellEquipData = null;
			return data;
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
		/**公共CD时间（毫秒）*/
		public function get pulbicCoolDown():int
		{
			var cfgDt:JobCfgData = ConfigDataManager.instance.jobCfgDatasById(job);
			return (!cfgDt ? 800 : cfgDt.public_cd)-attackSpeed*.01;
		}
		
		public var lastSkillTime:int;
		public static const MAX_STRENGTHEN_LEVEL:Number=51;
		public static const MAX_BAPTIZE_LEVEL:Number=20;
		
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
            var array:Array = [];
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
		 *获取装备的最小强化等级 
		 * */
		public function getStrengthenMinLevel():Number
		{
			var strengs:Array=[];
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.slot>ConstEquipCell.CP_XIEZI)
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
					var isUnsatisfySP1:Boolean = isUnsatisfySP(filter, lvStrength, lvPolish, memEquipData);
					if (isUnsatisfySP1)
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
		/**强化/打磨属性条件不满足*/
		private function isUnsatisfySP(filter:int,lvStrength:int,lvPolish:int,memEquipData:MemEquipData):Boolean
		{
			var boolean:Boolean = filter == 1 || filter == 2;
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
		
		
		
		/**
		 * 根据格子获取对应装备的战斗力，空格子战斗力为0
		 * @param slot
		 * @return 
		 */		
		public function getEquipPower(slot:int):Number
		{
			var equipData:EquipData = equipDatas.length > slot ? equipDatas[slot] : null;
			if(equipData && equipData.id && equipData.bornSid)
			{
				var fightPowerEquiped:Number = 0;
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid,equipData.id);
				if(!memEquipData)
				{
					return 0;
				}
				memEquipData.isHero = false;
				return memEquipData.getTotalFightPower();
			}
			return 0;
		}

        /**根据身上的部分获取装备数据*/
        public function getEquipCfgBySlot(slot:int):EquipCfgData
        {
            var equipData:EquipData = equipDatas.length > slot ? equipDatas[slot] : null;
            if (equipData && equipData.memEquipData && equipData.memEquipData.equipCfgData)
            {
                return equipData.memEquipData.equipCfgData;
            }
            return null;
        }
		public function getAttrValueByType(type:int):int
		{
			var value:int = attrPool[type];
			return value;
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
		
		public function isSameLv(re:int,lv:int):Boolean
		{
			return re == reincarn && lv == this.lv;
		}
		
		public function sendHideFactionData(value:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(value);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SETTING_CHEST_STATE,byteArray);
		}
		
		public function canDoRingUp():int
		{
			var count:int;
			var id1:int = getFireHeartId(HLZX);
			var id2:int = getFireHeartId(DUNPAI);
			var id3:int = getFireHeartId(HUANJIE);
			if(id1!=0)
			{
				count+=ConvertDataManager.instance.canConvertNewNum(id1,HLZX);
			}
			if(id2!=0)
			{
				count+=ConvertDataManager.instance.canConvertNewNum(id2,DUNPAI);
			}
			if(id3!=0)
			{
				count+=ConvertDataManager.instance.canConvertNewNum(id3,HUANJIE);
			}
			return count;
		}
		
		public function getRingUpNum(type:int):int
		{
			var id:int = getFireHeartId(type);
			return ConvertDataManager.instance.canConvertNewNum(id,type);
		}
		
		
		public function getFireHeartId(type:int = 0):int
		{
			for each(var quipData:EquipData in equipDatas)
			{
				if(type == HLZX&&quipData.slot==ConstEquipCell.CP_HUOLONGZHIXIN&&quipData.memEquipData)
					return quipData.memEquipData.baseId;
				else if(type == HUANJIE&&quipData.slot==ConstEquipCell.CP_HUANJIE&&quipData.memEquipData)
					return quipData.memEquipData.baseId;
				else if(type == DUNPAI&&quipData.slot==ConstEquipCell.CP_DUNPAI&&quipData.memEquipData)
					return quipData.memEquipData.baseId;
			}
			
			return BagDataManager.instance.getEquipExchangeData(type);
		}
		
		public function getPositionChopId():int
		{
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.memEquipData&&quipData.slot==ConstEquipCell.CP_XUNZHANG)
					return quipData.memEquipData.baseId;
			}
			return 0;
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
			
		public function isExpFull():Boolean
		{
			var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
			if(levelCfgData && exp >= levelCfgData.player_exp)
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
			if(levelCfgData && levelCfgData.player_reincarn > reincarn && exp + expAdd > levelCfgData.player_exp)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**获取身上等级超过_lv的装备的个数*/
		public function getEquipLvNum(_lv:int):int
		{
			var count:int;
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.slot>ConstEquipCell.CP_XIEZI)
					continue;
				if(quipData.memEquipData==null)
					continue;
				if(quipData.memEquipData.equipCfgData.level>=_lv)
					count++;
			}
			return count;
		}
		
		/**获取身上强化等级超过_lv的装备的个数*/
		public function getEquipStrengthenLvNum(_lv:int):int
		{
			var count:int;
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.slot>ConstEquipCell.CP_XIEZI)
					continue;
				if(quipData.memEquipData==null)
					continue;
				if(quipData.memEquipData.strengthen>=_lv)
					count++;
			}
			return count;
		}
		
		/**获取身上等阶等级超过step level的盾牌的个数*/
		public function getDunpaiNum(step:int,level:int):int
		{
			var id:int = getFireHeartId(DUNPAI);
			var cfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
			if(cfg){
				if(cfg.step>step||(cfg.step==step&&cfg.current_star>=level))
					return 1;
			}
			return 0;
		}
		
		/**获取身上等阶等级超过step level的HLZX的个数*/
		public function getHlzxNum(step:int,level:int):int
		{
			var id:int = getFireHeartId(HLZX);
			var cfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
			if(cfg)
			{
				if(cfg.step>step||(cfg.step==step&&cfg.current_star>=level))
					return 1;
			}
			return 0;
		}
		
		/**获取身上官印掌握等级超过level的装备个数*/
		public function getChopLvNum(level:int):int
		{
			for each(var quipData:EquipData in equipDatas)
			{
				if(quipData.memEquipData&&quipData.slot==ConstEquipCell.CP_XUNZHANG)
				{
					if(quipData.memEquipData.strengthen>=level)
						return 1;
				}
			}
			return 0;	
		}
		
		/**获取身上翅膀等阶*/
		public function getWingLvNum():int
		{
			var bodyPart:int = ConstEquipCell.getRoleEquipSlot(ConstEquipCell.TYPE_CHIBANG);
			var equipCfg:EquipCfgData = getEquipCfgBySlot(bodyPart);
			var cfg:WingUpgradeCfgData = ConfigDataManager.instance.wingUpgradeCfg(equipCfg.id);
			return cfg.upgrade;
		}
		
		/**判断转生和等级是达到条件*/
		public function isReinLvUp(r:int,l:int):int
		{
			if(reincarn>r||(reincarn == r&& lv>=l))
				return 1;
			return 0;
		}
	}
}