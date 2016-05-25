package com.view.gameWindow.panel.panels.roleProperty
{
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.roleProperty.role.IRolePanel;

	public interface IRolePropertyPanel extends IPanelBase
	{
		function changeSonPanel(name:int):void;
		function get rolePanel():IRolePanel;
	}
}