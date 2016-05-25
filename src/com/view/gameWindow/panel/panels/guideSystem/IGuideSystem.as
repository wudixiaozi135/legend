package com.view.gameWindow.panel.panels.guideSystem
{
	import com.core.bind_t;
	import com.model.configData.cfgdata.GuideCfgData;
	import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
	import com.view.gameWindow.panel.panels.guideSystem.trigger.IGuideTrigger;

	/**
	 * @inheritDoc
	 */
	public interface IGuideSystem extends IGuideTrigger
	{
		function checkDoingGuides():void;
		function get isNeedStopAutoTask():Boolean;
		function some(filter:bind_t):Boolean;
		function createAction(guideId:int):GuideAction;
		function get doingList():Array;
	}
}