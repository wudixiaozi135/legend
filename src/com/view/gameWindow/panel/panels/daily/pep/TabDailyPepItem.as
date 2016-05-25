package com.view.gameWindow.panel.panels.daily.pep
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.DailyCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DungeonData;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	import com.view.gameWindow.panel.panels.taskBoss.TaskBossDataManager;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class TabDailyPepItem
	{
		private var _bg0:MovieClip,_bg1:MovieClip,_bg2:MovieClip,_txt0:TextField,_txt1:TextField,_txt2:TextField;
		
		internal function get bg0():MovieClip
		{
			return _bg0;
		}
		
		internal function get txt2():TextField
		{
			return _txt2;
		}
		
		private var _skin:McDailyPepItem;

		public function get skin():McDailyPepItem
		{
			return _skin;
		}

		internal function get isCanGet():Boolean
		{
			var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
 			var finishCount:int = getFinishCount();
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

		private var _frame:int;

		private var _txtColor0:uint;
		private var _txtColor1:uint;
		private var _txtColor2:uint;
		/**超额领取是否提示临时变量*/
		private var _isPrompt:Boolean;
		
		public function TabDailyPepItem(dailyData:DailyData,frame:int)
		{
			_skin = new McDailyPepItem();
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			_dailyData = dailyData;
			_frame = frame;
			init();
		}
		
		private function init():void
		{
			_bg0 = _skin.mcBg0;
			_bg1 = _skin.mcBg1;
			_bg2 = _skin.mcBg2;
			_txt0 = _skin.txt0;
			_txt0.mouseEnabled = false;
			_txtColor0 = _txt0.textColor;
			_txt1 = _skin.txt1;
			_txt1.mouseEnabled = false;
			_txtColor1 = _txt0.textColor;
			_txt2 = _skin.txt2;
			_txtColor2 = _txt0.textColor;
			_skin.mouseEnabled = false;
			refreshFrame();
			//
			if(_frame != 1)
			{
				return;
			}
			if(_dailyData)
			{
				var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
				_txt0.text = cfgDt.condition_desc.replace("&x",0).replace("&y",cfgDt.count);
				//
				_txt1.text = StringConst.DAILY_PANEL_0002+" "+StringConst.DAILY_PANEL_0013+"+"+cfgDt.player_daily_vit+"/"+StringConst.DAILY_PANEL_0019+"+"+cfgDt.hero_daily_vit;
			}
			//
			_isPrompt = DailyDataManager.instance.isPrompt;
		}
		
		private function refreshFrame():void
		{
			if(_frame == 1)
			{
				_txt0.visible = _txt1.visible = _txt2.visible = _bg0.visible = true;
				_bg1.visible = _bg2.visible = false;
			}
			else if(_frame == 2)
			{
				_txt0.visible = _txt1.visible = _txt2.visible = _bg0.visible = false;
				_bg1.visible = true;
				_bg2.visible = false;
			}
			else if(_frame == 3)
			{
				_txt0.visible = _txt1.visible = _txt2.visible = _bg0.visible = false;
				_bg1.visible = false;
				_bg2.visible = true;
			}
		}
		
		internal function refresh():void
		{
			if(_frame != 1)
			{
				return;
			}
			refreshGet();
			//
			var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
			var textFormatTxt0:TextFormat = _txt0.defaultTextFormat;
			var textFormatTxt1:TextFormat = _txt1.defaultTextFormat;
			if(!isCanGet)
			{
				textFormatTxt0.color = 0xff0000;
				textFormatTxt1.color = 0xffe1aa;
				_txt2.visible = false;
			}
			else
			{
				textFormatTxt0.color = 0x00ff00;
				textFormatTxt1.color = 0x00ff00;
				_txt2.visible = true;
			}
			//
			if(_txt0.text)
			{
				var startIndex:int = _txt0.text.search(/\d*\/\d*/);
				var match:String = _txt0.text.match(/\d*\/\d*/)[0];
				var endIndex:int = match.search("/");
				var finishCount:int = getFinishCount();
				_txt0.replaceText(startIndex,startIndex+endIndex,(finishCount >= cfgDt.count ? cfgDt.count : finishCount)+"");
				_txt0.setTextFormat(textFormatTxt0,startIndex,startIndex+match.length);
			}
			//
			if(_txt1.text)
			{
				_txt1.setTextFormat(textFormatTxt1,4,_txt1.text.length);
			}
		}
		
		private function refreshGet():void
		{
			if(_dailyData.isGet)
			{
				_txt2.text = StringConst.DAILY_PANEL_0018
				_txt0.textColor = 0xb4b4b4;
				_txt1.textColor = 0xb4b4b4;
				_txt2.textColor = 0xb4b4b4;
			}
			else if(isCanGet)
			{
				_txt2.htmlText = HtmlUtils.createHtmlStr(_txt2.textColor,StringConst.DAILY_PANEL_0017,12,false,2,FontFamily.FONT_NAME,true);
				_txt0.textColor = _txtColor0;
				_txt1.textColor = _txtColor1;
				_txt2.textColor = _txtColor2;
			}
		}
		
		private function getFinishCount():int
		{
			var count:int;
			var cfgDt:DailyCfgData = _dailyData.dailyCfgData;
			if(_dailyData.type == DailyData.TYPE_ACTIVITY)
			{
				cfgDt.activity_id;
				
			}
			else if(_dailyData.type == DailyData.TYPE_TASK)
			{
				if(cfgDt.task_type == 1)//星级任务
				{
					count = PanelTaskStarDataManager.instance.count;
				}
				else if(cfgDt.task_type == 2)//悬赏任务
				{
					count = TaskBossDataManager.instance.numDone;
				}
				else if(cfgDt.task_type == 3)//押镖任务
				{
					count = 0;
				}
			}
			else if(_dailyData.type == DailyData.TYPE_DUNGEON)
			{
				var dgnId:int = cfgDt.dungeon_id;
				var dgnDts:Dictionary = DgnDataManager.instance.datas;
				var dgnDt:DungeonData = dgnDts[dgnId] as DungeonData;
				count = dgnDt ? dgnDt.daily_enter_count : 0;
			}
			return count;
		}
		
		internal function onMcClick():void
		{
			trace("TabDailyPepItem.onMcClick");
		}
		
		internal function onTxtClick():void
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
					showDailyPepPrompt(txt,getVit,null,setPromptState,null,strSelect);
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
			_skin = null;
			_dailyData = null;
			_frame = 0;
			_bg0 = null;
			_bg1 = null;
			_bg2 = null;
			_txt0 = null;
			_txt1 = null;
			_txt2 = null;
		}
		
		internal static function compareByOrder(left:TabDailyPepItem, right:TabDailyPepItem):int
		{
			return left.order - right.order;
		}
	}
}