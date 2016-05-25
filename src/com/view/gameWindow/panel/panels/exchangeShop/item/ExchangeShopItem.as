package com.view.gameWindow.panel.panels.exchangeShop.item
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.StoneExchangeShopItemCfgData;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.exchangeShop.ExchangeShopDataManager;
    import com.view.gameWindow.panel.panels.exchangeShop.McExchangeShopItem;
    import com.view.gameWindow.panel.panels.exchangeShop.data.ExchangeCostType;
    import com.view.gameWindow.panel.panels.exchangeShop.data.ExchangeShopData;
    import com.view.gameWindow.panel.panels.mall.mallItem.*;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2014/11/19.
     * 积分商店的物品项
     */
    public class ExchangeShopItem extends MallItemBase implements IObserver
    {
        private var _itemCfg:Object;//有可能是物品表，或者装备表
        private var _dt:ThingsData;
        private var _cellEx:IconCellEx;
        private var _data:ExchangeShopData;
        private var _costSp:CostSp;
        public function ExchangeShopItem()
        {
            mouseEnabled = false;
            _skin = new McExchangeShopItem();
            _skin.mouseEnabled = false;

            var mc:McExchangeShopItem = _skin as McExchangeShopItem;
            mc.iconContainer.mouseEnabled = false;

            addChild(_skin);
            initTxt();
            initView();
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            BagDataManager.instance.attach(this);
        }

        public function set data(value:ExchangeShopData):void
        {
            if (_data != null)
            {
                destoryReference();
            }
            _data = value;
            if (_data)
            {
                var exchangeShopItem:StoneExchangeShopItemCfgData;
                exchangeShopItem = ConfigDataManager.instance.stoneExchangeShopItemCfgData(_data.groupId, _data.itemIndex);
                var mc:McExchangeShopItem = _skin as McExchangeShopItem;
                if (exchangeShopItem.item_type == SlotType.IT_ITEM)
                {
                    _itemCfg = ConfigDataManager.instance.itemCfgData(exchangeShopItem.item_id);
                    mc.txtName.textColor = ItemType.getColorByQuality(_itemCfg.quality);
                } else
                {
                    _itemCfg = ConfigDataManager.instance.equipCfgData(exchangeShopItem.item_id);
                    mc.txtName.textColor = ItemType.getColorByQuality(_itemCfg.color);
                }

                if (_itemCfg)
                {
                    mc.txtName.text = _itemCfg.name;
                }
                if (exchangeShopItem)
                {
                    var iconX:Number = (mc.iconContainer.width - 60) >> 1;
                    _cellEx = new IconCellEx(mc.iconContainer, iconX, iconX, 60, 60);
                    _dt = new ThingsData();
                    _dt.id = exchangeShopItem.item_id;
                    _dt.type = exchangeShopItem.item_type;
                    _dt.bind = exchangeShopItem.bind;
                    _dt.count = exchangeShopItem.item_num;

                    mc.txtCostValue.text = exchangeShopItem.exchange_item_num.toString();
                    if (exchangeShopItem.exchange_type == ExchangeCostType.COST_PROPS)
                    {
                        _costSp = new CostSp(exchangeShopItem.exchange_type, exchangeShopItem.exchange_item_id);
                    } else
                    {
                        _costSp = new CostSp(exchangeShopItem.exchange_type);
                    }
                    ObjectUtils.clearAllChild(mc.costContainer);
                    mc.costContainer.addChild(_costSp);

                    IconCellEx.setItemByThingsData(_cellEx, _dt);
                    ToolTipManager.getInstance().attach(_cellEx);
                }
                enabled(Boolean(_data.state));
                refreshTxt();
            }
        }

        public function enabled(bool:Boolean):void
        {
            if (_skin.btnBuy)
            {
                ObjectUtils.gray(_skin.btnBuy, bool);
                _skin.btnBuy.mouseEnabled = !bool;
            }
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McExchangeShopItem = _skin as McExchangeShopItem;
            rsrLoader.addCallBack(skin.bg, function (mc:MovieClip):void
            {
                mc.mouseChildren = false;
                mc.mouseEnabled = false;
            });

            rsrLoader.addCallBack(skin.btnBuy, function (mc:MovieClip):void
            {
                if (_data)
                {
                    enabled(Boolean(_data.state));
                }
            });
        }

        /**购买*/
        private function buyHandler():void
        {
            var stoneItemCfg:StoneExchangeShopItemCfgData;
            if (_data)
            {
                var mgt:BagDataManager = BagDataManager.instance;
                var gold:int = mgt.coinBind + mgt.coinUnBind;
                var ticket:int = mgt.goldBind;
                var medal:int = mgt.goldUnBind;
                stoneItemCfg = ConfigDataManager.instance.stoneExchangeShopItemCfgData(_data.groupId, _data.itemIndex);
                if (stoneItemCfg)
                {
                    var dataManager:ExchangeShopDataManager = ExchangeShopDataManager.instance;
                    if (dataManager.stoneExchangeShop.exchange_max <= dataManager.exchangeCount)
                    {
                        RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.EXCHANGE_SHOP_0022);
                        return;
                    }
                    var costType:int = stoneItemCfg.exchange_type;
                    var costValue:int = stoneItemCfg.exchange_item_num;
                    var costName:String = "";
                    if (costType == ExchangeCostType.COST_GOLD)
                    {
                        costName = StringConst.EXCHANGE_SHOP_008;
                        if (costValue > gold)
                        {//金币不足
                            RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.EXCHANGE_SHOP_0018, costName));
                            return;
                        }
                    } else if (costType == ExchangeCostType.COST_TICKET)
                    {
                        costName = StringConst.EXCHANGE_SHOP_009;
                        if (costValue > ticket)
                        {
                            RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.EXCHANGE_SHOP_0018, costName));
                            return;
                        }
                    } else if (costType == ExchangeCostType.COST_MEDAL)
                    {
                        costName = StringConst.EXCHANGE_SHOP_0010;
                        if (costValue > medal)
                        {
                            RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.EXCHANGE_SHOP_0018, costName));
                            return;
                        }
                    } else if (costType == ExchangeCostType.COST_PROPS)
                    {
                        var itemCount:int = mgt.getItemNumById(stoneItemCfg.exchange_item_id);
                        var cfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(stoneItemCfg.exchange_item_id);
                        if (cfg)
                        {
                            costName = cfg.name;
                        }
                        if (costValue > itemCount)
                        {
                            RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.EXCHANGE_SHOP_0018, costName));
                            return;
                        }
                    }
                    var msg:String = StringUtil.substitute(StringConst.EXCHANGE_SHOP_0019, costName, stoneItemCfg.exchange_item_num);
                    Alert.show2(msg, function ():void
                    {
                        ExchangeShopDataManager.buyItemBmp = getBmp();
                        ExchangeShopDataManager.instance.sendExchangeItem(_data.index);
                    }, null, StringConst.PROMPT_PANEL_0012, StringConst.PROMPT_PANEL_0013);
                }
                refreshTxt();
            }
        }

        private function getBmp():Bitmap
        {
            var bmp:Bitmap;
            if (_cellEx)
            {
                bmp = _cellEx.getBitmap();
                if (bmp)
                {
                    bmp.name = _cellEx.id.toString();
                    bmp.width = bmp.height = 40;
                    _cellEx.addChild(bmp);
                }
            }
            return bmp;
        }

        private function initTxt():void
        {
            var mc:McExchangeShopItem = _skin as McExchangeShopItem;
            mc.txtName.mouseEnabled = false;
            mc.txtCostLabel.mouseEnabled = false;

            mc.txtCostLabel.textColor = 0xd4a460;
            mc.txtCostLabel.text = StringConst.EXCHANGE_SHOP_002;

            mc.txtCostValue.textColor = 0x00ff00;
            mc.txtCostValue.mouseEnabled = false;

            mc.txtBuy.text = StringConst.EXCHANGE_SHOP_001;
            mc.txtBuy.mouseEnabled = false;
        }

        private function onClick(event:MouseEvent):void
        {
            var mc:McExchangeShopItem = _skin as McExchangeShopItem;
            switch (event.target)
            {
                default :
                    break;
                case mc.btnBuy:
                    buyHandler();
                    break;
            }
        }

        override public function get height():Number
        {
            return _skin.bg.height;
        }

        override public function get width():Number
        {
            return _skin.bg.width;
        }

        public function getCostStr(cfg:StoneExchangeShopItemCfgData):String
        {
            var costName:String = "";
            if (cfg.exchange_type == ExchangeCostType.COST_GOLD)
            {
                costName = StringConst.EXCHANGE_SHOP_008;
            } else if (cfg.exchange_type == ExchangeCostType.COST_TICKET)
            {
                costName = StringConst.EXCHANGE_SHOP_009;
            } else if (cfg.exchange_type == ExchangeCostType.COST_MEDAL)
            {
                costName = StringConst.EXCHANGE_SHOP_0010;
            } else if (cfg.exchange_type == ExchangeCostType.COST_PROPS)
            {
                var obj:ItemCfgData = ConfigDataManager.instance.itemCfgData(cfg.exchange_item_id);
                if (obj)
                {
                    costName = obj.name;
                }
            }
            return StringUtil.substitute(StringConst.EXCHANGE_SHOP_0011, costName, cfg.exchange_item_num);
        }

        private function destoryReference():void
        {
            if (_data)
            {
                _data = null;
            }
            if (_itemCfg)
            {
                _itemCfg = null;
            }
            if (_dt)
            {
                _dt = null;
            }
            if (_cellEx)
            {
                ToolTipManager.getInstance().detach(_cellEx);
                _cellEx.destroy();
                _cellEx = null;
            }
        }

        override public function destroy():void
        {
            BagDataManager.instance.detach(this);
            if (_skin)
            {
                if (_costSp && _costSp.parent)
                {
                    _costSp.parent.removeChild(_costSp);
                    _costSp = null;
                }
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
                _skin = null;
            }
            destoryReference();
            super.destroy();
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_BAG_ITEMS)
            {
                refreshTxt();
            }
        }

        private function refreshTxt():void
        {
            var ownCount:int = 0;
            var mc:McExchangeShopItem = _skin as McExchangeShopItem;
            if (_data)
            {
                var exchangeShopItem:StoneExchangeShopItemCfgData;
                exchangeShopItem = ConfigDataManager.instance.stoneExchangeShopItemCfgData(_data.groupId, _data.itemIndex);
                if (exchangeShopItem.exchange_type == ExchangeCostType.COST_GOLD)
                {
                    ownCount = BagDataManager.instance.coinUnBind;
                } else if (exchangeShopItem.exchange_type == ExchangeCostType.COST_MEDAL)
                {
                    ownCount = BagDataManager.instance.goldUnBind;
                } else if (exchangeShopItem.exchange_type == ExchangeCostType.COST_TICKET)
                {
                    ownCount = BagDataManager.instance.goldBind;
                } else if (exchangeShopItem.exchange_type == ExchangeCostType.COST_PROPS)
                {
                    ownCount = BagDataManager.instance.getItemNumById(exchangeShopItem.exchange_item_id, 0);
                }
                if (ownCount < exchangeShopItem.exchange_item_num)
                {
                    mc.txtCostValue.textColor = 0xff0000;
                } else
                {
                    mc.txtCostValue.textColor = 0x00ff00;
                }
                mc.txtCostValue.text = exchangeShopItem.exchange_item_num.toString();
            }
        }
    }
}

import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.configData.ConfigDataManager;
import com.model.configData.cfgdata.ItemCfgData;
import com.model.consts.StringConst;
import com.model.consts.ToolTipConst;
import com.view.gameWindow.common.ResManager;
import com.view.gameWindow.panel.panels.exchangeShop.data.ExchangeCostType;
import com.view.gameWindow.tips.toolTip.ToolTipManager;
import com.view.gameWindow.util.HtmlUtils;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;

class CostSp extends Sprite
{
    private var _container:Sprite;
    private var _itemId:int;
    private var _costType:int;
    private var _itemCfg:ItemCfgData;

    public function CostSp(type:int, itemId:int = 0)
    {
        _costType = type;
        _itemId = itemId;
        if (_itemId > 0)
        {
            _itemCfg = ConfigDataManager.instance.itemCfgData(_itemId);
        }
        addChild(_container = new Sprite());
        addEventListener(Event.REMOVED, onRemove, false, 0, true);
        init();
    }


    public function destroy():void
    {
        if (_container)
        {
            while (_container.numChildren > 0)
            {
                _container.removeChildAt(0);
            }
            _container = null;
        }
    }

    private function init():void
    {
        var url:String;
        switch (_costType)
        {
            default :
                break;
            case ExchangeCostType.COST_GOLD:
                url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "bagPanel/money.png";
                break;
            case ExchangeCostType.COST_TICKET:
                url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "bagPanel/boundGold.png";
                break;
            case ExchangeCostType.COST_MEDAL:
                url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "bagPanel/gold.png";
                break;
            case ExchangeCostType.COST_PROPS:
                if (_itemCfg)
                {
                    url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "exchangeShop/lv_" + _itemCfg.item_level + ResourcePathConstants.POSTFIX_PNG;
                }
                break;
        }
        if (url)
        {
            ResManager.getInstance().loadBitmap(url, callBack);
        }
    }

    private function callBack(bmd:BitmapData, url:String):void
    {
        if (_container)
        {
            _container.addChild(new Bitmap(bmd));
            ToolTipManager.getInstance().attachByTipVO(this, ToolTipConst.TEXT_TIP, getCostLabel());
        }
    }

    private function getCostLabel():String
    {
        var costLabel:String = "";
        switch (_costType)
        {
            default :
                break;
            case ExchangeCostType.COST_GOLD:
                costLabel = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_4);
                break;
            case ExchangeCostType.COST_MEDAL:
                costLabel = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1);
                break;
            case ExchangeCostType.COST_TICKET:
                costLabel = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_2);
                break;
            case ExchangeCostType.COST_PROPS:
                if (_itemCfg)
                {
                    costLabel = _itemCfg.name;
                }
                break;
        }
        return costLabel;
    }

    private function onRemove(event:Event):void
    {
        removeEventListener(Event.REMOVED, onRemove);
        ToolTipManager.getInstance().detach(this);
        destroy();
    }
}