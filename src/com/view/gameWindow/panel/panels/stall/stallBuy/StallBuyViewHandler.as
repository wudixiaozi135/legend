package com.view.gameWindow.panel.panels.stall.stallBuy
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.McStallBuy;
    import com.view.gameWindow.panel.panels.mall.constant.ResIconType;
    import com.view.gameWindow.panel.panels.mall.mallItem.CostType;
    import com.view.gameWindow.panel.panels.stall.data.StallDataInfo;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallBuyViewHandler
    {

        private var _panel:PanelStallBuy;
        private var _skin:McStallBuy;
        private var _iconCell:IconCellEx;
        private var _thing:ThingsData;

        public function StallBuyViewHandler(panel:PanelStallBuy)
        {
            _panel = panel;
            _skin = _panel.skin as McStallBuy;
            var centX:Number = (_skin.mcIcon.width - 58) >> 1;
            var centY:Number = (_skin.mcIcon.height - 58) >> 1;
            _iconCell = new IconCellEx(_skin.mcIcon, centX + 2, centY, 58, 58);
            _thing = new ThingsData();
            init();
        }

        private function init():void
        {
            _skin.txtBuy.mouseEnabled = false;
            _skin.txtBuy.textColor = 0xd4a460;
            _skin.txtBuy.text = StringConst.STALL_PANEL_0010;

            _skin.txtCancel.mouseEnabled = false;
            _skin.txtCancel.textColor = 0xd4a460;
            _skin.txtCancel.text = StringConst.STALL_PANEL_0011;

            _skin.txtSell.mouseEnabled = false;
            _skin.txtSell.textColor = 0xd4a460;
            _skin.txtSell.text = StringConst.STALL_PANEL_0009;

            _skin.txtSellValue.mouseEnabled = false;
            _skin.txtSellValue.textColor = 0xd4a460;

            _skin.txtCount.mouseEnabled = false;
            _skin.txtCount.textColor = 0xffffff;

            refresh();
        }

        public function refresh():void
        {
            var data:StallDataInfo = StallBuyDataManager.bagData;
            if (data)
            {
                clearTips();
                _thing.bornSid = data.born_sid;
                _thing.id = data.item_id;
                _thing.type = data.item_type;
                IconCellEx.setItemByThingsData(_iconCell, _thing);
                ToolTipManager.getInstance().attach(_iconCell);

                if (_skin)
                {
                    updateIcon(data.cost_type);
                    _skin.txtSellValue.text = data.cost.toString();
                    if (data.item_count > 1)
                    {
                        _skin.txtCount.text = data.item_count.toString();
                    } else
                    {
                        _skin.txtCount.text = "";
                    }
                }
            }
        }

        private function updateIcon(type:int):void
        {
            var costIcon:CostType = null;
            if (type == 1)
            {//金币
                costIcon = new CostType(ResIconType.TYPE_MONEY);
            } else if (type == 2)
            {//元宝
                costIcon = new CostType(ResIconType.TYPE_GOLD);
            }
            if (costIcon)
            {
                clearIcon();
                _skin.costContainer.addChild(costIcon);
            }
        }

        private function clearIcon():void
        {
            if (_skin.costContainer)
            {
                while (_skin.costContainer.numChildren > 0)
                {
                    _skin.costContainer.removeChildAt(0);
                }
            }
        }

        private function clearTips():void
        {
            if (_iconCell)
            {
                ToolTipManager.getInstance().detach(_iconCell);
            }
        }

        public function destroy():void
        {
            if (_skin)
            {
                clearTips();
                if (_skin.costContainer)
                {
                    clearIcon();
                }
                if (_iconCell)
                {
                    _iconCell.destroy();
                    _iconCell = null;
                }
                if (_thing)
                {
                    _thing = null;
                }
            }
        }
    }
}
