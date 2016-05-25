package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	public interface ICheckCondition
	{
		/**
		 * @return true 代表隐藏
		 */
		function isDoing():Boolean;
		function isComplete():Boolean;
		
		function toDo():void;//因为塔防蛋疼的功能新加
	}
}