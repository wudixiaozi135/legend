package com.view.gameWindow.panel.panels.school.complex.shop
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.SchoolShopCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
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
    public class SchoolShopManager extends DataManagerBase
    {
        public static var selectIndex:int = 0;
        public static var lastMc:MovieClip;
        private var _shopConfigDic:Dictionary;
        private var _shopType:int = 0;//默认只有一个货架
        private static var _currentPage:int = 1;
        private static var _totalPage:int;

        public static var buyData:SchoolShopCfgData;


        ///////////服务下发的信息
        public var itemShopDatas:Dictionary;//存放限购的物品

        public function SchoolShopManager()
        {
            DistributionManager.getInstance().register(GameServiceConstants.SM_GET_FAMILY_LIMIT_NUM, this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BUY_FAMILY_SHOP, this);
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_GET_FAMILY_LIMIT_NUM:
                    handlerSM_GET_FAMILY_LIMIT_NUM(data);
                    break;
                case GameServiceConstants.CM_BUY_FAMILY_SHOP:
                    successBuy();
                    break;
                default :
                    break;
            }
            super.resolveData(proc, data);
        }

        private function successBuy():void
        {
            var data:SchoolShopCfgData = SchoolShopManager.buyData;
            if (data)
            {
                RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.SCHOOL_PANEL_5018, data.cost_value));
                SchoolShopManager.buyData = null;
            }
        }

        private function handlerSM_GET_FAMILY_LIMIT_NUM(data:ByteArray):void
        {
            itemShopDatas = new Dictionary();
            var len:int = data.readInt();
            while (len--)
            {
                var info:SchoolShopData = new SchoolShopData();
                info.id = data.readInt();
                info.num = data.readInt();
                itemShopDatas[info.id] = info;
            }
        }

        private function initData():void
        {
            _shopConfigDic = _shopConfigDic || new Dictionary(true);
            var dic:Dictionary = ConfigDataManager.instance.schoolShopDatas();
            for each(var cfg:SchoolShopCfgData in dic)
            {
                _shopConfigDic[_shopType] = _shopConfigDic[_shopType] || new Vector.<SchoolShopCfgData>();
                _shopConfigDic[_shopType].push(cfg);
            }
        }

        /**通过货架Id获取数据*/
        public function getVecCfgByShelf(shelfId:int = 0):Vector.<SchoolShopCfgData>
        {
            initData();
            return _shopConfigDic[shelfId].sort(function (item1:SchoolShopCfgData, item2:SchoolShopCfgData):int
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
        public function sendCM_GET_FAMILY_LIMIT_NUM():void
        {
            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_FAMILY_LIMIT_NUM, data);
            data = null;
        }

        /**帮会商店购买*/
        public function sendCM_BUY_FAMILY_SHOP(id:int, count:int):void
        {

            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            data.writeInt(id);
            data.writeInt(count);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BUY_FAMILY_SHOP, data);
            data = null;
        }

        private static var _instance:SchoolShopManager = null;
        public static function get instance():SchoolShopManager
        {
            if (_instance == null)
            {
                _instance = new SchoolShopManager();
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
            SchoolShopEvent.dispatchEvent(new SchoolShopEvent(SchoolShopEvent.CHANGE_PAGE, {
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
            SchoolShopEvent.dispatchEvent(new SchoolShopEvent(SchoolShopEvent.CHANGE_PAGE, {
                currentPage: _currentPage,
                totalPage: _totalPage
            }));
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }
    }
}
