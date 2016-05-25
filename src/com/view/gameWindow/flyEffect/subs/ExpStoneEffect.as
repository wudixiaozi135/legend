package com.view.gameWindow.flyEffect.subs
{
    import com.event.GameDispatcher;
    import com.event.GameEventConst;
    import com.greensock.TweenMax;
    import com.model.consts.EffectConst;
    import com.view.gameWindow.flyEffect.FlyEffectBase;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Created by Administrator on 2015/3/11.
     */
    public class ExpStoneEffect extends FlyEffectBase
    {
        private var _layer:Sprite;
        private var _ballExp:UIEffectLoader;
        private var _ballExpContainer:Sprite;

        public function ExpStoneEffect(layer:Sprite)
        {
            super(layer);
            this._layer = layer;
            _layer.addChild(_ballExpContainer = new Sprite());
            _ballExp = new UIEffectLoader(_ballExpContainer, 0, 0, 1, 1, EffectConst.RES_EXP_BALL, fly);
            target = _ballExpContainer;
        }

        public function setStartPoint(startP:Point):void
        {
            _ballExpContainer.x = startP.x;
            _ballExpContainer.y = startP.y;
            fromLct = startP;
            toLct = new Point(100, 500);
            duration = 1;
        }

        override public function fly():void
        {
            tweenFly();
        }

        public function tweenFly():void
        {
            var rect:Rectangle = MainUiMediator.getInstance().bottomBar.getCurrentExpRect();
            var endX:Number = rect.x + rect.width;
            var endY:Number = rect.y + rect.height;
            TweenMax.to(_ballExpContainer, duration, {
                x: endX,
                y: endY,
                scaleX: 0.6,
                scaleY: 0.6,
//                onUpdate: onUpdateHandler,
                onComplete: onComplete
            });
        }

        private function onUpdateHandler():void
        {
            TweenMax.killTweensOf(_ballExpContainer);
            duration -= 0.02;
            tweenFly();
        }

        override protected function onComplete():void
        {
            if (target)
            {
                TweenMax.killTweensOf(target);
                if (target.parent)
                {
                    _layer.removeChild(target);
                    target = null;
                }
            }
            if (_ballExpContainer && _ballExpContainer.parent)
            {
                _ballExpContainer.parent.removeChild(_ballExpContainer);
                _ballExpContainer = null;
            }
            if (_ballExp)
            {
                _ballExp.destroy();
                _ballExp = null;
            }
            GameDispatcher.dispatchEvent(GameEventConst.EXP_INTO_BOTTOM);
        }
    }
}
