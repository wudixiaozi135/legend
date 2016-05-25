package com.view.gameWindow.panel.panels.boss.individual
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.consts.DungeonConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCIndividualBoss;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	public class TabIndividualBoss extends TabBase
	{
		private var _viewHandle:TabIndividualViewHandle;
		public function TabIndividualBoss()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCIndividualBoss= new MCIndividualBoss;			 
			_skin = skin;
			_skin.mouseEnabled = false;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			_viewHandle = new TabIndividualViewHandle(this);
			_viewHandle.init(rsrLoader);
			
		}
		
		override protected function initData():void
		{
			DgnDataManager.instance.queryChrDungeonInfo();
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
				case GameServiceConstants.SM_BAG_ITEMS:
					_viewHandle.refreshChrDungeon();
					_viewHandle.refresh();
					break;
				case GameServiceConstants.SM_CHR_DUNGEON_INFO:
//					_viewHandle.refreshChrDungeon();
					_viewHandle.refresh();
					break;
				case GameServiceConstants.SM_ENTER_DUNGEON:
				{
					var dungeonId:int = BossDataManager.instance.dungeonId;
					var dgnCfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeonId);
					if(dgnCfgDt.func_type == DungeonConst.FUNC_TYPE_PRIVATE)
					{
						PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
					}
					break;
				}
				case GameServiceConstants.CM_CLEAR_DUNGEON_ONLINE_CHECK:
				{
					//_viewHandle.
				}
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
			DgnDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			BossDataManager.instance.detach(this);
			DgnDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}