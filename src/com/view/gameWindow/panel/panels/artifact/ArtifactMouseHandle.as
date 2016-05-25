package com.view.gameWindow.panel.panels.artifact
{
	import com.model.consts.TabConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ArtifactMouseHandle
	{
		
		private var _panel:ArtifactPanel;
		
		public function ArtifactMouseHandle(panel:ArtifactPanel)
		{
			_panel = panel;
			initHandle();
		}
		
		private function initHandle():void
		{
			_panel._mcArtifact.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		private function clickHandle(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _panel._mcArtifact.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_ARTIFACT);
					break;
				case _panel._mcArtifact.tabBtn_00:
					_panel.setTabIndex(TabConst.TYPE_TABARTIFACT);
					_panel.setBtnState(_panel._mcArtifact.tabBtn_00,_panel._mcArtifact.tabTxt_00);
					break;
				case _panel._mcArtifact.tabBtn_01:
					_panel.setTabIndex(TabConst.TYPE_TABNORMAL);
					_panel.setBtnState(_panel._mcArtifact.tabBtn_01,_panel._mcArtifact.tabTxt_01);
					break;
			}
		}
		
		public function destroy():void
		{
			if(_panel)
			{
				_panel._mcArtifact.removeEventListener(MouseEvent.CLICK,clickHandle);
				_panel = null;
			}
		}
		
	}
}