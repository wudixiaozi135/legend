package com.view.gameWindow.panel.panels.school.complex.shop
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    /**
     * Created by Administrator on 2014/11/17.
     */
    public class SchoolShopEvent extends Event
    {
        /**切换标签页*/
        public static const SWITCH_TAB:String = "switch_tab";
        /**查看所有物品信息*/
        public static const VIEW_ALL_GOODS:String = "view_all_goods";
        /**寻宝商店翻页*/
        public static const CHANGE_PAGE:String = "change_page";

        private static var _dispatcher:IEventDispatcher = new EventDispatcher();

        public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            _dispatcher.removeEventListener(type, listener, useCapture);
        }

        public static function hasEventListener(type:String):Boolean
        {
            return _dispatcher.hasEventListener(type);
        }

        public static function willTrigger(type:String):Boolean
        {
            return _dispatcher.willTrigger(type);
        }

        public function SchoolShopEvent(type:String, param:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this._param = param;
        }

        public var _param:Object;

        public static function dispatchEvent(event:Event):Boolean
        {
            return _dispatcher.dispatchEvent(event);
        }
    }
}
