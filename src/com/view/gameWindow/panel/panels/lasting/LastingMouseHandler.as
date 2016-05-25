package com.view.gameWindow.panel.panels.lasting
{
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelPage;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.mall.MallDataManager;
	import com.view.gameWindow.panel.panels.mall.constant.MallTabType;
	import com.view.gameWindow.panel.panels.mall.constant.ShopShelfType;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	
	import flash.events.MouseEvent;

	public class LastingMouseHandler
	{
		private var _panel:PanelLasting;
		private var _skin:McLasting;
		private static const NPCID:int = 10402;
		private static const ZSYID:int = 6011;
		public function LastingMouseHandler(panel:PanelLasting)
		{
			_panel = panel;
			_skin = _panel.skin as McLasting;
			initialize();
		}
		
		private function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var skin:McLasting = _skin as McLasting;
			switch(event.target)
			{
				case skin.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_REPAIR_ALERT);
					break;
				case skin.btnShoe:
					TeleportDatamanager.instance.setTargetEntity(NPCID,EntityTypes.ET_NPC);
					GameFlyManager.getInstance().flyToMapByNPC(NPCID);
					AutoSystem.instance.stopAuto(true);
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_REPAIR_ALERT);
					break;
				case skin.btnNpc:
					AutoSystem.instance.stopAuto(true);
					AutoJobManager.getInstance().setAutoTargetData(NPCID,EntityTypes.ET_NPC);
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_REPAIR_ALERT);
					break;
				case skin.btnShop:
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_REPAIR_ALERT);
					var panel:IPanelTab;
					PanelMediator.instance.openPanel(PanelConst.TYPE_MALL);
					panel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL) as IPanelTab;
					panel.setTabIndex(MallTabType.TYPE_TICKET);
					var pageIndex:int = MallDataManager.instance.getPageIndex(MallTabType.TYPE_TICKET+1,ZSYID);
					var page:IPanelPage = PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL) as IPanelPage;
					if(page)
					{
						page.setPageIndex(pageIndex);
					}	
					break;
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}