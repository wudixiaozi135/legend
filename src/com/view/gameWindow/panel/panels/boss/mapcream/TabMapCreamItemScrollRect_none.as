package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.MCMapCreamBossItem;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	 
	public class TabMapCreamItemScrollRect_none implements IScrollee
	{
		 
		private var _skin:MCMapCreamBossItem;
		private var _parent:TabMapCreamBoss;
		
		private var _items:Vector.<TabMapCreamItemTxtItem>;
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _contentHeight:int;
		private var _rsloader:RsrLoader;
		//private var num:int = 0;
		public function TabMapCreamItemScrollRect_none(parent:TabMapCreamBoss,skin:MCMapCreamBossItem,rsloader:RsrLoader)
		{
			_parent = parent;
			_skin = skin;
			_rsloader = rsloader;
			init();
		}

		public function get items():Vector.<TabMapCreamItemTxtItem>
		{
			return _items;
		}

		private function init():void
		{
			_items = new Vector.<TabMapCreamItemTxtItem>();
			_scrollRect = new Rectangle(0,0,_skin.mcScrollLayer.width,_skin.mcScrollLayer.height);
			_skin.mcScrollLayer.scrollRect = _scrollRect;
			 
		}
		
		internal function initScrollBar(mc:MovieClip):void
		{
			if(!_scrollBar)
			{
				_scrollBar = new ScrollBar(this,mc);
			}
			
			_scrollBar.resetHeight(_scrollRect.height);
			//var bool:Boolean = num>4;
			//_scrollBar.setVisible(bool);
		}
		
		public function refresh(data:Vector.<MapCreamItemNode>):void
		{
 
			_contentHeight = 0;
			var item:TabMapCreamItemTxtItem;
			var itemData:MapCreamItemNode;
			if(_items.length == data.length)
			{
				for(var i:int = 0;i<_items.length;i++)
				{
					itemData = data[i] as MapCreamItemNode;
					item = _items[i] as TabMapCreamItemTxtItem;
					item.refresh(itemData);
				}
			}
			else
			{
				clearItems();
				for (var j:int = 0;j<data.length;j++)
				{
					itemData = data[j] as MapCreamItemNode;
					item = new TabMapCreamItemTxtItem(_parent);
					_rsloader.loadItemRes(item.skin.mcState.mc);
					item.index = j;
					item.skin.x = 4;
					item.skin.y = _contentHeight ;
					_contentHeight += item.skin.height;	
					item.refresh(itemData);
					_skin.mcScrollLayer.addChild(item.skin);
					_items.push(item);
				}
			}
			
			
			
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
			}
			
			 
		}
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			_skin.mcScrollLayer.scrollRect = _scrollRect;
		}
		
		public function get contentHeight():int
		{
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
		private function clearItems():void
		{
			var item:TabMapCreamItemTxtItem;
			for each(item in _items)
			{
				if(item)
				{
					item.destroy();
				}
			}
			_items.length = 0;
		}
		internal function destroy():void
		{
			
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
				_scrollBar.destroy();
				_scrollBar = null;
			}
			var item:TabMapCreamItemTxtItem;
			for each(item in _items)
			{
				if(item)
				{
					item.destroy();
				}
			}
			_scrollBar = null;
			_items.length = 0;
			_items = null;
			 
		}
	}
}