package com.view.gameWindow.panel.panels.menus.others
{
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.menu.BagCellMenuItem;
	import com.view.gameWindow.panel.panels.bag.menu.McBagCellMenu;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MenuRoundBg
	{
		private var _layer:MovieClip;
		private var _x:int;
		public function get x():int
		{
			return _x;
		}
		public function set x(value:int):void
		{
			_x = value;
			_menuBg.x = _x;
			var i:int,l:int = _list.length;
			for(i=0;i<l;i++)
			{
				var item:BagCellMenuItem = _items[i];
				item.x = _x + 2;
			}
		}
		private var _y:int;
		public function get y():int
		{
			return _y;
		}
		public function set y(value:int):void
		{
			_y = value;
			_menuBg.y = _y;
			var i:int,l:int = _list.length;
			for(i=0;i<l;i++)
			{
				var item:BagCellMenuItem = _items[i];
				item.y = _y+4+i*18;
			}
		}
		public function get width():int
		{
			return _menuBg.width;
		}
		public function get height():int
		{
			return _menuBg.height;
		}
		private var _list:Vector.<int>;
		private var _callBack:Function;
		private var _tips:Vector.<String>;
		//
		private var _items:Vector.<BagCellMenuItem>;
		private var _menuBg:McBagCellMenu;
		
		public function MenuRoundBg(layer:MovieClip,list:Vector.<int>,callBack:Function,tips:Vector.<String> = null)
		{
			_layer = layer;
			_list = list;
			_callBack = callBack;
			_tips = tips;
			//
			_layer.addEventListener(MouseEvent.ROLL_OVER,onRollOver,true);
			_layer.addEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
			//
			_menuBg = new McBagCellMenu();
			_layer.addChild(_menuBg);
			_menuBg.width -= 5;
			_menuBg.visible = false;
			//
			var i:int,l:int = _list.length;
			_items = new Vector.<BagCellMenuItem>(l,true);
			for(i=0;i<l;i++)
			{
				var type:int = _list[i];
				var item:BagCellMenuItem = new BagCellMenuItem(type);
				_layer.addChild(item);
				_items[i] = item;
				if(_tips)
				{
					setToolTip(_items[i],_tips[i]);
				}
				item.visible = false;
				item.buttonMode = true;
			}
			_menuBg.__id0_.height = 18*l+8;
		}
		
		protected function onAdded2Stage(event:Event):void
		{
			_layer.removeEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
			_layer.stage.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function setToolTip(mc:DisplayObject,str:String):void
		{
			var tipVo:TipVO = new TipVO();
			tipVo.tipType = ToolTipConst.TEXT_TIP;
			tipVo.tipData = str;
			ToolTipManager.getInstance().hashTipInfo(mc,tipVo);
			ToolTipManager.getInstance().attach(mc);
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			var item:BagCellMenuItem = event.target as BagCellMenuItem;
			if(item)
			{
				_menuBg.mcSelect.y = item.y - 1 - _y;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var item:BagCellMenuItem = event.target as BagCellMenuItem;
			if(!item)
			{
				if(_menuBg.visible == true)
				{
					visible = false;
				}
				return;
			}
			for(var i:int = 0;i<_items.length;i++)
			{
				if(item == _items[i])
				{
					_callBack.call(null,i);
					setListVisible(event);
				}
			}
		}
		
		public function setListVisible(event:MouseEvent):void
		{
			visible = !_menuBg.visible;
			event.stopImmediatePropagation();
		}
		
		private function set visible(value:Boolean):void
		{
			for(var i:int = 0;i<_items.length;i++)
			{
				_items[i].visible = value;
			}
			_menuBg.visible = value;
		}
		
		public function destroy():void
		{
			_menuBg.parent.removeChild(_menuBg);
			var item:BagCellMenuItem;
			for each(item in _items)
			{
				ToolTipManager.getInstance().detach(item);
				item.parent.removeChild(item);
			}
			_tips = null;
			_callBack = null;
			_list = null;
			_layer.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,true);
			_layer.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onClick);
			_layer = null;
		}
	}
}