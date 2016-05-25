package com.view.gameWindow.panel.panels.stall
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.McStallPanel;
    import com.view.gameWindow.util.LoaderCallBackAdapter;

    import flash.display.MovieClip;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class PanelStall extends PanelBase
    {
        private var _mouseHandler:StallMouseHandler;
        private var _viewHandler:StallViewHandler;

        public function PanelStall()
        {
            super();
        }


        override protected function initSkin():void
        {
            _skin = new McStallPanel();
            addChild(_skin);
            setTitleBar(_skin.dragBox);
        }

        override protected function initData():void
        {
            _viewHandler = new StallViewHandler(this);
            _mouseHandler = new StallMouseHandler(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McStallPanel = _skin as McStallPanel;
            var bgs:Array = [];
            for (var i:int = 0; i < 12; i++)
            {
                var bg:MovieClip = _skin["itemBg" + i];
                bg.mouseEnabled = false;
                bgs.push(bg);
            }
            var load:LoaderCallBackAdapter = new LoaderCallBackAdapter();
            load.addCallBack(rsrLoader, function ():void
            {
                if (_viewHandler)
                {
                    _viewHandler.initData();
                }
                load = null;
            }, bgs);
        }

        override public function setPostion():void
        {
            isMount(true);
        }

        public function checkValidArea():Boolean
        {
            if (!_skin)
            {
                return false;
            }
            var mx:Number = mouseX * scaleX;//返回相对图像的起始点位置
            var my:Number = mouseY * scaleY;
            var result:Boolean = mx > 25 && mx <= (343 + 25) && my > 56 && my <= (358 + 56);
            return result;
        }

        override public function destroy():void
        {
            StallDataManager.instance.clearData();
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
            super.destroy();
        }
    }
}
