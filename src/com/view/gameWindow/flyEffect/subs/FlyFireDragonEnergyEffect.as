package com.view.gameWindow.flyEffect.subs
{
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.newMir.NewMirMediator;

    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2015/2/5.
     */
    public class FlyFireDragonEnergyEffect
    {
        private var _layer:Sprite;
        private const _size:int = 5;

        public function FlyFireDragonEnergyEffect(layer:Sprite)
        {
            this._layer = layer;

            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            var endPoint:Point = mc.localToGlobal(new Point(mc.ringUpBtn.x + (mc.ringUpBtn.width >> 1), mc.ringUpBtn.y));//结束点

            var mediator:NewMirMediator = NewMirMediator.getInstance();
            var center:Point;
            var remainHeight:Number = 0;
            var panX:Number = 0;
            var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG);
            if (panel && panel.isMouseOn())
            {
                if (layer.stage)
                {
                    center = new Point(layer.stage.mouseX, layer.stage.mouseY);
                } else
                {
                    center = new Point(panel.getPanelRect().width >> 1, panel.getPanelRect().height >> 1);
                }
            } else
            {
                center = new Point(mediator.width >> 1, mediator.height >> 1);//开始点
            }
            remainHeight = endPoint.y - center.y;

            var path:Array = [];
            path.push({x: center.x, y: center.y});

            panX = endPoint.x - center.x;
            if (Math.abs(panX) > 200)
            {
                panX = 200;
            }

            if (center.x > mediator.width * .5)
            {
                path.push({x: center.x - panX, y: center.y + (remainHeight >> 1) - 50});
            } else
            {
                path.push({x: center.x + panX, y: center.y + (remainHeight >> 1) - 50});
            }

            var during:Number = 1;
            for (var i:int = 0; i < _size; i++)
            {
                during += 0.2;
                var effect:SingleEffect = new SingleEffect(_layer, during, path, 1);
                effect.startPlay(center, endPoint);
            }
        }
    }
}

import com.greensock.TweenMax;
import com.model.consts.EffectConst;
import com.view.gameWindow.util.UIEffectLoader;

import flash.display.Sprite;
import flash.geom.Point;

class SingleEffect
{
    private var _layer:Sprite;
    private var _effectContainer:Sprite;
    private var _effect:UIEffectLoader;
    public var callBack:Function;
    private var _during:Number;
    private var _path:Array;
    private var _alpha:Number;

    public function SingleEffect(layer:Sprite, during:Number, path:Array, alpha:int)
    {
        _layer = layer;
        _during = during;
        _path = path;
        _alpha = alpha;
        _layer.addChild(_effectContainer = new Sprite());
    }

    public function startPlay(start:Point, end:Point):void
    {
        _effect = new UIEffectLoader(_effectContainer, 0, 0, .8, .8, EffectConst.RES_FIRE_DRAGON_STRENGTH);
        var dropFilter:Object = {color: 0xff0000, alpha: 1, blurX: 10, blurY: 20, distance: 20};
        if (_path)
        {
            TweenMax.fromTo(_effectContainer, _during, {
                x: start.x,
                y: start.y
            }, {
                x: end.x,
                y: end.y,
                alpha: _alpha,
                dropShadowFilter: dropFilter,
                bezierThrough: _path,
                orientToBezier: true,
                onComplete: onComplete
            });
        } else
        {
            TweenMax.to(_effectContainer, _during, {
                x: end.x,
                y: end.y,
                alpha: _alpha,
                dropShadowFilter: dropFilter,
                onComplete: onComplete
            });
        }
    }

    private function onComplete():void
    {
        if (callBack != null)
        {
            callBack();
        }
        if (_effectContainer)
        {
            TweenMax.killTweensOf(_effectContainer);
            if (_effectContainer.parent)
            {
                _layer.removeChild(_effectContainer);
                _effectContainer = null;
            }
        }
        if (_effect)
        {
            _effect.destroy();
            _effect = null;
        }
        if (callBack != null)
        {
            callBack = null;
        }
    }
}