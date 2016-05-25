package com.view.gameWindow.panel.panels.activitys
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.McTaskTrans;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 活动结束离开地图传送面板
	 * @author Administrator
	 */	
	public class PanelActvOverTrans extends PanelBase
	{
		private var _timer:Timer;
		private var _num:int;

		private var _mapId:int;
		
		public function PanelActvOverTrans()
		{
			super();
			EntityLayerManager.getInstance().attach(this);
			_mapId = SceneMapManager.getInstance().mapId;
		}
		
		override protected function initSkin():void
		{
			var skin:McTaskTrans = new McTaskTrans();
			_skin = skin as McTaskTrans;
			addChild(skin);
		}	
		
		override protected function initData():void
		{
			_num = 30;
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,timerHadnle);
			_timer.start();
			//
			addEventListener(MouseEvent.CLICK,clickHandle);
			//
			var skin:McTaskTrans = _skin as McTaskTrans
			skin.txt3.mouseEnabled = false;
			skin.timeTxt.text = String(_num) + StringConst.TASK_TRANS_0001;
			skin.txt1.text = StringConst.ACTIVITY_OVER_TRANS_0001;
			skin.txt2.text = StringConst.ACTIVITY_OVER_TRANS_0002;
			skin.txt3.text = StringConst.ACTIVITY_OVER_TRANS_0003;
		}
		
		private function timerHadnle(evt:TimerEvent):void
		{
			_num--;
			skin.timeTxt.text = String(_num) + StringConst.TASK_TRANS_0001;
			if(_num == 0)
			{
				deal();
			}
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var skin:McTaskTrans = _skin as McTaskTrans
			if(evt.target == skin.BtnTrans)
			{
				deal();
			}
		}
		
		private function deal():void
		{
			ActivityDataManager.instance.cmLeaveActivityMap();
			PanelMediator.instance.closePanel(PanelConst.TYPE_ACTV_OVER_TRANS);
		}
		
		override public function update(proc:int=0):void
		{
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(proc == GameServiceConstants.SM_ENTER_MAP && _mapId != mapId)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_ACTV_OVER_TRANS);
			}
		}
		
		override public function destroy():void 
		{
			EntityLayerManager.getInstance().detach(this);
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER,timerHadnle);
			super.destroy();
		}
	}
}