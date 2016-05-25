package com.view.gameWindow.panel.panels.daily.activity
{
	import com.model.configData.cfgdata.DailyCfgData;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	/**
	 * 日常活动页滚动区域类
	 * @author Administrator
	 */	
	internal class TabDailyActivityScrollRect implements IScrollee
	{
		private var _tab:TabDailyActivity;
		private var _skin:McDailyActivity1;
		
		private var _items:Vector.<TabDailyActivityItem>;
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _contentHeight:int;

		private var _highlightEffect:HighlightEffectManager;
		private var _isHightlightEffectShow:Boolean;
		
		public function TabDailyActivityScrollRect(tab:TabDailyActivity)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyActivity1;
			init();
		}
		
		private function init():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			var typeDts:Vector.<DailyData> = manager.getDailyDatasByTab(),dt:DailyData;
			_items = new Vector.<TabDailyActivityItem>(/*typeDts.length,true*/);
			for each(dt in typeDts)
			{
				if(dt)
				{
					var item:TabDailyActivityItem = new TabDailyActivityItem(_tab);
					var cfgDt:DailyCfgData = dt.dailyCfgData;
					item.refresh(cfgDt.sub_order);
					/*_items[cfgDt.sub_order] = item;*/
					_items.push(item);
				}
			}
			//
			_scrollRect = new Rectangle(0,0,_skin.mcScrollLayer.width,_skin.mcScrollLayer.height);
			_skin.mcScrollLayer.scrollRect = _scrollRect;
		}
		
		internal function initScrollBar(mc:MovieClip):void
		{
			_scrollBar = new ScrollBar(this,mc,0,_skin.mcScrollLayer,15);
			_scrollBar.resetHeight(_scrollRect.height);
		}
		
		internal function refresh():void
		{
			if(!_highlightEffect)
			{
				_highlightEffect = new HighlightEffectManager();
			}
			if(_items)
			{
				_items.sort(TabDailyActivityItem.sort);
			}
			_contentHeight = 0;
			var item:TabDailyActivityItem;
			for each(item in _items)
			{
				if(item.isEnterAble)
				{
					item.skin.y = _contentHeight/*+2*/;
					_contentHeight += item.skin.height;
					if(!item.skin.parent)
					{
						_skin.mcScrollLayer.addChild(item.skin);
					}
					//
					if(item.isTimeRight)
					{
						if(!_isHightlightEffectShow)
						{
							_isHightlightEffectShow = true;
							_highlightEffect.show(_skin.mcScrollLayer,item.skin);
						}
					}
					//
					_tab.mouseHandle.selectOrder == -1 ? _tab.mouseHandle.selectOrder = item.order : null;
				}
			}
			for each(item in _items)
			{
				if(!item.isEnterAble)
				{
					item.skin.y = _contentHeight/*+2*/;
					_contentHeight += item.skin.height;
					if(!item.skin.parent)
					{
						_skin.mcScrollLayer.addChild(item.skin);
					}
					_tab.mouseHandle.selectOrder == -1 ? _tab.mouseHandle.selectOrder = item.order : null;
				}
			}
			_skin.mcScrollLayer.setChildIndex(_skin.mcScrollLayer.mcItemSelect,_skin.mcScrollLayer.numChildren-1);
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
		
		internal function destroy():void
		{
			var item:TabDailyActivityItem;
			for each(item in _items)
			{
				if(item)
				{
					_highlightEffect.hide(item.skin);
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