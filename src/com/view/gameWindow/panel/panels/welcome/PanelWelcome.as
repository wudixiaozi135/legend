package com.view.gameWindow.panel.panels.welcome
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	
	import flash.events.MouseEvent;
	
	/**
	 * 欢迎面板类
	 * @author Administrator
	 */	
	public class PanelWelcome extends PanelBase
	{
		public function PanelWelcome()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McWelcome = new McWelcome();
			_skin = skin;
			addChild(skin);
		}
		
		override protected function initData():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McWelcome = _skin as McWelcome;
			if(event.target == skin.btn)
			{
				TaskDataManager.instance.setAutoTask(true,"welcome");
				PanelMediator.instance.closePanel(PanelConst.TYPE_WELCOME);
			}
		}
		
		override public function update(proc:int=0):void
		{
			
		}
		
		override public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}