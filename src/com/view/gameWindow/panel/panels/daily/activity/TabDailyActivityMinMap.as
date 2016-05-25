package com.view.gameWindow.panel.panels.daily.activity
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.util.UrlPic;

	/**
	 * 日常活动页迷你地图类
	 * @author Administrator
	 */	
	internal class TabDailyActivityMinMap
	{
		private var _tab:TabDailyActivity;
		private var _skin:McDailyActivity1;

		private var _urlPic:UrlPic;
		
		public function TabDailyActivityMinMap(tab:TabDailyActivity)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyActivity1;
			_urlPic = new UrlPic(_skin.mcMinMapLayer);
		}
		
		internal function refresh():void
		{
			var order:int = _tab.mouseHandle.selectOrder;
			var dts:Vector.<DailyData> = DailyDataManager.instance.getDailyDatasByTab();
			var url:String = ResourcePathConstants.IMAGE_DAILY_FOLDER_LOAD + dts[order].dailyCfgData.url3 + ResourcePathConstants.POSTFIX_JPG;
			_urlPic.load(url);
		}
		
		internal function destroy():void
		{
			_urlPic.destroy();
			_urlPic = null;
			_skin = null;
			_tab = null;
		}
	}
}