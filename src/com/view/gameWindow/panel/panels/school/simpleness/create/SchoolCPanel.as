package com.view.gameWindow.panel.panels.school.simpleness.create
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.school.create.MCcreateSchool;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	public class SchoolCPanel extends TabBase
	{
		private var _handler:SchoolCHandler;
		private var _mouseHandler:SchoolCMouseHandler;
		public function SchoolCPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			// TODO Auto Generated method stub
			var skin:MCcreateSchool = new MCcreateSchool();
			_skin = skin;
			addChild(_skin);
			_handler=new SchoolCHandler(this);
			_mouseHandler=new SchoolCMouseHandler(this);
			
			initText();
		}
		
		private function initText():void
		{
			var panel:MCcreateSchool = _skin as MCcreateSchool;
			panel.txt1.text=StringConst.SCHOOL_PANEL_0004;
			panel.txt3.htmlText=HtmlUtils.createHtmlStr(0x00ff00,StringConst.SCHOOL_PANEL_0006);
			panel.txt5.text=StringConst.SCHOOL_PANEL_0008;
			panel.txt6.text=StringConst.SCHOOL_PANEL_0009;
			panel.txt7.text=StringConst.SCHOOL_PANEL_0010;
			panel.txt8.text=StringConst.SCHOOL_PANEL_0011;
			panel.txt9.text=StringConst.SCHOOL_PANEL_0012;
			panel.txt10.text=StringConst.SCHOOL_PANEL_0043;
			panel.txt9.mouseEnabled=false;
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
			// TODO Auto Generated method stub
			super.initData();
		}		
		override public function update(proc:int=0):void
		{
			// TODO Auto Generated method stub
			if(proc==GameServiceConstants.SM_BAG_ITEMS||proc==GameServiceConstants.SM_BAG_CHANGE)
			{
				_handler&&_handler.updateNum();
			}
			super.update(proc);
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			BagDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			BagDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}