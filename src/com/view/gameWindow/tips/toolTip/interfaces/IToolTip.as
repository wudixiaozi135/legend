package com.view.gameWindow.tips.toolTip.interfaces
{
	import flash.display.MovieClip;

	/**
	 * tip接口 
	 * @author jhj
	 */	
	public interface IToolTip
	{
		function initView(mc:MovieClip):void;
		function setData(obj:Object):void;
	}
}