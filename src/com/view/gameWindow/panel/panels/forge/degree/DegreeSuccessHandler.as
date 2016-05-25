package com.view.gameWindow.panel.panels.forge.degree
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.EffectConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.Sprite;

    /**
     * Created by Administrator on 2015/2/4.
     */
    public class DegreeSuccessHandler implements IObserver
    {
        private var _tab:TabDegree;
        private var _effectContainer:Sprite;
        private var _effectLoader:UIEffectLoader;

        public function DegreeSuccessHandler(tab:TabDegree)
        {
            _tab = tab;
            _tab.addChild(_effectContainer = new Sprite());
            _effectContainer.x = 285;
            _effectContainer.y = -18;

            ForgeDataManager.instance.attach(this);
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.CM_EQUIP_UPGRADE)
            {
                handlerEffect();
            }
        }

        private function handlerEffect():void
        {
            _effectLoader = new UIEffectLoader(_effectContainer, 0, 0, 1, 1, EffectConst.RES_STRENGTH_SUCCESS, null, true);
        }

        public function destroy():void
        {
            ForgeDataManager.instance.detach(this);
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
