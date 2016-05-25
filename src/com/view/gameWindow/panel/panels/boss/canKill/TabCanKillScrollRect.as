package com.view.gameWindow.panel.panels.boss.canKill
{
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossData;
	import com.view.gameWindow.panel.panels.boss.MCFieldBoss;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class TabCanKillScrollRect implements IScrollee
	{
		private var _handler:TabCanKillViewHandle;
		private var _rsloader:RsrLoader;
		private var _skin:MCFieldBoss;
		private var _scrollRect:Rectangle;
		
		private var _scrollBar:ScrollBar;
		
		private var _contentHeight:int;
		
		private var _items:Array = [];
		public function TabCanKillScrollRect(parent:TabCanKillViewHandle,skin:MCFieldBoss,rsloader:RsrLoader)
		{
			_handler = parent;
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
		 
		
		public function refresh(data:Vector.<BossCfgData>):void
		{
			var item:CanKillBossItem;
			var itemData:BossCfgData;
			if(_items.length == data.length)
			{
				for(var i:int = 0;i<_items.length;i++)
				{
					itemData = data[i] as BossCfgData;
					item = _items[i] as CanKillBossItem;
					item.refresh(itemData);
				}
			}
			else
			{
				clearItems();

				for (var j:int = 0;j<data.length;j++)
				{
					itemData = data[j] as BossCfgData;
					item = new CanKillBossItem(_handler);
					item.init(_rsloader);
					item.skin.x = 5;
					item.skin.y = _contentHeight;
					_contentHeight += item.skin.height - 1;	
					item.refresh(itemData);
					_skin.mcScrollLayer.addChild(item.skin);
					_items.push(item);
				}
				
				if(_scrollBar)
				{
					_scrollBar.resetScroll();
					_scrollBar.scrollTo(0);
				}	
			}
			
			if(_handler.selectItem==null&&_items.length>0)
			{
				_items[0].setCheck(true);
				_handler.selectItem=_items[0];
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
			var item:CanKillBossItem;
			for each(item in _items)
			{
				if(item)
				{
					item.destroy();
				}
			}
			_contentHeight = 0;
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