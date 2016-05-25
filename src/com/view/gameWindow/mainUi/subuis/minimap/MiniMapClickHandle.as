package com.view.gameWindow.mainUi.subuis.minimap
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subclass.McMapProperty;
	import com.view.gameWindow.mainUi.subuis.displaySetting.DisplaySettingManager;
	import com.view.gameWindow.mainUi.subuis.musicSet.MusicSettingManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.achievement.AchievementDataManager;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
	import com.view.gameWindow.panel.panels.stronger.StrongerDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 小地图点击处理类
	 * @author Administrator
	 */	
	public class MiniMapClickHandle
	{
		private var _mc:McMapProperty;
		private var _unlock:UIUnlockHandler;
		
		public function MiniMapClickHandle(mc:McMapProperty)
		{
			_mc = mc;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_unlock = new UIUnlockHandler(null,0);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var mc:MovieClip = evt.target as MovieClip;
			switch(mc)
			{
				case _mc.btnPickUp:
					pickUp();
					break;
				case _mc.btnMap:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_MAP);
					break;
				case _mc.btnMail:
					PanelMailDataManager.instance.getMailList();
					PanelMailDataManager.instance.newMail = false;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_MAIL);
					break;
				case _mc.btnFriend:
					//					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
					PanelMediator.instance.switchPanel(PanelConst.TYPE_FRIEND);
					break;
				case _mc.btnRanking:
					if(_unlock.onClickUnlock(UnlockFuncId.RANK))
					{
						PanelMediator.instance.switchPanel(PanelConst.TYPE_RANK);
					}
					break;
				case _mc.btnAchieve:
					//					if(!GuideSystem.instance.isUnlock(UnlockFuncId.ACHIEVEMENT))
					//					{
					//						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ACHI_PANEL_0021);	
					//						return;
					//					}
					if (checkBottomBtnOpenState(UnlockFuncId.ACHIEVEMENT))
					{
						PanelMediator.instance.switchPanel(PanelConst.TYPE_ACHI);
					}
					break;
				case _mc.btnHide:
					handlerBtnHide();
					break;
				case _mc.btnMusic:
					handlerBtnMusic();
					break;
				case _mc.btnSystemSet:
					//					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
					PanelMediator.instance.switchPanel(PanelConst.TYPE_ASSIST_SET);
					break;
				case _mc.btnAvtivityDaily:
					if (checkBottomBtnOpenState(UnlockFuncId.DAILY_VIT))
					{
						DailyDataManager.instance.dealSwitchPanelDaily();
					}
					break;
				case _mc.btnStronger:
					if (checkBottomBtnOpenState(UnlockFuncId.STRONGER))
					{
						StrongerDataManager.instance.dealSwitchPanleStronger();
					}
					break;
			}
		}
		
		private function checkBottomBtnOpenState(id:int):Boolean
		{
			var isOpen:Boolean = GuideSystem.instance.isUnlock(id);
			if (!isOpen)
			{
				var tip:String = GuideSystem.instance.getUnlockTip(id);
				Alert.warning(tip);
			}
			
			return isOpen;
		}
		
		private function handlerBtnHide():void
		{
			if (_mc.btnHide)
			{
				DisplaySettingManager.instance.defaultSetting(_mc.btnHide.selected);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.MUSIC_SETTING_7);
			}
		}
		
		private function handlerBtnMusic():void
		{
			if (_mc.btnMusic)
			{
				MusicSettingManager.instance.defaultSetting(_mc.btnMusic.selected);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.MUSIC_SETTING_7);
			}
		}
		
		private function pickUp():void
		{
			var i:int,l:int,displayObject:DisplayObject;
			l = _mc.numChildren;
			for(i=0;i<l;i++)
			{
				displayObject = _mc.getChildAt(i);
				if(displayObject != _mc.mcHead && displayObject != _mc.txtMapInfo && displayObject != _mc.btnPickUp)
				{
					displayObject.visible = !_mc.btnPickUp.selected;
				}
			}
			if(!_mc.btnPickUp.selected){
				var noCount:int=AchievementDataManager.getInstance().noRequstCount;
				_mc.txtNoReqCount.htmlText=HtmlUtils.createHtmlStr(0xffffff,noCount+"",12,false);
				_mc.txtNoReqCount.visible=noCount>0;
				_mc.txtRequstBG.visible=noCount>0;
			}
		}
	}
}