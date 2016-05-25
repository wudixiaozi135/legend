package com.view.gameWindow.panel.panels.mall
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.GameShopCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.SkillCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.friend.ContactEntry;
    import com.view.gameWindow.panel.panels.mall.constant.ShopShelfType;
    import com.view.gameWindow.panel.panels.mall.event.MallEvent;
    import com.view.gameWindow.panel.panels.mall.mallbuy.PanelMallBuy;
    import com.view.gameWindow.panel.panels.mall.mallbuy.data.MallBuyData;
    import com.view.gameWindow.panel.panels.mall.tab.mallSortByOrder;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.ObjectUtils;

    import flash.display.MovieClip;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import mx.utils.StringUtil;

    /**
	 * Created by Administrator on 2014/11/19.
	 */
	public class MallDataManager extends DataManagerBase
	{
        public static var defaultIndex:int = 0;
        public static var defaultPage:int = 1;
		private static var _currentPage:int = 1;//限购物品的容器
		public static var lastTab:MovieClip;//上交选择按钮
		public static function get currentPage():int
		{
			return _currentPage;
		}

		public static function set currentPage(value:int):void
		{
			if (_currentPage != value)
			{
				_currentPage = value;
			}
			MallEvent.dispatchEvent(new MallEvent(MallEvent.CHANGE_PAGE, {currentPage: _currentPage, totalPage: MallDataManager.totalPage}));
		}

		private static var _totalPage:int;

		public static function get totalPage():int
		{
			return _totalPage;
		}//默认选中的索引

		public static function set totalPage(value:int):void
		{
			if (_totalPage != value)
			{
				_totalPage = value;
			}
			MallEvent.dispatchEvent(new MallEvent(MallEvent.CHANGE_PAGE, {currentPage: MallDataManager.currentPage, totalPage: _totalPage}));
		}

		private static var _instance:MallDataManager = null;

		public static function get instance():MallDataManager
		{
			if (_instance == null)
			{
				_instance = new MallDataManager();
			}
			return _instance;
		}

		public function MallDataManager()
		{
			_shopConfigDic = new Dictionary(true);
			limitGoods = new Dictionary(true);
			initData();
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BUY_SHOP_ITEM, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GIVE_FRIEND_ITEM, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_GET_CHR_LIMIT_NUM, this);
			super();
		}

		public var limitGoods:Dictionary;
		private var _shopConfigDic:Dictionary;

		private var _friendEntry:ContactEntry;

		public function get friendEntry():ContactEntry
		{
			return _friendEntry;
		}

		public function set friendEntry(value:ContactEntry):void
		{
			_friendEntry = value;
		}

		private var _selectIndex:int = 0;

		public function get selectIndex():int
		{
			return _selectIndex;
		}

		public function set selectIndex(value:int):void
		{
			_selectIndex = value;
		}

		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				default :
					break;
				case GameServiceConstants.SM_GET_CHR_LIMIT_NUM:
					handlerData(data);
					break;
				case GameServiceConstants.CM_BUY_SHOP_ITEM:
					successHandler();
					break;
				case GameServiceConstants.CM_GIVE_FRIEND_ITEM:
					RollTipMediator.instance.showRollTip(RollTipType.PROPERTY, StringConst.MALL_GIVE_MESSAGE_2);
					break;
			}
			super.resolveData(proc, data);
		}

		override public function clearDataManager():void
		{
			_instance = null;
		}
		
		public function getTotalPage(shelfId:int):int
		{
			var list:Vector.<GameShopCfgData> = getVecCfgByShelf(shelfId);
			var total:int = ObjectUtils.getTotalPage(list.length,getPageSize());
			return total;
		}
		
		public function getPageSize():int
		{
			return 9;
		}
		
		public function getPageIndex(shelfId:int,shopId:int):int
		{
			var list:Vector.<GameShopCfgData> = getVecCfgByShelf(shelfId);
			
			var size:int = getPageSize();
			var itemIndex:int = getItemIndex(shelfId,shopId);
			if(itemIndex != -1)
			{
				var index:int = itemIndex/size;
				return index;
			}
			
			return -1;
		}
		
		public function getItemIndex(shelfId:int,shopId:int):int
		{
			var list:Vector.<GameShopCfgData> = getVecCfgByShelf(shelfId);
			
			for(var i:int = 0; i < list.length; ++i)
			{
				var data:GameShopCfgData = list[i];
				if(data.id == shopId)
				{
					return i;
				}
			}
			
			return -1;
		}

		/**通过货架Id获取数据*/
		public function getVecCfgByShelf(shelfId:int):Vector.<GameShopCfgData>
		{
			_shopConfigDic[shelfId] = _shopConfigDic[shelfId] || new Vector.<GameShopCfgData>();
			mallSortByOrder(_shopConfigDic[shelfId]);
			return _shopConfigDic[shelfId];
		}
		
		public function getShelfOrder(shefId:int):int
		{
			var labs:Array = [ShopShelfType.TYPE_HOT_SELL,
				ShopShelfType.TYPE_STRENGTH,
				ShopShelfType.TYPE_GEM,
				ShopShelfType.TYPE_MEDICINE,
				ShopShelfType.TYPE_SKILL,
				ShopShelfType.TYPE_TICKET,
				ShopShelfType.TYPE_SCORE,
				ShopShelfType.TYPE_FASHION,
				ShopShelfType.TYPE_LIMIT_BUY];
			
			var len:int = 0;
			var index:int = 0;
			
			for each(var lab:int in labs)
			{
				len = MallDataManager.instance.getVecCfgByShelf(lab).length;
				if (len > 0)
				{
					if(shefId == lab)
					{
						return index;
					}
					++index;
				}
			}
			
			return 0;
		}
		
		public function getShopCfgDataBySkillId(id:int):GameShopCfgData
		{
			if(!id)
			{
				return null;
			}
			
			var skill:SkillCfgData = ConfigDataManager.instance.skillCfgData1(id);
			
			if(!skill || !skill.book)
			{
				return null;
			}
			
			var list:Vector.<GameShopCfgData> = getVecCfgByShelf(ShopShelfType.TYPE_SKILL);
			for each(var data:GameShopCfgData in list)
			{
				if(data.item_id == skill.book)
				{
					return data;
				}
			}
			
			return null;
		}

		private function successHandler():void
		{
			var data:GameShopCfgData = MallBuyData.buyData;
			var buyCount:int = MallBuyData.buyCount;
			if (data) {
				var costType:String = StringConst["MALL_COST_TYPE_" + data.cost_type];
				var costValue:String = (data.cost_value * buyCount).toString();
				var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(data.item_id);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.MALL_BUY_MESSAGE_8, itemCfg.name + "x" + buyCount, costType + " " + costValue));

				var panel:PanelMallBuy = PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL_BUY) as PanelMallBuy;
				if (panel) {
					panel.mouseHandler.closeHandler();
				}
			}
		}

		private function handlerData(data:ByteArray):void
		{
			var limitId:int = data.readInt();//限购物品的id
			var limitCount:int = data.readInt();//限购物品的次数
			limitGoods[limitId] = limitCount;
			MallEvent.dispatchEvent(new MallEvent(MallEvent.LIMIT_GOODS));
		}

		private function initData():void
		{
			var dic:Dictionary = ConfigDataManager.instance.gameShopCfgData();
			for each(var cfg:GameShopCfgData in dic)
			{
				_shopConfigDic[cfg.shelf] = _shopConfigDic[cfg.shelf] || new Vector.<GameShopCfgData>();
				_shopConfigDic[cfg.shelf].push(cfg);
			}
		}
	}
}
