package com.view.gameWindow.panel.panels.activitys.loongWar.tabApply
{
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class TabLoongWarApplyScrollRect implements IScrollee
	{
		private var _isUnion:Boolean;
		private var _tab:TabLoongWarApply;
		private var _skin:McLoongWarApply;
		
		private var _items:Vector.<TabLoongWarApplyGuildItem>;
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _contentHeight:int;
		
		public function TabLoongWarApplyScrollRect(tab:TabLoongWarApply,isUion:Boolean = false)
		{
			_tab = tab;
			_skin = _tab.skin as McLoongWarApply;
			_isUnion = isUion;
			initialize();
		}
		
		private function initialize():void
		{
			_items = new Vector.<TabLoongWarApplyGuildItem>();
			//
			var layer:MovieClip = _isUnion ? _skin.mcLayerUion : _skin.mcLayerAttack;
			_scrollRect = new Rectangle(0,0,layer.width,layer.height);
			layer.scrollRect = _scrollRect;
		}
		
		internal function initScrollBar(mc:MovieClip):void
		{
			var layer:MovieClip = _isUnion ? _skin.mcLayerUion : _skin.mcLayerAttack;
			_scrollBar = new ScrollBar(this,mc,0,layer,15);
			_scrollBar.resetHeight(_scrollRect.height);
		}
		
		internal function update():void
		{
			var dts:Vector.<DataLoongWarApplyGuild> = ActivityDataManager.instance.loongWarDataManager.dtsApplyGuild;
			var i:int,l:int;
			var isAdd:Boolean;
			if(_items.length > dts.length)
			{
				i = dts.length;
				l = _items.length;
				isAdd = false;
			}
			else if(_items.length < dts.length)
			{
				i = _items.length;
				l = dts.length;
				isAdd = true;
			}
			for (;i<l;i++) 
			{
				if(isAdd)
				{
					var layer:MovieClip = _isUnion ? _skin.mcLayerUion : _skin.mcLayerAttack;
					_items[i] = new TabLoongWarApplyGuildItem(layer);
					_items[i].isLeague = _isUnion;
				}
				else
				{
					_items[i].destroy();
				}
			}
			//
			_contentHeight = 0;
			l = dts.length;
			for (i=0;i<l;i++) 
			{
				_items[i].update(dts[i]);
				_items[i].skin.y = _contentHeight;
				_contentHeight += _items[i].skin.height;
			}
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
			}
		}
		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			var layer:MovieClip = _isUnion ? _skin.mcLayerUion : _skin.mcLayerAttack;
			layer.scrollRect = _scrollRect;
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
		
		internal function destroy():void
		{
			var item:TabLoongWarApplyGuildItem;
			for each(item in _items)
			{
				if(item)
				{
					item.destroy();
				}
			}
			_items = null;
			_scrollBar.destroy();
			_scrollBar = null;
			_skin = null;
			_tab = null;
		}
	}
}