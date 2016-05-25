package com.view.selectRole
{
	import com.view.gameWindow.util.Cover;
	
	import flash.events.MouseEvent;
	import com.view.gameWindow.panel.panels.prompt.McPanel2BtnPrompt;

	public class Panel2BtnPromotMouseHandle
	{
		private var _mc:McPanel2BtnPrompt;
		private var _cover:Cover;
		private var _callBack:Function;
		
		public function Panel2BtnPromotMouseHandle()
		{
		}
		
		public function addEvent(mc:McPanel2BtnPrompt,cover:Cover,callBack:Function = null):void
		{
			_callBack = callBack;
			_mc = mc;
			_cover = cover;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			if(evt.target == _mc.btnSure || evt.target == _mc.btnCancel)
			{
				if(evt.target == _mc.btnSure)
				{
					if(_callBack != null)
					{
						_callBack();
					}
				}
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