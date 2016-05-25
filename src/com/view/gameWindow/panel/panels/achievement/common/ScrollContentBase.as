package com.view.gameWindow.panel.panels.achievement.common
{
	import com.view.gameWindow.panel.panels.achievement.AchievementDataManager;
	import com.view.gameWindow.panel.panels.achievement.title.AchievementTitleItem;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ScrollContentBase extends Sprite implements IScrollee
	{
		protected var items:Vector.<IScrollItem>;
		private var _scrollRect:Rectangle;
		public function ScrollContentBase()
		{
			items=new Vector.<IScrollItem>();
			 _scrollRect=new Rectangle();
			this.scrollRect=_scrollRect;
			super();
		}
		
		public function setScrollRectWH(w:Number,h:Number):void
		{	
			_scrollRect.width=w;
			_scrollRect.height=h;
			this.scrollRect=_scrollRect;
		}
		
		public function additem(item:IScrollItem):void
		{
			addChild(item as DisplayObject);
			item.setY(items.length*item.getItemHight());
			items.push(item);
		}
		
		public function setItemSelect(item:IScrollItem):void
		{
			var achi:AchievementTitleItem= item as AchievementTitleItem;
			AchievementDataManager.getInstance().selectTitleType=achi.cfg.type;
			for each(var tmp:IScrollItem in items)
			{
				tmp.select=tmp==item;
			}
		}
		
		public function removeAllItem():void
		{
			while(items.length)
			{
				var tmp:IScrollItem=items.shift();
				removeChild(tmp as DisplayObject);
				tmp&&tmp.destroy();
				tmp=null;
			}
		}
		
		public function destroy():void
		{
			this.parent&&this.parent.removeChild(this);
			removeAllItem();
			items=null;
			_scrollRect=null;
		}
		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y=pos;
			this.scrollRect=_scrollRect;
		}
		
		public function get contentHeight():int
		{
			if(items.length>0)
			{
				return items.length*items[0].getItemHight();
			}
			return this.height;
		}
		
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
		
		public function get scrollRectHeight():int
		{
			// TODO Auto Generated method stub
			return _scrollRect.height;
		}
	}
}