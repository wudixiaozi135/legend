package com.view.gameWindow.panel.panels.school.complex
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.school.McSchoolPanelElse;
    import com.view.gameWindow.panel.panels.school.complex.build.SchoolBuildPanel;
    import com.view.gameWindow.panel.panels.school.complex.information.SchoolInfoPanel;
    import com.view.gameWindow.panel.panels.school.complex.list.SchoolListPanel;
    import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberPanel;
    import com.view.gameWindow.panel.panels.school.complex.shop.SchoolShopManager;
    import com.view.gameWindow.panel.panels.school.complex.shop.SchoolShopTab;
    import com.view.gameWindow.panel.panels.school.complex.storage.SchoolStoragePanel;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class SchoolElseMouseHandler
	{

		private var school:SchoolPanelElse;
		private var _skin:McSchoolPanelElse;
		internal var lastBtn:MovieClip;
		private var _tabsSwitch:TabsSwitch;
		private var _tabLayer:Sprite;
		
		public function SchoolElseMouseHandler(school:SchoolPanelElse)
		{
			this.school = school;
			_skin = school.skin as McSchoolPanelElse;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_tabLayer=new Sprite();
			_skin.addChild(_tabLayer);
			_tabLayer.x=41;
			_tabLayer.y=90;
			var selectTab:int = SchoolElseDataManager.getInstance().selectTab;
            _tabsSwitch = new TabsSwitch(_tabLayer, Vector.<Class>([SchoolInfoPanel, SchoolBuildPanel, SchoolMemberPanel, SchoolStoragePanel, SchoolListPanel, SchoolShopTab]), selectTab);
			//隐藏帮会建筑及仓库页
			_skin.tabBtn_01.visible =false;
//			_skin.tabBtn_03.visible = false;
			_skin.tabBtn_05.x = _skin.tabBtn_04.x;
//			_skin.tabBtn_03.x=_skin.tabBtn_04.x;
			_skin.tabBtn_04.x = _skin.tabBtn_02.x;
			_skin.tabBtn_02.x = _skin.tabBtn_01.x;
		}
		
		private function onClick(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _skin.btnClose:
					dealClose();
					break;
				case _skin.tabBtn_00:
					dealInformation();
					break;
				case _skin.tabBtn_01:
//					dealBuild();
					_skin.tabBtn_01.selected=false;
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HERO_PANEL_005);
					break;
				case _skin.tabBtn_02:
					dealMember();
					break;
				case _skin.tabBtn_03:
					dealStorage();
//					_skin.tabBtn_03.selected=false;
//					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HERO_PANEL_005);
					break;
				case _skin.tabBtn_04:
					dealList();
					break;
                case _skin.tabBtn_05:
                    dealShop();
                    break;
				default:
					break;
			}
		}

        private function dealShop():void
        {
            SchoolShopManager.instance.sendCM_GET_FAMILY_LIMIT_NUM();
            _tabsSwitch.onClick(5);
            setBtnState(_skin.tabBtn_05);
        }
		
		private function dealList():void
		{
			_tabsSwitch.onClick(4);
			setBtnState(_skin.tabBtn_04);
		}
		
		private function dealStorage():void
		{
			_tabsSwitch.onClick(3);
			setBtnState(_skin.tabBtn_03);
		}
		
		private function dealMember():void
		{
			_tabsSwitch.onClick(2);
			setBtnState(_skin.tabBtn_02);
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_SCHOOL);
		}
		
		private function dealBuild():void
		{
			_tabsSwitch.onClick(1);
			setBtnState(_skin.tabBtn_01);
		}
		
		private function dealInformation():void
		{
			_tabsSwitch.onClick(0);
			setBtnState(_skin.tabBtn_00);
		}
		
		private function setBtnState(nowBtn:MovieClip):void
		{
			lastBtn.selected = false;
			lastBtn.mouseEnabled = true;
			(lastBtn.txt as TextField).textColor = 0xd4a460;
			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			(nowBtn.txt as TextField).textColor = 0xffe1aa;
			lastBtn = nowBtn;
		}
		
		public function destroy():void
		{
			if(_tabLayer)
			{
				_tabLayer.parent&&_tabLayer.parent.removeChild(_tabLayer);
			}
			_tabLayer=null;
			if(_tabsSwitch)
			{
				_tabsSwitch.destroy();
				_tabsSwitch = null;
			}
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
		}
	}
}