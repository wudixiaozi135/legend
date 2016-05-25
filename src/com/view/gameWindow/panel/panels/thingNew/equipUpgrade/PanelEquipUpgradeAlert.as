package com.view.gameWindow.panel.panels.thingNew.equipUpgrade
{
    import com.greensock.TweenMax;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.newMir.NewMirMediator;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
     * Created by Administrator on 2015/1/30.
     * 装备进阶提示
     */
    public class PanelEquipUpgradeAlert extends PanelBase
    {
        private var _mouseHandler:EquipUpgradeMouseHandler;
        private var _viewHandler:EquipUpgradeViewHandler;
        private var _timeId:int = 0;
        private var _delay:int = 50000;
        private var _btnLight:HighlightEffectManager;
        public function PanelEquipUpgradeAlert()
        {
            super();
            _btnLight = new HighlightEffectManager();
            addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);
            _timeId = setTimeout(function ():void
            {
                closeHandler();
            }, _delay);
        }


        override protected function initSkin():void
        {
            _skin = new McEquipAlert();
            addChild(_skin);
            setTitleBar(_skin.mcDrag);
            _skin.btnDo.x = (_skin.width - _skin.btnDo.width) >> 1;
            handlerEffect();
        }

        override protected function initData():void
        {
            _mouseHandler = new EquipUpgradeMouseHandler(this);
            _viewHandler = new EquipUpgradeViewHandler(this);
        }

        override public function setPostion():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int((newMirMediator.width - rect.width));
            var newY:int = int((newMirMediator.height + rect.height - 10));
            x != newX ? x = newX : null;
            y != newY ? y = newY : null;
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McEquipAlert = _skin as McEquipAlert;
            rsrLoader.addCallBack(skin.btnDo, function (mc:MovieClip):void
            {
                _btnLight.show(mc, mc);
            });
        }

        override public function resetPosInParent():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int(newMirMediator.width - rect.width) - 50;
            var newY:int = int(newMirMediator.height - rect.height) - 100;
            x = newX;
            y = newY;
        }

        private function handlerEffect():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int(newMirMediator.width - rect.width) - 50;
            var newY:int = int(newMirMediator.height - rect.height) - 100;

            TweenMax.fromTo(this, 2, {alpha: 0}, {
                x: newX, y: newY, alpha: 1, onComplete: function ():void
                {
                    TweenMax.killTweensOf(this);
                }
            });
        }

        public function closeHandler():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int(newMirMediator.width + rect.width);

            clearTimeout(_timeId);

            alpha = 1;
            TweenMax.to(this, 3, {
                x: newX, alpha: 0, onComplete: function ():void
                {
                    TweenMax.killTweensOf(this);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_UPGRADE_ALERT);
                }
            });
        }

        override public function destroy():void
        {
            if (_btnLight)
            {
                if (_skin)
                {
                    _btnLight.hide(_skin.btnDo);
                }
                _btnLight = null;
            }
            if (_viewHandler)
            {
                _viewHandler.destroy();
                _viewHandler = null;
            }
            if (_mouseHandler)
            {
                _mouseHandler.destroy();
                _mouseHandler = null;
            }
            super.destroy();
        }

        private function onRemove(event:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
            EquipUpgradeDataManager.instance.isFlying = false;
        }
    }
}
