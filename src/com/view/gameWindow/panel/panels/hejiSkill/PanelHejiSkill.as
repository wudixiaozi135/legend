package com.view.gameWindow.panel.panels.hejiSkill
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.PanelBase;

    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.text.TextField;

    public class PanelHejiSkill extends PanelBase
	{
		private var _mouseHandle:PanelHejiSkillMouseEvent;
		public function PanelHejiSkill()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McPanelHejiSkill = new McPanelHejiSkill();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McPanelHejiSkill = _skin as McPanelHejiSkill;
			rsrLoader.addCallBack(skin.tabBtn_00,function(mc:MovieClip):void
			{
				setTabBtnState(0,mc);
			});
			rsrLoader.addCallBack(skin.tabBtn_01,function(mc:MovieClip):void
			{
				_skin.tabBtn_01.visible=false;
//				setTabBtnState(1,mc);
			});
		}
		
		private function setTabBtnState(tab:int,mc:MovieClip):void
		{
			var selectTab:int = HejiSkillDataManager.instance.selectTab;
			var textField:TextField = mc.txt as TextField;
			if(selectTab == tab)
			{
				mc.selected = true;
				mc.mouseEnabled = false;
				textField.text = StringConst.HEJI_PANEL_0002;
				textField.textColor = 0xffe1aa;
				_mouseHandle.lastBtn = mc;
			}
			else
			{
				textField.text = StringConst.HEJI_PANEL_0001;
				textField.textColor = 0xd4a460;
			}
		}
		
		override protected function initData():void
		{
			_mouseHandle = new PanelHejiSkillMouseEvent(this);
		}
		
		override public function update(proc:int=0):void
		{
			
		}
		
		override public function destroy():void
		{
			HejiSkillDataManager.instance.selectTab = 0;
			if(_mouseHandle)
			{
				_mouseHandle.destroy();
				_mouseHandle = null;
			}
			super.destroy();
		}
		
		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.joinSkillBtn.x, mc.joinSkillBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
	}
}