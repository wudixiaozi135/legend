package com.view.gameWindow.panel.panels.task.linkText
{
	import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;

	public interface ILinkText
	{
		function get htmlText():String;
		function init(text:String,noEvent : Boolean = false):void;
		function getItemById(id:int):LinkTextItem;
		function getItemCount():int;
	}
}