package com.view.gameWindow.panel.panels.trailer.enter
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.trailer.MCTrailerEnter;
	import com.view.gameWindow.panel.panels.trailer.TrailerData;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	
	import flash.events.MouseEvent;

	public class TrailerEnterMouseHandler
	{

		private var panel:TrailerEnter;
		private var skin:MCTrailerEnter;

		public function TrailerEnterMouseHandler(panel:TrailerEnter)
		{
			this.panel = panel;
			skin = panel.skin as MCTrailerEnter;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
		}		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			switch(event.target)
			{
				case skin.txt1:
					dealFunc1();
					break;
				case skin.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_IN);
					break;
			}
		}			
		
		private function dealFunc1():void
		{
			if(panel.isStar)
			{
				var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData(801);
				if(RoleDataManager.instance.lv<activityCfgData.level)
				{
					Alert.warning(StringConst.BAG_PANEL_0015);
					return;
				}
				PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_IN);
				PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_PANEL);
			}else
			{
				var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
				if(trailerData.state==TaskStates.TS_CAN_SUBMIT)
				{
					TaskDataManager.instance.submitTask(trailerData.tid);
				}
				PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_IN);
			}
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}