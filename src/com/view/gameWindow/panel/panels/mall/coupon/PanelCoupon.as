package com.view.gameWindow.panel.panels.mall.coupon
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;

	import flash.display.MovieClip;

	/**
	 * Created by Administrator on 2014/11/23.
	 * 优惠券商店
	 */
	public class PanelCoupon extends PanelBase
	{
		public function PanelCoupon()
		{
			super();
			CouponDataManager.instance.attach(this);
		}

		private var _viewHandler:CouponViewHandler;
		private var _mouseHandler:CouponMouseHandler;

		override protected function initSkin():void
		{
			_skin = new McCouponPanel();
			addChild(_skin);
			var mc:McCouponPanel = _skin as McCouponPanel;
			setTitleBar(mc.dragBox);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McCouponPanel = _skin as McCouponPanel;
			rsrLoader.addCallBack(skin.selectMc, function (mc:MovieClip):void
			{
				mc.visible = false;
				mc.mouseEnabled = false;
				mc.mouseChildren = false;

				if (_viewHandler)
				{
					_viewHandler.refresh();
				}
			});

			rsrLoader.addCallBack(skin.paneBg, function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				mc.mouseChildren = false;
			});
		}


		override protected function initData():void
		{
			_viewHandler = new CouponViewHandler(this);
			_mouseHandler = new CouponMouseHandler(this);
		}


		override public function update(proc:int = 0):void
		{
			switch (proc)
			{
				default :
					break;
				case GameServiceConstants.CM_BUY_PREFERENTIAL_SHOP:
					PanelMediator.instance.closePanel(PanelConst.TYPE_MALL_COUPON);
					break;
			}
		}

		override public function destroy():void
		{
			CouponDataManager.instance.detach(this);
			if (_viewHandler)
			{
				_viewHandler.destroy();
				_viewHandler = null;
			}
			if (_mouseHandler)
			{
				_mouseHandler.destroy();
				_mouseHandler = null;
			}
			if (_skin)
			{
				_skin = null;
			}
			super.destroy();
		}
	}
}
