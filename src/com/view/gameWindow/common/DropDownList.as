package com.view.gameWindow.common
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.TextMenu;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.events.Request;
	
	
	/**
	 * 按钮都在flash中，这里只是管理下 。 Event.CHANGE
	 * @author wqhk
	 * 2014-10-15
	 */
	public class DropDownList extends Sprite
	{
		protected var btnDisplay:DisplayObject;
		protected var labelDisplay:DisplayObject;
		private var prompt:String = "";
		private var label:TextField = null;
		private var labelField:String = "";
		private var _selectedItem:* = null;
		private var _selectedIndex:int = -1;

		private var menu:TextMenu;
		private var data:Array;
		private var _width:int;
		
		public function DropDownList(data:Array,label:TextField,width:int,labelDisplay:DisplayObject = null,btnDisplay:DisplayObject = null,prompt:String = "")
		{
			this.labelDisplay = labelDisplay;
			this.prompt = prompt;
			this.label = label;
			this.btnDisplay = btnDisplay;
			this.data = data.concat();
			_width = width;
			
			updateLabel();
			init();
		}
		
		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex != value&&data!=null)
			{
				_selectedIndex = value;
				_selectedItem = data[_selectedIndex];
				updateLabel();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function setSelectedIndex(value:int):void
		{
			if(_selectedIndex != value&&data!=null)
			{
				_selectedIndex = value;
				_selectedItem = data[_selectedIndex];
				updateLabel();
			}
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function get selectedItem():*
		{
			return _selectedItem;
		}
		
		protected function updateLabel():void
		{
			if(_selectedIndex == -1)
			{
				label.text = prompt;
			}
			else
			{
				label.text = getItemTxt(_selectedItem);
			}
		}
		
		protected function getItemTxt(item:*):String
		{
			if(labelField)
			{
				return item[labelField];
			}
			else
			{
				return item;
			}
		}
		
		protected function getTxtList(items:Array):Array
		{
			var re:Array = [];
			for each(var item:* in items)
			{
				var txt:String = getItemTxt(item);
				re.push(txt);
			}
			
			return re;
		}
		
		protected function init():void
		{
			if(labelDisplay)
			{
				labelDisplay.addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
			}
			
			if(btnDisplay)
			{
				btnDisplay.addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
			}
		}
		
		public function destroy():void
		{
			destroyMenu();
			
			if(labelDisplay)
			{
				labelDisplay.removeEventListener(MouseEvent.CLICK,clickHandler);
				labelDisplay = null;
			}
			
			if(btnDisplay)
			{
				btnDisplay.removeEventListener(MouseEvent.CLICK,clickHandler);
				btnDisplay = null;
			}
			_selectedItem = null;
			label = null;
			data = null;
		}
		
		
		
		private function clickHandler(e:MouseEvent):void
		{
			var list:Array = getTxtList(data);
			
			if(!menu)
			{
				menu = new TextMenu(list,_width);
				
				var pos:Point = new Point(MenuMediator.instance.mouseX,MenuMediator.instance.mouseY);
				
				if(labelDisplay && labelDisplay.parent)
				{
					pos = labelDisplay.parent.localToGlobal(new Point(labelDisplay.x,labelDisplay.y+labelDisplay.height));
				}
				
				menu.x = pos.x;
				menu.y = pos.y;
				menu.addEventListener(Event.SELECT,menuSelecthandler,false,0,true);
				MenuMediator.instance.showMenu(menu);
			}
		}
		
		private function destroyMenu():void
		{
			if(menu)
			{
				menu.removeEventListener(Event.SELECT,menuSelecthandler);
				MenuMediator.instance.hideMenu(menu);
				menu = null;
			}
		}
		
		protected function menuSelecthandler(e:Request):void
		{
			destroyMenu();
			
			var index:int = int(e.value);
			
			if(index >= 0)
			{
				selectedIndex = index;
			}
		}
		
	}
}