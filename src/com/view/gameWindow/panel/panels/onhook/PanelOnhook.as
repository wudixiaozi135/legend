package com.view.gameWindow.panel.panels.onhook
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.ButtonSelectWithLoad;
	import com.view.gameWindow.common.CountCallback;
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.TextMenu;
	import com.view.gameWindow.panel.panels.onhook.states.common.ConfigAuto;
	import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.events.Request;
	import mx.utils.StringUtil;

	public class PanelOnhook extends TabBase
	{
		
		private var _mc:McOnhookSet;
		private var _rangeGroup:ButtonSelectWithLoad;
		private var _oneTargetSkillGroup:ButtonSelectWithLoad;
		private var _multiTargetSkillGroup:ButtonSelectWithLoad;
		private var _icons:Array;
		private var _pickUpBtnLoadCallback:CountCallback;
		private var _onhookBtnLoadCallback:CountCallback;
		
		private var pickUpDrugLvMenu:TextMenu;
		private var pickUpEquipLvMenu:TextMenu;
		private var pickUpEquipQualityMenu:TextMenu;
		private var timeTPMenu:TextMenu;
		
		public function PanelOnhook()
		{
		}
		
		override public function update(proc:int=0):void
		{
			super.update(proc);
			
			if(proc == AutoDataManager.EVENT_UPDATE_ONE_TARGET_SKILL)
			{
				_oneTargetSkillGroup.selectedIndex = AutoDataManager.instance.oneTargetSkillIndex;
			}
			else if(proc == AutoDataManager.EVENT_UPDATE_MULTI_TARGET_SKILL)
			{
				_multiTargetSkillGroup.selectedIndex = AutoDataManager.instance.multiTargetSkillIndex;
			}
		}
		
		public function setSkillIcons(datas:Array):void
		{
			var hasMultiTargetSkill:Boolean = false;
			for(var i:int = 0; i < _icons.length; ++i)
			{
				if(i < datas.length)
				{
					IconCellEx.setItemBySkill(_icons[i],datas[i]);
					
					_mc["icon"+i].visible = Boolean(datas[i]);
					updateRadioButtonState(i,Boolean(datas[i]));
					
					if(i>=2 && datas[i])
					{
						hasMultiTargetSkill = true;
					}
				}
				else
				{
					IconCellEx.setItemBySkill(_icons[i],null);
					_mc["icon"+i].visible = false;
					updateRadioButtonState(i,false);
				}
			}
			
			_mc.txt14.visible = hasMultiTargetSkill;
		}
		
		private function updateRadioButtonState(index:int,value:Boolean):void
		{
			if(index<2)
			{
				_mc["oneSkill"+index].visible = value;
			}
			else
			{
				_mc["multiSkill"+(index-2)].visible = value;
			}
		}
		
		override protected function initSkin():void
		{
			_mc = new McOnhookSet();
			
			_skin = _mc;
			addChild(_skin);
			
			initTxt();
			initSkills();
			
			setSkillIcons(AutoDataManager.instance.getAutoFightSkills());
			
			addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
			
			AutoSystem.instance.addEventListener("updateAutoFight",updateAutoFighthandler,false,0,true);
		}
		
		override public function destroy():void
		{

			
			removeEventListener(MouseEvent.CLICK,clickHandler);
			AutoSystem.instance.removeEventListener("updateAutoFight",updateAutoFighthandler);
			
			_mc.txt8.removeEventListener(TextEvent.LINK,pickUpDrugLvHandler);
			_mc.txt12.removeEventListener(TextEvent.LINK,pickUpEquipHandler);
			_mc.txt7.removeEventListener(TextEvent.LINK,timeTPHandler);
			
			_rangeGroup.destroy();
			_rangeGroup = null;
			_oneTargetSkillGroup.destroy();
			_oneTargetSkillGroup = null;
			_multiTargetSkillGroup.destroy();
			_multiTargetSkillGroup = null;
			_pickUpBtnLoadCallback.destroy();
			_pickUpBtnLoadCallback = null;
			_onhookBtnLoadCallback.destroy();
			_onhookBtnLoadCallback = null;
			
			clearSkills();
			_icons = null;
			super.destroy();
			
			_mc = null;
		}
		
		public function updateExcuteBtn():void
		{
			var isFight:Boolean = AutoSystem.instance.isAutoFight();
			_mc.btnExcute.txt.text = isFight ? StringConst.AUTO_FIGHT_STOP:StringConst.AUTO_FIGHT_START;
		}
		
		//挂机
		public function updateOnhookBtns():void
		{
			initOnhookBtns();
			AutoDataManager.instance.sendCfg();
		}
		
		private function initOnhookBtns():void
		{
//			_mc.btnRepair.selected = AutoDataManager.instance.isRepair;
			_mc.btnCAttack.selected = AutoDataManager.instance.isCAttack;
			
			_mc.btnTP.selected = AutoDataManager.instance.isTP;
			_mc.btnRevive.selected = AutoDataManager.instance.isRevive;
			_mc.btnTime.selected = AutoDataManager.instance.isTime;
			_mc.txt7.htmlText =
				HtmlUtils.createHtmlStr(0xD5B300,
					StringUtil.substitute(StringConst.AUTO_TXT008,
						"<u><a href='event:setPickUpDragLv'>"+AutoDataManager.instance.timeName+"</a></u>"));
		}
		
		//拾取
		public function updatePickUpBtns():void
		{
			initPickUpBtns();
			AutoDataManager.instance.sendCfg();
		}
		
		private function initPickUpBtns():void
		{
			//coin
			_mc.btnCoin.selected = AutoDataManager.instance.isPickUpCoin;
			//drug
			_mc.btnDrug.selected = AutoDataManager.instance.isPickUpDrug;
			_mc.txt8.htmlText = 
				HtmlUtils.createHtmlStr(0xD5B300,
					StringUtil.substitute(StringConst.AUTO_TXT009,
						"<u><a href='event:setPickUpDragLv'>"+AutoDataManager.instance.pickUpDrugLv+StringConst.LEVEL+"</a></u>"));
			//material
			_mc.btnMaterial.selected = AutoDataManager.instance.isPickUpMaterial;
			//other
			_mc.btnOther.selected = AutoDataManager.instance.isPickUpOther;
			//equip
			_mc.btnEquip.selected = AutoDataManager.instance.isPickUpEquip;
			_mc.txt12.htmlText = 
				HtmlUtils.createHtmlStr(0xD5B300,
					StringUtil.substitute(StringConst.AUTO_TXT013,
						"<u><a href='event:setEquipLv'>"+(AutoDataManager.instance.pickUpEquipLv == 0 ? StringConst.TIP_TOTAL:AutoDataManager.instance.pickUpEquipLv+StringConst.LEVEL)+"</a></u>",
						"<u><a href='event:setEquipQuality'>"+AutoDataManager.instance.pickUpEquipQualityName+"</a></u>"));
		}
		
		private function updateAutoFighthandler(e:Event):void
		{
			updateExcuteBtn();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _mc.btnExcute:
					var isFight:Boolean = AutoSystem.instance.isAutoFight();
					
					AutoSystem.instance.stopAutoEx();
					if(isFight)
					{
//						AutoSystem.instance.stopAutoFight();
					}
					else
					{
						AutoSystem.instance.startAutoFight(FightPlace.FIGHT_PLACE_AUTO);
					}
					updateExcuteBtn();
					break;
				case _mc.btnCoin:
					AutoDataManager.instance.isPickUpCoin = !AutoDataManager.instance.isPickUpCoin;
					updatePickUpBtns();
					break;
				case _mc.btnDrug:
					AutoDataManager.instance.isPickUpDrug = !AutoDataManager.instance.isPickUpDrug;
					updatePickUpBtns();
					break;
				case _mc.btnMaterial:
					AutoDataManager.instance.isPickUpMaterial = !AutoDataManager.instance.isPickUpMaterial;
					updatePickUpBtns();
					break;
				case _mc.btnOther:
					AutoDataManager.instance.isPickUpOther = !AutoDataManager.instance.isPickUpOther;
					updatePickUpBtns();
					break;
				case _mc.btnEquip:
					AutoDataManager.instance.isPickUpEquip = !AutoDataManager.instance.isPickUpEquip;
					updatePickUpBtns();
					break;
//				case _mc.btnRepair:
////					AutoDataManager.instance.isRepair = !AutoDataManager.instance.isRepair;
//					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
//					updateOnhookBtns();
//					break;
				case _mc.btnCAttack:
					AutoDataManager.instance.isCAttack = !AutoDataManager.instance.isCAttack;
					updatePickUpBtns();
					break;
				case _mc.btnRevive:
					AutoDataManager.instance.isRevive = !AutoDataManager.instance.isRevive;
					updateOnhookBtns();
					break;
				case _mc.btnTime:
					AutoDataManager.instance.isTime = !AutoDataManager.instance.isTime;
					updateOnhookBtns();
					break;
				case _mc.btnTP:
					AutoDataManager.instance.isTP = !AutoDataManager.instance.isTP;
					updateOnhookBtns();
					AutoSystem.instance.resetAutoFightTime();
					break;
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
			initBtns(rsrLoader);
//			
			rsrLoader.addCallBack(_mc.btnExcute,function():void{updateExcuteBtn();});
			
			_pickUpBtnLoadCallback = new CountCallback(initPickUpBtns,5);
			rsrLoader.addCallBack(_mc.btnCoin,function():void{_pickUpBtnLoadCallback.call();});
			rsrLoader.addCallBack(_mc.btnDrug,function():void{_pickUpBtnLoadCallback.call();});
			rsrLoader.addCallBack(_mc.btnEquip,function():void{_pickUpBtnLoadCallback.call();});
			rsrLoader.addCallBack(_mc.btnMaterial,function():void{_pickUpBtnLoadCallback.call();});
			rsrLoader.addCallBack(_mc.btnOther,function():void{_pickUpBtnLoadCallback.call();});
			
			
			_onhookBtnLoadCallback = new CountCallback(initOnhookBtns,4);
//			rsrLoader.addCallBack(_mc.btnRepair,function():void{_onhookBtnLoadCallback.call();});
			rsrLoader.addCallBack(_mc.btnCAttack,function():void{_onhookBtnLoadCallback.call();});
			rsrLoader.addCallBack(_mc.btnRevive,function():void{_onhookBtnLoadCallback.call();});
			rsrLoader.addCallBack(_mc.btnTime,function():void{_onhookBtnLoadCallback.call();});
			rsrLoader.addCallBack(_mc.btnTP,function():void{_onhookBtnLoadCallback.call();});
		}
		
		
		private function initBtns(rsrLoader:RsrLoader):void
		{
			_rangeGroup = new ButtonSelectWithLoad(rsrLoader,_mc,["rang0","rang1","rang2"]);
//			_rangeGroup.preventSelectHandler = rangePrevent;
			_rangeGroup.selectedIndex = AutoDataManager.instance.rangeType;
			_rangeGroup.selectHandler = rangeSelect;
			_oneTargetSkillGroup = new ButtonSelectWithLoad(rsrLoader,_mc,["oneSkill0","oneSkill1"]);
			_oneTargetSkillGroup.selectedIndex = AutoDataManager.instance.oneTargetSkillIndex;
			_oneTargetSkillGroup.preventSelectHandler = oneTargetPrevent;
			_oneTargetSkillGroup.changeHandler = oneTargetChange;
			_oneTargetSkillGroup.cancelable = true;
			
			//tmp
//			_oneTargetSkillGroup.selectedIndex = AutoDataManager.instance.oneTargetSkillIndex;
//			if(_oneTargetSkillGroup.selectedIndex == -1)
//			{
//				for(var i:int = 0; i < 2; ++i)
//				{
//					if(!oneTargetPrevent(i,false))
//					{
//						_oneTargetSkillGroup.selectedIndex = i;
//						AutoDataManager.instance.oneTargetSkillIndex = i;
//						break;
//					}
//				}
//			}
			
			
			_multiTargetSkillGroup = new ButtonSelectWithLoad(rsrLoader,_mc,["multiSkill0","multiSkill1","multiSkill2"]);
			_multiTargetSkillGroup.selectedIndex = AutoDataManager.instance.multiTargetSkillIndex;
			_multiTargetSkillGroup.preventSelectHandler = multiTargetPrevent;
			_multiTargetSkillGroup.changeHandler = multiTargetChange;
			_multiTargetSkillGroup.cancelable = true;
			//tmp
			
			
//			if(_multiTargetSkillGroup.selectedIndex == -1)
//			{
//				for(var index:int = 0; index < 3; ++index)
//				{
//					if(!multiTargetPrevent(index,false))
//					{
//						_multiTargetSkillGroup.selectedIndex = index;
//						AutoDataManager.instance.multiTargetSkillIndex = index;
//						break;
//					}
//				}
//			}
		}
		
		private function rangePrevent(index:int):Boolean
		{
			if(index!=1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
				return true;
			}
			return false;
		}
		
		private function rangeSelect(btn:* = null):void
		{
			AutoDataManager.instance.rangeType = _rangeGroup.selectedIndex;
		}
		
//		private function oneTargetSelect(btn:* = null):void
//		{
//			AutoDataManager.instance.oneTargetSkillIndex = _oneTargetSkillGroup.selectedIndex;
//			AutoDataManager.instance.sendCfg();//放这会造成 初始化的时候多发一次
//		}
		
		private function oneTargetChange(index:int):void
		{
			AutoDataManager.instance.oneTargetSkillIndex = index;
			AutoDataManager.instance.sendCfg();//放这会造成 初始化的时候多发一次
		}
		
//		private function multiTargetSelect(btn:* = null):void
//		{
//			AutoDataManager.instance.multiTargetSkillIndex = _multiTargetSkillGroup.selectedIndex;
//			AutoDataManager.instance.sendCfg();
//		}
		
		private function multiTargetChange(index:int):void
		{
			AutoDataManager.instance.multiTargetSkillIndex = index;
			AutoDataManager.instance.sendCfg();
		}
		
		private function oneTargetPrevent(index:int,isWarnign:Boolean = true):Boolean
		{
			if(index>=0)
			{
				var code:int = AutoDataManager.instance.selectOneTargetSkill(index);
				if(code>0)
				{
					if(isWarnign)
					{
						showWarning(code);
					}
					return true;
				}
			}
			
			return false;
		}
		
		private function multiTargetPrevent(index:int,isWarning:Boolean = true):Boolean
		{
			if(index>=0)
			{
				var code:int = AutoDataManager.instance.selectMultiTargetSkill(index);
				if(code>0)
				{
					if(isWarning)
					{
						showWarning(code);
					}
					return true;
				}
			}
			
			return false;
		}
		
		public function showWarning(code:int):void
		{
			if(code>0)
			{
				if(code == 1)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.WARNING_SKILL_NOT_LEARN);
				}
				else if(code == 2)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.WARNING_SKILL_NONE);
				}
			}
		}
		
		private function clearSkills():void
		{
			for each(var item:IconCellEx in _icons)
			{
				item.destroy();
				ToolTipManager.getInstance().detach(item);
				if(item.parent)
				{
					item.parent.removeChild(item);
				}
			}
			
			_icons = [];
		}
		
		private function initSkills():void
		{
			clearSkills();
			for(var i:uint = 0;i < 5; ++i)
			{
				var mc:MovieClip = _mc["icon"+i];
				var icon:IconCellEx = new IconCellEx(_mc,mc.x,mc.y,mc.width,mc.height);
				_icons.push(icon);
				ToolTipManager.getInstance().attach(icon);
			}
		}
		
		private function initTxt():void
		{
			_mc.title0.text = StringConst.AUTO_ONHOOK;
			_mc.title1.text = StringConst.AUTO_PICKUP;
			_mc.title2.text = StringConst.AUTO_ONHOOK_SKILL;
			
			_mc.txt0.text = StringConst.AUTO_TXT001;
			_mc.txt1.text = StringConst.AUTO_TXT002;
			_mc.txt2.text = StringConst.AUTO_TXT003;
			_mc.txt3.text = StringConst.AUTO_TXT004;
			
			_mc.txt4.text = StringConst.AUTO_TXT005;
//			_mc.txt5.text = StringConst.AUTO_TXT006;
			_mc.txt6.text = StringConst.AUTO_TXT007;
			_mc.txt7.text = StringConst.AUTO_TXT008;
			
			_mc.txt8.text = StringConst.AUTO_TXT009;
			_mc.txt9.text = StringConst.AUTO_TXT010;
			_mc.txt10.text = StringConst.AUTO_TXT011;
			_mc.txt11.text = StringConst.AUTO_TXT012;
			_mc.txt12.text = StringConst.AUTO_TXT013;
			_mc.txt15.text = StringConst.AUTO_TXT014;
			
			
			_mc.txt13.text = StringConst.AUTO_SKILL_RANG0;
			_mc.txt14.text = StringConst.AUTO_SKILL_RANG1;
			
			_mc.txt8.addEventListener(TextEvent.LINK,pickUpDrugLvHandler);
			_mc.txt12.addEventListener(TextEvent.LINK,pickUpEquipHandler);
			_mc.txt7.addEventListener(TextEvent.LINK,timeTPHandler);
		}
		
		
		
		private function pickUpDrugLvHandler(e:TextEvent):void
		{
			if(!pickUpDrugLvMenu)
			{
				pickUpDrugLvMenu = new TextMenu(ConfigAuto.DRUG_LVS_MENU);
				pickUpDrugLvMenu.addEventListener(Event.SELECT,pickUpDrugLvMenuHandler);
			}
			
			pickUpDrugLvMenu.x = MenuMediator.instance.mouseX+10;
			pickUpDrugLvMenu.y = MenuMediator.instance.mouseY+10;
			MenuMediator.instance.showMenu(pickUpDrugLvMenu);
		}
		
		private function timeTPHandler(e:TextEvent):void
		{
			if(!timeTPMenu)
			{
				timeTPMenu = new TextMenu(ConfigAuto.TIME_MENU);
				timeTPMenu.addEventListener(Event.SELECT,timeTPMenuHandler);
			}
			timeTPMenu.x = MenuMediator.instance.mouseX+10;
			timeTPMenu.y = MenuMediator.instance.mouseY+10;
			MenuMediator.instance.showMenu(timeTPMenu);
		}
		
		private function pickUpEquipHandler(e:TextEvent):void
		{
			switch(e.text)
			{
				case "setEquipLv":
					if(!pickUpEquipLvMenu)
					{
						pickUpEquipLvMenu = new TextMenu(ConfigAuto.EQUIP_LVS_MENU);
						pickUpEquipLvMenu.addEventListener(Event.SELECT,pickUpEquipLvMenuHandler);
					}
					pickUpEquipLvMenu.x = MenuMediator.instance.mouseX+10;
					pickUpEquipLvMenu.y = MenuMediator.instance.mouseY+10;
					MenuMediator.instance.showMenu(pickUpEquipLvMenu);
					break;
				case "setEquipQuality":
					if(!pickUpEquipQualityMenu)
					{
						pickUpEquipQualityMenu = new TextMenu(ConfigAuto.EQUIP_Q_MENU);
						pickUpEquipQualityMenu.addEventListener(Event.SELECT,pickUpEquipQualityMenuHandler);
					}
					pickUpEquipQualityMenu.x = MenuMediator.instance.mouseX+10;
					pickUpEquipQualityMenu.y = MenuMediator.instance.mouseY+10;
					MenuMediator.instance.showMenu(pickUpEquipQualityMenu);
					break;
			}
		}
		
	
		private function timeTPMenuHandler(e:Request):void
		{
			MenuMediator.instance.hideMenu(timeTPMenu);
			timeTPMenu = null;
			
			var index:int = int(e.value);
			if(index>=0)
			{
				AutoDataManager.instance.timeMin = ConfigAuto.TIMES[index];
				AutoDataManager.instance.timeName = ConfigAuto.TIME_MENU[index];
				updateOnhookBtns();
				AutoSystem.instance.resetAutoFightTime();
			}
		}
			
		private function pickUpDrugLvMenuHandler(e:Request):void
		{
			MenuMediator.instance.hideMenu(pickUpDrugLvMenu);
			pickUpDrugLvMenu = null;
			
			var index:int = int(e.value);
			if(index>=0)
			{
				AutoDataManager.instance.pickUpDrugLv = ConfigAuto.DRUG_LVS[index];
				updatePickUpBtns();
			}
		}
		
		private function pickUpEquipLvMenuHandler(e:Request):void
		{
			MenuMediator.instance.hideMenu(pickUpEquipLvMenu);
			pickUpEquipLvMenu.removeEventListener(Event.SELECT,pickUpEquipLvMenuHandler);
			pickUpEquipLvMenu = null;
			var index:int = int(e.value);
			if(index>=0)
			{
				AutoDataManager.instance.pickUpEquipLv = ConfigAuto.EQUIP_LVS[index];
				updatePickUpBtns();
			}
		}
		
		private function pickUpEquipQualityMenuHandler(e:Request):void
		{
			MenuMediator.instance.hideMenu(pickUpEquipQualityMenu);
			pickUpEquipQualityMenu.removeEventListener(Event.SELECT,pickUpEquipQualityMenuHandler);
			pickUpEquipQualityMenu = null;
			var index:int = int(e.value);
			if(index>=0)
			{
				AutoDataManager.instance.pickUpEquipQuality = ConfigAuto.EQUIP_QS[index];
				AutoDataManager.instance.pickUpEquipQualityName = ConfigAuto.EQUIP_Q_MENU[index];
				updatePickUpBtns();
			}
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			AutoDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			AutoDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}