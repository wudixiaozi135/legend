package com.view.gameWindow.panel.panels.daily.activity
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.DailyCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.UtilGetStrLv;

	/**
	 * 日常活动页活动项类
	 * @author Administrator
	 */	
	internal class TabDailyActivityItem
	{
		private var _tab:TabDailyActivity;
		private var _skin:McActivityItem1;
		public function get skin():McActivityItem1
		{
			return _skin;
		}
		
		private var _order:int;
		public function get order():int
		{
			return _order;
		}

		private var _urlPic:UrlPic;
		
		public function get isEnterAble():Boolean
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			var dailyData:DailyData = manager.getDailyDatasByTab()[order] as DailyData;
			//
			var actCfgDt:ActivityCfgData = dailyData.actCfgData;
			var boolean:Boolean = actCfgDt.secondToStart != int.MIN_VALUE && actCfgDt.secondToStart != int.MAX_VALUE;
			boolean &&= actCfgDt.secondToEnter != int.MIN_VALUE && actCfgDt.secondToEnter != int.MAX_VALUE
			return boolean;
		}
		
		public function TabDailyActivityItem(tab:TabDailyActivity)
		{
			_tab = tab;
			_skin = new McActivityItem1();
			_skin.mouseChildren = false;
			_skin.handle = this;
			_urlPic = new UrlPic(_skin.mcLayer);
		}
		
		internal function refresh(order:int):void
		{
			_order = order;
			var manager:DailyDataManager = DailyDataManager.instance;
			var dailyData:DailyData = manager.getDailyDatasByTab()[order] as DailyData;
			//
			var actCfgDt:ActivityCfgData = dailyData.actCfgData;
			_skin.txtOpen.visible = false;
			_skin.txtOpen.text = StringConst.DAILY_PANEL_0026;
			var openTime:String = actCfgDt.start_time_str;
			_skin.txtOpenValue.text = "("+openTime+")";
			_skin.txtOpenValue.textColor = isCanEnter ? 0x53b436 : 0x6a6a6a;
			_skin.txtCdt.text = StringConst.DAILY_PANEL_0027;
			_skin.txtCdt.textColor = 0xffe1aa;
			var str:String = UtilGetStrLv.strReincarnLevel(actCfgDt.reincarn,actCfgDt.level);
			_skin.txtCdtValue.text = str/*actCfgDt.level+StringConst.DAILY_PANEL_0028*/;
			_skin.txtCdtValue.textColor = isLvEnough ? 0xffe1aa : 0xffe1aa;
			//
			var theHeight:int;
			if(isTimeRight)
			{
				_skin.txtOpenValue.y = 9;
				_skin.txtCdt.visible = _skin.txtCdtValue.visible = true;
			}
			else
			{
				_skin.txtOpenValue.y = 19;
				_skin.txtCdt.visible = _skin.txtCdtValue.visible = false;
			}
			//
			var cfgDt:DailyCfgData = dailyData.dailyCfgData;
			var url:String = !isEnterAble ? cfgDt.url2 : cfgDt.url1;
			url = ResourcePathConstants.IMAGE_DAILY_FOLDER_LOAD + url + ResourcePathConstants.POSTFIX_JPG;
			_urlPic.load(url);
		}
		
		internal function get isCanEnter():Boolean
		{
			return isLvEnough && isTimeRight;
		}
		
		internal function get isTimeRight():Boolean
		{
			var dailyData:DailyData = DailyDataManager.instance.getDailyDatasByTab()[_order] as DailyData;
			return dailyData.actCfgData.isInActv && dailyData.actCfgData.isEnterOpen;
		}
		
		internal function get isLvEnough():Boolean
		{
			var dailyData:DailyData = DailyDataManager.instance.getDailyDatasByTab()[_order] as DailyData;
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(dailyData.actCfgData.reincarn,dailyData.actCfgData.level);
			return checkReincarnLevel;
		}
		
		internal function destroy():void
		{
			_urlPic.destroy();
			_urlPic = null;
			if(_skin.parent)
			{
				_skin.parent.removeChild(_skin);
			}
			_skin.handle = null;
			_skin = null;
			_tab = null;
		}
		
		public static function sort(item1:TabDailyActivityItem,item2:TabDailyActivityItem):int
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			var dailyData1:DailyData = manager.getDailyDatasByTab()[item1._order] as DailyData;
			var actCfgDt1:ActivityCfgData = dailyData1.actCfgData;
			var dailyData2:DailyData = manager.getDailyDatasByTab()[item2._order] as DailyData;
			var actCfgDt2:ActivityCfgData = dailyData2.actCfgData;
			return actCfgDt1.currentActvTimeCfgDtToEnter.start_time - actCfgDt2.currentActvTimeCfgDtToEnter.start_time;
		}
	}
}