package com.view.gameWindow.panel.panels.hejiSkill
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff.TabHejiBuff;
	import com.view.gameWindow.panel.panels.hejiSkill.tabHejiSkill.TabHejiSkill;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PanelHejiSkillMouseEvent
	{
		private var _panel:PanelHejiSkill;
		private var _skin:McPanelHejiSkill;
		internal var lastBtn:MovieClip;
		private var _tabsSwitch:TabsSwitch;
		
		public function PanelHejiSkillMouseEvent(panel:PanelHejiSkill)
		{
			_panel = panel;
			_skin = _panel.skin as McPanelHejiSkill;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			var selectTab:int = HejiSkillDataManager.instance.selectTab;
//			_tabsSwitch = new TabsSwitch(_skin.mcLayer,Vector.<Class>([TabHejiSkill,TabHejiBuff]),selectTab);
			_tabsSwitch = new TabsSwitch(_skin.mcLayer,Vector.<Class>([TabHejiBuff]),selectTab);
		}
		
		private function onClick(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _skin.btnClose:
					dealClose();
					break;
				case _skin.tabBtn_00:
					dealBuff();
					break;
				case _skin.tabBtn_01:
					dealSkill();
					break;
				default:
					break;
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_HEJI);
		}
		
		private function dealSkill():void
		{
			_tabsSwitch.onClick(1);
			setBtnState(_skin.tabBtn_01);
		}
		
		private function dealBuff():void
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
		
		internal function destroy():void
		{
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
			_panel = null;
		}
	}
}