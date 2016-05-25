package com.view.gameWindow.panel.panels.boss.vip
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCVIPBoss;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	public class TabVipBoss extends TabBase
	{
		private var _viewHandle:TabVipViewHandle;
		
		public function TabVipBoss()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCVIPBoss= new MCVIPBoss;
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{	 
			_viewHandle = new TabVipViewHandle(this);
			_viewHandle.init(rsrLoader);
		}

		override public function refresh():void
		{
			_viewHandle.refresh();
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_BOSS_HP_INFO:
					_viewHandle.refresh();
					break;	
			}
			
		}
		override public function destroy():void
		{
			_viewHandle.destroy(); 
			_viewHandle = null;

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