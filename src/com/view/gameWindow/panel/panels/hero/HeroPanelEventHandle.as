package com.view.gameWindow.panel.panels.hero
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroPanel;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.hero.tab1.HeroEquipTab;
	import com.view.gameWindow.panel.panels.hero.tab2.HeroUpgradeTab;
	import com.view.gameWindow.panel.panels.hero.tab3.HeroImageTab;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class HeroPanelEventHandle
	{
		private var _mc:McHeroPanel;
		/**上次选中的按钮*/
		private var _lastSelect:MovieClip,_lastSelectTxt:TextField;
		private var _tabLayer:Sprite;
		private var _tabsSwitch:TabsSwitch;
		private var _unlock:UIUnlockHandler;
		
		public function HeroPanelEventHandle(mc:McHeroPanel)
		{
			_mc = mc;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			var defaultTextFormat:TextFormat;
			defaultTextFormat = _mc.txtBtnEquip.defaultTextFormat;
			defaultTextFormat.bold = true;
			
			_mc.txtBtnEquip.defaultTextFormat = defaultTextFormat;
			_mc.txtBtnEquip.setTextFormat(defaultTextFormat);
			_mc.txtBtnEquip.text = "";
			_mc.txtBtnEquip.mouseEnabled = false;
			
			_mc.txtBtnUpgrade.defaultTextFormat = defaultTextFormat;
			_mc.txtBtnUpgrade.setTextFormat(defaultTextFormat);
			_mc.txtBtnUpgrade.text = "";
			_mc.txtBtnUpgrade.mouseEnabled = false;
			
			/*_mc.txtBtnImage.defaultTextFormat = defaultTextFormat;
			_mc.txtBtnImage.setTextFormat(defaultTextFormat);
			_mc.txtBtnImage.text = "";
			_mc.txtBtnImage.mouseEnabled = false;*/
			
			_tabLayer=new Sprite();
			_mc.addChild(_tabLayer);
			_tabLayer.x=48;
			_tabLayer.y=70;
			var selectTab:int = HeroDataManager.instance.selectTab;
			_tabsSwitch = new TabsSwitch(_tabLayer,Vector.<Class>([HeroEquipTab,HeroUpgradeTab,HeroImageTab]),selectTab);
			_lastSelect = _mc.btnEquip;
			_lastSelectTxt=_mc.txtBtnEquip;
			
			_unlock = new UIUnlockHandler(getUnlockUI,1);
			_unlock.updateUIStates([UnlockFuncId.HERO_RE,UnlockFuncId.HERO_IMAGE]);
		}
		
		private function getUnlockUI(id:uint):Array
		{
			if(id == UnlockFuncId.HERO_RE)
			{
				return [_mc.btnUpgrade,_mc.txtBtnUpgrade];
			}
			/*else if(id == UnlockFuncId.HERO_IMAGE)
			{
				return [_mc.btnImage,_mc.txtBtnImage];
			}*/
			
			return null;
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.btnClose:
					HeroDataManager.instance.isExchange = false;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_HERO);
					break;
				case _mc.btnEquip://装备
					selectBtnDeal(_mc.btnEquip, HeroTabType.TAB_EQUIP);
					break;
				case _mc.btnUpgrade://进阶
					selectBtnDeal(_mc.btnUpgrade, HeroTabType.TAB_EQUIP_UPGRADE);
					break;
				/*case _mc.btnImage://形象
					selectBtnDeal(_mc.btnImage, HeroTabType.TAB_EQUIP_IMAGE);
					break;*/
			}
		}

		public function initSelect(nowSelect:MovieClip, index:int):void
		{
			selectBtnDeal(nowSelect, index);
		}

		private function selectBtnDeal(nowSelect:MovieClip, index:int):void
		{
			if(index == HeroTabType.TAB_EQUIP_UPGRADE)
			{
				if(!_unlock.onClickUnlock(UnlockFuncId.HERO_RE))
				{
					if(nowSelect)
					{
						nowSelect.selected = false;
					}
					return;
				}
			}
			else if(index == HeroTabType.TAB_EQUIP_IMAGE)
			{
				if(!_unlock.onClickUnlock(UnlockFuncId.HERO_IMAGE))
				{
					if(nowSelect)
					{
						nowSelect.selected = false;
					}
					return;
				}
			}
			
			var nowSelectTxt:TextField = getNowSelectTxt(index);
			_lastSelect.selected = false;
			_lastSelect.mouseEnabled = true;
			_lastSelectTxt.textColor = 0x675138;
			nowSelect.selected = true;
			nowSelect.mouseEnabled = false;
			nowSelectTxt.textColor = 0xffe1aa;
			_lastSelect = nowSelect;
			_lastSelectTxt = nowSelectTxt;
			if(_tabsSwitch.index==index)return;
			_tabsSwitch.onClick(index);
		}

		public function getNowSelectTxt(type:int):TextField
		{
			switch (type)
			{
				case HeroTabType.TAB_EQUIP:
					return _mc.txtBtnEquip;
				case HeroTabType.TAB_EQUIP_UPGRADE:
					return _mc.txtBtnUpgrade;
				/*case HeroTabType.TAB_EQUIP_IMAGE:
					return _mc.txtBtnImage;*/
			}
			return _mc.txtBtnEquip;
		}

		public function getNowSelectMc(type:int):MovieClip
		{
			switch (type)
			{
				case HeroTabType.TAB_EQUIP:
					return _mc.btnEquip;
				case HeroTabType.TAB_EQUIP_UPGRADE:
					return _mc.btnUpgrade;
				/*case HeroTabType.TAB_EQUIP_IMAGE:
					return _mc.btnImage;*/
			}
			return _mc.btnEquip;
		}

		public function destroy():void
		{
			if(_unlock)
			{
				_unlock.destroy();
				_unlock = null;
			}

			if(_tabsSwitch)
			{
				_tabsSwitch.destroy();
				_tabsSwitch = null;
			}
				
			if(_tabLayer)
			{
				_tabLayer.parent&&_tabLayer.parent.removeChild(_tabLayer);
			}
			_tabLayer=null;
			
			_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
			_mc = null;
		}
	}
}