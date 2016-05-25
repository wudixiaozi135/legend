package com.view.gameWindow.panel.panels.vip
{
	import com.model.configData.cfgdata.PeerageCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.text.TextFormat;

	/**
	 * vip特权面板显示相关处理类
	 * @author Administrator
	 */	
	internal class PanelVipViewHandle
	{
		private var _panel:PanelVip;
		private var _mc:McVip;
		
		public function PanelVipViewHandle(panel:PanelVip)
		{
			_panel = panel;
			_mc = _panel.skin as McVip;
			init();
		}
		
		private function init():void
		{
			_mc.txtRule.text = StringConst.VIP_PANEL_0003;
			var defaultTextFormat:TextFormat = _mc.txtPeerage.defaultTextFormat;
			defaultTextFormat.bold = true;
			_mc.txtPeerage.defaultTextFormat = defaultTextFormat;
			_mc.txtPeerage.setTextFormat(defaultTextFormat);
			defaultTextFormat = _mc.txtLv.defaultTextFormat;
			defaultTextFormat.bold = true;
			_mc.txtLv.defaultTextFormat = defaultTextFormat;
			_mc.txtLv.setTextFormat(defaultTextFormat);
			//
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = HtmlUtils.createHtmlStr(0xa56238,StringConst.VIP_PANEL_0011,12,false,6);
			ToolTipManager.getInstance().hashTipInfo(_mc.txtRule,tipVO);
			ToolTipManager.getInstance().attach(_mc.txtRule);
			tipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = HtmlUtils.createHtmlStr(0xa56238,StringConst.VIP_PANEL_0012,12,false,6);
			ToolTipManager.getInstance().hashTipInfo(_mc.txtExp,tipVO);
			ToolTipManager.getInstance().attach(_mc.txtExp);
		}
		
		internal function refresh():void
		{
			var manager:VipDataManager = VipDataManager.instance;
			//爵位
			var peerageCfgData:PeerageCfgData = manager.peerageCfgData;
			_mc.mcSign.gotoAndStop(peerageCfgData ? 2 : 1);
			_mc.txtPeerage.text = peerageCfgData ? peerageCfgData.name : StringConst.VIP_PANEL_0004;
			//vip等级
			var lv:int = manager.lv;
			_mc.txtLv.text = lv ? lv+"" : StringConst.VIP_PANEL_0005;
			//vip经验
			var data:VipCfgData = manager.vipCfgDataNext;
			_mc.txtExp.text = manager.exp+"/"+ (data ? data.point : 0);
			var scale:Number = data ? manager.exp/data.point : 1;
			_mc.mcExp.mcMask.scaleX = scale > 1 ? 1 : scale;
		}
		
		internal function destroy():void
		{
			ToolTipManager.getInstance().detach(_mc.txtRule);
			ToolTipManager.getInstance().detach(_mc.txtExp);
			_mc = null;
			_panel = null;
		}
	}
}