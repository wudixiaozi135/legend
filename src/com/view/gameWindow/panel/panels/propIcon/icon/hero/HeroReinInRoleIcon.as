package com.view.gameWindow.panel.panels.propIcon.icon.hero
{
	import com.model.configData.cfgdata.HeroReincarnAttrCfgData;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	public class HeroReinInRoleIcon extends PropIcon
	{
		public function HeroReinInRoleIcon()
		{
			super();
		}
		
		override public function checkUnLock():Boolean
		{
			updateLevel();
			return true;
		}
		
		override protected function getIconUrl():String
		{
			return "small_heroRein.png";
		}
		
		private function updateLevel():void
		{
			var curCfg:HeroReincarnAttrCfgData = HeroDataManager.instance.getCurReincarnLevelCfgData();
			if(curCfg!=null)
			{
				level=curCfg.level;
			}else
			{
				level=0;
			}
		}
		
		override public function getTipData():Object
		{
			var curCfg:HeroReincarnAttrCfgData = HeroDataManager.instance.getCurReincarnLevelCfgData();
			var nextCfg:HeroReincarnAttrCfgData = HeroDataManager.instance.getNextREincarnLevelCfgData();
			_data.cur=curCfg;
			_data.next=nextCfg;
			_data.type=EntityTypes.ET_HERO;
			return _data;
		}
		
		override public function getTipType():int
		{
			return ToolTipConst.EQUIP_REINCAIN_SUITE_TIP;
		}
	}
}