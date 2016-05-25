package com.view.gameWindow.panel.panels.propIcon.icon.hero
{
	import com.model.configData.cfgdata.EquipStrengthenSuiteCfgData;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	public class HeroEquipUpgradeIcon extends PropIcon
	{
		public function HeroEquipUpgradeIcon()
		{
			super();
		}
		
		override public function checkUnLock():Boolean
		{
			updateLevel();
			return GuideSystem.instance.isUnlock(UnlockFuncId.FORGE_DEGREE);
		}
		
		private function updateLevel():void
		{
			// TODO Auto Generated method stub
			var curCfg:EquipStrengthenSuiteCfgData = HeroDataManager.instance.getCurStrengthenLevelCfgData();
			if(curCfg!=null)
			{
				level=curCfg.activate_level;
			}else
			{
				level=0;
			}
		}
		
		override protected function getIconUrl():String
		{
			return "small_upgrade.png";
		}
		
		override public function getTipData():Object
		{
			var curCfg:EquipStrengthenSuiteCfgData = HeroDataManager.instance.getCurStrengthenLevelCfgData();
			var nextCfg:EquipStrengthenSuiteCfgData = HeroDataManager.instance.getNextStrengthenLevelCfgData();
			_data.cur=curCfg;
			_data.next=nextCfg;
			_data.type=EntityTypes.ET_HERO;
			return _data;
		}
		
		override public function getTipType():int
		{
			// TODO Auto Generated method stub
			return ToolTipConst.EQUIP_STRENG_SUITE_TIP;
		}
		
	}
}