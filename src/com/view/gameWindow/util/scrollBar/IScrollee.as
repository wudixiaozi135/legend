package com.view.gameWindow.util.scrollBar
{
	public interface IScrollee
	{
		/**
		 * 
		 * @param pos 被滚动内容的scrollRect的y坐标
		 */		
		function scrollTo(pos:int):void;
		function get contentHeight():int;
		function get scrollRectHeight():int;
		function get scrollRectY():int;
	}
}