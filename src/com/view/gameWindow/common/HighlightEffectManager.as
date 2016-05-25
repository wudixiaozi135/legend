package com.view.gameWindow.common
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * @author wqhk
	 * 2014-12-17
	 */
	public class HighlightEffectManager
	{
		private var hightlightStore:Dictionary;
		private var animStore:Dictionary;
		
		public function HighlightEffectManager()
		{
			hightlightStore = new Dictionary();
			animStore = new Dictionary();
			
		}
		
		public function show(ctner:DisplayObjectContainer,item:DisplayObject,plusX:Number = 0,plusY:Number = 0):void
		{
			if(hightlightStore[item])
			{
				return;
				hide(item);
			}
			
			var BORDER:int = 10;
			
			//1
			var img:BitmapData = new BitmapData(item.width,item.height,true,0x0);
			img.draw(item);
			var bitmapdata:BitmapData = new BitmapData(item.width+BORDER*2,item.height+BORDER*2,true,0x00000000);
			bitmapdata.applyFilter(img,new Rectangle(0,0,img.width,img.height),new Point(BORDER,BORDER),new GlowFilter(0xffcc00,1,BORDER,BORDER,2,1,false,true));
			
			var h:Bitmap = new Bitmap(bitmapdata);
			var rect:Rectangle = item.getBounds(ctner);
			h.x = rect.x - BORDER + plusX;
			h.y = rect.y - BORDER + plusX;
			ctner.addChild(h);
			
			//2
//			var oldState:Array = item.filters;
//			item.filters = [new GlowFilter(0xffcc00,1,BORDER,BORDER,2,1,false,true)];
//			var mat:Matrix = new Matrix(1,0,0,1,BORDER,BORDER);
//			var bitmapdata:BitmapData = new BitmapData(item.width+BORDER*2,item.height+BORDER*2,true,0x00000000);
//			bitmapdata.draw(item,mat);
//			
//			var h:Bitmap = new Bitmap(bitmapdata);
//			var rect:Rectangle = item.getRect(ctner);
//			h.x = rect.x - BORDER;
//			h.y = rect.y - BORDER;
//			ctner.addChild(h);
//			item.filters = oldState;
			
			hightlightStore[item] = h;
			h.alpha = 0.3;
			animStore[item] = TweenMax.to(h,0.6,{alpha:1,yoyo:true,repeat:-1});
		}
		/**
		 * 
		 * 
		 */
		public function zhouShow(ctner:DisplayObjectContainer,item:DisplayObject,plusX:Number = 0,plusY:Number = 0):Bitmap
		{
			var BORDER:int = 12;
			//1
			var img:BitmapData = new BitmapData(item.width,item.height,true,0x0);
			img.draw(item);
			var bitmapdata:BitmapData = new BitmapData(item.width+BORDER*2,item.height+BORDER*2,true,0x00000000);
			bitmapdata.applyFilter(img,new Rectangle(0,0,img.width,img.height),new Point(BORDER,BORDER),new GlowFilter(0xffcc00,1,BORDER,BORDER,2,1,false,true));
			
			var h:Bitmap = new Bitmap(bitmapdata);
			var rect:Rectangle = item.getBounds(ctner);
			h.x = rect.x - BORDER + plusX;
			h.y = rect.y - BORDER + plusX;
			ctner.addChild(h);
			
			hightlightStore[h] = h;
			h.alpha = 0.2;
			animStore[h] = TweenMax.to(h,0.5,{alpha:1,yoyo:true,repeat:-1});
			return h;
		}
		
		public function hide(item:DisplayObject):void
		{
			var h:DisplayObject = hightlightStore[item];
			
			if(h)
			{
				if(h.parent)
				{
					h.parent.removeChild(h);
				}
				delete hightlightStore[item];
			}
			
			var t:TweenMax = animStore[item];
			if(t)
			{
				t.kill();
				delete animStore[item];
			}
		}
		
		public function hideEffect(effect:Bitmap):void
		{
			var h:DisplayObject = hightlightStore[effect];
			
			if(h)
			{
				if(h.parent)
				{
					h.parent.removeChild(h);
				}
				delete hightlightStore[effect];
			}
			
			var t:TweenMax = animStore[effect];
			if(t)
			{
				t.kill();
				delete animStore[effect];
			}
		}
	}
}