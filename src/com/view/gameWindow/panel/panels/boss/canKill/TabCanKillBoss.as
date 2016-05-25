package com.view.gameWindow.panel.panels.boss.canKill
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCFieldBoss;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	public class TabCanKillBoss extends TabBase
	{
		private var _viewHandle:TabCanKillViewHandle;
		
		public function TabCanKillBoss()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCFieldBoss= new MCFieldBoss;
			_skin = skin;
			addChild(_skin);
			
			initText(skin);
		}
		
		private function initText(skin:MCFieldBoss):void
		{
//			skin.txt1.text=StringConst.BOSS_PANEL_0041;
			skin.mapTxt.text=StringConst.BOSS_PANEL_0042;
		}		
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{	 
			_viewHandle = new TabCanKillViewHandle(this);
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