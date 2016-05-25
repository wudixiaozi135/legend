package com.view.gameWindow.panel.panels.dungeon
{
	import flash.text.TextField;

	public interface IDungeonPanel
	{
		function set id(value:int):void;
		function get id():int;
		function get vector():Vector.<int>;
	}
}