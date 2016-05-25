package com.view.gameWindow.panel.panels.taskStar.over
{
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.taskStar.McTaskStarOver;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	
	/**
	 * 星级任务完成面板类
	 * @author Administrator
	 */	
	public class PanelTaskStarOver extends PanelBase implements IPanelTaskStarOver
	{
		private var _panelTaskStarOverClickHandle:PanelTaskStarOverClickHandle;
		private var _panelTaskStarOverInitHandle:PanelTaskStarOverInitHandle;
		
		public function PanelTaskStarOver()
		{
			super();
			PanelTaskStarDataManager.instance.attach(this);
		}
		
		override public function destroy():void
		{
			PanelTaskStarDataManager.instance.detach(this);
			if(_panelTaskStarOverClickHandle)
			{
				_panelTaskStarOverClickHandle.destroy();
				_panelTaskStarOverClickHandle = null;
			}
			if(_panelTaskStarOverInitHandle)
			{
				_panelTaskStarOverInitHandle.destroy();
				_panelTaskStarOverInitHandle = null;
			}
			super.destroy();
		}
		
		override protected function initSkin():void
		{
			_skin = new McTaskStarOver();
			addChild(_skin);
			setTitleBar((_skin as McTaskStarOver).mcTitle);
		}
		
		override protected function initData():void
		{
			_panelTaskStarOverInitHandle = new PanelTaskStarOverInitHandle(this);
			_panelTaskStarOverClickHandle = new PanelTaskStarOverClickHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			_panelTaskStarOverInitHandle.refresh();
		}
	}
}