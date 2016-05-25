package com.view.gameWindow.panel.panels.school.complex.information.eventList
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	
	public class SchoolEventListPanel extends PanelBase
	{
		private var _handler:SchoolEventListHandler;
		private var _mouseHandler:SchoolEventListMouseHandler;
		public function SchoolEventListPanel()
		{
			super();
			SchoolElseDataManager.getInstance().attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:McEventPanel = new McEventPanel();
			_skin = skin as McEventPanel;
			addChild(_skin);
			initText(skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.SCHOOL_PANEL_3006,14,true);
			_handler=new SchoolEventListHandler(this);
			_mouseHandler=new SchoolEventListMouseHandler(this);
		}
		
		private function initText(skin:McEventPanel):void
		{
			skin.txt0.text=StringConst.SCHOOL_PANEL_3004;
			skin.txt1.text=StringConst.SCHOOL_PANEL_3005;
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
			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			SchoolElseDataManager.getInstance().detach(this);
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			SchoolElseDataManager.getInstance().getSchoolEventListRequest();
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_FAMILY_EVENT_QUERY:
					updateList();
					break;
				default:
					break;
			}
			super.update(proc);
		}
		
		public function updateList():void
		{
			_handler.updateList();
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
	}
}