package com.view.gameWindow.mainUi.subuis.tasktrace
{
	import com.view.gameWindow.panel.panels.task.linkText.ILinkText;

	public interface ITaskTrace
	{
		function showHide(show:Boolean = true):void;
		function get isShow():Boolean;
		function getX():Number;
		function getY():Number;
		function getLinkText(taskId:int):ILinkText;
		function resetAutoTaskInfo(taskId:int = 0):void;
		function checkActivity():void;
		function updateAutoAfterLvUp():void;
	}
}