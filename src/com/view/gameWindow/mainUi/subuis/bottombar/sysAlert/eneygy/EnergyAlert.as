package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.eneygy
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class EnergyAlert extends AlertCellBase
	{
		public function EnergyAlert()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			// TODO Auto Generated method stub
			var url:String="mainUiBottom/energy.png";
			return url;
		}
		
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_20;
		}
		
	}
}