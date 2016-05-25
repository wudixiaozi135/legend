package com.view.gameWindow.panel.panels.stall.otherstall
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.ConstStorage;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.McOtherStall;
    import com.view.gameWindow.panel.panels.McStallItem;
    import com.view.gameWindow.panel.panels.bag.cell.BagCell;
    import com.view.gameWindow.panel.panels.stall.*;
    import com.view.gameWindow.panel.panels.stall.data.StallDataInfo;
    import com.view.gameWindow.panel.panels.stall.item.StallOtherItem;

    import flash.display.MovieClip;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallOtherViewHandler implements IObserver
    {
        private var _panel:PanelOtherStall;
        private var _skin:McOtherStall;
        private var _items:Vector.<McStallItem>;

        public function StallOtherViewHandler(panel:PanelOtherStall)
        {
            _panel = panel;
            _skin = _panel.skin as McOtherStall;
            StallDataManager.instance.attach(this);
        }

        public function initData():void
        {
            var i:int = 0;
            var bagCell:BagCell, stallItem:McStallItem;
            _items = new Vector.<McStallItem>();

            for (i = 0; i < StallDataManager.STALL_MAX_COUNT; i++)
            {
                var item:McStallItem = new StallOtherItem();
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
            _skin.txtName.text = StringUtil.substitute(StringConst.STALL_PANEL_0001, StallDataManager.instance.other_Name);
            _skin.txtDesc.mouseEnabled = false;
            _skin.txtDesc.textColor = 0xd4a460;
            _skin.txtDesc.text = StringConst.STALL_PANEL_0041;
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
            var data:Vector.<StallDataInfo> = StallDataManager.instance.otherInfos;
            if (data && data.length)
            {
                initVisible();
                var info:StallDataInfo, itemStall:StallOtherItem;
                for (var i:int = 0, len:int = data.length; i < len; i++)
                {
                    if (i < _items.length)
                    {
                        itemStall = _items[i] as StallOtherItem;
                        itemStall.refreshData(data[i]);
                        itemStall.visible = true;
                    }
                }
            } else
            {
                StallDataManager.instance.closeOtherStallPanel();
            }
        }

        public function update(proc:int = 0):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_QUERY_OTHER_SELL:
                    refresh();
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
