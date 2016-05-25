package com.view.gameWindow.panel.panels.stronger
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.StrongerCfgData;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;

    import flash.display.MovieClip;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2014/12/22.
     */
    public class StrongerDataManager
    {
        /**我要变强里的子标签*/
        public static const TITLE_1:int = 1;
        /**我要变强里的子标签*/
        public static const TITLE_2:int = 2;


        public static var selectIndex:int = -1;//默认不选中
        public static var lastMc:MovieClip;

        private var _map:Dictionary;

        public function StrongerDataManager()
        {
            _map = new Dictionary(true);
        }

        public function dealSwitchPanleStronger():void
        {
            PanelMediator.instance.switchPanel(PanelConst.TYPE_BECOME_STRONGER);
        }

        /**
         * @type 主标签 1到8
         * @title 次标签 1或2
         * */
        public function getDatasByTypeAndTitle(type:int, title:int):Vector.<StrongerCfgData>
        {
            if (!_map[type])
            {
                _map[type] = new Dictionary(true);
            }
            if (!_map[type][title])
            {
                _map[type][title] = new Vector.<StrongerCfgData>();
            }
            var vec:Vector.<StrongerCfgData> = _map[type][title];
            if (vec.length > 0)
            {
                return vec;
            }
            var dic:Dictionary = ConfigDataManager.instance.strongerCfgData(type, title);
            for each(var cfg:StrongerCfgData in dic)
            {
                vec.push(cfg);
            }
            if (vec.length > 0)
            {
                return vec;
            }
            return null;
        }

        private static var _instance:StrongerDataManager = null;
        public static function get instance():StrongerDataManager
        {
            if (_instance == null)
            {
                _instance = new StrongerDataManager();
            }
            return _instance;
        }
    }
}
