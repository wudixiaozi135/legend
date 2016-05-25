package com.view.gameWindow.panel.panels.mall.coupon
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagPanel;
	import com.view.gameWindow.panel.panels.mall.mallItem.CouponBottom;
	import com.view.gameWindow.panel.panels.mall.mallItem.CouponItem;
	import com.view.gameWindow.util.ObjectUtils;
	import com.view.newMir.NewMirMediator;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * Created by Administrator on 2014/11/23.
	 */
	public class CouponViewHandler
	{
		public function CouponViewHandler(panel:PanelCoupon)
		{
			_panel = panel;
			_skin = _panel.skin as McCouponPanel;
			_objs = new Dictionary(true);
			init();
		}

		private var _panel:PanelCoupon;
		private var _skin:McCouponPanel;
		private var _objs:Dictionary;
		private var _bottomPanel:CouponBottom;

		public function refresh():void
		{
			var dic:Dictionary = ConfigDataManager.instance.gameShopCfgData();
			var itemCfg:ItemCfgData = CouponDataManager.itemCfg;
			var key:int, shopCfg:GameShopCfgData, couponData:Array;
			if (itemCfg)
			{
				couponData = itemCfg.effect.split(":");
				for (var i:int = 0, len:int = couponData.length; i < len; i++)
				{
					key = couponData[i];
					shopCfg = dic[key];
					if (shopCfg)
					{
						var couponItem:CouponItem = _objs[key];
						if (!couponItem)
						{
							couponItem = new CouponItem();
							_objs[key] = couponItem;
						}
						couponItem.clickHandler = onClickHandler;
						couponItem.data = shopCfg;
						if (_skin.iconContainer.contains(couponItem) == false)
						{
							_skin.iconContainer.addChild(couponItem);
						}
						couponItem.x = (i % 3) * couponItem.width;
						couponItem.y = int(i / 3 % 2) * couponItem.height;
					}
				}
				onClickHandler(_objs[couponData[0]]);
			}

			if (couponData)
			{
				var leng:int = ObjectUtils.getTotalPage(couponData.length, 3);
				_skin.paneBg.height += (leng - 1) * 132;
				_skin.bottomContainer.y += (leng - 1) * 118;
			}
			dealWindow();
		}

		public function destroy():void
		{
			for each(var item:CouponItem in _objs)
			{
				item.destroy();
				item = null;
			}
			if (_objs)
			{
				_objs = null
			}
		}

		private function dealWindow():void
		{
			var mallCoupon:PanelCoupon = PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL_COUPON) as PanelCoupon;
			var bagPanel:BagPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG) as BagPanel;
			if (mallCoupon && bagPanel)
			{
				var mallRect:Rectangle = mallCoupon.getPanelRect();
				var bagRect:Rectangle = bagPanel.getPanelRect();
				var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
				var x:int = int((newMirMediator.width - mallRect.width - bagRect.width) * .5);
				var y:int = int((newMirMediator.height - bagRect.height) * .5);
				bagPanel.postion = new Point(x, y);
				mallCoupon.postion = new Point(x + bagRect.width, y + mallRect.y + 5);
			}
		}

		private function onClickHandler(item:CouponItem):void
		{
			if (_bottomPanel)
			{
				_bottomPanel.data = item.data;
				_skin.selectMc.x = item.x + item.parent.x;
				_skin.selectMc.y = item.y + item.parent.y;

				if (!_skin.selectMc.visible)
					_skin.selectMc.visible = true;
			}
		}

		private function init():void
		{
			_skin.txtName.text = StringConst.MALL_COUPON_1;
			_skin.txtName.mouseEnabled = false;
			_bottomPanel = new CouponBottom();
			_skin.bottomContainer.addChild(_bottomPanel);
		}
	}
}
