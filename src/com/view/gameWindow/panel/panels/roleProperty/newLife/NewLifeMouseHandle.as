package com.view.gameWindow.panel.panels.roleProperty.newLife
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ReinCarnCfgData;
	import com.model.configData.cfgdata.WorldLevelCfgData;
	import com.model.configData.cfgdata.WorldLevelExpCfgData;
	import com.model.consts.StringConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;

	public class NewLifeMouseHandle implements IObserver
	{
		private var _mc:McNewLife;
		private const LEVELMAX:int = 68;
		
		public function NewLifeMouseHandle(mc:McNewLife)
		{
			_mc = mc;
			init();
			NewLifeDataManager.instance.attach(this);
		}
		
		public function update(proc:int=0):void
		{		
			if(proc == GameServiceConstants.CM_REINCARN)
			{
				var reincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(RoleDataManager.instance.reincarn + 1)
				var reincarn:int = reincarnCfg.reincarn;
				var content:String = StringConst.ROLE_PROPERTY_PANEL_0078.replace("X",reincarn.toString()).replace("XX",String(reincarn + LEVELMAX)).replace("XXX",HtmlUtils.createHtmlStr(0x00ff00,String(NewLifeDataManager.instance.reincarn)));
				/*Panel1BtnPromptData.strName = StringConst.ROLE_PROPERTY_PANEL_0060;
				Panel1BtnPromptData.strContent = StringConst.ROLE_PROPERTY_PANEL_0078.replace("X",reincarn.toString()).replace("XX",String(reincarn + LEVELMAX)).replace("XXX",HtmlUtils.createHtmlStr(0x00ff00,String(NewLifeDataManager.instance.reincarn)));
				Panel1BtnPromptData.strBtn = StringConst.ROLE_PROPERTY_PANEL_0079;
				PanelMediator.instance.openPanel(PanelConst.TYPE_1BTN_PROMPT);*/
				Alert.show2(content,null,null,StringConst.ROLE_PROPERTY_PANEL_0079,StringConst.AUTO_ASSIST_DAN2,null,"left");
				NewLifeDataManager.instance.dungeon = 0;
				NewLifeDataManager.instance.time = 0;
			}
		}
		
		private function init():void
		{
			_mc.txt_00.addEventListener(MouseEvent.ROLL_OVER,rollOverHandle);
			_mc.txt_00.addEventListener(MouseEvent.ROLL_OUT,rollOutHandle);
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		private function rollOverHandle(evt:MouseEvent):void
		{
			_mc.txt_00.textColor = 0xff0000;
		}
		
		private function rollOutHandle(evt:MouseEvent):void
		{
			_mc.txt_00.textColor = 0x00ff00;
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var roleDataManager:RoleDataManager = RoleDataManager.instance;
			var reincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn);
			var nextReincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn + 1);
			if(evt.target == _mc.btnNewLife)
			{
				if(!nextReincarnCfg)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0080);
					return;
				}
				if(LEVELMAX + roleDataManager.reincarn > roleDataManager.lv)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0075);
					return;
				}
				if(reincarnCfg.coin > (BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind))
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0077);
					return;
				}
				if(_mc.progress.mcMask.scaleX != 1)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0076);
					return;
				}
				var openday:int = WelfareDataMannager.instance.openServiceDay;
				var maxday:int = ConfigDataManager.instance.maxOpenDay-1;
				var day:int = openday>maxday?maxday:openday;
				var worldCfg:WorldLevelCfgData =  ConfigDataManager.instance.worldLevel(day+1);
				if(roleDataManager.reincarn>=worldCfg.reincarn_limit)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0082);
					return;
				}
				NewLifeDataManager.instance.sendData();			
			}
			else if(evt.target == _mc.txt_00)
			{
				if(!nextReincarnCfg)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0080);
					return;
				}
				if(LEVELMAX + roleDataManager.reincarn > roleDataManager.lv)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0075);
					return;
				}
				if(_mc.progress.mcMask.scaleX == 1)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0081);
					return;
				}
				NewLifeDataManager.instance.enterReincarnDungeon();
				PanelMediator.instance.closePanel(PanelConst.TYPE_ROLE_PROPERTY);
			}
		}
		
		public function destory():void
		{
			NewLifeDataManager.instance.detach(this);
			if(_mc)
			{
				_mc.txt_00.removeEventListener(MouseEvent.ROLL_OVER,rollOverHandle);
				_mc.txt_00.removeEventListener(MouseEvent.ROLL_OUT,rollOutHandle);
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc = null;
			}		
		}
	}
}