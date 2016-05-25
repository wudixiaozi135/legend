package com.event
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    /**
     * Created by Administrator on 2015/2/6.
     * 可用于模块间派发
     */
    public class GameDispatcher
    {
        private static var _dispatcher:IEventDispatcher = new EventDispatcher();

        public function GameDispatcher()
        {
        }

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

        public static function dispatchEvent(eventName:String, param:Object = null, bubbles:Boolean = false, cancelable:Boolean = false):Boolean
        {
            return _dispatcher.dispatchEvent(new GameEvent(eventName, param, bubbles, cancelable));
        }
    }
}
