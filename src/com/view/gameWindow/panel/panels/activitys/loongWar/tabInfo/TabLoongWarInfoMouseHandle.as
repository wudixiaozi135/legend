package com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.activitys.loongWar.McLoongWarMouseLayer;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.menus.handlers.RoleMenuHandle;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.events.MouseEvent;

	public class TabLoongWarInfoMouseHandle
	{
		private var _tab:TabLoongWarInfo;
		private var _skin:McLoongWarInfo;

		public function TabLoongWarInfoMouseHandle(tab:TabLoongWarInfo)
		{
			_tab = tab;
			_skin = tab.skin as McLoongWarInfo;
			initialize();
		}
		
		private function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if (event.target == _skin.btnGoto)
			{
				if (RoleDataManager.instance.stallStatue)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
					return;
				}
			}
			switch(event.target)
			{
				/*case _skin.txtTitle0:
					dealTxtTitle(DataInfo.POSITION_MAIN);
					break;*/
				case _skin.txtTitle1:
					dealTxtTitle(DataLoongWarInfo.POSITION_VICE);
					break;
				case _skin.txtTitle2:
					dealTxtTitle(DataLoongWarInfo.POSITION_GENERAL);
					break;
				case _skin.txtTitle3:
					dealTxtTitle(DataLoongWarInfo.POSITION_ZS);
					break;
				case _skin.txtTitle4:
					dealTxtTitle(DataLoongWarInfo.POSITION_FS);
					break;
				case _skin.txtTitle5:
					dealTxtTitle(DataLoongWarInfo.POSITION_DS);
					break;
				case _skin.btnGoto:
					dealBtnGoto();
					break;
				case _skin.btnChange:
					dealBtnChange();
					break;
				case _skin.mcRule.btnClose:
				case _skin.btnRule:
					dealBtnRule();
					break;
				default:
					dealDefault(event);
					break;
			}
		}
		
		private function dealTxtTitle(position:int):void
		{
			ActivityDataManager.instance.loongWarDataManager.cmLongchengAppointList(position);
			PanelMediator.instance.openPanel(PanelConst.TYPE_LOONG_WAR_LIST_SET,true,position);
		}
		
		private function dealBtnGoto():void
		{
			var actCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(ActivityFuncTypes.AFT_LOONG_WAR);
			var npcId:int = actCfgData.npc;
			var born_region:int = actCfgData.born_region;
			/*if(npcId)
			{
				AutoJobManager.getInstance().setAutoTargetData(npcId,EntityTypes.ET_NPC);
			}
			else if(born_region)
			{
				var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(born_region);
				AutoJobManager.getInstance().setAutoFindPathPos(mapRegionCfgData.randomPoint,mapRegionCfgData.map_id);
			}*/
			if(npcId)
			{
				DailyDataManager.instance.requestTeleport(npcId);
			}
			else if(born_region)
			{
				DailyDataManager.instance.requestTeleport1(born_region);
			}
			else
			{
				trace("TabLoongWarInfoMouseHandle.dealBtnGoto() 配置错误");
			}
		}
		
		private function dealBtnChange():void
		{
			var isLoongWarChatelain:Boolean = ActivityDataManager.instance.loongWarDataManager.isLoongWarChatelain;
			if(!isLoongWarChatelain)
			{
				Alert.warning(StringConst.LOONG_WAR_ERROR_0006);
				return;
			}
			PanelMediator.instance.switchPanel(PanelConst.TYPE_LOONG_WAR_CHANGE);
		}
		
		private function dealBtnRule():void
		{
			_skin.mcRule.visible = !_skin.mcRule.visible;
		}
		
		private function dealDefault(event:MouseEvent):void
		{
			var layer:McLoongWarMouseLayer = event.target as McLoongWarMouseLayer;
			if(!layer)
			{
				return;
			}
			var dt:DataLoongWarInfo = layer.dt as DataLoongWarInfo;
			if(!dt)
			{
				return;
			}
			var roleMenuHandle:RoleMenuHandle = new RoleMenuHandle();
			roleMenuHandle.onClick(event,dt.cid,dt.sid,dt.namePlayer);
		}
		
		public function destroy():void
		{
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			_tab = null;
		}
	}
}