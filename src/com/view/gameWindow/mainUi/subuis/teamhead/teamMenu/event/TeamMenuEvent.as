package com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.event
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

/**
 * Created by Administrator on 2014/11/17.
 */
public class TeamMenuEvent extends Event
{
    public static const SELECT_MENU_ITEM:String = "select_menu_item";
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

    public function TeamMenuEvent(type:String, param:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
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
