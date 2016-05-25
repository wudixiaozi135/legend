package com.view.gameWindow.panel.panels.school.complex
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.school.McSchoolPanelElse;
    import com.view.gameWindow.util.HtmlUtils;

    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.text.TextField;

    public class SchoolPanelElse extends PanelBase
	{
		private var _mouseHandle:SchoolElseMouseHandler;
		public function SchoolPanelElse()
		{
			SchoolElseDataManager.getInstance().attach(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McSchoolPanelElse = _skin as McSchoolPanelElse;
			rsrLoader.addCallBack(skin.tabBtn_00,function(mc:MovieClip):void
			{
				setTabBtnState(0,mc);
				skin.tabBtn_00.txt.text=StringConst.SCHOOL_PANEL_1001;

			});
			rsrLoader.addCallBack(skin.tabBtn_01,function(mc:MovieClip):void
			{
				setTabBtnState(1,mc);
				skin.tabBtn_01.txt.text=StringConst.SCHOOL_PANEL_1002;

			});
			rsrLoader.addCallBack(skin.tabBtn_02,function(mc:MovieClip):void
			{
				setTabBtnState(2,mc);
				skin.tabBtn_02.txt.text=StringConst.SCHOOL_PANEL_1003;

			});
			rsrLoader.addCallBack(skin.tabBtn_03,function(mc:MovieClip):void
			{
				setTabBtnState(3,mc);
				skin.tabBtn_03.txt.text=StringConst.SCHOOL_PANEL_1004;

			});
			rsrLoader.addCallBack(skin.tabBtn_04,function(mc:MovieClip):void
			{
				setTabBtnState(4,mc);
				skin.tabBtn_04.txt.text=StringConst.SCHOOL_PANEL_1005;
			});
            rsrLoader.addCallBack(skin.tabBtn_05, function (mc:MovieClip):void
            {
                setTabBtnState(5, mc);
                skin.tabBtn_05.txt.text = StringConst.SCHOOL_PANEL_1006;
            });
		}
		
		private function setTabBtnState(tab:int,mc:MovieClip):void
		{
			var selectTab:int = SchoolElseDataManager.getInstance().selectTab;
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
		}
		override public function destroy():void
		{
			SchoolElseDataManager.getInstance().detach(this);
			if(_mouseHandle)
			{
				_mouseHandle.destroy();
				_mouseHandle = null;
			}
			super.destroy();
		}
		
		override protected function initData():void
		{
			_mouseHandle=new SchoolElseMouseHandler(this);
		}
		
		override protected function initSkin():void
		{
			_skin=new McSchoolPanelElse();
			addChild(_skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.SCHOOL_PANEL_0001,14,true);
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
			super.update(proc);
		}
	}
}