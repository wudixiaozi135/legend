package com.view.gameWindow.panel.panels.bag
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipDegreeCfgData;
	import com.model.configData.cfgdata.EquipPolishCfgData;
	import com.model.configData.cfgdata.EquipRecycleCfgData;
	import com.model.configData.cfgdata.EquipRefinedCostCfgData;
	import com.model.configData.cfgdata.EquipResolveCfgData;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.ItemTypeCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.configData.cfgdata.UselessSellCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.ItemType;
	import com.model.consts.SexConst;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subuis.herohead.IHeroHead;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.batchUse.PanelBatchUseData;
	import com.view.gameWindow.panel.panels.equipRecycle.EquipRecycleDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
	import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrowTalk;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.keySell.KeySellDataManager;
	import com.view.gameWindow.panel.panels.mall.MallDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.thingNew.ThingNewData;
	import com.view.gameWindow.panel.panels.thingNew.equipAlert.EquipCanWearManager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.SayUtil;
	import com.view.gameWindow.util.UtilGetCfgData;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;

	public class BagDataManager extends DataManagerBase
	{
		public static const totalCellNum:int = 63;
		private static const DIC:Object = {
			2501: 2531,
			2502: 2532,
			2503: 2533,
			2511: 2541,
			2512: 2542,
			2513: 2543,
			2521: 2551,
			2522: 2552,
			2523: 2553
		};
		
		public static const EQUIP_USE_PLAYER:int=1;
		public static const EQUIP_BAG_PLAYER:int=2;
		public static const EQUIP_USE_HERO:int=3;
		public static const EQUIP_BAG_HERO:int=4;
		public static const EQUIP_BAG_HERO_USE:int=5;
		public static const EQUIP_DATA_ERROR:int=6;

		private static var _instance:BagDataManager;

		public static function get instance():BagDataManager
		{
			if (!_instance)
				_instance = new BagDataManager(hideFun);
			return _instance;
		}
		
		private static function hideFun():void
		{
		}

		public function BagDataManager(fun:Function)
		{
			super();
			if (fun != hideFun)
				throw new Error("该类使用单例模式");
			DistributionManager.getInstance().register(GameServiceConstants.SM_BAG_ITEMS, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_BAG_CHANGE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ITEMS_SOLD, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ITEMS_DROPPED, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ITEMS_DESTORIED, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_USE_ZHUFUYOU_STATE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ZHANSHENYOU_USED, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_USE_DRUG_RETURN,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_USE_DAILY_ITEM_INFO,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_USE_ITEM,this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_GOLD, this);
		}

		public var combineCall:Function;//未绑元宝
		/**曾经获得过的道具id作为key*/
		private var _ownOnceItems:Dictionary;//绑定元宝
		/**整理操作冷却结束时间*/
		private var _sortCDOverTime:int;//未绑金币

		private var _goldUnBind:int;//绑定金币
        private var _unExtractGold:int;//未提取的元宝数量
		/**未绑元宝*/
		public function get goldUnBind():int
		{
			return _goldUnBind;
		}

		private var _goldBind:int;// 消费积分

		/**绑定元宝*/
		public function get goldBind():int
		{
			return _goldBind;
		}

		private var _coinUnBind:int;

		/**未绑金币*/
		public function get coinUnBind():int
		{
			return _coinUnBind;
		}

		private var _coinBind:int;

		/**绑定金币*/
		public function get coinBind():int
		{
			return _coinBind;
		}

		private var _numCelUnLock:int;

		public function get numCelUnLock():int
		{
			return _numCelUnLock;
		}

		private var _costScore:int;

		public function get costScore():int
		{
			return _costScore;
		}

		private var _remainCellNum:int;

		public function get remainCellNum():int
		{
			return _remainCellNum;
		}
		
		private var _lastRemainCellNum:int = -1;
		
		public function get lastRemainCellNum():int
		{
			return _lastRemainCellNum;
		}
		
		private var _bagCellDatas:Vector.<BagData>;

		public function get bagCellDatas():Vector.<BagData>
		{
			return _bagCellDatas;
		}

		private var _usedCellData:BagData;

		public function get usedCellData():BagData
		{
			var _usedCellData2:BagData = _usedCellData;
			_usedCellData = null;
			return _usedCellData2;
		}

		/**整理操作剩余的冷却时间*/
		public function get sortCDTime():int
		{
			return (_sortCDOverTime - getTimer()) * .001;
		}

		/**
		 * @private
		 */
		public function set sortCDTime(value:int):void
		{
			_sortCDOverTime = getTimer() + value * 1000;
		}
		
		public var isChangeForAutoDrug:Boolean = false;

		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_USE_DAILY_ITEM_INFO:
					dealSmUseDailyItemInfo(data);
					break;
				case GameServiceConstants.SM_BAG_ITEMS:
					readData(data);
					isChangeForAutoDrug = true;
					break;
				case GameServiceConstants.SM_BAG_CHANGE:
					dealThingNew(data);
					isChangeForAutoDrug = true;
					break;
				case GameServiceConstants.SM_ITEMS_SOLD:
					dealItemsSold(data);
					isChangeForAutoDrug = true;
					break;
				case GameServiceConstants.SM_ITEMS_DROPPED:
					dealItemsDropped(data);
					isChangeForAutoDrug = true;
					break;
				case GameServiceConstants.SM_ITEMS_DESTORIED:
					dealItemsDestoried(data);
					isChangeForAutoDrug = true;
					break;
				case GameServiceConstants.SM_USE_ZHUFUYOU_STATE:
					dealUseZhuFuYou(data);
					break;
				case GameServiceConstants.SM_ZHANSHENYOU_USED:
					dealZhanShenYouUse(data);
					break;
				case GameServiceConstants.CM_USE_ITEM:
                    handlerCM_USE_ITEM(data);
					break;
				case GameServiceConstants.SM_USE_DRUG_RETURN:
					dealUseItemSuccess(data);
					isChangeForAutoDrug = true;
					break;
                case GameServiceConstants.CM_GET_GOLD:
                    handlerCM_GET_GOLD();
                    break;
				default:
					break;
			}
			super.resolveData(proc, data);
			if (combineCall != null)
			{
				combineCall();
			}
            EquipCanWearManager.instance.update(proc);
		}
		
		private function dealSmUseDailyItemInfo(data:ByteArray):void
		{
			var itemId:int = data.readInt();//物品id
			var dailyUse:int = data.readInt();//已使用次数
			var countUse:int = data.readInt();//本次使用的个数
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(itemId);
			if(!itemCfgData)
			{
				trace("BagDataManager.dealSmUseDailyItemInfo(data) 物品配置信息错误");
				return;
			}
			var effect:String = itemCfgData.effect;
			var split:Array = effect.split(":");
			if(split.length != 2)
			{
				trace("BagDataManager.dealSmUseDailyItemInfo(data) 物品配置信息错误");
				return;
			}
			var value:int = split[0];
			var countMax:int = split[1];
			var str:String = "";
			if(dailyUse >= countMax)
			{
				str = StringConst.ITEM_DAILY_LIMIT_ERROR_0001;
			}
			else
			{
				var countUsed:int = dailyUse + countUse;
				if(countUsed <= countMax)
				{
					str = ItemType.getStrItemGet(itemCfgData.type).replace("&x",value*countUse)+countUsed+"/"+countMax;
				}
				else
				{
					str = StringConst.ITEM_DAILY_LIMIT_ERROR_0002;
				}
			}
			if(!str)
			{
				return;
			}
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);
		}
		
        private function handlerCM_GET_GOLD():void
        {
            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.MALL_GET_GOLD_TIP2);
        }

        private function handlerCM_USE_ITEM(data:ByteArray):void
        {
            var cfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(data.readInt());
            if (cfg)
            {
                if (cfg.type == ItemType.IT_REPUTE2 || cfg.type == ItemType.IT_LOONG_POWER)
                {
                    //如果是火龙之力，播放动画  或龙血令
                    FlyEffectMediator.instance.doFireDragonEnergyEffect();
                }
				else if (cfg.type == ItemType.IT_GIFT_NEED_COST)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.FIRST_CHARGE_TIP_002, cfg.effect));
                } else if (cfg.type == ItemType.IT_HERO_EXP)
                {//英雄经验丹
                    FlyEffectMediator.instance.doSpecialEffect(1);
                } else if (cfg.type == ItemType.IT_SHIELD)
                {
                    FlyEffectMediator.instance.doSpecialEffect(2);
                }
            }
        }
		
		public static function checkAutoUseGift(bag:Vector.<BagData>):Array
		{
			var autoGiftList:Array = AutoDataManager.instance.getAutoUseGift();
			var giftListInBag:Array = [];
			var giftDataListInBag:Array = [];
			
			var itemNumRecord:Dictionary = new Dictionary();
			var giftRecord:Dictionary = new Dictionary();
			
			//选出礼包（药包） 和药
			for each(var data:BagData in bag)
			{
				if(data && data.id && data.type == SlotType.IT_ITEM)
				{
					var item:ItemCfgData = ConfigDataManager.instance.itemCfgData(data.id);
					
					if(item.type == ItemType.GIFT)
					{
						if(autoGiftList.indexOf(item.id) != -1)
						{
							giftListInBag.push(item.id);
							giftDataListInBag.push(data);
						}
					}
					else if(isDrugItem(item.type))
					{
						if(!itemNumRecord[item.type])
						{
							itemNumRecord[item.type] = 0;
						}
						
						if(data.storageType == ConstStorage.ST_CHR_BAG)
						{
							if(RoleDataManager.instance.checkReincarnLevel(item.reincarn,item.level))
							{
								itemNumRecord[item.type] += data.count;
							}
						}
						else if(data.storageType == ConstStorage.ST_HERO_BAG)
						{
							if(HeroDataManager.instance.checkReincarnLevel(item.reincarn,item.level))
							{
								itemNumRecord[item.type] += data.count;
							}
						}
						
					}
				}
			}
			
			//判断的药的数量
			var drugTypes:Array = getDrugTypes();
			var needUseBagList:Array = [];
			for each(var type:int in  drugTypes)
			{
				var num:int = int(itemNumRecord[type]);
				
				if(num < 10)
				{
					var giftListSortByType:Array = AutoDataManager.instance.getAutoUseGiftByType(type);
					
					for each(var giftId:int in giftListSortByType)
					{
						var index:int = giftListInBag.indexOf(giftId);
						if(index != -1)
						{
							needUseBagList.push(giftDataListInBag[index]);
							break;
						}
					}
				}
			}
			
			return needUseBagList;
			
//			//使用药
//			for each(var useData:BagData in needUseBagList)
//			{
//				if(useData.storageType == ConstStorage.ST_CHR_BAG)
//				{
//					BagDataManager.instance.requestUseItem(useData.id,1);
//				}
//				else if(useData.storageType == ConstStorage.ST_HERO_BAG)
//				{
//					HeroDataManager.instance.requestUseItem(useData);
//				}
//			}
		}
		
		
		private static var DRUG_TYPES:Array;
		
		public static function getDrugTypes():Array
		{
			if(!DRUG_TYPES)
			{
				DRUG_TYPES = [ItemType.INTERVAL_HP_DRUG,
								ItemType.INTERVAL_MP_DRUG,
								ItemType.NSTANTANEOUS_HP_DRUG,
								ItemType.NSTANTANEOUS_MP_DRUG,
								ItemType.NSTANTANEOUS_HP_AND_MP_DRUG];
			}
			
			return DRUG_TYPES;
		}
		
		public static function isDrugItem(type:int):Boolean
		{
			var types:Array = getDrugTypes();
			
			return types.indexOf(type) != -1;
		}
		
		private function dealUseItemSuccess(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var id:int = data.readInt();
			var storage:int = data.readByte();
            var itemcfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
			var itemtype:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemcfg.type);
			if(itemtype)
			{
				var cd:Array = DrugCDData.drugCDChr(storage);
				var timer:int = getTimer();
				cd[itemtype.id] = timer;
				if(storage == ConstStorage.ST_CHR_BAG)
					MainUiMediator.getInstance().bottomBar.playCoolDownEffect(itemcfg.id);
				else
					HeroDataManager.instance.itemUsed();
			}
		}
		
		private function dealZhanShenYouUse(data:ByteArray):void
		{
			var type:int = data.readByte();
			if(type==ConstStorage.ST_CHR_BAG)
			{
				Alert.message(StringConst.BAG_PANEL_0038);
			}else
			{
				Alert.message(StringConst.BAG_PANEL_0039);
			}
			
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		public function requestUseItem(id:int, num:int, showTip:Boolean = false):int
		{
			var bag:BagData = getItemById(id);
			if (!bag)
			{
				return 0;
			}
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (firstPlayer.isPalsy && bag.storageType == ConstStorage.ST_CHR_BAG)
			{
				return 0;
			}

			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
			if (!itemCfgData)
			{
				return 0;
			}
			var job:int = RoleDataManager.instance.job;
			if (itemCfgData.job && itemCfgData.job != job)
			{
				if (showTip)
				{
					trace("BagDataManager.requestUseItem(id, num, showTip) 职业不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0013);
				}
				return 0;
			}
			var sex:int = RoleDataManager.instance.sex;
			if (itemCfgData.entity && itemCfgData.entity != EntityTypes.ET_PLAYER)
			{
				if (showTip)
				{
					trace("BagDataManager.requestUseItem(id, num, showTip) 类型不对");
					var replace:String = StringConst.BAG_PANEL_0016.replace("&x", StringConst.BAG_PANEL_0017).replace("&y", itemCfgData.name);
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, replace);
				}
				return 0;
			}
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(itemCfgData.reincarn,itemCfgData.level);
			if (!checkReincarnLevel)
			{
				if (showTip)
				{
					trace("BagDataManager.requestUseItem(id, num, showTip) 等级不够");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0015);
				}
				return 0;
			}
			
			if(itemCfgData.type==ItemType.IT_BATTLE_YOU)
			{
				if(LastingDataMananger.getInstance().lasting==false)
				{
					Alert.warning(StringConst.BAG_PANEL_0040);
					return 0;
				}
			}
			BagDataManager.instance.sendUseData(bag.slot, bag.storageType, num);
			return 1;
		}

		/**完整判断*/
		public function dealItemUse(id:int):void
		{
			var manager:BagDataManager = BagDataManager.instance;
			var dt:BagData = manager.getItemById(id);
			if (dt)
			{
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				if (firstPlayer.isPalsy && dt.storageType == ConstStorage.ST_CHR_BAG)
				{
					return;
				}
				
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(dt.id);
				if (!itemCfgData)
				{
					return;
				}
				
				if(itemCfgData.type == ItemType.IT_GIFT_FAMILY && SchoolDataManager.getInstance().schoolBaseData.schoolId == 0)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0041);
					return;
				}
				
				var job:int = RoleDataManager.instance.job;
				if (itemCfgData.job && itemCfgData.job != job)
				{
					trace("in BagCellClickHandle.dealUseWear 职业不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0013);
					return;
				}
				var sex:int = RoleDataManager.instance.sex;
				if (itemCfgData.entity && itemCfgData.entity != EntityTypes.ET_PLAYER)
				{
					trace("in BagCellClickHandle.dealUseWear 使用者不对");
					var replace:String = StringConst.BAG_PANEL_0016.replace("&x", StringConst.BAG_PANEL_0017).replace("&y", itemCfgData.name);
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, replace);
					return;
				}
				var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(itemCfgData.reincarn,itemCfgData.level);
				if (!checkReincarnLevel)//等级不够
				{
					trace("in BagCellClickHandle.dealUseWear 等级不够");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0015);
					return;
				}
				if (itemCfgData.type == ItemType.SKILL_BOOK || itemCfgData.type == ItemType.HERO_SKILL_BOOK)
				{
					SkillDataManager.instance.useSkillBook(dt.id, dt.slot);
				}
				else
				{
					var str:String;
					var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
					if (itemTypeCfgData && itemTypeCfgData.canBatch && dt.count > 1)
					{
						dealBatch(dt);
						return;
					}
					str = ItemType.itemTypeName(itemCfgData.type);
//					if (itemTypeCfgData.panel)
//					{
//						return;
//					}
					if (itemTypeCfgData.batch == ItemTypeCfgData.CantUse)
					{
						if(itemTypeCfgData.panel>0)
						{
							new OpenPanelAction(UICenter.getUINameFromMenu(itemTypeCfgData.panel+""),itemTypeCfgData.panel_param-1).act();
						}else
						{
							RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0026);
						}
					}
					if (str != "")
					{
						if (itemCfgData.type == ItemType.IT_ENERGY || itemCfgData.type == ItemType.IT_ENERGY2)
						{
							str = str.replace("xx", itemCfgData.effect).replace("xx", itemCfgData.effect);
						}
						else
						{
							str = str + itemCfgData.effect;
						}
						RollTipMediator.instance.showRollTip(RollTipType.REWARD, str);
					}
					manager.sendUseData(dt.slot);
				}
			}
			else
			{
				trace("BagDataManager.dealItemUse(id) 物品已用完");
			}
		}

		public function sendUseData(slot:int, storage:int = ConstStorage.ST_CHR_BAG, num:int = 1):void
		{
			if(checkUseCD(slot,storage))
			{
				return;
			}
			if(checkUseAngryDrug(slot,storage))
			{
				return;
			}
            var isCheckUseExpDrug:int = checkUseExpDrug(slot, storage, num);
            if (isCheckUseExpDrug == 1)
			{
				Alert.warning(StringConst.BAG_PANEL_ERROR_0002);
				return;
			}
            if (isCheckUseExpDrug == 2)
			{
				Alert.show2(StringConst.BAG_PANEL_ERROR_0001,func);
				return;
			}
			func();
			function func():void
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeByte(storage);
				byteArray.writeByte(slot);
				byteArray.writeInt(num);//数量
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_USE_ITEM, byteArray);
			}
		}
		/**判断能否使用瞬回怒气药*/
		public function checkUseAngryDrug(slot:int, storage:int):Boolean
		{
			var bagData:BagData = null;
			if (storage == ConstStorage.ST_CHR_BAG)
			{
				bagData = BagDataManager.instance.getBagCellData(slot);
			}
			else
			{
				bagData = HeroDataManager.instance.getBagCellData(slot);
			}
			var cfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(bagData.id);
 			if(cfg && cfg.type == ItemType.HEJI_ANGRY_DRUG)
			{
				var manager:HejiSkillDataManager = HejiSkillDataManager.instance;
				if(!manager.isAngryPlaying)
				{
					return true;
				}
				if(manager.isAngryFull)
				{
					Alert.warning(StringConst.HEJI_PANEL_0008);
					return true;
				}
			}
			return false;
		}
		
		public function checkUseCD(slot:int, storage:int):Boolean
		{
			var bagData:BagData = null;
			if (storage == ConstStorage.ST_CHR_BAG)
			{
				bagData = BagDataManager.instance.getBagCellData(slot);
			}
			else
			{
				bagData = HeroDataManager.instance.getBagCellData(slot);
			}
			var cfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(bagData.id);
			var item:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(cfg.type);
			if(item&&item.type == ItemType.ITEM_TYPE_DRUG)
			{
				var timer:int = getTimer();
				var cd:Array = DrugCDData.drugCDChr(storage);
				if(!cd[item.id])
				{
				}
				else
				{
					if(timer - cd[item.id] < item.cd)
						return true;
				}
			}
			return false;
		}
		/**
		 * 
		 * @param slot
		 * @param storage
		 * @param num
		 * @return 0：正常，1：满，2溢出
		 */		
		private function checkUseExpDrug(slot:int, storage:int, num:int):int
		{
			var bagData:BagData = null;
			if (storage == ConstStorage.ST_CHR_BAG)
			{
				var managerRole:RoleDataManager = RoleDataManager.instance;
				bagData = BagDataManager.instance.getBagCellData(slot);
				var cfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(bagData.id);
				if(cfg && (cfg.type == ItemType.IT_EXP2 || cfg.type == ItemType.IT_EXP_DRAG || cfg.type == ItemType.IT_HERO_EXP))
				{
					if(managerRole.isExpFull())
					{
						return 1
					}
					else if(managerRole.isExpOver(int(cfg.effect)*num))
					{
						return 2;
					}
				}
				return 0;
			}
			else
			{
				var managerHero:HeroDataManager = HeroDataManager.instance;
				bagData = managerHero.getBagCellData(slot);
				cfg = ConfigDataManager.instance.itemCfgData(bagData.id);
				if(cfg && (cfg.type == ItemType.IT_EXP2 || cfg.type == ItemType.IT_EXP_DRAG || cfg.type == ItemType.IT_HERO_EXP))
				{
					if(managerHero.isExpFull())
					{
						return 1
					}
					else if(managerHero.isExpOver(int(cfg.effect)*num))
					{
						return 2;
					}
				}
				return 0;
			}
		}
		/**
		 * @param datas 出售物品列表
		 */
		public function sendSellDatas(datas:Vector.<BagData>):void
		{
			var data:BagData;
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(datas.length);
			for each(data in datas)
			{
				byteArray.writeByte(data.storageType);
				byteArray.writeByte(data.slot);
			}
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SELL_ITEM, byteArray);
		}

		/**提示包裹已满*/
		public function promptBagPacked():void
		{
			if (!_remainCellNum)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0023,false);
				var manager:KeySellDataManager = KeySellDataManager.instance;
				manager.dealBagItems();
				if (!manager.datas || !manager.datas.length)
				{
					return;
				}
				PanelMediator.instance.openPanel(PanelConst.TYPE_KEY_SELL);
			}
		}

		/**提示包裹已满*/
		public function promptBagPackedCellLess():void
		{
			if (_lastRemainCellNum<=5&&_lastRemainCellNum>0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0042,false);
			}
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
			if(memEquipData.equipCfgData.entity!=0&&memEquipData.equipCfgData.entity!=EntityTypes.ET_PLAYER)return false;
			var fightPower:Number = 0, fightPowerEquiped:Number = 0;
			memEquipData.isHero = false;
			fightPower = memEquipData.getTotalFightPower();
			var slot:int = ConstEquipCell.getRoleEquipSlot(memEquipData.equipCfgData.type);
			if (slot != -1)
			{
				fightPowerEquiped = RoleDataManager.instance.getEquipPower(slot);
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
		
		/**
		 * 
		 * 检测装备是否符合人物佩戴，放入人物背包，英雄佩戴，放入英雄背包
		 * @return int 1符合人物佩戴，2 放入人物背包，3英雄佩戴，4放入英雄背包 5数据异常
		 */
		public function checkEquipUseBourn(memEquipData:MemEquipData,equipCfgData:EquipCfgData):int
		{
			if (!equipCfgData)
			{
				return EQUIP_DATA_ERROR;
			}
			var job:int = RoleDataManager.instance.job;
			var sex:int = RoleDataManager.instance.sex;
			var lv:int = RoleDataManager.instance.lv;
			var reincarn:int = RoleDataManager.instance.reincarn;
//			if(equipCfgData.entity&&equipCfgData.entity!=EntityTypes.ET_PLAYER)
//			{
//				return checkHeroUseEquip(memEquipData,equipCfgData);
//			}
			
			if (equipCfgData.job && equipCfgData.job != job)  //如果不是主角的职业
			{
				return checkHeroUseEquip(memEquipData,equipCfgData);
			}
			if (equipCfgData.sex && equipCfgData.sex != sex)
			{
				return checkHeroUseEquip(memEquipData,equipCfgData);
			}
			
			if (isFightPowerHigher(memEquipData)==false)
			{
				return checkHeroUseEquip(memEquipData,equipCfgData);
			}
			
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(equipCfgData.reincarn,equipCfgData.level);
			if (!checkReincarnLevel)
			{
				return EQUIP_BAG_PLAYER;
			}
			return EQUIP_USE_PLAYER;
		}
		
		/**
		 * 
		 * 检测一下英雄是否符合携带这件装备
		 */
		private function checkHeroUseEquip(memEquipData:MemEquipData,equipCfgData:EquipCfgData):int
		{
			var heroCreated:Boolean=HeroDataManager.instance.lv>0;
			if(heroCreated==false)
			{
				return EQUIP_BAG_PLAYER;
			}
			
			var sex2:int = HeroDataManager.instance.sex;
			var job2:int = HeroDataManager.instance.job;
			var lv2:int = HeroDataManager.instance.lv;
			var grade:int = HeroDataManager.instance.heroUpgradeData.grade;
			if(equipCfgData.entity==0||equipCfgData.entity==EntityTypes.ET_HERO)
			{
				if(equipCfgData.job==0||equipCfgData.job==job2)  //如果是英雄的职业
				{
					if(equipCfgData.sex==sex2||equipCfgData.sex==SexConst.TYPE_NO)  //如果是英雄的性别
					{
						var isHigher:Boolean = isHeroFightPowerHigher(memEquipData);
						if(isHigher)
						{
							if (grade>equipCfgData.reincarn||(equipCfgData.reincarn==grade&&equipCfgData.level<=lv2))
							{
								if(equipCfgData.level<50)
								{
									return EQUIP_USE_HERO;
								}else
								{
									return EQUIP_BAG_HERO_USE;
								}
							}else
							{
								return EQUIP_BAG_HERO;
							}
						}
					}
				}
			}
			return EQUIP_BAG_PLAYER;
		}
		
		/**
		 * 判断传入的英雄装备战斗力是否比装备着的装备好
		 * @param equipCfgData
		 * @return
		 */
		public function isHeroFightPowerHigher(memEquipData:MemEquipData):Boolean
		{
			if(!memEquipData)
			{
				return false;
			}
			var fightPower:Number = 0, fightPowerEquiped:Number = 0;
			memEquipData.isHero =true ;
			fightPower = memEquipData.getTotalFightPower();
			var slot:int = ConstEquipCell.getHeroEquipSlot(memEquipData.equipCfgData.type);
			if (slot != -1)
			{
				fightPowerEquiped = HeroDataManager.instance.getEquipPower(slot);
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

		/**
		 * 交换背包格数据
		 * @param cellId1当前格
		 * @param cellId2目标格
		 */
		public function exchangeBagCellData(cellId1:int, cellId2:int):void
		{
			var infos1:BagData, infos2:BagData;
			infos1 = _bagCellDatas[cellId1];
			infos2 = _bagCellDatas[cellId2];
			if (infos2 && infos1.id == infos2.id && infos1.type == infos2.type && infos1.bind == infos2.bind)//同一种东西
			{
				_bagCellDatas[cellId1] = null;
				_bagCellDatas[cellId2].count = infos1.count + infos2.count;
			}
			else
			{
				_bagCellDatas[cellId1] = infos2;
				_bagCellDatas[cellId2] = infos1;
			}
		}

		public function getBagCellData(cellId:int):BagData
		{
			return _bagCellDatas[cellId];
		}

		public function getBagCellDataById(id:int):BagData
		{
			for each(var bagCellData:BagData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.id == id)
				{
					return bagCellData;
				}
			}
			return null;
		}
		/**
		 * 
		 * 这个方法没有检测，请谨慎使用
		 */
		public function sendMoveData(oldStorage:int,oldSlot:int,newStorage:int,newSlot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(oldStorage);
			byteArray.writeByte(oldSlot);
			byteArray.writeByte(newStorage);
			byteArray.writeByte(newSlot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE_ITEM,byteArray);
		}
		
		public function getBagCellDataByBaseId(baseId:int):BagData
		{
			for each(var bagCellData:BagData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.memEquipData && bagCellData.memEquipData.baseId == baseId)
				{
					return bagCellData;
				}
			}
			return null;
		}
		
		public function getBagCellDataByIdType(id:int, type:int, bornSid:int):BagData
		{
			for each(var bagCellData:BagData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.id == id && bagCellData.type == type && bagCellData.bornSid == bornSid)
				{
					return bagCellData;
				}
			}
			return null;
		}

		/**
		 * 根据传入的id获取bagData
		 * @param id 可能是唯一id或配置id
		 */
		public function getBagDataById(id:int, type:int, bornSid:int):BagData
		{
			for each(var bagCellData:BagData in _bagCellDatas)
			{
				if (!bagCellData)
				{
					continue;
				}
				if (bagCellData.id == id && bagCellData.type == type && bagCellData.bornSid == bornSid)
				{
					return bagCellData;
				}
				if (bagCellData.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagCellData.bornSid, bagCellData.id);
					if (!memEquipData)
					{
						continue;
					}
					if (memEquipData.baseId == id && bagCellData.type == type && bagCellData.bornSid == bornSid)
					{
						return bagCellData;
					}
				}
			}
			return null;
		}
		/**
		 * 获取可以强化的装备列表
		 * @return
		 */
		public function getCanStrengthEquip():Array
		{
			var equipArr:Array = [];
			for each(var bagCellData:BagData in bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagCellData.bornSid, bagCellData.id);
					if (!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if (!equipCfgData)
					{
						continue;
					}
					if (equipCfgData.strengthen > 0 && memEquipData.strengthen <= equipCfgData.strengthen)
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
		public function getCanPolishEquips():Array
		{
            var array:Array = [];
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
		 * 取第一个空的格子
		 * @return 若无空格子返回-1
		 */
		public function getFirstEmptyCellId():int
		{
			var i:int, l:int;
			l = bagCellDatas.length;
			for (i = 0; i < l; i++)
			{
				var bagData:BagData = _bagCellDatas[i];
				if (!bagData)
				{
					return i;
				}
			}
			return -1;
		}

		/**
		 * 获取道具数量
		 * @param id 道具id
		 * @param bind -1：都获取，0：不绑定，1：绑定
		 * @return
		 */
		public function getItemNumById(id:int, bind:int = -1):int
		{
			var bagCellData:BagData, num:int;
			for each(bagCellData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_ITEM && bagCellData.id == id)
				{
					if (bind == -1 || (bind != -1 && bagCellData.bind == bind))
					{
						num += bagCellData.count;
					}
				}
			}
			return num;
		}

		/**
		 * 获取道具格子
		 * @param id 道具id
		 * @param bind -1：都获取，0：不绑定，1：绑定
		 * @return
		 */
		public function getItemSlotById(id:int, bind:int = -1):int
		{
			var bagCellData:BagData, slot:int;
			for each(bagCellData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_ITEM && bagCellData.id == id)
				{
					if (bind == -1 || (bind != -1 && bagCellData.bind == bind))
					{
						slot = bagCellData.slot;
						return slot;
					}
				}
			}
			return 0;
		}

		/**
		 * 获取某道具所占格子数据数组
		 * @param id 道具id
		 * @param bind -1：都获取，0：不绑定，1：绑定
		 * @return
		 */
		public function getItemVectorById(id:int, bind:int = -1):Vector.<BagData>
		{
			var bagCellData:BagData;
			var bagCellDataVec:Vector.<BagData> = new Vector.<BagData>;
			for each(bagCellData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_ITEM && bagCellData.id == id)
				{
					if (bind == -1 || (bind != -1 && bagCellData.bind == bind))
					{
						bagCellDataVec.push(bagCellData);
					}
				}
			}
			return bagCellDataVec;
		}
		
		/**
		 * 获取某道具所占的格子数组
		 * @param id 道具id
		 * @param bind -1：都获取，0：不绑定，1：绑定
		 * @return
		 */
		public function getItemVectorIntById(id:int, bind:int = -1):Vector.<int>
		{
			var bagCellData:BagData;
			var bagCellDataVec:Vector.<int> = new Vector.<int>;
			for each(bagCellData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_ITEM && bagCellData.id == id)
				{
					if (bind == -1 || (bind != -1 && bagCellData.bind == bind))
					{
						for(var i:int=0;i<bagCellData.count;i++)
						{
							bagCellDataVec.push(bagCellData.slot);
						}
					}
				}
			}
			return bagCellDataVec;
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
			for each(bagCellData in _bagCellDatas)
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

		public function getItemById(id:int):BagData
		{
			var bagCellData:BagData;
			for each(bagCellData in _bagCellDatas)
			{
				if(bagCellData && bagCellData.type == SlotType.IT_ITEM && bagCellData.id == id)
				{
					return bagCellData;
				}
			}
			return null;
		}

		/**
		 * 根据类型获取该类型的所有的时装数据
		 * @param type
		 * @return
		 */
		public function getFashionDatasByType(type:int):Vector.<BagData>
		{
			var bagCellData:BagData, vector:Vector.<BagData>;
			vector = new Vector.<BagData>();
			for each(bagCellData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagCellData.bornSid, bagCellData.id);
					if (!memEquipData)

					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if (!equipCfgData)
					{
						continue;
					}
					if (equipCfgData.type == type)
					{
						vector.push(bagCellData);
					}
				}
			}
			return vector;
		}

		public function getRecycleEquipDatas():Vector.<BagData>
		{
			var bagCellData:BagData, vector:Vector.<BagData>;
			vector = new Vector.<BagData>();
			for each(bagCellData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagCellData.bornSid, bagCellData.id);
					if (!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if (!equipCfgData)
					{
						continue;
					}
					var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type, equipCfgData.quality, equipCfgData.level);
					if (equipRecycleCfgData)
					{
						vector.push(bagCellData);
					}
				}
			}
			return vector;
		}

		public function getResolveEquipDatas():Vector.<BagData>
		{
			var bagCellData:BagData, vector:Vector.<BagData>;
			vector = new Vector.<BagData>();
			for each(bagCellData in _bagCellDatas)
			{
				if (bagCellData && bagCellData.type == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagCellData.bornSid, bagCellData.id);
					if (!memEquipData)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if (!equipCfgData)
					{
						continue;
					}
					var cfgData:EquipResolveCfgData = ConfigDataManager.instance.equipResolveCfgData(memEquipData.baseId);
					if (cfgData)
					{
						vector.push(bagCellData);
					}
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
		public function getExtendEquipDatas(type:int, onlyId:int,filter:int,memEquipDataSelect:MemEquipData):Vector.<BagData>
		{
			var lvStrength:int = memEquipDataSelect ? memEquipDataSelect.strengthen : 0;
			var lvEquip:int = memEquipDataSelect && memEquipDataSelect.equipCfgData ? memEquipDataSelect.equipCfgData.level : 0;
			var quality:int = memEquipDataSelect && memEquipDataSelect.equipCfgData ? memEquipDataSelect.equipCfgData.quality : 0;
			var lvPolish:int = memEquipDataSelect ? memEquipDataSelect.polish : 0;
			var attrRdCount:int =memEquipDataSelect ? memEquipDataSelect.attrRdCount : 0;
			var bagData:BagData, vector:Vector.<BagData>;
			vector = new Vector.<BagData>();
			for each(bagData in bagCellDatas)
			{
				if (bagData && bagData.type == SlotType.IT_EQUIP)
				{
					if (bagData.id == onlyId)
					{
						continue;
					}
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagData.bornSid, bagData.id);
					if (!memEquipData)
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
					if (type && type != equipCfgData.type)
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
					var isUnsatisfyRand:Boolean = isUnsatisfyRd(filter, attrRdCount, memEquipData);
					if (isUnsatisfyRand)
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
		
		public function getDegreeEquipDatas():Vector.<BagData>
		{
			var equipData:BagData, vector:Vector.<BagData>;
			vector = new Vector.<BagData>();
			for each(equipData in bagCellDatas)
			{
				if (equipData)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid, equipData.id);
					if(!memEquipData)
					{
						continue;
					}
					var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
					if (!equipDegreeCfgData)
					{
						continue;
					}
					vector.push(equipData);
				}
			}
			return vector;
		}
		
		public function getRefinedEquipDatas():Vector.<BagData>
		{
			var job:int = RoleDataManager.instance.job;
			var vector:Vector.<BagData> = new Vector.<BagData>();
			var dt:BagData;
			for each(dt in bagCellDatas)
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
			var lv:int = RoleDataManager.instance.lv;
			var worldLevel:int = WelfareDataMannager.instance.worldLevel;
			var uselessSellCfgDatas:Vector.<UselessSellCfgData> = ConfigDataManager.instance.uselessSellCfgDatas(lv,worldLevel);
			if (!uselessSellCfgDatas.length)
			{
				return null;
			}
			var vector:Vector.<BagData> = new Vector.<BagData>();
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			var data:BagData, sellData:UselessSellCfgData;
			for each(data in bagCellDatas)
			{
				if (!data)
				{
					continue;
				}
				for each(sellData in uselessSellCfgDatas)
				{
					if (data.type == SlotType.IT_EQUIP)
					{
						var equipCfgData:EquipCfgData = utilGetCfgData.GetEquipCfgData(data.id, data.bornSid);
						if (!equipCfgData)
						{
							continue;
						}
						if (equipCfgData.id == sellData.item_id)
						{
							var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(data.bornSid,data.id);
							if (!isFightPowerHigher(memEquipData))
							{
								vector.push(data);
							}
						}
					}
					else
					{
						if (data.id == sellData.item_id)
						{
							vector.push(data);
						}
					}
				}
			}
			return vector;
		}

		public function setUsedCellData(cellId:int):void
		{
			_usedCellData = _bagCellDatas[cellId];
		}

		/**处理批量*/
		private function dealBatch(dt:BagData):void
		{
			PanelBatchUseData.id = dt.id;
			PanelBatchUseData.type = dt.type;
			PanelBatchUseData.storage = dt.storageType;
			PanelBatchUseData.slot = dt.slot;
			PanelMediator.instance.openPanel(PanelConst.TYPE_BATCH);
		}

		public var needShowRecycleGuide:Boolean = false;
		public var numRecycleShown:int = 0;

		private var talk:GuideArrowTalk;
		
		public function checkRecycleNum(isBag:Boolean = true):void
		{
			//新加 是否有可回收装备的判断 
			
			var cellNum:int = isBag ? BagDataManager.instance.remainCellNum : HeroDataManager.instance.remainCellNum;
			var showNum:int = isBag ? BagDataManager.instance.numRecycleShown : HeroDataManager.instance.numRecycleShown;
			var threshold:int = isBag ? 8 : 4;
			if(cellNum <= threshold && cellNum>=0/* && showNum == 0*/)
			{
				if(!RoleDataManager.instance.isEquipInited ||
					!HeroDataManager.instance.isEquipInited)
				{
					return;
				}
				
				EquipRecycleDataManager.instance.getEecyaleEquipDatas();
				EquipRecycleDataManager.instance.filterEecyaleEquipDatas();
				if(EquipRecycleDataManager.instance.realEquipRecycleDatas.length > 0)
				{
					if(isBag)
					{
						BagDataManager.instance.needShowRecycleGuide = true;
					}
					else
					{
						HeroDataManager.instance.needShowRecycleGuide = true;
						//因为 HeroHead 并没有 监听role info 的信息
						HeroDataManager.instance.updateShowRecycleShow();
					}
				}
				else
				{
					BagDataManager.instance.needShowRecycleGuide = false;
					HeroDataManager.instance.needShowRecycleGuide = false;
				}
			}
			else
			{
				if(isBag)
				{
					BagDataManager.instance.needShowRecycleGuide = false;
				}
				else
				{
					HeroDataManager.instance.needShowRecycleGuide = false;
				}
			}
		/*	else if(showNum != 0)
			{
				if(isBag)
				{
					BagDataManager.instance.needShowRecycleGuide = cellNum <= 8 && cellNum>=0;
				}
				else
				{
					HeroDataManager.instance.needShowRecycleGuide = cellNum <= 8 && cellNum>=0;
				}
			}*/
		}
		
		//放在包裹数据刷新后
		private function checkCellNumChange():void
		{
			if(_lastRemainCellNum!=_remainCellNum)
			{
				checkRecycleNum();
				
				if(_remainCellNum<=5&&_remainCellNum>0)
				{
					promptBagPackedCellLess();
				}
				else if(_remainCellNum>5)
				{
					RollTipMediator.instance.removeBottom();
				}
				
				_lastRemainCellNum = _remainCellNum;
			}
		}
		
		private function readData(data:ByteArray):void
		{
            _unExtractGold = data.readInt();
			_goldUnBind = data.readInt();
			_goldBind = data.readInt();
			_coinUnBind = data.readInt();
			_coinBind = data.readInt();
			_numCelUnLock = data.readByte();
			_costScore = data.readInt();
			_bagCellDatas=null;
			_bagCellDatas = new Vector.<BagData>(totalCellNum, true);
			if (!_ownOnceItems)
			{
				_ownOnceItems = new Dictionary();
			}
			var readShort:int = data.readByte();
			_remainCellNum = _numCelUnLock - readShort;
			
			while (readShort--)
			{
				var bagData:BagData = new BagData();
				bagData.slot = data.readByte();
				bagData.id = data.readInt();
				bagData.bornSid = data.readInt();
				bagData.type = data.readByte();
				bagData.count = data.readShort();
				bagData.bind = data.readByte();
				bagData.isHide = data.readByte();
				bagData.storageType = ConstStorage.ST_CHR_BAG;
				_bagCellDatas[bagData.slot] = bagData;
			}
			promptBagPacked();
			
			checkCellNumChange();
			
			if(immediateUseData)
			{
				var useData:BagData = BagDataManager.instance.getBagDataById(immediateUseData.id,immediateUseData.type,immediateUseData.bornSid);
				if(useData)
				{
					//暂时只有技能书
					SkillDataManager.instance.useSkillBook(useData.id,useData.slot);
				}
				immediateUseData = null;
			}
		}
		
//		public function getFullExpStoneInfo():int
//		{
//			
//		}
		
		private function dealThingNew(data:ByteArray):void
		{
			var isUniqueEquip:int;//1字节有符号整形，1表示包含的装备为唯一id，0表示包含的装备为基础id
			var bnfType:int;//1字节有符号整形，防沉迷类型
			var size:int;//1字节有符号整形，增加的数量
			//下面缩进部分为按照增加的数量循环，包含所有增加的道具和装备
			var id:int;//4字节有符号整形，道具装备id
			var bornSid:int;//4字节有符号整形，装备出生服务器id
			var type:int;//1字节有符号整形，道具装备类型
			var count:int;//2字节有符号整形，数量
			isUniqueEquip = 1;
			bnfType = data.readByte();
			ThingNewData.isUniqueEquip = isUniqueEquip;
			ThingNewData.bnfType = bnfType;
			size = data.readInt();
			var index:int;
			while (size--)
			{
				var bagData:BagData = new BagData();
				id = data.readInt();
				bornSid = data.readInt();
				type = data.readByte();
				count = data.readShort();
				bagData.id = id;
				bagData.bornSid = bornSid;
				bagData.type = type;
				bagData.count = count;
				bagData.storageType = ConstStorage.ST_CHR_BAG;
				if (type == SlotType.IT_EQUIP)
				{
					while (count--)
					{
						bagData = bagData.clone();
						doPanelShow(bagData, isUniqueEquip, index++);
					}
				}
				else
				{
					doPanelShow(bagData, isUniqueEquip);
				}
			}
		}
		
		/***
		 * 分析一下，新装备的使用单位问题
		 * */
		private function dealEquipUseUnit(bagData:BagData,equipCfgData:EquipCfgData,index:int = 0):void
		{
			var useUnit:int = checkEquipUseBourn(bagData.memEquipData,equipCfgData);
			var bagCell:BagData = getBagCellDataByBaseId(bagData.memEquipData.baseId);
			if(useUnit==EQUIP_USE_PLAYER)
			{
                var object:Object = {};
				var timerId:uint = setTimeout(function(obj:Object):void
				{
					clearTimeout(obj.timerId);
					if (bagData.memEquipData)
					{
						ThingNewData.isUniqueEquip = 1;
					}
					if (equipCfgData.type == ConstEquipCell.TYPE_CHIBANG)
					{
						var slot:int = ConstEquipCell.getRoleEquipSlot(equipCfgData.type);
						var temp:BagData = BagDataManager.instance.getBagDataById(bagData.id, bagData.type, bagData.bornSid);
						if (temp)
						{
							sendMoveData(ConstStorage.ST_CHR_BAG, temp.slot, ConstStorage.ST_CHR_EQUIP, slot);
							temp = null;
						}
					}
					ThingNewData.bagData = bagData;
					PanelMediator.instance.openPanel(PanelConst.TYPE_EQUIP_NEW, false);
				},index*100,object);
				object.timerId = timerId;
				
			}
			else if(useUnit==EQUIP_USE_HERO)
			{
				SayUtil.heroSayEquip();
				var slot:int = ConstEquipCell.getHeroEquipSlot(equipCfgData.type);
				if(bagCell==null)
				{
					return;
				}
				sendMoveData(bagCell.storageType,bagCell.slot,ConstStorage.ST_HERO_EQUIP,slot);
			}
			else if(useUnit==EQUIP_BAG_HERO||useUnit==EQUIP_BAG_HERO_USE)
			{
				var cellId:int =HeroDataManager.instance.getFirstEmptyCellId();
				if(cellId == -1)  //英雄背包已经没有空格
				{
					return;
				}
                var heroSayStr:String;
				if(useUnit==EQUIP_BAG_HERO_USE)
				{
					heroSayStr = StringConst.HERO_SAY_0006;
				}else
				{
					heroSayStr = StringConst.HERO_SAY_0005;
				}
				closeTalk();
				if(talk==null)
				{
					var heroHead:IHeroHead = MainUiMediator.getInstance().heroHead;
					talk = GuideArrowTalk.show(heroSayStr,54,0,150,heroHead as DisplayObjectContainer);
				}
				if(bagCell==null)
				{
					return;
				}
				sendMoveData(bagCell.storageType,bagCell.slot,ConstStorage.ST_HERO_BAG,cellId);
			}
		}
		
		public function closeTalk():void
		{
			if(talk!=null)
			{
				talk.destroy();
				talk=null;
			}
		}		

		private function doPanelShow(bagData:BagData, isUniqueEquip:int, index:int = 0):void
		{
			if (bagData.type == SlotType.IT_EQUIP)
			{
				var equipCfgData:EquipCfgData;
				if (isUniqueEquip == 1)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagData.bornSid, bagData.id);
					if (!memEquipData)
					{
						trace("in BagDataManager.doPanelShow 不存在id 1");
						return;
					}
					equipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				}
				else
				{
					equipCfgData = ConfigDataManager.instance.equipCfgData(bagData.id);
				}
				if (!equipCfgData)
				{
					trace("in BagDataManager.doPanelShow 不存在id 2");
					return;
				}
				dealEquipUseUnit(bagData,equipCfgData,index);
			}
			else if (bagData.type == SlotType.IT_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(bagData.id);
				if(!itemCfgData)
				{
					return;
				}
				if(itemCfgData.entity == EntityTypes.ET_HERO)
				{
					return;
				}
				var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
				if (itemTypeCfgData && itemTypeCfgData.prompt)
				{
					var isOwnOnce:Boolean = _ownOnceItems[bagData.id];
					if (isOwnOnce)
					{
						return;
					}
					var isLimitMet1:Boolean = isLimitMet(itemCfgData);
					if (!isLimitMet1)
					{
						return;
					}
                    if (itemCfgData.level > RoleDataManager.instance.lv)
                    {
                        trace("使用等级不足");
                        return;
                    }
                    if (itemCfgData.job != 0 && itemCfgData.job != RoleDataManager.instance.job)
                    {
                        trace("职业不符");
                        return;
                    }
                    if (!RoleDataManager.instance.checkReincarnLevel(itemCfgData.reincarn, itemCfgData.level))
                    {
                        trace("转生等级不足");
                        return;
                    }
					
					//如果是需要引导的技能书 立即使用掉
					if(itemCfgData.type == ItemType.SKILL_BOOK)
					{
						var skill:SkillCfgData = ConfigDataManager.instance.skillCfgData1(SkillDataManager.instance.getGuideLearnSkillId());
						if(skill && skill.book == itemCfgData.id)
						{
							var shopData:GameShopCfgData = MallDataManager.instance.getShopCfgDataBySkillId(skill.id);
							if(shopData && shopData.hight_light)
							{
								immediateUseData = bagData;
								return;
							}
						}
							
					}
					
					ThingNewData.bagData = bagData;
					PanelMediator.instance.openPanel(PanelConst.TYPE_ITEM_NEW, false);
					_ownOnceItems[bagData.id] = true;
				}
			}
		}
		
		private var immediateUseData:BagData;
		
		/**
		 *检测装备是否符合佩戴包括英雄的条件
		 * @return 1 为职业不符合，2为等级不足，无法佩戴，3为正在摆摊（目前未完成）  4为正常
		 * */
		public function checkEquipMatch(bagData:BagData):int
		{
			var memEquipData:MemEquipData = bagData.memEquipData;
			var equipCfgData:EquipCfgData = memEquipData ? memEquipData.equipCfgData : null;
			if (!equipCfgData)
			{
				trace("in BagDataManager.isBagFightPowerHigher 不存在id 2");
				return 4;
			}
			var job:int = RoleDataManager.instance.job;
			var job2:int = HeroDataManager.instance.job;
			if (equipCfgData.job && equipCfgData.job != job&&equipCfgData.job!=job2)
			{
				trace("in BagDataManager.isBagFightPowerHigher 职业不对");
				return 1;
			}
			var sex:int = RoleDataManager.instance.sex;
			var sex2:int = HeroDataManager.instance.sex;
			if(equipCfgData.sex && equipCfgData.sex == sex)
			{
				if(equipCfgData.job&&equipCfgData.job!=job)
				{
					trace("in BagDataManager.isBagFightPowerHigher 性别不对");
					return 1;
				}
			}
			if(equipCfgData.sex && equipCfgData.sex == sex2)
			{
				if(equipCfgData.job&&equipCfgData.job!=job2)
				{
					trace("in BagDataManager.isBagFightPowerHigher 性别不对");
					return 1;
				}
			}
			var lv:int = RoleDataManager.instance.lv;
			var reincarn:int = RoleDataManager.instance.reincarn;
			var lv2:int = HeroDataManager.instance.lv;
			var grade:int = HeroDataManager.instance.heroUpgradeData.grade;
				
			if (((equipCfgData.reincarn==reincarn&&equipCfgData.level > lv)||equipCfgData.reincarn>reincarn)&&((equipCfgData.reincarn==grade&&equipCfgData.level>lv2)||equipCfgData.reincarn>grade))
			{
				trace("in BagDataManager.isBagFightPowerHigher 等级不够");
				return 2;
			}
			
			return 4;
		}

        /**
         *  return 1红标 2 黄标 0正常
         * */
        public function showRedOrYellowSign(bagData:BagData):int
        {
            var memEquipData:MemEquipData = bagData.memEquipData;
            var equipCfgData:EquipCfgData = memEquipData ? memEquipData.equipCfgData : null;
            if (!equipCfgData)
            {
                trace("in BagDataManager.isBagFightPowerHigher 不存在id 2");
                return 4;
            }
            var roleJob:int = RoleDataManager.instance.job;
            var roleLv:int = RoleDataManager.instance.lv;
            var roleSex:int = RoleDataManager.instance.sex;
			var heroJob:int = HeroDataManager.instance.job;
			var heroLv:int = HeroDataManager.instance.lv;
			var heroSex:int = HeroDataManager.instance.sex;
            var equipJob:int = equipCfgData.job;//通用
            var equipSex:int = equipCfgData.sex;//通用
            var equipLv:int = equipCfgData.level;

			if(bagData.storageType==ConstStorage.ST_CHR_BAG || ConstStorage.ST_STORAGE.indexOf(bagData.storageType) !=-1
			||bagData.storageType==ConstStorage.ST_SCHOOL_BAG||bagData.storageType==ConstStorage.ST_SCHOOL_MY_BAG)
			{
				if(equipCfgData.entity!=0&&equipCfgData.entity!=EntityTypes.ET_PLAYER)
				{
					return 1;
				}
				if(equipJob!=0&&equipJob!=roleJob)
				{
					return 1;
				}
				if(equipSex!=0&&equipSex!=roleSex)
				{
					return 1;
				}
				if(equipLv>roleLv&&equipCfgData.reincarn>=RoleDataManager.instance.reincarn)
				{
					return 2;
				}
				return 0;	
			}else
			{
				if(equipCfgData.entity!=0&&equipCfgData.entity!=EntityTypes.ET_HERO)
				{
					return 1;
				}
				if(equipJob!=0&&equipJob!=heroJob)
				{
					return 1;
				}
				if(equipSex!=0&&equipSex!=heroSex)
				{
					return 1;
				}
				if(equipLv>heroLv&&equipCfgData.reincarn>=HeroDataManager.instance.grade)
				{
					return 2;
				}
				return 0;
			}

//            if (equipJob == 0)
//            {//通用职业时
//                if (equipSex == 0)
//                {//通用性别时
//                    if (equipLv > roleLv)
//                    {
//                        return 2;//黄标
//                    }
//                    return 0;//正常
//                } else if (equipSex == roleSex)
//                {
//                    if (equipLv > roleLv)
//                    {
//                        return 2;
//                    }
//                    return 0;
//                } else
//                {
//                    return 1;//红标
//                }
//            } else if (equipJob == roleJob)//职业相等
//            {
//                if (equipSex == 0)
//                {
//                    if (equipLv > roleLv)
//                    {
//                        return 2;
//                    }
//                    return 0;
//                } else if (equipSex == roleSex)
//                {
//                    if (equipLv > roleLv)
//                    {
//                        return 2;
//                    }
//                    return 0;
//                } else
//                {
//                    return 1;
//                }
//            } else
//            {
//                return 1;//职业不等 红标
//            }
//            return 0;
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
			var job:int = RoleDataManager.instance.job;
			if (equipCfgData.job && equipCfgData.job != job)
			{
				trace("in BagDataManager.isBagFightPowerHigher 职业不对");
				return false;
			}
			var sex:int = RoleDataManager.instance.sex;
			if (equipCfgData.sex && equipCfgData.sex != sex)
			{
				trace("in BagDataManager.isBagFightPowerHigher 性别不对");
				return false;
			}
			var lv:int = RoleDataManager.instance.lv;
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
		 * 判断传入英雄背包格子装备战斗力是否比装备着的装备好
		 */
		public function isBagHeroFightPowerHigher(bagData:BagData):Boolean
		{
			var memEquipData:MemEquipData = bagData.memEquipData;
			var equipCfgData:EquipCfgData = memEquipData ? memEquipData.equipCfgData : null;
			if (!equipCfgData)
			{
				trace("in BagDataManager.isBagFightPowerHigher 不存在id 2");
				return false;
			}
			var job:int = HeroDataManager.instance.job;
			if (equipCfgData.job && equipCfgData.job != job)
			{
				trace("in BagDataManager.isBagFightPowerHigher 职业不对");
				return false;
			}
			var sex:int = HeroDataManager.instance.sex;
			if (equipCfgData.sex && equipCfgData.sex != sex)
			{
				trace("in BagDataManager.isBagFightPowerHigher 性别不对");
				return false;
			}
			var lv:int = HeroDataManager.instance.lv;
			if (equipCfgData.level > lv)
			{
				trace("in BagDataManager.isBagFightPowerHigher 等级不够");
				return false;
			}
			if (!isHeroFightPowerHigher(memEquipData))
			{
				trace("in BagDataManager.isBagFightPowerHigher 战斗力没有身上的高");
				return false;
			}
			return true;
		}
		
		private function isLimitMet(itemCfgData:ItemCfgData):Boolean
		{
			if (itemCfgData.type == ItemType.SKILL_BOOK)
			{
				var job1:int = RoleDataManager.instance.job;
				if (itemCfgData.job && itemCfgData.job != job1)
				{
					trace("in BagDataManager.doPanelShow 职业不对");
					return false;
				}
				/*if(itemCfgData.entity && itemCfgData.entity != EntityTypes.ET_PLAYER)
				{
					trace("in BagDataManager.doPanelShow 非玩家技能书");
					return false;
                 }*/

				var lv1:int = RoleDataManager.instance.lv;
				if (itemCfgData.level > lv1)
				{
					trace("in BagDataManager.doPanelShow 等级不够");
					return false;
                }
			}
			return true;
		}

		/**处理出售返回*/
		private function dealItemsSold(data:ByteArray):void
		{
			var coin:int = data.readInt();
			var bnfType:int = data.readByte();//防沉迷类型
			var size:int = data.readByte();
			var names:String = "";
			while (size--)
			{
				var id:int = data.readInt();
				var type:int = data.readByte();
				var count:int = data.readShort();
				var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
				var cfgData:Object = type == SlotType.IT_EQUIP ? utilGetCfgData.GetEquipCfgData(id) : utilGetCfgData.GetItemCfgData(id);
				if (cfgData && cfgData.hasOwnProperty("name"))
				{
					if (size != 0)
					{
						names += cfgData.name + ",";
					}
					else
					{
						names += cfgData.name;
					}
				}
			}
//			var replace:String = StringConst.BAG_PANEL_0010.replace("&x", names ? names : StringConst.BAG_PANEL_0022).replace("&y", coin);
			var replace:String = StringConst.BAG_PANEL_0010.replace("x",coin);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, replace);
			IncomeDataManager.instance.addOneLine(replace);
		}

		/**处理丢弃返回*/
		private function dealItemsDropped(data:ByteArray):void
		{
			var id:int = data.readInt();
			var bornSid:int = data.readInt();
			var type:int = data.readByte();
			var count:int = data.readShort();
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			var cfgData:Object = type == SlotType.IT_EQUIP ? utilGetCfgData.GetEquipCfgData(id, bornSid) : utilGetCfgData.GetItemCfgData(id);
			var replace:String = StringConst.BAG_PANEL_0011.replace("&x", cfgData && cfgData.hasOwnProperty("name") ? cfgData.name : StringConst.BAG_PANEL_0022);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, replace);
		}

		/**处理销毁返回*/
		private function dealItemsDestoried(data:ByteArray):void
		{
			var id:int = data.readInt();
			var type:int = data.readByte();
			var count:int = data.readShort();
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			var cfgData:Object = type == SlotType.IT_EQUIP ? utilGetCfgData.GetEquipCfgData(id) : utilGetCfgData.GetItemCfgData(id);
			var replace:String = StringConst.BAG_PANEL_0009.replace("&x", cfgData && cfgData.hasOwnProperty("name") ? cfgData.name : StringConst.BAG_PANEL_0022);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, replace);
		}

		private function dealUseZhuFuYou(data:ByteArray):void
		{
			var state:int = data.readByte();
			if (state == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.EQUIP_USER_003);
			}
			else if (state == 1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.EQUIP_USER_001);
			}
			else if (state == 2)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.EQUIP_USER_002);
			}
			else if (state == 3)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.EQUIP_USER_004);
			}
			else if (state == 4)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.EQUIP_USER_005);
			}
		}

        /**提取元宝*/
        public function sendExtraGold():void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_GOLD, byte);
            byte = null;
        }

        public function get unExtractGold():int
        {
            return _unExtractGold;
        }
		/**获取当前类型的兑换装备id*/
		public function getEquipExchangeData(type:int):int
		{
			for each(var data:BagData in _bagCellDatas)
			{
				if(data&&data.type == SlotType.IT_EQUIP&&data.memEquipData)
				{
					var cfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(data.memEquipData.baseId);
					if(type == RoleDataManager.HLZX && cfg.type == ConstEquipCell.TYPE_HUOLONGZHIXIN)
						return data.memEquipData.baseId;
					if(type == RoleDataManager.HUANJIE && cfg.type == ConstEquipCell.TYPE_HUANJIE)
						return data.memEquipData.baseId;
					if(type == RoleDataManager.DUNPAI && cfg.type == ConstEquipCell.TYPE_DUNPAI)
						return data.memEquipData.baseId;
				}
			}
			return 0;
		}
		
    }
}