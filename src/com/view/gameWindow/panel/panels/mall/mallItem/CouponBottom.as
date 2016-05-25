package com.view.gameWindow.panel.panels.mall.mallItem
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.mall.coupon.CouponDataManager;
	import com.view.gameWindow.panel.panels.mall.coupon.McCouponBottom;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ObjectUtils;

	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * Created by Administrator on 2014/11/23.
	 */
	public class CouponBottom extends MallItemBase
	{
		public function CouponBottom()
		{
			_skin = new McCouponBottom();
			var mc:McCouponBottom = _skin as McCouponBottom;
			addChild(_skin);

			initView();
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

			initTxt();
		}

		private var _data:GameShopCfgData;

		public function get data():GameShopCfgData
		{
			return _data;
		}

		public function set data(value:GameShopCfgData):void
		{
			var skin:McCouponBottom = _skin as McCouponBottom;
			_data = value;
			if (_data)
			{
				if (skin.goldContainer1.numChildren)
				{
					ObjectUtils.clearAllChild(skin.goldContainer1);
				}
				if (skin.goldContainer2.numChildren)
				{
					ObjectUtils.clearAllChild(skin.goldContainer2);
				}
				skin.goldContainer1.addChild(new CostType(_data.cost_type));
				skin.goldContainer2.addChild(new CostType(_data.cost_type));

				skin.txtNowValue.text = _data.preferential_price.toString();
				skin.txtDiscout.htmlText = HtmlUtils.createHtmlStr(0x00ff00, StringConst.MALL_COUPON_4);
				skin.txtDiscoutValue.htmlText = HtmlUtils.createHtmlStr(0xffcc00, (_data.cost_value - _data.preferential_price).toString()) + HtmlUtils.createHtmlStr(0x00ff00, ")");
			}
		}

		override public function destroy():void
		{
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			if (_data)
			{
				_data = null;
			}
			super.destroy();
		}

		private function initTxt():void
		{
			var skin:McCouponBottom = _skin as McCouponBottom;
			skin.btnTxt.textColor = 0xd4a460;
			skin.btnTxt.text = StringConst.MALL_COUPON_2;
			skin.txtDesc.htmlText = StringConst.MALL_COUPON_5;

			skin.txtNowPrice.text = StringConst.MALL_COUPON_3;

			skin.btnTxt.mouseEnabled = false;
			skin.txtNowPrice.mouseEnabled = false;
			skin.txtNowValue.mouseEnabled = false;
			skin.txtDiscoutValue.mouseEnabled = false;
			skin.txtDesc.mouseEnabled = false;
		}

		private function buyHandler():void
		{
			var bagData:BagData = CouponDataManager.bagData;
			if (bagData == null)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.MALL_COUPON_MESSAGE_1);
				return;
			}
			CouponDataManager.shopCfg = _data;
			var byte:ByteArray = new ByteArray();
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeInt(_data.id);
			byte.writeByte(bagData.storageType);
			byte.writeByte(bagData.slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BUY_PREFERENTIAL_SHOP, byte);
		}

		private function onClick(event:MouseEvent):void
		{
			var skin:McCouponBottom = _skin as McCouponBottom;
			switch (event.target)
			{
				case skin.btnBuy:
					buyHandler();
					break;
				default :
					break;
			}
		}
	}
}
