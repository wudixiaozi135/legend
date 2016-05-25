package com.view.gameWindow.panel.panels.school.complex.member.auditList.item
{
	import com.model.consts.JobConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.school.complex.member.MCAuditListItem;
	import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberData;
	import com.view.gameWindow.util.HtmlUtils;
	
	import mx.utils.StringUtil;
	
	public class SchoolAuditListItem extends MCAuditListItem
	{


		private var _data:SchoolMemberData;
		private const NO_SCHOOL:int=0;
		public function SchoolAuditListItem()
		{
			super();
		}
		
		public function update(data:SchoolMemberData):void
		{
			this.data = data;
			txt1.text=data.name;
			txt2.text=data.sex==1?StringConst.SEX_BOY:StringConst.SEX_GIRL;
			txt3.text=StringUtil.substitute(StringConst.TEAM_PANEL_00025,data.reincarn,data.level);
			txt4.text=JobConst.jobName(data.job);
			txt5.htmlText= HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_5006+"</u>");
			txt6.htmlText= HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_5007+"</u>");
		}
		
		public function get data():SchoolMemberData
		{
			return _data;
		}
		
		public function set data(value:SchoolMemberData):void
		{
			_data = value;
		}
		
		
		public function destroy():void
		{
			
		}
	}
}