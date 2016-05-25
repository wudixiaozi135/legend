package com.view.gameWindow.panel.panels.mall.mallacquire.data
{
    import com.view.gameWindow.panel.panels.mall.constant.MallAcquireType;
    import com.view.gameWindow.panel.panels.mall.constant.ShopCostType;

    /**
     * Created by Administrator on 2014/11/22.
     */
    public class AcquireManager
    {
        public static var costType:int;

        private static var _instance:AcquireManager = null;

        public static function get instance():AcquireManager
        {
            if (_instance == null)
            {
                _instance = new AcquireManager();
            }
            return _instance;
        }

        public function AcquireManager()
        {
        }

        public function getIdByType(type:int):int
        {
            var announceId:int;
            switch (type)
            {
                case ShopCostType.TYPE_GOLD:
                    announceId = MallAcquireType.TYPE_GOLD_ID;
                    break;
                case ShopCostType.TYPE_TICKET:
                    announceId = MallAcquireType.TYPE_TICKET_ID;
                    break;
                case ShopCostType.TYPE_SCORE:
                    announceId = MallAcquireType.TYPE_SCORE_ID;
                    break;
                default :
                    break;
            }
            return announceId;
        }
    }
}
