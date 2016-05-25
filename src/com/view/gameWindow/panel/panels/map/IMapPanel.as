package com.view.gameWindow.panel.panels.map
{
	import com.view.gameWindow.panel.panelbase.IPanelBase;

	public interface IMapPanel extends IPanelBase
	{
		function refreshFirstPlayerSign():void;
		function addMstSign(id:int):void;
		function refreshMstSign(id:int):void;
		function removeMstSign(id:int):void;
		function addPlayerSign(id:int):void;
		function refreshPlayerSign(id:int):void;
		function refreshMousePoint():void;
		function removePlayerSign(id:int):void;
		function removePathSigns():void;
	}
}