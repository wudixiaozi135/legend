package com.view.gameWindow.panel.panels.pray
{
    import com.model.configData.cfgdata.PrayCfgData;
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.pray.constants.PrayType;
    import com.view.gameWindow.panel.panels.pray.data.PrayData;

    import mx.utils.StringUtil;

    /**
	 * Created by Administrator on 2014/11/25.
	 */
	public class PrayViewHandler
	{
		public function PrayViewHandler(panel:PanelPray)
		{
			_panel = panel;
			_skin = _panel.skin as McPanelPray;
			initialize();
		}
		private var _panel:PanelPray;
		private var _skin:McPanelPray;
		private var _data:PrayData;

		public function refresh():void
		{
			var cfg:PrayCfgData;
			var mgt:PrayDataManager = PrayDataManager.instance;
			_data = mgt.data;
			if (_data) {
				_skin.txtTodayValue.text = _data.coinTotal.toString();//今日获得金币
				_skin.txtTodayTicketValue.text = _data.goldTotal.toString();//今日获得礼券

				_skin.txtCountValue1.text = _data.coinCount + "/" + _data.coinTotalCount;
				_skin.txtCountValue2.text = _data.goldCount + "/" + _data.goldTotalCount;
			}

			if ((_data.coinCount + 1) >= _data.coinTotalCount) {
				cfg = mgt.getConfigData(PrayType.TYPE_COIN, _data.coinTotalCount);
			} else {
				cfg = mgt.getConfigData(PrayType.TYPE_COIN, (_data.coinCount + 1));
			}

			if (cfg) {
				_skin.txtCostValue1.text = cfg.cost_gold.toString();
				_skin.getCoinValue.text = StringUtil.substitute(StringConst.PANEL_PRAY_10, cfg.bindcoin_count);//绑定金币
                if (cfg.cost_gold == 0)
                {
                    _skin.btnTxtCoin.text = StringConst.PANEL_PRAY_13;
                } else
                {
                    _skin.btnTxtCoin.text = StringConst.PANEL_PRAY_11;
                }
			} else {
				_skin.txtCostValue1.text = "0";
				_skin.getCoinValue.text = StringUtil.substitute(StringConst.PANEL_PRAY_10, "0");//绑定金币
			}

			if ((_data.goldCount + 1) >= _data.goldTotalCount) {
				cfg = mgt.getConfigData(PrayType.TYPE_TICKET, _data.goldTotalCount);
			} else {
				cfg = mgt.getConfigData(PrayType.TYPE_TICKET, (_data.goldCount + 1));
			}
			if (cfg) {
				_skin.txtCostValue2.text = cfg.cost_gold.toString();
				_skin.getTicketValue.text = StringUtil.substitute(StringConst.PANEL_PRAY_10, cfg.bindgold_count);//绑定礼券
                if (cfg.cost_gold == 0)
                {
                    _skin.btnTxtTicket.text = StringConst.PANEL_PRAY_14;
                } else
                {
                    _skin.btnTxtTicket.text = StringConst.PANEL_PRAY_12;
                }
			} else {
				_skin.txtCostValue2.text = "0";
				_skin.getTicketValue.text = StringUtil.substitute(StringConst.PANEL_PRAY_10, "0");//绑定礼券
			}
            refreshCostLabel();
		}

        /**是否显示消费信息*/
        public function refreshCostLabel():void
        {
            var freeCoin:int = PrayDataManager.FREE_COIN_COUNT;
            if (freeCoin > 0)
            {
                _skin.txtCost1.visible = false;
                _skin.txtCostValue1.visible = false;
                _skin.txtCount1.visible = false;
                _skin.txtCountValue1.visible = false;
                _skin.txtVip1.visible = false;
            } else
            {
                _skin.txtCost1.visible = true;
                _skin.txtCostValue1.visible = true;
                _skin.txtCount1.visible = true;
                _skin.txtCountValue1.visible = true;
                _skin.txtVip1.visible = true;
            }

            var freeTicket:int = PrayDataManager.FREE_TICKET_COUNT;
            if (freeTicket > 0)
            {
                _skin.txtCost2.visible = false;
                _skin.txtCostValue2.visible = false;
                _skin.txtCount2.visible = false;
                _skin.txtCountValue2.visible = false;
                _skin.txtVip2.visible = false;
            } else
            {
                _skin.txtCost2.visible = true;
                _skin.txtCostValue2.visible = true;
                _skin.txtCount2.visible = true;
                _skin.txtCountValue2.visible = true;
                _skin.txtVip2.visible = true;
            }
        }
		public function destroy():void
		{
			if (_data) {
				_data = null;
			}
			if (_skin) {
				_skin = null;
			}
			if (_panel) {
				_panel = null;
			}
		}

		private function initialize():void
		{
			_skin.titleName.mouseEnabled = false;
			_skin.titleName.textColor = 0xffe1aa;
			_skin.titleName.text = StringConst.PANEL_PRAY_1;

			_skin.txtTodayCoin.mouseEnabled = false;
			_skin.txtTodayCoin.textColor = 0xd4a460;
			_skin.txtTodayCoin.text = StringConst.PANEL_PRAY_2;

			_skin.txtTodayTicket.mouseEnabled = false;
			_skin.txtTodayTicket.textColor = 0xd4a460;
			_skin.txtTodayTicket.text = StringConst.PANEL_PRAY_3;

			_skin.txtCost1.mouseEnabled = false;
			_skin.txtCost1.textColor = 0xd4a460;
			_skin.txtCost1.text = StringConst.PANEL_PRAY_4;

			_skin.txtCost2.mouseEnabled = false;
			_skin.txtCost2.textColor = 0xd4a460;
			_skin.txtCost2.text = StringConst.PANEL_PRAY_4;

			_skin.txtCount1.mouseEnabled = false;
			_skin.txtCount1.textColor = 0xd4a460;
			_skin.txtCount1.text = StringConst.PANEL_PRAY_5;

			_skin.txtCount2.mouseEnabled = false;
			_skin.txtCount2.textColor = 0xd4a460;
			_skin.txtCount2.text = StringConst.PANEL_PRAY_5;

			_skin.txtVip1.htmlText = StringConst.PANEL_PRAY_7;
			_skin.txtVip2.htmlText = StringConst.PANEL_PRAY_7;

			_skin.getCoin.mouseEnabled = false;
			_skin.getCoin.textColor = 0xff6600;
			_skin.getCoin.text = StringConst.PANEL_PRAY_8;

			_skin.getTicket.mouseEnabled = false;
			_skin.getTicket.textColor = 0xff6600;
			_skin.getTicket.text = StringConst.PANEL_PRAY_9;

			_skin.btnTxtCoin.mouseEnabled = false;
			_skin.btnTxtCoin.textColor = 0xffcc00;
			_skin.btnTxtCoin.text = StringConst.PANEL_PRAY_11;

			_skin.btnTxtTicket.mouseEnabled = false;
			_skin.btnTxtTicket.textColor = 0xffcc00;
			_skin.btnTxtTicket.text = StringConst.PANEL_PRAY_12;
		}

	}
}
