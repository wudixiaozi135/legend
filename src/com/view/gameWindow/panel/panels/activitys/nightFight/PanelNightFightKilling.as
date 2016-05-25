package com.view.gameWindow.panel.panels.activitys.nightFight
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	/**
	 * 夜战比奇击杀提示类
	 * @author Administrator
	 */	
	public class PanelNightFightKilling extends PanelBase
	{
		public function PanelNightFightKilling()
		{
			super();
			canEscExit = false;
		}
		
		override protected function initSkin():void
		{
			var skin:McNightFightKilling = new McNightFightKilling();
			_skin = skin;
			addChild(skin);
		}
		
		override protected function initData():void
		{
			ActivityDataManager.instance.nightFightDataManager.attach(this);
			var skin:McNightFightKilling = _skin as McNightFightKilling;
			skin.txt1.text = StringConst.NIGHT_FIGHT_KILLING_0001;
		}
		
		override public function update(proc:int=0):void
		{
			var skin:McNightFightKilling = _skin as McNightFightKilling;
			skin.txt0.text = "";
			skin.txt2.text = "";
		}
		
		override public function destroy():void
		{
			ActivityDataManager.instance.nightFightDataManager.detach(this);
			super.destroy();
		}
	}
}