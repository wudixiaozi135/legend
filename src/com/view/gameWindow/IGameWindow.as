package com.view.gameWindow
{
	import com.view.gameWindow.mainUi.IMainUiMediator;
	import com.view.gameWindow.mainUi.subuis.musicSet.IMusicSettingManager;
	import com.view.gameWindow.panel.IPanelMediator;

	public interface IGameWindow
	{
		function resize(newWidth:int, newHeight:int):void;
		
		function showMainUI():void;
		function panelMediator():IPanelMediator;
		function get mainUiMediator():IMainUiMediator;
		function get musicSetingManager():IMusicSettingManager;
	}
}