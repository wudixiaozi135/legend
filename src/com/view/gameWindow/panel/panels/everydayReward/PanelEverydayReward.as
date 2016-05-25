package com.view.gameWindow.panel.panels.everydayReward
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.panelbase.PanelBase;

    import flash.display.MovieClip;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2015/2/28.
     */
    public class PanelEverydayReward extends PanelBase
    {
        private var _viewHandler:EverydayRewardViewHandler;
        private var _mouseHandler:EverydayRewardMouseHandler;
        private var _hight:HighlightEffectManager;
        public function PanelEverydayReward()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McEveryReward();
            addChild(_skin);
            setTitleBar(_skin.dragBox);
            _hight = new HighlightEffectManager();
        }

        override protected function initData():void
        {
            _mouseHandler = new EverydayRewardMouseHandler(this);
            _viewHandler = new EverydayRewardViewHandler(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McEveryReward = _skin as McEveryReward;
            rsrLoader.addCallBack(skin.btnGet, function (mc:MovieClip):void
            {
//                _hight.show(mc, mc);
            });
        }

        override public function destroy():void
        {
            EveryDayRewardDataManager.selectRewardIndex = -1;
            if (_hight)
            {
                _hight.hide(_skin.btnGet);
                _hight = null;
            }
            if (_mouseHandler)
            {
                _mouseHandler.destroy();
                _mouseHandler = null;
            }
            if (_viewHandler)
            {
                _viewHandler.destroy();
                _viewHandler = null;
            }
            super.destroy();
        }

        override public function setPostion():void
        {
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnEveryDay.x + 15, mc.mcBtns.mcLayer.btnEveryDay.y + 15));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }
        public function get viewHandler():EverydayRewardViewHandler
        {
            return _viewHandler;
        }

        public function get mouseHandler():EverydayRewardMouseHandler
        {
            return _mouseHandler;
        }
    }
}
