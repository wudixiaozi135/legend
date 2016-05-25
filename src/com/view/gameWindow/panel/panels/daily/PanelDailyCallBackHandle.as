package com.view.gameWindow.panel.panels.daily
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	internal class PanelDailyCallBackHandle
	{
		private var _panel:PanelDaily;
		private var _skin:McDaily1;
		
		public function PanelDailyCallBackHandle(panel:PanelDaily, rsrLoader:RsrLoader)
		{
			_panel = panel;
			_skin = _panel.skin as McDaily1;
			init(rsrLoader);
		}
		
		private function init(rsrLoader:RsrLoader):void
		{
			var i:int, l:int = 4;
			for (i = 0; i < l; i++)
			{
				rsrLoader.addCallBack(_skin["btnTab" + i], getFunc(i));
			}
		}
		
		private function getFunc(index:int):Function
		{
			var func:Function = function (mc:MovieClip):void
			{
				var selectTab:int = DailyDataManager.instance.selectTab;
				var textField:TextField = mc.txt as TextField;
				textField.text = StringConst["DAILY_PANEL_000" + (2 + index)];
				if (selectTab == index)
				{
					mc.selected = true;
					mc.mouseEnabled = false;
					_panel.mouseHandle.lastBtn = mc;
					textField.textColor = 0xffe1aa;
					if (_panel.mouseHandle)
					{
						_panel.mouseHandle.switchToTab(selectTab);
					}
				}
				else
				{
					textField.textColor = 0xd4a460;
				}
			};
			return func;
		}
		
		internal function destroy():void
		{
			_skin = null;
			_panel = null;
		}
	}
}