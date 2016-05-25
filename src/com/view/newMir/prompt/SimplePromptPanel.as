package com.view.newMir.prompt
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.prompt.McPanel2BtnPrompt;
    import com.view.gameWindow.util.Cover;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     * Created by Administrator on 2015/1/16.
     */
    public class SimplePromptPanel extends Sprite
    {
        public var clickHandler:Function;
        private var _mcPanelBtnPrompt:McPanel2BtnPrompt;
        private var _rect:Rectangle;
        private var _stage:Stage;
        private var _cover:Cover;

        public function SimplePromptPanel()
        {
            super();
            mouseEnabled = false;
            _cover = new Cover(0xff0000, 0);
            addChild(_cover);

            _mcPanelBtnPrompt = new McPanel2BtnPrompt();
            addChild(_mcPanelBtnPrompt);

            var rsrLoad:RsrLoader = new RsrLoader();
            rsrLoad.addCallBack(_mcPanelBtnPrompt.btnSure, function (mc:MovieClip):void
            {
                mc.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            });
            rsrLoad.load(_mcPanelBtnPrompt, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);

            _mcPanelBtnPrompt.txt.htmlText = "<p align='center'>" + PanelPromptData.txtContent + "</p>";
            _mcPanelBtnPrompt.sureTxt.text = PanelPromptData.txtBtn;
            _mcPanelBtnPrompt.sureTxt.mouseEnabled = false;

//            _mcPanelBtnPrompt.cancelTxt.text = StringConst.PROMPT_PANEL_0013;
            _mcPanelBtnPrompt.cancelTxt.mouseEnabled = false;
            _mcPanelBtnPrompt.cancelTxt.visible = false;
            _mcPanelBtnPrompt.btnCancel.visible = false;
            _mcPanelBtnPrompt.btnSure.x = (_mcPanelBtnPrompt.width - _mcPanelBtnPrompt.btnSure.width) >> 1;
            _mcPanelBtnPrompt.sureTxt.x = (_mcPanelBtnPrompt.width - _mcPanelBtnPrompt.sureTxt.width) >> 1;
            _rect = new Rectangle(0, 0, _mcPanelBtnPrompt.width, _mcPanelBtnPrompt.height);
        }

        private function onClick(event:MouseEvent):void
        {
            if (clickHandler != null)
            {
                clickHandler();
            }
            destroy();
        }

        public function init(stage:Stage):void
        {
            _stage = stage;
            stage.addChild(this);
            _stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
            onResize(null);
        }

        private function onResize(event:Event):void
        {
            x = int((stage.stageWidth - _rect.width) * .5);
            y = int((stage.stageHeight - _rect.height) * .5);
        }

        public function destroy():void
        {
            if (_mcPanelBtnPrompt && _mcPanelBtnPrompt.btnSure)
                _mcPanelBtnPrompt.btnSure.removeEventListener(MouseEvent.CLICK, onClick);
            if (clickHandler != null)
            {
                clickHandler = null;
            }
            if (_cover && contains(_cover))
            {
                removeChild(_cover);
                _cover = null;
            }

            if (_mcPanelBtnPrompt && contains(_mcPanelBtnPrompt))
            {
                removeChild(_mcPanelBtnPrompt);
                _mcPanelBtnPrompt = null;
            }

            if (_stage && _stage.contains(this))
            {
                _stage.removeChild(this);
                _stage.removeEventListener(Event.RESIZE, onResize);
            }
        }
    }
}
