package com.view.gameWindow.panel.panels.stronger.common
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;

    import flash.utils.Dictionary;
    import flash.utils.describeType;

    /**
     * Created by Administrator on 2014/12/23.
     */
    public class PanelSkipManager
    {
        private var _lastType:String;
        private var _keys:Dictionary;

        public function PanelSkipManager()
        {
            initMap();
        }

        private function initMap():void
        {
            _keys = new Dictionary(true);
            for each(var item:XML in describeType(PanelType).child("constant"))
            {
                _keys[PanelType[String(item.@name)]] = String(item.@name);
            }
        }

        /**
         * @panelName  PanelType里的常量
         * @tabIndex   从1开始
         * */
        public function skipToPanel(panelType:int, tabIndex:int):void
        {
            if (panelType in _keys)
            {
                var panelKey:String = PanelConst[_keys[panelType]];
                if (_lastType)
                {
                    PanelMediator.instance.closePanel(_lastType);
                }
                specialHandler(panelKey, tabIndex);
                PanelMediator.instance.openDefaultIndexPanel(panelKey, tabIndex);
                _lastType = panelKey;
            } else
            {
                throw  new ArgumentError("panelType illegal");
            }
        }

        /**有些面板需要特殊处理*/
        private function specialHandler(panelKey:String, index:int):void
        {
            switch (panelKey)
            {
                case PanelConst.TYPE_CLOSET:
                    ClosetDataManager.instance.setDefaultIndex(index);
                    break;
                case PanelConst.TYPE_DAILY:
                    DgnDataManager.instance.queryChrDungeonInfo();
                    break;
                case PanelConst.TYPE_WELFARE:
                    WelfareDataMannager.instance.querySign();
                    break;
                default :
                    break;
            }
            return;
        }

        private static var _instance:PanelSkipManager = null;
        public static function get instance():PanelSkipManager
        {
            if (_instance == null)
            {
                _instance = new PanelSkipManager();
            }
            return _instance;
        }
    }
}
