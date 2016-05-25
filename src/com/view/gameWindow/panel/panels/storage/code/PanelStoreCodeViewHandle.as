package com.view.gameWindow.panel.panels.storage.code
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.storage.MCStorageCode;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PanelStoreCodeViewHandle
	{
		private var _panel:PanelStoreCode;
		private var _skin:MCStorageCode;
		private var _tabsSwitch:TabsSwitch;
		internal var lastBtn:MovieClip;
		private var _selectTab:int = 0;
		public function PanelStoreCodeViewHandle(panel:PanelStoreCode)
		{
			_panel = panel;	
			_skin = _panel.skin as MCStorageCode;
			init();
		}
		
		private function init():void
		{
			_skin.txtName.text = StringConst.STORAGE_008;
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_tabsSwitch = new TabsSwitch(_skin.mcTabLayer,Vector.<Class>([StorageCodeOne,StorageCodeTwo,StorageCodeThree,StorageCodeFour,StorageCodeFive]))
			_tabsSwitch.onClick(0,false);	
		}
		
		private function onClick(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _skin.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_STORAGE_CODE);
					break;
				
				case _skin.btnTab0:
					dealBtnTab(0,_skin.btnTab0);
					break;
				case _skin.btnTab1:
					dealBtnTab(1,_skin.btnTab1);
					break;
				case _skin.btnTab2:
					dealBtnTab(2,_skin.btnTab2);
					break;
				case _skin.btnTab3:
					dealBtnTab(3,_skin.btnTab3);
					break;
				case _skin.btnTab4:
					dealBtnTab(4,_skin.btnTab4);
					break;				
			}
		}
		
		private function dealBtnTab(index:int,nowBtn:MovieClip):void
		{
			_selectTab = index;
			_tabsSwitch.onClick(index,true);
			if(!lastBtn)
				return;
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
			lastBtn = null;
			_panel = null;
		}
	}
}