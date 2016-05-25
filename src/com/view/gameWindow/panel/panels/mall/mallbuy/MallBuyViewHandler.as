package com.view.gameWindow.panel.panels.mall.mallbuy
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.mall.MallDataManager;
	import com.view.gameWindow.panel.panels.mall.McMallBuyPanel;
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
	public class MallBuyViewHandler
	{
		public function MallBuyViewHandler(panel:PanelMallBuy)
		{

			this._panel = panel;
			var skin:McMallBuyPanel = _panel.skin as McMallBuyPanel;
			skin.mcIcon.mouseEnabled = false;
			_panel.mouseEnabled = false;
			skin.txtCount.restrict = "0-9";
			init();
			refresh();
			MallEvent.addEventListener(MallEvent.CHANGE_BUY_COUNT, onChangeCount);
			MallEvent.addEventListener(MallEvent.LIMIT_GOODS, onRefresh, false, 0, true);
		}
		private var _panel:PanelMallBuy;
		private var _cellEx:IconCellEx;
		private var _dt:ThingsData;
		private var _itemCfg:ItemCfgData;

		public function refresh():void
		{
			var skin:McMallBuyPanel = _panel.skin as McMallBuyPanel;
			var data:GameShopCfgData = MallBuyData.buyData;
			if (data)
			{
				if (skin.icon1.numChildren)
				{
					ObjectUtils.clearAllChild(skin.icon1);
				}
				skin.icon1.addChild(new CostType(data.cost_type));

				skin.txtAllCostValue.text = data.cost_value.toString();
				if (data.is_limit)
				{
					var mdt:MallDataManager = MallDataManager.instance;
					var limitCount:int = mdt.limitGoods[data.id];//已购买次数
					skin.txtLimit.text = StringConst.MALL_BUY_LABEL_2;
					skin.txtLimitCount.text = (data.limit_num - limitCount) + "/" + data.limit_num.toString();
				} else
				{
					skin.txtLimit.text = "";//每日限购
					skin.txtLimitCount.text = "";//不上限
				}

				_itemCfg = ConfigDataManager.instance.itemCfgData(data.item_id);
				skin.txtItemName.textColor = ItemType.getColorByQuality(_itemCfg.quality)
				skin.txtItemName.text = _itemCfg.name;

				_cellEx = new IconCellEx(skin.mcIcon, 0, 0, 60, 60);
				_dt = new ThingsData();
				_dt.id = _itemCfg.id;
				_dt.type = SlotType.IT_ITEM;
				_dt.bind = data.is_bind;
				IconCellEx.setItemByThingsData(_cellEx, _dt);
				ToolTipManager.getInstance().attach(_cellEx);
				
				_panel.hightLight = data.hight_light;
			}
		}

		public function destroy():void
		{
			MallEvent.removeEventListener(MallEvent.CHANGE_BUY_COUNT, onChangeCount);
			MallEvent.removeEventListener(MallEvent.LIMIT_GOODS, onRefresh);
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
			var skin:McMallBuyPanel = _panel.skin as McMallBuyPanel;
			skin.txtName.textColor = 0xfee0a9;
			skin.txtName.text = StringConst.MALL_BUY_LABEL_5;
			skin.txtName.mouseEnabled = false;

			skin.txtCount.textColor = 0xffffff;
			skin.txtCount.text = "1";

			skin.txtAllCost.textColor = 0xd4a460;
			skin.txtAllCost.mouseEnabled = false;
			skin.txtAllCost.text = StringConst.MALL_BUY_LABEL_0;

			skin.txtLimit.textColor = 0xd4a460;
			skin.txtLimit.mouseEnabled = false;
			skin.txtLimit.text = StringConst.MALL_BUY_LABEL_2;

			skin.txtBuyNum.textColor = 0xd4a460;
			skin.txtBuyNum.mouseEnabled = false;
			skin.txtBuyNum.text = StringConst.MALL_BUY_LABEL_1;

			skin.txtOk.textColor = 0xf9c499;
			skin.txtOk.mouseEnabled = false;
			skin.txtOk.text = StringConst.MALL_BUY_LABEL_3;

			skin.txtCancel.textColor = 0xf9c499;
			skin.txtCancel.mouseEnabled = false;
			skin.txtCancel.text = StringConst.MALL_BUY_LABEL_4;
			
			
		}

		private function onRefresh(event:MallEvent):void
		{
			refresh();
		}

		private function onChangeCount(event:MallEvent):void
		{
			var skin:McMallBuyPanel = _panel.skin as McMallBuyPanel;
			var data:GameShopCfgData = MallBuyData.buyData;
			if (data)
			{
				var count:int = MallBuyData.buyCount;
				skin.txtAllCostValue.text = (data.cost_value * count).toString();
				skin.txtCount.text = count.toString();
			}
		}
	}
}
