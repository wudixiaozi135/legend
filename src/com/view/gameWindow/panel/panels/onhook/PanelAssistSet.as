package com.view.gameWindow.panel.panels.onhook
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.ButtonSelectWithLoad;
	import com.view.gameWindow.common.CountCallback;
	import com.view.gameWindow.common.DropDownListWithLoad;
	import com.view.gameWindow.panel.panels.onhook.states.common.ConfigAuto;
	import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PanelAssistSet extends TabBase
	{
		public static var DRUG_ITEM:Array = ["从大到小","从小到大"];	//中文 临时
		public static var TP_ITEM:Array = ["回城卷"];
		public static var REPAIR_ITEM:Array = ["战神油"];
		public static var SELL_LV:Array = ["30级","50级","60级"];
		
		public static var TIME:Array = ["5","10"];
		public static var TIME_X:Array = ["1","3","5","10"];
//		public static var EQUIP_PERCENT:Array = ["10%","20%","50%"];
		
		public static const NUM:int = 4;
		
		private var _mc:McAssistSet;
	
//		private var percentHPDropDown:DropDownListWithLoad;
//		private var percentHPXDropDown:DropDownListWithLoad;
//		private var percentMPDropDown:DropDownListWithLoad;
//		private var percentMPXDropDown:DropDownListWithLoad;
//		private var percentHPTPDropDown:DropDownListWithLoad;
		
		private var percentHPInput:TextField;
		private var percentHPXInput:TextField;
		private var percentMPInput:TextField;
		private var percentMPXInput:TextField;
		private var percentHPTPInput:TextField;
		
		
		private var itemHPDropDown:DropDownListWithLoad;
		private var itemHPXDropDown:DropDownListWithLoad;
		private var itemMPDropDown:DropDownListWithLoad;
		private var itemMPXDropDown:DropDownListWithLoad;
		private var itemHPTPDropDown:DropDownListWithLoad;
		
//		private var timeHPDropDown:DropDownListWithLoad;
//		private var timeHPXDropDown:DropDownListWithLoad;
//		private var timeMPDropDown:DropDownListWithLoad;
//		private var timeMPXDropDown:DropDownListWithLoad;
		
		private var timeHPInput:TextField;
		private var timeHPXInput:TextField;
		private var timeMPInput:TextField;
		private var timeMPXInput:TextField;
		
		private var equipPercentDropDown:DropDownListWithLoad;
		private var equipItemDropDown:DropDownListWithLoad;
		
//		private var equipSellLvDropDown:DropDownListWithLoad;
		
		private var danBtns:ButtonSelectWithLoad;
		
		private var _icons:Array;
		
		private var drugBtnCallback:CountCallback;
		private var skillBtnCallback:CountCallback;
		
		public function PanelAssistSet()
		{
		}
		
		override protected function initSkin():void
		{
			_skin = new McAssistSet();
			_mc = _skin as McAssistSet;
			addChild(_mc);
			
			initTxts();
			initSkills();
			
			setSkillIcons(AutoDataManager.instance.getAutoSkills());
			
			addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
			AutoSystem.instance.addEventListener("updateAutoFight",updateAutoFighthandler,false,0,true);
			
		}
		
		override public function update(proc:int=0):void
		{
			super.update(proc);
			
			if(proc == AutoDataManager.EVENT_UPDATE_ONE_TARGET_SKILL)
			{
				_mc.btn10.selected = Boolean(AutoDataManager.instance.quickSetState[1]);
			}
			else if(proc == AutoDataManager.EVENT_UPDATE_MULTI_TARGET_SKILL)
			{
				_mc.btn9.selected = Boolean(AutoDataManager.instance.quickSetState[0]);
			}
			else if(proc == AutoDataManager.EVENT_UPDATE_WITHOUT_SHIFT)
			{
				_mc.btn8.selected = AutoDataManager.instance.isWithoutShift;
			}
			else if(proc == AutoDataManager.EVENT_UPDATE_AUTO_SKILL)
			{
				updateSkillBtnState();
			}
			else if(proc == AutoDataManager.EVENT_UPDATE_AUTO_SKILL_CHANGE)
			{
				setSkillIcons(AutoDataManager.instance.getAutoSkills());
			}
			else if(proc == AutoDataManager.EVENT_UPDATE_MAGIC_LOCK)
			{
				_mc.btn9.selected = AutoDataManager.instance.isMagicLocking;
			}
		}
		
		override public function destroy():void
		{
			AutoSystem.instance.removeEventListener("updateAutoFight",updateAutoFighthandler);
			
			AutoDataManager.instance.detach(this);
			
			removeEventListener(MouseEvent.CLICK,clickHandler);
			
//			percentHPDropDown.removeEventListener(Event.CHANGE,drugDropDownChangeHandler);
//			percentHPXDropDown.removeEventListener(Event.CHANGE,drugDropDownChangeHandler);
//			percentMPDropDown.removeEventListener(Event.CHANGE,drugDropDownChangeHandler);
//			percentMPXDropDown.removeEventListener(Event.CHANGE,drugDropDownChangeHandler);
			
			percentHPInput.removeEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			percentHPXInput.removeEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			percentMPInput.removeEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			percentMPXInput.removeEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			
			itemHPDropDown.removeEventListener(Event.CHANGE,drugDropDownChangeHandler);
			itemHPXDropDown.removeEventListener(Event.CHANGE,drugDropDownChangeHandler);
			itemMPDropDown.removeEventListener(Event.CHANGE,drugDropDownChangeHandler);
			itemMPXDropDown.removeEventListener(Event.CHANGE,drugDropDownChangeHandler);
			
			timeHPInput.removeEventListener(Event.CHANGE,drugInputChangeHandler);
			timeHPXInput.removeEventListener(Event.CHANGE,drugInputChangeHandler);
			timeMPInput.removeEventListener(Event.CHANGE,drugInputChangeHandler);
			timeMPXInput.removeEventListener(Event.CHANGE,drugInputChangeHandler);
			
//			percentHPDropDown.destroy();
//			percentHPDropDown = null;
//			percentHPXDropDown.destroy();
//			percentHPXDropDown = null;
//			percentMPDropDown.destroy();
//			percentMPDropDown = null;
//			percentMPXDropDown.destroy();
//			percentMPXDropDown = null;
//			percentHPTPDropDown.destroy();
//			percentHPTPDropDown = null;
			percentHPInput = null;
			percentHPXInput = null;
			percentMPInput = null;
			percentMPXInput = null;
			
			itemHPDropDown.destroy();
			itemHPDropDown = null;
			itemHPXDropDown.destroy();
			itemHPXDropDown = null;
			itemMPDropDown.destroy();
			itemMPDropDown = null;
			itemMPXDropDown.destroy();
			itemMPXDropDown = null;
			itemHPTPDropDown.destroy();
			itemHPTPDropDown = null;
			
//			timeHPDropDown.destroy();
//			timeHPDropDown = null;
//			timeHPXDropDown.destroy();
//			timeHPXDropDown = null;
//			timeMPDropDown.destroy();
//			timeMPDropDown = null;
//			timeMPXDropDown.destroy();
//			timeMPXDropDown = null;
			
			timeHPInput = null;
			timeHPXInput = null;
			timeMPInput = null;
			timeMPXInput = null;
			
			equipPercentDropDown.destroy();
			equipPercentDropDown = null;
			equipItemDropDown.destroy();
			equipItemDropDown = null;
			
//			equipSellLvDropDown.destroy();
//			equipSellLvDropDown = null;
			
			danBtns.destroy();
			danBtns = null;
			
			destroySkills();
			_icons = null;
			
			drugBtnCallback.destroy();
			skillBtnCallback.destroy();
			
			_mc = null;
			super.destroy();
		}
		
		private function updateCfgData():void
		{
			AutoDataManager.instance.sendCfg();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var dataMgr:AutoDataManager = AutoDataManager.instance;
			switch(e.target)
			{
				case _mc.btn0:
					dataMgr.hpCfg.isOpen = !dataMgr.hpCfg.isOpen;
					updateCfgData();
					break;
				case _mc.btn1:
					dataMgr.hpXCfg.isOpen = !dataMgr.hpXCfg.isOpen;
					updateCfgData();
					break;
				case _mc.btn2:
					dataMgr.mpCfg.isOpen = !dataMgr.mpCfg.isOpen;
					updateCfgData();
					break;
				case _mc.btn3:
					dataMgr.mpXCfg.isOpen = !dataMgr.mpXCfg.isOpen;
					updateCfgData();
					break;
				case _mc.btnDefault:
//					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
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
				case _mc.btn4:
					/*_mc.btn4.selected = false;*/
					dataMgr.isHPTP = !dataMgr.isHPTP;
					updateCfgData();
					/*RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);*/
					break;
				case _mc.btn5:
					/*_mc.btn5.selected = false;
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);*/
					dataMgr.isRepairOil = !dataMgr.isRepairOil;
					updateCfgData();
					break;
				/*case _mc.btn6://自动卖装备
					_mc.btn6.selected = false;
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
					break;*/
				case _mc.btn7:
					_mc.btn7.selected = false;
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
					break;
				case _mc.btn8://免shift
					/*_mc.btn8.selected = false;
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);*/
					dataMgr.setIsWithoutShift(!dataMgr.isWithoutShift);
					updateCfgData();
					break;
				case _mc.btn9://战士：半月弯刀开关，非战士：魔法锁定
					/*dataMgr.quickSetState[0] = dataMgr.quickSetState[0] ? 0 : 1;*/
					if(!selectQuickSet(0))
					{
						_mc.btn9.selected = !_mc.btn9.selected;
					}
					/*dataMgr.changeQuickSetState(0);*/
					updateCfgData();
					break;
				case _mc.btn10://战士：刺杀剑法开关
					/*dataMgr.quickSetState[1] = dataMgr.quickSetState[1] ? 0 : 1;*/
					if(!selectQuickSet(1))
					{
						_mc.btn10.selected = !_mc.btn10.selected;
					}
					updateCfgData();
					break;
				case _mc.btnSkill0:
					if(_mc.btnSkill0.selected && !selectSkill(0))
					{
						_mc.btnSkill0.selected = false;
					}
					setSkillState(0,_mc.btnSkill0.selected);
					updateCfgData();
					break;
				case _mc.btnSkill1:
					if(_mc.btnSkill1.selected && !selectSkill(1))
					{
						_mc.btnSkill1.selected = false;
					}
					setSkillState(1,_mc.btnSkill1.selected);
					updateCfgData();
					break;
				case _mc.btnSkill2:
					if(_mc.btnSkill2.selected && !selectSkill(2))
					{
						_mc.btnSkill2.selected = false;
					}
					setSkillState(2,_mc.btnSkill2.selected);
					updateCfgData();
					break;
				case _mc.btnSkill3:
					if(_mc.btnSkill3.selected && !selectSkill(3))
					{
						_mc.btnSkill3.selected = false;
					}
					setSkillState(3,_mc.btnSkill3.selected);
					updateCfgData();
					break;
			}
		}
		
		public function updateSkillBtnState():void
		{
			var dataMgr:AutoDataManager = AutoDataManager.instance;
			_mc.btnSkill0.selected = Boolean(dataMgr.autoSkillState[0]);
			_mc.btnSkill1.selected = Boolean(dataMgr.autoSkillState[1]);
			_mc.btnSkill2.selected = Boolean(dataMgr.autoSkillState[2]);
			_mc.btnSkill3.selected = Boolean(dataMgr.autoSkillState[3]);
			
			
			_mc.btnSkill0.visible = Boolean(dataMgr.autoSkillList[0]);
			_mc.btnSkill1.visible = Boolean(dataMgr.autoSkillList[1]);
			_mc.btnSkill2.visible = Boolean(dataMgr.autoSkillList[2]);
			_mc.btnSkill3.visible = Boolean(dataMgr.autoSkillList[3]);
			
			
			_mc.icon0.visible = Boolean(dataMgr.autoSkillList[0]);
			_mc.icon1.visible = Boolean(dataMgr.autoSkillList[1]);
			_mc.icon2.visible = Boolean(dataMgr.autoSkillList[2]);
			_mc.icon3.visible = Boolean(dataMgr.autoSkillList[3]);
			
			_mc.btn9.visible = Boolean(dataMgr.quickSet[0]);
			_mc.btn10.visible = Boolean(dataMgr.quickSet[1]);
			
			_mc.btn8.selected = dataMgr.isWithoutShift;
			_mc.btn9.selected = Boolean(dataMgr.quickSetState[0]);
			_mc.btn10.selected = Boolean(dataMgr.quickSetState[1]);
			
			_mc.txtSkill0.text = dataMgr.quickSet[0];
			_mc.txtSkill1.text = dataMgr.quickSet[1];
		}
		
		public function setSkillState(index:int,isSelected:Boolean):void
		{
			AutoDataManager.instance.autoSkillState[index] = isSelected ? 1 : 0;
		}
		
		public function selectSkill(index:int):Boolean
		{
			var code:int = AutoDataManager.instance.selectAutoSkill(index);
			if(code == 0)
			{
				return true;
			}
			else if(code == 1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.WARNING_SKILL_NOT_LEARN);
			}
			else if(code == 2)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.WARNING_SKILL_NONE);
			}
			
			return false;
		}
		
		public function selectQuickSet(index:int):Boolean
		{
			var code:int = AutoDataManager.instance.changeQuickSetState(index);
			if(code == 0)
			{
				return true;
			}
			else if(code == 1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.WARNING_SKILL_NOT_LEARN);
			}
			else if(code == 2)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.WARNING_SKILL_NONE);
			}
			
			return false;
		}
		
		public function updateDrugBtns():void
		{
			//如果消息 后到 就会出错。以后要改 ！！
			
			var dataMgr:AutoDataManager = AutoDataManager.instance;
			_mc.btn0.selected = dataMgr.hpCfg.isOpen;
			_mc.btn1.selected = dataMgr.hpXCfg.isOpen;
			_mc.btn2.selected = dataMgr.mpCfg.isOpen;
			_mc.btn3.selected = dataMgr.mpXCfg.isOpen;
			_mc.btn4.selected = dataMgr.isHPTP;
			_mc.btn5.selected = dataMgr.isRepairOil; 
//			percentHPDropDown.selectedIndex = ConfigAuto.HP.indexOf(dataMgr.hpCfg.percent);
//			percentHPXDropDown.selectedIndex = ConfigAuto.HPX.indexOf(dataMgr.hpXCfg.percent);
//			percentMPDropDown.selectedIndex = ConfigAuto.MP.indexOf(dataMgr.mpCfg.percent);
//			percentMPXDropDown.selectedIndex = ConfigAuto.MPX.indexOf(dataMgr.mpXCfg.percent);
			
			equipPercentDropDown.selectedIndex = ConfigAuto.REPAIR_OIL.indexOf(dataMgr.repairOilPercent);
			
			percentHPInput.text = dataMgr.hpCfg.percent.toString()+"%";
			percentHPXInput.text = dataMgr.hpXCfg.percent.toString()+"%";
			percentMPInput.text = dataMgr.mpCfg.percent.toString()+"%";
			percentMPXInput.text = dataMgr.mpXCfg.percent.toString()+"%";
			
			itemHPDropDown.selectedIndex = ConfigAuto.DRUG_DESCENT.indexOf(dataMgr.hpCfg.isDescent);
			itemHPXDropDown.selectedIndex = ConfigAuto.DRUG_DESCENT.indexOf(dataMgr.hpXCfg.isDescent);
			itemMPDropDown.selectedIndex = ConfigAuto.DRUG_DESCENT.indexOf(dataMgr.mpCfg.isDescent);
			itemMPXDropDown.selectedIndex = ConfigAuto.DRUG_DESCENT.indexOf(dataMgr.mpXCfg.isDescent);
			
//			timeHPDropDown.selectedIndex = ConfigAuto.DRUG_TIME.indexOf(dataMgr.hpCfg.cd);
//			timeHPXDropDown.selectedIndex = ConfigAuto.DRUG_TIME_X.indexOf(dataMgr.hpXCfg.cd);
//			timeMPDropDown.selectedIndex = ConfigAuto.DRUG_TIME.indexOf(dataMgr.mpCfg.cd);
//			timeMPXDropDown.selectedIndex = ConfigAuto.DRUG_TIME_X.indexOf(dataMgr.mpXCfg.cd);
			
			timeHPInput.text = dataMgr.hpCfg.cd.toString();
			timeHPXInput.text = dataMgr.hpXCfg.cd.toString();
			timeMPInput.text = dataMgr.mpCfg.cd.toString();
			timeMPXInput.text = dataMgr.mpXCfg.cd.toString();
			
			
//			percentHPTPDropDown.selectedIndex = ConfigAuto.TP.indexOf(dataMgr.hpTPPercent);
			
			percentHPTPInput.text = dataMgr.hpTPPercent.toString()+"%"/**100*/;
			
		
			
		}
		
		private function initTxts():void
		{
			_mc.txt0.text = StringConst.AUTO_DRUG_001;
			_mc.txt1.text = StringConst.AUTO_DRUG_001;
			
			_mc.txt2.text = StringConst.AUTO_DRUG_002;
			_mc.txt3.text = StringConst.AUTO_DRUG_002;
			
			_mc.txt4.text = StringConst.AUTO_DRUG_001;
			
			_mc.txt5.text = StringConst.AUTO_DRUG_003 + StringConst.AUTO_DRUG_006;
			_mc.txt6.text = StringConst.AUTO_DRUG_003 + StringConst.AUTO_DRUG_007;
			_mc.txt7.text = StringConst.AUTO_DRUG_003 + StringConst.AUTO_DRUG_006;
			_mc.txt8.text = StringConst.AUTO_DRUG_003 + StringConst.AUTO_DRUG_007;
			_mc.txt9.text = StringConst.AUTO_DRUG_003;
			
			_mc.txt10.text = StringConst.AUTO_DRUG_004;
			_mc.txt11.text = StringConst.AUTO_DRUG_004;
			_mc.txt12.text = StringConst.AUTO_DRUG_004;
			_mc.txt13.text = StringConst.AUTO_DRUG_004;
			
			_mc.txt14.text = StringConst.AUTO_DRUG_005;
			_mc.txt15.text = StringConst.AUTO_DRUG_005;
			_mc.txt16.text = StringConst.AUTO_DRUG_005;
			_mc.txt17.text = StringConst.AUTO_DRUG_005;
			
			_mc.title0.text = StringConst.AUTO_ASSIST_TITLE0;
			_mc.title1.text = StringConst.AUTO_ASSIST_TITLE1;
			_mc.title2.text = StringConst.AUTO_ASSIST_TITLE2;
			
			_mc.txtEquip0.text = StringConst.AUTO_ASSIST_EQUIP0;
			_mc.txtEquip1.text = StringConst.AUTO_ASSIST_USE;
			
//			_mc.txtEquipLv0.text = StringConst.AUTO_ASSIST_SELL0;
//			_mc.txtEquipLv1.text = StringConst.AUTO_ASSIST_SELL1;
			
			_mc.txtDan0.text = StringConst.AUTO_ASSIST_DAN0;
			_mc.txtDan1.text = StringConst.AUTO_ASSIST_DAN1;
			_mc.txtDan2.text = StringConst.AUTO_ASSIST_DAN2;
			
			_mc.txtAuto.text = StringConst.AUTO_ASSIST_AUTO;
			_mc.txtShfit.text = StringConst.AUTO_ASSIST_SHIFT;
			
			
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
			
			rsrLoader.addCallBack(_mc.btnDefault,function():void{initBtn();});
			
			initDrugDropDownList(rsrLoader);
			
			drugBtnCallback = new CountCallback(updateDrugBtns,6);
			
			rsrLoader.addCallBack(_mc.btn0,function():void{drugBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btn1,function():void{drugBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btn2,function():void{drugBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btn3,function():void{drugBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btn4,function():void{drugBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btn5,function():void{drugBtnCallback.call();});
			
			skillBtnCallback = new CountCallback(updateSkillBtnState,7);
			
			rsrLoader.addCallBack(_mc.btnSkill0,function():void{skillBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btnSkill1,function():void{skillBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btnSkill2,function():void{skillBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btnSkill3,function():void{skillBtnCallback.call();});
			
			rsrLoader.addCallBack(_mc.btn8,function():void{skillBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btn9,function():void{skillBtnCallback.call();});
			rsrLoader.addCallBack(_mc.btn10,function():void{skillBtnCallback.call();});
		}
		
		private function updateAutoFighthandler(e:Event):void
		{
			updateExcuteBtn();
		}
		
		public function updateExcuteBtn():void
		{
			var isFight:Boolean = AutoSystem.instance.isAutoFight();
			
			if(_mc.btnDefault.txt)
			{
				_mc.btnDefault.txt.text = isFight ? StringConst.AUTO_FIGHT_STOP:StringConst.AUTO_FIGHT_START;
			}
		}
		
		private function initBtn():void
		{
//			_mc.btnDefault.txt.text = StringConst.AUTO_ASSIST_DEFAULT;
			updateExcuteBtn();			
		}
		
		public function setSkillIcons(datas:Array):void
		{
			for(var i:int = 0; i < _icons.length; ++i)
			{
				if(i < datas.length)
				{
					IconCellEx.setItemBySkill(_icons[i],datas[i]);
				}
				else
				{
					IconCellEx.setItemBySkill(_icons[i],null);
				}
			}
		}
		
		private function destroySkills():void
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
			
			destroySkills();
			
			for(var i:int = 0; i < NUM; ++i)
			{
				var mc:MovieClip = _mc["icon"+i];
				var icon:IconCellEx =  new IconCellEx(_mc,mc.x,mc.y,mc.width,mc.height);
				_icons.push(icon);
				ToolTipManager.getInstance().attach(icon);
			}
		}
		
		private function drugInputChangeHandler(e:Event):void
		{
			var t:TextField = e.currentTarget as TextField;
			
			var value:Number = int(t.text);
			
			if(value > 99)
			{
				value = 99;
			}
			else if(value == 0)
			{
				value = 1;
			}
			
			var dm:AutoDataManager = AutoDataManager.instance;
			
			switch(t)
			{
				case percentHPInput:
					dm.hpCfg.percent = value;
					t.text = value.toString()+"%";
					break;
				case percentHPXInput:
					dm.hpXCfg.percent = value;
					t.text = value.toString()+"%";
					break;
				case percentMPInput:
					dm.mpCfg.percent = value;
					t.text = value.toString()+"%";
					break;
				case percentMPXInput:
					dm.mpXCfg.percent = value;
					t.text = value.toString()+"%";
					break;
				case percentHPTPInput:
					dm.hpTPPercent = value;
					t.text = value.toString()+"%";
					break; 
				case timeHPInput:
					dm.hpCfg.cd = value;
					t.text = value.toString();
					break;
				case timeHPXInput:
					dm.hpXCfg.cd = value;
					t.text = value.toString();
					break;
				case timeMPInput:
					dm.mpCfg.cd = value;
					t.text = value.toString();
					break;
				case timeMPXInput:
					dm.mpXCfg.cd = value;
					t.text = value.toString();
					break;
			}
			
			updateCfgData();
		}
		
		private function drugDropDownChangeHandler(e:Event):void
		{
			var dp:DropDownListWithLoad = e.currentTarget as DropDownListWithLoad;
			
			var index:int = dp.selectedIndex;
			if(index < 0)
			{
				return;
			}
				
			var dm:AutoDataManager = AutoDataManager.instance;
			
			switch(dp)
			{
//				case percentHPDropDown:
//					dm.hpCfg.percent = ConfigAuto.HP[index];
//					break;
//				case percentHPXDropDown:
//					dm.hpXCfg.percent = ConfigAuto.HPX[index];
//					break;
//				case percentMPDropDown:
//					dm.mpCfg.percent = ConfigAuto.MP[index];
//					break;
//				case percentMPXDropDown:
//					dm.mpXCfg.percent = ConfigAuto.MPX[index];
//					break;
				case itemHPDropDown:
					dm.hpCfg.isDescent = ConfigAuto.DRUG_DESCENT[index];
					break;
				case itemHPXDropDown:
					dm.hpXCfg.isDescent = ConfigAuto.DRUG_DESCENT[index];
					break;
				case itemMPDropDown:
					dm.mpCfg.isDescent = ConfigAuto.DRUG_DESCENT[index];
					break;
				case itemMPXDropDown:
					dm.mpXCfg.isDescent = ConfigAuto.DRUG_DESCENT[index];
					break;
//				case timeHPDropDown:
//					dm.hpCfg.cd = ConfigAuto.DRUG_TIME[index];
//					break;
//				case timeHPXDropDown:
//					dm.hpXCfg.cd = ConfigAuto.DRUG_TIME_X[index];
//					break;
//				case timeMPDropDown:
//					dm.mpCfg.cd = ConfigAuto.DRUG_TIME[index];
//					break;
//				case timeMPXDropDown:
//					dm.mpXCfg.cd = ConfigAuto.DRUG_TIME_X[index];
//					break;
//				case percentHPTPDropDown:
//					dm.hpTPPercent = ConfigAuto.TP[index];
//					break;
				case equipPercentDropDown:
					dm.repairOilPercent = ConfigAuto.REPAIR_OIL[index];
					break;
			}
			
			updateCfgData();
		}
		
		private function initDrugDropDownList(rsrLoader:RsrLoader):void
		{
//			percentHPDropDown = new DropDownListWithLoad(ConfigAuto.HP_PERCENT,_mc.txtPercent0,_mc.btnPercent0.width,rsrLoader,_mc,"btnPercent0");
//			percentHPXDropDown = new DropDownListWithLoad(ConfigAuto.HPX_PERCENT,_mc.txtPercent1,_mc.btnPercent1.width,rsrLoader,_mc,"btnPercent1");
//			percentMPDropDown = new DropDownListWithLoad(ConfigAuto.MP_PERCENT,_mc.txtPercent2,_mc.btnPercent2.width,rsrLoader,_mc,"btnPercent2");
//			percentMPXDropDown= new DropDownListWithLoad(ConfigAuto.MPX_PERCENT,_mc.txtPercent3,_mc.btnPercent3.width,rsrLoader,_mc,"btnPercent3");
//			percentHPTPDropDown= new DropDownListWithLoad(ConfigAuto.TP_PERCENT,_mc.txtPercent4,_mc.btnPercent4.width,rsrLoader,_mc,"btnPercent4");
			
			percentHPInput = _mc.txtPercent0;
			percentHPXInput = _mc.txtPercent1;
			percentMPInput = _mc.txtPercent2;
			percentMPXInput = _mc.txtPercent3;
			percentHPTPInput = _mc.txtPercent4;
			
			itemHPDropDown = new DropDownListWithLoad(DRUG_ITEM,_mc.txtItem0,_mc.btnItem0.width+_mc.btnDown0.width,rsrLoader,_mc,"btnItem0","btnDown0");
			itemHPXDropDown = new DropDownListWithLoad(DRUG_ITEM,_mc.txtItem1,_mc.btnItem1.width+_mc.btnDown1.width,rsrLoader,_mc,"btnItem1","btnDown1");
			itemMPDropDown = new DropDownListWithLoad(DRUG_ITEM,_mc.txtItem2,_mc.btnItem2.width+_mc.btnDown2.width,rsrLoader,_mc,"btnItem2","btnDown2");
			itemMPXDropDown = new DropDownListWithLoad(DRUG_ITEM,_mc.txtItem3,_mc.btnItem3.width+_mc.btnDown3.width,rsrLoader,_mc,"btnItem3","btnDown3");
			itemHPTPDropDown = new DropDownListWithLoad(TP_ITEM,_mc.txtItem4,_mc.btnItem4.width+_mc.btnDown4.width,rsrLoader,_mc,"btnItem4","btnDown4");
			
//			timeHPDropDown = new DropDownListWithLoad(TIME,_mc.txtTime0,_mc.btnTime0.width,rsrLoader,_mc,"btnTime0");
//			timeHPXDropDown = new DropDownListWithLoad(TIME_X,_mc.txtTime1,_mc.btnTime1.width,rsrLoader,_mc,"btnTime1");
//			timeMPDropDown = new DropDownListWithLoad(TIME,_mc.txtTime2,_mc.btnTime2.width,rsrLoader,_mc,"btnTime2");
//			timeMPXDropDown = new DropDownListWithLoad(TIME_X,_mc.txtTime3,_mc.btnTime3.width,rsrLoader,_mc,"btnTime3");
			
			timeHPInput = _mc.txtTime0;
			timeHPXInput = _mc.txtTime1;
			timeMPInput = _mc.txtTime2;
			timeMPXInput = _mc.txtTime3;
			
			percentHPInput.restrict = "0-9 %";
			percentHPXInput.restrict = "0-9 %";
			percentMPInput.restrict = "0-9 %";
			percentMPXInput.restrict = "0-9 %";
			
			timeHPInput.restrict = "0-9 %";
			timeHPXInput.restrict = "0-9 %";
			timeMPInput.restrict = "0-9 %";
			timeMPXInput.restrict = "0-9 %";
			
			equipPercentDropDown = new DropDownListWithLoad(ConfigAuto.REPAIR_OIL_PERCENT,_mc.txtEquipPercent,_mc.btnEquipPercent.width,rsrLoader,_mc,"btnEquipPercent");
			
			equipItemDropDown = new DropDownListWithLoad(REPAIR_ITEM,_mc.txtEquipItem,_mc.btnEquipItem.width+_mc.btnEquipDown.width,rsrLoader,_mc,"btnEquipItem","btnEquipDown");
			
//			equipSellLvDropDown = new DropDownListWithLoad(SELL_LV,_mc.txtEquipLv,_mc.btnEquipLv.width,rsrLoader,_mc,"btnEquipLv");
			
			danBtns = new ButtonSelectWithLoad(rsrLoader,_mc,["btnDan0","btnDan1"]);
			
			equipPercentDropDown.selectedIndex = 0;
			equipItemDropDown.selectedIndex = 0;
//			equipSellLvDropDown.selectedIndex = 0;
			danBtns.selectedIndex = 0;
			
//			percentHPDropDown.selectedIndex = 0;
//			percentHPXDropDown.selectedIndex = 0;
//			percentMPDropDown.selectedIndex = 0;
//			percentMPXDropDown.selectedIndex = 0;
//			percentHPTPDropDown.selectedIndex = 0;
			
			itemHPDropDown.selectedIndex = 0;
			itemHPXDropDown.selectedIndex = 0;
			itemMPDropDown.selectedIndex = 0;
			itemMPXDropDown.selectedIndex = 0;
			itemHPTPDropDown.selectedIndex = 0;
			
//			timeHPDropDown.selectedIndex = 0;
//			timeHPXDropDown.selectedIndex = 0;
//			timeMPDropDown.selectedIndex = 0;
//			timeMPXDropDown.selectedIndex = 0;
			
			
//			percentHPDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
//			percentHPXDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
//			percentMPDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
//			percentMPXDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
//			
//			percentHPTPDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
			
			percentHPInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			percentHPXInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			percentMPInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			percentMPXInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			
			percentHPTPInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			
			itemHPDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
			itemHPXDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
			itemMPDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
			itemMPXDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
			
			timeHPInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			timeHPXInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			timeMPInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			timeMPXInput.addEventListener(FocusEvent.FOCUS_OUT,drugInputChangeHandler);
			
			equipItemDropDown.addEventListener(Event.CHANGE,drugDropDownChangeHandler);
			
			
			
			percentHPInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
			percentHPXInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
			percentMPInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
			percentMPXInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
			
			percentHPTPInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
			
			timeHPInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
			timeHPXInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
			timeMPInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
			timeMPXInput.addEventListener(FocusEvent.FOCUS_IN,drugInputInHandler);
		}
		
		private function drugInputInHandler(e:Event):void
		{
			var t:TextField = e.currentTarget as TextField;
			
			var reg:RegExp = /(\d+)%/;
			var re:Array = reg.exec(t.text);
			if(re)
			{
				var text:String = re[1];
				t.text = text;
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