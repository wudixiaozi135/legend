package com.view.gameWindow.panel.panels.school.complex.build
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.school.McInformation;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import mx.utils.StringUtil;
	
	public class SchoolBuildPanel extends TabBase
	{
		private var _handler:SchoolBuildHandler;
		private var _mouseHandler:SchoolBuildMouseHandler;
		public function SchoolBuildPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McInformation = new McInformation();
			_skin = skin;
			addChild(_skin);
			_handler=new SchoolBuildHandler(this);
			_mouseHandler=new SchoolBuildMouseHandler(this);
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
			panel.txt22.text=StringConst.SCHOOL_PANEL_0119;
			panel.txt23.text=StringConst.SCHOOL_PANEL_0120;
			panel.txt24.text=StringConst.SCHOOL_PANEL_0120;
			
			panel.txt1.htmlText=HtmlUtils.createHtmlStr(0xffcc00,StringConst.SCHOOL_PANEL_0100,12,true);
			panel.txt8.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0107+"</u>");
			panel.txt9.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0108+"</u>");
			panel.txt10.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0109+"</u>");
			panel.txt15.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0113+"</u>");
			panel.txt15.visible=false;
			panel.txt16.htmlText=HtmlUtils.createHtmlStr(0xffcc00,StringConst.SCHOOL_PANEL_0114,12,true);
			panel.txt21.htmlText=HtmlUtils.createHtmlStr(0xffcc00,StringConst.SCHOOL_PANEL_0117,12,true);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
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
			_handler.updatePanel();
			super.update(proc);
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			SchoolElseDataManager.getInstance().attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			SchoolElseDataManager.getInstance().detach(this);
			super.detach();
		}
		
	}
}