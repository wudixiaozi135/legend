package com.view.gameWindow.panel.panels.roleProperty
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class RolePropertyMouseHandle implements IPanelTab
	{
		private const ROLE:int = 0;
		private const PROPERTY:int = 2;
		private const NEWLIFE:int = 1;
		
		private var _mc:McRoleProperty;
		public var rolePropertyPanel:RolePropertyPanel;
		private var _unlock:UIUnlockHandler;
		
		public function RolePropertyMouseHandle(mc:McRoleProperty,panel:RolePropertyPanel)
		{
			_mc = mc;
			rolePropertyPanel = panel;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_unlock = new UIUnlockHandler(getUnlockUI,1,updatePos);
			_unlock.updateUIStates([UnlockFuncId.ROLE_RE,UnlockFuncId.ROLE_PRO]);
		}
		
		private function updatePos(id:int):void
		{
			if(id == UnlockFuncId.ROLE_PRO||id == UnlockFuncId.ROLE_RE)
			{
				rolePropertyPanel.updateBtnPosition();
			}
		}
		
		private function getUnlockUI(id:int):DisplayObject
		{
			if(id == UnlockFuncId.ROLE_RE)
			{
				return _mc.btnNewLife;
			}
			else if(id == UnlockFuncId.ROLE_PRO)
			{
				return _mc.btnProperty;
			}
			
			return null;
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var mc:MovieClip = evt.target as MovieClip;
			switch(mc)
			{
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_ROLE_PROPERTY);
					break;
				case _mc.btnProperty:
					if(!_unlock.onClickUnlock(UnlockFuncId.ROLE_PRO))
					{
						_mc.btnProperty.selected = false;
					}
					else
					{
						setTabIndex(PROPERTY);
					}
					break;
				case _mc.btnRole:
					setTabIndex(ROLE);
					break;
				case _mc.btnNewLife:
					if(!_unlock.onClickUnlock(UnlockFuncId.ROLE_RE))
					{
						_mc.btnNewLife.selected = false;
					}
					else
					{
						setTabIndex(NEWLIFE);
					}
					break;
			}
		}
		
		public function destroy():void
		{
			if(_unlock)
			{
				_unlock.destroy();
			}
			_unlock=null;
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc = null;
			}
			rolePropertyPanel = null;
		}
		
		private var _tabIndex:int = -1;
		public function getTabIndex():int
		{
			return _tabIndex;
		}
		
		public function setTabIndex(index:int):void
		{
			_tabIndex = index;
			if(index == ROLE)
			{
				rolePropertyPanel.changeSonPanel(ROLE);
				_mc.rolePropertyText.text = StringConst.ROLE_PROPERTY_PANEL_0019;
			}
			else if(index == PROPERTY)
			{
				rolePropertyPanel.changeSonPanel(PROPERTY);
				_mc.rolePropertyText.text = StringConst.ROLE_PROPERTY_PANEL_0023;
			}
			else if(index == NEWLIFE)
			{
				rolePropertyPanel.changeSonPanel(NEWLIFE);
				_mc.rolePropertyText.text = StringConst.ROLE_PROPERTY_PANEL_0060;
			}
		}
	}
}