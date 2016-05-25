package com.view.gameWindow.panel.panels.guideSystem.view
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	/**
	 * @author wqhk
	 * 2014-10-24
	 */
	public class RectHitArea extends GuideHitArea
	{
		private var img:Sprite;
		public function RectHitArea(panelName:String,tabIndex:int,rect:Rectangle,hitAreaShow:Boolean = true)
		{
			super(panelName,rect,hitAreaShow);
			
			if(tabIndex > -1)
			{
				setUICheck(new CheckTabIndex(panelName,tabIndex));
			}
		}
		
		override public function isInArea(x:int,y:int):Boolean
		{
			return x>=0 && x<=areaRect.width && y>=0 && y <= areaRect.height;
		}
		
		override protected function draw():void
		{
			img = new Sprite();
			img.graphics.clear();
			img.graphics.lineStyle(2,0xf2ab1f,1);
//			graphics.beginFill(0xffffff,0.5);
			img.graphics.drawRect(0,0,areaRect.width,areaRect.height);
//			graphics.endFill();
			
			img.filters = [new GlowFilter(0x996100,1,5,5)];
			addChild(img);
		}
	}
}