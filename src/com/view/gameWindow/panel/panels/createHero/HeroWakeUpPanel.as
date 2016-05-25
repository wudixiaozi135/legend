package com.view.gameWindow.panel.panels.createHero
{
	import com.greensock.TweenMax;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	
	public class HeroWakeUpPanel extends PanelBase
	{
		public var compleF:Function;
		public function HeroWakeUpPanel()
		{
			super();
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override protected function initSkin():void
		{
			_skin=new McWakeUpPanel();
			addChild(_skin);
			_skin.mc1.scaleX=0;
		}
		
		public function play():void
		{
			var mc:McWakeUpPanel = _skin as McWakeUpPanel;
			TweenMax.to(mc.mc1,2,{scaleX:1,onComplete:onCompleFunc});
		}
		
		private function onCompleFunc():void
		{
			if(compleF!=null)
			{
				compleF();
			}
			PanelMediator.instance.switchPanel(PanelConst.TYPE_HERO_WAKEUP);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
	}
}