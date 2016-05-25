package com.view.gameWindow.panel.panels.school.complex.member.auditList
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.DropDownListWithLoad;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.member.MCAuditList;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SchoolAuditListPanel extends PanelBase
	{
		private var _handler:SchoolAuditListHandler;
		private var _mouseHandler:SchoolAuditListMouseHandler;
		private var combox:DropDownListWithLoad;

		private var comboxArr:Array;
		public function SchoolAuditListPanel()
		{
			super();
			SchoolElseDataManager.getInstance().attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:MCAuditList = new MCAuditList();
			_skin = skin as MCAuditList;
			addChild(_skin);
			initText(skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.SCHOOL_PANEL_5000,14,true);
			_handler=new SchoolAuditListHandler(this);
			_mouseHandler=new SchoolAuditListMouseHandler(this);
		}
		
		private function initText(skin:MCAuditList):void
		{
			skin.txt1.text=StringConst.SCHOOL_PANEL_5001;
			skin.txt2.text=StringConst.SCHOOL_PANEL_5002;
			skin.txt3.text=StringConst.SCHOOL_PANEL_4003;
			skin.txt4.text=StringConst.SCHOOL_PANEL_4004;
			skin.txt5.text=StringConst.SCHOOL_PANEL_0027;
			skin.txtLabel.mouseEnabled=false;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(skin.mcSelectBuf,function (mc:MovieClip):void
			{
				skin.mcSelectBuf.mouseEnabled=false;
				skin.mcSelectBuf.visible=false;
			});
			rsrLoader.addCallBack(skin.mcMouseBuf,function (mc:MovieClip):void
			{
				skin.mcMouseBuf.mouseEnabled=false;
				skin.mcMouseBuf.visible=false;
			});
			rsrLoader.addCallBack(skin.check1,function (mc:MovieClip):void
			{
				SchoolElseDataManager.getInstance().getSchoolApplyListRequest();
			});
			
			comboxArr =[StringConst.SCHOOL_PANEL_5003,StringConst.SCHOOL_PANEL_5004,StringConst.SCHOOL_PANEL_5005];
			combox=new DropDownListWithLoad(comboxArr,skin.txtLabel,117,rsrLoader,skin,"downItem","downListBtn",comboxArr[0]);
			combox.addEventListener(Event.CHANGE,onComboxChanage);
			super.addCallBack(rsrLoader);
		}
		
		protected function onComboxChanage(event:Event):void
		{
			SchoolElseDataManager.getInstance().selectApplyType=combox.selectedIndex;
			if(skin.check1.selected)
			{
				SchoolElseDataManager.getInstance().setAutoAuditRequest(combox.selectedIndex+1);
			}
		}
		
		override public function destroy():void
		{
			if(	combox)
			{
				combox.removeEventListener(Event.CHANGE,onComboxChanage);
				combox.destroy();
			}
			combox=null;
			SchoolElseDataManager.getInstance().detach(this);
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_FAMILY_APPLY_LIST_QUERY:
					updatePanel();
					break;
				default:
					break;
			}
			super.update(proc);
		}
		
		public function updatePanel():void
		{
			_handler.updateList();
			var selectApplyType:int = SchoolElseDataManager.getInstance().selectApplyType;
			if(selectApplyType==0)
			{
				skin.txtLabel.text=comboxArr[selectApplyType];
				skin.check1.selected=false;
			}else
			{
				skin.txtLabel.text=comboxArr[selectApplyType-1];
				skin.check1.selected=true;	
			}
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
	}
}