package com.view.gameWindow.panel.panels.propIcon
{
	import com.view.gameWindow.panel.panels.propIcon.icon.hero.HeroEquipUpgradeIcon;
	import com.view.gameWindow.panel.panels.propIcon.icon.hero.HeroBaptizeIcon;
	import com.view.gameWindow.panel.panels.propIcon.icon.hero.HeroPositionIcon;
	import com.view.gameWindow.panel.panels.propIcon.icon.hero.HeroReinIcon;
	import com.view.gameWindow.panel.panels.propIcon.icon.hero.HeroReinInRoleIcon;

	public class HeroPropIconGroup extends PropIconGroup
	{
		public function HeroPropIconGroup()
		{
			super();
			initHeroProps();
		}
		
		private function initHeroProps():void
		{
			addIcon(new HeroEquipUpgradeIcon());
//			addIcon(new HeroBaptizeIcon());
			addIcon(new HeroPositionIcon());
//			addIcon(new HeroReinIcon());
			addIcon(new HeroReinInRoleIcon());
		}		
	}
}