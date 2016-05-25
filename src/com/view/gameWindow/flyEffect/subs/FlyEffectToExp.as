package com.view.gameWindow.flyEffect.subs
{
    import com.greensock.TweenMax;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.EffectConst;
    import com.view.gameWindow.flyEffect.FlyEffectBase;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UrlPic;
    
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2015/1/28.
     */
    public class FlyEffectToExp extends FlyEffectBase
    {
        private var urlPic:UrlPic;
        private var _downEffect:UIEffectLoader;
        private var _upEffect:UIEffectLoader;
        private var _topContainer:Sprite;
		private var _complete:Function;
		
        public function FlyEffectToExp(layer:Sprite,complete:Function = null)
        {
            super(layer);
            layer.addChild(_topContainer = new Sprite());
			_complete = complete;
        }

        private function initialize():void
        {
            var bm:Sprite = new Sprite();
            target = bm;
            urlPic = new UrlPic(bm, function ():void
            {

                var bottomBar:BottomBar = MainUiMediator.getInstance().bottomBar as BottomBar;
                if (!bottomBar)
                {
                    return;
                }
                duration = 2;
                fly();
            });
            urlPic.load(ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + "jyy1" + ResourcePathConstants.POSTFIX_PNG);
        }

        override public function fly():void
        {
            if (!target || !fromLct || !toLct)
            {
                return;
            }
            if (!target.parent)
            {
                _upEffect = new UIEffectLoader(_topContainer, fromLct.x-6, fromLct.y+18, 1, 1, EffectConst.RES_BAG_UP, null, true);
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
            initialize();
        }

        private function destroyEffectContainer():void
        {
            if (_topContainer && layer.contains(_topContainer))
            {
                layer.removeChild(_topContainer);
            }
            if (_upEffect)
            {
                _upEffect.destroyEffect();
                _upEffect = null;
            }
            if (_downEffect)
            {
                _downEffect.destroyEffect();
                _downEffect = null;
            }
        }

        override protected function onComplete():void
        {
//            GameDispatcher.dispatchEvent(GameEventConst.THING_INTO_BAG_EFFECT, {type: 2});
            if (target)
                TweenMax.killTweensOf(target);
            if (urlPic)
            {
                urlPic.destroy();
            }
            destroyEffectContainer();
            super.onComplete();
			
			if(_complete != null)
			{
				_complete();
				_complete = null;
			}
        }
    }
}
