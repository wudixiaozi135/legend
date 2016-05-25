package com.view.gameWindow.common
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	
	/**
	 * 极其简陋的Orz……
	 * @author wqhk
	 * 2014-9-18
	 */
	public class List extends Sprite implements IScrollee
	{
		private var _content:Sprite;
		private var _itemFactory:McFactory;


		private var _itemSetCallback:Function;
		private var _itemList:Array;
		private var _dataList:Array;
		private var _overMgr:MouseOverEffectManager;
		private var _maxItemNum:int;
		private var _minItemNum:int;
		private var _defaultItemWidth:Number;
		private var _defaultItemHeight:Number;
		private var _scrollRect:Rectangle;
		private var _itemHeight:Number;
		private var _itemWidth:Number;
		
		/**
		 * clickCallback(index:int,data:Object,target:DisplayObject);
		 */
		public var clickCallback:Function;
		
		//11.7加上了滚动条 
		private var _scrollbar:ScrollBar;
		private var _load:RsrLoader;
		private var _scrollbarView:MovieClip;
		
		//11.7加上选择
		private var _selectedIndex:int = -1;
		private var _lastSelected:DisplayObject = null;
		private var _selectable:Boolean = false;
		private var _selectedItem:Object = null;
		
		private var _alwaysShowScrollbar:Boolean = false;
		private var _classType:Class = MouseOverEffectManager;

		
		public function set classType(value:Class):void
		{
			_classType = value;
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

		public function get selectable():Boolean
		{
			return _selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			updateSelectedState();
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
			if(!selectable)
			{
				if(_lastSelected)
				{
					if(_overMgr)
					{
						_overMgr.setSelected(_lastSelected,false);
					}
					_lastSelected = null;
				}
				return;
			}
			
			var selectedItem:DisplayObject = null;
			
			if(_selectedIndex >= 0)
			{
				if(_selectedIndex < _itemList.length)
				{
					selectedItem = _itemList[_selectedIndex];
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
		
		
		/**
		 * @param minItemNum 最小个数（确定默认高度用）
		 * @param defaultItemWidth 未加滚动条的宽度
		 * @param defaultItemHeight  minItemNum 乘 defaultItemHeight
		 * @param maxItemNum 最大个数 （滚动条用），简化 把 height也屏蔽， 直接设置height 不会出现滚动条
		 * @param scrollerSkinType 滚动条资源类   生成的对象有 view变量（view才是带resUrl的组件）
		 * @see #clickCallback
		 */
		public function List(maxItemNum:int = -1,scrollerSkinType:Class = null,minItemNum:int = -1,defaultItemWidth:Number = 0,defaultItemHeight:Number = 0)
		{
			_content = new Sprite();
			addChild(_content);
			
			_maxItemNum = maxItemNum;
			_minItemNum = minItemNum;
			
			if(_minItemNum != -1)
			{
				_alwaysShowScrollbar = true;
			}
			
			_defaultItemWidth = defaultItemWidth;
			_defaultItemHeight = defaultItemHeight;
			_itemWidth = _defaultItemWidth;
			_itemHeight = _defaultItemHeight;
			_scrollRect = new Rectangle();
			_itemList = [];
			_dataList = [];
			
			if(maxItemNum != -1 && scrollerSkinType != null)
			{
				_load = new RsrLoader();
				var skin:MovieClip = new scrollerSkinType();
				_load.addCallBack(skin.view,scrollerSkinLoadCompleteHandler);
				_load.load(skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			}
			
			super();
		}
		
		override public function set height(value:Number):void
		{
			super.height = height;
		}
		
		private function scrollerSkinLoadCompleteHandler(mc:MovieClip):void
		{
			_scrollbarView = mc;
			_scrollbar = new ScrollBar(this,mc,0,this);
			updateScrollBarView();
		}
		
		private function updateScrollBarView():void
		{
			if(_scrollbar)
			{
				if(_scrollbar.height != height)
				{
					_scrollRect.height = height;
					
					if(_scrollbarView)
					{
						_scrollRect.width = _itemWidth + _scrollbarView.width;
					}
					else
					{
						_scrollRect.width = _itemWidth;
					}
					
					_scrollbarView.x = _itemWidth;
					_scrollbarView.y = 0;
					addChild(_scrollbarView);	
					_scrollbar.resetHeight(height);
				}
				
				if(!_alwaysShowScrollbar)
				{
					_scrollbar.setVisible(_scrollbar.scrollable);
				}
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
		public function setStyle(itemClass:Class,itemSetCallback:Function,itemCallback:Object,clickWord:String = ""):void
		{
			_itemFactory = new McFactory(itemClass);
			_itemFactory.prefixUrl = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD;
			_itemFactory.callbacks = itemCallback;
			_itemSetCallback = itemSetCallback;
			_clickWord = clickWord;
		}
		
		private var _clickWord:String = "";//临时增加 如果以后多个 再处理
		
		public function clear():void
		{
			for each(var item:DisplayObject in _itemList)
			{
				_overMgr.remove(item);
				
				item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
				if(item.parent)
				{
					item.parent.removeChild(item);
				}
			}
			_dataList = [];
			_itemList = [];
			_overMgr = null;
		}
		
		public function destroy():void
		{
			clear();
			if(_load)
			{
				_load.destroy();
				_load = null;
			}
		}
		
		public function get data():Array
		{
			return _dataList.concat();
		}
		
		public function set data(value:Array):void
		{
			clear();
			
			if(value)
			{
				_dataList = value.concat();
			}
			else
			{
				_dataList = [];
			}
			
			var index:int = 0;
			_itemHeight = _defaultItemHeight;
			_itemWidth = _defaultItemWidth;
			for each(var data:Object in _dataList)
			{
				var item:MovieClip = _itemFactory.create();
				_itemHeight = item.height;
				_itemWidth = item.width;
				item.addEventListener(MouseEvent.CLICK,itemClickHandler,false,0,true);
				
				_content.addChild(item);
				_itemList.push(item);
				
//				if(_itemSetCallback != null)
//				{
//					_itemSetCallback(index,data,item);
//				}
				updateItemAt(index);
				
				if(!_overMgr)
				{
					_overMgr = new _classType(1,item.width,item.height);
				}
				
				_overMgr.add(item);
				
				++index;
			}
			
			updatePos();
			
			updateSelectedState();
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
            if(stage){
                if(stage.focus!=stage){
                    stage.focus=stage;
                }
            }
			var target:Object = e.currentTarget;
			var index:int = _itemList.indexOf(target);
			
			selectedIndex = index;
			if(clickCallback!=null)
			{
				if(_clickWord == "")
				{
					clickCallback(index,_dataList[index],target);
				}
				else
				{
					if(e.target == target[_clickWord])
					{
						clickCallback(index,_dataList[index],target,_clickWord);
					}
					else
					{
						clickCallback(index,_dataList[index],target,"");
					}
				}
			}
		}
		
		/**
		 * 更新单个项
		 */
		public function updateItemAt(index:int):void
		{
			if(_itemSetCallback != null)
			{
				var view:DisplayObject = getItemView(index);
				var data:Object = getItemData(index);
				
				if(view && data)
				{
					_itemSetCallback(index,data,view);
				}
			}
		}
		
		public function updateItems():void
		{
			if(_itemSetCallback != null)
			{
				for(var i:int = 0; i < _dataList.length; ++i)
				{
					updateItemAt(i);
				}
			}
		}
		
		protected function getItemData(index:int):Object
		{
			if(index>=0 && index < _dataList.length)
			{
				return _dataList[index];
			}
			
			return null;
		}
		
		protected function getItemView(index:int):DisplayObject
		{
			if(index>=0 && index < _itemList.length)
			{
				return _itemList[index];
			}
			
			return null;
		}
		
		private var _contentHeight:Number = 0;
		
		public function updatePos():void
		{
			var y:Number = 0;
			for each(var item:DisplayObject in _itemList)
			{
				item.y = y;
				y+=item.height;
			}
			
			_contentHeight = y;
			updateScrollBarView();
		}
		
		override public function get height():Number
		{
			if(_minItemNum != -1)
			{
				return _minItemNum*_itemHeight;
			}
			
			if(_maxItemNum != -1)
			{
				var h:Number = _maxItemNum*_itemHeight;
				
				return Math.min(h,contentHeight);
			}
			
			return contentHeight;
		}
		
		/**
		 * 
		 * @param pos 被滚动内容的scrollRect的y坐标
		 */		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			_content.scrollRect = _scrollRect;
		}
		public function get contentHeight():int
		{
//			return _content.height;
			return _contentHeight;
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
	}
}