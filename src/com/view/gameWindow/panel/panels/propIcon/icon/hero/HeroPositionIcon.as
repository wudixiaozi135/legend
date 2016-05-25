package com.view.gameWindow.panel.panels.propIcon.icon.hero
{
	import com.model.configData.ConfigDataManager;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.position.PositionDataManager;
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	public class HeroPositionIcon extends PropIcon
	{
		public function HeroPositionIcon()
		{
			super();
		}
		
		override public function checkUnLock():Boolean
		{
			// TODO Auto Generated method stub
			updateLevel();
			return GuideSystem.instance.isUnlock(UnlockFuncId.POSITION)&&RoleDataManager.instance.position>=12;
		}
		
		private function updateLevel():void
		{
			// TODO Auto Generated method stub
			level=PositionDataManager.instance.heroPositionLevel;
//			if(HeroDataManager.instance.basicId==0)
//			{
//				level=0;
//			}else
//			{
//				level=MemEquipDataManager.instance.equipedMemEquipDataByType(ConfigDataManager.instance.equipCfgData(HeroDataManager.instance.basicId).type).strengthen;
//			}
		}
		
		override protected function getIconUrl():String
		{
			return "small_position.png";
		}
		
		override public function getTipData():Object
		{
			var baseId:int = HeroDataManager.instance.basicId;
			var strengthen:int=0;
			if(baseId!=0)
			{
				strengthen = MemEquipDataManager.instance.equipedMemEquipDataByType(ConfigDataManager.instance.equipCfgData(HeroDataManager.instance.basicId).type).strengthen;
			}
			_data.chopid=baseId;
			_data.curLevel=strengthen;
			_data.nextLevel=strengthen+1;
			_data.type=EntityTypes.ET_HERO;
			return _data;
		}
		
		override public function getTipType():int
		{
			return ToolTipConst.POSITION_SUITE_TIP; 
		}
	}
}