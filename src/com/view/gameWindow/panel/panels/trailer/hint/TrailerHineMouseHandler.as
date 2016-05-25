package com.view.gameWindow.panel.panels.trailer.hint
{
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.trailer.TrailerData;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;
	

	public class TrailerHineMouseHandler
	{

		private var _hint:TrailerHint;

		private var skin:MCHint;
		public function TrailerHineMouseHandler(hint:TrailerHint)
		{
			this._hint = hint;
			skin = hint.skin as MCHint;
			skin.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case skin.btn1:
					dealDefend();
					break;
				case skin.btn2:
					dealFly();
					break;
				case skin.btn3:
					dealCancelTrailer();
					break;
			}
		}
		
		private function dealDefend():void
		{
			var task:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
			if(task)
			{
				AutoJobManager.getInstance().setAutoTargetData(task.end_npc,EntityTypes.ET_NPC);
			}
		}
		
		private function dealFly():void
		{
			GameFlyManager.getInstance().flyToTrailer();
		}
		
		private function dealCancelTrailer():void
		{
			Alert.show2(HtmlUtils.createHtmlStr(0xff0000,StringConst.TRAILER_HINT_STRING_011),function ():void
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_HINT);
				var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
				TrailerDataManager.getInstance().cancelTrailer(trailerData.tid);
			});
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onMouseClick);
		}
	}
}