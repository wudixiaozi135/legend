package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCMapCreamBoss;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;

	public class TabMapCreamMouseHandle
	{
		private var _tab:TabMapCreamBoss;
		private var _skin:MCMapCreamBoss;		
		internal var selectOrder:int;
		public function TabMapCreamMouseHandle(tab:TabMapCreamBoss)
		{
			_tab = tab;
			_skin = _tab.skin as MCMapCreamBoss;
			init();
		}

		private function init():void
		{
			selectOrder = 0;
			_skin.addEventListener(MouseEvent.CLICK,onClick,true,0,false);
			_skin.itemNodeShow.addEventListener(MouseEvent.CLICK,onClick,true,0,false);
			//_skin.addEventListener(MouseEvent.ROLL_OVER,onOver,true,0,false);
			//_skin.mcScrollLayer.addEventListener(MouseEvent.ROLL_OUT,onOut,true,0,false);
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(e.target == _skin.itemNodeShow.goBtn)
			{
				gotoSceneBoss(_tab.viewHandle.currnetData);	
			}
		}
		
		public function gotoSceneBoss(data:MapCreamItemNode):void
		{
			
			if(0 >= data.percent)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BOSS_PANEL_0030);	
				return;
			}
			
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(data.maps_noFlys.indexOf(String(mapId)) ==-1)
			{
				BossDataManager.instance.deliverBoss(data,1);
			}
			else
			{
				//AutoJobManager.getInstance().setAutoTargetData(data.monsterCfgData.group_id,EntityTypes.ET_MONSTER);
				AutoSystem.instance.setTarget(data.monsterCfgData.group_id,EntityTypes.ET_MONSTER,data.map_monster_id);	
			}
		}
		 
		
		internal function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			_skin.itemNodeShow.removeEventListener(MouseEvent.CLICK,onClick);
			_skin = null;
			_tab = null;
		}
	}
}