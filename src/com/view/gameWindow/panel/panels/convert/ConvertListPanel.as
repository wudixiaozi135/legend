package com.view.gameWindow.panel.panels.convert
{
    import com.greensock.TweenLite;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.EquipExchangeCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.ButtonSelect;
    import com.view.gameWindow.common.CountCallback;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.common.ModelAnimBoard;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.cell.CellData;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.propertyParse.PropertyData;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
	 * @author wqhk
	 * 2014-8-28
	 */
	public class ConvertListPanel extends PanelBase implements IPanelTab
	{
		public static const NUM_ITEM:int = 10;
		public static const NUM_TAB:int =3;
		public static var DEFAULT_SELECTED_INDEX:int = -1;
		public static const ITEM_PREFIX:String = "item";
		public static const TAB_PREFIX:String = "tab";
		private var _tabList:ButtonSelect;
		private var _mc:McConvertListPanel;
		private var _itemList:ButtonSelect;
		private var _dataManager:ConvertDataManager;
		private var _selectedTabIndex:int;
//		private var _initAfterItemBtnLoadedHandler:bind_t = new bind_t(initAfterItemBtnLoaded);
//		private var _initAfterTabBtnLoadedHandler:bind_t = new bind_t(initAfterTabBtnLoaded);
		private var _initAfterItemBtnLoadedHandler:CountCallback;
		private var _initAfterTabBtnLoadedHandler:CountCallback;
		
		private var _grayFilter:ColorMatrixFilter;
		private var _animBoard:ModelAnimBoard;
		private var _centerIcon:IconCellEx;
		private var _iconAnim:TweenLite;
		
		private var _effectLoader:UIEffectLoader;
		private var _effectLoader2:UIEffectLoader;
		private var _unlock:UIUnlockHandler;
		private var _highlightEffect:HighlightEffectManager;
		public function ConvertListPanel()
		{
			super();
			
			_grayFilter = new ColorMatrixFilter();
			_grayFilter.matrix = [0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0,0,0,1,0];
			
			_initAfterItemBtnLoadedHandler = new CountCallback(initAfterItemBtnLoaded,NUM_ITEM+2);
			_initAfterTabBtnLoadedHandler = new CountCallback(initAfterTabBtnLoaded,NUM_TAB);
			_highlightEffect = new HighlightEffectManager();
		}
		
		public function setTabIndex(index:int):void
		{
			_tabList.selectedIndex = index;
			_selectedTabIndex = _tabList.selectedIndex;
			if(_itemList.selectedIndex>=0)
			{
				setSelectedItem(_itemList.selectedIndex,_selectedTabIndex);
			}
		}

		override public function setSelectTabShow(tabIndex:int = -1):void
		{
			setTabIndex(tabIndex);
		}

		public function getTabIndex():int
		{
			return _selectedTabIndex;
		}
		
		override public function destroy():void
		{
			if(_unlock)
			{
				_unlock.destroy();
				_unlock = null;
			}
			_dataManager.detach(this);
			_tabList.clear();
			_itemList.clear();
			if(_initAfterItemBtnLoadedHandler!=null)
			{
				_initAfterItemBtnLoadedHandler.destroy();
			}
			
			if(_initAfterTabBtnLoadedHandler != null)
			{
				_initAfterTabBtnLoadedHandler.destroy();
			}
			
			if(_animBoard)
			{
				_animBoard.destroy();
			}
			if(_effectLoader2)
			{
				_effectLoader2.destroy();
				_effectLoader2 = null;
			}
			
			clearCenterIcon();
			
			removeEventListener(MouseEvent.CLICK,clickHandler);
			_mc.needTxt.removeEventListener(TextEvent.LINK,needTxtLinkHandler);
			super.destroy();
		}
		
		override public function update(proc:int=0):void
		{
			if(_itemList.selectedIndex>=0)
			{
				setSelectedItem(_itemList.selectedIndex,_selectedTabIndex);
			}
		}
		
		override protected function initSkin():void
		{
			_mc = new McConvertListPanel();
			_skin = _mc;
			addChild(_skin);
			
			setTitleBar(_mc.mcTitleBar);
			
			_tabList = new ButtonSelect();
			_tabList.resetHandler = tabResetHandler;
			_tabList.selectHandler = tabSelectHandler;
			
			_itemList = new ButtonSelect();
			_itemList.resetHandler = btnResetHandler;
			_itemList.selectHandler = btnSelectHandler;
			
			
			addEventListener(MouseEvent.CLICK,clickHandler);
			_mc.needTxt.addEventListener(TextEvent.LINK,needTxtLinkHandler);
			
			_mc.desTxt.selectable = false;
			_mc.needTxt.selectable = false;
			
			_dataManager = ConvertDataManager.instance;
			
			_tabList.init([_mc.tab0,_mc.tab1,_mc.tab2]);
			_tabList.setSelected(_mc.tab0);
			_selectedTabIndex = _tabList.selectedIndex;
			
			_itemList.init([_mc.item0,_mc.item1,_mc.item2,_mc.item3,_mc.item4,_mc.item5,_mc.item6,_mc.item7,_mc.item8,_mc.item9]);
			_itemList.setSelected(_mc.item0);
			if(_effectLoader2)
			{
				_effectLoader2.destroy();
				_effectLoader2 = null;
			}
			_effectLoader2 = new UIEffectLoader(_mc.parent,_mc.bottom.x + 6 + _mc.x,_mc.bottom.y + _mc.y,1,1,EffectConst.RES_CONVERT_BOTTOM);
			
			
			_unlock = new UIUnlockHandler(getUnlockBtn);
			_unlock.updateUIStates([UnlockFuncId.CONVERT_LIST_RING,UnlockFuncId.CONVERT_LIST_SHIELD]);
		}
		
		private function getUnlockBtn(id:int):*
		{
			if(id == UnlockFuncId.CONVERT_LIST_RING)
			{
				return _mc.tab1;
			}
			else if(id == UnlockFuncId.CONVERT_LIST_SHIELD)
			{
				return _mc.tab2;
			}
			
			return null;
		}
		
		private function needTxtLinkHandler(e:TextEvent):void
		{
			var index:int = _itemList.selectedIndex;
			
			var list:Array = _dataManager.getListByIndex(_selectedTabIndex);
			
			if(e.text == EquipExchangeCfgDataUtils.SHENGWANG && index >= 0)
			{
				var data:EquipExchangeCfgData = list[index];
				var tab:int = data.link_tab;
				var open:OpenPanelAction = new OpenPanelAction(PanelConst.TYPE_BECOME_STRONGER,tab);
				open.act();
				return;
			}
			
			if(index>0)
			{
				setSelectedItem(index-1,_selectedTabIndex);
			}
		}
		
		public function setDetail(cfg:EquipExchangeCfgData,preCfg:EquipExchangeCfgData):void
		{
			clearCenterIcon();
			
			if(!cfg)
			{
				_mc.desTxt.htmlText = "";
				_mc.btnConvert.visible = false;
				_mc.btnBuy.visible = false;
				_mc.needTxt.htmlText = "";
				
				if(_animBoard)
				{
					_animBoard.destroy();
					_animBoard = null;
				}
				return;
			}
			var curItem:EquipCfgData = ConfigDataManager.instance.equipCfgData(cfg.id);
//			var propertys:Vector.<String> = CfgDataParse.getAttHtmlStringArray(curItem.attr,0);
//			_mc.desTxt.htmlText = propertys.join("<br/>");
			
			var propertys:Vector.<PropertyData> = CfgDataParse.getPropertyDatas(curItem.attr);
			var pTxt:String = "";
			var fight:Number = 0;
			for each(var p:PropertyData in propertys)
			{
				pTxt += CfgDataParse.propertyToStr(p,0,0xa56238)+"<br/>";
				fight += p.fightPower;
			}
			pTxt += HtmlUtils.createHtmlStr(0xa56238,StringConst.TIP_FIGHT+StringConst.COLON)+HtmlUtils.createHtmlStr(0xd5b300,int(fight).toString());
			_mc.desTxt.htmlText = pTxt;
			
			var canConvert:Boolean = _dataManager.canConvert(cfg.id);
			if(preCfg)
			{
				_mc.btnConvert.visible = true;
				if(canConvert)
				{
					_mc.btnConvert.mouseEnabled = true;
					_highlightEffect.show(_mc,_mc.btnConvert);
					_mc.btnConvert.filters = null;
				}
				else
				{
					_highlightEffect.hide(_mc.btnConvert);
					_mc.btnConvert.mouseEnabled = false;
					_mc.btnConvert.filters = [_grayFilter];
				}
				
				_mc.btnBuy.visible = false;
			}
			else
			{
				_mc.btnConvert.visible = false;
				
				if(_selectedTabIndex == 0 || _dataManager.isTypeGet(cfg.id))
				{
					_mc.btnBuy.visible =  false;
				}
				else
				{
					_mc.btnBuy.visible =  true;
				}
				_highlightEffect.hide(_mc.btnConvert);
			}
			
			_mc.needTxt.htmlText = EquipExchangeCfgDataUtils.getDes(cfg,preCfg);
			
//			if(!_animBoard)
//			{
//				_animBoard = new ModelAnimBoard(_mc.animPos);
//			}
//			_animBoard.setModel(EntityLayerManager.getInstance().firstPlayer.entityModel);
			
			var size:Rectangle = _dataManager.getIconSize(cfg.id);
			var startX:int = _mc.iconPos.x - size.width/2;
			var startY:int = _mc.iconPos.y - size.height/2;
			_effectLoader = new UIEffectLoader(_mc.parent,_mc.iconPos.x + _mc.x,_mc.iconPos.y + _mc.y,1,1,_dataManager.getIconUrl(cfg.id),function():void
			{
				if(_effectLoader.effect)
				{
					_effectLoader.effect.mouseEnabled = true;
					var tipVO:TipVO = new TipVO();
					tipVO.tipData = curItem;
					tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP;
					ToolTipManager.getInstance().hashTipInfo(_effectLoader.effect,tipVO);
					ToolTipManager.getInstance().attach(_effectLoader.effect);
					_iconAnim = TweenLite.to(_effectLoader.effect,1,{y:_mc.y + _mc.iconPos.y - 8,repeat:-1,onComplete:reverseTween, onReverseComplete:restartTween});
				}
			});	
		}
		
		private function clearCenterIcon():void
		{
			if(_centerIcon)
			{
				ToolTipManager.getInstance().detach(_centerIcon);
				
				_centerIcon.destroy();
				
				if(_centerIcon.parent)
				{
					_centerIcon.parent.removeChild(_centerIcon);
				}
				_centerIcon = null;
			}
			if(_effectLoader)
			{
				if( _effectLoader.effect)
				{
					ToolTipManager.getInstance().detach(_effectLoader.effect);
				}
				_effectLoader.destroy();
				_effectLoader = null;
			}
			if(_iconAnim)
			{
				_iconAnim.kill();
			}
		}
		
		private function reverseTween():void
		{
			if(_iconAnim)
			{
				_iconAnim.reverse();
			}
		}
		private function restartTween():void 
		{
			if(_iconAnim)
			{
				_iconAnim.restart();
			}
		}
		
		
		private function clickHandler(e:MouseEvent):void
		{
			var i:int = 0;
			var item:MovieClip;
			
			var list:Array;
			for(i = 0; i < NUM_TAB; ++i)
			{
				item = getTabBtn(i);
				if(item == e.target)
				{
					_tabList.setSelected(item);
					_selectedTabIndex = _tabList.selectedIndex;
					
					list = _dataManager.getListByIndex(_selectedTabIndex);
					setItemBtnList(list);
					
					setSelectedItem(0,_selectedTabIndex);
				}
			}
			
			for(i = 0; i < NUM_ITEM; ++i)
			{
				item = getItemBtn(i);
				if(item == e.target)
				{
					setSelectedItem(i,_selectedTabIndex);
				}
			}
			
			switch(e.target)
			{
				case _mc.btnBuy:
					PanelMediator.instance.openPanel(PanelConst.TYPE_CONVERT_START);
					break;
				case _mc.btnConvert:
					list = _dataManager.getListByIndex(_selectedTabIndex);
					var selectedIndex:int = _itemList.selectedIndex;
					var cfg:EquipExchangeCfgData = list[selectedIndex];
					if(_dataManager.canConvert(cfg.id))
					{
						var cell:CellData = _dataManager.getCell(cfg);
						_dataManager.requestConvert(cell.storageType,cell.slot);
					}
					break;
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_CONVERT_LIST);
					break;
			}
		}
		
		public function setSelectedItem(itemIndex:int,selectedTabIndex:int):void
		{
			var item:MovieClip = getItemBtn(itemIndex);
			
			_itemList.setSelected(item);
			var list:Array = _dataManager.getListByIndex(selectedTabIndex);
			
			if(!list || list.length == 0)
			{
				setDetail(null,null);
				return;
			}
			
			var equipExc:EquipExchangeCfgData = list[itemIndex];
			var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipExc.id);
			var preEquipExc:EquipExchangeCfgData = _dataManager.getPreData(itemIndex,list);
			setDetail(equipExc,preEquipExc);
		}
		
		
			
		private function initAfterItemBtnLoaded(...args):void
		{
			//+两个button
//			if(args.length == NUM_ITEM+2)
//			{
				_itemList.init([_mc.item0,_mc.item1,_mc.item2,_mc.item3,_mc.item4,_mc.item5,_mc.item6,_mc.item7,_mc.item8,_mc.item9]);
				
				var list:Array = _dataManager.getListByIndex(_selectedTabIndex);
				setItemBtnList(list);
				
				if(DEFAULT_SELECTED_INDEX == -1)
					setSelectedItem(0,_selectedTabIndex);
				else
					setSelectedItem(DEFAULT_SELECTED_INDEX,_selectedTabIndex);
				
				_dataManager.attach(this);
//			}
		}
		
		private function initAfterTabBtnLoaded(...args):void
		{
//			if(args.length == NUM_TAB)
//			{
				_mc.tab0.txt.text = StringConst.CONVERT_002;
				_mc.tab1.txt.text = StringConst.CONVERT_003;
				_mc.tab2.txt.text = StringConst.CONVERT_004;
				_tabList.init([_mc.tab0,_mc.tab1,_mc.tab2]);
//			}
		}
		
		public function setItemBtnList(list:Array):void
		{
			for(var i:int = 0; i < NUM_ITEM; ++i)
			{
				var btn:MovieClip = getItemBtn(i);
				if(i<list.length)
				{
					var cfg:EquipExchangeCfgData = list[i];
					var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(cfg.id);
					btn.visible = true;
					btn.label.htmlText = HtmlUtils.createHtmlStr(0x675138,equip.name,14,true,0);
				}
				else
				{
					btn.visible = false;
				}
			}
		}
		
		public function tabResetHandler(btn:MovieClip):void
		{
			if(btn.txt)
			{
				btn.txt.textColor = 0x675138;
			}
		}
		
		public function tabSelectHandler(btn:MovieClip):void
		{
			if(btn.txt)
			{
				btn.txt.textColor = 0xffe1aa;
			}
		}
		
		public function btnResetHandler(btn:MovieClip):void
		{
			if(btn.label)
			{
				btn.label.textColor = 0x675138;
				btn.label.filters = null;
			}
		}
		
		public function btnSelectHandler(btn:MovieClip):void
		{
			if(btn.label)
			{
				btn.label.textColor = 0xffe1aa;
				btn.label.filters = [new GlowFilter(0xc00000,0.8,6,6,4)];
			}
		}
		
		public function getItemBtn(index:int):MovieClip
		{
			return _mc[ITEM_PREFIX+index];
		}
		
		public function getTabBtn(index:int):MovieClip
		{
			return _mc[TAB_PREFIX+index];
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var i:int;
			for(i = 0; i < NUM_ITEM; ++i)
			{
				rsrLoader.addCallBack(getItemBtn(i),function():void{
					_initAfterItemBtnLoadedHandler.call();
				});
			}
			
			rsrLoader.addCallBack(_mc.btnConvert,function():void{
				_initAfterItemBtnLoadedHandler.call();
			});
			
			rsrLoader.addCallBack(_mc.btnBuy,function():void{
				_mc.btnBuy.txt.text = StringConst.CONVERT_001;
				_initAfterItemBtnLoadedHandler.call();
			});
			
			for(i = 0; i < NUM_TAB; ++i)
			{
				rsrLoader.addCallBack(getTabBtn(i),function(mc:MovieClip):void{
					_initAfterTabBtnLoadedHandler.call();
				})
			}
		}

        override public function setPostion():void
        {
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.ringUpBtn.x, mc.ringUpBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }
	}
}