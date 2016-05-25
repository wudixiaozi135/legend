package com.view.gameWindow.panel.panels.boss.world
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCWorldBoss;
	import com.view.gameWindow.util.tabsSwitch.TabBase;

	public class TabWorldBoss extends TabBase
	{
		public var viewHandle:TabWorldBossViewHandle;
		//public var mouseHandle:TabWorldBossMouseHandle;
		public function TabWorldBoss()
		{
			super();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			super.addCallBack(rsrLoader);
		}
		
		override protected function initData():void
		{
			// TODO Auto Generated method stub
			super.initData();
			viewHandle = new TabWorldBossViewHandle(this);
			//mouseHandle = new TabWorldBossMouseHandle(this);
		}
		
		override protected function initSkin():void
		{
			// TODO Auto Generated method stub
			//super.initSkin();
			var skin:MCWorldBoss = new MCWorldBoss;
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
			// TODO Auto Generated method stub
			
			
			 
			/*if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}*/
			
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
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