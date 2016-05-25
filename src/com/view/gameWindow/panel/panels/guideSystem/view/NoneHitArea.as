package com.view.gameWindow.panel.panels.guideSystem.view
{
	import flash.geom.Rectangle;
	
	
	/**
	 * @author wqhk
	 * 2014-10-28
	 */
	public class NoneHitArea extends GuideHitArea
	{
		public function NoneHitArea(panelName:String, rect:Rectangle)
		{
			super(panelName, rect);
		}
		
		override public function isInArea(x:int,y:int):Boolean
		{
			return true;
		}
	}
}