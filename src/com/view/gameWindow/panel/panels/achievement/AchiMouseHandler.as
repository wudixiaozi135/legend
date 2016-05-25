package com.view.gameWindow.panel.panels.achievement
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.achievement.content.AchievementContentItem;
	import com.view.gameWindow.panel.panels.achievement.title.AchievementTitleItem;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;

	public class AchiMouseHandler
	{
		private var _achi:AchievementPanel;
		private var _panel:MCAchievementPanel;
		public function AchiMouseHandler(achi:AchievementPanel)
		{
			_achi=achi;
			_panel=_achi.mcAcPanel;
			_achi.addEventListener(MouseEvent.CLICK,mouseClickFunc);
		}
		
		private function mouseClickFunc(e:MouseEvent):void
		{
			switch (e.target)
			{
				case _panel.closeBtn:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_ACHI);
					return;
				case _panel.btnOneKey:
					AchievementDataManager.getInstance().oneKeyAchievementAward();
					return;
				case _panel.isCheck:
					_achi.isFilter=_panel.isCheck.selected;
					_achi.contentHandler.initView();
					_achi.contentHandler.refreshView();
					return;
				case _panel.txt_vip_link:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_VIP);
					return;
				default:
					break;
			}
			var content:AchievementContentItem=e.target.parent as AchievementContentItem;
			if(content!=null)
			{
				var type:int;
				if(e.target==content.btnsub)
				{
					type=0;
				}else if(e.target==content.btnvsub)
				{
					type=1;
					if(VipDataManager.instance.lv<content.configData.vip_level)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0023);
						return;
					}
				}else
				{
					return;
				}
				if(content.iscompled==false)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ACHI_PANEL_0016);
					return;
				}
				/*if(type==0)
				{
					UtilsTimeOut.dealTimeOut(StringConst.ACHI_PANEL_0017+content.configData.bind_gold,0);
					UtilsTimeOut.dealTimeOut(StringConst.ACHI_PANEL_0018+content.configData.gongxun,500);
				}else
				{
					UtilsTimeOut.dealTimeOut(StringConst.ACHI_PANEL_0019+content.configData.vip_bind_gold,0);
					UtilsTimeOut.dealTimeOut(StringConst.ACHI_PANEL_0020+content.configData.vip_gongxun,500);
				}*/
				e.target.visible=false;
				AchievementDataManager.getInstance().getAchievementAward(content.configData.achievement_id,type);
				return;
			}
			var title:AchievementTitleItem=e.target.parent as AchievementTitleItem;
			if(title!=null)
			{
				if(title.select)return;
				_achi.titleHandler.setSelect(title);
				_achi.titleHandler.refreshTitle();
				_achi.contentHandler.initView();
				_achi.contentHandler.refreshView();
				_achi.updatePanel();
				return;
			}
		}
		
		public function destroy():void
		{
			_achi.removeEventListener(MouseEvent.CLICK,mouseClickFunc);
		}
	}
	
}