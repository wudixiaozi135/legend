package com.view.gameWindow.panel.panels.taskStar.over
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskStarCostCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.taskStar.McTaskStarOver;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;

	/**
	 * 星级任务点击刷新处理类
	 * @author Administrator
	 */	
	public class PanelTaskStarOverClickHandle
	{
		private var _panel:PanelTaskStarOver;
		private var _mc:McTaskStarOver;
		
		public function PanelTaskStarOverClickHandle(panel:PanelTaskStarOver)
		{
			_panel = panel;
			_mc = _panel.skin as McTaskStarOver;
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mc.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_TASK_STAR_OVER);
					break;
				case _mc.btn0:
					sendData(3);
					break;
				case _mc.btn1:
					sendData(2);
					break;
				case _mc.btn2:
					sendData(1);
					break;
			}
		}
		
		private function sendData(multiples:int):void
		{
			var taskStarCostCfgData:TaskStarCostCfgData;
			
			taskStarCostCfgData = ConfigDataManager.instance.taskStarCostCfgData(multiples);
			
			if(VipDataManager.instance.lv<taskStarCostCfgData.vip)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.DGN_GOALS_004,taskStarCostCfgData.vip));
				return;
			}
			
			var moneyBind:int = BagDataManager.instance.coinBind;
			var moneyUnBind:int = BagDataManager.instance.coinUnBind;
			if(moneyBind+moneyUnBind < taskStarCostCfgData.coin)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.TASK_STAR_PANEL_0030);
				return;
			}
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			var tid:int = PanelTaskStarDataManager.instance.tid;
			byteArray.writeInt(tid);
			byteArray.writeByte(multiples);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SUBMIT_TASK,byteArray);
			PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_STAR_OVER);
		}
		
		public function destroy():void
		{
			_mc.removeEventListener(MouseEvent.CLICK,onClick);
			_mc = null;
			_panel = null;
		}
	}
}