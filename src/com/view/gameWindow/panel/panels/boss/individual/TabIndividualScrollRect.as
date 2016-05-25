package com.view.gameWindow.panel.panels.boss.individual
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.MCIndividualBoss;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class TabIndividualScrollRect implements IScrollee
	{
		
		private var _rsloader:RsrLoader;	
		private var _scrollBar:ScrollBar;	
		private var _scrollRect:Rectangle;
		private var _skin:MCIndividualBoss;
		private var _parent:TabIndividualViewHandle;
		
		private var _contentHeight:int =0;
		
		private var _items:Array =[];
		public function TabIndividualScrollRect(parent:TabIndividualViewHandle,skin:MCIndividualBoss,rsloader:RsrLoader)
		{
			_parent = parent;
			_skin = skin;
			_rsloader = rsloader;
			init();
		}
		private function init():void
		{
		 	_scrollRect = new Rectangle(0,0,_skin.mcScrollLayer.width,_skin.mcScrollLayer.height-4);
			_skin.mcScrollLayer.scrollRect = _scrollRect;
			_skin.mcScrollLayer.mouseEnabled = false;
			_skin.mouseEnabled = false;
		}
		
		internal function initScrollBar(mc:MovieClip):void
		{
	 		if(!_scrollBar)
			{
				_scrollBar = new ScrollBar(this,mc);
			}
			
			_scrollBar.resetHeight(_scrollRect.height); 
		}
		
		public function refresh(data:Array):void
		{

			var item:IndividualItem;
			var itemData:IndividualItemData;
			if(_items.length == data.length)
			{
				for(var i:int = 0;i<_items.length;i++)
				{
					itemData = data[i] as IndividualItemData;
					item = _items[i] as IndividualItem;
					item.refresh(itemData);
				}
			}
			else
			{
				clearItems();
				for (var j:int = 0;j<data.length;j++)
				{
					itemData = data[j] as IndividualItemData;
					item = new IndividualItem(_parent,_rsloader);
					item.refresh(itemData);
					item.skin.x = 6;
					item.skin.y = _contentHeight;
					//_contentHeight += item.skin.height +2;	
					_contentHeight += 84 +2;	
					
					_skin.mcScrollLayer.addChild(item.skin);
					_items.push(item);
				}
			}
			
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
			}	
		}
		
		public function showFirstItem():void
		{
			var item:IndividualItem = _items[0] as IndividualItem; 
			if(item)
			{
				item.firstItemCheck();
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
			_contentHeight = 0;
			var item:IndividualItem;
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
			}
			_scrollBar = null;
			_skin = null;
		}
	}
 
}