package com.view.gameWindow.panel.panels.school.simpleness
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.school.MCSchoolPanel;
	import com.view.gameWindow.panel.panels.school.simpleness.create.SchoolCPanel;
	import com.view.gameWindow.panel.panels.school.simpleness.list.SchoolListPanel;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	

	public class SchoolMouseHandler
	{
		private var school:SchoolPanel;
		private var _skin:MCSchoolPanel;
		internal var lastBtn:MovieClip;
		private var _tabsSwitch:TabsSwitch;
		private var _tabLayer:Sprite;
		
		public function SchoolMouseHandler(school:SchoolPanel)
		{
			this.school = school;
			_skin = school.skin as MCSchoolPanel;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_tabLayer=new Sprite();
			_skin.addChild(_tabLayer);
			_tabLayer.x=41;
			_tabLayer.y=90;
			var selectTab:int = SchoolDataManager.getInstance().selectTab;
			_tabsSwitch = new TabsSwitch(_tabLayer,Vector.<Class>([SchoolCPanel,SchoolListPanel]),selectTab);
		}
		
		private function onClick(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _skin.btnClose:
					dealClose();
					break;
				case _skin.tabBtn_00:
					dealCreate();
					break;
				case _skin.tabBtn_01:
					dealList();
					break;
				default:
					break;
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_SCHOOL_CREATE);
		}
		
		private function dealList():void
		{
			_tabsSwitch.onClick(1);
			setBtnState(_skin.tabBtn_01);
		}
		
		private function dealCreate():void
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
			// TODO Auto Generated method stub
		}
		
		public function updateTabIndex():void
		{
			var selectTab:int = SchoolDataManager.getInstance().selectTab;
			_tabsSwitch.onClick(selectTab);
			setBtnState(_skin[("tabBtn_0"+selectTab)]);
		}
	}
}