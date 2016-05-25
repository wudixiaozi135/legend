package com.view.gameWindow.panel.panels.mall.mallgive
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactEntry;
	import com.view.gameWindow.panel.panels.friend.ContactType;
	import com.view.gameWindow.panel.panels.friend.PanelFriend;
	import com.view.gameWindow.panel.panels.mall.MallDataManager;
	import com.view.gameWindow.panel.panels.mall.McMallGive;
	import com.view.gameWindow.panel.panels.mall.constant.ShopCostType;
	import com.view.gameWindow.panel.panels.mall.event.MallEvent;
	import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireManager;
	import com.view.gameWindow.panel.panels.mall.mallbuy.data.MallBuyData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.newMir.NewMirMediator;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * Created by Administrator on 2014/11/21.
	 */
	public class MallGiveMouseHandler
	{
		public function MallGiveMouseHandler(panel:PanelMallGive)
		{
			this._panel = panel;
			_skin = _panel.skin as McMallGive;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			_skin.txtCount.addEventListener(Event.CHANGE, onChangeEvt, false, 0, true);
			_skin.txtFriend.addEventListener(TextEvent.LINK, onLinkEvt, false, 0, true);
			MallEvent.addEventListener(MallEvent.SELECT_FRIEND, onSelectFriend, false, 0, true);
		}

		private var _panel:PanelMallGive;
		private var _skin:McMallGive;

		public function closeHandler():void
		{
			if (PanelMediator.instance.openedPanels(PanelConst.TYPE_FRIEND))
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_FRIEND);
			}
			PanelMediator.instance.closePanel(PanelConst.TYPE_MALL_GIVE);
		}

		public function destroy():void
		{
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin.txtFriend.removeEventListener(TextEvent.LINK, onLinkEvt);
				_skin.txtCount.removeEventListener(Event.CHANGE, onChangeEvt);
				_skin = null;
			}
		}

		private function dealFriendListPanel():void
		{
			var mallGivePanel:PanelMallGive = PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL_GIVE) as PanelMallGive;
			var friendPanel:PanelFriend = PanelMediator.instance.openedPanel(PanelConst.TYPE_FRIEND) as PanelFriend;
			var mallRect:Rectangle = mallGivePanel.getPanelRect();
			var friendRect:Rectangle = friendPanel.getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var x:int = int((newMirMediator.width - mallRect.width - friendRect.width) * .5);
			var y:int = int((newMirMediator.height - mallRect.height) * .5);
			mallGivePanel.postion = new Point(x, y);
			friendPanel.postion = new Point(x + mallRect.width - 10, y + mallRect.y);
			friendPanel.setSelectShow(ContactType.FRIEND);
		}

		private function okHandler():void
		{
			if (_skin.txtFriendName.text == "" || _skin.txtFriendName.text == null)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.MALL_GIVE_MESSAGE_3);
				return;
			}
			var data:GameShopCfgData = MallBuyData.giveData;
			var entry:ContactEntry = MallDataManager.instance.friendEntry;
			if (data && entry)
			{
				var bagMgt:BagDataManager = BagDataManager.instance;
				var buyCount:int = MallBuyData.buyCount;
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
				byte.writeInt(MallBuyData.giveCount);
				byte.writeInt(entry.roleId);//cid
				byte.writeInt(entry.serverId);//sid
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GIVE_FRIEND_ITEM, byte);
			}
			closeHandler();
		}

		/**打开对应的获取面板*/
		private function openAcquirePanel():void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_MALL_ACQUIRE);
		}

		private function subCount():void
		{
			var count:int = MallBuyData.giveCount;
			count--;
			if (count <= 0)
			{
				count = 1;
			}
			MallBuyData.giveCount = count;
			MallEvent.dispatchEvent(new MallEvent(MallEvent.CHANGE_GIVE_COUNT));
		}

		private function addCount():void
		{
			var count:int = MallBuyData.giveCount;
			count++;
			if (count >= MallBuyData.BUY_MAX_COUNT)
			{
				count = MallBuyData.BUY_MAX_COUNT;
			}
			MallBuyData.giveCount = count;
			MallEvent.dispatchEvent(new MallEvent(MallEvent.CHANGE_GIVE_COUNT));
		}

		private function onSelectFriend(event:MallEvent):void
		{
			var param:ContactEntry = event._param as ContactEntry;
			_skin.txtFriendName.text = param.name;
			MallDataManager.instance.friendEntry = param;
		}

		private function onLinkEvt(event:TextEvent):void
		{
			if (event.text == "friendlist")
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_FRIEND);
				dealFriendListPanel();
			}
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
			MallBuyData.giveCount = count;
			MallEvent.dispatchEvent(new MallEvent(MallEvent.CHANGE_GIVE_COUNT));
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
			}
		}
	}
}
