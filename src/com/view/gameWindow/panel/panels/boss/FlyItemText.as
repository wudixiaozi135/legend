package com.view.gameWindow.panel.panels.boss
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapBossCfgData;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;

	public class FlyItemText extends MCFlyItem
	{

		private var isFly:Boolean;

		private var mapMstCfgData:MapMonsterCfgData;
		private var mapCfgData:MapCfgData;
		private var cfg:MapBossCfgData;

		private var boss:BossData;
		
		public function FlyItemText()
		{
			this.addEventListener(MouseEvent.CLICK,onClickFUnc);
		}
		
		protected function onClickFUnc(event:MouseEvent):void
		{
			if(isFly==false)return;
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(cfg.maps_nofly.indexOf(String(mapId)) ==-1)
			{
				BossDataManager.instance.deliverBoss(cfg,6);
			}
			else
			{
				if(SceneMapManager.getInstance().mapId == boss.mapId)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BOSS_PANEL_0029);
					return;
				} 
			}	
		}
		
		public function setFlyData(cfg:MapBossCfgData,boss:BossData,isFly:Boolean=false):void
		{
			this.boss = boss;
			this.cfg = cfg;
			this.isFly = isFly;
			mapMstCfgData = ConfigDataManager.instance.mapMstCfgData(cfg.map_monster_id);
			mapCfgData = ConfigDataManager.instance.mapCfgData(mapMstCfgData.map_id);
			if(isFly&&boss.dealReviveTime()==0)
			{
				mapName.htmlText=HtmlUtils.createHtmlStr(0x00ff00,mapCfgData.name+StringConst.BOSS_PANEL_0044,12,false,2,"SimSun",true,"this");
			}else
			{
				mapName.htmlText=HtmlUtils.createHtmlStr(0x00ff00,mapCfgData.name);
			}
		}
		
		public function destroy():void
		{
			this.removeEventListener(MouseEvent.CLICK,onClickFUnc);
		}
	}
}