package com.view.gameWindow.panel.panels.school.complex.information.donate
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.information.MCdonate;
	import com.view.gameWindow.util.HtmlUtils;
	
	public class DonatePanel extends PanelBase
	{
		private var _mouseHandler:DonateMouseHandler;
		private var _handler:DonateHandler;
		public function DonatePanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCdonate = new MCdonate();
			_skin = skin;
			addChild(_skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.SCHOOL_PANEL_2001,14,true);
			_handler=new DonateHandler(this);
			_mouseHandler=new DonateMouseHandler(this);
			initText();
		}
		
		private function initText():void
		{
			var panel:MCdonate = _skin as MCdonate;
			panel.txt1.text=StringConst.SCHOOL_PANEL_2002;
			panel.txt2.text=StringConst.SCHOOL_PANEL_2003;
			panel.txt3.text=StringConst.SCHOOL_PANEL_2004;
			panel.txt4.text=StringConst.SCHOOL_PANEL_2005;
			panel.txt5.text=StringConst.SCHOOL_PANEL_2006;
			panel.txt6.text=StringConst.SCHOOL_PANEL_2007;
			panel.txt5.mouseEnabled=false;
			panel.txt6.mouseEnabled=false;
			panel.txt7.text=StringConst.SCHOOL_PANEL_2008;
			panel.txt8.text=StringConst.SCHOOL_PANEL_2009;
			panel.txtv4.restrict="0-9";
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			BagDataManager.instance.detach(this);
			SchoolElseDataManager.getInstance().detach(this);
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			SchoolElseDataManager.getInstance().attach(this);
			BagDataManager.instance.attach(this);
			SchoolElseDataManager.getInstance().donateDataReq();
		}		
		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_FAMILY_CONTRIBUTE_INFO||proc==GameServiceConstants.SM_BAG_ITEMS)
			{
				_handler&&_handler.updatePanel();	
			}
			super.update(proc);
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
		
	}
}