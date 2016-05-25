package com.view.gameWindow.panel.panels.taskTrans
{
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.McTaskTrans;
	import com.view.gameWindow.panel.panels.task.TaskAutoHandoverData;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PanelTaskTrans extends PanelBase
	{
		private var _mcTaskTrans:McTaskTrans;
		private var _timer:Timer;
		private var _num:int;
		
		public function PanelTaskTrans()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_timer = new Timer(1000);
			_num = 5;
			_skin = new McTaskTrans();
			_mcTaskTrans = _skin as McTaskTrans;
			addChild(_mcTaskTrans);
			_mcTaskTrans.txt3.mouseEnabled = false;
			_mcTaskTrans.timeTxt.text = String(_num) + StringConst.TASK_TRANS_0001;
			_timer.addEventListener(TimerEvent.TIMER,timerHadnle);
			_timer.start();
			_mcTaskTrans.txt1.text = StringConst.TASK_TRANS_0002;
			_mcTaskTrans.txt2.text = StringConst.TASK_TRANS_0003;
			_mcTaskTrans.txt3.text = StringConst.TASK_TRANS_0004;
		}	
		
		private function timerHadnle(evt:TimerEvent):void
		{
			_num--;
			_mcTaskTrans.timeTxt.text = String(_num) + StringConst.TASK_TRANS_0001;
			if(_num == 0)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,timerHadnle);
				_num = 5;
				sendData();
				PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_TRANS);
			}
			
		}
		
		override public function destroy():void 
		{
			if(_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,timerHadnle);
			}
			if(_mcTaskTrans)
			{
				_mcTaskTrans = null;
			}
			super.destroy();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_mcTaskTrans.BtnTrans,function():void
			{
				if(_mcTaskTrans)
				{
					_mcTaskTrans.BtnTrans.addEventListener(MouseEvent.CLICK,clickHandle);
				}
			});
		}
		
		
		private function clickHandle(evt:MouseEvent):void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER,timerHadnle);
			_num = 5;
			sendData();
			PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_TRANS);
		}
		
		private function sendData():void
		{
			var taskId:int = TaskTransData.taskId;
			
			MainUiMediator.getInstance().taskTrace.resetAutoTaskInfo(taskId);
			TeleportDatamanager.instance.requestTeleportTask(taskId);
		}
	}
}