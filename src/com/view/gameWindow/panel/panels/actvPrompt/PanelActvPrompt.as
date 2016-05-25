package com.view.gameWindow.panel.panels.actvPrompt
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 活动开始提示面板类
	 * @author Administrator
	 */	
	public class PanelActvPrompt extends PanelBase
	{
		private var _cfgDt:ActivityCfgData;
		
		public function PanelActvPrompt()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McActvPrompt = new McActvPrompt();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}
		
		override protected function initData():void
		{
			var skin:McActvPrompt = _skin as McActvPrompt;
			_cfgDt = getNextCfgDt();
			skin.txt.mouseEnabled = false;
			skin.txt.htmlText = HtmlUtils.createHtmlStr(0xff6600,_cfgDt.name)+StringConst.ACTV_PROMPT_0003;
			//
			skin.txtShow.mouseEnabled = false;
			skin.txtShow.text = StringConst.ACTV_PROMPT_0001;
			skin.txtJoin.mouseEnabled = false;
			skin.txtJoin.text = StringConst.ACTV_PROMPT_0002;
			//
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McActvPrompt = _skin as McActvPrompt;
			switch(event.target)
			{
				default:
					break;
				case skin.btnClose:
					dealClose();
					break;
				case skin.btnShow:
					dealShow();
					break;
				case skin.btnJoin:
					dealJoin();
					break;
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_ACTV_PROMPT,index);
		}
		
		private function dealShow():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			manager.selectTab = manager.tabActivity;
			PanelMediator.instance.openPanel(PanelConst.TYPE_DAILY);
		}
		
		private function dealJoin():void
		{
			var npcId:int = _cfgDt.npc;
			DailyDataManager.instance.requestTeleport(npcId);
			PanelMediator.instance.closePanel(PanelConst.TYPE_ACTV_PROMPT,index);
		}
		
		private function getNextCfgDt():ActivityCfgData
		{
			var actvCfgDts:Dictionary = ConfigDataManager.instance.activityCfgDatas();
			var nextCfgDt:ActivityCfgData,actvCfgDt:ActivityCfgData;
			for each(actvCfgDt in actvCfgDts)
			{
				var boolean:Boolean = actvCfgDt.secondToStart != int.MIN_VALUE && actvCfgDt.secondToStart != int.MAX_VALUE;
				if(boolean && (!nextCfgDt || actvCfgDt.secondToStart < nextCfgDt.secondToStart))
				{
					nextCfgDt = actvCfgDt;
				}
			}
			return nextCfgDt;
		}
		
		override public function destroy():void
		{
			_cfgDt = null;
			removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}