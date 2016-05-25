package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.model.configData.cfgdata.GuideCfgData;

	public interface IActionFactory
	{
		function getAction(data:GuideCfgData):GuideAction;
	}
}