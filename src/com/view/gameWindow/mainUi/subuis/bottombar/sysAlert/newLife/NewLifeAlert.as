package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.newLife
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class NewLifeAlert extends AlertCellBase
	{
		public function NewLifeAlert()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			var url:String ="mainUiBottom/reincarn.swf";
			return url;
		}
		
		override protected function getTipStr():String
		{
			return StringConst.ICON_TIP_0001;
		}		
	}
}