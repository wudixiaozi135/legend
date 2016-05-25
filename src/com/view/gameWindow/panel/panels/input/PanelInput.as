package com.view.gameWindow.panel.panels.input
{
    import com.view.gameWindow.panel.panelbase.PanelBase;

    /**
     * Created by Administrator on 2014/12/15.
     */
    public class PanelInput extends PanelBase
    {
        private var _mouseHandler:InputMouseHandler;
        private var _viewHandler:InputViewHandler;

        public function PanelInput()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McInput();
            addChild(_skin);
            setTitleBar(_skin.mcTitleBar);
        }

        override protected function initData():void
        {
            _viewHandler = new InputViewHandler(this);
            _mouseHandler = new InputMouseHandler(this);
        }

        override public function destroy():void
        {
            if (_viewHandler != null)
            {
                _viewHandler.destroy();
                _viewHandler = null;
            }
            if (_mouseHandler != null)
            {
                _mouseHandler.destroy();
                _mouseHandler = null;
            }
            InputData.destroy();
            super.destroy();
        }
    }
}
