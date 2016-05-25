package com.view.gameWindow.panel.panels.boss.classic
{
	import com.view.gameWindow.panel.panels.boss.MCClassicBoss;
	
	import flash.events.MouseEvent;

	public class TabClassicBossmouseHandle
	{
		private var _tab:TabClassicBoss;
		private var _skin:MCClassicBoss;
		public function TabClassicBossmouseHandle(tab:TabClassicBoss)
		{
			_tab = tab;
			_skin = _tab.skin as MCClassicBoss;
			init();
		}
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
			_skin.addEventListener(MouseEvent.CLICK,onOver,false,0,true);
			_skin.addEventListener(MouseEvent.CLICK,onOut,false,0,true);
		}
		
		private function onClick(e:MouseEvent):void
		{ 
			
		}
		
		private function onOver(e:MouseEvent):void
		{
			
		}
		
		private function onOut(e:MouseEvent):void
		{
			
		}
		
		
	}
}