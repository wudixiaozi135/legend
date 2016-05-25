package com.view.gameWindow.panel.panels.stall.item
{
    import com.model.configData.ConfigDataManager;
    import com.model.consts.SlotType;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.McStallItem;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.mall.constant.ResIconType;
    import com.view.gameWindow.panel.panels.mall.mallItem.CostType;
    import com.view.gameWindow.panel.panels.stall.data.StallDataInfo;
    import com.view.gameWindow.panel.panels.stall.stallBuy.StallBuyDataManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallOtherItem extends McStallItem
    {
        private var _storageType:int;
        private var _cellEx:IconCellEx;
        private var _dt:ThingsData;
        private var _data:StallDataInfo;

        public function StallOtherItem()
        {
            super();
            txtName.mouseEnabled = false;
            txtPrice.mouseEnabled = false;
            txtPriceValue.mouseEnabled = false;
            txtCount.mouseEnabled = false;
            txtCount.textColor = 0xffffff;

            _dt = new ThingsData();
            _cellEx = new IconCellEx(iconCell, 0, 0, 36, 36);
            _cellEx.doubleClickEnabled = true;
            _cellEx.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
        }

        private function onDoubleClick(event:MouseEvent):void
        {
            if (_data)
            {
                StallBuyDataManager.bagData = _data;
                PanelMediator.instance.openPanel(PanelConst.TYPE_STALL_BUY);
            }
        }

        public function refreshData(data:StallDataInfo):void
        {
            var bagData:BagData, cfg:*;
            if (data)
            {
                if (_data != data)
                {
                    _data = data;
                }
                clearTips();
                _dt.bornSid = data.born_sid;
                _dt.id = data.item_id;
                _dt.type = data.item_type;

                IconCellEx.setItemByThingsData(_cellEx, _dt);
                ToolTipManager.getInstance().attach(_cellEx);

                if (data.item_type == SlotType.IT_ITEM)
                {
                    cfg = ConfigDataManager.instance.itemCfgData(data.item_id);
                } else
                {
                    cfg = MemEquipDataManager.instance.memEquipData(data.born_sid, data.item_id).equipCfgData;
                }
                txtName.text = cfg.name + "";
                txtPriceValue.text = data.cost.toString();
                if (data.item_count > 1)
                {
                    txtCount.text = data.item_count.toString();
                } else
                {
                    txtCount.text = "";
                }
                clearIcon();
                var costType:CostType;
                if (data.cost_type == 1)
                {//金币
                    costType = new CostType(ResIconType.TYPE_MONEY);
                } else
                {
                    costType = new CostType(ResIconType.TYPE_GOLD);
                }
                costContainer.addChild(costType);
            }
        }

        private function clearTips():void
        {
            if (_cellEx)
            {
                ToolTipManager.getInstance().detach(_cellEx);
            }
        }

        private function clearIcon():void
        {
            if (costContainer)
            {
                while (costContainer.numChildren > 0)
                {
                    costContainer.removeChildAt(0);
                }
            }
        }

        public function get storageType():int
        {
            return _storageType;
        }

        public function set storageType(value:int):void
        {
            _storageType = value;
        }

        public function destroy():void
        {
            if (_cellEx)
            {
                clearTips();
                _cellEx = null;
            }
            if (_dt)
            {
                _dt = null;
            }
            if (costContainer)
            {
                clearIcon();
                if (contains(costContainer))
                {
                    removeChild(costContainer);
                    costContainer = null;
                }
            }
        }
    }
}
