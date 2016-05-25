package com.view.gameWindow.panel.panels.taskStar.handle
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskStarCostCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.taskStar.McTaskStar;
	import com.view.gameWindow.panel.panels.taskStar.PanelTaskStar;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;

	import mx.utils.StringUtil;

	/**
	 * 星级任务面板初始化处理类
	 * @author Administrator
	 */	
	public class PanelTaskStarInitHnadle
	{
		private var _panel:PanelTaskStar;
		private var _mc:McTaskStar;
		
		public function PanelTaskStarInitHnadle(panel:PanelTaskStar)
		{
			_panel = panel;
			_mc = panel.skin as McTaskStar;
			init();
		}
		
		private function init():void
		{
			
			
			_mc.txtTitle.text = StringConst.TASK_STAR_PANEL_0001;
			_mc.txtTitle.mouseEnabled = false;
			_mc.btnprompt.visible = false;
			_mc.btnprompt.txt.mouseEnabled = false;
			_mc.btnprompt.txt.text = StringConst.TASK_STAR_PANEL_0060;

			_mc.taskTarget.textColor = 0xffe1aa;
			_mc.taskTarget.text = StringConst.TASK_STAR_PANEL_0040;
			_mc.taskTarget.mouseEnabled = false;

			_mc.rewardContainer.rewardValue1.mouseEnabled = false;
			_mc.rewardContainer.rewardValue1.textColor = 0xffcc00;
			_mc.rewardContainer.rewardValue2.mouseEnabled = false;
			_mc.rewardContainer.rewardValue2.textColor = 0xffcc00;
			_mc.txtRule.text = StringConst.TASK_STAR_PANEL_0047;

			_mc.mcReceiveLayer.btnZoom.visible = false;
			_mc.mcReceiveLayer.txtToday.textColor = 0xd4a460;
			_mc.mcReceiveLayer.txtToday.text = StringConst.TASK_STAR_PANEL_0008;
			_mc.mcReceiveLayer.txtToday.mouseEnabled = false;

			_mc.mcReceiveLayer.txtTodayCount.textColor = 0x00ff00;
			_mc.mcReceiveLayer.txtTodayCount.text = "";
			_mc.mcReceiveLayer.txtTodayCount.mouseEnabled = false;

			_mc.mcReceiveLayer.txtRefresh.mouseEnabled = false;
			_mc.mcReceiveLayer.txtRefresh.textColor = 0xd4a460;
			_mc.mcReceiveLayer.txtRefresh.text = StringConst.TASK_STAR_PANEL_0026;

			_mc.mcReceiveLayer.txt_0.text = StringConst.TASK_STAR_PANEL_0046;
			_mc.mcReceiveLayer.txt_0.mouseEnabled = false;

			_mc.mcReceiveLayer.txtBtnReceive.mouseEnabled = false;
			_mc.mcReceiveLayer.txtBtnReceive.text = StringConst.TASK_STAR_PANEL_0006;

			_mc.mcReceiveLayer.txtVip.htmlText = StringConst.PANEL_PRAY_7;
			_mc.mcReceiveLayer.txtVip.visible = true;

			var taskStarCostCfgData:TaskStarCostCfgData = ConfigDataManager.instance.taskStarCostCfgData(1);
			var costDes:String = StringConst.TASK_STAR_PANEL_0028 + taskStarCostCfgData.coin + StringConst.TASK_STAR_PANEL_0023;

			_mc.mcRewardLayer.txtReward1.htmlText = StringConst.TASK_STAR_PANEL_0011;
			_mc.mcRewardLayer.txtReward2.htmlText = StringConst.TASK_STAR_PANEL_0012;
			_mc.mcRewardLayer.txtReward3.htmlText = StringConst.TASK_STAR_PANEL_0013;

			_mc.mcRewardLayer.txtCost1.mouseEnabled = false;
			_mc.mcRewardLayer.txtCost2.mouseEnabled = false;
			_mc.mcRewardLayer.txtCost3.mouseEnabled = false;

			_mc.mcRewardLayer.txtCost1.textColor = 0xffe1aa;
			_mc.mcRewardLayer.txtCost2.textColor = 0xffe1aa;
			_mc.mcRewardLayer.txtCost3.textColor = 0xffe1aa;

			_mc.mcRewardLayer.txtCost1.text = StringConst.TASK_STAR_PANEL_0063;
			_mc.mcRewardLayer.txtCost2.text = StringConst.TASK_STAR_PANEL_0062;
			_mc.mcRewardLayer.txtCost3.text = StringConst.TASK_STAR_PANEL_0061;

			setTextTips();
			setVipTips();
		}

		private function setVipTips():void
		{
			var tipVo:TipVO = new TipVO();
			tipVo.tipType = ToolTipConst.TEXT_TIP;
			tipVo.tipData = getTipVo;
			ToolTipManager.getInstance().hashTipInfo(_mc.mcReceiveLayer.txtVip, tipVo);
			ToolTipManager.getInstance().attach(_mc.mcReceiveLayer.txtVip);
		}

		private function getTipVo():String
		{
			var cfg:VipCfgData, mgt:VipDataManager = VipDataManager.instance, mgt2:ConfigDataManager = ConfigDataManager.instance;
			var tip:String = HtmlUtils.createHtmlStr(0xd4a460, StringUtil.substitute(StringConst.PRAY_TIP_1, mgt.lv)) + "<br>";
			tip += HtmlUtils.createHtmlStr(0xd4a460, StringConst.PRAY_TIP_2) + "<br>";
			tip += HtmlUtils.createHtmlStr(0xffffff, StringConst.PRAY_TIP_7) + "<br>";
			for (var i:int = 1; i <= VipDataManager.MAX_LV; i++)
			{
				cfg = mgt2.vipCfgData(i);
				tip += HtmlUtils.createHtmlStr(0xffffff, StringUtil.substitute(StringConst.PRAY_TIP_4, i, cfg.add_task_star_num));
				tip += "<br>";
			}
			return tip;
		}


		///详情说明
		private function setTextTips():void
		{
			var tipVo:TipVO = new TipVO();
			tipVo.tipType = ToolTipConst.TEXT_TIP;
			tipVo.tipData = StringConst.TASK_STAR_PANEL_0054;
			ToolTipManager.getInstance().hashTipInfo(_mc.txtRule, tipVo);
			ToolTipManager.getInstance().attach(_mc.txtRule);
		}
		
		public function destroy():void
		{
			ToolTipManager.getInstance().detach(_mc.txtRule);
			ToolTipManager.getInstance().detach(_mc.mcReceiveLayer.txtVip);
			_mc = null;
			_panel = null;
		}
	}
}