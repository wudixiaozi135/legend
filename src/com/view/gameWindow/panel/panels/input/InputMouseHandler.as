package com.view.gameWindow.panel.panels.input
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
     * Created by Administrator on 2014/12/15.
     */
    public class InputMouseHandler
    {
        private var _panel:PanelInput;
        private var _skin:McInput;

        public function InputMouseHandler(panel:PanelInput)
        {
            _panel = panel;
            _skin = _panel.skin as McInput;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            _skin.txtInput.addEventListener(Event.CHANGE, onChange, false, 0, true);
        }

        private function onChange(event:Event):void
        {
            if (InputData.warnFunc != null)
            {
                var bool:Boolean = InputData.warnFunc(_skin.txtInput.text) as Boolean;
                _skin.txtWarn.visible = bool;
            } else
            {
                _skin.txtWarn.visible = false;
            }
			if (InputData.isNumber)
			{
				if (parseInt(_skin.txtInput.text) > InputData.maxValue)
				{
					_skin.txtInput.text = InputData.maxValue.toString();
				}
			}
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.btnOk:
                    okHandler();
                    break;
                case _skin.btnCancel:
                    cancelHandler();
                    break;
                default :
                    break;
            }
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_INPUT);
        }

        private function okHandler():void
        {
            if (InputData.btnOkFunc != null)
            {
                if (_skin.txtInput.text != null)
                {
                    InputData.btnOkFunc(_skin.txtInput.text);
                }
            }
            closeHandler();
        }

        private function cancelHandler():void
        {
            if (InputData.btnCancelFunc != null)
            {
                if (InputData.btnCancelFuncParam != null)
                {
                    InputData.btnCancelFunc(InputData.btnCancelFuncParam);
                } else
                {
                    InputData.btnCancelFunc();
                }
            }
            closeHandler();
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
                _skin.txtInput.removeEventListener(Event.CHANGE, onChange);
            }
        }
    }
}
