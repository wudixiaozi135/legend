package com.view.gameWindow.panel.panels.school.simpleness.list
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.school.McListPanel;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	public class SchoolListPanel extends TabBase
	{
		private var _handler:SchoolListHandler;
		private var _mouseHandler:SchoolListMouseHandler;
		public function SchoolListPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McListPanel = new McListPanel();
			_skin = skin as McListPanel;
			addChild(_skin);
			initText(skin);
			_skin.y=-27;
			_skin.x=1;
			_handler=new SchoolListHandler(this);
			_mouseHandler=new SchoolListMouseHandler(this);
		}
		
		private function initText(skin:McListPanel):void
		{
//			skin.txt0.text=StringConst.SCHOOL_PANEL_0028;
			skin.txt1.text=StringConst.SCHOOL_PANEL_0022;
			skin.txt2.text=StringConst.SCHOOL_PANEL_0023;
			skin.txt3.text=StringConst.SCHOOL_PANEL_0024;
			skin.txt4.text=StringConst.SCHOOL_PANEL_0025;
			skin.txt5.text=StringConst.SCHOOL_PANEL_0026;
			skin.txt6.text=StringConst.SCHOOL_PANEL_0027;
			skin.txt7.text=StringConst.SCHOOL_PANEL_0029;
			skin.txt9.text=StringConst.SCHOOL_PANEL_0002;
			skin.txt9.mouseEnabled=false;
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
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			SchoolDataManager.getInstance().getSchoolListRequest();
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_FAMILY_LIST_QUERY:
				case GameServiceConstants.SM_FAMILY_APPLY_SUCCESS:
				case GameServiceConstants.SM_FAMILY_APPLY_CANCEL_SUCCESS:
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
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			SchoolDataManager.getInstance().attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			SchoolDataManager.getInstance().detach(this);
			super.detach();
		}
		
	}
}