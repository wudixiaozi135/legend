package com.view.gameWindow.panel.panels.school.complex.list.card
{
	import com.model.configData.cfgdata.FamilyCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.InputHandler;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;

	public class CardMouseHandler
	{

		private var panel:CardPanel;
		private var skin:MCCard;

		private var inputHandler:InputHandler;

		private var timeIndex:uint;
		public function CardMouseHandler(panel:CardPanel)
		{
			this.panel = panel;
			skin = panel.skin as MCCard;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
		}		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			switch(event.target)
			{
				case skin.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_CARD);
					break;
				case skin.btnJoin:
					doJoin();
					break;
			}
		}		
		
		private function doJoin():void
		{
			var cfg:FamilyCfgData=SchoolDataManager.getInstance().getSchoolCreateCfg();
			var lookSchoolData:SchoolData = SchoolDataManager.getInstance().lookSchoolData;
			if(RoleDataManager.instance.lv<cfg.join_level)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.SCHOOL_PANEL_0038,cfg.join_level));
				return;
			}
			SchoolDataManager.getInstance().joinSchoolRequest(lookSchoolData.id,lookSchoolData.sid);
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}