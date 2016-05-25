package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.skill
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	
	/**
	 * @author wqhk
	 * 2015-1-27
	 */
	public class SkillLearnAlert extends AlertCellBase
	{
		public function SkillLearnAlert()
		{
//			super();
		}
		
		override protected function getIconUrl():String
		{
			var url:String = "mainUiBottom/skillLearnIcon.swf";
			return url;
		}
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_14;
		}	
	}
}