package com.view.gameWindow.panel.panels.stall.log
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.McStallLog;
    import com.view.gameWindow.panel.panels.stall.StallDataManager;
    import com.view.gameWindow.panel.panels.stall.data.StallLogData;
    import com.view.gameWindow.panel.panels.stall.item.LogRow;
    import com.view.gameWindow.util.scrollBar.IScrollee;
    import com.view.gameWindow.util.scrollBar.ScrollBar;

    import flash.display.MovieClip;
    import flash.geom.Rectangle;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallLogViewHandler implements IScrollee,IObserver
    {
        private var _panel:PanelStallLog;
        private var _skin:McStallLog;
        private var _scrollBar:ScrollBar;
        private var _scrollRect:Rectangle;
        private var _contentHeight:int;
        private var _litterPool:Vector.<LogRow> = new Vector.<LogRow>();
        public function StallLogViewHandler(panel:PanelStallLog)
        {
            _panel = panel;
            _skin = _panel.skin as McStallLog;
            init();
            StallDataManager.instance.attach(this);
        }

        private function init():void
        {
            _skin.txtName.mouseEnabled = false;
            _skin.txtName.text = StringConst.STALL_PANEL_0002;

            _scrollRect = new Rectangle(0, 0, 350, 435);
        }

        public function refresh():void
        {
            clearData();
            var data:Vector.<StallLogData> = StallDataManager.instance.logInfos;
            var totalHeight:int = 0;
            for (var i:int = 0, len:int = data.length; i < len; i++)
            {
                var info:StallLogData = data[i];
                var row:LogRow = new LogRow();
                _skin.container.addChild(row);
                row.data = info;
                row.y = row.height * i;
                _litterPool.push(row);
                totalHeight += row.height;
            }
            _contentHeight = totalHeight;
            refreshScroll();
        }

        private function clearData():void
        {
            if (_litterPool)
            {
                if (_skin && _skin.container)
                {
                    _litterPool.forEach(function (element:LogRow, index:int, vec:Vector.<LogRow>):void
                    {
                        element.destroy();
                        if (_skin.container.contains(element))
                        {
                            _skin.container.removeChild(element);
                            element = null;
                        }
                    });
                    _litterPool.length = 0;
                }
            }
        }
        
        public function refreshScroll():void
        {
            if (_scrollBar)
            {
                _scrollBar.resetScroll();
            }
        }

        public function initScroll(mc:MovieClip):void
        {
            _scrollBar = new ScrollBar(this, mc, 0, _skin.container, 10);
            _scrollBar.resetHeight(_scrollRect.height);
            refreshScroll();
        }

        public function scrollTo(pos:int):void
        {
            _scrollRect.y = pos;
            _skin.container.scrollRect = _scrollRect;
        }

        public function get contentHeight():int
        {
            return _contentHeight;
        }

        public function get scrollRectHeight():int
        {
            return _scrollRect.height;
        }

        public function get scrollRectY():int
        {
            return _scrollRect.y;
        }

        public function destroy():void
        {
            StallDataManager.instance.detach(this);
            clearData();
            if (_litterPool)
            {
                _litterPool = null;
            }
            if (_scrollBar)
            {
                _scrollBar.destroy();
                _scrollBar = null;
            }
            if (_scrollRect)
            {
                _scrollRect = null;
            }
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_SELL_MSG_INFORMATION)
            {
                refresh();
            }
        }
    }
}
