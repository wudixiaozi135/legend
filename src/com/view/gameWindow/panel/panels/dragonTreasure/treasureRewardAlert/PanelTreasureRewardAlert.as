package com.view.gameWindow.panel.panels.dragonTreasure.treasureRewardAlert
{
    import com.view.gameWindow.panel.panelbase.PanelBase;

    import flash.geom.Rectangle;

    /**
     * Created by Administrator on 2015/1/31.
     */
    public class PanelTreasureRewardAlert extends PanelBase
    {
        private var _mouseHandler:TreasureRewardAlertMouseHandler;
        private var _viewHandler:TreasureRewardAlertViewHandler;

        public function PanelTreasureRewardAlert()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McRewardAlert();
            addChild(_skin);
        }

        override protected function initData():void
        {
            _mouseHandler = new TreasureRewardAlertMouseHandler(this);
            _viewHandler = new TreasureRewardAlertViewHandler(this);
        }

        override public function getPanelRect():Rectangle
        {
            return new Rectangle(0, 0, _skin.mcBg.width, _skin.mcBg.height);
        }

        override public function destroy():void
        {
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
