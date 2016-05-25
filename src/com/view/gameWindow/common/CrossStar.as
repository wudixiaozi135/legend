package com.view.gameWindow.common
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	
	/**
	 * @author wqhk
	 * 2015-1-28
	 */
	public class CrossStar extends Shape
	{
		public function CrossStar(radius:int = 3)
		{
			super();
			
			graphics.beginFill(0xffffff,1);
			graphics.drawCircle(0,0,radius);
			graphics.endFill();
			
			this.filters = [new GlowFilter(0xffffff,0.5,5,5)]
			this.alpha = 1;
		}
	}
}