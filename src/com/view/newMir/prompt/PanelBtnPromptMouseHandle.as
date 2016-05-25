package com.view.newMir.prompt
{
	import com.view.gameWindow.util.Cover;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.view.gameWindow.panel.panels.prompt.McPanel1BtnPrompt;

	public class PanelBtnPromptMouseHandle extends Sprite
	{
		private var _mc:McPanel1BtnPrompt;
		private var _cover:Cover;
		
		
		public function PanelBtnPromptMouseHandle()
		{
		}
		
		public function addEvent(mc:McPanel1BtnPrompt,cover:Cover):void
		{
			_mc = mc;
			_cover = cover;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			if(evt.target == _mc.btnClose || evt.target == _mc.btnOne)
			{
				if(_mc)
				{
					_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
					if(_mc.parent)
						_mc.parent.removeChild(_mc);
					_mc = null;
				}
				if(_cover)
				{
					if(_cover.parent)
						_cover.parent.removeChild(_cover);
					_cover = null;
				}
			}
		}
	}
}