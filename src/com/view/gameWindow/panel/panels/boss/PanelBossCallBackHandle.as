package com.view.gameWindow.panel.panels.boss
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	internal class PanelBossCallBackHandle
	{
		private var _panel:PanelBoss;
		private var _skin:MCPanelBoss;
		
		public function PanelBossCallBackHandle(panel:PanelBoss,rsrloder:RsrLoader)
		{
			_panel = panel;
			_skin = panel.skin as MCPanelBoss;
			init(rsrloder);
		}
		
		private function init(rsrloder:RsrLoader):void
		{
			var i:int,l:int = 3;
			for(i=0;i<l;i++)
			{
				rsrloder.addCallBack(_skin["btnTab"+i],getFunc(i));
			}
		}
		
		private function getFunc(index:int):Function
		{
			var func:Function = function(mc:MovieClip):void
			{
				var selectTab:int = BossDataManager.instance.selectTab;
				var textField:TextField = mc.txt as TextField;
				textField.text = StringConst["BOSS_PANEL_TAB_000"+(2+index)];
				if(selectTab == index)
				{
					mc.selected = true;
					mc.mouseEnabled = false;
					_panel.mouseHandle.lastBtn = mc;
					textField.textColor = 0xffe1aa;
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