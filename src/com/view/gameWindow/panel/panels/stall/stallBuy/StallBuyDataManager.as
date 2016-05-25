package com.view.gameWindow.panel.panels.stall.stallBuy
{
    import com.view.gameWindow.panel.panels.stall.data.StallDataInfo;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallBuyDataManager
    {
        public static var bagData:StallDataInfo;

        public function StallBuyDataManager()
        {
        }

        private static var _instance:StallBuyDataManager = null;
        public static function get instance():StallBuyDataManager
        {
            if (_instance == null)
            {
                _instance = new StallBuyDataManager();
            }
            return _instance;
        }
    }
}
