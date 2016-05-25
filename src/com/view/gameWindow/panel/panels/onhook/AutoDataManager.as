package com.view.gameWindow.panel.panels.onhook
{
	import com.core.getDictElement;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.ItemGiftCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.configData.constants.ConfigType;
	import com.model.consts.JobConst;
	import com.model.consts.MapConst;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.pattern.Observer.IObserverEx;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.ConfigAuto;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillData;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.scene.GameSceneManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.skillDeal.SkillDealManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	
	/**
	 * @author wqhk
	 * 2014-10-13
	 */
	public class AutoDataManager extends DataManagerBase implements IObserverEx
	{
		public static const EVENT_UPDATE_ONE_TARGET_SKILL:int = -1;
		public static const EVENT_UPDATE_MULTI_TARGET_SKILL:int = -2;
		public static const EVENT_UPDATE_AUTO_SKILL:int = -3;
		public static const EVENT_UPDATE_WITHOUT_SHIFT:int = -4;
		
		public static const EVENT_UPDATE_AUTO_SKILL_CHANGE:int = -5;
		
		public static const EVENT_UPDATE_MAGIC_LOCK:int = -6;
		
		/** 定点 */
		public static const RANGE_ANCHOR:int = 0;
		/** 当前屏  */
		public static const RANGE_SCREEN:int = 1;
		/** 全地图  */
		public static const RANGE_FULL_MAP:int = 2;
		
		private static var _instance:AutoDataManager;
		public static function get instance():AutoDataManager
		{
			if(!_instance)
			{
				_instance = new AutoDataManager();
			}
			
			return _instance;
		}
		
		public function clearInstance():void
		{
			oneTargetSkillIndex = -1;
			multiTargetSkillIndex = -1;
			isReady = false;
		}
		
		/** 定点 当前屏 全屏 */
		public var rangeType:int = 2;//
		
		//挂机中 单体
		public var oneTargetSkillList:Array=[];
		//挂机中 群体
		public var multiTargetSkillList:Array=[];
		
		private var _oneTargetSkillIndex:int = -1;
		private var _multiTargetSkillIndex:int = -1;
//		private var _magicLocking:int = -1;
		public var isMagicLocking:Boolean = true;
		
		//是否拾取金币
		public var isPickUpCoin:Boolean = true;
		
		public var isPickUpDrug:Boolean = true;
		//拾取药物等级
		public var pickUpDrugLv:int = 0;
		public var isPickUpMaterial:Boolean = true;
		//other
		public var isPickUpOther:Boolean = true;
		//equip
		public var isPickUpEquip:Boolean = true;
		public var pickUpEquipLv:int = 0;
		public var pickUpEquipQuality:int = 0;
		public var pickUpEquipQualityName:String = "";
		
		public var isCAttack:Boolean = false;//反击
		
		public var isRepair:Boolean = false;
		//药品耗尽后回城
		public var isTP:Boolean = false;
		//
		public var isRevive:Boolean = true;
		//挂一段时间回城
		public var isTime:Boolean = false;
		public var timeMin:int = 0;
		public var timeName:String = "";
		
		
		//----------------------
		
		public var quickSet:Array = ["",""];
		public var quickSetState:Array = [0,0];
		
		//可以自动释放的技能
		public var autoSkillList:Array=[0,0,0,0];
		public var autoSkillState:Array=[0,0,0,0];
		public static const DS_SKILL_UP:int = 3071;
		
		public var hpCfg:DrugCfg;
		public var hpXCfg:DrugCfg;
		public var mpCfg:DrugCfg;
		public var mpXCfg:DrugCfg;
		//血量低回城
		public var isHPTP:Boolean = false;
		public var hpTPPercent:Number = 10; //note:未保存！！！
		
		public var isRepairOil:Boolean = false;
		public var repairOilPercent:Number = 0;
		
		private var _job:int = -1;
		private var _skillInited:Boolean = false;
		
		/**是否免shift*/
		public var isWithoutShift:Boolean = true;
		
		public var isReady:Boolean = false;
		
		private var _tmpServerCfg:ByteArray;
		
		private var _autoUseGiftList:Array;
		
		//key:ItemCfgData.type  data:ItemCfgData.id
		private var _autoUseGiftDict:Dictionary;
		
		public function getAutoUseGift():Array
		{
			initAutoUseGiftList();
			return _autoUseGiftList;
		}
		
		public function getAutoUseGiftByType(type:int):Array
		{
			initAutoUseGiftList();
			
			return _autoUseGiftDict[type];
		}
		
		public function initAutoUseGiftList():void
		{
			if(!_autoUseGiftList)
			{
				_autoUseGiftList = [];
				_autoUseGiftDict = new Dictionary();
				ConfigDataManager.instance.forEach([ConfigType.KeyItemGift],filterAutoGifts);
			}
		}
		
		/**
		 * 注意只取礼包中的第一个判断
		 */
		private function filterAutoGifts(dict:Dictionary):void
		{
			var cfg:ItemGiftCfgData = getDictElement(dict);
			
			if(cfg && cfg.type == SlotType.IT_ITEM)
			{
				var item:ItemCfgData = ConfigDataManager.instance.itemCfgData(cfg.item_id);
				if(item && isDrugItem(item.type))
				{
					_autoUseGiftList.push(cfg.id);
					
					if(!_autoUseGiftDict[item.type])
					{
						_autoUseGiftDict[item.type] = [];
					}
					
					_autoUseGiftDict[item.type].push(cfg.id);
				}
			}
		}
		
		public function isDrugItem(type:int):Boolean
		{
//			if(type == ItemType.INTERVAL_HP_DRUG || type == ItemType.INTERVAL_MP_DRUG ||
//				type == ItemType.NSTANTANEOUS_HP_DRUG || type == ItemType.NSTANTANEOUS_MP_DRUG ||
//				type == ItemType.NSTANTANEOUS_HP_AND_MP_DRUG)
//			{
//				return true;
//			}
//			
//			return false;
			
			return BagDataManager.isDrugItem(type);
		}
		
		/**
		 * 只有在选择了英雄后才能取到技能
		 */
		public function get jointAttakSkill():SkillCfgData
		{
			return HejiSkillDataManager.instance.cfgDtHeji;
		}
		
		public function learn(id:int):void
		{
			var index:int = -1;
			if(oneTargetSkillIndex == -1)
			{
				index = oneTargetSkillList.indexOf(id);
				if(index != -1)
				{
					oneTargetSkillIndex = index;
					sendCfg();
					return;
				}
			}
			
			if(multiTargetSkillIndex == -1)
			{
				index = multiTargetSkillList.indexOf(id);
				
				if(index != -1)
				{
					multiTargetSkillIndex = index;
					sendCfg();
					return;
				}
			}
			
			//新加 道士替换召唤技能
			if(_job == JobConst.TYPE_DS)
			{
//				if(upgradeDsSkill())//收到学习技能的消息时 skilldatamanger中的技能还未变化……
				if(id == DS_SKILL_UP)
				{
					autoSkillList[2] = DS_SKILL_UP;
					notify(EVENT_UPDATE_AUTO_SKILL_CHANGE);
				}
			}
			
			if(checkJointSkill())
			{
				return;//默认不勾选该技能
			}
			
			index = autoSkillList.indexOf(id);
			
			if(index != -1)
			{
				autoSkillState[index] = 1;
				updateAutoSkillState();
				sendCfg();
				return;
			}
		}
		
		private var lastJointSkill:SkillCfgData = null;
		
		/**
		 * @return 是否发生改变 1 增加 -1去掉 0没改变
		 */
		public function checkJointSkill():int
		{
			var skill:SkillCfgData = jointAttakSkill;
			var code:int = 0;
			
			if(skill != lastJointSkill)
			{
				if(skill)
				{
					pushAutoSkill(skill.id);
					code = 1;
				}
				else if(lastJointSkill)
				{
					var index:int = removeAutoSkill(lastJointSkill.id);
					if(index != -1)
					{
						autoSkillState[index] = 0;
					}
					code = -1;
				}
				
				lastJointSkill = skill;
				notify(EVENT_UPDATE_AUTO_SKILL_CHANGE);
				return code;
			}
			
			return code;
		}
			
		public function removeAutoSkill(skillId:int):int
		{
			for(var i:int = 0; i < autoSkillList.length; ++i)
			{
				var id:int = autoSkillList[i];
				
				if(id == skillId)
				{
					return autoSkillList.splice(i,1);
				}
			}
			
			return -1;
		}
		
		/**
		 * @return index -1表示失败
		 */ 
		public function pushAutoSkill(skillId:int):int
		{
			if(!skillId)
			{
				return -1;
			}
			
			for(var i:int = 0; i < autoSkillList.length; ++i)
			{
				var id:int = autoSkillList[i];
				
				if(id == skillId)
				{
					return -1;
				}
				
				if(id == 0)
				{
					autoSkillList[i] = skillId;
					return i;
				}
			}
			
			return -1;
		}
		
		public function updateAutoSkillState():void
		{
			notify(EVENT_UPDATE_AUTO_SKILL);
		}
		
		public function get battlefieldRadius():int
		{
			if(rangeType == RANGE_FULL_MAP)
			{
				return int.MAX_VALUE/2;
			}
			else
			{
				return ConfigAuto.FIGHT_RADIUS;
			}
		}
		
		public function get isAnchorRange():Boolean
		{
			return rangeType == RANGE_ANCHOR;
		}
		
		public function get isFullMapRange():Boolean
		{
			return rangeType == RANGE_FULL_MAP;
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(proc == GameServiceConstants.SM_HANG_UP_SETING_INFO)
			{
				_tmpServerCfg = data;
				checkReadCfg();
			}
		}
		
		private function checkReadCfg():void
		{
			if(_job != -1 && _tmpServerCfg && _skillInited)
			{
				if(_job == JobConst.TYPE_ZS)
				{
					oneTargetSkillList = [1011,0];
					multiTargetSkillList = [1041,0,0];
					
					autoSkillList = [1051,1071,0,0];
					autoSkillState = [0,0,0,0];
					
					quickSet = [StringConst.AUTO_ASSIST_ZS_0001,StringConst.AUTO_ASSIST_ZS_0002];
					quickSetState = [0,0];
				}
				else if(_job == JobConst.TYPE_FS)
				{
					oneTargetSkillList = [2011,2041];
					multiTargetSkillList = [2051,0,0];
					//2021
					autoSkillList = [2021,2071,0,0];
					autoSkillState = [0,0,0,0];
					
					quickSet = [StringConst.AUTO_ASSIST_FS_DS,""];
					quickSetState = [isMagicLocking ? 1 : 0,0];
				}
				else if(_job == JobConst.TYPE_DS)
				{
					oneTargetSkillList = [3011,0];
					multiTargetSkillList = [0,0,0];
					
					autoSkillList = [3021,3031,3051,0];
					upgradeDsSkill();
					autoSkillState = [0,0,0,0];
					
					quickSet = [StringConst.AUTO_ASSIST_FS_DS,""];
					quickSetState = [isMagicLocking ? 1 : 0,0];
				}
				
				checkJointSkill();
				
				readCfg(_tmpServerCfg);
				_tmpServerCfg.clear();
				_tmpServerCfg = null;
			}
		}
		
		
		private function upgradeDsSkill():Boolean
		{
			if(isLearnSkill(DS_SKILL_UP))
			{
				autoSkillList[2] = DS_SKILL_UP;
				return true;
			}
			
			return false;
		}
		
		
		public function update(proc:int = 0):void
		{
			if(proc == GameServiceConstants.SM_CHR_INFO)
			{
				setJob(RoleDataManager.instance.job);
				checkReadCfg();
				notify(proc);
			}
			else if(proc == GameServiceConstants.SM_SKILL_LIST)
			{
				_skillInited = true;
				checkReadCfg();
			}
			else if(proc == GameServiceConstants.SM_ENTER_MAP)
			{
				AutoSystem.instance.stopCheckFight();
				if(AxFuncs.getCurMapId() == MapConst.EMOGUANGCHANG)
				{
					AutoSystem.instance.startCheckFight();
				}
				else if(MapConst.AUTO_DGN_IDS.indexOf(AxFuncs.getCurMapId())!=-1)
				{
					AutoSystem.instance.startCheckFight();
				}
			}
		}
		
		
		
		public function sendCfg():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			
			//
			data.writeByte(oneTargetSkillIndex);
			data.writeByte(multiTargetSkillIndex);
			data.writeByte(isTP ? 1 : 0);
			data.writeByte(isRepair ? 1 : 0);
			data.writeByte(isRevive ? 1 : 0);
			data.writeByte(isTime ? 1 : 0);
			data.writeInt(timeMin);
			
			data.writeByte(isPickUpDrug ? 1 : 0);
			data.writeInt(pickUpDrugLv);
			data.writeByte(isPickUpCoin ? 1 : 0);
			data.writeByte(isPickUpMaterial ? 1 : 0);
			data.writeByte(isPickUpOther ? 1 : 0);
			data.writeByte(isPickUpEquip ? 1 : 0);
			data.writeInt(pickUpEquipLv);
			data.writeByte(pickUpEquipQuality);
			
			//
			for each(var state:int in autoSkillState)
			{
				data.writeByte(state);
			}
			hpCfg.toSerialize(data);
			hpXCfg.toSerialize(data);
			mpCfg.toSerialize(data);
			mpXCfg.toSerialize(data);
			
			//
			data.writeByte(isWithoutShift ? 1: 0);
			
			data.writeByte(isHPTP ? 1 : 0);
			data.writeByte(hpTPPercent);
			data.writeByte(isRepairOil ? 1 : 0);
			data.writeByte(repairOilPercent);
			data.writeByte(isCAttack ? 1 : 0);
			
			data.writeByte(isMagicLocking ? 1 : 0);
			
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_UPDATE_HANG_UP_SETING,data);
		}
		
		
		public function initMagicLock():void
		{
			
		}
		
		public function readCfg(data:ByteArray):void
		{
			//
			var isSet:int = data.readByte();
			
			if(isSet == 0)
			{
				//采用默认设置
				initDrugCfg();
				
				repairWrongData();
				sendCfg();
				isReady = true;
				return;
			}
			
			var isNeedUpdate:Boolean = false;
			
			oneTargetSkillIndex = data.readByte();
			multiTargetSkillIndex = data.readByte();
			isTP = Boolean(data.readByte());
			isRepair = Boolean(data.readByte());
			isRevive = Boolean(data.readByte());
			isTime = Boolean(data.readByte());
			timeMin = data.readInt();
			
			isPickUpDrug = Boolean(data.readByte());
			pickUpDrugLv = data.readInt();
			
			isPickUpCoin = Boolean(data.readByte());
			isPickUpMaterial = Boolean(data.readByte());
			isPickUpOther = Boolean(data.readByte());
			isPickUpEquip = Boolean(data.readByte());
			
			pickUpEquipLv = data.readInt();
			pickUpEquipQuality = data.readByte();
			
			//
			for(var i:int = 0; i < autoSkillState.length; ++i)
			{
				autoSkillState[i] = data.readByte();
			}
			
			initDrugCfg();
			hpCfg.deserialize(data);
			hpXCfg.deserialize(data);
			mpCfg.deserialize(data);
			mpXCfg.deserialize(data);
			
			setIsWithoutShift(Boolean(data.readByte()));
			
			isHPTP = Boolean(data.readByte());
			hpTPPercent = data.readByte();
			isRepairOil = Boolean(data.readByte());
			repairOilPercent = data.readByte();
			isCAttack = Boolean(data.readByte());
			setIsMagicLocking(Boolean(data.readByte()));
			
			if(repairWrongData())
			{
				sendCfg();
			}
			
			isReady = true;
		}
		
		private function repairWrongData():Boolean
		{
			var isNeedUpdate:Boolean = false;
			
			var timeIndex:int = ConfigAuto.TIMES.indexOf(timeMin);
			if(timeIndex == -1)
			{
				timeIndex = 0;
				timeMin = ConfigAuto.TIMES[timeIndex];
				isNeedUpdate = true;
			}
			timeName = ConfigAuto.TIME_MENU[timeIndex];
			
			if(ConfigAuto.DRUG_LVS.indexOf(pickUpDrugLv) == -1)
			{
				pickUpDrugLv = ConfigAuto.DRUG_LVS[0];
				isNeedUpdate = true;
			}
			
			if(ConfigAuto.EQUIP_LVS.indexOf(pickUpEquipLv) == -1)
			{
				pickUpEquipLv = ConfigAuto.EQUIP_LVS[0];
				isNeedUpdate = true;
			}
			
			var qualityIndex:int = ConfigAuto.EQUIP_QS.indexOf(pickUpEquipQuality);
			if(qualityIndex == -1)
			{
				qualityIndex = 0;
				pickUpEquipQuality = ConfigAuto.EQUIP_QS[qualityIndex];
				isNeedUpdate = true;
			}
			pickUpEquipQualityName = ConfigAuto.EQUIP_Q_MENU[qualityIndex];
			
//			if(ConfigAuto.TP.indexOf(hpTPPercent) == -1)
//			{
//				hpTPPercent = ConfigAuto.TP[0];
//				isNeedUpdate = true;
//			}
			
			//temp test 未保存，如果保存了把这删掉
			if(hpTPPercent != 10)
			{
				hpTPPercent = 10;
				isNeedUpdate = true;
			}
			
			if(ConfigAuto.REPAIR_OIL.indexOf(repairOilPercent) == -1)
			{
				repairOilPercent = ConfigAuto.REPAIR_OIL[0];
				isNeedUpdate = true;
			}
			
//			if(checkWrongData(hpCfg,"cd",ConfigAuto.DRUG_TIME))
//			{
//				isNeedUpdate = true;
//			}
//			if(checkWrongData(hpCfg,"percent",ConfigAuto.HP))
//			{
//				isNeedUpdate = true;
//			}
//			if(checkWrongData(hpXCfg,"cd",ConfigAuto.DRUG_TIME_X))
//			{
//				isNeedUpdate = true;
//			}
//			if(checkWrongData(hpXCfg,"percent",ConfigAuto.HPX))
//			{
//				isNeedUpdate = true;
//			}
//			
//			if(checkWrongData(mpCfg,"cd",ConfigAuto.DRUG_TIME))
//			{
//				isNeedUpdate = true;
//			}
//			if(checkWrongData(mpCfg,"percent",ConfigAuto.MP))
//			{
//				isNeedUpdate = true;
//			}
//			if(checkWrongData(mpXCfg,"cd",ConfigAuto.DRUG_TIME_X))
//			{
//				isNeedUpdate = true;
//			}
//			if(checkWrongData(mpXCfg,"percent",ConfigAuto.MPX))
//			{
//				isNeedUpdate = true;
//			}
			
			return isNeedUpdate;
		}
		
		private function checkWrongData(object:*,propertyName:String,list:Array):Boolean
		{
			var value:* = object[propertyName];
			if(list.indexOf(value) == -1)
			{
				object[propertyName] = list[0];
				return true;
			}
			
			return false;
		}
		
		/**
		 * 选中一个学会的挂机技能
		 */
		public function checkLearnedSkills():void
		{
//			var i:int;
//			var code:int;
//			if(oneTargetSkillIndex == -1)
//			{
//				for(i = 0;i < oneTargetSkillList.length; ++i)
//				{
//					code = selectOneTargetSkill(i);
//					if(code == 0)
//					{
//						oneTargetSkillIndex = i;
//						break;
//					}
//				}
//			}
//			
//			if(multiTargetSkillIndex == -1)
//			{
//				for(i = 0;i < multiTargetSkillList.length; ++i)
//				{
//					code = selectMultiTargetSkill(i);
//					if(code == 0)
//					{
//						multiTargetSkillIndex = i;
//						break;
//					}
//				}
//			}
		}
		
		
		public function initDrugCfg():void
		{
			if(!hpCfg)
			{
				hpCfg = new DrugCfg();
				hpCfg.drugs = [2503,2502,2501];
				hpCfg.revDrugs = hpCfg.drugs.concat().reverse();
				hpCfg.cd = 15;
				hpCfg.percent = 80;
			}
			
			if(!hpXCfg)
			{
				hpXCfg = new DrugCfg();
				hpXCfg.drugs = [2523,2522,2521];
				hpXCfg.revDrugs = hpXCfg.drugs.concat().reverse();
				hpXCfg.cd = 1;
				hpXCfg.percent = 50;
			}
			
			if(!mpCfg)
			{
				mpCfg = new DrugCfg();
				mpCfg.drugs = [2513,2512,2511];
				mpCfg.revDrugs = mpCfg.drugs.concat().reverse();
				mpCfg.cd = 15;
				mpCfg.percent = 80;
			}
			
			if(!mpXCfg)
			{
				mpXCfg = new DrugCfg();
				mpXCfg.drugs = [2523,2522,2521];
				mpXCfg.revDrugs = mpXCfg.drugs.concat().reverse();
				mpXCfg.cd = 1;
				mpXCfg.percent = 50;
			}
			
		}
		
		public function get selectedAutoSkillList():Array
		{
			var re:Array = [];
			for(var i:int = 0; i < autoSkillList.length; ++i)
			{
				if(autoSkillState[i])
				{
					re.push(autoSkillList[i]);
				}
			}
			
			return re;
		}
		
		public function get oneTargetSkill():int
		{
			if(oneTargetSkillIndex>=0)
			{
				return oneTargetSkillList[oneTargetSkillIndex];
			}
			
			return 0;
		}
		
		public function get multiTargetSkill():int
		{
			if(multiTargetSkillIndex>=0)
			{
				return multiTargetSkillList[multiTargetSkillIndex];
			}
			
			return 0;
		}
		
		public function AutoDataManager()
		{
			super();
			oneTargetSkillList = [];
			multiTargetSkillList = [];
			
			RoleDataManager.instance.attach(this);
			SkillDataManager.instance.attach(this);
			SkillDealManager.instance.attach(this);
			EntityLayerManager.getInstance().attach(this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HANG_UP_SETING_INFO,this);
		}
		
		public function setJob(job:int):void
		{
			if(_job != job)
			{
				_job = job;
			}
		}
		
		public function changeQuickSetState(index:int):int
		{
			var state:int = 0;
			var result:int = 0;
			if(_job == JobConst.TYPE_ZS)
			{
				if(index == 1)//刀刀刺杀
				{
					state = quickSetState[index];
					if(state)
					{
						result = 0//selectOneTargetSkill(0);
						quickSetState[index] = 0;
						AutoDataManager.instance.oneTargetSkillIndex = -1;
						Alert.message(StringConst.AUTO_ASSIST_CLOSE_CSJS);
						Alert.mesageChatPanel(StringConst.AUTO_ASSIST_CLOSE_CSJS);
						return result;
					}
					else
					{
						result = selectOneTargetSkill(0);
						if(result == 0)
						{
							quickSetState[index] = 1;
							AutoDataManager.instance.oneTargetSkillIndex = 0;
							Alert.message(StringConst.AUTO_ASSIST_OPEN_CSJS);
							Alert.mesageChatPanel(StringConst.AUTO_ASSIST_OPEN_CSJS);
						}
						return result;
					}
				}
				else if(index == 0)//智能弧月
				{
					state = quickSetState[index];
					if(state)
					{
						quickSetState[index] = 0;
						AutoDataManager.instance.multiTargetSkillIndex = -1;
						Alert.message(StringConst.AUTO_ASSIST_CLOSE_BYWD);
						Alert.mesageChatPanel(StringConst.AUTO_ASSIST_CLOSE_BYWD);
						return result;
					}
					else
					{
						result =  selectMultiTargetSkill(0);
						if(result == 0)
						{
							quickSetState[index] = 1;
							AutoDataManager.instance.multiTargetSkillIndex = 0;
							Alert.message(StringConst.AUTO_ASSIST_OPEN_BYWD);
							Alert.mesageChatPanel(StringConst.AUTO_ASSIST_OPEN_BYWD);
						}
						return result;
					}
				}
			}
			else if(_job == JobConst.TYPE_FS || _job == JobConst.TYPE_DS)
			{
				if(index == 0)
				{
//					state = quickSetState[index];
//					if(state)
//					{
//						quickSetState[index] = 0;
//						AutoDataManager.instance.multiTargetSkillIndex = -1;
//						return result;
//					}
//					else
//					{
//						quickSetState[index] = 1;
//						AutoDataManager.instance.multiTargetSkillIndex = 0;
//						return result;
//					}
					
					setIsMagicLocking(!isMagicLocking);
				}
			}
			return 0;
		}
		
		public function updateOneTargetSkill():void
		{
			if(_job == JobConst.TYPE_ZS)
			{
				if(oneTargetSkillIndex == -1)
				{
					//刀刀刺杀
					quickSetState[1] = 0;
				}
				else if(oneTargetSkillIndex == 0)
				{
					//刀刀刺杀
					quickSetState[1] = 1;
				}
			}
			notify(EVENT_UPDATE_ONE_TARGET_SKILL);
		}
		
		public function updateMultiTargetSkill():void
		{
			if(_job == JobConst.TYPE_ZS)
			{
				if(multiTargetSkillIndex == -1)
				{
					//智能弧月或魔法锁定
					quickSetState[0] = 0;
				}
				else if(multiTargetSkillIndex == 0)
				{
					//智能弧月或魔法锁定
					quickSetState[0] = 1;
				}
			}
//			else if(_job == JobConst.TYPE_FS || _job == JobConst.TYPE_DS)
//			{
//				if(magicLocking == -1)
//				{
//					//智能弧月或魔法锁定
//					quickSetState[0] = 0;
//				}
//				else if(magicLocking == 0)
//				{
//					//智能弧月或魔法锁定
//					quickSetState[0] = 1;
//				}
//			}
			
			notify(EVENT_UPDATE_MULTI_TARGET_SKILL);
		}
		
		public function getAutoFightSkills():Array
		{
			var skills:Array = oneTargetSkillList.concat(multiTargetSkillList);
			var re:Array = getSkills(skills);
			
			return re;
		}
		
		private function getSkills(list:Array):Array
		{
			var re:Array = [];
			
			for each(var skillId:int in list)
			{
				if(skillId > 0)
				{
					var skilldata:SkillData = SkillDataManager.instance.skillData(skillId);
					var cfg:SkillCfgData = ConfigDataManager.instance.skillCfgData(0,0,skillId,skilldata?skilldata.level:1);
					re.push(cfg);
				}
				else
				{
					re.push(null);
				}
			}
			
			return re;
		}
		
		public function getAutoSkills():Array
		{
			var skills:Array = autoSkillList;
			return getSkills(skills);
		}
		/**
		 * @return 0 成功 1未学习 2技能为空
		 */
		public function selectAutoSkill(index:int):int
		{
			var skill:int = (index>=0 && index < autoSkillList.length ? autoSkillList[index] : 0);
			return selectSkill(skill);
		}
		/**
		 * @return 0 成功 1未学习 2技能为空
		 */
		public function selectOneTargetSkill(index:int):int
		{
			var skill:int = (index>=0 && index < oneTargetSkillList.length ? oneTargetSkillList[index] : 0);
			return selectSkill(skill);
		}
		/**
		 * @return 0 成功 1未学习 2技能为空
		 */
		public function selectMultiTargetSkill(index:int):int
		{
			var skill:int = (index>=0 && index<multiTargetSkillList.length ? multiTargetSkillList[index] : 0);
			return selectSkill(skill);
		}
		
		private function isLearnSkill(groupId:int):Boolean
		{
			var data:SkillData = SkillDataManager.instance.skillData(groupId);
			if(data)
			{
				return true;
			}
			
			return false;
		}
		
		private function selectSkill(skillGroupId:int):int
		{
			if(skillGroupId > 0)
			{
				var isLearn:Boolean = isLearnSkill(skillGroupId);
				return  isLearn ? 0 : 1;
			}
			else
			{
				return 2;
			}
		}

		public function get oneTargetSkillIndex():int
		{
			return _oneTargetSkillIndex;
		}

		public function set oneTargetSkillIndex(value:int):void
		{
			if(_oneTargetSkillIndex != value)
			{
				_oneTargetSkillIndex = value;
				updateOneTargetSkill();
			}
		}

		public function get multiTargetSkillIndex():int
		{
			return _multiTargetSkillIndex;
		}
		
		
		public function set multiTargetSkillIndex(value:int):void
		{
			var valueOld:int = /*_job == JobConst.TYPE_ZS ? */_multiTargetSkillIndex /*: _magicLocking*/;
			if(valueOld != value)
			{
//				_job == JobConst.TYPE_ZS ? _multiTargetSkillIndex = value : _magicLocking = value;
				
//				if(_job != JobConst.TYPE_ZS)
//				{
//					_magicLocking = value;
//				}
				_multiTargetSkillIndex = value;
				
				updateMultiTargetSkill();
			}
		}
		
		
		public function setIsWithoutShift(value:Boolean):void
		{
			isWithoutShift = value;
			notify(EVENT_UPDATE_WITHOUT_SHIFT);
		}
		
		public function setIsMagicLocking(value:Boolean):void
		{
			isMagicLocking = value;
			quickSetState[0] = value ? 1 : 0; //因为按钮用了原先的按钮，所以要改变它的状态
			notify(EVENT_UPDATE_MAGIC_LOCK);
		}
		
		public function updateData(proc:int,data:*):void
		{
			if(proc == GameServiceConstants.SM_SKILL_RESULT)
			{
				if(isCAttack && (data is ILivingUnit))
				{
					var enemy:ILivingUnit = ILivingUnit(data);
					var isDown:Boolean = GameSceneManager.getInstance().mouseDown;
					if(!isDown && !AutoSystem.instance.isAutoAttackPk())
					{
						AutoSystem.instance.stopAuto();
						AutoJobManager.getInstance().reset();
						
						AutoSystem.instance.startIndepentAttack(enemy.entityType,enemy.entityId);
					}
				}
			}
		}
		
	}
}