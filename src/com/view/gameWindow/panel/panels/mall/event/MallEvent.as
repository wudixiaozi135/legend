package com.view.gameWindow.panel.panels.mall.event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * Created by Administrator on 2014/11/17.
	 */
	public class MallEvent extends Event
	{
		/**改变页数*/
		public static const CHANGE_PAGE:String = "change_total_page";
		/**改变购买数量*/
		public static const CHANGE_BUY_COUNT:String = "change_buy_count";

		public static const CHANGE_GIVE_COUNT:String = "change_give_count";

		/**选择了某个好友*/
		public static const SELECT_FRIEND:String = "select_friend";
		/**搜索物品*/
		public static const SEARCH_GOODS:String = "search_goods";
		/**限购物品*/
		public static const LIMIT_GOODS:String = "limit_goods";


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

		public function MallEvent(type:String, param:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
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
