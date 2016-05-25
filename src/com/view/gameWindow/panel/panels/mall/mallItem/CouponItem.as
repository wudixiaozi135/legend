package com.view.gameWindow.panel.panels.mall.mallItem
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.GameShopCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.mall.coupon.McCouponItem;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    /**
	 * Created by Administrator on 2014/11/23.
	 */
	public class CouponItem extends MallItemBase
	{
		public function CouponItem()
		{
			_skin = new McCouponItem();
			var mc:McCouponItem = _skin as McCouponItem;
			addChild(_skin);

			initView();
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		private var _itemCfg:ItemCfgData;
		private var _dt:ThingsData;
		private var _cellEx:IconCellEx;

		private var _data:GameShopCfgData;

		public function get data():GameShopCfgData
		{
			return _data;
		}

		public function set data(value:GameShopCfgData):void
		{
			_data = value;
			var skin:McCouponItem = _skin as McCouponItem;

			if (_data)
			{
				_itemCfg = ConfigDataManager.instance.itemCfgData(_data.item_id);

				if (skin.goldContainer.numChildren)
				{
					ObjectUtils.clearAllChild(skin.goldContainer);
				}
				skin.goldContainer.addChild(new CostType(_data.cost_type));

				skin.txtName.textColor = ItemType.getColorByQuality(_itemCfg.quality);
				skin.txtName.text = _itemCfg.name;

				skin.txtPrice.text = StringConst.MALL_LABEL_8;
                skin.txtValue.text = _data.cost_value.toString();

				_cellEx = new IconCellEx(skin.iconContainer, 0, 0, 60, 60);
				_dt = new ThingsData();
				_dt.id = _itemCfg.id;
				_dt.type = SlotType.IT_ITEM;
				IconCellEx.setItemByThingsData(_cellEx, _dt);
				ToolTipManager.getInstance().attach(_cellEx);
			}
		}

		private var _clickHandler:Function;

		public function get clickHandler():Function
		{
			return _clickHandler;
		}

		public function set clickHandler(value:Function):void
		{
			_clickHandler = value;
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McCouponItem = _skin as McCouponItem;
			rsrLoader.addCallBack(skin.bg, function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				mc.mouseChildren = false;
			});
		}

		override public function destroy():void
		{
			if (_cellEx)
			{
				ToolTipManager.getInstance().detach(_cellEx);
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

		private function onClick(event:MouseEvent):void
		{
			if (_clickHandler != null)
			{
				_clickHandler(this);
			}
		}
	}
}
