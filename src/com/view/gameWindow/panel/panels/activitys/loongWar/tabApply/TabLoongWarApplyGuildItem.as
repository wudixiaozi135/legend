package com.view.gameWindow.panel.panels.activitys.loongWar.tabApply
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolBasicData;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilText;
	
	import flash.display.DisplayObjectContainer;

	public class TabLoongWarApplyGuildItem
	{
		/**是否为联盟显示列表*/
		public var isLeague:Boolean;
		
		private var _skin:McLoongWarApplyGuildItem;
		private var _dt:DataLoongWarApplyGuild;

		public function get skin():McLoongWarApplyGuildItem
		{
			return _skin;
		}
		
		public function TabLoongWarApplyGuildItem(layer:DisplayObjectContainer)
		{
			_skin = new McLoongWarApplyGuildItem();
			_skin.item = this;
			layer.addChild(_skin);
			_skin.txt0.mouseEnabled = false;
			_skin.txt1.mouseWheelEnabled = false;
			_skin.txt2.mouseEnabled = false;
			_skin.txt3.mouseWheelEnabled = false;
		}
		
		public function update(dt:DataLoongWarApplyGuild):void
		{
			_dt = dt;
			_skin.txt0.text = StringConst.LOONG_WAR_0053;
			_skin.txt1.text = dt.familyName;
			UtilText.ellipsesText(_skin.txt1);
			_skin.txt2.text = StringConst.LOONG_WAR_0053;
			//
			_skin.txt3.htmlText = dt.familyNameLeagueFull;
			UtilText.ellipsesText(_skin.txt3);
			_skin.txt3.textColor = dt.textColor;
			if(!isLeague)
			{
				_skin.txt4.text = "";
				_skin.mouseEnabled = false;
				return;
			}
			var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
			if(!schoolBaseData.isMainViceLeader)//不是正副帮主
			{
				_skin.txt4.text = "";
				_skin.mouseEnabled = false;
				return;
			}
			var dtMy:DataLoongWarApplyGuild = ActivityDataManager.instance.loongWarDataManager.applyGuildDataMy;
			if(!dtMy)//未报名
			{
				_skin.txt4.text = "";
				_skin.mouseEnabled = false;
				return;
			}
			if(dtMy.familyIdLeague)//已结盟
			{
				if(dtMy == dt)//该项是我的帮会项
				{
					_skin.txt4.htmlText = HtmlUtils.createHtmlStr(0x00ff00,StringConst.LOONG_WAR_0040,12,false,2,FontFamily.FONT_NAME,true);
					_skin.mouseEnabled = true;
				}
				else
				{
					_skin.txt4.text = "";
					_skin.mouseEnabled = false;
				}
			}
			else
			{
				if((!dt.familyIdLeague || dt.isLeader) && dtMy != dt)//未结盟或盟主帮会且非本帮
				{
					_skin.txt4.htmlText = HtmlUtils.createHtmlStr(0x00ff00,StringConst.LOONG_WAR_0039,12,false,2,FontFamily.FONT_NAME,true);
					_skin.mouseEnabled = true;
				}
				else
				{
					_skin.txt4.text = "";
					_skin.mouseEnabled = false;
				}
			}
		}
		
		public function onClick():void
		{
			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(ActivityFuncTypes.AFT_LOONG_WAR);
			if(activityCfgData.isInActv)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.LOONG_WAR_ERROR_0007);
				return;
			}
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			if(_skin.txt4.text == StringConst.LOONG_WAR_0039)
			{
				manager.cmFamilyLongchengLeague(_dt);
			}
			else if(_skin.txt4.text == StringConst.LOONG_WAR_0040)
			{
				manager.cmFamilyLongchengLeagueLeave();
			}
		}
		
		public function destroy():void
		{
			if(_skin)
			{
				if(_skin.parent)
				{
					_skin.parent.removeChild(_skin);
				}
				_skin.item = null;
				_skin = null;
			}
		}
	}
}