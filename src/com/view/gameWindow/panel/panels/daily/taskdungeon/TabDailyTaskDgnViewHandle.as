package com.view.gameWindow.panel.panels.daily.taskdungeon
{
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	
	import flash.utils.Dictionary;

	/**
	 * 任务副本页显示相关处理类
	 * @author Administrator
	 */	
	internal class TabDailyTaskDgnViewHandle
	{
		private var _tab:TabDailyTaskDgn;
		private var _skin:McDailyTaskDungeon1;
		
		internal const numPage:int = 3;
		internal var page:int,totalPage:int;
		internal var items:Vector.<TabDailyTaskDgnItem>;
		internal var itemDic:Dictionary;
		
		public function TabDailyTaskDgnViewHandle(tab:TabDailyTaskDgn)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyTaskDungeon1;
			init();
		}
		
		private function init():void
		{
			items = new Vector.<TabDailyTaskDgnItem>();
			itemDic = new Dictionary();
			var i:int;
			for(i=0;i<numPage;i++)
			{
				var item:TabDailyTaskDgnItem = new TabDailyTaskDgnItem(_tab,i);
				items.push(item);
				itemDic[item.skin.mcBtnTxt] = item;
			}
			var length:uint = DailyDataManager.instance.numByTab();
			totalPage = Math.ceil(length/numPage);
			page = 1;
		}
		
		internal function refresh():void
		{
			var typeDts:Vector.<DailyData> = DailyDataManager.instance.getDailyDatasByTab();
			typeDts.sort(sort);
			var i:int,order:int;
			for(i=0;i<numPage;i++)
			{
				order = (page - 1)*numPage + i + 1;
				if(order < typeDts.length)
				{
					var dailyData:DailyData = typeDts[order];
					items[i].skin.visible = true;
					items[i].refresh(dailyData);
				}
				else
				{
					items[i].skin.visible = false;
				}
			}
			refreshPageBtn();
		}
		
		private function sort(dt1:DailyData,dt2:DailyData):int
		{
			if(!dt1 && dt2)
			{
				return -1;
			}
			else if(!dt2)
			{
				return 1;
			}
			else
			{
				if(!dt1.isUnlock && dt2.isUnlock)
				{
					return 1;
				}
				else if(!dt2.isUnlock && dt1.isUnlock)
				{
					return -1;
				}
				else
				{
					var manager:DailyDataManager = DailyDataManager.instance;
					var selectTab:int = manager.selectTab;
					if(selectTab == manager.tabTask)
					{
						return dt2.taskRemainCount - dt1.taskRemainCount;
					}
					else if(selectTab == manager.tabDgn)
					{
						return dt2.dgnRemainCount - dt1.dgnRemainCount;
					}
					return 0;
				}
			}
		}
		
		internal function refreshPageBtn():void
		{
			_skin.btnLeft.btnEnabled = page > 1;
			_skin.btnRight.btnEnabled = page < totalPage;
		}
		
		internal function destroy():void
		{
			var item:TabDailyTaskDgnItem;
			for each(item in items)
			{
				item.destroy();
			}
			items = null;
			itemDic = null;
			_skin = null;
			_tab = null;
		}
	}
}