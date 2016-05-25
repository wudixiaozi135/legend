package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.model.configData.cfgdata.GuideCfgData;
	
	/**
	 * @author wqhk
	 * 2015-1-29
	 */
	public function getAction(data:GuideCfgData):GuideAction
	{
		var fac:ActionFactory2 = new ActionFactory2();
		return fac.getAction(data);
	}
}