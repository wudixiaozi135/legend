package com.view.gameWindow.panel.panels.stronger.data
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    /**
     * Created by Administrator on 2014/11/17.
     */
    public class StrongerEvent extends Event
    {
        /**改变选项*/
        public static const SWITCH_TAB:String = "switch_tab";

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

        public function StrongerEvent(type:String, param:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.param = param;
        }

        public var param:Object;

        public static function dispatchEvent(event:Event):Boolean
        {
            return _dispatcher.dispatchEvent(event);
        }
    }
}
