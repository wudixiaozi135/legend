package com.view.gameWindow.panel.panels.boss.world
{
	import com.view.gameWindow.panel.panels.boss.MCWorldBoss;
	import com.view.gameWindow.panel.panels.boss.McWorldBossItem;
	
	import flash.events.MouseEvent;

	public class TabWorldBossMouseHandle
	{
		
		private var _tab:TabWorldBoss;
		private var _skin:MCWorldBoss;
		
		private var currentTarget:McWorldBossItem;
		public function TabWorldBossMouseHandle(tab:TabWorldBoss)
		{
			_tab = tab;
			_skin = tab.skin as MCWorldBoss;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			_skin.addEventListener(MouseEvent.MOUSE_OUT,onOut);
		}
		
		private function onOut(e:MouseEvent):void
		{
			var target:McWorldBossItem = e.target as McWorldBossItem;
			if(target && currentTarget != target)
			{
				target.mcstate.visible = false;
				
			}
		}
		
		private function onOver(e:MouseEvent):void
		{
			var target:McWorldBossItem = e.target as McWorldBossItem;
			if(target && currentTarget != target)
			{
				 
				target.mcstate.visible = true;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			var target:McWorldBossItem = e.target as McWorldBossItem;
			if(target && currentTarget != target)
			{
				target.mcstate.visible = true;
				_tab.viewHandle.setItemShow(target);
				currentTarget = target;
			}
		}
		
		internal function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			_skin.removeEventListener(MouseEvent.MOUSE_OVER,onOver);
			_skin.removeEventListener(MouseEvent.MOUSE_OUT,onOut);
			
		}
		
	}
}