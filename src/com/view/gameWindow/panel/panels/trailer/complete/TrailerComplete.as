package com.view.gameWindow.panel.panels.trailer.complete
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.configData.cfgdata.TaskTrailerCfgData;
	import com.model.configData.cfgdata.TaskTrailerRewardCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.trailer.MCTrailerComplete;
	import com.view.gameWindow.panel.panels.trailer.TrailerData;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	import com.model.configData.cfgdata.WorldLevelExpCfgData;
	
	public class TrailerComplete extends PanelBase
	{
		private var mouseHandler:TrailerCompleteMouseHandler;
		private const ACTIVITE_ID:int=801;
		public var isStar:Boolean;
		private var _dt3:ThingsData;
		private var _dt2:ThingsData;
		private var _dt1:ThingsData;
		private var _iconEx1:IconCellEx;
		private var _iconEx3:IconCellEx;
		private var _iconEx2:IconCellEx;
		public function TrailerComplete()
		{
			super();
			TrailerDataManager.getInstance().attach(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
		override protected function initSkin():void
		{
			var skin:MCTrailerComplete = new MCTrailerComplete();
			_skin = skin;
			addChild(_skin);
			setTitleBar(_skin.mcTitleBar);
			_skin.txtNpcName.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.TRAILER_STRING_1,14,true);
			initText();
			TrailerDataManager.getInstance().queryTrailerInfo();
			mouseHandler = new TrailerCompleteMouseHandler(this);
		}
		
		private function initText():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			_skin.txtDialog.text= npcCfgData.default_dialog;
			_skin.mcContent.txtb1.text=StringConst.TRAILER_STRING_04;
			_skin.mcContent.txtb1.mouseEnabled=false;
			_skin.mcContent.visible=false;
			
			_iconEx1 = new IconCellEx(_skin.mcContent.rewardIcon1, 0, 0, 48, 48);
			_iconEx2 = new IconCellEx(_skin.mcContent.rewardIcon2, 0, 0, 48, 48);
			_iconEx3 = new IconCellEx(_skin.mcContent.rewardIcon3, 0, 0, 48, 48);
			
			_dt1 = new ThingsData();
			_dt2 = new ThingsData();
			_dt3 = new ThingsData();
		}
		
		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_TASK_TRAILER_INFO)
			{
				updatePanel();
			}
			super.update(proc);
		}
		
		private function updatePanel():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			if(trailerData.state==TaskStates.TS_CAN_SUBMIT)
			{
				_skin.mcContent.visible=true;
				updateReaward();
			}else
			{
				_skin.mcContent.visible=false;
			}
		}
		
		private function updateReaward():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			var trailerRewardCfgData:TaskTrailerRewardCfgData = ConfigDataManager.instance.trailerRewardCfgData(RoleDataManager.instance.lv);
			var taskTrailerCfgData:TaskTrailerCfgData = ConfigDataManager.instance.taskTrailerCfgData(trailerData.quality);
			var tasktrailerCfg:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
			var expAddon:int;
			var bindCoinAddon:int;
			var gongxunAddon:int;
			if (trailerData.hp > 1)
			{
				if (trailerData.insure > 0)
				{
					expAddon = trailerRewardCfgData.exp * taskTrailerCfgData.reward_rate * taskTrailerCfgData.insure_reward_rate / (100 * 100);
					bindCoinAddon = trailerRewardCfgData.bind_coin * taskTrailerCfgData.reward_rate * taskTrailerCfgData.insure_reward_rate / (100 * 100);
					gongxunAddon = trailerRewardCfgData.get_gongxun * taskTrailerCfgData.reward_rate * taskTrailerCfgData.insure_reward_rate / (100 * 100);
				}
				else
				{
					expAddon = trailerRewardCfgData.exp * taskTrailerCfgData.reward_rate / 100;
					bindCoinAddon = trailerRewardCfgData.bind_coin * taskTrailerCfgData.reward_rate / 100;
					gongxunAddon = trailerRewardCfgData.get_gongxun * taskTrailerCfgData.reward_rate / 100;
				}
			}
			else
			{
				if (trailerData.insure > 0)
				{
					expAddon = trailerRewardCfgData.exp * taskTrailerCfgData.reward_rate / 100;
					bindCoinAddon = trailerRewardCfgData.bind_coin * taskTrailerCfgData.reward_rate / 100;
					gongxunAddon = trailerRewardCfgData.get_gongxun * taskTrailerCfgData.reward_rate / 100;
				}
				else
				{
					expAddon = trailerRewardCfgData.exp * taskTrailerCfgData.reward_rate / 100;
					bindCoinAddon = 0;
					gongxunAddon = trailerRewardCfgData.get_gongxun * taskTrailerCfgData.reward_rate / 100;
				}
			}
			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData(ACTIVITE_ID);
			if (activityCfgData.isInActv)
			{
				expAddon = expAddon * 2;
				bindCoinAddon = bindCoinAddon *2;
			}
			
			var worldLevel:int = WelfareDataMannager.instance.worldLevel;
			var worldLevelExpCfg:WorldLevelExpCfgData = ConfigDataManager.instance.worldLevelExp(worldLevel);
			var worldLevelExp:int = expAddon * worldLevelExpCfg.add_exp_ratio / 100;
			expAddon += worldLevelExp;
			
			ToolTipManager.getInstance().detach(_iconEx1);
			_dt1.id = ItemType.IT_EXP;
			_dt1.type = SlotType.IT_ITEM;
			IconCellEx.setItemByThingsData(_iconEx1, _dt1);
			ToolTipManager.getInstance().attach(_iconEx1);
			
			ToolTipManager.getInstance().detach(_iconEx2);
			_dt2.id = ItemType.IT_MONEY_BIND;
			_dt2.type = SlotType.IT_ITEM;
			IconCellEx.setItemByThingsData(_iconEx2, _dt2);
			ToolTipManager.getInstance().attach(_iconEx2);
			
			ToolTipManager.getInstance().detach(_iconEx3);
			_dt3.id = ItemType.IT_EXPLOIT;
			_dt3.type = SlotType.IT_ITEM;
			IconCellEx.setItemByThingsData(_iconEx3, _dt3);
			ToolTipManager.getInstance().attach(_iconEx3);

			_skin.mcContent.rewardValue1.text=StringConst.INCOME_0002+"：x"+expAddon;
			_skin.mcContent.rewardValue2.text=StringConst.INCOME_0003+"：x"+bindCoinAddon;
			_skin.mcContent.rewardValue3.text=StringConst.INCOME_0017+"：x"+gongxunAddon;
			_iconEx1.visible=_skin.mcContent.rewardValue1.visible=_skin.mcContent.reward1.visible=_skin.mcContent.rewardIcon1.visible=expAddon>0;
			if(_iconEx1.visible==false)
			{
				_skin.mcContent.rewardValue2.x=83;
				_skin.mcContent.rewardValue2.y=82;
				_skin.mcContent.reward2.x=22;
				_skin.mcContent.reward2.y=49;
				_skin.mcContent.rewardIcon2.x=27;
				_skin.mcContent.rewardIcon2.y=54;
			}
			_iconEx2.visible=_skin.mcContent.rewardValue2.visible=_skin.mcContent.reward2.visible=_skin.mcContent.rewardIcon2.visible=bindCoinAddon>0;
			if(_iconEx2.visible==false)
			{
				_skin.mcContent.rewardValue3.x=83;
				_skin.mcContent.rewardValue3.y=142;
				_skin.mcContent.reward3.x=22;
				_skin.mcContent.reward3.y=110;
				_skin.mcContent.rewardIcon3.x=27;
				_skin.mcContent.rewardIcon3.y=115;
			}
			_iconEx3.visible=_skin.mcContent.rewardValue3.visible=_skin.mcContent.reward3.visible=_skin.mcContent.rewardIcon3.visible=gongxunAddon>0;
		}
		
		override public function destroy():void
		{
			if (_iconEx1)
			{
				ToolTipManager.getInstance().detach(_iconEx1);
				if (_iconEx1.parent)
				{
					_iconEx1.parent.removeChild(_iconEx1);
					_iconEx1 = null;
				}
			}
			if (_iconEx2)
			{
				ToolTipManager.getInstance().detach(_iconEx2);
				if (_iconEx2.parent)
				{
					_iconEx2.parent.removeChild(_iconEx2);
					_iconEx2 = null;
				}
			}
			if (_iconEx3)
			{
				ToolTipManager.getInstance().detach(_iconEx3);
				if (_iconEx3.parent)
				{
					_iconEx3.parent.removeChild(_iconEx3);
					_iconEx3 = null;
				}
			}
				
			if (_dt1)
				_dt1 = null;
			if (_dt2)
				_dt2 = null;
			if (_dt3)
				_dt3 = null;
			
			TrailerDataManager.getInstance().detach(this);
			mouseHandler.destroy();
			mouseHandler=null;
			super.destroy();
		}
	}
}