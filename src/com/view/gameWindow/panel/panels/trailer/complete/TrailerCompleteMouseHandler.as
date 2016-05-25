package com.view.gameWindow.panel.panels.trailer.complete
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.trailer.MCTrailerComplete;
	import com.view.gameWindow.panel.panels.trailer.TrailerData;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	
	import flash.events.MouseEvent;

	public class TrailerCompleteMouseHandler
	{

		private var panel:TrailerComplete;
		private var skin:MCTrailerComplete;

		public function TrailerCompleteMouseHandler(panel:TrailerComplete)
		{
			this.panel = panel;
			skin = panel.skin as MCTrailerComplete;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
		}		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			switch(event.target)
			{
				case skin.mcContent.btn1:
					dealFunc1();
					break;
				case skin.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_COMPLETE);
					break;
			}
		}			
		
		private function dealFunc1():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			if(trailerData.state==TaskStates.TS_CAN_SUBMIT)
			{
				TaskDataManager.instance.submitTask(trailerData.tid);
			}
			PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_COMPLETE);
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}