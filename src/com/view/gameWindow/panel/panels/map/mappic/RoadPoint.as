package com.view.gameWindow.panel.panels.map.mappic
{
	import flash.display.Sprite;
	
	
	/**
	 * @author wqhk
	 * 2015-1-9
	 */
	public class RoadPoint extends Sprite
	{
		public var pos:Number;
		
		public function RoadPoint()
		{
			super();
			graphics.beginFill(0x00cc00);
			graphics.drawCircle(0,0,2);
			graphics.endFill();
		}
	}
}