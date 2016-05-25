package com.view.gameWindow.panel.panels.keyBuy
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.NpcShopCfgData;
    import com.model.consts.ConstPriceType;
    import com.model.consts.GameConst;
    import com.model.consts.ItemType;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.SysAlertHandle;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.welfare.OpenDayConsts;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;

    /**
	 * 一键买药面板
	 * @author Administrator
	 */	
	public class KeyBuyPanel extends PanelBase implements IKeyBuyPanel
	{
		private var _clickHandle:MouseEventHandle;
		private var _dataArr:Vector.<NpcShopCfgData>;
		public static var HOR:int=GameConst.ROLE;
		public static var TYPE:int = 0;
		private var vectorCell:Vector.<MovieClip>;
		private var _btnHightLight:HighlightEffectManager;
        private var _tipsArr:Vector.<Sprite>;
		public function KeyBuyPanel()
		{
			super();
			_btnHightLight = new HighlightEffectManager();
		}
		override protected function initSkin():void
		{
            _tipsArr = new Vector.<Sprite>();
			_skin = new McKeyBuyPanel();
			addChild(_skin);
			_clickHandle = new MouseEventHandle();
			_clickHandle.mouseEventHandle(_skin as McKeyBuyPanel,this);
			initText();
			setTitleBar((_skin as McKeyBuyPanel).dragCell);
		}
		
		private function initText():void
		{
			var i:int;
			var tipVO:TipVO;
			var _txtFormat:TextFormat;
			var dic:Dictionary;
			var npcShopCfhData:NpcShopCfgData;
			var itemCfgData:ItemCfgData;
			var itemDataArr:Vector.<ItemCfgData> = new Vector.<ItemCfgData>();
			var dataArr:Vector.<NpcShopCfgData> = new Vector.<NpcShopCfgData>();
			var mcKeyBuyPanel:McKeyBuyPanel = _skin as McKeyBuyPanel;
			var vectorTitle:Vector.<TextField> = searchText(mcKeyBuyPanel,"titleText_",0,10,2);
			var vectorDesc:Vector.<TextField> = searchText(mcKeyBuyPanel,"contentText_",0,12,2);
			var vectorLevel:Vector.<TextField> = searchText(mcKeyBuyPanel,"levelNum_",0,9,2);
			var vectorPrice:Vector.<TextField> = searchText(mcKeyBuyPanel,"numText_",0,8,2);
			vectorCell = Vector.<MovieClip>([mcKeyBuyPanel.Cell_00,mcKeyBuyPanel.Cell_01,mcKeyBuyPanel.Cell_02,mcKeyBuyPanel.Cell_03]);
			var loadIcon:LoadIcon;
			
			_dataArr = dataArr;
			var bagId:int=getBagId();
			
			dic = ConfigDataManager.instance.npcShopCfgDatas(bagId);
			
			for each(npcShopCfhData in dic)
			{
				dataArr.push(npcShopCfhData);
			}
			dataArr.sort(dataArrSortFunc);
			for each(npcShopCfhData in dataArr)
			{
				itemCfgData = ConfigDataManager.instance.itemCfgData(npcShopCfhData.base);
				itemDataArr.push(itemCfgData);
			}
			_txtFormat = mcKeyBuyPanel.nameText.defaultTextFormat;
			_txtFormat.bold = true;
			mcKeyBuyPanel.nameText.defaultTextFormat = _txtFormat;
			mcKeyBuyPanel.nameText.setTextFormat(_txtFormat);
			mcKeyBuyPanel.nameText.text = StringConst.KEY_BUY_PANEL_0001;
			mcKeyBuyPanel.levelText.text = StringConst.KEY_BUY_PANEL_0008;
			mcKeyBuyPanel.priceText.text = StringConst.KEY_BUY_PANEL_0009;
			
			for(i=0;i<dataArr.length;i++)
			{
				vectorTitle[i].textColor = ItemType.getColorByQuality(itemDataArr[i].quality);
				vectorTitle[i].text = itemDataArr[i].name;
				var descs:Array = CfgDataParse.pareseDes(itemDataArr[i].desc_short);
				var ii:int,l:int = descs.length,htmlText:String = "";
				for(ii=0;ii<l;ii++)
				{
					htmlText += descs[ii];
				}
				vectorDesc[i].htmlText = htmlText;
				vectorLevel[i].text = String(itemDataArr[i].level);
				vectorPrice[i].text = String(dataArr[i].price_value);
                var mcMoneyIcon:MovieClip = mcKeyBuyPanel["moneyIcon" + i];
                if (mcMoneyIcon.hasOwnProperty("resUrl"))
				{
                    mcMoneyIcon.resUrl = ConstPriceType.getResUrl(dataArr[i].price_type);
                    var sp:Sprite = new Sprite();
                    sp.graphics.beginFill(0xffffff, 0);
                    sp.graphics.drawRect(0, 0, mcMoneyIcon.width, mcMoneyIcon.height);
                    sp.graphics.endFill();
                    mcMoneyIcon.addChild(sp);
                    ToolTipManager.getInstance().attachByTipVO(sp, ToolTipConst.TEXT_TIP, getCostLabel(dataArr[i].price_type));
                    _tipsArr[i] = sp;
				}
			}
			for(var j:int = 0;j<itemDataArr.length;j++)
			{
				tipVO = new TipVO();
				loadIcon = new LoadIcon();
				loadIcon.load(vectorCell[j],itemDataArr[j].icon);
				if(dataArr[j].type == ToolTipConst.EQUIP_BASE_TIP)
				{
					tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP;
					tipVO.tipData = ConfigDataManager.instance.equipCfgData(dataArr[j].base);
				}
				else if(dataArr[j].type == ToolTipConst.ITEM_BASE_TIP)
				{
					tipVO.tipType = ToolTipConst.ITEM_BASE_TIP;
					tipVO.tipData = ConfigDataManager.instance.itemCfgData(dataArr[j].base);
				}
				ToolTipManager.getInstance().hashTipInfo(vectorCell[j],tipVO);
				ToolTipManager.getInstance().attach(vectorCell[j]);
			}
		}

        private function getCostLabel(priceType:int):String
        {
            switch (priceType)
            {
                case 1:
                    return HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_4);
                case 2:
                    return HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_5);
                case 3:
                    return HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1);
                case 4:
                    return HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_2);
            }
            return "";
        }
		private function dataArrSortFunc(a:NpcShopCfgData,b:NpcShopCfgData):int
		{
			if(a.rank<b.rank)
			{
				return -1;
			}
			return 1;
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McKeyBuyPanel = _skin as McKeyBuyPanel;
			var _textFormat:TextFormat = new TextFormat();
			rsrLoader.addCallBack(mc.buyBtn_00,function ():void
			{
				
				_textFormat = mc.buyBtn_00.txt.defaultTextFormat;
				mc.buyBtn_00.txt.defaultTextFormat = _textFormat;
				mc.buyBtn_00.txt.setTextFormat(_textFormat);
				mc.buyBtn_00.txt.text = StringConst.KEY_BUY_PANEL_0010;
				mc.buyBtn_00.txt.textColor = 0xffe1aa;
				if(TYPE == SysAlertHandle.HP){
					_btnHightLight.show(mc, mc.buyBtn_00);
				}
				
				InterObjCollector.instance.add(mc.buyBtn_00,PanelConst.TYPE_BAG_KEYBUY);
			});
			rsrLoader.addCallBack(mc.buyBtn_01,function ():void
			{
				mc.buyBtn_01.txt.setTextFormat(_textFormat);
				mc.buyBtn_01.txt.text = StringConst.KEY_BUY_PANEL_0010;
				mc.buyBtn_01.txt.textColor = 0xffe1aa;
				if(TYPE == SysAlertHandle.MP){
					_btnHightLight.show(mc, mc.buyBtn_01);
				}
				InterObjCollector.instance.add(mc.buyBtn_01,PanelConst.TYPE_BAG_KEYBUY);
			});
			rsrLoader.addCallBack(mc.buyBtn_02,function ():void
			{
				mc.buyBtn_02.txt.setTextFormat(_textFormat);
				mc.buyBtn_02.txt.text = StringConst.KEY_BUY_PANEL_0010;
				mc.buyBtn_02.txt.textColor = 0xffe1aa;
				InterObjCollector.instance.add(mc.buyBtn_02,PanelConst.TYPE_BAG_KEYBUY);
			});
			rsrLoader.addCallBack(mc.buyBtn_03,function ():void
			{
				mc.buyBtn_03.txt.setTextFormat(_textFormat);
				mc.buyBtn_03.txt.text = StringConst.KEY_BUY_PANEL_0010;
				mc.buyBtn_03.txt.textColor = 0xffe1aa;
				InterObjCollector.instance.add(mc.buyBtn_03,PanelConst.TYPE_BAG_KEYBUY);
			});
		}
		
		private function getBagId():int
		{
			var lv:int=0;
			var day:int = WelfareDataMannager.instance.openServiceDay;
			if(HOR==GameConst.ROLE)
			{	
				lv=RoleDataManager.instance.lv;
				if(lv>0&&lv<50)
				{
					return 11;
				}
				if(lv>=50&&lv<70)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						return 11;
					}
					return 12;
				}
				if(lv>=70)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						return 11;
					}
					else if(day+1<OpenDayConsts.SECOND)
					{
						return 12;
					}
					return 13;
				}
			}
			else
			{
				lv=HeroDataManager.instance.lv;
				if(lv>0&&lv<50)
				{
					return 21;
				}
				if(lv>=50&&lv<70)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						return 21;
					}
					return 22;
				}
				if(lv>=70)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						return 21;
					}
					else if(day+1<OpenDayConsts.SECOND)
					{
						return 22;
					}
					return 23;
				}
			}
			return 0;
		}
		
		public function get dataArr():Vector.<NpcShopCfgData>
		{
			return _dataArr;
		}
		
		public function hideEffect():void
		{
			if(_btnHightLight)
			{
				_btnHightLight.hide(_skin.buyBtn_00);
				_btnHightLight.hide(_skin.buyBtn_01);
			}
		}
		
		override public function destroy():void
		{
            if (_tipsArr)
            {
                _tipsArr.forEach(function (element:Sprite, index:int, vec:Vector.<Sprite>):void
                {
                    ToolTipManager.getInstance().detach(element);
                    if (element.parent)
                    {
                        element.parent.removeChild(element);
                    }
                    element = null;
                });
                _tipsArr.length = 0;
                _tipsArr = null;
            }
			if(_clickHandle)
			{
				_clickHandle.destoryEvent();
				_clickHandle = null;
			}
			if(vectorCell)
			{
				for each(var mc:MovieClip in vectorCell)
				{
					ToolTipManager.getInstance().detach(mc);
				}
				vectorCell = null;
			}
			if(_btnHightLight)
			{
				_btnHightLight.hide(_skin.buyBtn_00);
			}
			
			InterObjCollector.instance.removeByGroupId(PanelConst.TYPE_BAG_KEYBUY);
			_dataArr = null;
			super.destroy();
		}
	}
}