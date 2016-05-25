package com.view.gameWindow.panel.panels.convert
{
    import com.greensock.TweenLite;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.EquipExchangeCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.common.ButtonSelect;
    import com.view.gameWindow.common.CountCallback;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.common.ModelAnimBoard;
    import com.view.gameWindow.common.MouseOverEffectManager;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.mainUi.subuis.onlineReward.OnlineRewardDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
    import com.view.gameWindow.panel.panels.guideSystem.constants.GuidesID;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.NumUtil;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UtilNumChange;
    import com.view.gameWindow.util.cell.CellData;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.propertyParse.PropertyData;
    import com.view.gameWindow.util.scrollBar.IScrollee;
    import com.view.gameWindow.util.scrollBar.ScrollBar;
    import com.view.gameWindow.util.tabsSwitch.ITabBase;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    
    import mx.utils.StringUtil;

    public class ConvertListPanelNew extends PanelBase implements ITabBase,IScrollee
	{
		public static const NUM_TAB:int =3;
		public static const NUM_ITEM:int = 10;
		public static const MAX_STAR:int = 5;
		public static const TAB_PREFIX:String = "tab";
		private static const PROGRESS_WIDTH:int = 625;
		public static var DEFAULT_SELECTED_INDEX:int = -1;
		private var _tabList:ButtonSelect;
		private var _itemList:Vector.<ConvertListItem>;
		private var _mc:McConvertListPanel;
		private var _dataManager:ConvertDataManager;
		private var _selectedTabIndex:int;
		private static const DESC_LIST:Array = [StringConst.PANEL_CONVERT_DESC1,StringConst.PANEL_CONVERT_DESC3,StringConst.PANEL_CONVERT_DESC2];
//		private var _initAfterItemBtnLoadedHandler:CountCallback;
		private var _initAfterTabBtnLoadedHandler:CountCallback;
		
		private var _grayFilter:ColorMatrixFilter;
		private var _animBoard:ModelAnimBoard;
		private var _iconAnim:TweenLite;
		
		private var _effectLoader:UIEffectLoader;
		private var _unlock:UIUnlockHandler;
		private var _highlightEffect:HighlightEffectManager;
		
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var activeOK:Boolean = false;
		private var needEffectActive:Boolean;
		private var getOk:Boolean = false;
		private var needEffectGet:Boolean;
		
		private var _overEffectManager:MouseOverEffectManager;
		
		private var _listCtner:MovieClip;
		
		public function ConvertListPanelNew()
		{
			super();
			_grayFilter = new ColorMatrixFilter();
			_grayFilter.matrix = [0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0,0,0,1,0];
			
//			_initAfterItemBtnLoadedHandler = new CountCallback(initAfterItemBtnLoaded,1);
			_initAfterTabBtnLoadedHandler = new CountCallback(initAfterTabBtnLoaded,NUM_TAB);
            OnlineRewardDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
		}
		
		public function setTabIndex(index:int):void
		{
			_tabList.selectedIndex = index;
			_selectedTabIndex = _tabList.selectedIndex;
//			if(_itemList.selectedIndex>=0)
//			{
//				setSelectedItem(_itemList.selectedIndex,_selectedTabIndex);
//			}
			updateList(index);
		}
		
		override public function setSelectTabShow(tabIndex:int = -1):void
		{
			setTabIndex(tabIndex);
		}
		
		public function getTabIndex():int
		{
			return _selectedTabIndex;
		}
		
		public function get listContentHeight():Number
		{
			if(_itemList && _itemList.length>0)
			{
				return _itemList.length*(_itemList[0].height+15)+3-15;
			}
			
			return 0;
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
		
		public function clearList():void
		{
			if(_itemList && _itemList.length>0)
			{
				for each(var item:ConvertListItem in _itemList)
				{
					_overEffectManager.remove(item);
					if(item.parent)
					{
						item.parent.removeChild(item);
					}
					item.destroy();
				}
			}
			ToolTipManager.getInstance().detach(_mc.txtDesc);
			_itemList = null;
		}
		
		public function updateList(index:int):void
		{
			clearList();
			
//			var data:Vector.<EquipExchangeCfgData> = TaskBossDataManager.instance.listData;
			var _data:Vector.<EquipExchangeCfgData> = _dataManager.getListByIndex(_selectedTabIndex);
			_itemList = new Vector.<ConvertListItem>();
//			lastSelect = 0;
			_overEffectManager = new MouseOverEffectManager(1,180,60);
			for(var i:int = 0; i < _data.length; i++)
			{
				var cell:ConvertListItem = new ConvertListItem(setSelectedItem,i,_selectedTabIndex);
				cell.data = _data[i];
				cell.x = 3;
				cell.y = 3+i*cell.height+i*15;
				_itemList.push(cell);
				_listCtner.addChild(cell);
				cell.initView();
				_overEffectManager.add(cell);
			}
            var sindex:int = 0;
            sindex = DEFAULT_SELECTED_INDEX == -1 ? 0 : DEFAULT_SELECTED_INDEX;
			if(_selectedTabIndex==0)
				sindex = sindex>9?9:sindex;
			else if(_selectedTabIndex == 1)
				sindex = sindex>4?4:sindex;
			setSelectedItem(sindex,_selectedTabIndex,true);
			_overEffectManager.setSelected(_itemList[sindex],true);
			resetScrollBar();
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			var htmlStrArr:Array = CfgDataParse.pareseDes(_dataManager.getDesc(_selectedTabIndex),0xffffff);
			var str:String = "";
			for(i = 0;i<htmlStrArr.length;i++){
				str+=htmlStrArr[i]+"\n";
			}
			tipVO.tipData = HtmlUtils.createHtmlStr(0xa56238,str,12,false,6);
			ToolTipManager.getInstance().hashTipInfo(_mc.txtDesc,tipVO);
			ToolTipManager.getInstance().attach(_mc.txtDesc);
		}
		
		public function resetScrollBar():void
		{
			if(_scrollBar)
			{
//				var old:int = _scrollBar.scrollRectY;
				var _data:Vector.<EquipExchangeCfgData> = _dataManager.getListByIndex(_selectedTabIndex);
				if(_data.length<7)
				{
					_mc.mcScrollBar.visible = false;
				}else{
					_mc.mcScrollBar.visible = true;
				}
				_scrollBar.resetScroll();
//				scrollTo(old);
			}
		}
		
		
		override public function destroy():void
		{
			clearGuide();
			InterObjCollector.instance.removeByGroupId(PanelConst.TYPE_CONVERT_LIST);
            OnlineRewardDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			if(_unlock)
			{
				_unlock.destroy();
				_unlock = null;
			}
			_dataManager.detach(this);
			_tabList.clear();
//			_itemList.clear();
//			if(_initAfterItemBtnLoadedHandler!=null)
//			{
//				_initAfterItemBtnLoadedHandler.destroy();
//			}
			if(_initAfterTabBtnLoadedHandler != null)
			{
				_initAfterTabBtnLoadedHandler.destroy();
			}
			
			if(_animBoard)
			{
				_animBoard.destroy();
			}
			
			clearCenterIcon();
			clearList();
			removeEventListener(MouseEvent.CLICK,clickHandler);
//			_mc.needTxt.removeEventListener(TextEvent.LINK,needTxtLinkHandler);
			super.destroy();
		}
		
		override public function update(proc:int=0):void
		{
//			if(_itemList.selectedIndex>=0)
//			{
//				setSelectedItem(_itemList.selectedIndex,_selectedTabIndex);
//			}
			if(proc == GameServiceConstants.CM_EQUIP_EXCHANGE)
			{
				var cfg:EquipExchangeCfgData  = ConfigDataManager.instance.equipExchangeCfgData(RoleDataManager.instance.getFireHeartId(_selectedTabIndex));
				if(!cfg)
					ConvertListPanelNew.DEFAULT_SELECTED_INDEX = 0;
				else if(cfg.step>0)
				{
					if(cfg.current_star<MAX_STAR)
						ConvertListPanelNew.DEFAULT_SELECTED_INDEX = cfg.step-1;
					else
						ConvertListPanelNew.DEFAULT_SELECTED_INDEX = cfg.step;
					if(cfg.current_star!=1)
					{
						Alert.reward(StringUtil.substitute(StringConst.CONVERT_026,cfg.name,NumUtil.getNUM(cfg.current_star)+StringConst.TASK_STAR_PANEL_0018));
					}else
					{
						Alert.reward(StringUtil.substitute(StringConst.CONVERT_027,cfg.name));
					}
					Alert.message(StringUtil.substitute(StringConst.CONVERT_029,cfg.name,cfg.current_star,cfg.coin));
				}
				else
				{
					var str:String = cfg.id.toString();
					ConvertListPanelNew.DEFAULT_SELECTED_INDEX = int(str.charAt(str.length-3));
					Alert.reward(StringUtil.substitute(StringConst.CONVERT_027,cfg.name));
					Alert.message(StringUtil.substitute(StringConst.CONVERT_029,cfg.name,cfg.current_star,cfg.coin));
				}
				updateList(_tabList.selectedIndex);
				showNum();
            }else if(proc == GameServiceConstants.SM_ACTIVATE_REWARD_GET)
            {
                checkActive(0);
                updateList(_tabList.selectedIndex);
				showNum();
            }else if(proc == GameServiceConstants.SM_BAG_ITEMS)
			{
				showNum();
			}
		}
		
		public static const HEIGHT:int = 442;
		public static const WIDTH:int = 205;
		
		override protected function initSkin():void
		{
			_mc = new McConvertListPanel();
			_skin = _mc;
			addChild(_skin);
			
			setTitleBar(_mc.mcTitleBar);
			
			_listCtner = _mc.list;
			
			_mc.effectMc.alpha= 0;
			
			_scrollRect = new Rectangle(0,0,WIDTH,HEIGHT);
			_listCtner.scrollRect = _scrollRect;
			
			_highlightEffect = new HighlightEffectManager();
			
			_tabList = new ButtonSelect();
			_tabList.resetHandler = tabResetHandler;
			_tabList.selectHandler = tabSelectHandler;
			
			_itemList = new Vector.<ConvertListItem>();
			
			_mc.curInfo.mouseEnabled = false;
			_mc.curName.mouseEnabled = false;
			_mc.nextInfo.mouseEnabled = false;
			_mc.nextName.mouseEnabled = false;
			_mc.needCoin.mouseEnabled = false;
			_mc.needItem.mouseEnabled = false;
			_mc.needLv.mouseEnabled = false;
			_mc.needMerit.mouseEnabled = false;
			_mc.txtItem.mouseEnabled = false;
			_mc.txtDesc.selectable = false;
			_mc.txtMerit.mouseEnabled = false;
			_mc.txtGet.mouseEnabled = false;

            _mc.txtActive.mouseEnabled = false;
            _mc.txtActive.text = StringConst.CONVERT_0008;//激活

			addEventListener(MouseEvent.CLICK,clickHandler);
			
			_dataManager = ConvertDataManager.instance;
			
			_tabList.init([_mc.tab0,_mc.tab1,_mc.tab2]);
			_tabList.setSelected(_mc.tab0);
			_selectedTabIndex = _tabList.selectedIndex;
			
			
			_unlock = new UIUnlockHandler(getUnlockBtn);
			_unlock.updateUIStates([UnlockFuncId.CONVERT_LIST_RING,UnlockFuncId.CONVERT_LIST_SHIELD]);
		}

        public function checkActive(id:int):void
        {
            var dataManager:OnlineRewardDataManager = OnlineRewardDataManager.instance;
            var isFireActive:int = dataManager.activeFire;
            var isShieldActive:int = dataManager.activeShield;

//            var activeId:int = dataManager.getRewardId();
            if (isFireActive == 1 && _selectedTabIndex == 0)
            {
                _mc.btnActive.visible = true;
                _mc.txtActive.visible = true;
				if(activeOK)
					_highlightEffect.show(_mc,_mc.btnActive);
				else
					needEffectActive = true;
				checkGuideActive(true);
            } else if (isShieldActive == 1 && _selectedTabIndex == 1)
            {
                _mc.btnActive.visible = true;
                _mc.txtActive.visible = true;
				if(activeOK)
					_highlightEffect.show(_mc,_mc.btnActive);
				else
					needEffectActive = true;
				checkGuideActive(true);
            } else
            {
                _mc.btnActive.visible = false;
                _mc.txtActive.visible = false;
				_highlightEffect.hide(_mc.btnActive);
				checkGuideActive(false);
            }
        }
		
		private var lastActive:Boolean = false;
		private function checkGuideActive(isActive:Boolean):void
		{
			if(isActive)
			{
				if(!guideActive)
				{
					guideActive = GuideSystem.instance.createAction(GuidesID.CONVERT_LIST_ACTIVIE);
					if(guideActive)
					{
						guideActive.init();
						guideActive.act();
					}
				}
				
				if(guideClose)
				{
					guideClose.destroy();
					guideClose = null;
				}
				
				lastActive = true;
			}
			else
			{
				if(guideActive)
				{
					guideActive.destroy();
					guideActive = null;
				}
				
				if(!guideClose && lastActive)
				{
					guideClose = GuideSystem.instance.createAction(GuidesID.CONVERT_LIST_CLOSE);
					if(guideClose)
					{
						guideClose.init();
						guideClose.act();
					}
				}
			}
		}
		
		private function clearGuide():void
		{
			if(guideActive)
			{
				guideActive.destroy();
				guideActive = null;
			}
			
			if(guideClose)
			{
				guideClose.destroy();
				guideClose = null;
			}
		}
		
		private var guideActive:GuideAction;
		private var guideClose:GuideAction;
		
		private function getUnlockBtn(id:int):*
		{
			if(id == UnlockFuncId.CONVERT_LIST_RING)
			{
				return _mc.tab2;
			}
			else if(id == UnlockFuncId.CONVERT_LIST_SHIELD)
			{
				return _mc.tab1;
			}
			
			return null;
		}
		
		private function needTxtLinkHandler(e:TextEvent):void
		{
			
		}
		
		public function setDetail(cfg:EquipExchangeCfgData,preCfg:EquipExchangeCfgData):void
		{
			clearCenterIcon();
			if(!cfg)
			{
//				_mc.desTxt.htmlText = "";
				_mc.buqianBtn.visible = false;
				_mc.txtGet.visible = false;
//				_mc.btnBuy.visible = false;
//				_mc.needTxt.htmlText = "";
				_mc.txtDesc.visible = false;
				if(_animBoard)
				{
					_animBoard.destroy();
					_animBoard = null;
				}
				return;
			}
			var curId:int = RoleDataManager.instance.getFireHeartId(_selectedTabIndex);
			var curCfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(curId);
			var curItem:EquipCfgData = ConfigDataManager.instance.equipCfgData(cfg.id);
			//			var propertys:Vector.<String> = CfgDataParse.getAttHtmlStringArray(curItem.attr,0);
			//			_mc.desTxt.htmlText = propertys.join("<br/>");
			
			var propertys:Vector.<PropertyData> = CfgDataParse.getPropertyDatas(curItem.attr);
			var pTxt:String = "";
			for each(var p:PropertyData in propertys)
			{
				pTxt += CfgDataParse.propertyToStr(p,0,0xa56238,0x00ff00,true,true)+"<br/>";
			}
			_mc.nextName.text = curItem.name;
			_mc.nextInfo.htmlText = pTxt;
			_mc.txtDesc.visible = true;
			_mc.txtDesc.text = DESC_LIST[_selectedTabIndex];
			_mc.txtItem.text = StringConst.CONVERT_010;
			var numChange:UtilNumChange = new UtilNumChange();
			var canConvert:Boolean = _dataManager.canConvert(cfg.id,_selectedTabIndex);
			if(preCfg)
			{
				_mc.buqianBtn.visible = true;
				_mc.txtGet.visible= true;
				if(canConvert)
				{
					_mc.buqianBtn.mouseEnabled = true;
					_mc.buqianBtn.filters = null;
					if(getOk)
						_highlightEffect.show(_mc,_mc.buqianBtn);
					else
						needEffectGet = true;
				}
				else
				{
					_highlightEffect.hide(_mc.buqianBtn);
					_mc.buqianBtn.mouseEnabled = false;
					_mc.buqianBtn.filters = [_grayFilter];
				}
				_mc.info.visible = true;
				_mc.curInfo.visible =true;
				_mc.curName.visible =true;
				_mc.nextInfo.visible =true;
				_mc.nextName.visible =true;
//				_mc.btnBuy.visible = false;
				
				var nextEquipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(preCfg.id);
				propertys.length = 0;
				propertys = CfgDataParse.getPropertyDatas(nextEquipCfg.attr);
				pTxt = "";
				for each(p in propertys)
				{
					pTxt += CfgDataParse.propertyToStr(p,0,0xa56238)+"<br/>";
				}
				_mc.curName.text = nextEquipCfg.name;
				_mc.curInfo.htmlText = pTxt;
				_mc.needItem.text = ConfigDataManager.instance.equipCfgData(preCfg.id).name;
				_mc.needLv.text = preCfg.player_reincarn+StringConst.ROLE_PROPERTY_PANEL_0071+preCfg.player_level+StringConst.ROLE_PROPERTY_PANEL_0072;
				if(preCfg.player_reincarn==0)
				{
					_mc.needLv.text = preCfg.player_level+StringConst.ROLE_PROPERTY_PANEL_0072;
				}
				_mc.needLv.textColor = (RoleDataManager.instance.reincarn>curCfg.player_reincarn||
					RoleDataManager.instance.reincarn==curCfg.player_reincarn && RoleDataManager.instance.lv>=curCfg.player_level)?0xffe1aa:0xff0000;
				_mc.needCoin.text = numChange.changeNum(preCfg.coin);
				var coin:Number = BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind;
				_mc.needCoin.textColor = coin>=preCfg.coin?0xffe1aa:0xff0000;
				var num:Number = RoleDataManager.instance.reputation;
				_mc.needMerit.text = numChange.changeNum(num)+"/"+numChange.changeNum(preCfg.zhuangyuanshengwang);
				_mc.needMerit.textColor = num>=preCfg.zhuangyuanshengwang?0xffe1aa:0xff0000;
			}
			else
			{
				_mc.buqianBtn.visible = false;
				_mc.txtGet.visible = false;
				_mc.info.visible = false;
				_mc.curInfo.visible =false;
				_mc.curName.visible =false;
				_mc.nextInfo.visible =false;
				_mc.nextName.visible =false;
				_mc.needItem.text = curItem.name;
				_mc.needLv.text = "???";
				_mc.needLv.textColor = 0xffe1aa;
				_mc.needCoin.text = "???";
				_mc.needCoin.textColor = 0xffe1aa;
				num = RoleDataManager.instance.reputation;
				_mc.needMerit.text = "???"+"/"+"???";
				_mc.needMerit.textColor = 0xffe1aa;
				if(curCfg)
				{
					_highlightEffect.hide(_mc.buqianBtn);
				}
				if(curId>cfg.id||(curId==cfg.id&&curCfg.current_star == MAX_STAR))
				{
					_mc.needLv.text = "-";
					_mc.needCoin.text = "-";
					_mc.needMerit.text = "-";
				}
			}
			if(cfg.shendunzhili!=0)
			{
				_mc.txtItem.text = StringConst.PANEL_CONVERT_DUNPAIZHILI;
				if(!preCfg)
				{
					_mc.needMerit.text = "???"+"/"+"???";
					_mc.needMerit.textColor = 0xffe1aa;
					if(curId>cfg.id||(curId==cfg.id&&curCfg.current_star == MAX_STAR))
					{
						_mc.needLv.text = "-";
						_mc.needCoin.text = "-";
						_mc.needMerit.text = "-";
					}
				}
				else
				{
					num = RoleDataManager.instance.shendunzhili;
					_mc.needMerit.text = numChange.changeNum(num)+"/"+numChange.changeNum(preCfg.shendunzhili);
					_mc.needMerit.textColor = num>=preCfg.shendunzhili?0xffe1aa:0xff0000;
				}
			}
			if(cfg.hero_love!=0)
			{
				var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(cfg.id);
				if(equip.entity==EntityTypes.ET_HERO)
				{
					curId = HeroDataManager.instance.getRings();
				}
				_mc.txtItem.text = StringConst.PANEL_CONVERT_HEROADMIRE;
				if(!preCfg)
				{
					_mc.needMerit.text = "???"+"/"+"???";
					_mc.needMerit.textColor = 0xffe1aa;
					if(curId>=cfg.id)
					{
						_mc.needLv.text = "-";
						_mc.needCoin.text = "-";
						_mc.needMerit.text = "-";
					}
				}
				else
				{
					num = HeroDataManager.instance.love;
					_mc.needMerit.text = numChange.changeNum(num)+"/"+numChange.changeNum(preCfg.hero_love);
					_mc.needMerit.textColor = num>=preCfg.hero_love?0xffe1aa:0xff0000;
				}
				
			}
			
			var size:Rectangle = _dataManager.getIconSize(cfg.id);
			_effectLoader = new UIEffectLoader(_mc.parent,_mc.iconPos.x + _mc.x,_mc.iconPos.y + _mc.y,1,1,_dataManager.getIconUrl(cfg),function():void
			{
				if(_effectLoader.effect)
				{
					_effectLoader.effect.mouseEnabled = false;
					var tipVO:TipVO = new TipVO();
					tipVO.tipData = curItem;
					tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP;
					ToolTipManager.getInstance().hashTipInfo(_mc.effectMc,tipVO);
					ToolTipManager.getInstance().attach(_mc.effectMc);
					_iconAnim = TweenLite.to(_effectLoader.effect,1,{y:_mc.y + _mc.iconPos.y - 8,repeat:-1,onComplete:reverseTween, onReverseComplete:restartTween});
				}
			});	
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
			
			for(i = 0; i < NUM_TAB; ++i)
			{
				item = getTabBtn(i);
				if(item == e.target)
				{
					_tabList.setSelected(item);
					_selectedTabIndex = _tabList.selectedIndex;
					var cfg:EquipExchangeCfgData  = ConfigDataManager.instance.equipExchangeCfgData(RoleDataManager.instance.getFireHeartId(_selectedTabIndex));
					if(!cfg)
						ConvertListPanelNew.DEFAULT_SELECTED_INDEX = 0;
					else if(cfg.step>0)
					{
						if(cfg.current_star<MAX_STAR)
							ConvertListPanelNew.DEFAULT_SELECTED_INDEX = cfg.step-1;
						else
							ConvertListPanelNew.DEFAULT_SELECTED_INDEX = cfg.step;
					}
					else
					{
						var str:String = cfg.id.toString();
						ConvertListPanelNew.DEFAULT_SELECTED_INDEX = int(str.charAt(str.length-3));
					}
					updateList(_selectedTabIndex);
				}
			}
			switch(e.target)
			{
//				case _mc.btnBuy:
//					PanelMediator.instance.openPanel(PanelConst.TYPE_CONVERT_START);
//					break;
				case _mc.buqianBtn:
					var selectedIndex:int = lastSelect;
					cfg = _itemList[selectedIndex].data;
					if(cfg.step>0&&cfg.id == RoleDataManager.instance.getFireHeartId(_selectedTabIndex))
						cfg = ConfigDataManager.instance.equipExchangeCfgData(cfg.next_id);
					if(_dataManager.canConvert(cfg.id,_selectedTabIndex))
					{
						var cell:CellData = _dataManager.getCell(cfg);
						_dataManager.requestConvert(cell.storageType,cell.slot);
					}
					break;
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_CONVERT_LIST);
					break;
                case _mc.btnActive:
                    handlerActive();
                    break;
			}
		}

        private function handlerActive():void
        {
            var dataManager:OnlineRewardDataManager = OnlineRewardDataManager.instance;
            var isFireActive:int = dataManager.activeFire;
            var isShieldActive:int = dataManager.activeShield;
            if (isFireActive == 1 && _selectedTabIndex == 0)
            {
                dataManager.sendActiveEquip(1);
            } else if (isShieldActive == 1 && _selectedTabIndex == 1)
            {
                dataManager.sendActiveEquip(2);
            }
        }
		
		private var lastSelect:int = 0;
		public function setSelectedItem(itemIndex:int,selectedTabIndex:int = -1,change:Boolean = false):void
		{
//			var item:MovieClip = getItemBtn(itemIndex);
			
//			_itemList.setSelected(item);
			var curCfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(RoleDataManager.instance.getFireHeartId(_selectedTabIndex));
			if(itemIndex != lastSelect&&!change)
			{
				if(_itemList[lastSelect]){
					_overEffectManager.setSelected(_itemList[lastSelect],false);
				}
			}
			_overEffectManager.setSelected(_itemList[itemIndex],true);
			lastSelect = itemIndex;
			if(selectedTabIndex == -1)
				selectedTabIndex = _tabList.selectedIndex;
			var list:Vector.<EquipExchangeCfgData> = _dataManager.getListByIndex(selectedTabIndex);
			
			if(!list || list.length == 0)
			{
				setDetail(null,null);
				return;
			}
			
			var equipExc:EquipExchangeCfgData = _itemList[itemIndex].data;
            checkActive(equipExc.id);

			if(curCfg&&equipExc.step>0&&curCfg.id == equipExc.id&&curCfg.current_star<MAX_STAR)
				equipExc = ConfigDataManager.instance.equipExchangeCfgData(equipExc.next_id);
			var preEquipExc:EquipExchangeCfgData = _dataManager.getNextData(equipExc,_selectedTabIndex);
			setDetail(equipExc,preEquipExc);
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
			return null;
		}
		
		public function getTabBtn(index:int):MovieClip
		{
			return _mc[TAB_PREFIX+index];
		}
		
		
		private function clearCenterIcon():void
		{
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
		
		private function initAfterItemBtnLoaded(...args):void
		{
			//+两个button
			//			if(args.length == NUM_ITEM+2)
			//			{
//			_itemList.init([_mc.item0,_mc.item1,_mc.item2,_mc.item3,_mc.item4,_mc.item5,_mc.item6,_mc.item7,_mc.item8,_mc.item9]);
//			
//			var list:Array = _dataManager.getListByIndex(_selectedTabIndex);
//			setItemBtnList(list);
//			
			updateList(_selectedTabIndex);
			_dataManager.attach(this);
			showNum();
			//			}
		}
		
		private function showNum():void
		{
			// TODO Auto Generated method stub
			check(RoleDataManager.HLZX,UnlockFuncId.CONVERT_LIST,_mc.txtHlBG,_mc.txtHlCount);
			check(RoleDataManager.HUANJIE,UnlockFuncId.CONVERT_LIST_RING,_mc.txtDjBG,_mc.txtDjCount);
			check(RoleDataManager.DUNPAI,UnlockFuncId.CONVERT_LIST_SHIELD,_mc.txtDpBG,_mc.txtDpCount);
		}
		
		private function check(type:int,id:int, mc:MovieClip, txt:TextField):void
		{
			// TODO Auto Generated method stub
			var b:Boolean = GuideSystem.instance.isUnlock(id);
			mc.visible = txt.visible = b;
			if(b)
			{
				var num:int = RoleDataManager.instance.getRingUpNum(type);
				txt.text = num.toString();
				if(num == 0)
				{
					mc.visible = txt.visible = false;
				}
			}
		}
		
		private function initAfterTabBtnLoaded(...args):void
		{
			//			if(args.length == NUM_TAB)
			//			{
			_mc.tab0.txt.text = StringConst.CONVERT_002;
			_mc.tab1.txt.text = StringConst.CONVERT_004;
			_mc.tab2.txt.text = StringConst.CONVERT_003;
			_tabList.init([_mc.tab0,_mc.tab1,_mc.tab2]);
			//			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var i:int;
			rsrLoader.addCallBack(_mc.mcScrollBar,function (mc:MovieClip):void//滚动条资源加载完成后构造滚动条控制类
			{
				if(!_scrollBar)
				{
					_scrollBar = new ScrollBar(_skin.parent as IScrollee,mc,0,_listCtner);
					_scrollBar.resetHeight(HEIGHT);
					var _data:Vector.<EquipExchangeCfgData> = _dataManager.getListByIndex(_selectedTabIndex);
					if(_data.length<7)
					{
						mc.visible = false;
					}else
					{
						mc.visible = true;
					}
				}
				
			});
			
			rsrLoader.addCallBack(_mc.buqianBtn,function():void{
//				_initAfterItemBtnLoadedHandler.call();
				getOk = true;
				_mc.txtGet.text = StringConst.CONVERT_0007;
				initAfterItemBtnLoaded();
				refreshBtnEffect();
			});
			
			
			rsrLoader.addCallBack(_mc.btnActive,function():void{
				InterObjCollector.instance.add(_mc.btnActive,PanelConst.TYPE_CONVERT_LIST);
				activeOK = true;
				refreshBtnEffect();
			});
			
			
			for(i=0;i<NUM_TAB;++i)
			{
				rsrLoader.addCallBack(getTabBtn(i),function(mc:MovieClip):void{
					_initAfterTabBtnLoadedHandler.call();
					InterObjCollector.instance.add(mc,PanelConst.TYPE_CONVERT_LIST);
				});
			}
		}
		
		private function refreshBtnEffect():void
		{
			if(needEffectActive&&activeOK)
			{
				_highlightEffect.show(_mc,_mc.btnActive);
				needEffectActive = false;
			}
			if(needEffectGet&&getOk)
			{
				_highlightEffect.show(_mc,_mc.buqianBtn);
				needEffectGet = false;
			}
		}
		
		
		/**
		 * 
		 * @param pos 被滚动内容的scrollRect的y坐标
		 */		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			_listCtner.scrollRect = _scrollRect;
		}
		public function get contentHeight():int
		{
			return listContentHeight;
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
		
	}
}