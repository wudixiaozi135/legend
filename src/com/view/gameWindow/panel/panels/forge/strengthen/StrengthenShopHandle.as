package com.view.gameWindow.panel.panels.forge.strengthen
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.NpcShopCfgData;
    import com.view.gameWindow.util.scrollBar.PageScrollBar;

    import flash.display.MovieClip;
    import flash.utils.Dictionary;

    public class StrengthenShopHandle
	{
		private var _tab:TabStrengthen;
		
		private var _npcId:int = 99;
		private var _cfgDts:Vector.<NpcShopCfgData>;
		private var _pageScrollBar:PageScrollBar;
		private var _page:int;
		private var _pageNum:int = 2;
		private var _pageTotal:int;
		
		private var _items:Vector.<ShopItem>;
		
		public function StrengthenShopHandle(tab:TabStrengthen)
		{
			_tab = tab;
			initialize();
		}
		
		private function initialize():void
		{
			_cfgDts = new Vector.<NpcShopCfgData>();
			var npcShopCfgDatas:Dictionary = ConfigDataManager.instance.npcShopCfgDatas(_npcId);
			var cfgDt:NpcShopCfgData;
			for each (cfgDt in npcShopCfgDatas) 
			{
				_cfgDts.push(cfgDt);
			}
			_cfgDts.sort(function (item1:NpcShopCfgData,item2:NpcShopCfgData):Number
			{
				return item1.rank - item2.rank;
			});
			_pageTotal = (_cfgDts.length + _pageNum - 1) / _pageNum;
			//
			_items = new Vector.<ShopItem>();
			var i:int;
			for (i=0;i<_pageNum;i++) 
			{
				var shopItem:ShopItem = new ShopItem(_tab,i+1);
				_items.push(shopItem);
			}
			//
			refreshData();
		}
		
		private function refreshData():void
		{
			var page:int,dtIndex:int,i:int;
			if(!_pageScrollBar)
			{
				page = 1;
			}
			else
			{
				page = _pageScrollBar.page
			}
			for (i=0;i<_pageNum;i++) 
			{
				dtIndex = (page-1)*_pageNum+i;
				if(dtIndex < _cfgDts.length)
				{
					_items[i].update(_cfgDts[dtIndex]);
				}
				else
				{
					_items[i].setNull();
				}
			}
		}
		
		public function initPageScrollBar(mc:MovieClip):void
		{
			_pageScrollBar = new PageScrollBar(mc,150,refreshData,_pageTotal);
		}
		
		public function destroy():void
		{
			var i:int;
			for (i=0;i<_pageNum;i++) 
			{
				_items[i].setNull();
			}
			_items = null;
			if(_pageScrollBar)
			{
				_pageScrollBar.destroy();
				_pageScrollBar = null;
			}
			_tab = null;
		}
	}
}

import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.configData.ConfigDataManager;
import com.model.configData.cfgdata.ItemCfgData;
import com.model.configData.cfgdata.NpcShopCfgData;
import com.model.consts.ConstPriceType;
import com.model.consts.ItemType;
import com.model.consts.StringConst;
import com.model.consts.ToolTipConst;
import com.view.gameWindow.panel.panels.forge.strengthen.TabStrengthen;
import com.view.gameWindow.tips.toolTip.ToolTipManager;
import com.view.gameWindow.util.HtmlUtils;

import flash.display.MovieClip;
import flash.display.Sprite;

class ShopItem
{
	private var _tab:TabStrengthen;
	
	private var _index:int;
	private var _url:String;
    private var _mcCostTip1:Sprite;
    private var _mcCostTip2:Sprite;
	public function ShopItem(tab:TabStrengthen,index:int)
	{
		_tab = tab;
		_index = index;

        var htmlTip:String = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1);
        var mc:MovieClip = _tab.skinThis.mcMaterialBuy.money1Icon;
        _mcCostTip1 = new Sprite();
        _mcCostTip1.graphics.beginFill(0xffffff, 0);
        _mcCostTip1.graphics.drawRect(0, 0, mc.width, mc.height);
        mc.addChild(_mcCostTip1);
        ToolTipManager.getInstance().attachByTipVO(_mcCostTip1, ToolTipConst.TEXT_TIP, htmlTip);

        mc = _tab.skinThis.mcMaterialBuy.money2Icon;
        _mcCostTip2 = new Sprite();
        _mcCostTip2.graphics.beginFill(0xffffff, 0);
        _mcCostTip2.graphics.drawRect(0, 0, mc.width, mc.height);
        mc.addChild(_mcCostTip2);
        ToolTipManager.getInstance().attachByTipVO(_mcCostTip2, ToolTipConst.TEXT_TIP, htmlTip);
        htmlTip = null;
	}
	
	public function update(npcShopCfgData:NpcShopCfgData):void
	{
		_tab.stone1Amount = 1;
		_tab.stone2Amount = 1;
		var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(npcShopCfgData.base);
		if(!itemCfg)
		{
			return;
		}
		var url:String = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + itemCfg.icon + ResourcePathConstants.POSTFIX_PNG;
		if(_url != url)
		{
			_url = url;
			_tab["stone"+_index+"Icon"].loadPicFromURL(_url);
		}
		_tab["stone"+_index+"Amount"] = 1;
		_tab["stone"+_index+"Icon"].tipType = ToolTipConst.SHOP_ITEM_TIP;
		ToolTipManager.getInstance().attach(_tab["stone"+_index+"Icon"]);
		_tab["stone"+_index+"Icon"].npcShopCfgData = npcShopCfgData;
		_tab.skinThis.mcMaterialBuy["stone"+_index+"AmountText"].text = "1";
		_tab.skinThis.mcMaterialBuy["stone"+_index+"NameText"].text = itemCfg.name;
		_tab.skinThis.mcMaterialBuy["stone"+_index+"NameText"].textColor = ItemType.getColorByQuality(itemCfg.quality);
		_tab.skinThis.mcMaterialBuy['stone'+_index+'PriceText'].text = npcShopCfgData.price_value;
		_tab.skinThis.mcMaterialBuy['money'+_index+'Icon'].resUrl = ConstPriceType.getResUrl(npcShopCfgData.price_type);
		_tab.skinThis.mcMaterialBuy['stone'+(_index+2)+'PriceText'].text = _tab.skinThis.mcMaterialBuy['stone'+_index+'PriceText'].text;
	}
	
	public function setNull():void
	{
		_url = "";
		_tab["stone"+_index+"Icon"].setNull();
		ToolTipManager.getInstance().detach(_tab["stone"+_index+"Icon"]);
		_tab.skinThis.mcMaterialBuy['stone'+_index+'PriceText'].text = "";
		_tab.skinThis.mcMaterialBuy['stone'+_index+'AmountText'].text = "";
		_tab.skinThis.mcMaterialBuy['stone'+(_index+2)+'PriceText'].text = _tab.skinThis.mcMaterialBuy['stone'+_index+'PriceText'].text;
	}
	
	public function destory():void
	{
        if (_mcCostTip1)
        {
            ToolTipManager.getInstance().detach(_mcCostTip1);
            if (_mcCostTip1.parent)
            {
                _mcCostTip1.parent.removeChild(_mcCostTip1);
                _mcCostTip1 = null;
            }
        }
        if (_mcCostTip2)
        {
            ToolTipManager.getInstance().detach(_mcCostTip2);
            if (_mcCostTip2.parent)
            {
                _mcCostTip2.parent.removeChild(_mcCostTip2);
                _mcCostTip2 = null;
            }
        }
		_url = "";
		_tab = null;
	}
}