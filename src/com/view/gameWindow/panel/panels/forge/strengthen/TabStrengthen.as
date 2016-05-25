package com.view.gameWindow.panel.panels.forge.strengthen
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.forge.McIntensify;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.Container;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.tabsSwitch.TabBase;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.text.TextField;

    public class TabStrengthen extends TabBase
	{
		public var equipCellList:Array = [];
		public var skinThis:McIntensify;
		public var forgeNumContainer:Container;
		public var sPreviewCell:EquipCell;
		public var toStrengthenEquip:EquipCell;
		public var materiaIcon:EquipCell;
		public var protectIcon:EquipCell;
		public var stone1Icon:EquipCell;
		public var stone2Icon:EquipCell;
		public var starsConainer:Container;
		public var stone1Amount:int = 1;
		public var stone2Amount:int = 1;
		
		internal var strengthenHandle:StrengthenHandle;
		private var _mouseEvent:StrengthenMouseEvent;
		private var _successHandle:StrengthenSuccessHandle;
        private var _polishSuccessHandler:PolishSuccessHandler;
		private var _effectLoader:UIEffectLoader;
		private const _filter:GlowFilter = new GlowFilter(0,1,2,2,10);
		public static const STAR_FILTER:GlowFilter = new GlowFilter(0xff9900,1,6,6,3);

		public function TabStrengthen()
		{
			super();
			mouseEnabled = false;
		}		
		
		override protected function initSkin():void
		{
			_skin = new McIntensify();
			skinThis = _skin as McIntensify;
			skinThis.mouseEnabled = false;
			addChild(skinThis);
			//隐藏英雄装备按钮
			/*skinThis.btnHeroEquip.visible = false;
			skinThis.btnBagItem.x = skinThis.btnHeroEquip.x;*/
			//隐藏包裹装备按钮
			skinThis.btnBagItem.visible = false;
			//
			skinThis.layer.mouseEnabled = false;
			//
			_mouseEvent = new StrengthenMouseEvent();
			_mouseEvent.addEvent(skinThis,this);
			//
			drawUI();
			//
			strengthenHandle = new StrengthenHandle(this);
			//
			_successHandle = new StrengthenSuccessHandle(this);
            _polishSuccessHandler = new PolishSuccessHandler(this);
			//
			_effectLoader = new UIEffectLoader(skinThis.layer,-145,-155,1,1,EffectConst.RES_FORGE_BG);
		}
		
		private function drawUI():void
		{
			sPreviewCell = new EquipCell(skinThis.previewStrengthenIcon, 0, 0);
			sPreviewCell.tipType = ToolTipConst.EQUIP_BASE_TIP_NO_COMPLETE;
			sPreviewCell.isBindShow = false;
			toStrengthenEquip = new EquipCell(skinThis.toStrengthenEquip, 0, 0);
			toStrengthenEquip.isBindShow = false;
			materiaIcon = new EquipCell(skinThis.materiaIcon, 0, 0);
			protectIcon = new EquipCell(skinThis.protectIcon, 0, 0);
			stone1Icon = new EquipCell(skinThis.mcMaterialBuy.stone1Icon, 0, 0);
			stone2Icon = new EquipCell(skinThis.mcMaterialBuy.stone2Icon, 0, 0);
			starsConainer = new Container();
			starsConainer.mouseEnabled = false;
			addChild(starsConainer);
			starsConainer.x = 271-34;
			starsConainer.y = 345-74;
			forgeNumContainer = new Container();
			forgeNumContainer.x = 41-34;
			forgeNumContainer.y = 79-74;
			addChild(forgeNumContainer);
			forgeNumContainer.mouseEnabled = false;
			forgeNumContainer.mouseChildren = false;
			skinThis.strengthenRateOrForgText.mouseEnabled = false;
			skinThis.strengthenRateOrForgValueText.mouseEnabled = false;
			skinThis.luminousSelected.mouseChildren = false;
			skinThis.luminousSelected.mouseEnabled = false;
			skinThis.strengthMaxFlag.visible = false;
			for (var i:int=1;i<=7;i++)
			{
				var mcEquipCell:MovieClip = skinThis["equipCell"+i];
				var equipName:TextField = skinThis["equipName"+i];
				equipName.filters =[_filter];
				skinThis["bg"+i].mouseChildren = false;
				equipName.mouseEnabled = false;
				equipName.mouseWheelEnabled = false;
				mcEquipCell.mouseChildren = false;
				mcEquipCell.mouseEnabled = false;
				mcEquipCell.scaleX = mcEquipCell.scaleY = .9;
				mcEquipCell.x += 2;
				var cell:EquipCell = new EquipCell(mcEquipCell, 0, 0);
				cell.x = mcEquipCell.x;
				cell.y = mcEquipCell.y;
				cell.isBindShow = false;
				cell.name = mcEquipCell.name;
				cell.mouseChildren = false;
				addChild(cell);
				equipCellList.push(cell);
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(skinThis.btnSure,function():void
			{
				strengthenHandle.onBtnSureLoad();
				InterObjCollector.instance.add(skinThis.btnSure);
			});
			rsrLoader.addCallBack(skinThis.keyStrengthenBtn,function():void
			{
				strengthenHandle.keyStrengthenBtnLoad();
				skinThis.keyStrengthenBtn.txt.text = StringConst.STRENGTH_PANEL_0008;
			});
			rsrLoader.addCallBack(skinThis.mcUseProtect.protectSingleBtn,function():void
			{
				skinThis.mcUseProtect.protectSingleBtn.selected = false;
				strengthenHandle.onProtectSingleBtnLoad();
			});
			rsrLoader.addCallBack(skinThis.strengthForgProgress,function():void
			{
				strengthenHandle.onForeProgressBar();
			});
			//
			rsrLoader.addCallBack(skinThis.btnRoleEquip,function():void
			{
				skinThis.btnRoleEquip.txt.textColor = 0xffe1aa;
				skinThis.btnRoleEquip.txt.text = StringConst.STRENGTH_PANEL_0001;
				skinThis.btnRoleEquip.selected = true;
				skinThis.btnRoleEquip.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
				{
					strengthenHandle.changeToBeStrengthenedList(skinThis.btnRoleEquip);
				});
			});
			rsrLoader.addCallBack(skinThis.btnHeroEquip,function():void
			{
				skinThis.btnHeroEquip.txt.textColor = 0x675138;
				skinThis.btnHeroEquip.txt.text = StringConst.STRENGTH_PANEL_0002;
				skinThis.btnHeroEquip.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
				{
					strengthenHandle.changeToBeStrengthenedList(skinThis.btnHeroEquip);
				});
			});
			rsrLoader.addCallBack(skinThis.btnBagItem,function():void
			{
				skinThis.btnBagItem.txt.textColor = 0x675138;
				skinThis.btnBagItem.txt.text = StringConst.STRENGTH_PANEL_0003;
				skinThis.btnBagItem.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
				{
					strengthenHandle.changeToBeStrengthenedList(skinThis.btnBagItem);
				});
			});
			//
			rsrLoader.addCallBack(skinThis.bg1,function():void
			{
				strengthenHandle.isGlowListener(1);
				strengthenHandle.setNameToIndex(skinThis.bg1.name, 1);
				strengthenHandle.setNameToIndex(equipCellList[0].name, 1);
			});
			rsrLoader.addCallBack(skinThis.bg2,function():void
			{
				strengthenHandle.isGlowListener(2);
				strengthenHandle.setNameToIndex(skinThis.bg2.name, 2);
				strengthenHandle.setNameToIndex(equipCellList[1].name, 2);
			});
			rsrLoader.addCallBack(skinThis.bg3,function():void
			{
				strengthenHandle.isGlowListener(3);
				strengthenHandle.setNameToIndex(skinThis.bg3.name, 3);
				strengthenHandle.setNameToIndex(equipCellList[2].name, 3);
			});
			rsrLoader.addCallBack(skinThis.bg4,function():void
			{
				strengthenHandle.isGlowListener(4);
				strengthenHandle.setNameToIndex(skinThis.bg4.name, 4);
				strengthenHandle.setNameToIndex(equipCellList[3].name, 4);
			});
			rsrLoader.addCallBack(skinThis.bg5,function():void
			{
				strengthenHandle.isGlowListener(5);
				strengthenHandle.setNameToIndex(skinThis.bg5.name, 5);
				strengthenHandle.setNameToIndex(equipCellList[4].name, 5);
			});
			rsrLoader.addCallBack(skinThis.bg6,function():void
			{
				strengthenHandle.isGlowListener(6);
				strengthenHandle.setNameToIndex(skinThis.bg6.name, 6);
				strengthenHandle.setNameToIndex(equipCellList[5].name, 6);
			});
			rsrLoader.addCallBack(skinThis.bg7,function():void
			{
				strengthenHandle.isGlowListener(7);
				strengthenHandle.setNameToIndex(skinThis.bg7.name, 7);
				strengthenHandle.setNameToIndex(equipCellList[6].name, 7);
			});
			//
			rsrLoader.addCallBack(skinThis.btnTabStrengthen,function(mc:MovieClip):void
			{
				var textField:TextField = mc.txt as TextField;
				textField.textColor = 0xffe1aa;
				textField.text = StringConst.STRENGTH_PANEL_0018;
				mc.selected = true;
			});
			rsrLoader.addCallBack(skinThis.btnTabPolish,function(mc:MovieClip):void
			{
				var textField:TextField = mc.txt as TextField;
				textField.textColor = 0x675138;
				textField.text = StringConst.STRENGTH_PANEL_0019;
			});
			//
			rsrLoader.addCallBack(skinThis.mcMaterialBuy.stone1BuyBtn,function():void
			{
				skinThis.mcMaterialBuy.stone1BuyBtn.txt.textColor = 0xd4a460;
				skinThis.mcMaterialBuy.stone1BuyBtn.txt.text = StringConst.NPC_SHOP_PANEL_0002;
			});
			rsrLoader.addCallBack(skinThis.mcMaterialBuy.stone2BuyBtn,function():void
			{
				skinThis.mcMaterialBuy.stone2BuyBtn.txt.textColor = 0xd4a460;
				skinThis.mcMaterialBuy.stone2BuyBtn.txt.text = StringConst.NPC_SHOP_PANEL_0002;
			});
			rsrLoader.addCallBack(skinThis.mcMaterialBuy.mcScrollBar,function(mc:MovieClip):void
			{
				strengthenHandle.initPageScrollBar(mc);
			});
		}
		
		override protected function initData():void
		{
		}
		
		override public function update(proc:int = 0):void
		{
			if(proc == GameServiceConstants.SM_BAG_ITEMS || proc == GameServiceConstants.SM_HERO_INFO)
			{
				strengthenHandle.bageItemChange();
			}
			else if(proc == GameServiceConstants.SM_MEM_UNIQUE_EQUIP_INFO)
			{
				strengthenHandle.changeMemequipData();
				strengthenHandle.accruePolishInfo();
			}
		}
		
		public function loadStarMc(mc:MovieClip,/*memEquipData:MemEquipData,*/frameLanbel:String):void
		{
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.addCallBack(mc.star,function():void
			{
				mc.star.gotoAndStop(frameLanbel);
				/*var tipVO:TipVO = new TipVO();
				tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP;
				tipVO.tipData = memEquipData;
				tipVO.completeTipeType = 1;
				ToolTipManager.getInstance().hashTipInfo(mc,tipVO);
				ToolTipManager.getInstance().attach(mc);*/
            });
			rsrLoader.load(mc,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
		}
		
		public function loadFrogNum(forgeNum:MovieClip,num:int):void
		{
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.addCallBack(forgeNum.num,function():void
			{
			    forgeNum.num.gotoAndStop(num);
            });
			rsrLoader.load(forgeNum,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
		}
		
		public function clearAllStars():void
		{
			var star:ForgeStars;
			while(starsConainer.numChildren>0)
			{
				star = starsConainer.removeChildAt(0) as ForgeStars;
				ToolTipManager.getInstance().detach(star);
				/*star.removeEventListener(MouseEvent.MOUSE_OVER,_strengthenHandle.onStarMouseMove);
				star.removeEventListener(MouseEvent.MOUSE_OUT,_strengthenHandle.onStarMouseOut);*/
			}
		}
		
		override public function destroy():void
		{
			ToolTipManager.getInstance().detach(skinThis.txtVip);
			ToolTipManager.getInstance().detach(materiaIcon);
			ToolTipManager.getInstance().detach(protectIcon);
			ToolTipManager.getInstance().detach(sPreviewCell);
			ToolTipManager.getInstance().detach(toStrengthenEquip);
			materiaIcon.setNull();
			protectIcon.setNull();
			sPreviewCell.setNull();
			toStrengthenEquip.setNull();
			forgeNumContainer.removeAllChild();
			clearAllStars();
			setAllEquipCellNull();
			if(_mouseEvent)
			{
				_mouseEvent.destoryEvent();
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			if(strengthenHandle)
			{
				strengthenHandle.destroy();
			}
			if(_successHandle)
			{
				_successHandle.destory();
			}
            if (_polishSuccessHandler)
            {
                _polishSuccessHandler.destroy();
            }
			InterObjCollector.instance.remove(skinThis.btnSure);
			_mouseEvent = null;
			skinThis = null;
		
			super.destroy();
		}
		
		private function setAllEquipCellNull():void
		{
			for (var i:int=0;i<equipCellList.length;i++)
			{
				var equipCell:EquipCell = equipCellList[i] as EquipCell;
				equipCell.setNull();
			}
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			MemEquipDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			MemEquipDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}