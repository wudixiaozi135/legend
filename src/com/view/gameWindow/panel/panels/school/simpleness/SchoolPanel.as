package com.view.gameWindow.panel.panels.school.simpleness
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.school.MCSchoolPanel;
    
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.text.TextField;
	
	/**
	 * 帮派面板类
	 * @author Administrator
	 */
    public class SchoolPanel extends PanelBase
	{
		private var _mouseHandle:SchoolMouseHandler;
		public function SchoolPanel()
		{
			super();
			SchoolDataManager.getInstance().attach(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:MCSchoolPanel = _skin as MCSchoolPanel;
			rsrLoader.addCallBack(skin.tabBtn_00,function(mc:MovieClip):void
			{
				setTabBtnState(0,mc);
			});
			rsrLoader.addCallBack(skin.tabBtn_01,function(mc:MovieClip):void
			{
				setTabBtnState(1,mc);
			});
		}
		
		private function setTabBtnState(tab:int,mc:MovieClip):void
		{
			var selectTab:int = SchoolDataManager.getInstance().selectTab;
			var textField:TextField = mc.txt as TextField;
			if(selectTab == tab)
			{
				mc.selected = true;
				mc.mouseEnabled = false;
				textField.textColor = 0xffe1aa;
				_mouseHandle.lastBtn = mc;
			}
			else
			{
				textField.textColor = 0xd4a460;
			}
			
			if(tab==0)
			{
				textField.text=StringConst.SCHOOL_PANEL_0002;
			}else if(tab==1)
			{
				textField.text=StringConst.SCHOOL_PANEL_0003;
			}
		}
		override public function destroy():void
		{
			// TODO Auto Generated method stub
			SchoolDataManager.getInstance().detach(this);
			if(_mouseHandle)
			{
				_mouseHandle.destroy();
				_mouseHandle = null;
			}
			super.destroy();
		}
		
		override protected function initData():void
		{
			_mouseHandle=new SchoolMouseHandler(this);
			super.initData();
		}
		
		override protected function initSkin():void
		{
			_skin=new MCSchoolPanel();
			addChild(_skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.text=StringConst.SCHOOL_PANEL_0001;
		}
		
		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.factionBtn.x, mc.factionBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
		override public function update(proc:int=0):void
		{
			if(proc==SchoolDataManager.UPDATE_TAB_INDEX)
			{
				_mouseHandle.updateTabIndex();
			}
			super.update(proc);
		}
		
	}
}