package com.view.gameWindow.panel.panels.loginReward
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.util.LoaderCallBackAdapter;

    import flash.display.MovieClip;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2015/2/26.
     */
    public class PanelLoginReward extends PanelBase
    {
        private var _mouseHandler:LoginRewardMouseHandler;
        private var _viewHandler:LoginRewardViewHandler;
        private var _hightLight:HighlightEffectManager;
        public function PanelLoginReward()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McLoginReward();
            addChild(_skin);
            setTitleBar(_skin.dragBox);
            _hightLight = new HighlightEffectManager();
        }

        override protected function initData():void
        {
            _mouseHandler = new LoginRewardMouseHandler(this);
            _viewHandler = new LoginRewardViewHandler(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McLoginReward = _skin as McLoginReward;
            var adapt:LoaderCallBackAdapter = new LoaderCallBackAdapter();
            adapt.addCallBack(rsrLoader, function ():void
            {
                if (_viewHandler)
                {
                    _viewHandler.lockCanGetReward();
                }
            }, skin.btnLeft, skin.btnRight);

            rsrLoader.addCallBack(skin.btnGet, function (mc:MovieClip):void
            {
//                _hightLight.show(mc, mc);
            });
        }

        public function get mouseHandler():LoginRewardMouseHandler
        {
            return _mouseHandler;
        }

        public function get viewHandler():LoginRewardViewHandler
        {
            return _viewHandler;
        }

        override public function setPostion():void
        {
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnLogin.x + 15, mc.mcBtns.mcLayer.btnLogin.y + 15));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }
        override public function destroy():void
        {
            LoginRewardDataManager.currentPage = 1;
            LoginRewardDataManager.selectDay = 0;
            if (_hightLight)
            {
                _hightLight.hide(_skin.btnGet);
                _hightLight = null;
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
    }
}
