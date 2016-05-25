package com.view.gameWindow.panel.panels.school.complex.member
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.SchoolConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.DropDownListWithLoad;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.shop.SchoolShopManager;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SchoolMemberPanel extends TabBase
	{
		private var _handler:SchoolMemberHandler;
		private var _mouseHandler:SchoolMemberMouseHandler;
		public var combox:DropDownListWithLoad;
		public function SchoolMemberPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCMemberPanel = new MCMemberPanel();
			_skin = skin;
			addChild(_skin);
			_handler=new SchoolMemberHandler(this);
			_mouseHandler=new SchoolMemberMouseHandler(this);
			initText();
		}
		
		private function initText():void
		{
			var panel:MCMemberPanel = _skin as MCMemberPanel;
			skin.txt0.text=StringConst.SCHOOL_PANEL_4001;
			skin.txt1.text=StringConst.SCHOOL_PANEL_4002;
			skin.txt2.text=StringConst.SCHOOL_PANEL_4003;
			skin.txt3.text=StringConst.SCHOOL_PANEL_4004;
			skin.txt4.text=StringConst.SCHOOL_PANEL_4005;
			skin.txt5.text=StringConst.SCHOOL_PANEL_4006;
			skin.txt6.text=StringConst.SCHOOL_PANEL_4007;
			skin.txt7.text=StringConst.SCHOOL_PANEL_4008;
			skin.txt8.mouseEnabled=false;
			skin.txt9.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_4009+"</u>");
			
			panel.txtb1.text=StringConst.SCHOOL_PANEL_4010;
			panel.txtb1.mouseEnabled=false;
			panel.txtb2.text=StringConst.SCHOOL_PANEL_4011;
			panel.txtb2.mouseEnabled=false;
			panel.txtb3.text=StringConst.SCHOOL_PANEL_4012;
			panel.txtb3.mouseEnabled=false;
			panel.txtb4.text=StringConst.SCHOOL_PANEL_4013;
			panel.txtb4.mouseEnabled=false;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var positionArr:Array =[StringConst.SCHOOL_PANEL_4016].concat(SchoolDataManager.getInstance().positionArr);
			combox=new DropDownListWithLoad(positionArr,skin.txt8,81,rsrLoader,skin,"downItem","downListBtn",positionArr[0]);
			combox.addEventListener(Event.CHANGE,onComboxChanage);
			rsrLoader.addCallBack(_skin.mcScrollBar,function (mc:MovieClip):void
			{
				_handler.initScrollBar();
				SchoolElseDataManager.getInstance().getSchoolMemberList();
			});
			rsrLoader.addCallBack(skin.btn1,function(mc:MovieClip):void
			{
				skin.btn1.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN);
			});
			rsrLoader.addCallBack(skin.btn2,function(mc:MovieClip):void
			{
				skin.btn2.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN);
			});
			rsrLoader.addCallBack(skin.btnRecruit,function(mc:MovieClip):void
			{
				skin.btn3.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN);
			});
			super.addCallBack(rsrLoader);
		}
		
		protected function onComboxChanage(event:Event):void
		{
			SchoolElseDataManager.getInstance().selectMemberPosition=combox.selectedIndex;
			_handler.updatePanel();
			_mouseHandler.clearSelect();
		}
		
		override public function destroy():void
		{
			if(	combox)
			{
				combox.removeEventListener(Event.CHANGE,onComboxChanage);
				combox.destroy();
			}
			combox=null;

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
			if(proc==GameServiceConstants.SM_FAMILY_MEMBER_LIST_QUERY||
				proc==GameServiceConstants.SM_FAMILY_POSITION_TITLE_QUERY||
				proc==GameServiceConstants.SM_FAMILY_APPOINTMENT)
			{
				_handler.updatePanel();
				_handler.updateJurisdiction();
			}
			else if(proc==GameServiceConstants.SM_FAMILY_INFO_QUERY)
			{
				_handler.updateJurisdiction();
			}
			super.update(proc);
		}
		
		public function hideMouseBuf():void
		{
			_handler.hideMouseBuf();			
		}
		
		public function hideSelectBuf():void
		{
			_handler.hideSelectBuf();
		}
		
		override protected function attach():void
		{
			SchoolElseDataManager.getInstance().attach(this);
			SchoolShopManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			SchoolElseDataManager.getInstance().detach(this);
			SchoolDataManager.getInstance().detach(this);
			super.detach();
		}
		
	}
}