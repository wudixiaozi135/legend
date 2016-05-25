package com.view.gameWindow.panel.panels.stall
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.ConstStorage;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.McStallItem;
    import com.view.gameWindow.panel.panels.McStallPanel;
    import com.view.gameWindow.panel.panels.bag.cell.BagCell;
    import com.view.gameWindow.panel.panels.stall.data.StallDataInfo;
    import com.view.gameWindow.panel.panels.stall.item.StallItem;

    import flash.display.MovieClip;
    import flash.utils.getTimer;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallViewHandler implements IObserver
    {
        private var _panel:PanelStall;
        private var _skin:McStallPanel;
        private var _items:Vector.<McStallItem>;
        private var _currentTime:uint = getTimer();
        public function StallViewHandler(panel:PanelStall)
        {
            _panel = panel;
            _skin = _panel.skin as McStallPanel;
            StallDataManager.instance.attach(this);
        }

        public function initData():void
        {
            var i:int = 0;
            var bagCell:BagCell, stallItem:McStallItem;
            _items = new Vector.<McStallItem>();

            for (i = 0; i < StallDataManager.STALL_MAX_COUNT; i++)
            {
                var item:McStallItem = new StallItem();
                item.storageType = ConstStorage.ST_STALL_SELF_BAG;
                _items.push(item);
                item.txtPrice.textColor = 0xd4a460;
                item.txtPrice.text = StringConst.STALL_PANEL_0009;

                var bg:MovieClip = _skin["itemBg" + i];
                bg.mouseEnabled = false;
                bg.addChild(item);
                item.x = item.y = 11;
            }

            initTxt();
            refresh();
        }

        private function initTxt():void
        {
            _skin.txtName.mouseEnabled = false;
            _skin.txtName.text = StringUtil.substitute(StringConst.STALL_PANEL_0001, StringConst.STALL_PANEL_0020);

            _skin.txtDesc.mouseEnabled = false;
            _skin.txtDesc.textColor = 0xd4a460;
            _skin.txtDesc.text = StringConst.STALL_PANEL_0014;

            _skin.txtLog.textColor = 0xd4a460;
            _skin.txtLog.mouseEnabled = false;
            _skin.txtLog.text = StringConst.STALL_PANEL_0003;

            _skin.txtStall.textColor = 0xd4a460;
            _skin.txtStall.mouseEnabled = false;
            _skin.txtStall.text = StringConst.STALL_PANEL_0004;
        }

        private function initVisible():void
        {
            if (_items)
            {
                _items.forEach(function (element:McStallItem, index:int, vec:Vector.<McStallItem>):void
                {
                    element.visible = false;
                });
            }
        }

        public function refresh():void
        {
            var data:Vector.<StallDataInfo> = StallDataManager.instance.selfInfos;
            initVisible();
            if (data && data.length)
            {
                var info:StallDataInfo, itemStall:StallItem;
                for (var i:int = 0, len:int = data.length; i < len; i++)
                {
                    if (i < _items.length)
                    {
                        itemStall = _items[i] as StallItem;
                        itemStall.refreshData(data[i]);
                        itemStall.visible = true;
                    }
                }
            } else
            {
                _skin.txtStall.text = StringConst.STALL_PANEL_0004;
                _skin.txtDesc.text = StringConst.STALL_PANEL_0014;
            }
        }

        private function upgradeTxt():void
        {
            if (_skin)
            {
                _skin.txtStall.text = StringConst.STALL_PANEL_0022;
                _skin.txtDesc.text = StringConst.STALL_PANEL_0025;
            }
        }

        public function update(proc:int = 0):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_SELL_THING_INFOR:
                    refresh();
                    break;
                case GameServiceConstants.CM_CREATE_SELL:
                    upgradeTxt();
                    break;
                default :
                    break;
            }
        }

        public function destroy():void
        {
            StallDataManager.instance.detach(this);
        }
    }
}
