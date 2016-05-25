package com.view.gameWindow.panel.panels.mall.coupon
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;

	import flash.events.MouseEvent;

	/**
	 * Created by Administrator on 2014/11/23.
	 */
	public class CouponMouseHandler
	{
		public function CouponMouseHandler(panel:PanelCoupon)
		{
			this._panel = panel;
			_skin = _panel.skin as McCouponPanel;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		private var _panel:PanelCoupon;
		private var _skin:McCouponPanel;

		public function destroy():void
		{
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				default :
					break;
				case _skin.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_MALL_COUPON);
					break;
			}
		}
	}
}
