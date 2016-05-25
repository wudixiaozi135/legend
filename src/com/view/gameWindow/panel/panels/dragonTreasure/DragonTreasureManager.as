package com.view.gameWindow.panel.panels.dragonTreasure
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.TreasureCfgData;
    import com.model.configData.cfgdata.TreasureGiftCfgData;
    import com.model.configData.cfgdata.TreasureShopCfgData;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.model.gameWindow.mem.AttrRandomData;
    import com.model.gameWindow.mem.MemEquipData;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.constant.TreasureTabType;
    import com.view.gameWindow.panel.panels.dragonTreasure.constant.TreasureType;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.StorageDataInfo;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.TreasureEventData;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.TreasureGetData;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.TreasureIconData;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.TreasureShopManager;
    import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireCostType;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.propertyParse.PropertyData;
    
    import flash.display.MovieClip;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    
    import mx.utils.StringUtil;

    /**
	 * Created by Administrator on 2014/11/29.
	 */
	public class DragonTreasureManager extends DataManagerBase
	{
		/////服务端返回数据
		public var score:int;//我的积分
        public var storageDatas:Vector.<StorageDataInfo> = new Vector.<StorageDataInfo>();//仓库信息数据
		public var treasureEvtDatas:Vector.<TreasureEventData>;//寻宝事件
        public var treasureGetDatas:Vector.<TreasureGetData>;//获得奖励

		////////////////////
		public static var selectIndex:int = 0;
		public static var lastMc:MovieClip;
		public static const STORAGE_MAX:int = 320;

		///寻宝次数
		public static const COUNT_1:int = 1;
		public static const COUNT_5:int = 5;
		public static const COUNT_10:int = 10;
		public static var lastSlotMc:IconCellEx;//上次选中的位置（仓库）

//		private var _goodsDic:Dictionary;
		private var _tipCounts:int;//成功时提示的次数
		/**仓库整理倒计时开关*/
		public static var MAKE_UP_SWITCH:Boolean = false;
		public static var MAKE_UP_END_TIME:Number = 0;

		private var dic:Dictionary = new Dictionary(true);//存放宝藏记录
		public function DragonTreasureManager()
		{
			super();
//			_goodsDic = new Dictionary(true);
//			initData();
			DistributionManager.getInstance().register(GameServiceConstants.SM_FIND_TREASURE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FIND_TREASURE_STORAGE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FIND_TREASURE_EVENT, this);
            DistributionManager.getInstance().register(GameServiceConstants.SM_FIND_TREASURE_GET, this);


			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_FIND_TREASURE_STORAGE, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FIND_TREASURE_STORAGE_CLEARUP, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FIND_TREASURE, this);

		}

//		private function initData():void
//		{
//			var types:Array = [TreasureType.TYPE_1, TreasureType.TYPE_2, TreasureType.TYPE_3, TreasureType.TYPE_4];
//			var type:int = 0, cfg:TreasureCfgData = null, iconCfg:TreasureIconData = null, desc:String = null, totalData:Array = null, data:Array = null;
//			for (var i:int = 0, len:int = types.length; i < len; i++)
//			{
//				type = types[i];
//				_goodsDic[type] = _goodsDic[type] || new Vector.<TreasureIconData>();
//				cfg = ConfigDataManager.instance.findTreasure(type);
//				desc = cfg.gift_desc;
//				totalData = desc.split("|");
//				for (var j:int = 0, len1:int = totalData.length; j < len1; j++)
//				{
//					data = totalData[j].split(":");
//					iconCfg = new TreasureIconData();
//					iconCfg.id = data[0];
//					iconCfg.type = data[1];
//					iconCfg.count = data[2];
//					iconCfg.job = data[3];
//					iconCfg.sex = data[4];
//					_goodsDic[type].push(iconCfg);
//					iconCfg = null;
//				}
//			}
//			types = null;
//			cfg = null;
//			desc = null;
//			iconCfg = null;
//			totalData = null;
//			data = null;
//		}

		/*
		 *  type:1,2,3,4
		 *  all: true全部取出,false只取出前19个
		 * */
//		public function getTypeConfig(type:int, all:Boolean = true):Vector.<TreasureIconData>
//		{
//			if (all)
//			{
//				return _goodsDic[type];
//			} else
//			{
//				var filterVec:Vector.<TreasureIconData> = filter(_goodsDic[type]);
//				if (filterVec.length > 14)
//				{
//					return filterVec.slice(0, 14);
//				}
//				return filterVec;
//			}
//		}
		
		public function getCfgByWoldLevel(all:Boolean=true):TreasureCfgData
		{
			var worldLevel:int = WelfareDataMannager.instance.worldLevel;
			return ConfigDataManager.instance.findTreasureWoldLevel(worldLevel);
		}
		
		public function getTreasureIconDataByGift(desc:String):Vector.<TreasureIconData>
		{
			var gifts:Array = desc.split("|");
			var array:Vector.<TreasureIconData>=new Vector.<TreasureIconData>();
			var len:int = gifts.length;
			for (var j:int = 0; j < len; j++)
			{
				var data:Array = gifts[j].split(":");
				var iconCfg:TreasureIconData = new TreasureIconData();
				iconCfg.id = data[0];
				iconCfg.type = data[1];
				iconCfg.count = data[2];
				iconCfg.job = data[3];
				iconCfg.sex = data[4];
				array.push(iconCfg);
			}
			return array;
		}

		public function getTypeGiftConfig(type:int):Vector.<TreasureGiftCfgData>
		{
			var vec:Vector.<TreasureGiftCfgData> = new Vector.<TreasureGiftCfgData>();
			var dic:Dictionary = ConfigDataManager.instance.treasureGiftCfgDic(type);
			for each(var item:TreasureGiftCfgData in dic)
			{
				vec.push(item);
			}
			return vec.sort(function (item1:TreasureGiftCfgData, item2:TreasureGiftCfgData):int
			{
				if (item1.order > item2.order)
				{
					return 1;
				} else if (item1.order < item2.order)
				{
					return -1;
				} else
				{
					return 0;
				}
				return 0;
			});
		}


		/**过滤符合自身的装备*/
		private function filter(source:Vector.<TreasureIconData>):Vector.<TreasureIconData>
		{
			var vec:Vector.<TreasureIconData> = new Vector.<TreasureIconData>();
			var self:IPlayer = EntityLayerManager.getInstance().firstPlayer;
			for each(var item:TreasureIconData in source)
			{
				if (item.type == SlotType.IT_ITEM)
				{
					vec.push(item);
				} else
				{
					var cfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(item.id);
					if (cfg.sex == 0 || cfg.sex == self.sex)
					{
						if (cfg.job == 0 || cfg.job == self.job)
						{
							vec.push(item);
						}
					}
				}
			}
			return vec;
		}

		public function getScoreReward(type:int):TreasureShopCfgData
		{
			var vec:Vector.<TreasureShopCfgData> = TreasureShopManager.instance.getVecCfgByShelf(type);
			for each(var item:TreasureShopCfgData in vec)
			{
				if (item.order == 1)
				{
					return item;
				}
			}
			return null;
		}

		public function dealSwitchPanleDragon():void
		{
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_DRAGON_TREASURE);
			if (!openedPanel)
			{
				//查询信息
				queryTreasureInfo();
				queryTreasureEventInfo();
				PanelMediator.instance.openPanel(PanelConst.TYPE_DRAGON_TREASURE);
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_DRAGON_TREASURE);
			}
		}

		/**取出物品
		 * slot 位置从1开始
		 * */
		public function sendTakeOutGoods(slot:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_FIND_TREASURE_STORAGE, data);
			data = null;
		}

		/**查询寻宝信息*/
		public function queryTreasureInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_FIND_TREASURE, data);
		}

		/**查询寻宝事件*/
		public function queryTreasureEventInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUREY_FIND_TREASURE_EVENT, data);
		}

		/**
		 * 开始寻宝
		 * tabSelect
		 * type 1,10,50
		 * */
		public function sendFindTreasure(tabSelect:int,count:int):void
		{
			var remainNum:int = STORAGE_MAX - storageDatas.length;//仓库剩余数量
			if (count > remainNum)//空间不足
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PANEL_DRAGON_ERROR_1);
				return;
			}
			var worldLevel:int = WelfareDataMannager.instance.worldLevel;
			var cfgTreasure:TreasureCfgData = ConfigDataManager.instance.findTreasureWoldLevel(worldLevel);
//			if (!RoleDataManager.instance.checkReincarnLevel(cfgTreasure.reincarn, cfgTreasure.level))
//			{
//				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.DGN_TOWER_0042);
//				return;
//			}

			var itemValues:Array = getItemCostValueByWoldLevel(worldLevel, count);
			var ownItemValue:int = BagDataManager.instance.getItemNumById(itemValues[0]);
			var costItemValue:int = itemValues[2];//消耗道具数量
			var ownGoldValue:int = BagDataManager.instance.goldUnBind;
			var costGoldValue:int = getGoldCostValueByWoldLevel(worldLevel, count);

			if (ownItemValue < costItemValue)
			{//道具不足
				if (costGoldValue > ownGoldValue)
				{
					Alert.showAcquirePanel(AcquireCostType.TYPE_GOLD);
					return;
				}
				var noNote:Boolean = getNoNoteSelectedByType(tabSelect, count);//不再提示
				if (noNote == false)
				{
					var msg:String = getMsgByType(costGoldValue, costItemValue, count);
					Alert.show3(msg, function ():void
					{
						sendRequest();
					}, null, function (bol:Boolean):void
					{
						setNoNoteSelectedByType(tabSelect, count, bol);
					}, null, StringConst.PROMPT_PANEL_0033,"","",null,"left");
				} else
				{
					sendRequest();
				}
			} else
			{

				var noNote1:Boolean = getNoNoteSelectedByType(tabSelect, count);//不再提示
				if (noNote1 == false)
				{
					var msg1:String = getMsgByType(costGoldValue, costItemValue, count);
					Alert.show3(msg1, function ():void
					{
						sendRequest();
					}, null, function (bol:Boolean):void
					{
						setNoNoteSelectedByType(tabSelect, count, bol);
					}, null, StringConst.PROMPT_PANEL_0033,"","",null,"left");
				} else
				{
					sendRequest();
				}
			}

			function sendRequest():void
			{
				_tipCounts = count;
				var data:ByteArray = new ByteArray();
				data.endian = Endian.LITTLE_ENDIAN;
				data.writeInt(count);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FIND_TREASURE, data);
				PanelMediator.instance.openPanel(PanelConst.TYPE_DRAGON_TREASURE_WAREHOUSE);
			}
		}

		private function getMsgByType(goldCost:int, itemCost:int, count:int):String
		{
			var msg:String = StringConst.PANEL_DRAGON_TIP_1;
			msg = StringUtil.substitute(msg, goldCost, itemCost, count);
			return msg;
		}

		/**不再提示*/
		private function getNoNoteSelectedByType(type:int, count:int):Boolean
		{
			switch (count)
			{
				case DragonTreasureManager.COUNT_1:
					return SelectPromptBtnManager.getSelect(SelectPromptType.SELEC_TTREASURE_1);
				case DragonTreasureManager.COUNT_5:
					return SelectPromptBtnManager.getSelect(SelectPromptType.SELEC_TTREASURE_5);
				case DragonTreasureManager.COUNT_10:
					return SelectPromptBtnManager.getSelect(SelectPromptType.SELEC_TTREASURE_10);
			}
			return false;
		}

		/**设置不再提示*/
		private function setNoNoteSelectedByType(type:int, count:int, selected:Boolean):void
		{
			switch (count)
			{
				case DragonTreasureManager.COUNT_1:
					SelectPromptBtnManager.setSelect(SelectPromptType.SELEC_TTREASURE_1, selected);
					break;
				case DragonTreasureManager.COUNT_5:
					SelectPromptBtnManager.setSelect(SelectPromptType.SELEC_TTREASURE_5, selected);
					break;
				case DragonTreasureManager.COUNT_10:
					SelectPromptBtnManager.setSelect(SelectPromptType.SELEC_TTREASURE_10, selected);
					break;
				default :
					break;
			}
		}

		/**
		 * 物品ID：物品类型：物品数量
		 * */
		private function getItemCostValueByWoldLevel(level:int, count:int):Array
		{
			var config:TreasureCfgData = ConfigDataManager.instance.findTreasureWoldLevel(level);
			var costItem:Array = null;
			switch (count)
			{
				case DragonTreasureManager.COUNT_1:
					costItem = config.one_item_cost.split(":");//物品ID：物品类型：物品数量
					break;
				case DragonTreasureManager.COUNT_5:
					costItem = config.five_item_cost.split(":");//物品ID：物品类型：物品数量
					break;
				case DragonTreasureManager.COUNT_10:
					costItem = config.ten_item_cost.split(":");//物品ID：物品类型：物品数量
					break;
				default :
					break;
			}
			return costItem;
		}

		private function getGoldCostValueByWoldLevel(level:int, count:int):int
		{
			var cfg:TreasureCfgData = ConfigDataManager.instance.findTreasureWoldLevel(level);
			switch (count)
			{
				case DragonTreasureManager.COUNT_1:
					return cfg.one_gold_cost;
				case DragonTreasureManager.COUNT_5:
					return cfg.five_gold_cost;
				case DragonTreasureManager.COUNT_10:
					return cfg.ten_gold_cost;
			}
			return 0;
		}


		/**根据tab页获取相应的类型*/
		public function getTypeBySelectIndex():int
		{
			var selectIndex:int = DragonTreasureManager.selectIndex;
			var type:int;
			switch (selectIndex)
			{
				case TreasureTabType.TAB_0:
					type = TreasureType.TYPE_1;
					break;
				case TreasureTabType.TAB_1:
					type = TreasureType.TYPE_2;
					break;
				case TreasureTabType.TAB_2:
					type = TreasureType.TYPE_3;
					break;
				case TreasureTabType.TAB_3:
					type = TreasureType.TYPE_4;
					break;
				default :
					break;
			}
			return type;
		}

		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_FIND_TREASURE:
					handlerSM_FIND_TREASURE(data);
					break;
				case GameServiceConstants.SM_FIND_TREASURE_STORAGE:
					handlerSM_FIND_TREASURE_STORAGE(data);
					break;
				case GameServiceConstants.SM_FIND_TREASURE_EVENT:
					handlerSM_FIND_TREASURE_EVENT(data);
					break;
                case GameServiceConstants.SM_FIND_TREASURE_GET:
                    handlerSM_FIND_TREASURE_GET(data);
                    break;
				case GameServiceConstants.CM_GET_FIND_TREASURE_STORAGE:
					handlerCM_GET_FIND_TREASURE_STORAGE(data);
					break;
				case GameServiceConstants.CM_FIND_TREASURE:
					handlerCM_FIND_TREASURE();
					break;
				default :
					break;
			}

			super.resolveData(proc, data);
		}

        private function handlerSM_FIND_TREASURE_GET(data:ByteArray):void
        {
            treasureGetDatas = new Vector.<TreasureGetData>();
            var size:int = data.readInt();
            while (size--)
            {
                var getData:TreasureGetData = new TreasureGetData();
                getData.id = data.readInt();
                getData.born_sid = data.readInt();
                getData.type = data.readByte();
                getData.count = data.readInt();
                treasureGetDatas.push(getData);
            }

            var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_TREASURE_REWARD_ALERT);
            if (panel)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_TREASURE_REWARD_ALERT);
            }
            PanelMediator.instance.openPanel(PanelConst.TYPE_TREASURE_REWARD_ALERT);
        }

		/**成功寻宝后提示*/
		private function handlerCM_FIND_TREASURE():void
		{
			if (_tipCounts > 0)
			{
				var msg:String = StringUtil.substitute(StringConst.PANEL_DRAGON_TREASURE_021, _tipCounts);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, msg);
				_tipCounts = 0;
			}
		}

		private function handlerCM_GET_FIND_TREASURE_STORAGE(data:ByteArray):void
		{
			DragonTreasureManager.lastSlotMc = null;
            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.PANEL_DRAGON_ERROR_3);
		}

		private function handlerSM_FIND_TREASURE_EVENT(data:ByteArray):void
		{
			treasureEvtDatas = new Vector.<TreasureEventData>();
			var len:int = data.readInt();
			while (len--)
			{
				var info:TreasureEventData = new TreasureEventData();
				info.cid=data.readInt();
				info.sid=data.readInt();
				info.name = data.readUTF();
				info.itemId = data.readInt();
				info.itemType = data.readByte();
				info.bornSid = data.readInt();
				treasureEvtDatas.push(info);
			}
			var equipCount:int = data.readInt();
			while (equipCount--)
			{
				var job:int = data.readByte();
				var onlyId:int = data.readInt();
				var bornSid:int = data.readInt();
				if (!dic[bornSid])
				{
					dic[bornSid] = new Dictionary();
				}
				var memEquipData:MemEquipData = dic[bornSid][onlyId];
				if (!memEquipData)
				{
					memEquipData = new MemEquipData();
					memEquipData.onlyId = onlyId;
					memEquipData.bornSid = bornSid;
					dic[memEquipData.bornSid][memEquipData.onlyId] = memEquipData;
				}
				memEquipData.baseId = data.readInt();
				memEquipData.duralibility = data.readInt();
				memEquipData.strengthen = data.readByte();
				memEquipData.polish = data.readByte();
				memEquipData.polishExp = data.readShort();
				memEquipData.bind = data.readByte();
				memEquipData.goodLuck = data.readInt();
				var attrRds:Vector.<AttrRandomData> = new Vector.<AttrRandomData>();
				var attrRdCount:int = data.readInt();
				memEquipData.attrRdCount = attrRdCount;
				memEquipData.attrRdStars = 0;
				var attrRdMaxStar:int;
				while (attrRdCount--)
				{
					var index:int = data.readByte();//洗炼属性的属性下标，为1字节有符号整形
					var star:int = data.readByte();//洗炼星级，为1字节有符号整形
					var type:int = data.readByte();//属性加成为1.值加成 2.百分比，为1字节有符号整形
					var addon_rate:int = data.readInt();//属性加成数，为4字节有符号整形
					if (index)
					{
						var attrRdDt:AttrRandomData = new AttrRandomData();
						attrRds.push(attrRdDt);
						attrRdDt.star = star;
						var attrDt:PropertyData = CfgDataParse.getPropertyDatas(index + ":" + type + ":" + addon_rate, false, null, job)[0];
						attrRdDt.attrDt = attrDt;
						memEquipData.attrRdStars += star;
						attrRdMaxStar < star ? attrRdMaxStar = star : null;
					}
					else
					{
						attrRds.push(null);
					}
				}
				memEquipData.attrRdMaxStar = attrRdMaxStar;
				memEquipData.setAttrRds(attrRds);
			}
		}

		public function getMemEquipData(bornSid:int, onlyId:int):MemEquipData
		{
			if (!dic[bornSid])
			{
				return null;
			}
			return dic[bornSid][onlyId];
		}

		/**寻宝仓库信息*/
		private function handlerSM_FIND_TREASURE_STORAGE(data:ByteArray):void
		{
            if (storageDatas)
            {
                storageDatas.forEach(function (element:StorageDataInfo, index:int, vec:Vector.<StorageDataInfo>):void
                {
                    element = null;
                });
                storageDatas.length = 0;
            }
			var len:int = data.readInt();
			while (len--)
			{
				var info:StorageDataInfo = new StorageDataInfo();
				info.slot = data.readInt();
				info.id = data.readInt();
				info.born_sid = data.readInt();
				info.type = data.readByte();
				info.count = data.readInt();
				info.bind = data.readByte();
				info.extra = data.readInt();
				storageDatas.push(info);
			}

		}

		/**解析我的积分*/
		private function handlerSM_FIND_TREASURE(data:ByteArray):void
		{
			score = data.readInt();
		}

		override public function clearDataManager():void
		{
			_instance = null;
		}

		private static var _instance:DragonTreasureManager = null;
		public static function get instance():DragonTreasureManager
		{
			if (_instance == null)
			{
				_instance = new DragonTreasureManager();
			}
			return _instance;
		}

		public function sendMakeUp():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FIND_TREASURE_STORAGE_CLEARUP, data);
			data = null;
		}
	}
}
