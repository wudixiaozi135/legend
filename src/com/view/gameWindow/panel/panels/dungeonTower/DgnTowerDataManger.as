package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DgnEventCfgData;
	import com.model.configData.cfgdata.DgnRewardMultipleCfgData;
	import com.model.configData.cfgdata.DgnShopCfgData;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.consts.DungeonConst;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilNumChange;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	/**
	 * 塔防副本数据管理类
	 * @author Administrator
	 */	
	public class DgnTowerDataManger extends DataManagerBase
	{
		private static var _instance:DgnTowerDataManger;
		public static function get instance():DgnTowerDataManger
		{
			return _instance ||= new DgnTowerDataManger(new PrivateClass());
		}
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		public const guards:Array = [ItemType.IT_GUARD_THUNDER,ItemType.IT_GUARD_FIRE,ItemType.IT_GUARD_ICE,ItemType.IT_GUARD_POSION];
		/**副本id*/
		public var dungeonId:int = 541;
		/**阶段*/
		public var step:int;
		/**剩余怪物数量*/
		public var nMonster:int;
		/**获得经验*/
		public var expGain:int;
		public function get expGainScale():Number
		{
			return expGain/expTotal;
		}
		/**丢失经验*/
		public var expLost:int;
		public function get expLostScale():Number
		{
			return expLost/expTotal;
		}
		/**总经验*/
		public const expTotal:int = 5000000;
		/**召唤塔的数量*/
		public var summonCount:int;
		/**防御守卫上限*/
		public var summonTotal:int = 15;
		/**选中的倍率项*/
		public var index:int;
		/**要兑换的令牌itemId*/
		public var exchange:int;
		/**购买后是否自动放置守卫*/
		public var isAutos:Dictionary;
		/**事件触发时间*/
		public var timeEventStart:int;
		/**当前波触发事件*/
		public var timeStepStart:int;
		
		private var _multipleCfgDts:Vector.<DgnRewardMultipleCfgData>;
		
		private var _isOver:Boolean;
		
		public function get isInMainDgnTower():Boolean
		{
			var dungeonId:int = DgnDataManager.instance.dungeonId;
			var dungeonCfgData:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeonId);
			if(dungeonCfgData && dungeonCfgData.func_type == DungeonConst.FUNC_TYPE_MAIN_TOWER)
			{
				return true;
			}
			return false;
		}
		
		public function get isInDgnTower():Boolean
		{
			var dungeonId:int = DgnDataManager.instance.dungeonId;
			var dungeonCfgData:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeonId);
			if(dungeonCfgData && dungeonCfgData.func_type == DungeonConst.FUNC_TYPE_TOWER)
			{
				return true;
			}
			return false;
		}
		
		public function DgnTowerDataManger(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_TOWER_DUNGEON_EXP,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_TOWER_DUNGEON_EXP,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_DUNGEON_SHOP_BUY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TOWER_DUNGEON_STEP_PROGRESS,this);
			//
			assignMultipleCfgDts();
			//
			isAutos = new Dictionary();
		}
		
		private function assignMultipleCfgDts():void
		{
			_multipleCfgDts = new Vector.<DgnRewardMultipleCfgData>();
			var cfgDts:Dictionary = ConfigDataManager.instance.dungeonRewardMultipleCfgData(dungeonId);
			var cfgDt:DgnRewardMultipleCfgData;
			for each (cfgDt in cfgDts) 
			{
				_multipleCfgDts.push(cfgDt);
			}
			_multipleCfgDts.sort(function(item1:DgnRewardMultipleCfgData,item2:DgnRewardMultipleCfgData):int
			{
				return item1.multiple - item2.multiple;
			});
		}
		
		public function get multipleCfgDts():Vector.<DgnRewardMultipleCfgData>
		{
			return _multipleCfgDts;
		}
		/**是否开始刷怪*/
		public function get isStart():Boolean
		{
			return step != 0;
		}
		/**当前选中倍率的奖励经验*/
		public function get expGainMultiple():int
		{
			return expGainMultipleBy(index);
		}
		
		public function cmEnterDungeon():void
		{
			dungeonId = 541;
			DgnDataManager.instance.cmEnterDungeon(dungeonId);
		}
		/**请求塔防副本经验（用于NPC面板上显示）*/
		public function cmQueryTowerDungeonExp():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_TOWER_DUNGEON_EXP,byteArray);
		}
		/**客户端触发事件协议*/
		public function cmSendDungeonEvnet():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SEND_DUNGEON_EVENT,byteArray);
			timeEventStart = getTimer();
		}
		/**获取塔防经验*/
		public function cmGetTowerDungeonExp(multiple:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(multiple);//领取倍率，1字节有符号整形
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_TOWER_DUNGEON_EXP,byteArray);
		}
		/**副本商店购买*/
		public function cmDungeonShopBuy():void
		{
			var cfgDt:DgnShopCfgData = dgnShopCfgData(exchange);
			if(!cfgDt)
			{
				trace("DgnTowerDataManger.cmDungeonShopBuy() DgnShopCfgData配置信息不存在");
				return;
			}
			if(expGain < cfgDt.exp)
			{
				var itemCfg:ItemCfgData = itemCfgData(exchange);
				var utilNumChange:UtilNumChange = new UtilNumChange();
				var changeNum:String = utilNumChange.changeNum(cfgDt.exp);
				var str:String = StringConst.DGN_TOWER_0032.replace("&x",itemCfg.name).replace("&y",changeNum);
				str = HtmlUtils.createHtmlStr(0xffcc00,str);
				IncomeDataManager.instance.addOneLine(str);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(exchange);//道具id，4字节有符号整形
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DUNGEON_SHOP_BUY,byteArray);
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_EXCHANGE);
		}
		/**使用令牌*/
		public function cmItemUse(itemId:int):void
		{
			if(summonCount >= summonTotal)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0038);
				return;
			}
			var str:String = StringConst.DGN_TOWER_0037.replace("&x",summonTotal-summonCount-1);
			str = HtmlUtils.createHtmlStr(0xffcc00,str);
			IncomeDataManager.instance.addOneLine(str);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);
			BagDataManager.instance.dealItemUse(itemId);
		}
		/**离开副本*/
		public function cmLeaveDungeon():void
		{
			if(_isOver)
			{
				leave();
			}
			else
			{
				Alert.show2(StringConst.DGN_GOALS_022,leave);
			}
			function leave():void
			{
				var dgnCfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeonId);
				var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(dgnCfgDt ? dgnCfgDt.region : 0);
				var mapId:int = SceneMapManager.getInstance().mapId;
				if(mapRegionCfgData && mapRegionCfgData.map_id == mapId)
				{
					DgnGoalsDataManager.instance.requestCancel();
					reset();
				}
			}
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				default:
					break;
				case GameServiceConstants.CM_DUNGEON_SHOP_BUY:
					dealCmDungeonShopBuy(data);
					break;
				case GameServiceConstants.SM_TOWER_DUNGEON_EXP:
					dealSmTowerDungeonExp(data);
					break;
				case GameServiceConstants.CM_GET_TOWER_DUNGEON_EXP:
					dealCmGetTowerDungeonExp(data);
					break;
				case GameServiceConstants.SM_TOWER_DUNGEON_STEP_PROGRESS:
					dealSmTowerDungeonStepProgress(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealCmDungeonShopBuy(byteArray:ByteArray):void
		{
			/*var itemCfgData:ItemCfgData = itemCfgData(exchange);
			var str:String = StringConst.DGN_TOWER_0035.replace("&x",itemCfgData.name);
			str = HtmlUtils.createHtmlStr(0xffcc00,str);
			IncomeDataManager.instance.addOneLine(str);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);
			RollTipMediator.instance.showRollTip(RollTipType.PLACARD,StringConst.DGN_TOWER_0036);*/
			var dgnShopCfg:DgnShopCfgData = dgnShopCfgData(exchange);
			var itemCfg:ItemCfgData = itemCfgData(exchange);
			var str:String = StringConst.DGN_TOWER_0041.replace("&x",dgnShopCfg ? dgnShopCfg.exp : 0).replace("&y",itemCfg ? itemCfg.name : 0);
			str = HtmlUtils.createHtmlStr(0xffcc00,str);
			IncomeDataManager.instance.addOneLine(str);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);
			var boolean:Boolean = isAutos[exchange] as Boolean;
			if(boolean)
			{
				cmItemUse(exchange);
			}
			var indexOf:int = guards.indexOf(exchange);
			if(indexOf > -1)
			{
				FlyEffectMediator.instance.doFlyDgnExchange(indexOf);
			}
		}
		/**可获取的经验（用于显示）*/
		private function dealSmTowerDungeonExp(byteArray:ByteArray):void
		{
			expGain = byteArray.readInt();//4字节有符号整形,经验值
			var dgnCfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeonId);
			var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(dgnCfgDt ? dgnCfgDt.region : 0);
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(mapRegionCfgData && mapRegionCfgData.map_id == mapId && isStart && expGain)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_TOWER_REWARD);
				_isOver = true;
			}
		}
		/**获取经验成功返回*/
		private function dealCmGetTowerDungeonExp(byteArray:ByteArray):void
		{
			expGain = 0;
			/*var exp:int = byteArray.readInt();//获取经验值，4字节有符号整形
			RollTipMediator.instance.showRollTip(RollTipType.REWARD,StringConst.DGN_TOWER_0027+exp);*/
		}
		/**副本阶段信息下发*/
		private function dealSmTowerDungeonStepProgress(byteArray:ByteArray):void
		{
			dungeonId = byteArray.readInt();//副本id，4字节有符号整形
			var stepTemp:int = byteArray.readByte();//阶段，1字节有符号整形
			var stepNew:int = stepTemp < 1 ? 0 : stepTemp - 1;
			dealStep(stepNew);
			step = stepNew;
			/*step = */byteArray.readInt();//事件id，4字节有符号整形
			nMonster = byteArray.readShort();//剩余怪物数量，2字节有符号整形
			var expGainNew:int = byteArray.readInt();//获得经验，4字节有符号整形
			dealExpGain(expGainNew);
			expGain = expGainNew;
			expLost = byteArray.readInt();//丢失经验，4字节有符号整形
			summonCount = byteArray.readByte();//召唤塔的数量，1字节有符号整形
		}
		
		private function dealStep(stepNew:int):void
		{
			if(stepNew > step && stepNew <= stepTotal)
			{
				timeStepStart = getTimer();
			}
		}
		
		private function dealExpGain(expGainNew:int):void
		{
			var expGainAdd:int = expGainNew - expGain;
			if(expGainAdd > 0)
			{
				var str:String = StringConst.DGN_TOWER_0039.replace("&x",expGainAdd > 0 ? "+"+expGainAdd : expGainAdd).replace("&y",expGainNew);
				str = HtmlUtils.createHtmlStr(0xffcc00,str);
				IncomeDataManager.instance.addOneLine(str);
				/*RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);*/
			}
		}
		
		public function reset():void
		{
			dungeonId = 541;
			step = 0;
			nMonster = 0;
			summonCount = 0;
			index = 0;
			timeEventStart = 0;
			timeStepStart = 0;
			_isOver = false;
		}
		
		public function dgnCfgDt():DungeonCfgData
		{
			var cfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeonId);
			return cfgDt;
		}
		
		public function dgnEventCfgDt():DgnEventCfgData
		{
			var cfgDt:DgnEventCfgData = ConfigDataManager.instance.dungeonEventCfgData(dungeonId,1);
			return cfgDt;
		}
		/**阶段总数*/
		public function get stepTotal():int
		{
			var stepTotal:int;
			var dt:DgnEventCfgData;
			var dts:Dictionary = ConfigDataManager.instance.dungeonEventCfgDatas(dungeonId);
			for each (dt in dts)
			{
				stepTotal++;
			}
			return stepTotal < 2 ? 1 : stepTotal-1;//去除最后一个结束事件
		}
		
		public function dgnRewardMultipleCfgDt(index:int):DgnRewardMultipleCfgData
		{
			return _multipleCfgDts[index];
		}
		
		public function expGainMultipleBy(index:int):int
		{
			var cfgDt:DgnRewardMultipleCfgData = dgnRewardMultipleCfgDt(index);
			if(cfgDt)
			{
				return expGain * cfgDt.multiple;
			}
			else
			{
				return expGain;
			}
		}
		
		public function dgnShopCfgData(itemId:int):DgnShopCfgData
		{
			var cfgDt:DgnShopCfgData = ConfigDataManager.instance.dgnShopCfgData(dungeonId,itemId);
			return cfgDt;
		}
		
		public function itemCfgData(itemId:int):ItemCfgData
		{
			var cfgDt:ItemCfgData = ConfigDataManager.instance.itemCfgData(itemId);
			return cfgDt;
		}
	}
}
class PrivateClass{}