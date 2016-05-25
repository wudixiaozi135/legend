package com.view.gameWindow.panel.panels.trade
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.bag.cell.BagCellType;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.trade.data.OppositeDataInfo;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.Entity;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ObjectUtils;

	/**
     * Created by Administrator on 2014/12/15.
     */
	public class TradeViewHandler implements IObserver
    {
        private var _panel:PanelTrade;
        private var _skin:McPanelTrade;

		private static const TOTAL_LENGTH:int = 12;
		private var _selfGrids:Vector.<BagCell>;//自己的物品格子
		private var _otherGrids:Vector.<BagCell>;//他人的物品格子

        public function TradeViewHandler(panel:PanelTrade)
        {
            _panel = panel;
            _skin = _panel.skin as McPanelTrade;
			_selfGrids = new Vector.<BagCell>(TOTAL_LENGTH, true);
			_otherGrids = new Vector.<BagCell>(TOTAL_LENGTH, true);

            initialize();
			TradeDataManager.instance.attach(this);
			EntityLayerManager.getInstance().attach(this);
        }

        private function initialize():void
        {
            _skin.txtName.mouseEnabled = false;
            _skin.txtName.textColor = 0xffe1aa;
            _skin.txtName.text = StringConst.TRADE_001;

            _skin.txtName1.mouseEnabled = false;
            _skin.txtName1.textColor = 0xffcc00;
            _skin.txtLv1.mouseEnabled = false;
            _skin.txtLv1.textColor = 0xffcc00;

            _skin.txtName2.mouseEnabled = false;
            _skin.txtName2.textColor = 0xffcc00;
            _skin.txtLv2.mouseEnabled = false;
            _skin.txtLv2.textColor = 0xffcc00;

            _skin.txtGold1.mouseEnabled = false;
            _skin.txtGold1.textColor = 0xffe1aa;
			_skin.txtGold1.text = "0";

            _skin.txtCoin1.mouseEnabled = false;
            _skin.txtCoin1.textColor = 0xffe1aa;
			_skin.txtCoin1.text = "0";

            _skin.txtGold2.textColor = 0xffe1aa;
			_skin.txtGold2.text = "0";
			_skin.txtGold2.restrict = "0-9";

            _skin.txtCoin2.textColor = 0xffe1aa;
			_skin.txtCoin2.text = "0";
			_skin.txtCoin2.restrict = "0-9";

            _skin.txtLock1.mouseEnabled = false;
            _skin.txtLock1.htmlText = StringConst.TRADE_002;

            _skin.txtLock2.mouseEnabled = false;
            _skin.txtLock2.htmlText = StringConst.TRADE_002;

            _skin.txtWarn.mouseEnabled = false;
            _skin.txtWarn.textColor = 0x53b436;
            _skin.txtWarn.text = StringConst.TRADE_004;

            _skin.btnTxt1.mouseEnabled = false;
            _skin.btnTxt1.textColor = 0xd4a460;
            _skin.btnTxt1.text = StringConst.TRADE_005;

            _skin.btnTxt2.mouseEnabled = false;
            _skin.btnTxt2.textColor = 0xd4a460;
            _skin.btnTxt2.text = StringConst.TRADE_006;

			ToolTipManager.getInstance().attachByTipVO(_skin.btnCoin1, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_4));
			ToolTipManager.getInstance().attachByTipVO(_skin.btnCoin2, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_4));
			ToolTipManager.getInstance().attachByTipVO(_skin.btnGold1, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1));
			ToolTipManager.getInstance().attachByTipVO(_skin.btnGold2, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1));
        }


		public function initData():void
		{
			var i:int = 0;
			var bagCell:BagCell;
			for (i; i < TOTAL_LENGTH; i++)
			{
				bagCell = new BagCell();
				bagCell.initView();
				bagCell.storageType = ConstStorage.ST_TRADE_OTHER_BAG;
				bagCell.refreshLockState(false);
				bagCell.bg.visible = false;
				_skin["item0_" + i].addChild(bagCell);
				_skin["item0_" + i].mouseEnabled = false;
				_otherGrids[i] = bagCell;

				bagCell = new BagCell();
				bagCell.storageType = ConstStorage.ST_TRADE_SELF_BAG;
				bagCell.initView();
				bagCell.bg.visible = false;
				bagCell.refreshLockState(false);
				_skin["item1_" + i].addChild(bagCell);
				_skin["item1_" + i].mouseEnabled = false;
				_selfGrids[i] = bagCell;
			}
			refresh();
		}

		public function refresh():void
		{
			var mgt:TradeDataManager = TradeDataManager.instance;
			var otherInfo:OppositeDataInfo = mgt.oppositeData;
			if (otherInfo)
			{
				_skin.txtName1.text = otherInfo.name;
				_skin.txtLv1.text = otherInfo.level + StringConst.ROLE_PROPERTY_PANEL_0072;
			}

			//刷新自己的等级
			var roleData:RoleDataManager = RoleDataManager.instance;
			_skin.txtName2.text = (EntityLayerManager.getInstance().firstPlayer as Entity).entityName;
			_skin.txtLv2.text = roleData.lv + StringConst.ROLE_PROPERTY_PANEL_0072;
		}


		public function update(proc:int = 0):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_MOVE:
					checkDistance();
					break;
				case GameServiceConstants.SM_CHANGE_THING_INFO://他人
					refreshOtherItem();
					break;
				case GameServiceConstants.SM_MYSELF_EXCHANGE_ITEMS://自己
					refreshSelfItem();
					break;
				case GameServiceConstants.SM_CHANGE_LOCK_INFO:
					refreshOtherLockState();
					break;
				case GameServiceConstants.CM_CHANGE_LOCK:
					refreshSelfLockState();
					break;
				case GameServiceConstants.CM_CHANGE:
					refreshSelfTradeState();
					break;
				default :
					break;
			}
		}

		/**刷新自己的交易按钮状态*/
		private function refreshSelfTradeState():void
		{
			_skin.btnTrade.btnEnabled = false;
			ObjectUtils.gray(_skin.btnTxt2);
		}

		/**刷新他人的锁定状态*/
		private function refreshOtherLockState():void
		{
			if (TradeDataManager.lock_state_other)
			{
				_skin.txtLock1.htmlText = StringConst.TRADE_003;
			} else
			{
				_skin.txtLock1.htmlText = StringConst.TRADE_002;
			}
			refreshTradeState();
		}

		/**刷新自己的锁定状态*/
		private function refreshSelfLockState():void
		{
			if (TradeDataManager.lock_state_self)
			{
				_skin.txtLock2.htmlText = StringConst.TRADE_003;
			} else
			{
				_skin.txtLock2.htmlText = StringConst.TRADE_002;
			}
			_skin.btnLock.btnEnabled = false;
			ObjectUtils.gray(_skin.btnTxt1);
			refreshTradeState();
		}

		private function refreshTradeState():void
		{
			var otherLock:Boolean = TradeDataManager.lock_state_other;
			var selfLock:Boolean = TradeDataManager.lock_state_self;
			if (otherLock && selfLock)
			{
				_skin.btnTrade.btnEnabled = true;
				ObjectUtils.gray(_skin.btnTxt2, false);
			}
		}

		/**自己的物品信息*/
		private function refreshSelfItem():void
		{
			var tradeData:TradeDataManager = TradeDataManager.instance;
			var selfItems:Vector.<BagData> = tradeData.selfItems;
			destroySelfTips();
			if (selfItems)
			{
				_skin.txtCoin2.text = tradeData.selfCoin.toString();
				_skin.txtGold2.text = tradeData.selfGold.toString();
				for (var i:int = 0, len:int = _selfGrids.length; i < len; i++)
				{
					var cell:BagCell = _selfGrids[i];
					if (i < selfItems.length)
					{
						cell.refreshData(selfItems[i]);
						ToolTipManager.getInstance().attach(_selfGrids[i]);
					} else
					{
						cell.setNull();
					}
				}
			}
		}

		private function destroySelfTips():void
		{
			_selfGrids.forEach(function (item:BagCell, index:int, vec:Vector.<BagCell>):void
			{
				ToolTipManager.getInstance().detach(item);
			});
		}

		private function destroyOtherTips():void
		{
			_otherGrids.forEach(function (item:BagCell, index:int, vec:Vector.<BagCell>):void
			{
				ToolTipManager.getInstance().detach(item);
			});
		}


		/**他人的物品信息*/
		private function refreshOtherItem():void
		{
			var tradeData:TradeDataManager = TradeDataManager.instance;
			var otherItems:Vector.<BagData> = tradeData.otherItems;
			destroyOtherTips();
			if (otherItems)
			{
				if (tradeData.oppositeData)
				{
					_skin.txtCoin1.text = tradeData.oppositeData.coin.toString();
					_skin.txtGold1.text = tradeData.oppositeData.gold.toString();
				}
				for (var i:int = 0, len:int = _otherGrids.length; i < len; i++)
				{
					var cell:BagCell = _otherGrids[i];
					cell.setNull();
					if (i < otherItems.length)
					{
						if (otherItems[i].type == SlotType.IT_EQUIP)
						{
							_otherGrids[i].bagType = BagCellType.TradeCellType;
						}
						cell.refreshData(otherItems[i]);
						ToolTipManager.getInstance().attach(_otherGrids[i]);
					}
				}
			}
		}

		/**检查交易双方的距离是否在交易范围*/
		private function checkDistance():void
		{
			var tradeManager:TradeDataManager = TradeDataManager.instance;
			var bool:Boolean = tradeManager.checkDistance();
			var isOverRange:Boolean = tradeManager.isOverRange;
			if (!bool && !isOverRange)
			{
				Alert.show2(StringConst.TRADE_0023, function ():void
				{
					tradeManager.cancelTrade(tradeManager.oppositeData.cid, tradeManager.oppositeData.sid);
				},null,"","",
				function ():void{
					tradeManager.isOverRange = true;
				},'center',true);
			}
		}

        public function destroy():void
        {
			TradeDataManager.instance.detach(this);
			EntityLayerManager.getInstance().detach(this);
			TradeDataManager.instance.isOverRange = false;
			destroyOtherTips();
			destroySelfTips();
			if (_selfGrids)
			{
				_selfGrids.forEach(function (cell:BagCell, index:int, vec:Vector.<BagCell>):void
				{
					cell.destory();
					cell = null;
				});
				_selfGrids = null;
			}
			if (_otherGrids)
			{
				_otherGrids.forEach(function (cell:BagCell, index:int, vec:Vector.<BagCell>):void
				{
					cell.destory();
					cell = null;
				});
				_otherGrids = null;
			}

			if (_skin)
			{
				ToolTipManager.getInstance().detach(_skin.btnCoin1);
				ToolTipManager.getInstance().detach(_skin.btnCoin2);
				ToolTipManager.getInstance().detach(_skin.btnGold1);
				ToolTipManager.getInstance().detach(_skin.btnGold2);
				ObjectUtils.clearAllChild(_skin);
				_skin = null;
			}
			if (_panel)
			{
				_panel = null;
			}
        }
    }
}
