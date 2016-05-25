package com.view.gameWindow.panel.panels.propIcon.icon.role
{
	import com.model.configData.cfgdata.EquipBaptizeSuiteCfgData;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	public class RoleBaptizeIcon extends PropIcon
	{
		public function RoleBaptizeIcon()
		{
			super();
		}
		
		override public function checkUnLock():Boolean
		{
			// TODO Auto Generated method stub
			updateLevel();
			return GuideSystem.instance.isUnlock(UnlockFuncId.FORGE_REFINED);
		}
		
		private function updateLevel():void
		{
			var curCfg:EquipBaptizeSuiteCfgData = RoleDataManager.instance.getCurBaptizeLevelCfgData();
			if(curCfg!=null)
			{
				level=curCfg.level;
			}else
			{
				level=0;
			}
		}
		
		override protected function getIconUrl():String
		{
			return "small_hardening.png";
		}
		
		override public function getTipData():Object
		{
			var curCfg:EquipBaptizeSuiteCfgData = RoleDataManager.instance.getCurBaptizeLevelCfgData();
			var nextCfg:EquipBaptizeSuiteCfgData = RoleDataManager.instance.getNextBaptizeLevelCfgData();
			_data.cur=curCfg;
			_data.next=nextCfg;
			_data.type=EntityTypes.ET_PLAYER;
			return _data;
		}
		
		override public function getTipType():int
		{
			return ToolTipConst.EQUIP_BAPTIZE_SUITE_TIP;
		}
	}
}