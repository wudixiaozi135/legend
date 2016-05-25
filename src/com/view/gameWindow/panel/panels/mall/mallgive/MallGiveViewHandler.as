package com.view.gameWindow.panel.panels.mall.mallgive
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.mall.McMallGive;
	import com.view.gameWindow.panel.panels.mall.event.MallEvent;
	import com.view.gameWindow.panel.panels.mall.mallItem.CostType;
	import com.view.gameWindow.panel.panels.mall.mallbuy.data.MallBuyData;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.ObjectUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;

	/**
	 * Created by Administrator on 2014/11/21.
	 */
	public class MallGiveViewHandler
	{
		public function MallGiveViewHandler(panel:PanelMallGive)
		{
			this._panel = panel;
			_skin = _panel.skin as McMallGive;

			_skin.mcIcon.mouseEnabled = false;
			_panel.mouseEnabled = false;
			_skin.txtCount.restrict = "0-9";

			init();
			MallEvent.addEventListener(MallEvent.CHANGE_GIVE_COUNT, onChangeCount);
			refresh();
		}

		private var _panel:PanelMallGive;
		private var _cellEx:IconCellEx;
		private var _dt:ThingsData;
		private var _itemCfg:ItemCfgData;
		private var _skin:McMallGive;

		public function refresh():void
		{
			var data:GameShopCfgData = MallBuyData.giveData;
			if (data)
			{
				_skin.txtAllCostValue.text = data.cost_value.toString();
				if (_skin.icon0.numChildren)
				{
					ObjectUtils.clearAllChild(_skin.icon0);
				}
				if (_skin.icon1.numChildren)
				{
					ObjectUtils.clearAllChild(_skin.icon1);
				}
				_skin.icon0.addChild(new CostType(data.cost_type));
				_skin.icon1.addChild(new CostType(data.cost_type));
				_skin.txtPriceValue.text = data.cost_value.toString();
				_itemCfg = ConfigDataManager.instance.itemCfgData(data.item_id);
				_skin.txtItemName.textColor = ItemType.getColorByQuality(_itemCfg.quality);
				_skin.txtItemName.text = _itemCfg.name;

				_cellEx = new IconCellEx(_skin.mcIcon, 0, 0, 60, 60);
				_dt = new ThingsData();
				_dt.id = _itemCfg.id;
				_dt.type = SlotType.IT_ITEM;
				_dt.bind = data.is_bind;
				IconCellEx.setItemByThingsData(_cellEx, _dt);
				ToolTipManager.getInstance().attach(_cellEx);
			}
		}

		public function destroy():void
		{
			MallBuyData.giveCount = 1;
			MallBuyData.giveData = null;
			MallEvent.removeEventListener(MallEvent.CHANGE_GIVE_COUNT, onChangeCount);
			if (_cellEx)
			{
				_cellEx.destroy();
				_cellEx = null;
			}
			if (_dt)
			{
				_dt = null;
			}
			if (_itemCfg)
			{
				_itemCfg = null;
			}
			if (_panel)
			{
				_panel = null;
			}
		}

		private function init():void
		{
			var skin:McMallGive = _panel.skin as McMallGive;
			skin.txtName.textColor = 0xfee0a9;
			skin.txtName.text = StringConst.MALL_GIVE_LABEL_1;
			skin.txtName.mouseEnabled = false;

			skin.txtPrice.textColor = 0xd4a460;
			skin.txtPrice.mouseEnabled = false;
			skin.txtPrice.text = StringConst.MALL_GIVE_LABEL_2;

			skin.txtBuyNum.textColor = 0xd4a460;
			skin.txtBuyNum.mouseEnabled = false;
			skin.txtBuyNum.text = StringConst.MALL_BUY_LABEL_1;

			skin.txtCount.textColor = 0xffffff;
			skin.txtCount.text = "1";

			skin.txtAllCost.textColor = 0xd4a460;
			skin.txtAllCost.mouseEnabled = false;
			skin.txtAllCost.text = StringConst.MALL_GIVE_LABEL_4;

			skin.txtGive.textColor = 0xd4a460;
			skin.txtGive.mouseEnabled = false;
			skin.txtGive.text = StringConst.MALL_GIVE_LABEL_5;

			skin.txtNotice.htmlText = StringConst.MALL_GIVE_LABEL_6;
			skin.txtNotice.mouseEnabled = false;

			skin.txtFriend.htmlText = StringConst.MALL_GIVE_LABEL_7;

			skin.txtOk.textColor = 0xf9c499;
			skin.txtOk.mouseEnabled = false;
			skin.txtOk.text = StringConst.MALL_GIVE_LABEL_8;
		}

		private function onChangeCount(event:MallEvent):void
		{
			var data:GameShopCfgData = MallBuyData.giveData;
			if (data)
			{
				var count:int = MallBuyData.giveCount;
				_skin.txtAllCostValue.text = (data.cost_value * count).toString();
				_skin.txtCount.text = count.toString();
			}
		}
	}
}
