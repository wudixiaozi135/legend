package com.view.gameWindow.panel.panels.charge
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.util.LoaderCallBackAdapter;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Created by Administrator on 2015/2/11.
     */
    public class PanelCharge extends PanelBase
    {

        private var _mouseHandler:ChargeMouseHandler;
        private var _viewHandler:ChargeViewHandler;

        public function PanelCharge()
        {
            super();
            ChargeDataManager.instance.attach(this);
            BagDataManager.instance.attach(this);
        }

        override protected function initSkin():void
        {
            _skin = new McCharge();
            addChild(_skin);
            setTitleBar(_skin.dragBox);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McCharge = _skin as McCharge;
            var adapt:LoaderCallBackAdapter = new LoaderCallBackAdapter();
            adapt.addCallBack(rsrLoader, function ():void
            {
                if (_viewHandler)
                {
                    _viewHandler.refresh();
                }
                adapt = null;
            }, skin.btnGet, skin.btnPlay);
        }

        override protected function initData():void
        {
            _mouseHandler = new ChargeMouseHandler(this);
            _viewHandler = new ChargeViewHandler(this);
        }

        override public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_FIRST_PAY_REWARD_GET)
            {
                if (_viewHandler)
                {
                    _viewHandler.refresh();
                }
            } else if (proc == GameServiceConstants.CM_FIRST_PAY_REWARD_GET)
            {
                if (_viewHandler)
                {
                    FlyEffectMediator.instance.doFlyReceiveThings2(_viewHandler.getBitmaps());
                    PanelMediator.instance.closePanel(PanelConst.TYPE_CHARGE_PANEL);
                }
            } else if (proc == GameServiceConstants.SM_BAG_ITEMS)
            {
                if (_viewHandler)
                {
                    _viewHandler.refresh();
                }
            }
        }

        override public function setPostion():void
        {
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnCharge.x + 15, mc.mcBtns.mcLayer.btnCharge.y + 15));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }


        override public function getPanelRect():Rectangle
        {
            return new Rectangle(0, 0, 745, 453);//为背景图片的大小，不包括武器特效
        }

        override public function destroy():void
        {
            ChargeDataManager.instance.detach(this);
            BagDataManager.instance.detach(this);
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
