package com.view.gameWindow.panel.panels.forge.compound.slider
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.McFactory;
	import com.view.gameWindow.common.MouseOverEffectManager;
	import com.view.gameWindow.panel.panels.forge.compound.CombineData;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	public class List2 extends Sprite
	{
		private var _itemFactory:McFactory;
		private var _itemSetCallback:Function;
		private var _itemClassList:Array;
		private var _dataList:Vector.<CombineData>;
		private var _overMgr:MouseOverEffectManager;
		/**clickCallback(index:int,data:Object,target:DisplayObject);*/
		public var clickCallback:Function;
		
		public var slider:CompoundItemSlider;
		private var _selectedIndex:int = -1;
		private var _lastSelected:DisplayObject = null;
		private var _selectedItem:Object = null;
		
		/**@see #clickCallback*/
		public function List2()
		{
			super();
		}
		
		public function get selectedItem():Object
		{
			return _selectedItem;
		}
		
		public function set selectedItem(value:Object):void
		{
			_selectedItem = value;
			var index:int = _dataList.indexOf(_selectedItem);
			selectedIndex = index;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			updateSelectedState();
		}
		
		protected function updateSelectedState():void
		{
			var selectedItem:DisplayObject = null;
			
			if(_selectedIndex >= 0)
			{
				if(_selectedIndex < _itemClassList.length)
				{
					selectedItem = _itemClassList[_selectedIndex];
					_selectedItem = _dataList[_selectedIndex];
				}
				else
				{
					_selectedIndex = -1;
				}
			}
			
			if(selectedItem != _lastSelected)
			{
				if(_overMgr)
				{
					if(_lastSelected)
					{
						_overMgr.setSelected(_lastSelected,false);
					}
					
					if(selectedItem)
					{
						_overMgr.setSelected(selectedItem,true);
					}
				}
				_lastSelected = selectedItem;
			}
		}
		
		public function drawBorder(thickness:int,color:int):void
		{
			graphics.clear();
			graphics.lineStyle(thickness,color);
			graphics.beginFill(0,0);
			graphics.drawRect(-thickness,-thickness,width+thickness,height+thickness);
			graphics.endFill();
		}
		
		/**
		 * itemSetCallback(index:int,data:Object,target:DisplayObject);
		 */
		public function setStyle(itemClass:Class,itemSetCallback:Function,itemCallback:Object):void
		{
			_itemFactory = new McFactory(itemClass);
			_itemFactory.prefixUrl = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD;
			_itemFactory.callbacks = itemCallback;
			_itemSetCallback = itemSetCallback;
		}
		
		public function clear():void
		{
			for each(var item:DisplayObject in _itemClassList)
			{
				_overMgr.remove(item);
				
				item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
				if(item.parent)
				{
					item.parent.removeChild(item);
				}
			}
			_dataList = new Vector.<CombineData>;
			_itemClassList = [];
			_overMgr = null;
		}
		
		public function get data():Vector.<CombineData>
		{
			return _dataList;
		}
		
		public function set data(value:Vector.<CombineData>):void
		{
			clear();
			
			if(value)
			{
				_dataList = value;
			}
			else
			{
				_dataList = new Vector.<CombineData>;
			}
			
			var index:int = 0;
			for each(var data:CombineData in value)
			{
				var item:MovieClip = _itemFactory.create();
				
				if(!_overMgr)
				{
					_overMgr = new MouseOverEffectManager(1,item.width,item.height);
				}
				
				_overMgr.add(item);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler,false,0,true);
				changeHeadNum(item,data.canCombineNum);
				item.txt.htmlText = HtmlUtils.createHtmlStr(data.color,data.name);
				
				addChild(item);
				_itemClassList.push(item);
			}
			
			updatePos();
			updateSelectedState();
		}
		
		private function changeHeadNum(mc:MovieClip,num:int):void
		{
			if(num>0)
			{
				mc.numTxt.text=StringUtil.substitute(StringConst.NUM_MSG,num);
			}
			else
			{
				mc.numTxt.text="";
			}
		}
		
		
		private function itemClickHandler(e:MouseEvent):void
		{
			var target:Object = e.currentTarget;
			var index:int = _itemClassList.indexOf(target);
			selectedIndex = index;
			if(parent)
			{
				var itemList:ItemList = parent as ItemList;
				slider.setSelectedType(itemList.type,itemList.type2);
			}
			
			if(clickCallback!=null)
			{
				clickCallback(index,_dataList[index],target);
			}
		}
		
		public function changeNum(data:Vector.<CombineData>):void
		{
			var head:MovieClip;
			var num:int;
			for(var i:int=0;i<data.length;i++)
			{
				head=_itemClassList[i];
				num=data[i].canCombineNum;
				changeHeadNum(head,num);
			}
		}
		
		public function updatePos():void
		{
			var y:Number = 0;
			for each(var item:DisplayObject in _itemClassList)
			{
				item.y = y;
				y+=item.height;
			}
		}
	}
}