package com.view.gameWindow.panel.panelbase
{
	import com.pattern.Observer.IObserver;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface IPanelBase extends IObserver
	{
		/**显示*/
		function show(layer:Sprite):void;
		/**隐藏*/
		function hide():void;
		function get isShow():Boolean;
		function getPanelRect():Rectangle;
		function get postion():Point;
		function set postion(value:Point):void;
		function doContains(child:DisplayObject):Boolean;
		function isMouseOn():Boolean;
		function get skin():MovieClip;
	}
}