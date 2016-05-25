package com.view.gameWindow.panel.panels.school.complex.build
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.FamilyCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirmData;
	import com.view.gameWindow.panel.panels.guardSystem.GuardManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.school.McInformation;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.selectRole.SelectRoleDataManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.ByteArray;

	public class SchoolBuildMouseHandler
	{

		private var panel:SchoolBuildPanel;
		private var skin:McInformation;
		public function SchoolBuildMouseHandler(panel:SchoolBuildPanel)
		{
			this.panel = panel;
			skin = panel.skin as McInformation;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.addEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
			skin.txt8.addEventListener(Event.CHANGE,onRemoveText);
		}
		
		protected function onRemoveText(event:Event):void
		{
			skin.txt8.removeEventListener(Event.CHANGE,onRemoveText);
			skin.txt8.text="";
			skin.txt8.textColor=0xd4a480;
			skin.txt8.maxChars=8;
		}
		
		protected function onOutFunc(event:MouseEvent):void
		{
			if(event.target==skin.txt3)
			{
				skin.txt3.textColor=0x00ff00;
			}
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(event.target==skin.txt3)
			{
				skin.txt3.textColor=0xff0000;
			}
		}		
		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			var familyCfg:FamilyCfgData=SchoolDataManager.getInstance().getSchoolCreateCfg();
			if(event.target==skin.txt3)
			{
				var data:NpcShopCfgData =ConfigDataManager.instance.npcShopCfgData1( familyCfg.ncp_shop_id);
				if(data)
				{
					PanelBuyItemConfirmData.cfgDt = data;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
				}
				return;
			}
			
			if(event.target==skin.btnSub)
			{
				dealCreateSchool();
			}
		}		
		
		private function dealCreateSchool():void
		{
			// TODO Auto Generated method stub
			var familyCfg:FamilyCfgData=SchoolDataManager.getInstance().getSchoolCreateCfg();
			var itemCfg:ItemCfgData=ConfigDataManager.instance.itemCfgData(familyCfg.item_id);
			var itemCount:int=BagDataManager.instance.getItemNumById(familyCfg.item_id);
			
			if(skin.txt8.text==StringConst.SCHOOL_PANEL_0011||skin.txt8.text=="")
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0013);
				return;
			}
			if(itemCount<familyCfg.item_num)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0014);
				return;
			}
			if(familyCfg.creat_level>RoleDataManager.instance.lv)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0015);
				return;
			}
			
			if(GuardManager.getInstance().containBannedWord(skin.txt8.text) == true)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0019);
				return;
			}
			SchoolDataManager.getInstance().schoolName=skin.txt8.text;
			SchoolDataManager.getInstance().createSchoolRequest(skin.txt8.text,SelectRoleDataManager.getInstance().selectSid);
		}
		
		public function destroy():void
		{
			skin.txt8.removeEventListener(Event.CHANGE,onRemoveText);
			skin.removeEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.removeEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}