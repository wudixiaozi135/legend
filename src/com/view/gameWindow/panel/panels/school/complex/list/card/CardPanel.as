package com.view.gameWindow.panel.panels.school.complex.list.card
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;
	import com.view.gameWindow.util.HtmlUtils;
	
	public class CardPanel extends PanelBase
	{
		private var _mouseHandler:CardMouseHandler;
		private var _handler:CardHandler;
		public function CardPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCCard = new MCCard();
			_skin = skin;
			addChild(_skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.SCHOOL_PANEL_2011,14,true);
			_handler=new CardHandler(this);
			_mouseHandler=new CardMouseHandler(this);
			initText();
		}
		
		private function initText():void
		{
			var panel:MCCard = _skin as MCCard;
			panel.txt1.text=StringConst.SCHOOL_PANEL_0023+":";
			panel.txt2.text=StringConst.SCHOOL_PANEL_00262+":";
			panel.txt3.text=StringConst.SCHOOL_PANEL_00241+":";
			panel.txt4.text=StringConst.SCHOOL_PANEL_2012+":";
			panel.txt5.text=StringConst.SCHOOL_PANEL_2013;
			panel.txt6.text=StringConst.SCHOOL_PANEL_2014;
			panel.txt6.mouseEnabled=false;
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
			var lookSchoolData:SchoolData = SchoolDataManager.getInstance().lookSchoolData;
			if(lookSchoolData==null)return;
			_handler&&_handler.updatePanel();	
		}		
		override public function update(proc:int=0):void
		{
			super.update(proc);
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
		
	}
}