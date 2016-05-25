package com.view.gameWindow.panel.panels.mall
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.GameShopCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.mall.constant.MallTabType;
    import com.view.gameWindow.panel.panels.mall.constant.ShopShelfType;
    import com.view.gameWindow.panel.panels.mall.event.MallEvent;
    import com.view.gameWindow.panel.panels.mall.mallbuy.PanelMallBuy;
    import com.view.gameWindow.panel.panels.mall.mallgive.PanelMallGive;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallFashion;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallGem;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallHotSell;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallLimitBuy;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallMedicine;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallScore;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallSkill;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallStrength;
    import com.view.gameWindow.panel.panels.mall.tab.TabMallTicket;
    import com.view.gameWindow.panel.panels.mall.tab.TabSearchGoods;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.JsUtils;
    import com.view.gameWindow.util.tabsSwitch.TabsSwitch;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.utils.Dictionary;

    import mx.utils.StringUtil;

    /**
	 * Created by Administrator on 2014/11/19.
	 */
	public class MallMouseHandler implements IMallMouseHandler
	{
        //上次搜索的记录 减少重复搜索次数
        private var _tabSerachGood:TabSearchGoods;
        private var _lastSearchTxt:String;
        private var _panel:PanelMall;
        private var _skin:McMallPanel;
        private var _tipVo:TipVO;

        private var _tabSwitch:TabsSwitch;

        private var _tabButtons:Dictionary;
        private var _vecClass:Vector.<Class>;
        private var _tabIndex:Array = [];//存放下标位置
		public function MallMouseHandler(panel:PanelMall)
		{
			this._panel = panel;
			_skin = _panel.skin as McMallPanel;

            _tabButtons = new Dictionary();
            _vecClass = new Vector.<Class>();

            initData();
            _tabSwitch = new TabsSwitch(_skin.tabContainer, _vecClass);

			addTips();
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function initData():void
        {
            var len:int = 0;
            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_HOT_SELL).length;
            if (len > 0)
            {
                _vecClass.push(TabMallHotSell);
            }
            _tabButtons["tab0"] = Boolean(len);

            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_STRENGTH).length;
            if (len > 0)
            {
                _vecClass.push(TabMallStrength);
            }
            _tabButtons["tab1"] = Boolean(len);

            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_GEM).length;
            if (len > 0)
            {
                _vecClass.push(TabMallGem);
            }
            _tabButtons["tab2"] = Boolean(len);

            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_MEDICINE).length;
            if (len > 0)
            {
                _vecClass.push(TabMallMedicine);
            }
            _tabButtons["tab3"] = Boolean(len);

            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_SKILL).length;
            if (len > 0)
            {
                _vecClass.push(TabMallSkill);
            }
            _tabButtons["tab4"] = Boolean(len);

            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_TICKET).length;
            if (len > 0)
            {
                _vecClass.push(TabMallTicket);
            }
            _tabButtons["tab5"] = Boolean(len);

            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_SCORE).length;
            if (len > 0)
            {
                _vecClass.push(TabMallScore);
            }
            _tabButtons["tab6"] = Boolean(len);

            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_FASHION).length;
            if (len > 0)
            {
                _vecClass.push(TabMallFashion);
            }
            _tabButtons["tab7"] = Boolean(len);

            len = MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_LIMIT_BUY).length;
            if (len > 0)
            {
                _vecClass.push(TabMallLimitBuy);
            }
            _tabButtons["tab8"] = Boolean(len);

            var key:String;
            var btnHgap:int = 5;
            var btnStartX:int = 195;
            var tab:MovieClip, txt:TextField;
            for (var i:int = 0; i < 9; i++)
            {
                key = "tab" + i;
                tab = _skin[key];
                txt = _skin["tabTxt" + i];
                if (_tabButtons[key])
                {
                    tab.x = btnStartX;
                    tab.visible = true;
                    txt.x = tab.x + ((tab.width - txt.width) >> 1);
                    txt.visible = true;
                    btnStartX += tab.width + btnHgap;
                    _tabIndex.push(key);
                } else
                {
                    tab.visible = false;
                    txt.visible = false;
                }
            }
        }

		public function get tabSwitch():TabsSwitch
		{
			return _tabSwitch;
		}

		public function firstClick(mallTabType:int = 0):void
		{
            var key:String = "tab" + mallTabType;
            var pos:int = _tabIndex.indexOf(key);
            if (pos == -1)
            {
                pos = 0;
            }
			if (MallDataManager.lastTab) {
                dealBtnTab(pos, MallDataManager.lastTab);
			} else {
                dealBtnTab(pos, _skin.tab0);
			}
		}

		public function refresh():void
		{
		}

		public function destroy():void
		{
            if (_tabButtons)
            {
                for (var key:String in _tabButtons)
                {
                    delete _tabButtons[key];
                    key = null;
                }
                _tabButtons = null;
            }

            if (_vecClass)
            {
                _vecClass.forEach(function (element:Class, index:int, vec:Vector.<Class>):void
                {
                    element = null;
                });
                _vecClass.length = 0;
                _vecClass = null;
            }

            if (_tabIndex)
            {
                _tabIndex.length = 0;
                _tabIndex = null;
            }

			if (_tipVo) {
				_tipVo = null;
			}
            if (_tabSerachGood)
            {
                if (_tabSerachGood.parent)
                {
                    _skin.tabContainer.removeChild(_tabSerachGood);
                }
                _tabSerachGood.destroy();
                _tabSerachGood = null;
            }
			if (_skin)
			{
				ToolTipManager.getInstance().detach(_skin.mcBindGold);
				ToolTipManager.getInstance().detach(_skin.mcGold);
				ToolTipManager.getInstance().detach(_skin.mcScore);
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			if (_panel)
			{
				_panel = null;
			}
			if (_tabSwitch)
			{
				_tabSwitch.destroy();
				_tabSwitch = null;
			}
			_lastSearchTxt = null;
		}

		private function addTips():void
		{
			_tipVo = new TipVO();
			_tipVo.tipType = ToolTipConst.TEXT_TIP;
			_tipVo.tipData = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1);
			ToolTipManager.getInstance().hashTipInfo(_skin.mcGold, _tipVo);
			ToolTipManager.getInstance().attach(_skin.mcGold);

			_tipVo = new TipVO();
			_tipVo.tipType = ToolTipConst.TEXT_TIP;
			_tipVo.tipData = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_2);
			ToolTipManager.getInstance().hashTipInfo(_skin.mcBindGold, _tipVo);
			ToolTipManager.getInstance().attach(_skin.mcBindGold);

			_tipVo = new TipVO();
			_tipVo.tipData = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_3);
			ToolTipManager.getInstance().hashTipInfo(_skin.mcScore, _tipVo);
			ToolTipManager.getInstance().attach(_skin.mcScore);
		}

		private function turnRight():void
		{
			var currentPage:int = MallDataManager.currentPage;
			var totalPage:int = MallDataManager.totalPage;
			if (currentPage < totalPage)
			{
				currentPage++;
			}
			MallDataManager.currentPage = currentPage;
			switchRefresh();
		}

		private function turnLeft():void
		{
			var currentPage:int = MallDataManager.currentPage;
			var totalPage:int = MallDataManager.totalPage;
			if (currentPage > 1)
			{
				currentPage--;
			}
			MallDataManager.currentPage = currentPage;
			switchRefresh();
		}

		private function switchRefresh():void
		{
			var selectIndex:int = MallDataManager.instance.selectIndex;
			if (selectIndex == MallTabType.TYPE_SEARCH_GOODS)
			{
				if (_tabSerachGood)
				{
					_tabSerachGood.refresh();
				}
				return;
			}
			if (_tabSwitch)
			{
				_tabSwitch.onClick(selectIndex, true);
			}
		}

		/**充值*/
		private function charge():void
		{
            JsUtils.callRecharge();
		}

		/**提取元宝*/
		private function getGold():void
		{
            var unExtractGold:int = BagDataManager.instance.unExtractGold;
            if (unExtractGold > 0)
            {
                Alert.show2(StringConst.MALL_GET_GOLD_TIP, function ():void
                {
                    BagDataManager.instance.sendExtraGold();
                });
            } else
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.MALL_GET_GOLD_TIP1);
            }
		}

		/**选中消息播报*/
		private function sendBroadCase():void
		{
			RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0007);
		}

        public function dealBtnTab(index:int, tab:MovieClip, pos:int = 0):void
		{
			_lastSearchTxt = null;

            if (MallDataManager.instance.selectIndex != index)
			{
                if (MallDataManager.defaultPage > 0)
                {
                    MallDataManager.currentPage = MallDataManager.defaultPage;
                    MallDataManager.defaultPage = 0;
                } else
                {
                    MallDataManager.currentPage = 1;
                }
			}
			MallDataManager.instance.selectIndex = index;
			_tabSwitch.onClick(index, true);

			if (!MallDataManager.lastTab) return;

			MallDataManager.lastTab.selected = false;
			MallDataManager.lastTab.mouseEnabled = true;

			for (var i:int = 0; i < 9; i++)
			{
                _skin["tabTxt" + i].textColor = 0xd4a460;
			}
			tab.selected = true;
            _skin["tabTxt" + pos].textColor = 0xffe1aa;
			tab.mouseEnabled = false;
			MallDataManager.lastTab = tab;
		}

		private function closePanel():void
		{
			var buyPanel:PanelMallBuy = PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL_BUY) as PanelMallBuy;
			if (buyPanel)
			{
				buyPanel.mouseHandler.closeHandler();
			}
			var givePanel:PanelMallGive = PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL_GIVE) as PanelMallGive;
			if (givePanel)
			{
				givePanel.mouseHandler.closeHandler();
			}
			PanelMediator.instance.closePanel(PanelConst.TYPE_MALL);
		}

		private function searchHandler():void
		{
			var serachTxt:String = _skin.searchTxt.text;
			serachTxt = StringUtil.trim(serachTxt);
			if (_lastSearchTxt == serachTxt) return;
			if (serachTxt == StringConst.MALL_LABEL_1 || serachTxt == "")
			{
                Alert.show2(StringConst.MALL_COUPON_MESSAGE_5, null, null);
				_skin.stage.focus = _skin.searchTxt;
				resetSearch();
				return;
			}
			_lastSearchTxt = serachTxt;

			MallDataManager.currentPage = 1;
			var vecData:Vector.<GameShopCfgData> = new Vector.<GameShopCfgData>();
			var dic:Dictionary = ConfigDataManager.instance.gameShopCfgData();
			var itemCfg:ItemCfgData;
			for each(var item:GameShopCfgData in dic)
			{
				itemCfg = ConfigDataManager.instance.itemCfgData(item.item_id);
				if (itemCfg.name.indexOf(serachTxt) != -1)
				{
					vecData.push(item);
				}
			}
			if (vecData.length == 0)
			{
                Alert.show2(StringConst.MALL_COUPON_MESSAGE_2, function ():void
                {
                    _lastSearchTxt = null;
                }, null, StringConst.MALL_COUPON_MESSAGE_4, "", function ():void
                {
                    _lastSearchTxt = null;
                });
				return;
			}
			if (_skin.tabContainer)
			{
				MallDataManager.instance.selectIndex = MallTabType.TYPE_SEARCH_GOODS;
				if (_tabSwitch.tab)
				{
					if (_tabSwitch.tab.parent)
					{
						_tabSwitch.tab.parent.removeChild(_tabSwitch.tab);
					}
				}
				if (_tabSerachGood)
				{
					if (_tabSerachGood.parent)
					{
						_tabSerachGood.parent.removeChild(_tabSerachGood);
					}
					_tabSerachGood.destroy();
					_tabSerachGood = null;
				}
				_tabSerachGood = new TabSearchGoods();
				_skin.tabContainer.addChild(_tabSerachGood);
				MallEvent.dispatchEvent(new MallEvent(MallEvent.SEARCH_GOODS, {data: vecData}));

				if (MallDataManager.lastTab)
				{
					MallDataManager.lastTab.selected = false;
					MallDataManager.lastTab.mouseEnabled = true;
				}
			}
		}

		private function resetSearch():void
		{
			if (_skin.stage.focus == _skin.searchTxt)
			{
				if (StringUtil.trim(_skin.searchTxt.text) == StringConst.MALL_LABEL_1)
				{
					_skin.searchTxt.text = "";
				}
			}
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				default :
					break;
				case _skin.btnClose:
					closePanel();
					break;
				case _skin.tab0:
//					dealBtnTab(MallTabType.TYPE_HOT_SELL, _skin.tab0);//热销
                    dealBtnTab(_tabIndex.indexOf("tab0"), _skin.tab0, 0);//热销
					break;
				case _skin.tab1:
//					dealBtnTab(MallTabType.TYPE_STRENGTH, _skin.tab1);//强化
                    dealBtnTab(_tabIndex.indexOf("tab1"), _skin.tab1, 1);//强化
					break;
				case _skin.tab2:
//					dealBtnTab(MallTabType.TYPE_GEM, _skin.tab2);//宝石
                    dealBtnTab(_tabIndex.indexOf("tab2"), _skin.tab2, 2);//宝石
					break;
				case _skin.tab3:
//					dealBtnTab(MallTabType.TYPE_MEDICINE, _skin.tab3);//药水
                    dealBtnTab(_tabIndex.indexOf("tab3"), _skin.tab3, 3);//药水
					break;
				case _skin.tab4:
//					dealBtnTab(MallTabType.TYPE_SKILL, _skin.tab4);//技能
                    dealBtnTab(_tabIndex.indexOf("tab4"), _skin.tab4, 4);//技能
					break;
				case _skin.tab5:
//					dealBtnTab(MallTabType.TYPE_TICKET, _skin.tab5);//礼券
                    dealBtnTab(_tabIndex.indexOf("tab5"), _skin.tab5, 5);//礼券
					break;
				case _skin.tab6:
//					dealBtnTab(MallTabType.TYPE_SCORE, _skin.tab6);//积分
                    dealBtnTab(_tabIndex.indexOf("tab6"), _skin.tab6, 6);//积分
					break;
				case _skin.tab7:
//					dealBtnTab(MallTabType.TYPE_FASHION, _skin.tab7);//时装
                    dealBtnTab(_tabIndex.indexOf("tab7"), _skin.tab7, 7);//时装
					break;
				case _skin.tab8:
//					dealBtnTab(MallTabType.TYPE_LIMIT_BUY, _skin.tab8);//限购
                    dealBtnTab(_tabIndex.indexOf("tab8"), _skin.tab8, 8);//限购
					break;
				case _skin.checkBtn:
					sendBroadCase();
					break;
				case _skin.btnGetGold:
					getGold();
					break;
				case _skin.btnCharge:
					charge();
					break;
				case _skin.btnLeft:
					turnLeft();
					break;
				case _skin.btnRight:
					turnRight();
					break;
				case _skin.btnSearch:
					searchHandler();
				case _skin.searchTxt:
					resetSearch();
					break;
			}
		}
	}
}
