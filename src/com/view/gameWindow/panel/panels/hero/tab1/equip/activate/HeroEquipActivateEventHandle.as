package com.view.gameWindow.panel.panels.hero.tab1.equip.activate
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.HeroEquipUpgradeCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.ConditionConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;

	public class HeroEquipActivateEventHandle
	{
		private var _heuc:HeroEquipActivateCell;
		public function HeroEquipActivateEventHandle(heuc:HeroEquipActivateCell)
		{
			_heuc=heuc;
			_heuc.btn.addEventListener(MouseEvent.CLICK,onclick);
		}
		
		private function onclick(e:MouseEvent):void
		{
			var heroUpgrade:HeroEquipActivateData =HeroDataManager.instance.heroActivateData;
			var upgradeCfg:HeroEquipUpgradeCfgData=ConfigDataManager.instance.heroEquipUpgradeCfgData(heroUpgrade.grade,heroUpgrade.order);
			
			if(_heuc.btnType==ConditionConst.TYPE_CHONGNENG)
			{
				HeroDataManager.instance.requestInsertExp();
			}else
			{
				if(upgradeCfg.is_auto==ConditionConst.AUTO)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HERO_UPGRADE_0010);
					return;
				}
				
				if(_heuc.title!="")
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,_heuc.title);
					return;
				}
				
				if(upgradeCfg.item_id!=0||upgradeCfg.bind_gold!=0)
				{
					var count:int=BagDataManager.instance.getItemNumById(upgradeCfg.item_id);
					if(count<upgradeCfg.item_count||upgradeCfg.bind_gold>BagDataManager.instance.goldBind)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,	StringConst.HERO_UPGRADE_0014);
						return;
					}
				}
				HeroDataManager.instance.requestActivate();
			}
		}
		
		public function destroy():void
		{
			_heuc.btn.removeEventListener(MouseEvent.CLICK,onclick);
		}
	}
}