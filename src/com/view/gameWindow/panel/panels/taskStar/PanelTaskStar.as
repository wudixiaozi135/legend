package com.view.gameWindow.panel.panels.taskStar
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
	import com.view.gameWindow.panel.panels.guideSystem.completeCond.ExportCheck;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuidesID;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.panel.panels.taskStar.handle.PanelTaskStarAddFuncHandle;
	import com.view.gameWindow.panel.panels.taskStar.handle.PanelTaskStarClickHandle;
	import com.view.gameWindow.panel.panels.taskStar.handle.PanelTaskStarInitHnadle;
	import com.view.gameWindow.panel.panels.taskStar.handle.PanelTaskStarRefreshHandle;
	
	import flash.display.MovieClip;

	/**
	 * 星级任务面板类
	 * @author Administrator
	 */	
	public class PanelTaskStar extends PanelBase implements IPanelTaskStar
	{
		public var _panelTaskStarInitHnadle:PanelTaskStarInitHnadle;
		public var _panelTaskStarClickHandle:PanelTaskStarClickHandle;
		public var _panelTaskStarRefreshHandle:PanelTaskStarRefreshHandle;

		private var _panelTaskStarAddFuncHandle:PanelTaskStarAddFuncHandle;
		
		public var refreshBtnGuide:GuideAction;
		public var receiveBtnGuide:GuideAction;
		
		public function PanelTaskStar()
		{
			super();
			PanelTaskStarDataManager.instance.attach(this);
		}
		
		public function createReceiveBtnGuide():void
		{
			if(!receiveBtnGuide)
			{
				receiveBtnGuide = GuideSystem.instance.createAction(GuidesID.TASK_STAR_RECEIVE_BTN);
				receiveBtnGuide.cond = [new ExportCheck(isHideReceiveGuide)];
				receiveBtnGuide.init();
				receiveBtnGuide.act();
			}
		}
		
		public function createRefreshBtnGuide():void
		{
			if(!refreshBtnGuide)
			{
				refreshBtnGuide = GuideSystem.instance.createAction(GuidesID.TASK_STAR_REFRESH_BTN);
				refreshBtnGuide.cond = [new ExportCheck(isHideRefreshGuide)];
				refreshBtnGuide.init();
				refreshBtnGuide.act();
			}
		}
		
		public function checkReceiveBtnGuide():void
		{
			if(receiveBtnGuide)
			{
				receiveBtnGuide.check();
			}
		}
		
		public function checkRefreshBtnGuide():void
		{
			if(refreshBtnGuide)
			{
				refreshBtnGuide.check();
			}
		}
		
		private function isHideRefreshGuide():Boolean
		{
			var dataMgr:PanelTaskStarDataManager = PanelTaskStarDataManager.instance
			var isFullStar:Boolean = dataMgr.isFullStar;
			var isInProgress:Boolean = _panelTaskStarClickHandle.isInProgress;
			var isComplete:Boolean = PanelTaskStarDataManager.instance.isComplete;
			
			return isFullStar || isInProgress || isComplete;
		}
		
		private function isHideReceiveGuide():Boolean
		{
			var dataMgr:PanelTaskStarDataManager = PanelTaskStarDataManager.instance
			var isFullStar:Boolean = dataMgr.isFullStar;
			
			var tidState:int = PanelTaskStarDataManager.instance.state;
			var isDoing:Boolean = tidState == TaskStates.TS_DOING;
			return !isFullStar || isDoing;
		}
		
		override public function destroy():void
		{
			if(refreshBtnGuide)
			{
				refreshBtnGuide.destroy();
				refreshBtnGuide = null;
			}
			
			if(receiveBtnGuide)
			{
				receiveBtnGuide.destroy();
				receiveBtnGuide = null;
			}
			PanelTaskStarDataManager.instance.detach(this);
			if(_panelTaskStarRefreshHandle)
			{
				_panelTaskStarRefreshHandle.destroy();
				_panelTaskStarRefreshHandle = null;
			}
			if(_panelTaskStarClickHandle)
			{
				_panelTaskStarClickHandle.destroy();
				_panelTaskStarClickHandle = null;
			}
			if(_panelTaskStarInitHnadle)
			{
				_panelTaskStarInitHnadle.destroy();
				_panelTaskStarInitHnadle = null;
			}
			if(_panelTaskStarAddFuncHandle)
			{
				_panelTaskStarAddFuncHandle.destroy();
				_panelTaskStarAddFuncHandle = null;
			}
			super.destroy();
		}
		
		override protected function initSkin():void
		{
			_skin = new McTaskStar();

			addChild(_skin);
			setTitleBar((_skin as McTaskStar).mcTitle);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			_panelTaskStarAddFuncHandle = new PanelTaskStarAddFuncHandle();
			_panelTaskStarAddFuncHandle.deal(rsrLoader,this);
		}
		
		override protected function initData():void
		{
			_panelTaskStarInitHnadle = new PanelTaskStarInitHnadle(this);
			_panelTaskStarClickHandle = new PanelTaskStarClickHandle(this);
			_panelTaskStarRefreshHandle = new PanelTaskStarRefreshHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_TASK_STAR_INFO:
					_panelTaskStarRefreshHandle.refresh();
					checkRefreshBtnGuide();
					checkReceiveBtnGuide();
					break;
				default:
					break;
			}
		}
		
		public function set lastBtn(value:MovieClip):void
		{
			_panelTaskStarRefreshHandle.lastBtn = value;
		}
	}
}