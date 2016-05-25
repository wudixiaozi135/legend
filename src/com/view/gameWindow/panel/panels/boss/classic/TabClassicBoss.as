package com.view.gameWindow.panel.panels.boss.classic
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCClassicBoss;
	import com.view.gameWindow.util.tabsSwitch.TabBase;

	public class TabClassicBoss extends TabBase
	{
		//internal var mouseHandle:TabClassicBossmouseHandle;
		internal var viewHandle:TabClassicBossViewHandle;
		public function TabClassicBoss()
		{
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
 
			viewHandle = new TabClassicBossViewHandle(this);
			viewHandle.init(rsrLoader)
		}
 
		override protected function initSkin():void
		{
			// TODO Auto Generated method stub
			//super.initSkin();
			var skin:MCClassicBoss = new MCClassicBoss;
			_skin = skin;
			addChild(_skin);
		}
		override public function update(proc:int = 0):void
		{
			// TODO Auto Generated method stub
			super.update(proc);
			switch(proc)
			{
				case GameServiceConstants.SM_BOSS_HP_INFO:
					viewHandle.refresh();
					break;
			}
			
		}
		override public function refresh():void
		{
			viewHandle.refresh();
		}
		
		override public function destroy():void
		{
			viewHandle.destroy();
			viewHandle = null;
			super.destroy();
		}
		
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			BossDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			BossDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}