package com.view.gameWindow.panel.panels.mail
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
	
	import flash.events.MouseEvent;

	/**
	 * 右键面板功能按钮点击处理类
	 * @author Administrator
	 */	
	public class PanelMailClickHandle
	{
		private var _panel:PanelMail;
		private var _mc:McMail;
		
		public function PanelMailClickHandle(panel:PanelMail)
		{
			_panel = panel;
			_mc = _panel.skin as McMail;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_MAIL);
					break;
				case _mc.btnGetAll:
					dealGetAll();
					break;
				case _mc.btnDeleteAll:
					dealDeleteAll();
					break;
			}
		}
		
		private function dealGetAll():void
		{
			PanelMailDataManager.instance.getAllMailAttachment();
		}
		
		private function dealDeleteAll():void
		{
			PanelMailDataManager.instance.delAllMail();
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