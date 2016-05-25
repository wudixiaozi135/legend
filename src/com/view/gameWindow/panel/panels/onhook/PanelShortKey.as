package com.view.gameWindow.panel.panels.onhook
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.util.tabsSwitch.TabBase;

	public class PanelShortKey extends TabBase
	{
		private var _mc:McShortKey;
		
		public function PanelShortKey()
		{
			
		}
		
		override protected function initSkin():void
		{
			_mc = new McShortKey();
			_skin = _mc;
			addChild(_skin);
			
			initTxts();
		}
		
		override public function destroy():void
		{
			_mc = null;
			super.destroy();
		}
		
		private function initTxts():void
		{
			_mc.txt0.text = StringConst.HOTKEY_ID_00;
			_mc.txt1.text = StringConst.HOTKEY_ID_01;
			_mc.txt2.text = StringConst.HOTKEY_ID_02;
			_mc.txt3.text = StringConst.HOTKEY_ID_03;
			_mc.txt4.text = StringConst.HOTKEY_ID_04;
			_mc.txt5.text = StringConst.HOTKEY_ID_05;
			_mc.txt6.text = StringConst.HOTKEY_ID_06;
			_mc.txt7.text = StringConst.HOTKEY_ID_07;
			_mc.txt8.text = StringConst.HOTKEY_ID_08;
			_mc.txt9.text = StringConst.HOTKEY_ID_09;
			_mc.txt10.text = StringConst.HOTKEY_ID_10;
			_mc.txt11.text = StringConst.HOTKEY_ID_11;
			_mc.txt12.text = StringConst.HOTKEY_ID_12;
			_mc.txt13.text = StringConst.HOTKEY_ID_13;
			_mc.txt14.text = StringConst.HOTKEY_ID_14;
			_mc.txt15.text = StringConst.HOTKEY_ID_15;
			_mc.txt16.text = StringConst.HOTKEY_ID_16;
			
			_mc.value0.text = StringConst.HOTKEY_00;
			_mc.value1.text = StringConst.HOTKEY_01;
			_mc.value2.text = StringConst.HOTKEY_02;
			_mc.value3.text = StringConst.HOTKEY_03;
			_mc.value4.text = StringConst.HOTKEY_04;
			_mc.value5.text = StringConst.HOTKEY_05;
			_mc.value6.text = StringConst.HOTKEY_06;
			_mc.value7.text = StringConst.HOTKEY_07;
			_mc.value8.text = StringConst.HOTKEY_08;
			_mc.value9.text = StringConst.HOTKEY_09;
			_mc.value10.text = StringConst.HOTKEY_10;
			_mc.value11.text = StringConst.HOTKEY_11;
			_mc.value12.text = StringConst.HOTKEY_12;
			_mc.value13.text = StringConst.HOTKEY_13;
			_mc.value14.text = StringConst.HOTKEY_14;
			_mc.value15.text = StringConst.HOTKEY_15;
			_mc.value16.text = StringConst.HOTKEY_16;
			
			_mc.title0.text = StringConst.HOTKEY_TITLE;
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			super.detach();
		}
		
	}
}