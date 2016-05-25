package com.view.gameWindow.panel.panels.forge.strengthen
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.EffectConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
    import com.view.gameWindow.panel.panels.forge.McIntensify;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.Sprite;

    /**
     * Created by Administrator on 2015/2/4.
     */
    public class PolishSuccessHandler implements IObserver
    {
        private var _effectLoader:UIEffectLoader;
        private var _tab:TabStrengthen;
        private var _skin:McIntensify;
        private var _effectContainer:Sprite;

        public function PolishSuccessHandler(tab:TabStrengthen)
        {
            _tab = tab;
            _skin = _tab.skin as McIntensify;
            _effectContainer = new Sprite();
            _tab.addChild(_effectContainer);
            _effectContainer.x = 290;
            _effectContainer.y = -18;
            _effectContainer.mouseEnabled = false;

            ForgeDataManager.instance.attach(this);
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.CM_EQUIP_POLISH)
            {
//                handlerEffect();
            }
        }

        private function handlerEffect():void
        {
            if (_effectLoader)
            {
                _effectLoader.destroy();
                _effectLoader = null;
            }
            var code:int = ForgeDataManager.instance.isPolishSuccess;
            if (code)
            {
                _effectLoader = new UIEffectLoader(_effectContainer, 0, 0, 1, 1, EffectConst.RES_STRENGTH_SUCCESS, null, true);
            } else
            {
                _effectLoader = new UIEffectLoader(_effectContainer, 0, 0, 1, 1, EffectConst.RES_STRENGTH_FAILE, null, true);
            }
        }

        public function destroy():void
        {
            if (_effectLoader)
            {
                _effectLoader.destroy();
                _effectLoader = null;
            }
            if (_effectContainer && _effectContainer.parent)
            {
                _tab.removeChild(_effectContainer);
                _effectContainer = null;
            }
        }
    }
}
