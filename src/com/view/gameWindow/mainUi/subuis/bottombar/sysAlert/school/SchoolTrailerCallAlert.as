package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.school
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class SchoolTrailerCallAlert extends AlertCellBase
	{
		public function SchoolTrailerCallAlert()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			var url:String="mainUiBottom/medicineBtnB.swf";
			return url;
		}
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_11;
		}
	}
}