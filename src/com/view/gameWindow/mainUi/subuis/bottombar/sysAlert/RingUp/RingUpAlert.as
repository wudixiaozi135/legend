package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.RingUp
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class RingUpAlert extends AlertCellBase
	{
		public function RingUpAlert()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			// TODO Auto Generated method stub
			var url:String="mainUiBottom/achievement.png";
			return url;
		}
		
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_19;
		}
		
	}
}