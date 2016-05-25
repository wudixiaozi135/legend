package com.view.gameWindow.panel.panels.guideSystem.view
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	
	/**
	 * @author wqhk
	 * 2014-10-28
	 */
	public class CircleHitArea extends GuideHitArea
	{
		private var radius:int;
		private var img:Sprite;
		public function CircleHitArea(panelName:String,tabIndex:int, rect:Rectangle,hitAreaShow:Boolean = true)
		{
			radius = int(Math.min(rect.width,rect.height)/2);
			
			super(panelName,rect,hitAreaShow);
			
			if(tabIndex > -1)
			{
				setUICheck(new CheckTabIndex(panelName,tabIndex));
			}
		}
		
		override public function isInArea(x:int,y:int):Boolean
		{
			if(x>=0 && x<=areaRect.width && y>=0 && y <= areaRect.height)
			{
				var dis:Number = Math.sqrt(Math.pow(x-int(areaRect.width/2),2)+Math.pow(x-int(areaRect.height/2),2));
				
				return dis <= radius;
			}
			
			return false;
		}
		
		override protected function draw():void
		{
			img = new Sprite();
			img.graphics.clear();
			img.graphics.lineStyle(2,0xf2ab1f,1);
			//			graphics.beginFill(0xffffff,0.5);
//			graphics.drawRect(0,0,areaRect.width,areaRect.height);
			//			graphics.endFill();
			img.graphics.drawCircle(int(areaRect.width/2),int(areaRect.height/2),radius);
			
			img.filters = [new GlowFilter(0x996100,1,5,5)];
			addChild(img);
		}
	}
}