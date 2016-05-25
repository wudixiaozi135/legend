package com.view.gameWindow.panel.panels.levelReward
{
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.newMir.NewMirMediator;

    import flash.display.MovieClip;
    import flash.geom.Rectangle;

    /**
     * Created by Administrator on 2014/12/8.
     */
    public class PanelLevelReward extends PanelBase
    {
        private var _viewHandler:LevelRewardViewHandler;
        private var _mouseHandler:LevelRewardMouseHandler;
        private var _btnHightLight:HighlightEffectManager;
        public function PanelLevelReward()
        {
            super();
            LevelRewardDataManager.instance.attach(this);
            RoleDataManager.instance.attach(this);
        }

        override protected function initSkin():void
        {
            _skin = new McLevelReward();
            addChild(_skin);
            _btnHightLight = new HighlightEffectManager();
        }

        override protected function initData():void
        {
            _viewHandler = new LevelRewardViewHandler(this);
            _mouseHandler = new LevelRewardMouseHandler(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McLevelReward = _skin as McLevelReward;
			
			rsrLoader.addCallBack(skin.mcBtn,function(mc:MovieClip):void{
				InterObjCollector.instance.add(mc);
                _btnHightLight.show(mc, mc);
            });
        }

        public function get viewHandler():LevelRewardViewHandler
        {
            return _viewHandler;
        }

        public function get mouseHandler():LevelRewardMouseHandler
        {
            return _mouseHandler;
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

        override public function update(proc:int = 0):void
        {
            switch (proc)
            {
                default :
                    break;
                case GameServiceConstants.SM_CHR_INFO:
                case GameServiceConstants.SM_LEVEL_GIFT_INFO:
                    handlerEffect();
                    break;
            }
        }

        private function handlerEffect():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int((newMirMediator.width - rect.width));
            var newY:int = int((newMirMediator.height - rect.height - 100));
            TweenMax.fromTo(this, 2, {}, {
                x: newX, y: newY, onComplete: function ():void
                {
                    TweenLite.killTweensOf(this);
                }
            });
        }

        override public function destroy():void
        {
            LevelRewardDataManager.instance.detach(this);
            RoleDataManager.instance.detach(this);
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
            if (_skin)
            {
                if (_btnHightLight)
                {
                    _btnHightLight.hide(_skin.mcBtn);
                    _btnHightLight = null;
                }
            }
			InterObjCollector.instance.remove(_skin.mcBtn);
			
            super.destroy();
        }
    }
}
