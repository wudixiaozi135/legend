package com.view.gameWindow.panel.panels.menus
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.List;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.Request;
	
	/**
	 * 文本菜单
	 * 
	 * Event.SELECT
	 * @author wqhk
	 * 2014-10-14
	 */
	public class TextMenu extends MenuBase
	{
		private static const PADDING:int = 5;
		private var _items:Array;
		private var _list:List;
		private var _width:int;
		private var _mc:McTextMenu;
		public function TextMenu(items:Array,width:int = 0)
		{
			super();
			_items = items.concat();
			_width = width;
		}
		
		override protected function initSkin():void
		{
			_mc = new McTextMenu();
			_skin = _mc;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
			rsrLoader.addCallBack(_mc.bg,function():void{updateSize();});
		}
		
		override protected function initData():void
		{
			itemNum = _items.length;
			
			if(!_list)
			{
				_list = new List();
				_list.x = PADDING;
				_list.y = PADDING;
				_list.setStyle(McTextItem,itemSetCallback,null);
				_list.clickCallback = menuClickHandler;
			}
			_list.data = _items;
			addChild(_list);
			updateSize();
		}
		
		protected function updateSize():void
		{
			_skin.width = _list.width+PADDING*2;
			_skin.height = _list.height+PADDING*2;
			if(_skin.bg)
			{
				_skin.bg.width = _skin.width;
				_skin.bg.height = _skin.height;
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			
		}
		
		protected function itemSetCallback(index:int,data:Object,target:DisplayObject):void
		{
			Object(target).txt.htmlText = data;
			
			if(_width > 0)
			{
				Object(target).txt.width = _width - PADDING*2;
			}
		}
		
		private function menuClickHandler(index:int,data:Object,target:DisplayObject):void
		{
			dispatchEvent(new Request(Event.SELECT,false,false,createSelectedData(index)));
		}
		
		override protected function onItemClick(e:MouseEvent):void
		{
			trace("tt");
		}
	}
}