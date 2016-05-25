package com.view.gameWindow.panel.panels.dungeon
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;

	public class DungeonPanelInMouseEvent
	{
		private var _mc:McDungeonPanel;
		private var _id:int;
		public function DungeonPanelInMouseEvent()
		{
			
		}
		
		public function addEvent(mc:McDungeonPanel):void
		{
			var dungeonPanel:DungeonPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_DUNGEON) as DungeonPanel;
			_id = DungeonGlobals.dungeonId ? DungeonGlobals.dungeonId : dungeonPanel.id;
			_mc = mc;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_mc.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandle);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandle);
		}
		
		private function mouseOverHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.txt_07:
					TextFormatManager.instance.setTextFormat( _mc.txt_07,0xff0000,true,false);
					break;
				case _mc.txt_08:
					TextFormatManager.instance.setTextFormat( _mc.txt_08,0xff0000,true,false);
					break;
			}
		}
		
		private function mouseOutHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.txt_07:
					TextFormatManager.instance.setTextFormat(_mc.txt_07,0x00ff00,true,false);
					break;
				case _mc.txt_08:
					TextFormatManager.instance.setTextFormat(_mc.txt_08,0x00ff00,true,false);
					break;
			}
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_IN);
					DungeonGlobals.dungeonId = 0;
					break;
				case _mc.txt_07:
					if(showRollTip())
					{
						return;
					}
					sendMessage();
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_IN);
					break;
				case _mc.txt_08:
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_IN);
					if(!DungeonGlobals.dungeonId)
					{
						PanelMediator.instance.switchPanel(PanelConst.TYPE_DUNGEON);
					}
					DungeonGlobals.dungeonId = 0;
					break;
			}
		}
		
		private function showRollTip():Boolean
		{
			var dungeonCfgData:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(_id);
			if(!dungeonCfgData)
			{
				trace("DungeonPanelInMouseEvent.showRollTip() 副本配置信息错误");
				return true;
			}
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(dungeonCfgData.reincarn,dungeonCfgData.level);
			if(!checkReincarnLevel)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.DUNGEON_PANEL_0024);
				return true;
			}
			if(dungeonCfgData.item)
			{
				var count:int = BagDataManager.instance.getItemNumById(dungeonCfgData.item);
				count += HeroDataManager.instance.getItemNumById(dungeonCfgData.item);
				if(count < dungeonCfgData.item_count)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.DUNGEON_PANEL_0029);
					return true;
				}
			}
			var dt:DungeonData = DgnDataManager.instance.getDgnDt(_id);
			if(dt)
			{
				if(dt.daily_enter_count == (dungeonCfgData.free_count + dungeonCfgData.toll_count))
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.DUNGEON_PANEL_0025);
					return true;
				}
				if(dt.daily_enter_count > dungeonCfgData.free_count)
				{	
					if(dungeonCfgData.coin)
					{
						if(dungeonCfgData.coin > (BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind))
						{
							RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.PROMPT_PANEL_0021);
							return true;
						}
						if(dungeonCfgData.unbind_coin > BagDataManager.instance.coinUnBind)
						{
							RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.PROMPT_PANEL_0022);
							return true;
						}
						if(dungeonCfgData.bind_gold > BagDataManager.instance.goldBind)
						{
							RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.PROMPT_PANEL_0023);
							return true;
						}
						if(dungeonCfgData.unbind_gold > BagDataManager.instance.coinUnBind)
						{
							RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.PROMPT_PANEL_0024);
							return true;
						}
					}
				}
			}
			return false;
		}
		
		private function sendMessage():void
		{
			DgnDataManager.instance.cmEnterDungeon(_id);
		}
		
		public function destoryEvent():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandle);
				_mc.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandle);
			}	
			_mc = null;
			_id = 0;
		}
	}
}