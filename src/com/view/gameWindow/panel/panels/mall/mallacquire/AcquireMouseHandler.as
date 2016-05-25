package com.view.gameWindow.panel.panels.mall.mallacquire
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.mall.McAcquirePanel;

	import flash.events.MouseEvent;

	/**
	 * Created by Administrator on 2014/11/22.
	 */
	public class AcquireMouseHandler
	{
		public function AcquireMouseHandler(panel:PanelAcquire)
		{
			this._panel = panel;
			_skin = _panel.skin as McAcquirePanel;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		private var _panel:PanelAcquire;
		private var _skin:McAcquirePanel;

		public function destroy():void
		{
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
		}

		private function closeHandler():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_MALL_ACQUIRE);
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				case _skin.btnClose:
				case _skin.btnOk:
					closeHandler();
					break;
				default :
					break;
			}
		}

	}
}
