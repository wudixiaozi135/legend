package com.view.gameWindow.panel.panels.welfare
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.welfare.activate.TabActivate;
	import com.view.gameWindow.panel.panels.welfare.notice.TabNotice;
	import com.view.gameWindow.panel.panels.welfare.offline.TabOffline;
	import com.view.gameWindow.panel.panels.welfare.sign.TabSign;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class WelfareViewHandle
	{
		private var _panel:PanelWelfare;
		private var _skin:MCPanelWelfare;
		
		private var _tabSwitch:TabsSwitch;
		private var _lastBtn:MovieClip;
		public function WelfareViewHandle(panel:PanelWelfare)
		{
			_panel = panel;
			_skin = panel.skin as MCPanelWelfare;
		}
		
		public function init(rsrLoader:RsrLoader):void
		{
			_skin.addEventListener(MouseEvent.CLICK, onClick);
			/*_skin.btnTab2.mouseEnabled = _skin.btnTab3.mouseEnabled = false; */
			_skin.btn0.mouseEnabled = false;
			for(var i:int = 0;i < 3; i++)
			{
				rsrLoader.addCallBack(_skin["btnTab"+String(i)].mc,getFun(i));
			}
			_tabSwitch = new TabsSwitch(_skin.mcTabLayer, Vector.<Class>([TabSign,TabOffline,TabActivate,TabNotice]));
			//_tabSwitch.onClick(0, false);	
			reafreshNum();
		}
		
		public function reafreshNum():void
		{
			// TODO Auto Generated method stub
			var num:Number = WelfareDataMannager.instance.offLineTime / 60;
			var isHasOffLineExp:Boolean = true;//是否有离线经验
			if (num < 60)
			{//离线60分钟以内不显示特效
				isHasOffLineExp = false;
			}
			if (WelfareDataMannager.instance.flag == 1 || WelfareDataMannager.instance.isGetOffLineExp)
				isHasOffLineExp = false;
			_skin.txtOffLineCount.text = "1";
			_skin.txtOffLineCount.visible = _skin.txtOffLineBG.visible = isHasOffLineExp;
		}
		
		private function getFun(index:int):Function
		{
			var func:Function = function(mc:MovieClip):void
			{
				var selectTab:int = WelfareDataMannager.instance.selectTab;
				var textField:TextField = mc.txt as TextField;
				textField.text = StringConst["WELFARE_TAB_000"+String(index)];
				if(selectTab == index)
				{
					mc.selected = true;
					mc.mouseEnabled = false;
					_lastBtn = mc;
					textField.textColor = 0xffe1aa;
				}
				else
				{
					textField.textColor = 0xd4a460;
				}
			}
			return func;
		}
		private function onClick(e:MouseEvent):void
		{
			switch (e.target)
			{
				case _skin.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_WELFARE);
					break;
				case _skin.btnTab0.mc:
					dealBtnTab(0, _skin.btnTab0.mc);
					break;
				case _skin.btnTab1.mc:
					dealBtnTab(1, _skin.btnTab1.mc);
					break;
				case _skin.btnTab2.mc:
					dealBtnTab(2, _skin.btnTab2.mc);
					break;
				//case _skin.btnTab3.mc:
					//dealBtnTab(3, _skin.btnTab3.mc);
					//break;
				//case _skin.btn0:
				//case _skin.btn1:
					//Alert.warning(StringConst.WELFARE_PANEL_0018);
					//break;
			}
		}
		
		private function dealBtnTab(index:int, nowBtn:MovieClip):void
		{
			WelfareDataMannager.instance.selectTab = index;
			_tabSwitch.onClick(index,true);
			if(!_lastBtn)
				return;
			_lastBtn.selected = false;
			_lastBtn.mouseEnabled = true;
			(_lastBtn.txt as TextField).textColor = 0xd4a460;
			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			(nowBtn.txt as TextField).textColor = 0xffe1aa;
			_lastBtn = nowBtn;
		}
		
		public function switchTab(index:int):void
		{
			dealBtnTab(index,_skin['btnTab'+index].mc);
		}
		public function destroy():void
		{
			_lastBtn = null;
			_tabSwitch.destroy();
			_tabSwitch = null;
			_skin.removeEventListener(MouseEvent.CLICK, onClick);
		}
	}
}