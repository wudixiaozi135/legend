package com.view.gameWindow.panel.panels.activitys.loongWar.tabApply
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
	
	import flash.display.MovieClip;

	internal class TabLoongWarApplyViewHandle
	{
		private var _tab:TabLoongWarApply;
		private var _skin:McLoongWarApply;

		private var scrollRectAttack:TabLoongWarApplyScrollRect;
		private var scrollRectUion:TabLoongWarApplyScrollRect;
		
		public function TabLoongWarApplyViewHandle(tab:TabLoongWarApply)
		{
			_tab = tab;
			_skin = _tab.skin as McLoongWarApply;
		}
		
		public function initialize():void
		{
			_skin.txtAttackInfo.text = StringConst.LOONG_WAR_0034;
			_skin.txtUionInfo.text = StringConst.LOONG_WAR_0035;
			_skin.txtTime.text = StringConst.LOONG_WAR_0036;
			_skin.txtGuildDefend.text = StringConst.LOONG_WAR_0037;
			_skin.txtGuildAttack0.text = StringConst.LOONG_WAR_0038;
			_skin.txtGuildAttack1.text = StringConst.LOONG_WAR_0038;
			_skin.txtTimeInfo.text = StringConst.LOONG_WAR_0041;
			_skin.txtTimeInfoValue.htmlText = StringConst.LOONG_WAR_0042;
			_skin.txtCondition.text = StringConst.LOONG_WAR_0043;
			_skin.txtConditionValue.htmlText = StringConst.LOONG_WAR_0044;
			_skin.txtTip.text = StringConst.LOONG_WAR_0045;
			_skin.txtTipValue.htmlText = StringConst.LOONG_WAR_0046;
			_skin.txtUionTip0.htmlText = StringConst.LOONG_WAR_0047;
			_skin.txtUionTip1.htmlText = StringConst.LOONG_WAR_0048;
			_skin.txtUionTip2.htmlText = StringConst.LOONG_WAR_0049;
			_skin.txtUionTip3.htmlText = StringConst.LOONG_WAR_0050;
			_skin.btnSelect.visible = false;
			_skin.txtAutoApply.text = StringConst.LOONG_WAR_0051;
			_skin.txtAutoApply.visible = false;
			_skin.txtbtnApply.text = StringConst.LOONG_WAR_0052;
			_skin.txtbtnApply.mouseEnabled = false;
			//
			scrollRectAttack = new TabLoongWarApplyScrollRect(_tab);
			scrollRectUion = new TabLoongWarApplyScrollRect(_tab,true);
		}
		
		internal function initScrollBar(mc:MovieClip,isUion:Boolean = false):void
		{
			isUion ? scrollRectUion.initScrollBar(mc) : scrollRectAttack.initScrollBar(mc);
		}
		
		public function update():void
		{
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			_skin.txtTimeValue.text = manager.nextFullTime;
			_skin.txtGuildDefendValue.text = manager.familyNameDefense;
			scrollRectAttack.update();
			scrollRectUion.update();
		}
		
		public function destroy():void
		{
			if(scrollRectAttack)
			{
				scrollRectAttack.destroy();
				scrollRectAttack = null;
			}
			if(scrollRectUion)
			{
				scrollRectUion.destroy();
				scrollRectUion = null;
			}
			_skin = null;
			_tab = null;
		}
	}
}