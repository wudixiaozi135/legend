package com.view.gameWindow.panel.panels.exchangeShop
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.StoneExchangeShopCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.exchangeShop.data.ExchangeCostType;
    import com.view.gameWindow.panel.panels.exchangeShop.data.ExchangeShopData;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;

    import flash.display.Bitmap;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
     * Created by Administrator on 2015/3/12.
     */
    public class ExchangeShopDataManager extends DataManagerBase
    {

        public var stoneExchangeShop:StoneExchangeShopCfgData;
        public static var buyItemBmp:Bitmap;

        //服务端回传数据
        public var exchangeShopDatas:Vector.<ExchangeShopData> = new Vector.<ExchangeShopData>();
        public var exchangeCount:int = 0;//已兑换次数
        public var refreshCount:int = 0;//免费刷新次数

        /**刷新时间数组*/
        private var _refreshTimeArr:Array;
        public function ExchangeShopDataManager()
        {
            super();
            stoneExchangeShop = ConfigDataManager.instance.stoneExchangeShopCfgData(1);
            _refreshTimeArr=stoneExchangeShop.refresh_time.split(":");

            DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_EXCHANGR_SHOP, this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EXCHANGR_SHOP_BY_EXCHANGE, this);
        }
        /**刷新时间数组*/
        public function getRefreshTimeArr():Array
        {
            return _refreshTimeArr;
        }
        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_QUERY_EXCHANGR_SHOP:
                    handlerSM_QUERY_EXCHANGR_SHOP(data);
                    break;
                default :
                    break;
            }
            super.resolveData(proc, data);
        }

        private function handlerSM_QUERY_EXCHANGR_SHOP(data:ByteArray):void
        {
            if (exchangeShopDatas)
            {
                exchangeShopDatas.forEach(function (element:ExchangeShopData, index:int, vec:Vector.<ExchangeShopData>):void
                {
                    element = null;
                });
                exchangeShopDatas.length = 0;
            }
            var size:int = data.readByte();
            var exchangeData:ExchangeShopData = null;
            while (size--)
            {
                exchangeData = new ExchangeShopData();
                exchangeData.index = data.readByte();
                exchangeData.groupId = data.readInt();
                exchangeData.itemIndex = data.readInt();
                exchangeData.state = data.readByte();
                exchangeShopDatas.push(exchangeData);
            }
            exchangeCount = data.readInt();
            refreshCount = data.readInt();
        }

        /*
         * 检查今日免费刷新次数
         * true 有刷新次数 false 没有刷新次数
         * */
        public function checkHasFreeRefreshCount():Boolean
        {
            if (stoneExchangeShop)
            {
                var vipLv:int = VipDataManager.instance.lv;
                var vipCount:int = 0;
                if (vipLv > 0)
                {
                    vipCount = ConfigDataManager.instance.vipCfgData(vipLv).add_refresh_num;
                }
                return (stoneExchangeShop.daily_num + vipCount - refreshCount) > 0;
            }
            return false;
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }

        /**查询信息*/
        public function sendCM_QUERY_EXCHANGR_SHOP():void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_EXCHANGR_SHOP, byte);
            byte = null;
        }

        public function sendRefresh():void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EXCHANGR_SHOP_REFRESH, byte);
            byte = null;
        }

        /**兑换物品*/
        public function sendExchangeItem(index:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeByte(index);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EXCHANGR_SHOP_BY_EXCHANGE, byte);
            byte = null;
        }

        public function dealSwitchPanel():void
        {
			if(GuideSystem.instance.isUnlock(UnlockFuncId.EQUIP_STONE_SHOP))
			{
	            var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_EXCHANGE_SHOP);
	            if (!panel)
	            {
	                sendCM_QUERY_EXCHANGR_SHOP();
	                PanelMediator.instance.openPanel(PanelConst.TYPE_EXCHANGE_SHOP);
	            } else
	            {
	                PanelMediator.instance.closePanel(PanelConst.TYPE_EXCHANGE_SHOP);
	            }
			}
			else
			{
				var tip:String = GuideSystem.instance.getUnlockTip(UnlockFuncId.EQUIP_STONE_SHOP);
				Alert.warning(tip);
			}
        }

        public function getCostStr(type:int):String
        {
            var costName:String = "";
            if (type == ExchangeCostType.COST_GOLD)
            {
                costName = StringConst.EXCHANGE_SHOP_008;
            } else if (type == ExchangeCostType.COST_TICKET)
            {
                costName = StringConst.EXCHANGE_SHOP_009;
            } else if (type == ExchangeCostType.COST_MEDAL)
            {
                costName = StringConst.EXCHANGE_SHOP_0010;
            }
            return costName;
        }

        private static var _instance:ExchangeShopDataManager = null;
        public static function get instance():ExchangeShopDataManager
        {
            if (_instance == null)
            {
                _instance = new ExchangeShopDataManager();
            }
            return _instance;
        }
    }
}
