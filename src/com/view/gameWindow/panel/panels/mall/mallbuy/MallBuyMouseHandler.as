package com.view.gameWindow.panel.panels.mall.mallbuy
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.mall.MallDataManager;
	import com.view.gameWindow.panel.panels.mall.McMallBuyPanel;
	import com.view.gameWindow.panel.panels.mall.constant.ShopCostType;
	import com.view.gameWindow.panel.panels.mall.event.MallEvent;
	import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireManager;
	import com.view.gameWindow.panel.panels.mall.mallbuy.data.MallBuyData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * Created by Administrator on 2014/11/21.
	 */
	public class MallBuyMouseHandler
	{
		public function MallBuyMouseHandler(panel:PanelMallBuy)
		{
			this._panel = panel;
			_skin = _panel.skin as McMallBuyPanel;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			_skin.txtCount.addEventListener(Event.CHANGE, onChangeEvt, false, 0, true);
		}

		private var _skin:McMallBuyPanel;
		private var _panel:PanelMallBuy;

		public function closeHandler():void
		{
			MallBuyData.buyData = null;
			MallBuyData.buyCount = 1;
			PanelMediator.instance.closePanel(PanelConst.TYPE_MALL_BUY);
		}

		public function destroy():void
		{
			if (_skin)
			{
				_skin.txtCount.removeEventListener(Event.CHANGE, onChangeEvt);
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
		}

		private function addCount():void
		{
			var count:int = MallBuyData.buyCount;
			count++;
			if (count >= MallBuyData.BUY_MAX_COUNT)
			{
				count = MallBuyData.BUY_MAX_COUNT;
			}
			MallBuyData.buyCount = count;
			MallEvent.dispatchEvent(new MallEvent(MallEvent.CHANGE_BUY_COUNT));
		}

		private function subCount():void
		{
			var count:int = MallBuyData.buyCount;
			count--;
			if (count <= 0)
			{
				count = 1;
			}
			MallBuyData.buyCount = count;
			MallEvent.dispatchEvent(new MallEvent(MallEvent.CHANGE_BUY_COUNT));
		}

		private function okHandler():void
		{
			var data:GameShopCfgData = MallBuyData.buyData;
			var buyCount:int = MallBuyData.buyCount;

			var mgt:MallDataManager = MallDataManager.instance;
			if (data.is_limit) {
				var alreadyBuyCount:int = mgt.limitGoods[data.id];
				if (alreadyBuyCount && alreadyBuyCount == data.limit_num)
				{//今日购买次数已用完
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.MALL_COUPON_MESSAGE_6);
					return;
				}
				if (buyCount > data.limit_num - alreadyBuyCount)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.MALL_COUPON_MESSAGE_7);
					return;
				}
			}
			if (data)
			{
				var bagMgt:BagDataManager = BagDataManager.instance;
				var needCost:int, ownCost:int;
				if (data.cost_type == ShopCostType.TYPE_GOLD)
				{//元宝
					ownCost = bagMgt.goldUnBind;
				} else if (data.cost_type == ShopCostType.TYPE_SCORE)
				{//积分
					ownCost = bagMgt.costScore;
				} else
				{//礼券
					ownCost = bagMgt.goldBind;
				}
				needCost = buyCount * data.cost_value;
				if (needCost > ownCost)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst["RESOURCE_LACK_" + data.cost_type]);
					AcquireManager.costType = data.cost_type;
					openAcquirePanel();
					closeHandler();
					return;
				}

				var byte:ByteArray = new ByteArray();
				byte.endian = Endian.LITTLE_ENDIAN;
				byte.writeInt(data.id);
				byte.writeInt(buyCount);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BUY_SHOP_ITEM, byte);
			}
		}

		/**打开对应的获取面板*/
		private function openAcquirePanel():void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_MALL_ACQUIRE);
		}

		private function cancelHandler():void
		{
			closeHandler();
		}

		private function onChangeEvt(event:Event):void
		{
			var count:int = int(_skin.txtCount.text);
			if (count > MallBuyData.BUY_MAX_COUNT)
			{
				count = MallBuyData.BUY_MAX_COUNT;
				_skin.txtCount.text = count.toString();
			} else if (count < 1)
			{
				count = 1;
				_skin.txtCount.text = count.toString();
			}
			MallBuyData.buyCount = count;
			MallEvent.dispatchEvent(new MallEvent(MallEvent.CHANGE_BUY_COUNT));
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				default :
					break;
				case _skin.btnClose:
					closeHandler();
					break;
				case _skin.btnAdd:
					addCount();
					break;
				case _skin.btnSub:
					subCount();
					break;
				case _skin.btnOk:
					okHandler();
					break;
				case _skin.btnCancel:
					cancelHandler();
					break;
			}
		}
	}
}
