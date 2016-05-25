package com.view.gameWindow.panel.panels.hero
{
	import com.view.gameWindow.panel.panels.hero.tab1.HeroEquipTab;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class HeroPanelTimerHandler
	{
		private var timer:Timer;
		private var _heroPanel:HeroEquipTab;
		
		public function HeroPanelTimerHandler(heroPanel:HeroEquipTab)
		{
			_heroPanel=heroPanel;
			timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,timerUpdateFunc);
			timer.start();
		}
		
		private function timerUpdateFunc(e:TimerEvent):void
		{
			_heroPanel.timer();
		}
		
		public function destroy():void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,timerUpdateFunc);
		}
	}
}