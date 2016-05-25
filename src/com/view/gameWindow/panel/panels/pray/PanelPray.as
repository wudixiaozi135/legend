package com.view.gameWindow.panel.panels.pray
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.EffectConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.pray.constants.PrayType;
    import com.view.gameWindow.util.UIEffectLoader;
    
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
	 * Created by Administrator on 2014/11/25.
	 */
	public class PanelPray extends PanelBase
	{
        //特效
        private var _normalCoinEffect:UIEffectLoader;
        private var _normalTicketEffect:UIEffectLoader;

        private var _coinEffect:UIEffectLoader;
        private var _ticketEffect:UIEffectLoader;
        private var _effectContainer:Sprite;
		public function PanelPray()
		{
			super();
			PrayDataManager.instance.attach(this);
		}

		private var _mouseHandler:PrayMouseHandler;

		public function get mouseHandler():PrayMouseHandler
		{
			return _mouseHandler;
		}

		private var _viewHandler:PrayViewHandler;

		public function get viewHandler():PrayViewHandler
		{
			return _viewHandler;
		}

		override protected function initSkin():void
		{
			_skin = new McPanelPray();
			addChild(_skin);
			setTitleBar(_skin.mcTitleBar);
            _skin.addChild(_effectContainer = new Sprite());
		}

		override protected function initData():void
		{
			_viewHandler = new PrayViewHandler(this);
			_mouseHandler = new PrayMouseHandler(this);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McPanelPray = _skin as McPanelPray;
            _normalCoinEffect = new UIEffectLoader(skin, 199, 211, 1, 1, EffectConst.RES_PRAY_COIN_NORMAL);
            _normalTicketEffect = new UIEffectLoader(skin, 497, 212, 1, 1, EffectConst.RES_PRAY_TICKET_NORMAL);
		}

		override public function update(proc:int = 0):void
		{
			switch (proc) {
				case GameServiceConstants.SM_PRAY_INFO:
					refresh();
					break;
                case GameServiceConstants.CM_PRAY:
                    playEffect();
                    break;
				default :
					break;
			}
		}

        private function playEffect():void
        {
			var mannager:PrayDataManager = PrayDataManager.instance;
            if (_skin)
            {
                if (mannager.currentTypeData[0] == PrayType.TYPE_COIN && mannager.currentTypeData[1] == 0)
                {
                    _coinEffect = new UIEffectLoader(_effectContainer, -44, -17, 1, 1, EffectConst.RES_PRAY_COIN, null, true);
                } else if (mannager.currentTypeData[0] == PrayType.TYPE_TICKET && mannager.currentTypeData[1] == 0)
                {
                    _ticketEffect = new UIEffectLoader(_effectContainer, 255, -17, 1, 1, EffectConst.RES_PRAY_TICKET, null, true);
                }
            }
        }

        override public function setPostion():void
        {
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnPray.x, mc.mcBtns.mcLayer.btnPray.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function destroy():void
		{
            PrayDataManager.instance.currentTypeData = [0,1];
			PrayDataManager.instance.detach(this);
            if (_normalCoinEffect)
            {
                _normalCoinEffect.destroy();
                _normalCoinEffect = null;
            }
            if (_normalTicketEffect)
            {
                _normalTicketEffect.destroy();
                _normalTicketEffect = null;
            }
            if (_coinEffect)
            {
                _coinEffect.destroy();
                _coinEffect = null;
            }
            if (_ticketEffect)
            {
                _ticketEffect.destroy();
                _ticketEffect = null;
            }
			if (_mouseHandler) {
				_mouseHandler.destroy();
				_mouseHandler = null;
			}
			if (_viewHandler) {
				_viewHandler.destroy();
				_viewHandler = null;
			}
			super.destroy();
		}

		public function refresh():void
		{
			if (_viewHandler) {
				_viewHandler.refresh();
			}
		}
	}
}
