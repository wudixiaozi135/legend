package com.view.gameWindow.panel.panels.school.complex.member.item
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.JobConst;
	import com.model.consts.SchoolConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.common.DropDownListWithLoad;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.member.MCMemberItem;
	import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberData;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolBasicData;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.FilterUtil;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.scrollBar.IScrolleeCell;
	import com.view.selectRole.SelectRoleDataManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	
	public class SchoolMemberItem extends MCMemberItem implements IScrolleeCell
	{

		private var rsrLoader:RsrLoader;
		private var _data:SchoolMemberData;
		private const NO_SCHOOL:int=0;
		private var combox:DropDownListWithLoad;
		public function SchoolMemberItem()
		{
			super();
			init();
			this.mouseEnabled=false;
		}
		
		private function init():void
		{
			txt7.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			txt7.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			rsrLoader=new RsrLoader();
			this.txt1.mouseEnabled=false;
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			event.currentTarget.textColor=0xff0000;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			event.currentTarget.textColor=0x00ff00;
		}
		
		public function update(data:SchoolMemberData):void
		{
			this.data = data;
			var sex:String = data.sex==2?"♀":"♂";
			
			txt0.htmlText=HtmlUtils.createHtmlStr(0xd4a460,"<font color='#f541cc'>"+sex+"</font>"+data.name);
			
			if(combox)
			{
				combox.removeEventListener(Event.CHANGE,onComBoxChange);
				combox.destroy();
				combox=null;
			}
			
			var positionArr:Array =SchoolDataManager.getInstance().positionArr;
			var dataPosition:String=SchoolDataManager.getInstance().positionDic[data.position];
			combox=new DropDownListWithLoad(positionArr,this.txt1,81,rsrLoader,this,"downItem","downListBtn",dataPosition);
			combox.mouseChildren=combox.mouseEnabled=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_8);
			combox.addEventListener(Event.CHANGE,onComBoxChange);
			rsrLoader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			txt2.text=StringUtil.substitute(StringConst.TEAM_PANEL_00025,data.reincarn,data.level);
			txt3.text=JobConst.jobName(data.job);
			txt4.text=data.fightPow+"";
			txt5.text=data.contribute+"/"+data.contribute_sum;
			txt6.mouseEnabled=false;
			if(data.state==1)
			{
				this.filters=null;
				txt6.text=StringConst.SCHOOL_PANEL_4014;
				txt7.htmlText= HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_4015+"</u>");
				ToolTipManager.getInstance().attachByTipVO(txt7,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xd4a460,StringConst.SCHOOL_PANEL_5008));
			}else
			{
				this.filters=[FilterUtil.getGrayfiltes()];
				var timeDiff:Number = ServerTime.time-data.time;
				if(timeDiff<3600)
				{
					txt6.text=StringConst.SCHOOL_PANEL_4017
				}else if(timeDiff<3600*24)
				{
					txt6.text=StringConst.SCHOOL_PANEL_4018
				}else
				{
					txt6.text=StringConst.SCHOOL_PANEL_4019
				}
			}
			txt7.visible=data.state==1;
			
			if(data.cid==SelectRoleDataManager.getInstance().selectCid&&data.sid==SelectRoleDataManager.getInstance().selectSid)
			{
				txt7.htmlText= HtmlUtils.createHtmlStr(0xff0000,"<u>"+StringConst.SCHOOL_PANEL_4015+"</u>");
				txt7.mouseEnabled=false;
			}else
			{
				txt7.mouseEnabled=true;
			}
		}
		
		protected function onComBoxChange(event:Event):void
		{
			var selectedIndex:int = combox.selectedIndex;
			var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
			var selectCid:int = SelectRoleDataManager.getInstance().selectCid;
			var selectSid:int = SelectRoleDataManager.getInstance().selectSid;
			if(selectedIndex==0&&schoolBaseData.schoolPosition==1)
			{
				var createHtmlStr:String = HtmlUtils.createHtmlStr(0xd4a460,StringUtil.substitute(StringConst.SCHOOL_PANEL_2022,"<font color='#00ff00'>"+data.name+"</font>"));
				Alert.show2(createHtmlStr,function ():void
				{
					SchoolElseDataManager.getInstance().sendAppointMentReq(data.cid,data.sid,selectedIndex+1);
				},null,"","",function ():void{
					combox.setSelectedIndex(data.position-1);
				});
				return;
			}
			if(data.position<=schoolBaseData.schoolPosition||selectedIndex<schoolBaseData.schoolPosition||(data.cid==selectCid&&data.sid==selectSid))
			{
				Alert.warning(StringConst.SCHOOL_PANEL_0040);
				combox.setSelectedIndex(data.position-1);
				return;
			}
			combox.setSelectedIndex(data.position-1);
			SchoolElseDataManager.getInstance().sendAppointMentReq(data.cid,data.sid,selectedIndex+1);
		}
		
		public function destroy():void
		{
			if(combox)
			{
				combox.removeEventListener(Event.CHANGE,onComBoxChange);
				combox.destroy();
				combox=null;
			}
			if(rsrLoader)
			{
				rsrLoader.destroy();
				rsrLoader = null;
			}
			ToolTipManager.getInstance().detach(txt7);
			txt7.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			txt7.removeEventListener(MouseEvent.MOUSE_UP,onMouseOver);
		}

		public function get data():SchoolMemberData
		{
			return _data;
		}

		public function set data(value:SchoolMemberData):void
		{
			_data = value;
		}
	}
}