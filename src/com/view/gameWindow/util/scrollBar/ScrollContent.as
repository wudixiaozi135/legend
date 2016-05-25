package com.view.gameWindow.util.scrollBar
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ScrollContent extends Sprite implements IScrollee
	{
		protected var items:Vector.<IScrolleeCell>;
		private var _scrollRect:Rectangle;
		private var _contentHeight:int;
		public function ScrollContent()
		{
			items=new Vector.<IScrolleeCell>();
			 _scrollRect=new Rectangle();
			this.scrollRect=_scrollRect;
			this.mouseEnabled=false;
			super();
		}
		
		public function setScrollRectWH(w:Number,h:Number):void
		{	
			_scrollRect.width=w;
			_scrollRect.height=h;
			this.scrollRect=_scrollRect;
		}
		
		public function additem(item:IScrolleeCell):void
		{
			addChild(item as DisplayObject);
			items.push(item);
		}
		
		public function removeAllItem():void
		{
			while(items.length)
			{
				var tmp:IScrolleeCell=items.shift();
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
			if(_contentHeight!=0)
			{
				return _contentHeight;
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

		public function set contentHeight(value:int):void
		{
			_contentHeight = value;
		}

	}
}