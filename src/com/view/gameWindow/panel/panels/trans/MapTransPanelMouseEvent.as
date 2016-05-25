package com.view.gameWindow.panel.panels.trans
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilCostRollTip;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class MapTransPanelMouseEvent
	{
		private var _mc:McMapTransPanel;
		
		public function MapTransPanelMouseEvent()
		{
		}
		
		public function addEvent(mc:McMapTransPanel):void
		{
			_mc = mc;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_mc.addEventListener(MouseEvent.MOUSE_OVER,overHandle);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,outHandle);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_MAP_TRANS);
					break;
				case _mc.txt_06:
					mapTeleport();
					break;
					
			}
		}
		
		private function mapTeleport():void
		{
			var npcTeleportCfgData:NpcTeleportCfgData;
			var npcTeleportId:int = PanelTransData.npcTeleportId;
			var npcId:int = PanelNpcFuncData.npcId;
			npcTeleportCfgData = ConfigDataManager.instance.npcTeleportCfgData(npcTeleportId);
			var mapRegionCfg:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(npcTeleportCfgData.region_to);
			var mapCfg:MapCfgData =  ConfigDataManager.instance.mapCfgData(mapRegionCfg.map_id);
			if(mapCfg.reincarn > RoleDataManager.instance.reincarn)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DUNGEON_PANEL_0024);
				return;
			}
			else if(mapCfg.reincarn == RoleDataManager.instance.reincarn)
			{
				if(mapCfg.level > RoleDataManager.instance.lv)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DUNGEON_PANEL_0024);
					return;
				}
				else
				{
					if(!UtilCostRollTip.costEnoughOnlyOne(npcTeleportCfgData))
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,UtilCostRollTip.str);
						return;
					}
				}
			}
			else
			{
				if(!UtilCostRollTip.costEnoughOnlyOne(npcTeleportCfgData))
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,UtilCostRollTip.str);
					return;
				}
			}
			TeleportDatamanager.instance.requestTeleportNpc(npcTeleportId);
			PanelMediator.instance.closePanel(PanelConst.TYPE_MAP_TRANS);
		}
		
		private function overHandle(evt:MouseEvent):void
		{
			if(evt.target == _mc.txt_06)
			{
				TextFormatManager.instance.setTextFormat(evt.target as TextField,0xff0000,true,false);
			}
		}
		
		private function outHandle(evt:MouseEvent):void
		{
			if(evt.target == _mc.txt_06)
			{			
				_mc.txt_06.htmlText = HtmlUtils.createHtmlStr(0x00ff00,_mc.txt_06.text,12,false,2,StringConst.STRING_0001,true);
			}
		}
		
		public function destoryEvent():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc.removeEventListener(MouseEvent.MOUSE_MOVE,overHandle);
				_mc.removeEventListener(MouseEvent.MOUSE_OUT,outHandle);
				_mc = null;
			}
			PanelTransData.normal_monster = null;
			PanelTransData.elite_monster = null;
		}
	}
}