package com.view.gameWindow.mainUi.subuis.income
{
    import flash.utils.ByteArray;

    /**
     * Created by Administrator on 2015/3/4.
     * 为数值型物品备用
     */
    public class SpecialPromptManager
    {
        private var _itemId:int;//物品id
        private var _count:int;//物品数量
        public function SpecialPromptManager()
        {
        }

        public function resolveData(data:ByteArray):void
        {
            _itemId = data.readInt();
            _count = data.readInt();
            refresh();
            data.clear();
            data = null;
        }

        private function refresh():void
        {
        }

        public function get itemId():int
        {
            return _itemId;
        }

        public function get count():int
        {
            return _count;
        }

        private static var _instance:SpecialPromptManager = null;
        public static function get instance():SpecialPromptManager
        {
            if (_instance == null)
            {
                _instance = new SpecialPromptManager();
            }
            return _instance;
        }
    }
}
