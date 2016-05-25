package com.view.gameWindow.panel.panels.boss
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	
	import flash.text.TextFormat;

	public class PanelBossViewHandle
	{
		private var _panel:PanelBoss;
		private var _skin:MCPanelBoss;
		public function PanelBossViewHandle(panel:PanelBoss)
		{
			_panel = panel;
			_skin = _panel.skin as MCPanelBoss;
			init();
		}
		private function init():void
		{
			var defaultTextFormat:TextFormat = _skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			_skin.txtTitle.defaultTextFormat = defaultTextFormat;
			_skin.txtTitle.setTextFormat(defaultTextFormat);
			_skin.txtTitle.text = StringConst.BOSS_PANEL_0001;
		}
		internal function destroy():void
		{
			_skin = null;
			_panel = null;
		}
		
		public function refreshVip():void
		{
			var lv:int = VipDataManager.instance.lv;
			var vipData:VipCfgData = ConfigDataManager.instance.vipCfgData(lv);	
			if(!vipData)
			{
				BossDataManager.instance.isLockClassic = true;
				BossDataManager.instance.isLockWorld = true;
			}
			else
			{
				BossDataManager.instance.isLockClassic = vipData.unlock_classic_boss > 0 ?false:true;
				BossDataManager.instance.isLockWorld = vipData.unlock_world_boss > 0 ?false:true;
			}
			BossDataManager.instance.isLockClassicVip =  ConfigDataManager.instance.getSpecialFlagVipCfgData('unlock_classic_boss').level;
		}
	}
}