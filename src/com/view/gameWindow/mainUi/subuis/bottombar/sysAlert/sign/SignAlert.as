package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.sign
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class SignAlert extends AlertCellBase
	{
		public function SignAlert()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			// TODO Auto Generated method stub
			var url:String="mainUiBottom/sign.png";
			return url;
		}
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_17;
		}
		
	}
}
