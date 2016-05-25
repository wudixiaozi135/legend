package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.achievement
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class AchievementAlert extends AlertCellBase
	{
		public function AchievementAlert()
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
			return StringConst.SYSTEM_ALERT_15;
		}
		
		
	}
}
