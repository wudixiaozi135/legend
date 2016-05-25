package com.view.gameWindow.panel.panels.mail.content
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;

    import flash.events.MouseEvent;

    public class PanelMailContentClickHandle
	{
		private var _panel:PanelMailContent;
		private var _mc:McMailContent;
		
		public function PanelMailContentClickHandle(panel:PanelMailContent)
		{
			_panel = panel;
			_mc = _panel.skin as McMailContent;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mc.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_MAIL_CONTENT);
					break;
				case _mc.btnGet:
					dealGetMail();
					break;
			}
		}
		
		private function dealGetMail():void
		{
			var selectIndex:int = _panel.viewHandle.selectIndex;
			if(selectIndex != -1)
			{
				PanelMailDataManager.instance.getMailAttachment(selectIndex);
			}
		}
		
		public function destroy():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
	}
}