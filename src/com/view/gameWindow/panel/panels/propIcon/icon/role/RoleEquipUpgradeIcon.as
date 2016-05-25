package com.view.gameWindow.panel.panels.propIcon.icon.role
{
	import com.model.configData.cfgdata.EquipBaptizeSuiteCfgData;
	import com.model.configData.cfgdata.EquipStrengthenSuiteCfgData;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	public class RoleEquipUpgradeIcon extends PropIcon
	{
		public function RoleEquipUpgradeIcon()
		{
			super();
		}
		
		override public function checkUnLock():Boolean
		{
			updateLevel();
			return GuideSystem.instance.isUnlock(UnlockFuncId.FORGE_DEGREE);
		}
		
		override protected function getIconUrl():String
		{
			return "small_upgrade.png";
		}
		
		private function updateLevel():void
		{
			var curCfg:EquipStrengthenSuiteCfgData = RoleDataManager.instance.getCurStrengthenLevelCfgData();
			if(curCfg!=null)
			{
				level=curCfg.activate_level;
			}else
			{
				level=0;
			}
		}
		
		override public function getTipData():Object
		{
			var curCfg:EquipStrengthenSuiteCfgData = RoleDataManager.instance.getCurStrengthenLevelCfgData();
			var nextCfg:EquipStrengthenSuiteCfgData = RoleDataManager.instance.getNextStrengthenLevelCfgData();
			_data.cur=curCfg;
			_data.next=nextCfg;
			_data.type=EntityTypes.ET_PLAYER;
			return _data;
		}
		
		override public function getTipType():int
		{
			// TODO Auto Generated method stub
			return ToolTipConst.EQUIP_STRENG_SUITE_TIP;
		}
		
	}
}