package com.view.gameWindow.panel.panels.artifact.tabArtifact
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ArtifactCfgData;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.artifact.ArtifactDataManager;
    import com.view.gameWindow.panel.panels.artifact.McArtifact;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.UICenter;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.UtilItemParse;

    import flash.events.MouseEvent;
    import flash.events.TextEvent;

    public class TabArtifactMouseHandle
	{
		private var _mc:McArtifact;
		private var _panel:TabArtifact;
		internal var cfg:ArtifactCfgData;
		private var _uiCenter:UICenter;
		
		public function TabArtifactMouseHandle(panel:TabArtifact)
		{
			_panel = panel;
			_mc = _panel.skin as McArtifact;
			initHandle();
		}
		
		private function initHandle():void
		{
			_uiCenter = new UICenter();
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_mc.desc.addEventListener(TextEvent.LINK,linkHandle);
		}
		
		protected function linkHandle(event:TextEvent):void
		{
			var num:int = _panel._linkText.getItemCount();
			var name:String;
			var tabIndex:int;
            var tabSubIndex:int;
            var linkItem:LinkTextItem;
			for(var i:int = 1;i<num+1;i++)
			{
				if(event.text == i.toString())
				{
					name = UICenter.getUINameFromMenu(_panel._linkText.getItemById(i).panelId.toString());
					_uiCenter.openUI(name);
                    linkItem = _panel._linkText.getItemById(i);
                    tabIndex = linkItem.panelPage;
                    tabSubIndex = linkItem.subTabIndex;
					if(tabIndex>=0)
					{
                        var tab:* = UICenter.getUI(name);
						if(tab)
						{
                            if (tab.hasOwnProperty("setTabIndex"))
                            {
                                tab.setTabIndex(tabIndex);
                            }
                            if (tab.hasOwnProperty("setSubTabIndex"))
                            {
                                tab.setSubTabIndex(tabSubIndex);
                            }
						}
					}
				}
			}
		}
		
		protected function clickHandle(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mc.mcContain.btnSure:
					dealSure();
					break;
			}
		}
		
		private function dealSure():void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			cfg = _panel._ArtifactSidebar._selectedItemCfg;
			var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(cfg.equipid);
			var storage:int = 0;
			var slot:int = 0;
			var baseId:int;
			if(!cfg)
			{
				return;
			}
			if(cfg.equip_cost)
			{
				baseId = UtilItemParse.getThingsData(cfg.equip_cost).id;
				if(!RoleDataManager.instance.getEquipCellDataById(baseId) && !BagDataManager.instance.getBagCellDataByBaseId(baseId))
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.ARTIFACT_PANEL_0009);
					return;
				}
				else
				{
					if(RoleDataManager.instance.getEquipCellDataById(baseId) &&!BagDataManager.instance.getBagCellDataByBaseId(baseId) && (RoleDataManager.instance.reincarn<equipCfg.reincarn ||
						(RoleDataManager.instance.reincarn == equipCfg.reincarn && RoleDataManager.instance.lv < equipCfg.level)))
					{
						RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.ARTIFACT_PANEL_0012);
						return;
					}
					if(RoleDataManager.instance.getEquipCellDataById(baseId))
					{
						storage = RoleDataManager.instance.getEquipCellDataById(baseId).storageType;
						slot = RoleDataManager.instance.getEquipCellDataById(baseId).slot;
					}
					else
					{
						storage = BagDataManager.instance.getBagCellDataByBaseId(baseId).storageType;
						slot = BagDataManager.instance.getBagCellDataByBaseId(baseId).slot;
					}
				}
			}
			if(cfg.item_cost)
			{
				if(BagDataManager.instance.getItemNumById(UtilItemParse.getThingsData(cfg.item_cost).id) < UtilItemParse.getThingsData(cfg.item_cost).count)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.ARTIFACT_PANEL_0009);
					return;
				}
			}
			if((BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind) < cfg.coin_cost)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.ARTIFACT_PANEL_0010);
				return;
			}
			ArtifactDataManager.instance.sendData(cfg.equipid,storage,slot);
		}
		
		public function destory():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc.desc.removeEventListener(TextEvent.LINK,linkHandle);
				_mc = null;
			}
			_uiCenter = null;
			_panel = null;
			cfg = null;
		}
	}
}