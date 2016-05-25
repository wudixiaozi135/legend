package com.view.gameWindow.panel.panels.trade
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.trade.data.OppositeDataInfo;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	/**
     * Created by Administrator on 2014/12/15.
     */
    public class TradeMouseHandler
    {
        private var _panel:PanelTrade;
        private var _skin:McPanelTrade;

        public function TradeMouseHandler(panel:PanelTrade)
        {
            _panel = panel;
            _skin = _panel.skin as McPanelTrade;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			_skin.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
			_skin.txtCoin2.addEventListener(Event.CHANGE, onTxtChangeHandler, false, 0, true);
			_skin.txtGold2.addEventListener(Event.CHANGE, onTxtChangeHandler, false, 0, true);

			_skin.txtCoin2.addEventListener(FocusEvent.FOCUS_IN, onFocusEvt, false, 0, true);
			_skin.txtGold2.addEventListener(FocusEvent.FOCUS_IN, onFocusEvt, false, 0, true);

			_skin.txtCoin2.addEventListener(FocusEvent.FOCUS_OUT, onFocusEvt, false, 0, true);
			_skin.txtGold2.addEventListener(FocusEvent.FOCUS_OUT, onFocusEvt, false, 0, true);

        }

		private function onFocusEvt(event:FocusEvent):void
		{
			if (event.type == FocusEvent.FOCUS_IN)
			{
				if (event.target == _skin.txtCoin2)
				{
					if (parseInt(_skin.txtCoin2.text) <= 0)
					{
						_skin.txtCoin2.text = "";
					}
				} else if (event.target == _skin.txtGold2)
				{
					if (parseInt(_skin.txtGold2.text) <= 0)
					{
						_skin.txtGold2.text = "";
					}
				}
			} else if (event.type == FocusEvent.FOCUS_OUT)
			{
				if (event.target == _skin.txtCoin2)
				{
					if (parseInt(_skin.txtCoin2.text) <= 0 || _skin.txtCoin2.text == "")
					{
						_skin.txtCoin2.text = "0";
					}
				} else if (event.target == _skin.txtGold2 || _skin.txtGold2.text == "")
				{
					if (parseInt(_skin.txtGold2.text) <= 0)
					{
						_skin.txtGold2.text = "0";
					}
				}
			}
		}

		private function onTxtChangeHandler(event:Event):void
		{
			if (TradeDataManager.lock_state_self)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0027);
				return;
			}
			var mgt:TradeDataManager = TradeDataManager.instance;
			var bagManager:BagDataManager = BagDataManager.instance;
			var maxValue:int = 0;
			if (event.target == _skin.txtCoin2)
			{
				maxValue = bagManager.coinUnBind;
				var money:int = parseInt(_skin.txtCoin2.text);
				if (money >= bagManager.coinUnBind)
				{
					money = bagManager.coinUnBind;
				}
				if (money <= bagManager.coinUnBind)
				{
					if (mgt.oppositeData)
					{
						mgt.sendCM_BEGIN_CHANGE(mgt.oppositeData.cid, mgt.oppositeData.sid, TradeDataManager.TRADE_TYPE_COIN, 0, 0, money);
					}
				}
			} else if (event.target == _skin.txtGold2)
			{
				maxValue = bagManager.goldUnBind;
				var gold:int = parseInt(_skin.txtGold2.text);
				if (gold >= bagManager.goldUnBind)
				{
					gold = bagManager.goldUnBind;
				}
				if (gold <= bagManager.goldUnBind)
				{
					if (mgt.oppositeData)
					{
						mgt.sendCM_BEGIN_CHANGE(mgt.oppositeData.cid, mgt.oppositeData.sid, TradeDataManager.TRADE_TYPE_GOLD, 0, 0, gold);
					}
				}
			}
		}

		private function onDoubleClick(event:MouseEvent):void
		{
			var cell:BagCell = event.target as BagCell;
			if (cell)
			{
				if (cell.bagData)
				{
					if (checkItemIsSelf(cell.bagData) == false)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0031);
						return;
					}
					if (TradeDataManager.lock_state_self)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0027);
						return;
					}
					var mgt:TradeDataManager = TradeDataManager.instance;
					var opporiteData:OppositeDataInfo = mgt.oppositeData;
					if (opporiteData)
					{
						mgt.sendCM_CHANGE_THING_TOBAG(opporiteData.cid, opporiteData.sid, cell.bagData.id, cell.bagData.type, cell.bagData.count);
					}
				}
			}
		}

		private function checkItemIsSelf(bagData:BagData):Boolean
		{
			var selfItems:Vector.<BagData> = TradeDataManager.instance.selfItems;
			for each(var data:BagData in selfItems)
			{
				if (bagData == data)
				{
					return true;
				}
			}
			return false;
		}


        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.btnLock:
					lockHandler();
                    break;
                case _skin.btnTrade:
					tradeHandler();
                    break;
				case _skin.btnCoin2:
//					setCoin2();
					break;
				case _skin.btnGold2:
//					setGold2();
					break;
                default :
                    break;
            }
        }

		private function tradeHandler():void
		{
			if (TradeDataManager.lock_state_self == false)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0029);
				return;
			}
			var mgt:TradeDataManager = TradeDataManager.instance;
			var data:OppositeDataInfo = mgt.oppositeData;
			var bool:Boolean = mgt.checkDistance();
			if (data)
			{
				if (!bool)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0025);
					return;
				}
				TradeDataManager.instance.sendTrade(data.cid, data.sid);
			}
		}

		private function lockHandler():void
		{
			var mgt:TradeDataManager = TradeDataManager.instance;
			var data:OppositeDataInfo = mgt.oppositeData;
			var bool:Boolean = mgt.checkDistance();
			if (data)
			{
				if (!bool)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0024);
					return;
				}
				TradeDataManager.instance.sendLock(data.cid, data.sid);
			}
		}

		private function setCoin2():void
		{
			if (TradeDataManager.lock_state_self)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0027);
				return;
			}
			var msg:String = StringConst.TRADE_0017;
			var warn:String = StringConst.TRADE_0015;
			var bagManager:BagDataManager = BagDataManager.instance;
			var maxValue:int = bagManager.coinUnBind;
			Alert.showInputPanel(msg, true, maxValue, function (value:String):void
			{
				var mgt:TradeDataManager = TradeDataManager.instance;
				var money:int = parseInt(value);
				if (money <= bagManager.coinUnBind)
				{
					if (mgt.oppositeData)
					{
						mgt.sendCM_BEGIN_CHANGE(mgt.oppositeData.cid, mgt.oppositeData.sid, TradeDataManager.TRADE_TYPE_COIN, 0, 0, money);
					}
				}
			}, warn, function (param:String):Boolean
			{
				var inputMoney:int = parseInt(param);
				return inputMoney > bagManager.coinUnBind;
			}, function ():void
			{
				_skin.txtCoin2.text = "";
			}, null, StringConst.TRADE_0014, StringConst.PROMPT_PANEL_0012, StringConst.PROMPT_PANEL_0013);
		}

		private function setGold2():void
		{
			if (TradeDataManager.lock_state_self)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0027);
				return;
			}
			var msg:String = StringConst.TRADE_0017;
			var warn:String = StringConst.TRADE_0015;
			var bagManager:BagDataManager = BagDataManager.instance;
			var maxValue:int = bagManager.goldUnBind;
			Alert.showInputPanel(msg, true, maxValue, function (value:String):void
			{
				var mgt:TradeDataManager = TradeDataManager.instance;
				var gold:int = parseInt(value);
				if (gold <= bagManager.goldUnBind)
				{
					if (mgt.oppositeData)
					{
						mgt.sendCM_BEGIN_CHANGE(mgt.oppositeData.cid, mgt.oppositeData.sid, TradeDataManager.TRADE_TYPE_GOLD, 0, 0, gold);
					}
				}
			}, warn, function (param:String):Boolean
			{
				var mgt:BagDataManager = BagDataManager.instance;
				var inputMoney:int = parseInt(param);
				return inputMoney > mgt.goldUnBind;
			}, function ():void
			{
				_skin.txtGold2.text = "";
			}, null, StringConst.TRADE_0014, StringConst.PROMPT_PANEL_0012, StringConst.PROMPT_PANEL_0013);
		}

        private function closeHandler():void
        {
			Alert.show2(StringConst.TRADE_0022, function ():void
			{
				var data:OppositeDataInfo = TradeDataManager.instance.oppositeData;
				if (data)
				{
					TradeDataManager.instance.cancelTrade(data.cid, data.sid);
				}
			});
        }

        public function destroy():void
        {
            if (_skin)
            {
				_skin.txtCoin2.removeEventListener(Event.CHANGE, onTxtChangeHandler);
				_skin.txtGold2.removeEventListener(Event.CHANGE, onTxtChangeHandler);
				_skin.txtCoin2.removeEventListener(FocusEvent.FOCUS_IN, onFocusEvt);
				_skin.txtGold2.removeEventListener(FocusEvent.FOCUS_IN, onFocusEvt);
				_skin.txtCoin2.removeEventListener(FocusEvent.FOCUS_OUT, onFocusEvt);
				_skin.txtGold2.removeEventListener(FocusEvent.FOCUS_OUT, onFocusEvt);

                _skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
            }
        }
    }
}
