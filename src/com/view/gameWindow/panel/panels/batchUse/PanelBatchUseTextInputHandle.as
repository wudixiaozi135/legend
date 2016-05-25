package com.view.gameWindow.panel.panels.batchUse
{
	import flash.events.Event;

	/**
	 * 批量使用输入文本处理类
	 * @author Administrator
	 */	
	public class PanelBatchUseTextInputHandle
	{
		private var _panel:PanelBatchUse;
		private var _mc:McBatchUse;
		
		public function PanelBatchUseTextInputHandle(panel:PanelBatchUse)
		{
			_panel = panel;
			_mc = _panel.skin as McBatchUse;
			init();
		}
		
		private function init():void
		{
			_mc.txtValue.restrict = "0-9";
			_mc.txtValue.addEventListener(Event.CHANGE,onInput);
		}
		
		protected function onInput(event:Event):void
		{
			var total:int = _panel.viewHandle.total;
			var input:int = int(_mc.txtValue.text);
			if(input < 1)
			{
				input = 1;
			}
			else if(input > total)
			{
				input = total;
			}
			_panel.mouseHandle.useNum = input;
			_panel.viewHandle.refresh(input);
		}
		
		public function destroy():void
		{
			if(_mc)
			{
				_mc.txtValue.removeEventListener(Event.CHANGE,onInput);
				_mc = null;
			}
			_panel = null;
		}
	}
}