package com.view.gameWindow.panel.panels.school.complex.information
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.FamilyPositionCfgData;
	import com.model.consts.SchoolConst;
	import com.view.gameWindow.panel.panels.school.McInformation;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;

	public class SchoolInfoHandler
	{
		private var _panel:SchoolInfoPanel;
		private var _skin:McInformation;
		public function SchoolInfoHandler(panel:SchoolInfoPanel)
		{
			this._panel = panel;
			_skin=panel.skin as McInformation;
		}
		
		public function updatePanel():void
		{
			var schoolInfoData:SchoolInfoData = SchoolElseDataManager.getInstance().schoolInfoData;
			_skin.txtRank.text=schoolInfoData.rank+"";
			_skin.txtName.text=schoolInfoData.name;
			_skin.txtLaoda.text=schoolInfoData.leaderName;
			_skin.txtPCount.text=schoolInfoData.count+"/"+schoolInfoData.maxCount;
			_skin.txtFund.text=schoolInfoData.money+"";
			var dataPosition:String=SchoolDataManager.getInstance().positionDic[schoolInfoData.position];
			var familyPositionCfgData:FamilyPositionCfgData=ConfigDataManager.instance.familyPositionCfgData(schoolInfoData.position);
			_skin.txt18.text=dataPosition;
			_skin.txt15.visible=((familyPositionCfgData.jurisdiction&SchoolConst.JURISDICTION_ADMIN)==SchoolConst.JURISDICTION_ADMIN)as Boolean;
			_skin.txt20.text=schoolInfoData.contribute+"";
			
			if(_panel.lastBtn==_skin.tab0)
			{
				_skin.txt14.text=schoolInfoData.notice;
			}else
			{
				_skin.txt14.text=schoolInfoData.noticeExter;
			}
			
			if((familyPositionCfgData.jurisdiction&SchoolConst.JURISDICTION_16)==SchoolConst.JURISDICTION_16)
			{
				_skin.txt7.visible=true;
				_skin.btnAuction.visible=true;
			}else
			{
				_skin.txt7.visible=false;
				_skin.btnAuction.visible=false;
			}
			
			if((familyPositionCfgData.jurisdiction&SchoolConst.JURISDICTION_32)==SchoolConst.JURISDICTION_32)
			{
				_skin.txt9.visible=true;
			}else
			{
				_skin.txt9.visible=false;	
			}
			
			if(schoolInfoData.position==1)//如果是帮主
			{
				_skin.btnDissolve.visible=true;
				_skin.txt22.visible=true;
			}else
			{
				_skin.btnDissolve.visible=false;
				_skin.txt22.visible=false;
			}
			_skin.txt23.visible=_skin.btnRecruit.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN);
		}
		
		public function destroy():void
		{
			
		}
	}
}