package com.view.gameWindow.panel.panels.exchangeShop
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.StoneExchangeShopCfgData;
    import com.model.consts.ItemType;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.exchangeShop.data.ExchangeShopData;
    import com.view.gameWindow.panel.panels.exchangeShop.item.ExchangeShopItem;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;

    import flash.display.Bitmap;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/3/12.
     */
    public class ExchangeShopViewHandler implements IObserver
    {
        private var _panel:PanelExchangeShop;
        private var _skin:McExchangeShopPanel;

        private var _exchangeShopItems:Vector.<ExchangeShopItem>;

        private const SIZE:int = 6;

        public function ExchangeShopViewHandler(panel:PanelExchangeShop)
        {
            _panel = panel;
            _skin = _panel.skin as McExchangeShopPanel;

            initTxt();
            initData();
            updateTxt();

            ExchangeShopDataManager.instance.attach(this);
            BagDataManager.instance.attach(this);
        }

        private function initData():void
        {
            _exchangeShopItems = new Vector.<ExchangeShopItem>(SIZE);
            for (var i:int = 0; i < SIZE; i++)
            {
                var item:ExchangeShopItem = new ExchangeShopItem();
                _skin.tabContainer.addChild(item);
                item.x = (i % 3) * item.width;
                item.y = int(i / 3) * item.height;
                _exchangeShopItems[i] = item;
            }
        }

        private function initTxt():void
        {
            _skin.txtTodayLabel.mouseEnabled = false;
            _skin.txtTodayLabel.textColor = 0xd4a460;
            _skin.txtTodayLabel.text = StringConst.EXCHANGE_SHOP_005;

            _skin.txtTodayCount.mouseEnabled = false;
            _skin.txtTodayCount.textColor = 0x00ff00;

            _skin.txtVip.htmlText = HtmlUtils.createHtmlStr(0x00ff00, StringConst.EXCHANGE_SHOP_006, 12, false, 2, 'SimSun', true);

            _skin.txtStone40Count.textColor = 0x00ff00;
            _skin.txtStone40Count.mouseEnabled = false;

            _skin.txtRefresh.mouseEnabled = false;
            _skin.txtRefresh.textColor = 0xffe1aa;
            _skin.txtRefresh.text = StringConst.EXCHANGE_SHOP_0024;

            _skin.txtRemain.mouseEnabled = false;
            _skin.txtRemain.textColor = 0xd4a460;
            _skin.txtRemain.text = StringConst.EXCHANGE_SHOP_0025;

            _skin.txtRemainCount.textColor = 0x00ff00;
            _skin.txtRemainCount.mouseEnabled = false;
            _skin.txtRemainCount.text = "0";

            var stoneShopCfg:StoneExchangeShopCfgData = ExchangeShopDataManager.instance.stoneExchangeShop;
            var times:Array = [];
            if (stoneShopCfg)
            {
                times = stoneShopCfg.name.split("|");
                _skin.txtTitle.mouseEnabled = false;
                _skin.txtTitle.htmlText = "<font color='" + times[0] + "'>" + times[1] + "</font>";
            }

            var cfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(ItemType.IT_113);
            if (cfg)
            {
                ToolTipManager.getInstance().attachByTipVO(_skin.stone40, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xd4a460, cfg.name));
            }
            cfg = null;
        }

        private function refresh():void
        {
            var mgt:ExchangeShopDataManager = ExchangeShopDataManager.instance;
            var datas:Vector.<ExchangeShopData> = mgt.exchangeShopDatas;
            var data:ExchangeShopData, shopItem:ExchangeShopItem;

            for (var i:int = 0, len:int = datas.length; i < len; i++)
            {
                if (i < SIZE)
                {
                    data = datas[i];
                    shopItem = _exchangeShopItems[i];
                    if (shopItem)
                    {
                        shopItem.data = data;
                    }
                }
            }
            var stoneShopCfg:StoneExchangeShopCfgData = mgt.stoneExchangeShop;
            _skin.txtTodayCount.text = (stoneShopCfg.exchange_max - mgt.exchangeCount).toString();
            updateTips();
        }

        public function updateTips():void
        {
            ToolTipManager.getInstance().detach(_skin.btnRefresh);
            var mgt:ExchangeShopDataManager = ExchangeShopDataManager.instance;
            var stoneShopCfg:StoneExchangeShopCfgData = mgt.stoneExchangeShop;
            var vipLv:int = VipDataManager.instance.lv;
            var vipCount:int = 0;
            if (vipLv > 0)
            {
                vipCount = ConfigDataManager.instance.vipCfgData(vipLv).add_refresh_num;
            }
            var remainCount:int = stoneShopCfg.daily_num + vipCount - mgt.refreshCount;
            if (_skin.txtRemainCount)
            {
                _skin.txtRemainCount.text = remainCount.toString();
            }
            if (remainCount > 0)
            {
                var msg:String = StringUtil.substitute(StringConst.EXCHANGE_SHOP_0013, mgt.getCostStr(stoneShopCfg.cost_type), stoneShopCfg.cost);
                ToolTipManager.getInstance().attachByTipVO(_skin.btnRefresh, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffffff, msg));
            }
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_QUERY_EXCHANGR_SHOP)
            {
                refresh();
            } else if (proc == GameServiceConstants.SM_BAG_ITEMS)
            {
                updateTxt();
            } else if (proc == GameServiceConstants.CM_EXCHANGR_SHOP_BY_EXCHANGE)
            {
                handlerSuccess();
            }
        }

        private function handlerSuccess():void
        {
            var bmp:Bitmap = ExchangeShopDataManager.buyItemBmp;
            if (bmp)
            {
                var arr:Array = [bmp];
                FlyEffectMediator.instance.doFlyReceiveThings2(arr);
                arr = null;
                if (bmp.bitmapData)
                {
                    bmp.bitmapData.dispose();
                    bmp.bitmapData = null;
                }
                if (bmp.parent)
                {
                    bmp.parent.removeChild(bmp);
                }
                bmp = null;
            }
            ExchangeShopDataManager.buyItemBmp = null;
            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.EXCHANGE_SHOP_0020);
        }

        private function updateTxt():void
        {
            if (_skin.txtStone40Count)
            {
                _skin.txtStone40Count.text = BagDataManager.instance.getItemNumById(ItemType.IT_113) + "";
            }
            if (_skin.txtGoldCount)
            {
                _skin.txtGoldCount.text = BagDataManager.instance.goldUnBind.toString();
            }
        }

        public function destroy():void
        {
            ExchangeShopDataManager.instance.detach(this);
            BagDataManager.instance.detach(this);

            if (_exchangeShopItems)
            {
                _exchangeShopItems.forEach(function (element:ExchangeShopItem, index:int, vec:Vector.<ExchangeShopItem>):void
                {
                    if (element.parent)
                    {
                        _skin.tabContainer.removeChild(element);
                    }
                    element.destroy();
                    element = null;
                });
                _exchangeShopItems = null;
            }
            if (_skin)
            {
                ToolTipManager.getInstance().detach(_skin.btnRefresh);
                ToolTipManager.getInstance().detach(_skin.stone40);
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }

    }
}
