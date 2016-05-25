package com.view.gameWindow.panel.panels.school.complex.member.nickName
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.FamilyPositionCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.common.InputHandler;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guardSystem.GuardManager;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	public class NickNameMouseHandler
	{

		private var panel:NickNamePanel;
		private var skin:MCNickName;

		private var inputHandler:InputHandler;

		private var timeIndex:uint;
		public function NickNameMouseHandler(panel:NickNamePanel)
		{
			this.panel = panel;
			skin = panel.skin as MCNickName;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
		}		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			switch(event.target)
			{
				case skin.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_NICKNAME);
					break;
				case skin.btn1:
					doSet();
					break;
				case skin.btn2:
					doDefault();
					break;
			}
		}		
		
		private function doDefault():void
		{
			SchoolElseDataManager.getInstance().setNickName(2);
			PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_NICKNAME);
		}
		
		private function doSet():void
		{
			var type:int=1;
			var para1:String=skin.txtv1.text;
			var para2:String=skin.txtv2.text;
			var para3:String=skin.txtv3.text;
			var para4:String=skin.txtv4.text;
			if(StringUtil.trim(para1)==""||StringUtil.trim(para2)==""||StringUtil.trim(para3)==""||StringUtil.trim(para4)=="")
			{
				Alert.warning(StringConst.SCHOOL_PANEL_5011);
				return;
			}
			if(GuardManager.getInstance().containBannedWord(para1+para2+para3+para4))
			{
				Alert.warning(StringConst.SCHOOL_PANEL_5022);
				return;
			}
			var familyPositionCfgData1:FamilyPositionCfgData = ConfigDataManager.instance.familyPositionCfgData(3);
			var familyPositionCfgData2:FamilyPositionCfgData = ConfigDataManager.instance.familyPositionCfgData(4);
			var familyPositionCfgData3:FamilyPositionCfgData = ConfigDataManager.instance.familyPositionCfgData(5);
			var familyPositionCfgData4:FamilyPositionCfgData = ConfigDataManager.instance.familyPositionCfgData(6);
			if(StringUtil.trim(para1)==familyPositionCfgData1.name&&
				StringUtil.trim(para2)==familyPositionCfgData2.name&&
				StringUtil.trim(para3)==familyPositionCfgData3.name&&
				StringUtil.trim(para4)==familyPositionCfgData4.name)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_5012);
				return;
			}
			SchoolElseDataManager.getInstance().setNickName(type,para1,para2,para3,para4);
			PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_NICKNAME);
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}