package com.view.gameWindow.panel.panels.daily.activity
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.DailyCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;

	/**
	 * 日常活动页显示相关处理类
	 * @author Administrator
	 */	
	internal class TabDailyActivityViewHandle
	{
		private var _tab:TabDailyActivity;
		private var _skin:McDailyActivity1;
		
		private var _scrollRect:TabDailyActivityScrollRect;
		private var _minMap:TabDailyActivityMinMap;
		private var _rewardCells:Vector.<IconCellEx>;
		
		public function TabDailyActivityViewHandle(tab:TabDailyActivity)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyActivity1;
			init();
		}
		
		private function init():void
		{
			_skin.txtName.text = StringConst.DAILY_PANEL_0022;
			_skin.txtEnter.text = StringConst.DAILY_PANEL_0023;
			_skin.txtReward.text = StringConst.DAILY_PANEL_0025;
			//
			_scrollRect = new TabDailyActivityScrollRect(_tab);
			_minMap = new TabDailyActivityMinMap(_tab);
			//
			_rewardCells = new Vector.<IconCellEx>();
		}
		
		internal function initScrollBar(mc:MovieClip):void
		{
			_scrollRect.initScrollBar(mc);
		}
		
		internal function refresh():void
		{
			_scrollRect.refresh();
			_minMap.refresh();
			//
			destroyRewardCells();
			var manager:DailyDataManager = DailyDataManager.instance;
			var selectOrder:int = _tab.mouseHandle.selectOrder;
			var actCfgDt:ActivityCfgData = manager.getDailyDatasByTab()[selectOrder].actCfgData;
			_skin.txtNameValue.text = actCfgDt.name;
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(actCfgDt.npc);
			_skin.txtEnter1.htmlText = HtmlUtils.createHtmlStr(0x00ff00,(npcCfgData ? npcCfgData.name : ""/*StringConst.DAILY_PANEL_0024*/),12,false,2,"SimSun",true);
			_skin.btn.visible = _skin.txtEnter1.text != "";
			//
			_skin.txtDesc.htmlText = "";
			var dailyCfgData:DailyCfgData = manager.getDailyDatasByTab()[selectOrder].dailyCfgData;
			var pareseDes:Array = CfgDataParse.pareseDes(dailyCfgData.game_desc,0xffe1aa,6),str:String;
			for each(str in pareseDes)
			{
				_skin.txtDesc.htmlText += str;
			}
			//
			if(actCfgDt.reward_view != "")
			{
				var thingsDts:Vector.<ThingsData> = UtilItemParse.getThingsDatas(actCfgDt.reward_view),thingsDt:ThingsData,i:int;
				for each(thingsDt in thingsDts)
				{
					var mcReward:MovieClip = _skin["mcReward"+i] as MovieClip;
					if(mcReward)
					{
						var cell:IconCellEx = new IconCellEx(mcReward.parent,mcReward.x,mcReward.y,mcReward.width,mcReward.height);
						IconCellEx.setItemByThingsData(cell,thingsDt);
						ToolTipManager.getInstance().attach(cell);
						_rewardCells.push(cell);
						i++;
					}
				}
			}
			else
			{
				destroyRewardCells();
			}
		}
		
		private function destroyRewardCells():void
		{
			var cell:IconCellEx;
			for each(cell in _rewardCells)
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			_rewardCells.length = 0;
		}
		
		internal function destroy():void
		{
			if(_scrollRect)
			{
				_scrollRect.destroy();
				_scrollRect = null;
			}
			if(_minMap)
			{
				_minMap.destroy();
				_minMap = null;
			}
			destroyRewardCells();
			_rewardCells = null;
			_skin = null;
			_tab = null;
		}
	}
}