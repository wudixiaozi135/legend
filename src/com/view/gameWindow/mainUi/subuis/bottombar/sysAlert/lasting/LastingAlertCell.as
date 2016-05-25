package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.lasting
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class LastingAlertCell extends AlertCellBase
	{
		public function LastingAlertCell()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			var url:String="mainUiBottom/lastingIcon.swf";
			return url;
		}
		
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_9;
		}
			
//		public function getTipType():int
//		{
//			return ToolTipConst.LASTING_TIP;
//		}
		
		override public function destroy():void
		{
//			ToolTipManager.getInstance().detach(this);
			super.destroy();
		}
		
	}
}