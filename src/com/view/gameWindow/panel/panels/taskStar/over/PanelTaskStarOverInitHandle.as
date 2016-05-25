package com.view.gameWindow.panel.panels.taskStar.over
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.configData.cfgdata.TaskStarCostCfgData;
	import com.model.configData.cfgdata.TaskStarRateCfgData;
	import com.model.configData.cfgdata.TaskStarRewardCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.taskStar.McTaskStarOver;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.UtilNumChange;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import mx.utils.StringUtil;

	/**
	 * 星级任务完成初始化处理类
	 * @author Administrator
	 */	
	public class PanelTaskStarOverInitHandle
	{
		private var _panel:PanelTaskStarOver;
		private var _mc:McTaskStarOver;
		
		public function PanelTaskStarOverInitHandle(panel:PanelTaskStarOver)
		{
			_panel = panel;
			_mc = _panel.skin as McTaskStarOver;
			init();
		}
		
		private function init():void
		{
			_mc.txtTitle.text = StringConst.TASK_STAR_PANEL_0001;
			_mc.txtInfo.text = StringConst.TASK_STAR_PANEL_0010;
			_mc.txt00.text = StringConst.TASK_STAR_PANEL_0011;
			_mc.txt01.text = StringConst.TASK_STAR_PANEL_0012;
			_mc.txt02.text = StringConst.TASK_STAR_PANEL_0013;
			
//			_mc.txt20.text = StringConst.TASK_STAR_PANEL_0014;
//			_mc.txt21.text = StringConst.TASK_STAR_PANEL_0015;
//			_mc.txt22.text = StringConst.TASK_STAR_PANEL_0016;
			
//			var taskStarCostCfgData:TaskStarCostCfgData = ConfigDataManager.instance.taskStarCostCfgData(2);
//			_mc.txt31.text = StringConst.TASK_STAR_PANEL_0028+taskStarCostCfgData.bind_coin+StringConst.TASK_STAR_PANEL_0023;
//			taskStarCostCfgData = ConfigDataManager.instance.taskStarCostCfgData(3);
//			_mc.txt30.text = StringConst.TASK_STAR_PANEL_0028+taskStarCostCfgData.bind_coin+StringConst.TASK_STAR_PANEL_0023;
			
			
			
			var i:int,l:int = 3;
			for(i=0;i<l;i++)
			{
				refreshRewardTxt(_mc["txt1"+i],i+1);
				initBtnTxt(_mc["txt2"+i]);
			}
			
			setRewardInfo(1,_mc.txt22,_mc.btn2,_mc.txt32);
			setRewardInfo(2,_mc.txt21,_mc.btn1,_mc.txt31);
			setRewardInfo(3,_mc.txt20,_mc.btn0,_mc.txt30);
		}
		
		private function setRewardInfo(id:int,btnName:TextField,btn:MovieClip,cost:TextField):void
		{
			ToolTipManager.getInstance().detach(btnName.parent);
			var taskStarCostCfgData:TaskStarCostCfgData = ConfigDataManager.instance.taskStarCostCfgData(id);
			var costDes:String = "";
			if(taskStarCostCfgData)
			{
				btnName.text = StringUtil.substitute(StringConst.TASK_STAR_PANEL_0039,taskStarCostCfgData.rate);
				
				if(taskStarCostCfgData.vip>0)
				{
					costDes+=StringConst.TIP_VIP+taskStarCostCfgData.vip+" ";
				}
				
				if(taskStarCostCfgData.coin>0)
				{
					var tipVO:TipVO = new TipVO;
					tipVO.tipType = ToolTipConst.TEXT_TIP;
					tipVO.tipData = HtmlUtils.createHtmlStr(0xffc000,StringConst.TIP_USE_COIN_PRIORITY);
					ToolTipManager.getInstance().hashTipInfo(btn,tipVO);
					ToolTipManager.getInstance().attach(btn);
					
					costDes+=StringConst.TASK_STAR_PANEL_0028+taskStarCostCfgData.coin+StringConst.TASK_STAR_PANEL_0023;
				}
				
				cost.text = costDes;
			}
			else
			{
				btnName.text = "";
				cost.text = "";
			}
		}
		
		private function initBtnTxt(txt:TextField):void
		{
			txt.mouseEnabled = false;
//			var movieClip:MovieClip = new MovieClip();
//			movieClip.buttonMode = true;
//			txt.parent.addChild(movieClip);
//			movieClip.x = txt.x;
//			movieClip.y = txt.y;
//			txt.x = txt.y = 0;
//			movieClip.addChild(txt);
		}
		
		public function destroy():void
		{
			_mc = null;
			_panel = null;
		}
		
		public function refresh():void
		{
			refreshTxtInfo();
			var i:int,l:int = 3;
			for(i=0;i<l;i++)
			{
				refreshRewardTxt(_mc["txt1"+i],l-i);
			}
		}
		
		private function refreshTxtInfo():void
		{
			var tid:int = PanelTaskStarDataManager.instance.tid;
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			if(!taskCfgData)
			{
				return;
			}
			var star:int;
			switch(taskCfgData.type)
			{
				default:
				case TaskTypes.TT_ROOTLE:
					star = PanelTaskStarDataManager.instance.wajue_star;
					break;
				case TaskTypes.TT_MINING:
					star = PanelTaskStarDataManager.instance.caikuang_star;
					break;
				case TaskTypes.TT_EXORCISM:
					star = PanelTaskStarDataManager.instance.chumo_star;
					break;
			}
			var string:String = star+StringConst.TASK_STAR_PANEL_0018+taskCfgData.name;
			string = HtmlUtils.createHtmlStr(0xffcc00,string,14);
			_mc.txtInfo.htmlText = _mc.txtInfo.text.replace("&x",string);
		}
		
		private function refreshRewardTxt(txt:TextField,multiples:int):void
		{
			var tid:int = PanelTaskStarDataManager.instance.tid;
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			if(!taskCfgData)
			{
				return;
			}
			var lv:int = PanelTaskStarDataManager.instance.level;
			var taskStarRewardCfgData:TaskStarRewardCfgData = ConfigDataManager.instance.taskStarRewardCfgData(lv,taskCfgData.type);
			var star:int = PanelTaskStarDataManager.instance.getStar(taskCfgData.type);
			var taskStarRateCfgData:TaskStarRateCfgData = ConfigDataManager.instance.taskStarRateCfgData(star);
			var exp:int = taskStarRewardCfgData.exp*taskStarRateCfgData.rate;
			var itemString:Array = UtilItemParse.getItemString(taskStarRewardCfgData.reward_item);
			var utilNumChange:UtilNumChange = new UtilNumChange();
			txt.text = utilNumChange.changeNum(multiples*exp)+StringConst.TASK_STAR_PANEL_0004.substr(0,2)+"，"+itemString[1]+"*"+itemString[2];
		}
	}
}