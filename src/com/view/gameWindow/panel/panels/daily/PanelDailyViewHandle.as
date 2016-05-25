package com.view.gameWindow.panel.panels.daily
{
	import com.model.consts.StringConst;
	
	import flash.text.TextFormat;

	/**
	 * 日常面板显示相关处理类
	 * @author Administrator
	 */	
	internal class PanelDailyViewHandle
	{
		private var _panel:PanelDaily;
		private var _skin:McDaily1;
		
		public function PanelDailyViewHandle(panel:PanelDaily)
		{
			_panel = panel;
			_skin = _panel.skin as McDaily1;
			init();
		}
		
		private function init():void
		{
			var defaultTextFormat:TextFormat = _skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			_skin.txtTitle.defaultTextFormat = defaultTextFormat;
			_skin.txtTitle.setTextFormat(defaultTextFormat);
			_skin.txtTitle.text = StringConst.DAILY_PANEL_0001;
		}
		
		internal function destroy():void
		{
			_skin = null;
			_panel = null;
		}
	}
}