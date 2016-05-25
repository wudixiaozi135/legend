package com.view.gameWindow.panel.panels.propIcon.icon.role
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.position.PositionDataManager;
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	public class RolePositionIcon extends PropIcon
	{
		public function RolePositionIcon()
		{
			super();
		}
		
		override public function checkUnLock():Boolean
		{
			updateLevel();
			return GuideSystem.instance.isUnlock(UnlockFuncId.POSITION)&&RoleDataManager.instance.position>=12;
		}
		
		private function updateLevel():void
		{
//			if(RoleDataManager.instance.baseId==0)
//			{
//				level=0;
//			}else
//			{
				level=PositionDataManager.instance.rolePositionLevel;
//				level=MemEquipDataManager.instance.equipedMemEquipDataByType(ConfigDataManager.instance.equipCfgData(RoleDataManager.instance.baseId).type).strengthen;
//			}
		}
		
		override protected function getIconUrl():String
		{
			return "small_position.png";
		}
		
		override public function getTipData():Object
		{
			var baseId:int = RoleDataManager.instance.baseId ? RoleDataManager.instance.baseId : HeroDataManager.instance.basicId;
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(baseId);
			if(!equipCfgData)
			{
				return null;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.equipedMemEquipDataByType(equipCfgData.type);
			if(!memEquipData)
			{
				return {chopid:baseId,curLevel:0,nextLevel:strengthen+1,type:EntityTypes.ET_PLAYER};
			}
			var strengthen:int = memEquipData.strengthen;
			_data.chopid=baseId;
			_data.curLevel=strengthen;
			_data.nextLevel=strengthen+1;
			_data.type=EntityTypes.ET_PLAYER;
			return _data;
		}
		
		override public function getTipType():int
		{
			return ToolTipConst.POSITION_SUITE_TIP;
		}
	}
}