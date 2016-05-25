package com.view.gameWindow.panel.panels.stall.stallSell
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagData;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallSellDataManager
    {
        public static var bagData:BagData;

        public function StallSellDataManager()
        {

        }

        public function dealPanelStallSell():void
        {
            PanelMediator.instance.openPanel(PanelConst.TYPE_STALL_SELL);

        }

        private static var _instance:StallSellDataManager = null;
        public static function get instance():StallSellDataManager
        {
            if (_instance == null)
            {
                _instance = new StallSellDataManager();
            }
            return _instance;
        }
    }
}
