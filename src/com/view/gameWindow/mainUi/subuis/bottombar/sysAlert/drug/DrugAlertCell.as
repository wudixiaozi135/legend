package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.drug
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.GameConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.SysAlertHandle;
	
	public class DrugAlertCell extends AlertCellBase
	{
		public function DrugAlertCell()
		{
			super();
		}
		
		override protected function getIconUrl():String
		{
			// TODO Auto Generated method stub
			var url:String
			if(type==SysAlertHandle.HP)
			{
				url="mainUiBottom/medicineBtnR.swf";
			}else
			{
				url="mainUiBottom/medicineBtnB.swf";
			}
			return url;
		}
		
		override protected function getTipStr():String
		{
			// TODO Auto Generated method stub
			var str:String="";
			
			if(id==GameConst.ROLE)
			{
				str=StringConst.SYSTEM_ALERT_3;
			}else
			{
				str=StringConst.SYSTEM_ALERT_4;
			}
			if(type==SysAlertHandle.HP)
			{
				str+=StringConst.SYSTEM_ALERT_1;
			}else
			{
				str+=StringConst.SYSTEM_ALERT_2;
			}
			return str;
		}
	}
}