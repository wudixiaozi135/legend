package com.view.gameWindow.mainUi.subuis.chatframe
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public interface IChatOutput
	{
		function init(showHandler:Function):void;
		/**
		 * @param createHandler(index:int):DisplayObject
		 */
		function setExpCreateFunc(createHandler:Function):void;
		function changeChannel(type:int):void;
		/**
		 *  不要从外部直接调用 ，通过chatFrame调用
		 */
		function pushData(data:String,color:uint = 0):void;
		function getHeight():Number;
		function get view():DisplayObject;
	}
}