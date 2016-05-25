package com.view.gameWindow.panel.panels.split
{
	import flash.events.Event;

	/**
	 * 拆分输入文本处理类
	 * @author Administrator
	 */	
	public class PanelSplitTextInputHandle
	{
		private var _panel:PanelSplit;
		private var _mc:McSplit;
		
		public function PanelSplitTextInputHandle(panel:PanelSplit)
		{
			_panel = panel;
			_mc = _panel.skin as McSplit;
			init();
		}
		
		private function init():void
		{
			_mc.txtNum.restrict = "0-9";
			_mc.txtNum.addEventListener(Event.CHANGE,onInput);
		}
		
		protected function onInput(event:Event):void
		{
			var total:int = _panel.viewHandle.count;
			var input:int = int(_mc.txtNum.text);
			if(input < 1)
			{
				input = 1;
			}
			else if(input > total - 1)
			{
				input = total - 1;
			}
			_panel.mouseHandle.count1 = input;
			_panel.viewHandle.refresh(input);
		}
		
		public function destroy():void
		{
			if(_mc)
			{
				_mc.txtNum.removeEventListener(Event.CHANGE,onInput);
				_mc = null;
			}
			_panel = null;
		}
	}
}