package com.view.gameWindow.mainUi.subuis.bottombar
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.HeroEquipUpgradeCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.ConditionConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.util.ServerTime;

	public class BottomBarHandler
	{
		private var bar:BottomBar;
		private var _mcMainUIBottom:McMainUIBottom;
		public function BottomBarHandler(bar:BottomBar)
		{
			this.bar = bar;
			_mcMainUIBottom = this.bar.skin as McMainUIBottom;
		}
		
		public function checkHeroScript():void
		{
//			var heroUpgrade:HeroEquipActivateData =HeroDataManager.instance.heroActivateData;
//			if(heroUpgrade.grade==0&&heroUpgrade.order==0)
//			{
//				_mcMainUIBottom.txtHeroCount.visible=_mcMainUIBottom.txtHeroCountBG.visible=false;
//				return;
//			}
//			var count:int = checkHeroCondition(heroUpgrade.grade,heroUpgrade.order,0);
//			_mcMainUIBottom.txtHeroCount.text=count+"";
//			_mcMainUIBottom.txtHeroCount.visible=_mcMainUIBottom.txtHeroCountBG.visible=count>0;
//			_mcMainUIBottom.txtHeroCountBG.visible=false;
		}
		
		private function checkHeroCondition(grade:int,order:int,count:int):int
		{
			var upgradeCfg:HeroEquipUpgradeCfgData=ConfigDataManager.instance.heroEquipUpgradeCfgData(grade,order);
			if(upgradeCfg==null)
			{
				order++;
				if(order>10)
				{
					grade++;
					order=1;
				}
				if(grade>7)return count;
				return checkHeroCondition(grade,order,count);
			}
			
			if(upgradeCfg.is_auto==ConditionConst.AUTO)
			{
				return count;
			}
			
			var cut:int;
			var ned:int;
			switch(upgradeCfg.condition)
			{
				case ConditionConst.TIMER:
					cut=(ServerTime.time-(HeroDataManager.instance.heroActivateData.timer-upgradeCfg.param/1000))/60;
					ned=upgradeCfg.param/60/1000;
					if(cut<ned)
					{
						return count;
					}
					return 1;
					break;
				case ConditionConst.EXP:
					cut=HeroDataManager.instance.heroActivateData.exp;
					ned=upgradeCfg.param;
					if(cut<ned)return count;
					break;
				case ConditionConst.LEVEL:
					cut=HeroDataManager.instance.lv;
					ned=upgradeCfg.param;
					if(cut<ned)return count;
					break;
			}
			
			if(upgradeCfg.item_id!=0||upgradeCfg.bind_gold!=0)
			{
				var itemCfg:ItemCfgData=ConfigDataManager.instance.itemCfgData(upgradeCfg.item_id);
				if(itemCfg)
				{
					var count:int=BagDataManager.instance.getItemNumById(upgradeCfg.item_id);
					if(count<upgradeCfg.item_count)return count;
				}
				if(upgradeCfg.bind_gold>0)
				{
					cut=BagDataManager.instance.goldBind;
					ned=upgradeCfg.bind_gold;
					if(cut<ned)return count;
				}
			}
			order++;
			count++;
			return checkHeroCondition(grade,order,count);
		}
	}
}