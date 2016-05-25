package com.view.gameWindow.panel.panels.school.complex.information
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.SchoolConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.school.McInformation;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	import mx.utils.StringUtil;
	
	public class SchoolInfoPanel extends TabBase
	{
		private var _handler:SchoolInfoHandler;
		private var _mouseHandler:SchoolInfoMouseHandler;
		public var lastBtn:MovieClip;
		public function SchoolInfoPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McInformation = new McInformation();
			_skin = skin;
			addChild(_skin);
			_handler=new SchoolInfoHandler(this);
			_mouseHandler=new SchoolInfoMouseHandler(this);
			initText();
		}
		
		private function initText():void
		{
			var panel:McInformation = _skin as McInformation;

			panel.txt2.text=StringConst.SCHOOL_PANEL_0101;
			panel.txt3.text=StringConst.SCHOOL_PANEL_0102;
			panel.txt4.text=StringConst.SCHOOL_PANEL_0103;
			panel.txt5.text=StringConst.SCHOOL_PANEL_0104;
			panel.txt6.text=StringConst.SCHOOL_PANEL_0105;
			panel.txt7.text=StringConst.SCHOOL_PANEL_0106;
			panel.txt7.mouseEnabled=false;

			panel.txt11.text=StringUtil.substitute(StringConst.SCHOOL_PANEL_0110,840);
			panel.txt12.text=StringConst.SCHOOL_PANEL_0111;
			panel.txt12.mouseEnabled=false;
			panel.txt13.text=StringConst.SCHOOL_PANEL_0112;
			panel.txt13.mouseEnabled=false;

			panel.txt17.text=StringConst.SCHOOL_PANEL_0115;
			panel.txt19.text=StringConst.SCHOOL_PANEL_0116;
			panel.txt22.text=StringConst.SCHOOL_PANEL_0118;
			panel.txt22.mouseEnabled=false;
			panel.txt23.text=StringConst.SCHOOL_PANEL_0119;
			panel.txt23.mouseEnabled=false;
			panel.txt24.text=StringConst.SCHOOL_PANEL_0120;
			panel.txt24.mouseEnabled=false;
			
			panel.txt1.htmlText=HtmlUtils.createHtmlStr(0xffcc00,StringConst.SCHOOL_PANEL_0100,12,true);
			panel.txt8.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0107+"</u>");
			panel.txt8.visible=false;
			panel.txt9.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0108+"</u>");
			panel.txt10.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0109+"</u>");
			panel.txt15.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0113+"</u>");
			panel.txt16.htmlText=HtmlUtils.createHtmlStr(0xffcc00,StringConst.SCHOOL_PANEL_0114,12,true);
			panel.txt21.htmlText=HtmlUtils.createHtmlStr(0xffcc00,StringConst.SCHOOL_PANEL_0117,12,true);
			
			panel.txtEvent1.text=StringConst.SCHOOL_PANEL_3000;
			panel.txtEvent2.text=StringConst.SCHOOL_PANEL_3001;
			panel.txtEvent3.text=StringConst.SCHOOL_PANEL_3002;
			panel.txtEvent4.text=StringConst.SCHOOL_PANEL_3003;
		}
		
		private function setTabBtnState(tab:int,mc:MovieClip):void
		{
			var selectTab:int = SchoolElseDataManager.getInstance().selectTab;
			if(selectTab == tab)
			{
				mc.selected = true;
				mc.mouseEnabled = false;
				lastBtn = mc;
			}
			skin.txt13.textColor=0xd4a460;
			skin.txt12.textColor=0xffe1aa;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McInformation = _skin as McInformation;
			rsrLoader.addCallBack(skin.tab0,function(mc:MovieClip):void
			{
				setTabBtnState(0,mc);
			});
			rsrLoader.addCallBack(skin.btnAuction,function(mc:MovieClip):void
			{
				skin.btnAuction.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_16);
			});
			rsrLoader.addCallBack(skin.btnDissolve,function(mc:MovieClip):void
			{
				var schoolInfoData:SchoolInfoData = SchoolElseDataManager.getInstance().schoolInfoData;
				if(schoolInfoData&&schoolInfoData.position==1)//如果是帮主
				{
					skin.btnDissolve.visible=true;
				}else
				{
					skin.btnDissolve.visible=false;
				}
			});
			rsrLoader.addCallBack(skin.btnRecruit,function(mc:MovieClip):void
			{
				skin.btnRecruit.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN);
			});

			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			SchoolElseDataManager.getInstance().getSchoolInfoRequest();
		}		
		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_FAMILY_INFO_QUERY||
				proc==GameServiceConstants.SM_FAMILY_RANK_GOLD||
				proc==GameServiceConstants.SM_FAMILY_ADD_MAX_COUNT)
			{
				_handler.updatePanel();
			}
			super.update(proc);
		}
		
		override protected function attach():void
		{
			SchoolElseDataManager.getInstance().attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			SchoolElseDataManager.getInstance().detach(this);
			super.detach();
		}
		
	}
}