package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.individualBoss
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class IndividualBossAlert extends AlertCellBase
	{
		public function IndividualBossAlert()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			// TODO Auto Generated method stub
			var url:String="mainUiBottom/IndBOSS.png";
			return url;
		}
		
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_18;
		}
		
	}
}