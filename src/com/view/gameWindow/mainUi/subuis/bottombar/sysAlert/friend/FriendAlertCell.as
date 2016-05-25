package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.friend
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class FriendAlertCell extends AlertCellBase
	{
		public function FriendAlertCell()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			
			var url:String="mainUiBottom/friendIcon.swf";
			return url;
		}
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_5;
		}
		
	}
}