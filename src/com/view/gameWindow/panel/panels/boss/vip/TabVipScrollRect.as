package com.view.gameWindow.panel.panels.boss.vip
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.MCVIPBoss;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class TabVipScrollRect implements IScrollee
	{
		private var _parent:TabVipViewHandle;
		private var _rsloader:RsrLoader;
		private var _skin:MCVIPBoss;
		private var _scrollRect:Rectangle;
		
		private var _scrollBar:ScrollBar;
		
		private var _contentHeight:int;
		
		private var _items:Array = [];
		public function TabVipScrollRect(parent:TabVipViewHandle,skin:MCVIPBoss,rsloader:RsrLoader)
		{
			_parent = parent;
			_rsloader = rsloader;
			_skin = skin;
			init();
		}
		
		private function init():void
		{
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
			_scrollBar.scrollTo(0);
		}
		 
		
		public function refresh(data:Array):void
		{
			_contentHeight = 0;
			var item:VipBossItem;
			var itemData:VipBossItemData;
			if(_items.length == data.length)
			{
				for(var i:int = 0;i<_items.length;i++)
				{
					itemData = data[i] as VipBossItemData;
					item = _items[i] as VipBossItem;
					item.refresh(itemData);
				}
			}
			else
			{
				clearItems();
				for (var j:int = 0;j<data.length;j++)
				{
					itemData = data[j] as VipBossItemData;
					item = new VipBossItem(_parent);
					item.init(_rsloader);
					item.skin.x = 5;
					item.skin.y = _contentHeight;
					_contentHeight += item.skin.height - 1;	
					item.refresh(itemData);
					_skin.mcScrollLayer.addChild(item.skin);
					_items.push(item);
				}
			}
			
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
				_scrollBar.scrollTo(0);
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
			var item:VipBossItem;
			for each(item in _items)
			{
				if(item)
				{
					item.destroy();
				}
			}
		}
		
		internal function destroy():void
		{
			clearItems(); 
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
				_scrollBar.destroy();
				_scrollBar = null;
			}
			_skin = null;
			_items.length = 0;
			_items = null;
		}
	}
}