package com.view.gameWindow.panel.panels.pray
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.PrayCfgData;
    import com.model.configData.cfgdata.VipCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireCostType;
    import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireManager;
    import com.view.gameWindow.panel.panels.pray.constants.PrayType;
    import com.view.gameWindow.panel.panels.pray.data.PrayData;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;

    import flash.events.MouseEvent;
    import flash.events.TextEvent;

    import mx.utils.StringUtil;

    /**
	 * Created by Administrator on 2014/11/25.
	 */
	public class PrayMouseHandler
	{
		public function PrayMouseHandler(panel:PanelPray)
		{
			_panel = panel;
			_skin = _panel.skin as McPanelPray;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

			_tipVo = new TipVO();
			_tipVo.tipType = ToolTipConst.TEXT_TIP;
			_tipVo.tipData = getTipVo();
			ToolTipManager.getInstance().hashTipInfo(_skin.txtVip1, _tipVo);
			ToolTipManager.getInstance().attach(_skin.txtVip1);

			_tipVo = new TipVO();
			_tipVo.tipType = ToolTipConst.TEXT_TIP;
			_tipVo.tipData = getTipVo();

			ToolTipManager.getInstance().hashTipInfo(_skin.txtVip2, _tipVo);
			ToolTipManager.getInstance().attach(_skin.txtVip2);
		}

		private var _tipVo:TipVO;
		private var _panel:PanelPray;
		private var _skin:McPanelPray;

		public function destroy():void
		{
			if (_tipVo) {
				_tipVo = null;
			}
			if (_skin) {
				ToolTipManager.getInstance().detach(_skin.txtVip1);
				ToolTipManager.getInstance().detach(_skin.txtVip2);
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			if (_panel) {
				_panel = null;
			}
		}

		private function getTipVo():String
		{
			var cfg:VipCfgData, mgt:VipDataManager = VipDataManager.instance, mgt2:ConfigDataManager = ConfigDataManager.instance;
			var tip:String = HtmlUtils.createHtmlStr(0xd4a460, StringUtil.substitute(StringConst.PRAY_TIP_1, mgt.lv)) + "<br>";
			tip += HtmlUtils.createHtmlStr(0xd4a460, StringConst.PRAY_TIP_2) + "<br>";
//			tip += HtmlUtils.createHtmlStr(0xffffff, StringConst.PRAY_TIP_3) + "<br>";
			for (var i:int = 1; i <= VipDataManager.MAX_LV; i++)
			{
				cfg = mgt2.vipCfgData(i);
				tip += HtmlUtils.createHtmlStr(0xffffff, StringUtil.substitute(StringConst.PRAY_TIP_4, i, cfg.add_pray_count));
				tip += "<br>";
			}
			return tip;
		}

		private function sendTicket():void
		{
			var currentGold:int = BagDataManager.instance.goldUnBind;
			var cfg:PrayCfgData, _data:PrayData;
			var mgt:PrayDataManager = PrayDataManager.instance;

			_data = mgt.data;
			if (mgt.data.goldCount == mgt.data.goldTotalCount) {
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PRAY_MESSAGE_2);
				return;
			}
			if ((_data.goldCount + 1) >= _data.goldTotalCount) {
				cfg = mgt.getConfigData(PrayType.TYPE_TICKET, _data.goldTotalCount);
			} else {
				cfg = mgt.getConfigData(PrayType.TYPE_TICKET, (_data.goldCount + 1));
			}

			if (currentGold < cfg.cost_gold) {
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TIP_GOLD_NOT_ENOUGH);
				AcquireManager.costType = AcquireCostType.TYPE_GOLD;
				PanelMediator.instance.openPanel(PanelConst.TYPE_MALL_ACQUIRE);
			} else {
                if (cfg.cost_gold <= 0)
                {
                    mgt.sendPrayRequest(PrayType.TYPE_TICKET);
                    return;
                }
				var bol:Boolean = SelectPromptBtnManager.getSelect(SelectPromptType.SELECT_PRAY_TICKET);
				if (bol) {
					mgt.sendPrayRequest(PrayType.TYPE_TICKET);
				} else {
					Alert.show3(StringUtil.substitute(StringConst.PRAY_TIP_6, cfg.cost_gold), function ():void
					{
						mgt.sendPrayRequest(PrayType.TYPE_TICKET);
					}, null, function (selected:Boolean):void
					{
						SelectPromptBtnManager.setSelect(SelectPromptType.SELECT_PRAY_TICKET, selected);
					}, null, StringConst.PROMPT_PANEL_0033, "","",null,"left");
				}
			}
		}

		private function sendCoin():void
		{
			var currentGold:int = BagDataManager.instance.goldUnBind;
			var cfg:PrayCfgData, _data:PrayData;
			var mgt:PrayDataManager = PrayDataManager.instance;

			_data = mgt.data;
			if (mgt.data) {
				if (mgt.data.coinCount == mgt.data.coinTotalCount) {
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PRAY_MESSAGE_1);
					return;
				}
			}
			if ((_data.coinCount + 1) >= _data.coinTotalCount) {
				cfg = mgt.getConfigData(PrayType.TYPE_COIN, _data.coinTotalCount);
			} else {
				cfg = mgt.getConfigData(PrayType.TYPE_COIN, (_data.coinCount + 1));
			}

			if (currentGold < cfg.cost_gold) {
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TIP_GOLD_NOT_ENOUGH);
				AcquireManager.costType = AcquireCostType.TYPE_GOLD;
				PanelMediator.instance.openPanel(PanelConst.TYPE_MALL_ACQUIRE);
			} else {
                if (cfg.cost_gold <= 0)
                {
                    mgt.sendPrayRequest(PrayType.TYPE_COIN);
                    return;
                }
				var bol:Boolean = SelectPromptBtnManager.getSelect(SelectPromptType.SELECT_PRAY_COIN);
				if (bol) {
					mgt.sendPrayRequest(PrayType.TYPE_COIN);
				} else {
					Alert.show3(StringUtil.substitute(StringConst.PRAY_TIP_5, cfg.cost_gold), function ():void
					{
						mgt.sendPrayRequest(PrayType.TYPE_COIN);
					}, null, function (selected:Boolean):void
					{
						SelectPromptBtnManager.setSelect(SelectPromptType.SELECT_PRAY_COIN, selected);
					}, null, StringConst.PROMPT_PANEL_0033, "","",null,"left");
				}
			}
		}

		private function closeHandler():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_PRAY);
		}

		private function onLinkEvt(event:TextEvent):void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_VIP);
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target) {
				case _skin.btnClose:
					closeHandler();
					break;
				case _skin.btnCoin:
					sendCoin();
					break;
				case _skin.btnTicket:
					sendTicket();
					break;
				default :
					break;
			}
		}
	}
}
