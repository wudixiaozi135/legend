package com.view.gameWindow.mainUi.subuis.onlineReward
{
    import com.event.GameDispatcher;
    import com.event.GameEventConst;
    import com.greensock.TweenMax;
    import com.view.gameWindow.flyEffect.FlyEffectBase;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2015/3/7.
     */
    public class FlyOnlineShieldEffect extends FlyEffectBase
    {
        private var _type:int;

        public function FlyOnlineShieldEffect(layer:Sprite)
        {
            super(layer);
        }

        public function setData(type:int, bmp:Bitmap, start:Point, end:Point):void
        {
            _type = type;
            target = bmp;
            setStartPoint(start, end);
        }

        override public function fly():void
        {
            if (!target || !fromLct || !toLct)
            {
                return;
            }
            if (!target.parent)
            {
                layer.addChild(target);
            }
            TweenMax.fromTo(target, duration, {x: fromLct.x, y: fromLct.y}, {
                x: toLct.x,
                y: toLct.y,
                width: 26,
                height: 26,
                onComplete: onComplete
            });
        }

        /**开始位置*/
        public function setStartPoint(fPoint:Point, endPoint:Point):void
        {
            fromLct = fPoint;
            toLct = endPoint;
            fly();
        }

        override protected function onComplete():void
        {
            if (_type == 1)
            {//须激活
                GameDispatcher.dispatchEvent(GameEventConst.THING_INTO_BAG_EFFECT, {type: 7});//进背包不闪特效
            } else if (_type == 2)
            {
                GameDispatcher.dispatchEvent(GameEventConst.THING_INTO_BAG_EFFECT, {type: 11});//进背包不闪特效
            }
            if (target)
                TweenMax.killTweensOf(target);
            super.onComplete();
        }
    }
}
