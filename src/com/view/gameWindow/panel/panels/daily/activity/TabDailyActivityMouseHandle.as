package com.view.gameWindow.panel.panels.daily.activity
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.events.MouseEvent;

	/**
	 * 日常活动页鼠标相关处理类
	 * @author Administrator
	 */	
	internal class TabDailyActivityMouseHandle
	{
		private var _tab:TabDailyActivity;
		private var _skin:McDailyActivity1;
		
		internal var overOrder:int;
		internal var selectOrder:int = -1;
		
		public function TabDailyActivityMouseHandle(tab:TabDailyActivity)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyActivity1;
			init();
		}
		
		private function init():void
		{
			_skin.mcScrollLayer.mcItemOver.visible = false;
			_skin.mcScrollLayer.mcItemOver.mouseChildren = false;
			_skin.mcScrollLayer.mcItemOver.mouseEnabled = false;
			_skin.mcScrollLayer.mcItemSelect.mouseChildren = false;
			_skin.mcScrollLayer.mcItemSelect.mouseEnabled = false;
			_skin.mcScrollLayer.mouseEnabled = false;
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.addEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_skin.mcScrollLayer.addEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		
		protected function onOut(event:MouseEvent):void
		{
			overOrder = 0;
			_skin.mcScrollLayer.mcItemOver.visible = false;
		}
		
		protected function onOver(event:MouseEvent):void
		{
			var mc:McActivityItem1 = event.target as McActivityItem1;
			if(mc)
			{
				var item:TabDailyActivityItem = mc.handle as TabDailyActivityItem;
				if(item)
				{
					overOrder = item.order;
				}
				_skin.mcScrollLayer.mcItemOver.y = mc.y/*+mc.parent.y*/;
				_skin.mcScrollLayer.setChildIndex(_skin.mcScrollLayer.mcItemOver,_skin.mcScrollLayer.numChildren-1);
				if(overOrder != selectOrder)
				{
					_skin.mcScrollLayer.mcItemOver.visible = true;
				}
				else
				{
					_skin.mcScrollLayer.mcItemOver.visible = false;
				}
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:McActivityItem1 = event.target as McActivityItem1;
			if(mc)
			{
				var item:TabDailyActivityItem = mc.handle as TabDailyActivityItem;
				if(item)
				{
					if(item.order != selectOrder)
					{
						selectOrder = item.order;
						_tab.viewHandle.refresh();
					}
				}
				_skin.mcScrollLayer.mcItemSelect.y = mc.y/*+mc.parent.y*/;
				_skin.mcScrollLayer.setChildIndex(_skin.mcScrollLayer.mcItemSelect,_skin.mcScrollLayer.numChildren-1);
				_skin.mcScrollLayer.mcItemOver.visible = false;
				return;
			}
			if(event.target == _skin.txtEnter1)
			{
				dealTxtEnter();
			}
			else if(event.target == _skin.btn)
			{
				dealBtn();
			}
		}
		
		private function dealTxtEnter():void
		{
			var actCfgData:ActivityCfgData = DailyDataManager.instance.getDailyDatasByTab()[selectOrder].actCfgData;
			var npcId:int = actCfgData.npc;
			var born_region:int = actCfgData.born_region;
			if(npcId)
			{
				AutoJobManager.getInstance().setAutoTargetData(npcId,EntityTypes.ET_NPC);
			}
			else if(born_region)
			{
				var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(born_region);
				AutoJobManager.getInstance().setAutoFindPathPos(mapRegionCfgData.randomPoint, mapRegionCfgData.map_id, 0);
			}
			else
			{
				trace("TabDailyActivityMouseHandle.dealTxtEnter() 配置错误");
			}
		}
		
		private function dealBtn():void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			/*trace("TabDailyActivityMouseHandle.onClick 参加活动");*/
			var actCfgData:ActivityCfgData = DailyDataManager.instance.getDailyDatasByTab()[selectOrder].actCfgData;
			var npcId:int = actCfgData.npc;
			var born_region:int = actCfgData.born_region;
			if(npcId)
			{
				DailyDataManager.instance.requestTeleport(npcId);
			}
			else if(born_region)
			{
				DailyDataManager.instance.requestTeleport1(born_region);
			}
			else
			{
				trace("TabDailyActivityMouseHandle.dealBtn() 配置错误");
			}
		}
		
		internal function destroy():void
		{
			_skin.mcScrollLayer.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			_skin.removeEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			_skin = null;
			_tab = null;
		}
	}
}