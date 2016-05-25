package com.view.gameWindow.panel.panels.input
{
    import com.model.consts.StringConst;

    /**
     * Created by Administrator on 2014/12/15.
     */
    public class InputViewHandler
    {
        private var _panel:PanelInput;
        private var _skin:McInput;

        public function InputViewHandler(panel:PanelInput)
        {
            _panel = panel;
            _skin = _panel.skin as McInput;

            initialize();
        }

        private function initialize():void
        {
            _skin.txtName.mouseEnabled = false;
            _skin.txtName.textColor = 0xd4a460;
            if (InputData.title)
            {
                _skin.txtName.text = InputData.title;
            } else
            {
                _skin.txtName.text = StringConst.PROMPT_PANEL_0035;
            }

            _skin.txtContent.mouseEnabled = false;
            _skin.txtContent.textColor = 0xd4a460;
            if (InputData.content)
            {
                _skin.txtContent.htmlText = InputData.content;
            } else
            {
                _skin.txtContent.htmlText = "";
            }

            _skin.txtOk.mouseEnabled = false;
            _skin.txtOk.textColor = 0xffe1aa;
            if (InputData.btnTxt1)
            {
                _skin.txtOk.text = InputData.btnTxt1;
            } else
            {
                _skin.txtOk.text = InputData.btnTxt1;
            }

            _skin.txtCancel.mouseEnabled = false;
            _skin.txtCancel.textColor = 0xffe1aa;
            if (InputData.btnTxt2)
            {
                _skin.txtCancel.text = InputData.btnTxt2;
            } else
            {
                _skin.txtCancel.text = InputData.btnTxt2;
            }

            _skin.txtInput.textColor = 0xffffff;
            if (InputData.isNumber)
            {
                _skin.txtInput.restrict = "0-9";
            } else
            {
                _skin.txtInput.restrict = null;
            }
            _skin.txtWarn.mouseEnabled = false;
            _skin.txtWarn.textColor = 0xff0000;
            _skin.txtWarn.visible = false;
            if (InputData.warn != null)
            {
                _skin.txtWarn.htmlText = InputData.warn;
            }
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
