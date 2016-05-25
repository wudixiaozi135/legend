package com.view.gameWindow.panel.panels.keyBuy
{
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.view.gameWindow.panel.panelbase.IPanelBase;

	public interface IKeyBuyPanel extends IPanelBase
	{
		function get dataArr():Vector.<NpcShopCfgData>;
	}
}