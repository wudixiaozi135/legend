package com.event
{
    /**
     * Created by Administrator on 2015/2/6.
     */

    import flash.events.Event;

    public class GameEvent extends Event
    {
        public var param:Object;

        public function GameEvent(type:String, param:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.param = param;
        }

        override public function clone():Event
        {
            return new GameEvent(type, param, bubbles, cancelable);
        }

        override public function toString():String
        {
            return "type>>" + type + " param>>" + param + " bubbles>>" + bubbles + " cancelable>>" + cancelable;
        }
    }
}
