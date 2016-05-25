package com.view.gameWindow.panel.panels.forge.strengthen
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipPolishAttrCfgData;
	import com.model.configData.cfgdata.EquipPolishCfgData;
	import com.model.configData.cfgdata.EquipStrengthenAttrCfgData;
	import com.model.configData.cfgdata.EquipStrengthenCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.ConstProtect;
	import com.model.consts.EffectConst;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.forge.McIntensify;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/**
	 * 强化面板
	 * @author jhj
	 */
	public class StrengthenHandle
	{
		private var _tab:TabStrengthen;
		private var _bgNameToIndex:Dictionary = new Dictionary();
		private var _toStrengthenedList:Array = [];
		private var _pageIndex:int = 1;
		private var _selectIndex:int = -1;
		private var _memEquipData:MemEquipData;
		private var _effectVector:Vector.<UIEffectLoader>;
		private static const PAGE_NUM:int = 7;
		public static var instance:StrengthenHandle;
		
		public static const MODE_STRENGTHEN:int = 0;
		public static const MODE_POLISH:int = 1;
		/**强化/打磨模式*/
		private var _mode:int;
		/**上次强化显示等级*/
		private var _numStrengthenStr:String;
		/**上次打磨显示等级*/
		private var _numPolishStr:String;
		/***/
		private var _accruePolish:StrengthenAccruePolish;
		
		private var _shopHandle:StrengthenShopHandle;
		/**上次强化操作时刻*/
		private var _timeLastStrengthen:int;
		private const cdStrength:int = 300;
		private function get isStrengthenCDOver():Boolean
		{
			return getTimer() - _timeLastStrengthen > cdStrength;
		}
		
		public function StrengthenHandle(view:TabStrengthen)
		{
			_tab = view;
			instance = this;
			_shopHandle = new StrengthenShopHandle(_tab);
			changeToBeStrengthenedList(_tab.skinThis.btnRoleEquip);
			hideProtect();
			//
			_tab.skinThis.txtPolishTip.htmlText = StringConst.STRENGTH_PANEL_0020;
			_tab.skinThis.txtCoin.text = StringConst.STRENGTH_PANEL_0042;
			_tab.skinThis.txtGold.text = StringConst.STRENGTH_PANEL_0043;
			_tab.skinThis.mcMaterialLack.goldDesText.text = StringConst.STRENGTH_PANEL_0044;
			_tab.skinThis.mcMaterialBuy.txtPriceTotal1.text = StringConst.STRENGTH_PANEL_0045;
			_tab.skinThis.mcMaterialBuy.txtPriceUnit1.text = StringConst.STRENGTH_PANEL_0046;
			_tab.skinThis.mcMaterialBuy.txtPriceTotal2.text = StringConst.STRENGTH_PANEL_0045;
			_tab.skinThis.mcMaterialBuy.txtPriceUnit2.text = StringConst.STRENGTH_PANEL_0046;
			initTxtVip();
		}
		
		private function initTxtVip():void
		{
			var txtVip:TextField = _tab.skinThis.txtVip;
			txtVip.htmlText = HtmlUtils.createHtmlStr(0x53b436,StringConst.STRENGTH_PANEL_0036,12,false,2,"SimSun",true);
			ToolTipManager.getInstance().attachByTipVO(txtVip,ToolTipConst.TEXT_TIP,getTxtVipData);
		}
		
		private function getTxtVipData():String
		{
			var manager:VipDataManager = VipDataManager.instance;
			var str:String = StringConst.STRENGTH_PANEL_0037 + HtmlUtils.createHtmlStr(0xffcc00,manager.lv+"",12,false,4) + "\n\n";
			str += StringConst.STRENGTH_PANEL_0038 + "\n";
			var i:int,l:int = VipDataManager.MAX_LV;
			for (i=0;i<l;i++) 
			{
				var lv:int = i+1;
				var vipCfgDt:VipCfgData = manager.vipCfgDataByLv(lv);
				var color:int = lv == manager.lv ? 0x00ff00 : 0xb4b4b4;
				str += HtmlUtils.createHtmlStr(color,lv+StringConst.STRENGTH_PANEL_0039+(vipCfgDt.strongthen_rate*.1)+"%",12,false,4) + "\n";
			}
			return HtmlUtils.createHtmlStr(0xd4a460,str,12,false,4);
		}
		
		public function get memEquipData():MemEquipData
		{
			return _memEquipData;
		}
		
		public function setNameToIndex(name:String, index:int):void
		{
			for(var i:int = 1; i<8; i++)
			{
				_bgNameToIndex[name] = index;
			}
		}
		
		public function isGlowListener(i:int):void
		{
			var equipCell:EquipCell = _tab.equipCellList[i-1] as EquipCell;
			var isListener:Boolean = equipCell.onlyId != 0;
			
			if(isListener)
			{
				_tab.skinThis["bg"+i].addEventListener(MouseEvent.CLICK, onSelctGlow);
				equipCell.addEventListener(MouseEvent.CLICK,onSelctGlow);
			}
			else
			{
				_tab.skinThis["bg"+i].removeEventListener(MouseEvent.CLICK, onSelctGlow);
				equipCell.removeEventListener(MouseEvent.CLICK,onSelctGlow);
			}
		}
		
		public function onLastPageHandler(event:MouseEvent = null):void
		{
			if(isAutoPolishing)
			{
				Alert.warning(StringConst.STRENGTH_PANEL_0035);
				return;
			}
			if(_pageIndex <= 1)
			{
				return;
			}
			_pageIndex--;
			initToBeStrengthenedList();
		}
		
		public function onNextPageHandler(event:MouseEvent = null):void
		{
			if(isAutoPolishing)
			{
				Alert.warning(StringConst.STRENGTH_PANEL_0035);
				return;
			}
			if(_pageIndex >= totalPage)
			{
				return;
			}
			_pageIndex++;
			initToBeStrengthenedList();
		}
		
		public function changeToBeStrengthenedList(mc:MovieClip):void
		{
			var managerRole:RoleDataManager = RoleDataManager.instance;
			var managerHero:HeroDataManager = HeroDataManager.instance;
			var managerBag:BagDataManager = BagDataManager.instance;
			if(mc == _tab.skinThis.btnRoleEquip)
			{
				_toStrengthenedList = !isPolish ? managerRole.getCanStrengthenEquips() : managerRole.getCanPolishEquips();
			}
			else if(mc == _tab.skinThis.btnHeroEquip)
			{
				_toStrengthenedList = !isPolish ? managerHero.getCanStrengthenEquips() : managerHero.getCanPolishEquips();
			}
			else if(mc == _tab.skinThis.btnBagItem)
			{
				var equips:Array = !isPolish ? managerBag.getCanStrengthEquip() : managerBag.getCanPolishEquips();
				equips = equips.concat(!isPolish ? managerHero.getCanStrengthBagEquips() : managerHero.getCanPolishBagEquips());
				_toStrengthenedList = equips;
			}
			
			_pageIndex = thePageIndex;
			updatePage();
			initToBeStrengthenedList();
		}
		/**切换到打磨时，根据原本选中的装备获得page*/
		private function get thePageIndex():int
		{
			var cell:EquipCell;
			var i:int,l:int = _tab.equipCellList.length;
			for (i=0;i<l;i++) 
			{
				cell = _tab.equipCellList[i];
				if(_memEquipData && cell.bornSid == _memEquipData.bornSid && cell.onlyId == _memEquipData.onlyId)
				{
					return Math.ceil((i+1)/PAGE_NUM);
				}
			}
			return 1;
		}
		
		public function onProtectedSingleHandler():void
		{
			var selected:Boolean = _tab.skinThis.mcUseProtect.protectSingleBtn.selected;
			updateAboutMaterialPosition(selected);
			if(!selected)
			{
				hideProtect();
				updateStrengthenRateOrForgeAbhout();
			}
			else
			{
				isShowProtect();
			}
			updateGlod();
			updateVisibles();
		}
		
		public function keyPolishBtnHandler():void
		{
			trace("key>>> " + isAutoPolishing);
			if(isAutoPolishing)
			{
				ForgeDataManager.instance.stopIntervalPolishRequest();
				/*Alert.warning(StringConst.STRENGTH_PANEL_0035);*/
				return;
			}
			var isCan:Boolean = canStrengthOrPolish();
			if (isPolish && isCan)
			{
				var equipCell:EquipCell = _tab.equipCellList[_selectIndex-1];
				if(equipCell)
				{
					var continueStrengthenVO:SendStrengthenVO = new SendStrengthenVO();
					continueStrengthenVO.storageType = equipCell.storageType;
					continueStrengthenVO.slot = equipCell.slot;
					var isUseGold:int = _tab.skinThis.mcMaterialLack.goldBuyBtn.selected ? ConstProtect.USE : ConstProtect.NO_USE;
					continueStrengthenVO.isUseGold = isUseGold;
					ForgeDataManager.instance.continueStrengthenVO = continueStrengthenVO;
					ForgeDataManager.instance.stopIntervalPolishRequest();
					ForgeDataManager.instance.continuePolishTimeId = setInterval(continueRequestPolish,500,continueStrengthenVO);
					_accruePolish = new StrengthenAccruePolish(_tab.skinThis,_memEquipData);
					continueRequestPolish(continueStrengthenVO);
				}
			}
		}
		
		public function changeMemequipData():void
		{
			var equipCell:EquipCell = _tab.equipCellList[_selectIndex-1];
			if(equipCell)
			{
				selectEquipCell(equipCell);
				for each (equipCell in _tab.equipCellList) 
				{
					if(equipCell && !equipCell.isEmpty())
					{
						equipCell.addLevel(isPolish);
					}
				}
				if(isPolish)
				{
					if(isToMax())
					{
						ForgeDataManager.instance.stopIntervalPolishRequest();
					}
				}
			}
		}
		
		public function bageItemChange():void
		{
			showMateria();
			isShowProtect();
			updateAttr(memEquipData);
			updateVisibles();
		}
		
		public function onProtectSingleBtnLoad():void
		{
			if(!memEquipData)
			{
				return;
			}
			_tab.skinThis.mcUseProtect.protectSingleBtn.alpha = isPolish ? 0 : 1;
		}
		
		public function onForeProgressBar():void
		{
			if(!memEquipData)
			{
				return;
			}
			var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
			if(!equipPolishCfgData)
			{
				return;
			}
			if(isPolish && !isToMax())
			{
                var scaleWidth:Number = equipPolishCfgData.exp / equipPolishCfgData.max_exp * 156;
                if (scaleWidth <= 0)
                {
                    _tab.skinThis.strengthForgProgress.alpha = 0;
                } else
                {
                    _tab.skinThis.strengthForgProgress.alpha = 1;
                    _tab.skinThis.strengthForgProgress.width = scaleWidth;
                }
				_tab.skinThis.strengthenRateOrForgText.text = StringConst.STRENGTH_PANEL_0005+": ";
				_tab.skinThis.strengthenRateOrForgValueText.text = memEquipData.polishExp+"/"+equipPolishCfgData.max_exp;
				forgeProgressBarTipHandler(true);
			}
			else
			{
				forgeProgressBarTipHandler(false);
			}
		}
		
		public function keyStrengthenBtnLoad():void
		{
			_tab.skinThis.keyStrengthenBtn.visible = isPolish ? true : false;
		}
		
		public function onBtnSureLoad():void
		{
			if(!_tab.skinThis.btnSure.txt)
			{
				return;
			}
			if(isPolish)
			{
				_tab.skinThis.btnSure.txt.text = StringConst.STRENGTH_PANEL_0007;
			}
			else
			{
				_tab.skinThis.btnSure.btnEnabled = isStrengthenCDOver;
				_tab.skinThis.btnSure.txt.text = StringConst.FORGE_PANEL_00011;
			}
		}
		
		private function initToBeStrengthenedList():void
		{
			ForgeDataManager.instance.stopIntervalPolishRequest();
			
			updateList();
			
			if(_tab.equipCellList[0].onlyId != 0)
			{
				_selectIndex = theSelectIndex;
				setLuminousSelectedPosition();
				selectEquipCell(_tab.equipCellList[_selectIndex-1]);
			}
			else
			{
				_selectIndex = 0;
				_memEquipData = null;
				_tab.skinThis.luminousSelected.alpha = 0; 
				_tab.materiaIcon.setNull();
				ToolTipManager.getInstance().detach(_tab.materiaIcon);
				_tab.skinThis.materiaNum.text = "";
				_tab.protectIcon.setNull();
				ToolTipManager.getInstance().detach(_tab.protectIcon);
				_tab.skinThis.protectNum.text = "";
				_tab.toStrengthenEquip.setNull();
				ToolTipManager.getInstance().detach(_tab.toStrengthenEquip);
				if(_tab.skinThis.btnSure.txt)
					_tab.skinThis.btnSure.txt.text = StringConst.FORGE_PANEL_00011;
				_tab.skinThis.strengthForgProgress.alpha = 0;
				_tab.skinThis.mcUseProtect.protectDesText.text = StringConst.STRENGTH_PANEL_0006;
				_tab.skinThis.mcUseProtect.protectDescMc.alpha = 1;
				_tab.skinThis.mcUseProtect.protectSingleBtn.alpha = 1;
				_tab.skinThis.keyStrengthenBtn.visible = false;
				_tab.skinThis.btnSure.x = 376+41-34;
				_tab.skinThis.btnSure.y = 394+79-74;
				clearAttr();
				clearPreviewStrengthen();
				isShowProtect();
				updateAboutMaterialPosition(_tab.skinThis.mcUseProtect.protectSingleBtn.selected);
			}
		}
		/**切换到打磨时，根据原本选中的装备获得index*/
		private function get theSelectIndex():int
		{
			var cell:EquipCell;
			var i:int,l:int = _tab.equipCellList.length;
			for (i=0;i<l;i++) 
			{
				cell = _tab.equipCellList[i];
				if(_memEquipData && cell.bornSid == _memEquipData.bornSid && cell.onlyId == _memEquipData.onlyId)
				{
					return i%PAGE_NUM + 1;
				}
			}
			return 1;
		}
		
		private function setLuminousSelectedPosition():void
		{
			_tab.skinThis.luminousSelected.y = 28+(_selectIndex-1)*55;
			_tab.skinThis.luminousSelected.alpha = 1;
		}
		
		private function get totalPage():int
		{
			return _toStrengthenedList.length == 0 ? 1 : Math.ceil(_toStrengthenedList.length/PAGE_NUM);
		}
		
		private function updateList():void
		{
			var startIndex:int = (_pageIndex-1)*PAGE_NUM;
			var endIndex:int = _pageIndex*PAGE_NUM > _toStrengthenedList.length? _toStrengthenedList.length : _pageIndex*PAGE_NUM ;
			var l:int = _pageIndex*PAGE_NUM;
			for(var i:int = startIndex; i<l; i++)
			{
				if(i<endIndex)
				{
					var isMatchType:Boolean;
					var equipId:int;
					var slot:int;
					var bornSid:int = _toStrengthenedList[i].bornSid;
					if(_toStrengthenedList[i] is EquipData)
					{
						isMatchType = true;
						slot = _toStrengthenedList[i].slot;
						equipId = _toStrengthenedList[i].id;
						
					}
					else if(_toStrengthenedList[i] is BagData)
					{
						isMatchType = true;
						slot = _toStrengthenedList[i].slot;
						equipId = _toStrengthenedList[i].id;
					}
					if(isMatchType)
					{
						var memEquiData:MemEquipData = MemEquipDataManager.instance.memEquipData(bornSid, equipId);
						if(!memEquiData)
							continue;
						var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquiData.baseId);
						if(!equipCfgData)
							continue;
						var equipCell:EquipCell = _tab.equipCellList[i-startIndex];
						equipCell.slot = slot;
						equipCell.storageType = _toStrengthenedList[i].storageType;
						equipCell.refreshData(equipId, bornSid);
						equipCell.txtNum.visible = false;
						equipCell.addLevel(isPolish);
						ToolTipManager.getInstance().attach(equipCell);
						var textField:TextField = _tab.skinThis["equipName"+(i-startIndex+1)] as TextField;
						textField.text = equipCfgData.name;
						textField.textColor = ItemType.getColorByQuality(equipCfgData.color);
						
					}
				}
				else
				{
					_tab.equipCellList[i-startIndex].setNull();
					ToolTipManager.getInstance().detach(_tab.equipCellList[i-startIndex]);
					_tab.skinThis["equipName"+(i-startIndex+1)].text = "";
				}
			}
			
			for(var j:int = 1; j<=PAGE_NUM; j++)
			{
				isGlowListener(j);
			}
			
			updatePage();
		}
		
		private function onSelctGlow(event:MouseEvent):void
		{
			if(isAutoPolishing)
			{
				Alert.warning(StringConst.STRENGTH_PANEL_0035);
				return;
			}
			var target:DisplayObject = event.target as DisplayObject;
			_selectIndex = _bgNameToIndex[target.name];
			if(_selectIndex == 0)
			{
				return;
			}
			
			setLuminousSelectedPosition();
			var equipCell:EquipCell = _tab.equipCellList[_selectIndex-1];
			_tab.skinThis.mcUseProtect.protectSingleBtn.selected = false;
			_tab.skinThis.mcMaterialLack.goldBuyBtn.selected = false;
			selectEquipCell(equipCell);
		}
		
		private function isMouseOn(target:DisplayObject):Boolean
		{
			var mx:Number = target.mouseX*target.scaleX;//返回相对图像的起始点位置
			var my:Number = target.mouseY*target.scaleY;
			var result:Boolean = mx > 0 && mx <= target.width && my > 0 && my <= target.height;
			return result;
		}
		
		private function selectEquipCell(equipCell:EquipCell):void
		{
			_memEquipData = MemEquipDataManager.instance.memEquipData(equipCell.bornSid, equipCell.onlyId);
			updateAttr(memEquipData);
			updateToStrengthen(equipCell); 
			updatePreviewStrengthen(equipCell);
			onBtnSureLoad();
			updateWhetherPolish();
			updateVisibles();
		}
		/**更新相关功能按钮的可见性*/
		private function updateVisibles():void
		{
			if(!_memEquipData)
			{
				return;
			}
			var equipCfgData:EquipCfgData = _memEquipData.equipCfgData;
			if(!equipCfgData)
			{
				return;
			}
			var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
			if(!equipPolishCfgData || memEquipData.strengthen < equipPolishCfgData.equipstrong_limit)
			{
				_tab.skinThis.btnTabPolish.visible = false;
			}
			else
			{
				_tab.skinThis.btnTabPolish.visible = true;
			}
			var equipStrengthen:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
			if(!equipStrengthen || rateSuccess(equipStrengthen) == 1000)
			{
				_tab.skinThis.mcUseProtect.visible = false;
			}
			else
			{
				_tab.skinThis.mcUseProtect.visible = true;
			}
			var materialIsEnough:int = materialEnough();
			if (materialIsEnough == 0)
			{
				_tab.skinThis.mcMaterialLack.visible = false;
				_tab.skinThis.mcMaterialBuy.visible = false;
			}
			else
			{
				_tab.skinThis.mcMaterialLack.visible = true;
				_tab.skinThis.mcMaterialBuy.visible = true;
			}
		}
		
		private function updateWhetherPolish():void
		{
			if(isPolish)
			{
				hideProtect();
				updateAboutMaterialPosition(false);
				_tab.skinThis.btnSure.text = "";
				_tab.skinThis.mcUseProtect.protectDescMc.alpha = 0;
				_tab.skinThis.mcUseProtect.protectSingleBtn.alpha = 0;
				_tab.skinThis.mcUseProtect.protectDesText.text = "";
				_tab.skinThis.keyStrengthenBtn.visible = true;
				_tab.skinThis.btnSure.x = 291+41-34;
				_tab.skinThis.btnSure.y = 394+79-74;
				_tab.skinThis.keyStrengthenBtn.x = 436+41-34;
				_tab.skinThis.keyStrengthenBtn.y = 394+79-74;
				_tab.skinThis.mcEffect.visible = false;
				_tab.skinThis.mcEffect1.visible = true;
				_tab.skinThis.mcPolish0.visible = true;
				_tab.skinThis.mcPolish1.visible = true;
				_tab.skinThis.txtPolishTip.visible = true;
				_tab.starsConainer.visible = false;
			}
			else
			{
				_tab.skinThis.mcUseProtect.protectDescMc.alpha = 1;
				_tab.skinThis.mcUseProtect.protectSingleBtn.alpha = 1;
				_tab.skinThis.mcUseProtect.protectDesText.text = StringConst.STRENGTH_PANEL_0006;
				_tab.skinThis.keyStrengthenBtn.visible = false;
				_tab.skinThis.btnSure.x = 376+41-34;
				_tab.skinThis.btnSure.y = 394+79-74;
				_tab.skinThis.mcEffect.visible = true;
				_tab.skinThis.mcEffect1.visible = false;
				_tab.skinThis.mcPolish0.visible = false;
				_tab.skinThis.mcPolish1.visible = false;
				_tab.skinThis.txtPolishTip.visible = false;
				_tab.starsConainer.visible = true;
			}
		}
		
		private function updatePage():void
		{
			_tab.skinThis.pageText.text = _pageIndex+"/"+totalPage;
		}
		
		private function updateAttr(memEquipData:MemEquipData):void
		{
			if(!memEquipData)
			{
				return;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				return;
			}
			var isStengthenToMax:Boolean = isToMax();
			if(isStengthenToMax)
			{
				setAttrText(new Vector.<String>);
				_tab.skinThis.txtCoinValue.text = "";
				_tab.skinThis.txtGoldValue.text = "";
				_tab.skinThis.strengthenRateOrForgValueText.text = "";
				_tab.skinThis.strengthenRateOrForgValueText.text = "";
				_tab.skinThis.strengthMaxFlag.visible = true;
				_tab.skinThis.strengthenAddProText.text = isPolish ? StringConst.STRENGTH_PANEL_0041 : StringConst.STRENGTH_PANEL_0040;
				_tab.skinThis.strengthenAddProText.width = _tab.skinThis.strengthenAddProText.textWidth + 5;
				_tab.skinThis.forgeArrow.visible = false;
				forgeProgressBarTipHandler(false);
				updateStrengthenRateOrForgeAbhout();
			}
			else
			{
				if(!isPolish)
				{
					var equipStrengthenAttr:EquipStrengthenAttrCfgData = ConfigDataManager.instance.equipStrengthenAttr(equipCfgData.type,memEquipData.strengthen+1);
					setAttrText(CfgDataParse.getAttStringArray(equipStrengthenAttr.attr,true));
					var nextStrengthen:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
					_tab.skinThis.txtCoinValue.text = nextStrengthen.coin.toString();
					var coin:int = BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind;
					_tab.skinThis.txtCoinValue.textColor = coin >= nextStrengthen.coin ? 0x53B436 : 0xff0000;
					_tab.skinThis.strengthenAddProText.text = StringConst.STRENGTH_PANEL_0009;
				}
				else
				{
					var equipPolishAttrCfgData:EquipPolishAttrCfgData = ConfigDataManager.instance.equipPolishAttrCfgData(equipCfgData.type,memEquipData.polish+1);
					var attrStrs:Vector.<String> = CfgDataParse.getAttStringArray(equipPolishAttrCfgData.attr,true);
					attrStrs.push(StringConst.STRENGTH_PANEL_0023+equipPolishAttrCfgData.attr_rate*.1+"%");
					setAttrText(attrStrs);
					var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
					_tab.skinThis.txtCoinValue.text = equipPolishCfgData.coin.toString();
					coin = BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind;
					_tab.skinThis.txtCoinValue.textColor = coin >= equipPolishCfgData.coin ? 0x53B436 : 0xff0000;
					_tab.skinThis.strengthenAddProText.text = StringConst.STRENGTH_PANEL_0022;
				}
				_tab.skinThis.strengthMaxFlag.visible = false;
				_tab.skinThis.forgeArrow.visible = true;
				updateGlod();
				updateStrengthenRateOrForgeAbhout();
			}
			//星星相关
			if(!isPolish)
			{
				setStars(equipCfgData,memEquipData);
			}
			else
			{
				destroyStarEffects();
			}
		}
		
		private function setAttrText(propertyArray:Vector.<String>):void
		{
			for(var i:int = 1; i<4; i++)
			{
				if(i > propertyArray.length)
				{
					_tab.skinThis["attr"+i].text = "";
				}
				else
				{
					var textField:TextField = _tab.skinThis["attr"+i] as TextField;
					textField.text = propertyArray[i-1];
					textField.width = textField.textWidth + 6;
				}
			}
		}
		
		//更新费用和概率值	
		private function updateStrengthenRateOrForgeAbhout():void
		{
			///强化概率和锻造
            var scaleWidth:Number = 0;
			if(!isPolish)
			{
				var nextStrengthen:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
				var vipCfgData:VipCfgData = VipDataManager.instance.vipCfgData;
				_tab.skinThis.strengthenRateOrForgText.text = StringConst.STRENGTH_PANEL_0004+": ";
				var value:String = vipCfgData ? HtmlUtils.createHtmlStr(0x00ff00,"+"+vipCfgData.strongthen_rate*.1+"%") : "";
				value = nextStrengthen ? nextStrengthen.rate * .1 + "%" + value : "";
				_tab.skinThis.strengthenRateOrForgValueText.htmlText = value;
                var rate:Number = rateSuccess(nextStrengthen) * .001;
                scaleWidth = 156 * rate;
                if (scaleWidth <= 0)
                {
                    _tab.skinThis.strengthForgProgress.alpha = 0;//显示对象不能没有宽高
                } else
                {
                    _tab.skinThis.strengthForgProgress.alpha = 1;
                    _tab.skinThis.strengthForgProgress.width = scaleWidth;
                }

				forgeProgressBarTipHandler(false);
				_tab.skinThis.txtVip.visible = true;
				if(_tab.skinThis.mcUseProtect.protectSingleBtn.selected)
				{
					_tab.skinThis.strengthenRateOrForgValueText.text = "100%";
                    _tab.skinThis.strengthForgProgress.alpha = 1;
                    _tab.skinThis.strengthForgProgress.width = 156;
				}
			}
			else
			{
				var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
                scaleWidth = equipPolishCfgData ? 156 * memEquipData.polishExp / equipPolishCfgData.max_exp : 0;
                if (scaleWidth <= 0)
                {
                    _tab.skinThis.strengthForgProgress.alpha = 0;
                } else
                {
                    _tab.skinThis.strengthForgProgress.alpha = 1;
                    _tab.skinThis.strengthForgProgress.width = scaleWidth;
                }

				_tab.skinThis.strengthenRateOrForgText.text = StringConst.STRENGTH_PANEL_0005+": ";
				_tab.skinThis.strengthenRateOrForgValueText.text = equipPolishCfgData ? memEquipData.polishExp+"/"+equipPolishCfgData.max_exp : "";
				forgeProgressBarTipHandler(!isToMax() ? true : false);
				_tab.skinThis.txtVip.visible = false;
			}
		}
		
		public function updateGlod():void
		{
			if(!memEquipData)
			{
				return;
			}
			var otherGlod:int;
			if(!isPolish)
			{
				var equipStrengthen:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
				if(!equipStrengthen)
				{
					return;
				}
				if(_tab.skinThis.mcMaterialLack.goldBuyBtn.selected)
				{
					var itemNum:int = BagDataManager.instance.getItemNumById(equipStrengthen.stone);
					otherGlod = (equipStrengthen.stone_count-itemNum <= 0 ? 0 :(equipStrengthen.stone_count-itemNum)*equipStrengthen.stone_price);
					if(_tab.skinThis.mcUseProtect.protectSingleBtn.selected && !isPolish)
					{
						var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(equipStrengthen.protect);
						if(!itemCfg)
						{
							return;
						}
						itemNum = BagDataManager.instance.getItemNumById(equipStrengthen.protect);
						var countProtectTotal:int = countProtect(equipStrengthen);
						otherGlod += ((countProtectTotal - itemNum) <= 0 ? 0 : (countProtectTotal - itemNum) * equipStrengthen.protect_price);
					}
				}
			}
			else
			{
				var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
				if(!equipPolishCfgData)
				{
					return;
				}
				if(_tab.skinThis.mcMaterialLack.goldBuyBtn.selected)
				{
					itemNum = BagDataManager.instance.getItemNumById(equipPolishCfgData.stone);
					otherGlod = (equipPolishCfgData.stone_count-itemNum <= 0 ? 0 :(equipPolishCfgData.stone_count-itemNum)*equipPolishCfgData.stone_price);
				}
			}
			
			_tab.skinThis.txtGoldValue.text = otherGlod.toString();
			var goldUnBind:int = BagDataManager.instance.goldUnBind;
			_tab.skinThis.txtGoldValue.textColor = goldUnBind >= otherGlod ? 0x53B436 : 0xff0000;
		}
		
		private function clearAttr():void
		{
			_tab.skinThis.strengthenRateOrForgText.text = "";
			_tab.skinThis.strengthenRateOrForgValueText.text = "";
			_tab.skinThis.txtCoinValue.text = "";
			_tab.skinThis.txtGoldValue.text = "";
			_tab.clearAllStars();
		}
		
		private function setStars(equipCfgData:EquipCfgData,memEquipData:MemEquipData):void
		{
			_tab.clearAllStars();
			var strengthenStars:Vector.<String> = memEquipData.strengthenStars();
			var j:int,l:int = strengthenStars.length;
			for(j=0; j<l; j++)
			{
				var star:ForgeStars = new ForgeStars();
				star.mouseChildren = false;
				/*var frameLanbel:String = memEquipData.strengthen>j? ConstStarsFlag.STAR_FRAME : ConstStarsFlag.STAR_GREY_FRAME;*/
				var frameLanbel:String = strengthenStars[j];
				_tab.starsConainer.addChild(star);
				/*var tempMemEquip:MemEquipData = new MemEquipData();
				tempMemEquip.copy(memEquipData);
				tempMemEquip.strengthen = j+1;*/
				_tab.loadStarMc(star,/*tempMemEquip,*/frameLanbel);
				star.x = j*(star.width-1.5);
				if(j == memEquipData.strengthen)
				{
					star.filters = [TabStrengthen.STAR_FILTER];
				}
				/*star.addEventListener(MouseEvent.MOUSE_OVER,onStarMouseMove);
				star.addEventListener(MouseEvent.MOUSE_OUT,onStarMouseOut);*/
			}
			/*loadStarEffects();*/
		}
		
		private function loadStarEffects():void
		{
			destroyStarEffects();
			_effectVector = new Vector.<UIEffectLoader>();
			for(var k:int = 0; k<memEquipData.strengthen;k++)
			{
				var effectLoader:UIEffectLoader = new UIEffectLoader(_tab,216+k*25.5,241,1,1,EffectConst.RES_STRENGTH_STAR);
				_effectVector.push(effectLoader);
			}
		}
		
		/*public function onStarMouseMove(event:MouseEvent):void
		{
		var star:ForgeStars = event.currentTarget as ForgeStars;
		var index:int = _view.starsConainer.getChildIndex(star);
		for(var i:int = 0;i<_view.starsConainer.numChildren;i++)
		{
		star = _view.starsConainer.getChildAt(i) as ForgeStars;
		var frameLabel:String = i<=index? ConstStarsFlag.STARS_FRAME : ConstStarsFlag.GREY_STARS_FRAME;
		star.star.gotoAndStop(frameLabel);
		star.filters = null;
		}
		}
		
		public function onStarMouseOut(event:MouseEvent):void
		{
		if(!memEquipData)
		return;
		var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
		if(!equipCfgData)
		return;
		var star:ForgeStars;
		for(var i:int = 0;i<_view.starsConainer.numChildren;i++)
		{
		star = _view.starsConainer.getChildAt(i) as ForgeStars;
		var frameLabel:String = memEquipData.strengthen>i? ConstStarsFlag.STARS_FRAME : ConstStarsFlag.GREY_STARS_FRAME;
		star.star.gotoAndStop(frameLabel);
		if(i == memEquipData.strengthen)
		star.filters = [TabStrengthen.STAR_FILTER];
		}
		}*/
		
		private function updateToStrengthen(equipCell:EquipCell):void
		{
			_tab.toStrengthenEquip.copyRefreshData(equipCell);
			_tab.toStrengthenEquip.addLevel(isPolish);
			ToolTipManager.getInstance().attach(_tab.toStrengthenEquip);
			showMateria();
			isShowProtect();
			updateAboutMaterialPosition(_tab.skinThis.mcUseProtect.protectSingleBtn.selected);
		}
		
		private function showMateria():void
		{
			if(!memEquipData)
			{
				return;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				return;
			}
			if(isToMax())
			{
				_tab.materiaIcon.setNull();
				ToolTipManager.getInstance().detach(_tab.materiaIcon);
				_tab.skinThis.materiaNum.text = "";
			}
			else
			{
				if(!isPolish)
				{
					var equipStrengthen:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
					var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(equipStrengthen.stone);
					if(!itemCfg)
					{
						return;
					}
					var url:String = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfg.icon+ResourcePathConstants.POSTFIX_PNG;
					var bagData:BagData = BagDataManager.instance.getItemById(equipStrengthen.stone);
					if(bagData)
					{
						_tab.materiaIcon.slot = bagData.slot;
					}
					_tab.materiaIcon.loadPicFromURL(url);
					_tab.materiaIcon.tipType = ToolTipConst.SHOP_ITEM_TIP;
					_tab.materiaIcon.npcShopCfgData = ConfigDataManager.instance.npcShopCfgDataByBase(equipStrengthen.stone);
					ToolTipManager.getInstance().attach(_tab.materiaIcon);
					var itemNum:int = BagDataManager.instance.getItemNumById(equipStrengthen.stone);
					itemNum += HeroDataManager.instance.getItemNumById(equipStrengthen.stone);
					_tab.skinThis.materiaNum.textColor = itemNum < equipStrengthen.stone_count ? 0xff0000: 0x009900;
					_tab.skinThis.materiaNum.text = itemNum+"/"+equipStrengthen.stone_count.toString();
				}
				else
				{
					var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish + 1);
					itemCfg = ConfigDataManager.instance.itemCfgData(equipPolishCfgData.stone);
					if(!itemCfg)
					{
						return;
					}
					url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfg.icon+ResourcePathConstants.POSTFIX_PNG;
					bagData = BagDataManager.instance.getItemById(equipPolishCfgData.stone);
					if(bagData)
					{
						_tab.materiaIcon.slot = bagData.slot;
					}
					_tab.materiaIcon.loadPicFromURL(url);
					_tab.materiaIcon.tipType = ToolTipConst.SHOP_ITEM_TIP;
					_tab.materiaIcon.npcShopCfgData = ConfigDataManager.instance.npcShopCfgDataByBase(equipPolishCfgData.stone);
					ToolTipManager.getInstance().attach(_tab.materiaIcon);
					itemNum = BagDataManager.instance.getItemNumById(equipPolishCfgData.stone);
					itemNum += HeroDataManager.instance.getItemNumById(equipPolishCfgData.stone);
					_tab.skinThis.materiaNum.textColor = itemNum < equipPolishCfgData.stone_count ? 0xff0000: 0x009900;
					_tab.skinThis.materiaNum.text = itemNum+"/"+equipPolishCfgData.stone_count.toString();
				}
			}
		}
		
		private function isShowProtect():void
		{
			if(!_tab.skinThis.mcUseProtect.protectSingleBtn.selected || isPolish)
			{
				hideProtect();
				return;
			}
			
			_tab.skinThis.protect.visible = true;
			_tab.skinThis.protectNumBg.visible = true;
			_tab.skinThis.protectNum.visible = true;
			_tab.protectIcon.visible = true;
			
			if(!memEquipData)
				return;
			if(isToMax())
			{
				_tab.protectIcon.setNull();
				_tab.skinThis.protectNum.text = "";
				ToolTipManager.getInstance().detach(_tab.protectIcon);
				return;
			}
			
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
				return;
			var equipStrengthen:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
			var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(equipStrengthen.protect);
			if(!itemCfg)
				return;
			var url:String = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfg.icon+ResourcePathConstants.POSTFIX_PNG;
			_tab.protectIcon.loadPicFromURL(url);
			_tab.protectIcon.tipType = ToolTipConst.SHOP_ITEM_TIP;
			_tab.protectIcon.npcShopCfgData = ConfigDataManager.instance.npcShopCfgDataByBase(equipStrengthen.protect);
			ToolTipManager.getInstance().attach(_tab.protectIcon);
			var itemNum:int = BagDataManager.instance.getItemNumById(equipStrengthen.protect);
			var countProtectTotal:int = countProtect(equipStrengthen);
			_tab.skinThis.protectNum.text = itemNum + "/" + countProtectTotal.toString();
			_tab.skinThis.protectNum.textColor = itemNum < countProtectTotal ? 0xff0000 : 0x009900;
			if(!isPolish)
			{
				_tab.skinThis.strengthenRateOrForgValueText.text = "100%";
                _tab.skinThis.strengthForgProgress.alpha = 1;
                _tab.skinThis.strengthForgProgress.width = 156;
			}
		}
		
		private function hideProtect():void
		{
			var _mcIntensify:McIntensify = _tab.skinThis;
			_mcIntensify.protect.visible = false;
			_mcIntensify.protectNum.visible = false;
			_mcIntensify.protectNumBg.visible = false;
			_tab.protectIcon.visible = false;
			
			ToolTipManager.getInstance().detach(_tab.protectIcon);
			_tab.protectIcon.setNull();
		}
		
		private function updateAboutMaterialPosition(isSelectProtect:Boolean):void
		{
			var _mcIntensify:McIntensify = _tab.skinThis;
			_mcIntensify.materia.x = isSelectProtect? 317.80+42-34 : 394+42-34;
			_mcIntensify.materiaNumBg.x = _mcIntensify.materia.x+5;
			_mcIntensify.materiaNum.x = _mcIntensify.materiaNumBg.x+2.45; 
			_tab.materiaIcon.x = _mcIntensify.materia.x+7;
		}
		
		private function updatePreviewStrengthen(equipCell:EquipCell):void
		{		
			_tab.sPreviewCell.nextRefreshData(equipCell);
			_tab.sPreviewCell.addNextLevel(isPolish);
			ToolTipManager.getInstance().attach(_tab.sPreviewCell);
			if(!memEquipData)
			{
				return;
			}
			var starX:int;
			if(!isPolish)
			{
				var sterengthenStr:String = memEquipData.strengthen.toString();
				if(sterengthenStr == _numStrengthenStr)
				{
					return;
				}
				_tab.forgeNumContainer.removeAllChild();
				_numPolishStr = "";
				_numStrengthenStr = sterengthenStr;
				starX = (90-sterengthenStr.length*45)/2+10;
				addForgeNum(memEquipData,memEquipData.strengthen,starX);
				if(!isToMax())//未强化到最大级
				{
					sterengthenStr = ((memEquipData.strengthen)+1).toString();
					starX = (54-sterengthenStr.length*45)/2+150;
					addForgeNum(memEquipData,memEquipData.strengthen+1,starX);
				}
			}
			else
			{
				var polishStr:String = memEquipData.polish.toString();
				if(polishStr == _numPolishStr)
				{
					return;
				}
				_tab.forgeNumContainer.removeAllChild();
				_numPolishStr = polishStr;
				_numStrengthenStr = "";
				starX = (90-polishStr.length*45)/2+18;
				addForgeNum(memEquipData,memEquipData.polish,starX);
				if(!isToMax())//未强化到最大级
				{
					polishStr = ((memEquipData.polish)+1).toString();
					starX = (54-polishStr.length*45)/2+158;
					addForgeNum(memEquipData,memEquipData.polish+1,starX);
				}
			}
		}
		
		private function addForgeNum(memEquipData:MemEquipData,strength:int,starX:int):void
		{
			var i:int;
			var forgeNum:ForgeNumber;
			var sterengthenStr:String = strength.toString();
			for(i = 0;i<sterengthenStr.length;i++)
			{
				forgeNum = new ForgeNumber();
				_tab.forgeNumContainer.addChild(forgeNum);
				forgeNum.x = starX+i*forgeNum.width;
				forgeNum.y = 132;
				if(int(sterengthenStr.charAt(i)) == 0)
				{
					forgeNum.y -= 2;
				}
				_tab.loadFrogNum(forgeNum,int(sterengthenStr.charAt(i))+1);
			}
		}
		
		private function clearPreviewStrengthen():void
		{
			_tab.forgeNumContainer.removeAllChild();
			_tab.sPreviewCell.setNull();
			_tab.skinThis.attr1.text = "";
			_tab.skinThis.attr2.text = "";
			_tab.skinThis.attr3.text = "";
			_tab.skinThis.forgeArrow.visible = true;
			_tab.skinThis.strengthMaxFlag.visible = false;
			_tab.skinThis.strengthenAddProText.text = StringConst.STRENGTH_PANEL_0009;
			ToolTipManager.getInstance().detach(_tab.sPreviewCell);
		}
		
		private function forgeProgressBarTipHandler(isAdd:Boolean):void
		{
			var progressBar:MovieClip = _tab.skinThis.forgeProgressTip;
			
			if(isAdd)
			{
				var tipVO:TipVO = new TipVO();
				tipVO.tipType = ToolTipConst.FORGE_PROGRESS_TIP;
				tipVO.tipData = memEquipData;
				ToolTipManager.getInstance().hashTipInfo(progressBar,tipVO);
				ToolTipManager.getInstance().attach(progressBar);
			}
			else
			{
				ToolTipManager.getInstance().detach(progressBar);
			}
		}
		
		private function isToMax():Boolean
		{
			if(!memEquipData)
			{
				return false
			}
			if(!isPolish)
			{
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if(!equipCfgData)
				{
					return false
				}
				if(memEquipData.strengthen == equipCfgData.strengthen)
				{
					return true;
				}
				else 
				{
					return false;
				}
			}
			else
			{
				if(memEquipData.polish >= 9)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		public function canStrengthOrPolish():Boolean
		{
			var equipCell:EquipCell = _tab.equipCellList[_selectIndex-1];
			if(!equipCell)
			{
				return false;
			}
			if(!memEquipData)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STRENGTH_PANEL_0014);
				return false;
			}
			if(isToMax())
			{
				trace("已经强化到最高等级,无法强化");
				errorStr = !isPolish ? StringConst.STRENGTH_PANEL_0013 : StringConst.STRENGTH_PANEL_0021;
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,errorStr);
				return false;
			}
			var nextStrengthen:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
			var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
			if(isPolish)
			{
				if(memEquipData.strengthen < equipPolishCfgData.equipstrong_limit)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STRENGTH_PANEL_0024);
					return false;
				}
			}
			var coinNeed:int = !isPolish ? (nextStrengthen ? nextStrengthen.coin : 0) : (equipPolishCfgData ? equipPolishCfgData.coin : 0);
			if(coinNeed > BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind)
			{
				trace("金币不够");
				var errorStr:String = !isPolish ? StringConst.STRENGTH_PANEL_0010 : StringConst.STRENGTH_PANEL_0025;
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,errorStr);
				return false;
			}
			if(int(_tab.skinThis.txtGoldValue.text) > BagDataManager.instance.goldUnBind)
			{
				trace("元宝不够");
				errorStr = !isPolish ? StringConst.STRENGTH_PANEL_0012 : StringConst.STRENGTH_PANEL_0027;
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,errorStr);
				return false;
			}
			if(!_tab.skinThis.mcMaterialLack.goldBuyBtn.selected)
			{
				var materialIsEnough:int = materialEnough();
				if (materialIsEnough == 1 || materialIsEnough == 3)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STRENGTH_PANEL_0011);
					return false;
				}
				else if (materialIsEnough == 2)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STRENGTH_PANEL_0026);
					return false;
				}
			}
			if(!isPolish)
			{
				trace("StrengthenHandle.canStrengthOrPolish() isStrengthenCDOver:"+isStrengthenCDOver);
				if(!isStrengthenCDOver)
				{
					/*Alert.warning(StringConst.STRENGTH_PANEL_TIP_0001);*/
					return false;
				}
				_timeLastStrengthen = getTimer();
				_tab.skinThis.btnSure.btnEnabled = false;
				var timerId:uint = setTimeout(function(timerId:int):void
				{
					if(_tab && _tab.skinThis)
					{
						_tab.skinThis.btnSure.btnEnabled = true;
					}
					clearTimeout(timerId);
				},cdStrength,timerId);
			}
			showTip();
			return true;
		}
		/**
		 * 判断材料是否足够
		 * @return 0:材料足够，1：材料不足，无法强化，2：材料不足，无法打磨，3：保护符不足
		 */		
		private function materialEnough():int
		{
			if(!isPolish)
			{
				var nextStrengthen:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
				if(nextStrengthen)
				{
					var itemNum:int = BagDataManager.instance.getItemNumById(nextStrengthen.stone);
					itemNum += HeroDataManager.instance.getItemNumById(nextStrengthen.stone);
					if(itemNum < nextStrengthen.stone_count)
					{
						trace("StrengthenHandle.isMaterialEnough(nextStrengthen) 强化材料不足，请购买");
						return 1;
					}
					if(_tab.skinThis.mcUseProtect.protectSingleBtn.selected && !isPolish)
					{
						nextStrengthen = ConfigDataManager.instance.equipStrengthen(memEquipData.strengthen+1);
						var protectNum:int = BagDataManager.instance.getItemNumById(nextStrengthen.protect);
						var countProtectTotal:int = countProtect(nextStrengthen);
						if (protectNum < countProtectTotal)
						{
							trace("StrengthenHandle.isMaterialEnough(nextStrengthen) 保护符不足，请购买");
							return 3;
						}
					}
				}
			}
			else
			{
				var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
				if(equipPolishCfgData)
				{
					itemNum = BagDataManager.instance.getItemNumById(equipPolishCfgData.stone);
					itemNum += HeroDataManager.instance.getItemNumById(equipPolishCfgData.stone);
					if(itemNum < equipPolishCfgData.stone_count)
					{
						trace("StrengthenHandle.isMaterialEnough(nextStrengthen) 强化材料不足，请购买");
						return 2;
					}
				}
			}
			return 0;
		}
		/**显示系统提示及收益提示*/
		private function showTip():void
		{
			var coin:String = (_tab.skin as McIntensify).txtCoinValue.text;
			var replace:String = StringConst.FORGE_PANEL_0008.replace(/&x/g,StringConst.FORGE_PANEL_0006).replace(/&y/,coin);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
			IncomeDataManager.instance.addOneLine(replace);
		}
		/**需要的强化符数量*/
		private function countProtect(cfgDt:EquipStrengthenCfgData):int
		{
			var rate:int = rateSuccess(cfgDt);
			return Math.ceil((1000 - rate) * .1 * cfgDt.protect_rate * .001);
		}
		/**成功几率，0-1000*/
		private function rateSuccess(cfgDt:EquipStrengthenCfgData):int
		{
			var vipCfgData:VipCfgData = VipDataManager.instance.vipCfgData;
			var rate:int = (vipCfgData ? vipCfgData.strongthen_rate : 0) + (cfgDt ? cfgDt.rate : 0);
			rate = rate > 1000 ? 1000 : rate;
			return rate;
		}
		
		public function requestStrengthenOrPolish(isProtect:int,isUseGold:int):void
		{
			if(isAutoPolishing)
			{
				Alert.warning(StringConst.STRENGTH_PANEL_0035);
				return;
			}
			if(!canStrengthOrPolish())
			{
				return;
			}
			var equipCell:EquipCell = _tab.equipCellList[_selectIndex-1];
			var byteArray:ByteArray = new ByteArray();
			if(!isPolish)
			{
				byteArray.writeByte(equipCell.storageType);
				byteArray.writeByte(equipCell.slot);
				byteArray.writeByte(isProtect);
				byteArray.writeByte(isUseGold);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_STRENGTHEN, byteArray);
			}
			else
			{
				byteArray.writeByte(equipCell.storageType);
				byteArray.writeByte(equipCell.slot);
				byteArray.writeByte(isUseGold);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_POLISH, byteArray);
			}
		}
		/**是否自动打磨中*/
		public function get isAutoPolishing():Boolean
		{
			if(ForgeDataManager.instance.continuePolishTimeId)
			{
				return true;
			}
			return false;
		}
		
		public function continueRequestPolish(sendStrengthenVO:SendStrengthenVO):void
		{
			if(!canStrengthOrPolish() || !sendStrengthenVO)
			{
				ForgeDataManager.instance.stopIntervalPolishRequest();
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeByte(sendStrengthenVO.storageType);
			byteArray.writeByte(sendStrengthenVO.slot);
			byteArray.writeByte(sendStrengthenVO.isUseGold);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_POLISH, byteArray);
			if(_accruePolish)
			{
				_accruePolish.accruePolishCost(_memEquipData);
			}
		}
		
		public function destoryAccruePolish():void
		{
			if(_accruePolish)
			{
				if (_memEquipData)
				{
					accruePolishInfo();
				}
				_accruePolish.showPrompt();
				_accruePolish.destroy();
				_accruePolish = null
			}
		}
		
		public function accruePolishInfo():void
		{
			if(_accruePolish)
			{
				_accruePolish.accruePolishInfo(_memEquipData);
			}
		}
		
		/**切换强化/打磨模式*/
		public function switchMode(mode:int):void
		{
			var skin:McIntensify = _tab.skinThis;
			skin.mcUseProtect.protectSingleBtn.selected = false;
			skin.mcMaterialLack.goldBuyBtn.selected = false;
			_mode = mode;
			var mc:MovieClip;
			if(skin.btnRoleEquip.selected)
			{
				mc = skin.btnRoleEquip;
			}
			else if(skin.btnHeroEquip.selected)
			{
				mc = skin.btnHeroEquip;
			}
			else
			{
				mc = skin.btnBagItem;
			}
			changeToBeStrengthenedList(mc);
			changeMemequipData();
			_tab.sPreviewCell.isPolish = isPolish;
		}
		
		private function get isPolish():Boolean
		{
			return _mode == MODE_POLISH;
		}
		
		public function initPageScrollBar(mc:MovieClip):void
		{
			_shopHandle.initPageScrollBar(mc);
		}
		
		public function destroy():void
		{
			if(_shopHandle)
			{
				_shopHandle.destroy();
			}
			ForgeDataManager.instance.stopIntervalPolishRequest();
			_toStrengthenedList = null;
			_memEquipData = null;
			instance = null;
			destroyStarEffects();
		}
		
		private function destroyStarEffects():void
		{
			while(_effectVector && _effectVector.length >0)
			{
				var shift:UIEffectLoader = _effectVector.shift();
				shift.destroy();
			}
			_effectVector = null;
		}
	}
}