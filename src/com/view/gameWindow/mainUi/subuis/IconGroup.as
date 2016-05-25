package com.view.gameWindow.mainUi.subuis
{
    import com.event.GameDispatcher;
    import com.event.GameEvent;
    import com.event.GameEventConst;

    import flash.display.DisplayObject;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2015/3/28.
     */
    public class IconGroup
    {
        private var _newWidth:int;
        private var _icons:Array;
        private var _dic:Dictionary;

        public function IconGroup()
        {
            _icons = [];
            _dic = new Dictionary(true);
            GameDispatcher.addEventListener(GameEventConst.ICON_CHANGE, onHandlerEvt, false, 0, true);
        }

        private function onHandlerEvt(event:GameEvent):void
        {
            refresh();
        }

        public function addIcon(obj:DisplayObject):void
        {
            if (_dic[obj]) return;
            _icons.push(obj);
        }

        public function removeIcon(obj:DisplayObject):void
        {
            var item:* = _dic[obj];
            if (!item) return;

            var pos:int = _icons.indexOf(obj);
            if (pos == -1) return;
            _icons.splice(pos, 1);

            delete _dic[obj];
            _dic[obj] = null;
            obj = null;
        }

        private function refresh():void
        {
            var icon:DisplayObject;
            var initW:int = 61;
            var hgap:int = 4;
            var startX:Number = 440;
            for (var i:int = 0, len:int = _icons.length; i < len; i++)
            {
                icon = _icons[i];
                if (icon.visible)
                {
                    icon.x = _newWidth - startX;
                    icon.y = 130;
                    startX += initW + hgap;
                }
            }
        }

        public function resize(newWidth:int):void
        {
            if (_newWidth != newWidth)
            {
                _newWidth = newWidth;
                refresh();
            }
        }

        private static var _instance:IconGroup = null;
        public static function get instance():IconGroup
        {
            if (_instance == null)
            {
                _instance = new IconGroup();
            }
            return _instance;
        }

    }
}
