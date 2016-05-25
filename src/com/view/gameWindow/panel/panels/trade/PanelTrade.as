package com.view.gameWindow.panel.panels.trade
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McRoleHp;
    import com.view.gameWindow.mainUi.subuis.rolehp.PlayerHP;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.trade.data.OppositeDataInfo;
    import com.view.gameWindow.util.ObjectUtils;

    import flash.display.MovieClip;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2014/12/15.
     */
    public class PanelTrade extends PanelBase
    {
        private var _mouseHandler:TradeMouseHandler;
        private var _viewHandler:TradeViewHandler;
        public function PanelTrade()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McPanelTrade();
            addChild(_skin);
            setTitleBar(_skin.dragBox);
        }

        override protected function initData():void
        {
            _viewHandler = new TradeViewHandler(this);
            _mouseHandler = new TradeMouseHandler(this);
        }


		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McPanelTrade = _skin as McPanelTrade;
			rsrLoader.addCallBack(skin.gridBg, function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				_viewHandler.initData();
			});

			rsrLoader.addCallBack(skin.btnTrade, function (mc:MovieClip):void
			{
				mc.btnEnabled = false;
				ObjectUtils.gray(skin.btnTxt2);
			});
		}

		override public function setPostion():void
		{
			var mc:McRoleHp = MainUiMediator.getInstance().playHp.skin as McRoleHp;
			var hp:PlayerHP = MainUiMediator.getInstance().playHp;
			if (mc && hp)
			{
				var popPoint:Point = localToGlobal(new Point(hp.x + mc.btn3.x, hp.y + mc.btn3.y));
				isMount(true, popPoint.x, popPoint.y);
			} else
			{
				isMount(true);
			}
		}

        public function get mouseHandler():TradeMouseHandler
        {
            return _mouseHandler;
        }

        public function set mouseHandler(value:TradeMouseHandler):void
        {
            _mouseHandler = value;
        }

        public function get viewHandler():TradeViewHandler
        {
            return _viewHandler;
        }

        public function set viewHandler(value:TradeViewHandler):void
        {
            _viewHandler = value;
        }

        override public function destroy():void
        {
			TradeDataManager.lock_state_other = false;
			TradeDataManager.lock_state_self = false;
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

            var data:OppositeDataInfo = TradeDataManager.instance.oppositeData;
            if (data)
            {
                TradeDataManager.instance.cancelTrade(data.cid, data.sid);
                data = null;
            }
            super.destroy();
        }
    }
}
