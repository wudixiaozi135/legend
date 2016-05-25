package com.view.gameWindow.panel.panels.daily.pep1
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.DailyCfgData;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
	import com.view.gameWindow.panel.panels.mall.constant.MallTabType;
	import com.view.gameWindow.panel.panels.pray.PrayDataManager;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	
	import flash.display.MovieClip;

	public class TabDailyPepItem
	{
		private var _skin:McDailyPepItem;

		public function get skin():McDailyPepItem
		{
			return _skin;
		}

		internal function get isCanGet():Boolean
		{
			var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
 			var finishCount:int = _dailyData.countDone;
			if(finishCount >= cfgDt.count)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		private var _dailyData:DailyData;
		public function get dailyData():DailyData
		{
			return _dailyData;
		}

		private var _txtColor0:uint;
		private var _txtColor1:uint;
		private var _txtColor2:uint;
		/**超额领取是否提示临时变量*/
		private var _isPrompt:Boolean;
		
		public function TabDailyPepItem(dailyData:DailyData)
		{
			_skin = new McDailyPepItem();
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.addCallBack(_skin.btnFly,callBack());
			rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			_dailyData = dailyData;
			initialize();
		}
		
		private function callBack():Function
		{
			var pepItem:TabDailyPepItem = this;
			var func:Function = function (mc:MovieClip):void
			{
				mc.pepItem = pepItem;
			};
			return func;
		}
		
		private function initialize():void
		{
			_skin.mouseEnabled = false;
			//
			if(_dailyData)
			{
				var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
				_skin.txtContent.text = cfgDt.condition_desc;
				_skin.txtCount.text = "0/"+cfgDt.count;
				_skin.txtReward.text = cfgDt.reward_desc;
				var enter:String = strEnter();
				var textColor:uint = _skin.txtEnter.textColor;
				_skin.txtEnter.htmlText = HtmlUtils.createHtmlStr(textColor,enter,12,false,2,FontFamily.FONT_NAME,true);
				_skin.btnFly.x = _skin.txtEnter.x + _skin.txtEnter.textWidth + 10;
				_skin.btnFly.visible = enter != "" && enter != StringConst.DAILY_PANEL_0041;
				_skin.txtPep.text = cfgDt.player_daily_vit + "";
				_skin.txtPepGet.text = "";
			}
			//
			_isPrompt = DailyDataManager.instance.isPrompt;
		}
		
		private function strEnter():String
		{
			var str:String = "";
			var npcCfgData:NpcCfgData;
			var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
			if(_dailyData.type == DailyData.TYPE_ACTIVITY)
			{
				var activity_id:int = cfgDt.activity_id;
				var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData(activity_id);
				if(!activityCfgData)
				{
					return str;
				}
				npcCfgData = ConfigDataManager.instance.npcCfgData(activityCfgData.npc);
				if(!npcCfgData)
				{
					return str;
				}
				return npcCfgData.name;
			}
			else if(_dailyData.type == DailyData.TYPE_TASK)
			{
				npcCfgData = ConfigDataManager.instance.npcCfgData(_dailyData.taskNpc);
				if(!npcCfgData)
				{
					return str;
				}
				return npcCfgData.name;
			}
			else if(_dailyData.type == DailyData.TYPE_DUNGEON)
			{
				var dgnId:int = cfgDt.dungeon_id;
				var dungeonCfgData:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dgnId);
				if(!dungeonCfgData)
				{
					return str;
				}
				npcCfgData = dungeonCfgData.npcCfgData;
				if(!npcCfgData)
				{
					return str;
				}
				return npcCfgData.name;
			}
			else if(_dailyData.type == DailyData.TYPE_EQUIP_DUNGEON)
			{
				npcCfgData = ConfigDataManager.instance.npcCfgData(cfgDt.npc_id);
				if(!npcCfgData)
				{
					return str;
				}
				return npcCfgData.name;
			}
			else if(_dailyData.type == DailyData.TYPE_SIGN_IN || _dailyData.type == DailyData.TYPE_PRAY || 
					_dailyData.type == DailyData.TYPE_EQUIP_STRENGTHEN || _dailyData.type == DailyData.TYPE_EQUIP_DEGREE || 
					_dailyData.type == DailyData.TYPE_KILL_BOSS || _dailyData.type == DailyData.TYPE_SPECIAL_RING_DUNGEON/* || 
					_dailyData.type == DailyData.TYPE_EXP_STONE*/)
			{
				str = StringConst.DAILY_PANEL_0041;
			}
			return str;
		}
		
		private function npcId():int
		{
			var id:int;
			var npcCfgData:NpcCfgData;
			var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
			if(_dailyData.type == DailyData.TYPE_ACTIVITY)
			{
				var activity_id:int = cfgDt.activity_id;
				var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData(activity_id);
				if(!activityCfgData)
				{
					return id;
				}
				return activityCfgData.npc;
			}
			else if(_dailyData.type == DailyData.TYPE_TASK)
			{
				return _dailyData.taskNpc;
			}
			else if(_dailyData.type == DailyData.TYPE_DUNGEON)
			{
				var dgnId:int = cfgDt.dungeon_id;
				var dungeonCfgData:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dgnId);
				if(!dungeonCfgData)
				{
					return id;
				}
				return dungeonCfgData.npc;
			}
			else if(_dailyData.type == DailyData.TYPE_EQUIP_DUNGEON)
			{
				return cfgDt.npc_id;
			}
			return id;
		}
		
		internal function refresh():void
		{
			if(_dailyData.isGet)
			{
				_skin.txtPepGet.text = StringConst.DAILY_PANEL_0018;
				_skin.txtPepGet.mouseEnabled = false;
				_skin.filters = UtilColorMatrixFilters.GREY_FILTERS;
			}
			else if(isCanGet)
			{
				_skin.txtPepGet.htmlText = HtmlUtils.createHtmlStr(_skin.txtPepGet.textColor,StringConst.DAILY_PANEL_0017,12,false,2,FontFamily.FONT_NAME,true);
				_skin.txtPepGet.mouseEnabled = true;
				_skin.filters = null;
			}
			else
			{
				_skin.txtPepGet.text = "";
				_skin.txtPepGet.mouseEnabled = false;
				_skin.filters = null;
			}
			//
			var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
			var finishCount:int = _dailyData.countDone;
			var count:String = (finishCount >= cfgDt.count ? cfgDt.count : finishCount)+"/"+cfgDt.count;
			_skin.txtCount.text = count;
		}
		
		internal function onMcClick():void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			var npc:int = npcId();
			DailyDataManager.instance.requestTeleport(npc);
		}
		
		internal function onTxtNpcClick():void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			if(_skin.txtEnter.text == StringConst.DAILY_PANEL_0041)
			{
				dealLookOver();
			}
			else
			{
				var npc:int = npcId();
				AutoJobManager.getInstance().setAutoTargetData(npc, EntityTypes.ET_NPC);
			}
		}
		/**查看处理*/
		private function dealLookOver():void
		{
			var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
			if(_dailyData.type == DailyData.TYPE_SIGN_IN)
			{
				WelfareDataMannager.instance.dealSwitchPanleWelfare();
			}
			else if(_dailyData.type == DailyData.TYPE_PRAY)
			{
				PrayDataManager.instance.dealSwitchPanlePray();
			}
			else if(_dailyData.type == DailyData.TYPE_EQUIP_STRENGTHEN)
			{
				ForgeDataManager.instance.dealSwitchPanel1(ForgeDataManager.typeStrengthen);
			}
			else if(_dailyData.type == DailyData.TYPE_EQUIP_DEGREE)
			{
				ForgeDataManager.instance.dealSwitchPanel1(ForgeDataManager.typeDegree);
			}
			else if(_dailyData.type == DailyData.TYPE_KILL_BOSS)
			{
				/*BossDataManager.instance.dealSwitchPanleBoss();*/
				PanelMediator.instance.openPanel(PanelConst.TYPE_BOSS);
				var panelTab:IPanelTab = PanelMediator.instance.openedPanel(PanelConst.TYPE_BOSS) as IPanelTab;
				if(panelTab)
				{
					panelTab.setTabIndex(BossDataManager.INDIVIDUAL_BOSS_INDEX);
				}
			}
			else if(_dailyData.type == DailyData.TYPE_SPECIAL_RING_DUNGEON)
			{
				SpecialRingDataManager.instance.selectTab = 1;
				PanelMediator.instance.openPanel(PanelConst.TYPE_SPECIAL_RING);
			}
			else if(_dailyData.type == DailyData.TYPE_EXP_STONE)
			{
				var skillOpen:OpenPanelAction = new OpenPanelAction(PanelConst.TYPE_MALL,MallTabType.TYPE_TICKET);
				skillOpen.act();
			}
		}
		
		internal function onTxtGetClick():void
		{
			/*trace("TabDailyPepItem.onTxtClick");*/
			if(!isCanGet)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DAILY_PANEL_0034);
				return;
			}
			var manager:DailyDataManager = DailyDataManager.instance;
			if(manager.isPrompt)
			{
				var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
				var totalPlayer:int = cfgDt.player_daily_vit + manager.player_daily_vit;
				var totalHero:int = cfgDt.hero_daily_vit + manager.hero_daily_vit;
				var str:String;
				if(totalPlayer > manager.daily_vit_max)
				{
					str = StringConst.BAG_PANEL_0017;
				}
				else if(totalHero > manager.daily_vit_max)
				{
					str = StringConst.BAG_PANEL_0018;
				}
				if(str)
				{
					var txt:String = StringConst.DAILY_PANEL_0033.replace("&x",str);
					txt = HtmlUtils.createHtmlStr(0xd4a460,txt,12,false,6);
					var strSelect:String = StringConst.PROMPT_PANEL_0027;
//					showDailyPepPrompt(txt,getVit,null,setPromptState,null,strSelect);
					Alert.show3(txt,getVit,null,setPromptState,null,strSelect,StringConst.PROMPT_PANEL_0003,StringConst.PROMPT_PANEL_0013,null,"left");
					/*RollTipMediator.instance.showRollTip(RollTipType.ERROR,txt);*/
					return;
				}
			}
			getVit();
		}
		/**设置超额领取是否提示*/
		private function setPromptState():void
		{
			_isPrompt = !_isPrompt;
		}
		/**领取活力值*/
		private function getVit():void
		{
			DailyDataManager.instance.isPrompt = _isPrompt;
			DailyDataManager.instance.requestGetDailyVit(_dailyData.id);
		}
		/**
		 * 显示一按钮提示面板
		 * @param txt 内容
		 * @param funcBtn 确定按钮回调函数
		 * @param funcBtnParam 确定按钮回调函数参数
		 * @param funcSelect 选择按钮回调函数
		 * @param funcSelectParam 选择按钮回调函数参数
		 * @param strSelect 选择按钮文字
		 * @param align 内容对齐方式<br>left:左对齐<br>right:右对齐<br>center:居中<br>justify:自动
		 * @param title 标题
		 */		
		private function showDailyPepPrompt(txt:String, funcBtn:Function = null, funcBtnParam:* = null, 
									funcSelect:Function = null, funcSelectParam:* = null, strSelect:String = "", 
									align:String = "center", title:String = StringConst.PROMPT_PANEL_0005):void
		{
			Panel1BtnPromptData.strName = title;
			Panel1BtnPromptData.strContent = "\n\n<p align='"+align+"'>"+txt+"</p>";
			Panel1BtnPromptData.strBtn = StringConst.PROMPT_PANEL_0003;
			Panel1BtnPromptData.funcBtn = funcBtn;
			Panel1BtnPromptData.funcBtnParam = funcBtnParam;
			Panel1BtnPromptData.funcSelect = funcSelect;
			Panel1BtnPromptData.funcSelectParam = funcSelectParam;
			Panel1BtnPromptData.strSelect = strSelect;
			PanelMediator.instance.openPanel(PanelConst.TYPE_DAILY_PEP_PROMPT);
		}
		
		internal function get order():int
		{
			if (_dailyData)
			{
				return _dailyData.order;
			}
			return int.MAX_VALUE;
		}
		
		internal function destroy():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DAILY_PEP_PROMPT);
			if(_skin.parent)
			{
				_skin.parent.removeChild(_skin);
			}
			_isPrompt = false;
			_skin.btnFly.pepItem = null;
			_skin = null;
			_dailyData = null;
		}
		
		internal static function compareByOrder(left:TabDailyPepItem, right:TabDailyPepItem):int
		{
			if(left.isCanGet && !right.isCanGet)
			{
				return -1;
			}
			else if(!left.isCanGet && right.isCanGet)
			{
				return 1;
			}
			else
			{
				return left.order - right.order;
			}
		}
	}
}