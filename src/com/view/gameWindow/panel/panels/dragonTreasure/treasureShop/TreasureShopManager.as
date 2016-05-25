package com.view.gameWindow.panel.panels.dragonTreasure.treasureShop
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TreasureShopCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.dragonTreasure.event.DragonTreasureEvent;
	import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.data.TreasureShopData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	import mx.utils.StringUtil;

	/**
	 * Created by Administrator on 2014/12/2.
	 */
	public class TreasureShopManager extends DataManagerBase
	{
		public static var selectIndex:int = 0;
		public static var lastMc:MovieClip;
		private var _shopConfigDic:Dictionary;

		private static var _currentPage:int = 1;
		private static var _totalPage:int;

		public static var buyData:TreasureShopCfgData;


		///////////服务下发的信息
		public var itemShopDatas:Dictionary;

		public function TreasureShopManager()
		{
			initData();
			DistributionManager.getInstance().register(GameServiceConstants.SM_GET_FIND_TREASURE_LIMIT_NUM, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BUY_FIND_TREASURE_SHOP, this);
		}


		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_GET_FIND_TREASURE_LIMIT_NUM:
					handlerSM_GET_FIND_TREASURE_LIMIT_NUM(data);
					break;
				case GameServiceConstants.CM_BUY_FIND_TREASURE_SHOP:
					successBuy();
					break;
				default :
					break;
			}
			super.resolveData(proc, data);
		}

		private function successBuy():void
		{
			var data:TreasureShopCfgData = TreasureShopManager.buyData;
			if (data)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.PANEL_DRAGON_TIP_3, data.cost_value));
				TreasureShopManager.buyData = null;
			}
		}

		private function handlerSM_GET_FIND_TREASURE_LIMIT_NUM(data:ByteArray):void
		{
			itemShopDatas = new Dictionary();
			var len:int = data.readInt();
			while (len--)
			{
				var info:TreasureShopData = new TreasureShopData();
				info.id = data.readInt();
				info.num = data.readInt();
				itemShopDatas[info.id] = info;
			}
		}

		private function initData():void
		{
			_shopConfigDic = new Dictionary(true);
			var dic:Dictionary = ConfigDataManager.instance.findTreasureShop();
			for each(var cfg:TreasureShopCfgData in dic)
			{
				_shopConfigDic[cfg.shelf] = _shopConfigDic[cfg.shelf] || new Vector.<TreasureShopCfgData>();
				_shopConfigDic[cfg.shelf].push(cfg);
			}
		}

		/**通过货架Id获取数据*/
		public function getVecCfgByShelf(shelfId:int):Vector.<TreasureShopCfgData>
		{
			_shopConfigDic[shelfId] = _shopConfigDic[shelfId] || new Vector.<TreasureShopCfgData>();
			return _shopConfigDic[shelfId].sort(function (item1:TreasureShopCfgData, item2:TreasureShopCfgData):int
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

		/** 请求限购次数*/
		public function sendCM_GET_FIND_TREASURE_LIMIT_NUM():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_FIND_TREASURE_LIMIT_NUM, data);
			data = null;
		}

		/**寻宝商店购买*/
		public function sendCM_BUY_FIND_TREASURE_SHOP(id:int, count:int):void
		{

			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(id);
			data.writeInt(count);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BUY_FIND_TREASURE_SHOP, data);
			data = null;
		}
		
		private static var _instance:TreasureShopManager = null;
		public static function get instance():TreasureShopManager
		{
			if (_instance == null)
			{
				_instance = new TreasureShopManager();
			}
			return _instance;
		}

		public static function get currentPage():int
		{
			return _currentPage;
		}

		public static function set currentPage(value:int):void
		{
			_currentPage = value;
			DragonTreasureEvent.dispatchEvent(new DragonTreasureEvent(DragonTreasureEvent.CHANGE_PAGE, {
				currentPage: _currentPage,
				totalPage: _totalPage
			}));
		}

		public static function get totalPage():int
		{
			return _totalPage;
		}

		public static function set totalPage(value:int):void
		{
			_totalPage = value;
			DragonTreasureEvent.dispatchEvent(new DragonTreasureEvent(DragonTreasureEvent.CHANGE_PAGE, {
				currentPage: _currentPage,
				totalPage: _totalPage
			}));
		}

		override public function clearDataManager():void
		{
			_instance = null;
		}

		public function dealTreasureShopPanel():void
		{
			var panel:PanelTreasureShop = PanelMediator.instance.openedPanel(PanelConst.TYPE_DRAGON_TREASURE_SHOP) as PanelTreasureShop;
			if (!panel)
			{
				sendCM_GET_FIND_TREASURE_LIMIT_NUM();
				PanelMediator.instance.openPanel(PanelConst.TYPE_DRAGON_TREASURE_SHOP);
			} else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_DRAGON_TREASURE_SHOP);
			}
		}
	}
}
