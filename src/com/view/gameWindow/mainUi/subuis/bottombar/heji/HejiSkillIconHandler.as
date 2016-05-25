package com.view.gameWindow.mainUi.subuis.bottombar.heji
{
	import com.model.configData.cfgdata.SkillCfgData;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
	import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.IconCellSkill;

	/**
	 * 合击技能icon处理类
	 * @author Administrator
	 */	
	public class HejiSkillIconHandler implements IObserver
	{
		private var _bottomBar:BottomBar;
		private var _skin:McMainUIBottom;

		private var _cell:IconCellSkill;
		
		public function HejiSkillIconHandler(bottomBar:BottomBar)
		{
			_bottomBar = bottomBar;
			_skin = _bottomBar.skin as McMainUIBottom;
			initialize();
		}
		
		private function initialize():void
		{
			HejiSkillDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			//
			_cell = new IconCellSkill(_skin.mcIconHeji);
			ToolTipManager.getInstance().attach(_cell);
		}
		
		public function update(proc:int=0):void
		{
			var cfgDt:SkillCfgData = HejiSkillDataManager.instance.cfgDtHeji;
			_cell.refresh(cfgDt);
		}
	}
}