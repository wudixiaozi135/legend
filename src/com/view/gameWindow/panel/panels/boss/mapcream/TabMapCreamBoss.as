package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCMapCreamBoss;
	import com.view.gameWindow.panel.panels.boss.MCMapCreamBossItem;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;

	public class TabMapCreamBoss extends TabBase
	{
		//public var callbackHandle;
		public var viewHandle:TabMapCreamViewHandle;
		public var mouseHandle:TabMapCreamMouseHandle;		
		
		
		 
		public function TabMapCreamBoss()
		{
	
					 
		}
		
		 
		override protected function initSkin():void
		{
 
			var skin:MCMapCreamBoss = new MCMapCreamBoss();
			_skin = skin;
			addChild(_skin);
 
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:MCMapCreamBoss = _skin as MCMapCreamBoss; 
			
			viewHandle = new TabMapCreamViewHandle(this);
			viewHandle.init(rsrLoader);
			mouseHandle = new TabMapCreamMouseHandle(this);
			/*var len:int = _items.length;
			for(var i:int = 0;i<6 ;i++) 
			{
				_items[i].init(rsrLoader);
			}   */
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
			 	
			 
			/*FOR(VAR I:INT = 0;I<6;I++)
			{
				_ITEMS[I].DESTROY();
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