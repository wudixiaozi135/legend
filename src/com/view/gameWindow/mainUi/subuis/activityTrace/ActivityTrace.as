package com.view.gameWindow.mainUi.subuis.activityTrace
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.MapRegionType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.activitys.castellanWorship.WorshipDataManager;
	import com.view.gameWindow.panel.panels.activitys.goldenPig.GoldenPigDataManager;
	import com.view.gameWindow.panel.panels.activitys.loongWar.trace.DataLoongWarFamilyRank;
	import com.view.gameWindow.panel.panels.activitys.loongWar.trace.DataLoongWarTrace;
	import com.view.gameWindow.panel.panels.activitys.nightFight.DataNightFightRank;
	import com.view.gameWindow.panel.panels.activitys.nightFight.NightFightDataManager;
	import com.view.gameWindow.panel.panels.activitys.seaFeast.SeaFeastDataManager;
	import com.view.gameWindow.panel.panels.map.MapDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.SpecialActionTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.css.GameStyleSheet;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import flashx.textLayout.formats.TextAlign;
	
	/**
	 * 活动追踪
	 * @author wqhk
	 * 2014-11-27
	 */
	public class ActivityTrace extends Sprite implements IObserver
	{
		private var _width:int;
		private var _contentHeight:int;
		private var _timeId:int = 0;
		
		private var _txtName:TextField;
		private var _txtInfos:TextField;
		private var _txtDes:TextField;
		private var _txtRegionType:TextField;
		private var _line:DelimiterLine;
		private var _btn:McActivityDepart;
		private var _txtBtn:TextField;

		private var _mcLWTrace:McLoongWarTrace;
		private var _mcNFTrace:McNightFightTrace;
		
		public function ActivityTrace(width:int)
		{
			super();
			mouseEnabled = false;
			//
			_width = width;
			//
			initialize();
		}
		
		private function initialize():void
		{
			if(!_txtName)
			{
				_txtName = new TextField();
				_txtName.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xffcc00,true,null,null,null,null,TextAlign.CENTER,null,null,null,6)
				_txtName.width = _width;
				_txtName.height = 18;
				_txtName.filters = [new GlowFilter(0x0,1,3,3,10)];
				_txtName.mouseEnabled = false;
				addChild(_txtName);
			}
			if(!_txtInfos)
			{
				_txtInfos = new TextField();
				_txtInfos.multiline = true;
				_txtInfos.wordWrap = true;
				_txtInfos.width = _width - 16;
				_txtInfos.x = 8;
				_txtInfos.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xffe1aa,null,null,null,null,null,null,null,null,null,6)
				_txtInfos.filters = [new GlowFilter(0x0,1,3,3,10)];
				_txtInfos.mouseEnabled = false;
				addChild(_txtInfos);
			}
			if(!_txtDes)
			{
				_txtDes = new TextField();
				_txtDes.multiline = true;
				_txtDes.wordWrap = true;
				_txtDes.width = _width - 16;
				_txtDes.x = 8;
				_txtDes.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xffe1aa,null,null,null,null,null,null,null,null,null,6)
				_txtDes.filters = [new GlowFilter(0x0,1,3,3,10)];
				_txtDes.mouseEnabled = false;
				addChild(_txtDes);
			}
			if(!_txtRegionType)
			{
				_txtRegionType = new TextField();
				_txtRegionType.width = _width;
				_txtRegionType.height = 18;
				_txtRegionType.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xffe1aa,null,null,null,null,null,TextAlign.CENTER,null,null,null,6)
				_txtRegionType.filters = [new GlowFilter(0x0,1,3,3,10)];
				_txtRegionType.mouseEnabled = false;
				addChild(_txtRegionType);
			}
			if(!_line)
			{
				_line = new DelimiterLine();
				_line.width = _width - 20;
				_line.x = 10;
				var rsrLoader:RsrLoader = new RsrLoader();
				rsrLoader.load(_line,ResourcePathConstants.IMAGE_TOOLTIP_FOLDER_LOAD,true);
				addChild(_line);
			}
			if(!_btn)
			{
				_btn = new McActivityDepart();
				_btn.x = (_width - _btn.width)*.5;
				rsrLoader = new RsrLoader();
				rsrLoader.load(_btn,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
				addChild(_btn);
				//
				_txtBtn = new TextField();
				_txtBtn.x = _btn.x;
				_txtBtn.width = _btn.width;
				_txtBtn.height = 18;
				_txtBtn.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xd4a460,null,null,null,null,null,TextAlign.CENTER);
				_txtBtn.filters = [new GlowFilter(0,1,3,3,10)];
				_txtBtn.mouseEnabled = false;
				addChild(_txtBtn);
			}
		}
		
		public function update(proc:int=0):void
		{
			if(proc == ModelEvents.UPDATE_MAP_ACTIVITY || proc == ModelEvents.UPDATE_REGION_TYPE)
			{
				updateTxtName();
				updateTxtInfos();
				updateLine();
				updateTxtDes();
				updataTxtRegionType();
				updateBtn();
				updateCountDown();
			}
		}
		
		private function updateTxtName():void
		{
			var activity:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			_txtName.text = activity ? activity.name : StringConst.TIP_ACTIVITY_NONE;
			_contentHeight = 0;
			_txtName.y = 3;
			_contentHeight = _txtName.y + _txtName.height;
		}
		
		private function updateTxtInfos():void
		{
			assignTxtInfos();
			_txtInfos.height = _txtInfos.textHeight + 4;
			_txtInfos.y = _contentHeight + 3;
			_contentHeight = _txtInfos.y + _txtInfos.height;
		}
		
		private function assignTxtInfos():void
		{
			if(_txtInfos)
			{
				var string:String = "";
				var manager:ActivityDataManager = ActivityDataManager.instance;
				var currentActvCfgDtAtMap:ActivityCfgData = manager.currentActvCfgDtAtMap;
				if(currentActvCfgDtAtMap)
				{
					var isInActv:Boolean = currentActvCfgDtAtMap.isInActv;
					var second:int = currentActvCfgDtAtMap.secondRemain;
					if(isInActv && second)
					{
						if(currentActvCfgDtAtMap.func_type == ActivityFuncTypes.AFT_SEA_SIDE)
						{
							string = dealStrSeaFeast(second);
						}
						else if(currentActvCfgDtAtMap.func_type == ActivityFuncTypes.AFT_GOLDEN_PIG)
						{
							string = dealGoldenPig(second);
						}
						else if(currentActvCfgDtAtMap.func_type == ActivityFuncTypes.AFT_WORSHIP)
						{
							string = dealWorship(second);
						}
						else if(currentActvCfgDtAtMap.func_type == ActivityFuncTypes.AFT_LOONG_WAR)
						{
							string = dealLoongWar(second);
						}
						else if(currentActvCfgDtAtMap.func_type == ActivityFuncTypes.AFT_NIGHT_FIGHT)
						{
							string = dealNightFight(second);
						}
						else if(currentActvCfgDtAtMap.func_type == ActivityFuncTypes.AFT_GOD_DEVIL)
						{
							string = dealSwmy(second);
						}
					}
					else
					{
						manager.openActvs[currentActvCfgDtAtMap.id] = null;
						manager.updateActvAtMap();
						manager.notify(ModelEvents.UPDATE_MAP_ACTIVITY);
					}
				}
				_txtInfos.htmlText = string;
			}
		}
		
		private function dealSwmy(second:int):String
		{
			var string:String = "";
			//剩余时间
			string = HtmlUtils.createHtmlStr(0xffe1aa,StringConst.SURPLUS,12,false,3) + HtmlUtils.createHtmlStr(0x53b436,TimeUtils.format(TimeUtils.calcTime(second)),12,false,3)
			return string;
		}
		
		private function dealNightFight(second:int):String
		{
			var string:String = "";
			//剩余时间
			string = HtmlUtils.createHtmlStr(0xffe1aa,StringConst.SURPLUS,12,false,3) + HtmlUtils.createHtmlStr(0x53b436,TimeUtils.format(TimeUtils.calcTime(second-1)),12,false,3)//比倒计时时间慢一秒所以减一
			return string;
		}
		
		private function dealLoongWar(second:int):String
		{
			var dtLWTrace:DataLoongWarTrace = ActivityDataManager.instance.loongWarDataManager.dtLWTrace;
			var string:String = "";
			//占领者
			string = HtmlUtils.createHtmlStr(0xffe1aa,dtLWTrace.textType,12,false,3);
			string += HtmlUtils.createHtmlStr(0x00a2ff,dtLWTrace.familyNameFull,12,false,3) + "\n";
			//占领时间
			string += HtmlUtils.createHtmlStr(0xffe1aa,StringConst.LOONG_WAR_TRACE_0004,12,false,3);
			string += HtmlUtils.createHtmlStr(0x00a2ff,dtLWTrace.textOccupyTime,12,false,3) + "\n";
			//剩余时间
			string += HtmlUtils.createHtmlStr(0xff0000,StringConst.SURPLUS+TimeUtils.format(TimeUtils.calcTime(second)),12,false,3) + "\n";
			//当前区域
			string += HtmlUtils.createHtmlStr(0xffe1aa,StringConst.LOONG_WAR_TRACE_0005,12,false,3);
			string += HtmlUtils.createHtmlStr(0x00ff00,StringConst.LOONG_WAR_TRACE_0006.replace("&x",dtLWTrace.expRatio),12,false,3);
			string += HtmlUtils.createHtmlStr(0xffe1aa,StringConst.LOONG_WAR_TRACE_0007,12,false,3) + "\n";
			//获得经验
			string += HtmlUtils.createHtmlStr(0xffe1aa,StringConst.LOONG_WAR_TRACE_0008,12,false,3);
			string += HtmlUtils.createHtmlStr(0x00ff00,dtLWTrace.exp+"",12,false,3);
			return string;
		}
		
		private function dealWorship(second:int):String
		{
			/*剩余时间：xx分xx秒
			每xx秒增加经验：99999
			累计获得经验：999999999*/
			var string:String = "";
			string = HtmlUtils.createHtmlStr(0xd4a460,StringConst.SURPLUS,12,false,3) + TimeUtils.format(TimeUtils.calcTime(second)) + "\n";
			var worshipDataManager:WorshipDataManager = ActivityDataManager.instance.worshipDataManager;
			string += HtmlUtils.createHtmlStr(0xd4a460,StringConst.WORSHIP_TRACE_0001.replace("&x",worshipDataManager.strPer),12,false,3) + worshipDataManager.strExpPer + "\n";
			string += HtmlUtils.createHtmlStr(0xd4a460,StringConst.WORSHIP_TRACE_0002,12,false,3) + worshipDataManager.strExpTotal;
			return string;
		}
		
		private function dealGoldenPig(second:int):String
		{
			/*剩余时间：xx分xx秒
			当前波数：1/5
			剩余金猪：15/60
			下一波倒计时：xx分xx秒*/
			var string:String = "";
			string = HtmlUtils.createHtmlStr(0xd4a460,StringConst.SURPLUS,12,false,3) + TimeUtils.format(TimeUtils.calcTime(second)) + "\n";
			var goldenPigDataManager:GoldenPigDataManager = ActivityDataManager.instance.goldenPigDataManager;
			string += HtmlUtils.createHtmlStr(0xd4a460,StringConst.GOLDEN_PIG_0001,12,false,3) + goldenPigDataManager.strWave + "\n";
			string += HtmlUtils.createHtmlStr(0xd4a460,StringConst.GOLDEN_PIG_0002,12,false,3) + goldenPigDataManager.strPigNum + "\n";
			string += HtmlUtils.createHtmlStr(0xd4a460,StringConst.GOLDEN_PIG_0003,12,false,3) + goldenPigDataManager.strNextWaveTime;
			return string;
		}
		
		private function dealStrSeaFeast(second:int):String
		{
			/*剩余时间：xx分xx秒
			面前经验倍率：120%
			VIP特权加成：20%
			累计获得经验：222222444*/
			var string:String = "";
			string = HtmlUtils.createHtmlStr(0xd4a460,StringConst.SURPLUS,12,false,3) + TimeUtils.format(TimeUtils.calcTime(second)) + "\n";
			var vipCfgData:VipCfgData = VipDataManager.instance.vipCfgData;
			var vipAdden:int = vipCfgData ? vipCfgData.sea_side_exp_addon : 0;
			var seaFeastDataManager:SeaFeastDataManager = ActivityDataManager.instance.seaFeastDataManager;
			var player:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var multiply:Number = player.specialAction == SpecialActionTypes.PSA_LAY ? (seaFeastDataManager.seaFeastCfgData.lay_exp_ratio + vipAdden)*.01 : (1 + vipAdden*.01);
			string += HtmlUtils.createHtmlStr(0xd4a460,StringConst.SEA_FEAST_0009,12,false,3) + multiply + "\n";
			string += HtmlUtils.createHtmlStr(0xd4a460,StringConst.SEA_FEAST_0010,12,false,3) + vipAdden + "%\n";
			string += HtmlUtils.createHtmlStr(0xd4a460,StringConst.SEA_FEAST_0011,12,false,3) + seaFeastDataManager.exp_gain;
			return string;
		}
		
		private function updateLine():void
		{
			_line.y = _contentHeight + 5;
			_contentHeight = _line.y + 5;
		}
		
		private function updateTxtDes():void
		{
			var activity:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			if(activity)
			{
				if(activity.func_type == ActivityFuncTypes.AFT_LOONG_WAR)
				{
					updateTxtDesLoongWar();
				}
				else if(activity.func_type == ActivityFuncTypes.AFT_NIGHT_FIGHT)
				{
					updateTxtDesNightFight();
				}
				else
				{
					func();
				}
			}
			else
			{
				func();
			}
			function func():void
			{
				if(_mcLWTrace)
				{
					_mcLWTrace.visible = false;
					ToolTipManager.getInstance().detach(_mcLWTrace.txtTip);
				}
				if(_mcNFTrace)
				{
					_mcNFTrace.visible = false;
					ToolTipManager.getInstance().detach(_mcNFTrace.txtTip);
				}
				//
				_txtDes.htmlText = activity ? CfgDataParse.pareseDesToStr(activity.desc) : "";
				_txtDes.height = _txtDes.textHeight + 4;
				_txtDes.y = _contentHeight + 3;
				_contentHeight = _txtDes.y + _txtDes.height;
			}
		}
		
		private function updateTxtDesLoongWar():void
		{
			_txtDes.text = "";
			//
			if(!_mcLWTrace)
			{
				_mcLWTrace = new McLoongWarTrace();
				var rsrLoader:RsrLoader = new RsrLoader();
				rsrLoader.load(_mcLWTrace,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
				addChild(_mcLWTrace);
				_mcLWTrace.txtMore.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
				{
					trace("ActivityTrace.enclosing_method(event) 查看更多");
					if(event.currentTarget == _mcLWTrace.txtMore)
					{
						PanelMediator.instance.switchPanel(PanelConst.TYPE_LOONG_WAR_LIST_RANK);
					}
				});
			}
			_mcLWTrace.visible = true;
			_mcLWTrace.y = _contentHeight + 3;
			var dtLWTrace:DataLoongWarTrace = ActivityDataManager.instance.loongWarDataManager.dtLWTrace;
			//
			var str:String = HtmlUtils.createHtmlStr(0xffcc00,StringConst.LOONG_WAR_TRACE_0009,12,true,3);
			_mcLWTrace.txtFamilyRank.htmlText = str;
			//
			var i:int,l:int = 3;
			for (i=0;i<l;i++) 
			{
				if(i >= dtLWTrace.dtsFamilyRank.length)
				{
					_mcLWTrace["txtName"+i].text = StringConst.SCHOOL_PANEL_00331;
					_mcLWTrace["txtScore"+i].text = StringConst.LOONG_WAR_TRACE_0010;
					_mcLWTrace["txtScoreValue"+i].text = "0";
					continue;
				}
				var dtRank:DataLoongWarFamilyRank = dtLWTrace.dtsFamilyRank[i];
				if(!dtRank)
				{
					_mcLWTrace["txtName"+i].text = StringConst.SCHOOL_PANEL_00331;
					_mcLWTrace["txtScore"+i].text = StringConst.LOONG_WAR_TRACE_0010;
					_mcLWTrace["txtScoreValue"+i].text = "0";
					continue;
				}
				str = HtmlUtils.createHtmlStr(_mcLWTrace["txtName"+i].textColor,dtRank.familyName,12,true,3);
				_mcLWTrace["txtName"+i].htmlText = str;
				_mcLWTrace["txtScore"+i].text = StringConst.LOONG_WAR_TRACE_0010;
				str = HtmlUtils.createHtmlStr(_mcLWTrace["txtScoreValue"+i].textColor,dtRank.familyScore+"",12,false,3);
				_mcLWTrace["txtScoreValue"+i].htmlText = str;
			}
			//
			str = HtmlUtils.createHtmlStr(0xffcc00,StringConst.LOONG_WAR_TRACE_0011,12,true,3);
			_mcLWTrace.txtPersonRank.htmlText = str;
			//
			_mcLWTrace.txtName.text = RoleDataManager.instance.name;
			_mcLWTrace.txtScore.text = StringConst.LOONG_WAR_TRACE_0012;
			_mcLWTrace.txtScoreValue.text = dtLWTrace.score + "";
			_mcLWTrace.txtRank.text = StringConst.LOONG_WAR_TRACE_0013 + dtLWTrace.rank;
			//
			str = HtmlUtils.createHtmlStr(_mcLWTrace.txtMore.textColor,StringConst.LOONG_WAR_TRACE_0014,12,false,3,FontFamily.FONT_NAME,true);
			_mcLWTrace.txtMore.htmlText = str;
			//
			_mcLWTrace.txtTip.htmlText = HtmlUtils.createHtmlStr(_mcLWTrace.txtTip.textColor,StringConst.DGN_TOWER_0048,12,false,2,FontFamily.FONT_NAME,true);
			_mcLWTrace.txtTip.styleSheet = GameStyleSheet.linkStyle;
			var activity:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			var strDesc:String = CfgDataParse.pareseDesToStr(activity.desc);
			ToolTipManager.getInstance().attachByTipVO(_mcLWTrace.txtTip,ToolTipConst.TEXT_TIP,strDesc);
			//
			_contentHeight = _mcLWTrace.y + _mcLWTrace.height;
		}
		
		private function updateTxtDesNightFight():void
		{
			_txtDes.text = "";
			//
			if(!_mcNFTrace)
			{
				_mcNFTrace = new McNightFightTrace();
				var rsrLoader:RsrLoader = new RsrLoader();
				rsrLoader.load(_mcNFTrace,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
				addChild(_mcNFTrace);
				_mcNFTrace.mcTitle.txt0.text = StringConst.NIGHT_FIGHT_TRACE_0001;
				_mcNFTrace.mcTitle.txt1.text = StringConst.NIGHT_FIGHT_TRACE_0002;
				_mcNFTrace.mcTitle.txt2.text = StringConst.NIGHT_FIGHT_TRACE_0003;
				_mcNFTrace.mcTitle.txt0.textColor = _mcNFTrace.mcTitle.txt1.textColor = _mcNFTrace.mcTitle.txt2.textColor = 0xffcc00;
				_mcNFTrace.txtScores.text = StringConst.NIGHT_FIGHT_TRACE_0004;
				_mcNFTrace.txtRank.text = StringConst.NIGHT_FIGHT_TRACE_0005;
				_mcNFTrace.txtExp.text = StringConst.NIGHT_FIGHT_TRACE_0007;
			}
			_mcNFTrace.visible = true;
			_mcNFTrace.y = _contentHeight + 3;
			//
			var manager:NightFightDataManager = ActivityDataManager.instance.nightFightDataManager;
			var i:int,l:int = manager.TOTAL_DTS;
			for (i=0;i<l;i++) 
			{
				var mc:McNightFightTraceLine = _mcNFTrace["mc"+i];
				var dt:DataNightFightRank = manager.dtsRank[i];
				mc.txt0.text = dt.strName;
				mc.txt1.text = dt.strScore;
				mc.txt2.text = dt.rank+"";
				mc.txt0.textColor = mc.txt1.textColor = mc.txt2.textColor = dt.textColor;
			}
			//
			_mcNFTrace.txtRankValue.text = manager.strRankMine;
			_mcNFTrace.txtScoresValue.text = manager.scoreMine+"";
			_mcNFTrace.txtExpValue.text = manager.totalExp+"";
			//
			_mcNFTrace.txtTip.htmlText = HtmlUtils.createHtmlStr(_mcNFTrace.txtTip.textColor,StringConst.DGN_TOWER_0048,12,false,2,FontFamily.FONT_NAME,true);
			_mcNFTrace.txtTip.styleSheet = GameStyleSheet.linkStyle;
			var activity:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			var strDesc:String = CfgDataParse.pareseDesToStr(activity.desc);
			ToolTipManager.getInstance().attachByTipVO(_mcNFTrace.txtTip,ToolTipConst.TEXT_TIP,strDesc);
			//
			_contentHeight = _mcNFTrace.y + _mcNFTrace.height + _mcNFTrace.txtTip.y;
		}
		
		private function updataTxtRegionType():void
		{
			var activity:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			if(activity)
			{
				if (activity.func_type == ActivityFuncTypes.AFT_GOLDEN_PIG ||
					activity.func_type == ActivityFuncTypes.AFT_LOONG_WAR ||
					activity.func_type == ActivityFuncTypes.AFT_NIGHT_FIGHT)
				{
					_txtRegionType.htmlText = "";
				}
				else
				{
					var type:int = MapDataManager.instance.regionType;
					var str:String = "";
					if(type == MapRegionType.FIGHT)
					{
						str = HtmlUtils.createHtmlStr(0xff0000,StringConst.TIP_MAP_REGION_DANGEROUS_EX,12,false,3);
					}
					else
					{
						str = HtmlUtils.createHtmlStr(0x00ff00,StringConst.TIP_MAP_REGION_SAFE_EX,12,false,3);
					}
					_txtRegionType.htmlText = str;
					_txtRegionType.y = _contentHeight + 3;
					_contentHeight = _txtRegionType.y + _txtRegionType.height;
				}
			}
			else
			{
				_txtRegionType.htmlText = "";
			}
		}
		
		private function updateBtn():void
		{
			var activity:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			if(activity)
			{
				if (activity.func_type == ActivityFuncTypes.AFT_GOLDEN_PIG || 
					activity.func_type == ActivityFuncTypes.AFT_LOONG_WAR ||
					activity.func_type == ActivityFuncTypes.AFT_WORSHIP)
				{
					_txtBtn.text = "";
					_btn.visible = false;
					_contentHeight += 10;
				}
				else
				{
					_btn.visible = true;
					_btn.y = _contentHeight + 5;
					_contentHeight = _btn.y + _btn.height + 10;
					_txtBtn.y = _btn.y + (_btn.height - _txtBtn.height)*.5;
					!_txtBtn.text ? _txtBtn.text = StringConst.ACITIVTY_0001 : null;
				}
			}
			else
			{
				_txtBtn.text = "";
				_btn.visible = false;
				_contentHeight += 10;
			}
		}
		
		private function updateCountDown():void
		{
			var activity:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			if(activity)
			{
				startCountDown();
			}
			else
			{
				stopCountDown();
			}
		}
		
		private function startCountDown():void
		{
			if(_timeId == 0)
			{
				_timeId = setInterval(assignTxtInfos,1000);
			}
		}
		
		public function stopCountDown():void
		{
			if(_timeId != 0)
			{
				clearInterval(_timeId);
				_timeId = 0;
			}
		}
		
		public function get contentHeight():int
		{
			return _contentHeight;
		}
		
		public function get btn():MovieClip
		{
			return _btn.btn;
		}
		
		private function addText(htmlStr:String,x:int,y:int):TextField
		{
			var text:TextField = new TextField();
			addChild(text);
			text.autoSize = TextFieldAutoSize.LEFT;
			text.htmlText = htmlStr;
			text.width = text.textWidth + 3;
			text.height = 18;
			text.wordWrap = true;
			text.multiline =true;
			text.x = x;
			text.y = y;
			text.filters = [UtilColorMatrixFilters.BLACK_COLOR_FILTER];
			return text;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(value)
			{
				MapDataManager.instance.attach(this);
				ActivityDataManager.instance.attach(this);
				//
				update(ModelEvents.UPDATE_MAP_ACTIVITY);
			}
			else
			{
				MapDataManager.instance.detach(this);
				ActivityDataManager.instance.detach(this);
				stopCountDown();
			}
		}
	}
}