package com.view.gameWindow.panel.panels.stall.stallSell
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.McStallSell;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.stall.StallDataManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallSellViewHandler implements IObserver
    {
        private var _panel:PanelStallSell;
        private var _skin:McStallSell;
        private var _cellEx:IconCellEx;
        private var _thing:ThingsData;

        public function StallSellViewHandler(panel:PanelStallSell)
        {
            _panel = panel;
            _skin = _panel.skin as McStallSell;

            _cellEx = new IconCellEx(_skin.mcIcon, 0, 0, _skin.mcIcon.width, _skin.mcIcon.height);
            _skin.mcIcon.mouseEnabled = false;
            _thing = new ThingsData();
            init();
            StallDataManager.instance.attach(this);
        }

        private function init():void
        {
            _skin.txtName.mouseEnabled = false;
            _skin.txtName.text = StringConst.STALL_PANEL_0005;

            _skin.radioBtn1Txt.textColor = 0xd4a460;
            _skin.radioBtn1Txt.text = StringConst.STALL_PANEL_0006;
            _skin.radioBtn1Txt.mouseEnabled = false;

            _skin.radioBtn2Txt.textColor = 0xd4a460;
            _skin.radioBtn2Txt.text = StringConst.STALL_PANEL_0007;
            _skin.radioBtn2Txt.mouseEnabled = false;

            _skin.txtBtn.mouseEnabled = false;
            _skin.txtBtn.textColor = 0xffe1aa;
            _skin.txtBtn.text = StringConst.STALL_PANEL_0008;

            _skin.txtInput.textColor = 0xffcc00;
            _skin.txtInput.restrict = "0-9";
            _skin.txtCount.mouseEnabled = false;
            _skin.txtCount.textColor = 0xffffff;
            refresh();
        }

        public function refresh():void
        {
            var data:BagData = StallSellDataManager.bagData;
            if (data)
            {
                _thing.id = data.id;
                _thing.bornSid = data.bornSid;
                _thing.type = data.type;
                if (data.type == SlotType.IT_ITEM)
                {
                    IconCellEx.setItemByThingsData(_cellEx, _thing);
                } else if (data.type == SlotType.IT_EQUIP)
                {
                    IconCellEx.setItemByThingsData(_cellEx, _thing);
                }
                if (data.count > 1)
                {
                    _skin.txtCount.text = data.count.toString();
                } else
                {
                    _skin.txtCount.text = "";
                }
                ToolTipManager.getInstance().attach(_cellEx);
            }
        }

        private function destroyTips():void
        {
            if (_cellEx)
            {
                ToolTipManager.getInstance().detach(_cellEx);
            }
        }

        public function update(proc:int = 0):void
        {
            switch (proc)
            {
                case GameServiceConstants.CM_SELL_THING_MOVE:
                    closeHandler();
                    break;
                default :
                    break;
            }
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_SELL);
        }

        public function destroy():void
        {
            StallDataManager.instance.detach(this);
            if (_skin)
            {
                destroyTips();
            }
            if (_cellEx)
            {
                _cellEx.destroy();
                _cellEx = null;
            }
            if (_thing)
            {
                _thing = null;
            }
        }
    }
}
