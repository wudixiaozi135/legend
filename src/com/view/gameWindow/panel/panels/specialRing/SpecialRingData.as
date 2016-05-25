package com.view.gameWindow.panel.panels.specialRing
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.configData.cfgdata.SpecialRingCfgData;
	import com.model.configData.cfgdata.SpecialRingLevelCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.specialRing.upgrade.RingCondition;
	import com.view.gameWindow.panel.panels.task.constants.TaskCondition;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;
	
	import flash.utils.Dictionary;

	/**
	 * 特戒数据类
	 * @author Administrator
	 */	
	public class SpecialRingData
	{
		public static const RING_INDEX_1:int = 1;
		public static const RING_INDEX_2:int = 2;
		public static const RING_INDEX_3:int = 3;
		public static const RING_INDEX_4:int = 4;
		public static const RING_INDEX_5:int = 5;
		public static const RING_INDEX_6:int = 6;
		public static const RING_INDEX_7:int = 7;
		public static const RING_INDEX_8:int = 8;
		
		public var isInit:Boolean;
		public var isActive:Boolean;
		public var ringIndex:int;
		public var ringId:int;//特戒id，4字节有符号整形
		private var _level:int;//特戒等级，1字节有符号整形
		public var in_use:int;//是否使用，1字节有符号整形，1表示使用，0表示未使用，仅仅需要使用的特戒才有效
		
		public var linkTexts:Vector.<LinkText>;
		public var conditions:Vector.<RingCondition>;

		private var _data:SpecialRingCfgData;
		private var _target1:String;
		private var _target2:String;

		private var _levelZeroAttr:String;

		private var _totalAttr:Array;
		
		private var _skillCfgDatas:Vector.<SkillCfgData>;
		
		public function SpecialRingData(ringIndex:int = 0,ringId:int = 0)
		{
			this.ringIndex = ringIndex;
			this.ringId = ringId;
			linkTexts = new Vector.<LinkText>(4,true);
			conditions = new Vector.<RingCondition>(4,true);
			if(ringIndex != 0)
			{
				initTarget1Condition();
				initTarget2Condition();
			}
		}
		
		private function initTarget1Condition():void
		{
			var cfgDt:SpecialRingCfgData = specialRingCfgData;
			//
			var condition:int = cfgDt.target1_condition1;
			var request:String = cfgDt.target1_request1;
			if(condition)
			{
				var ringCondition:RingCondition = new RingCondition();
				conditions[0] = ringCondition;
				ringCondition.init(ringId,condition,request);
				var linkText:LinkText = new LinkText();
				linkTexts[0] = linkText;
				linkText.lId=0;
				linkText.init(cfgDt.target1_hint1);
			}
			//
			condition = cfgDt.target1_condition2;
			request = cfgDt.target1_request2;
			if(condition)
			{
				ringCondition = new RingCondition();
				conditions[1] = ringCondition;
				ringCondition.init(ringId,condition,request);
				linkText = new LinkText();
				linkTexts[1] = linkText;
				linkText.lId=1;
				linkText.init(cfgDt.target1_hint2);
			}
		}
		
		private function initTarget2Condition():void
		{
			var cfgDt:SpecialRingCfgData = specialRingCfgData;
			//
			var condition:int = cfgDt.target2_condition1;
			var request:String = cfgDt.target2_request1;
			if(condition && request)
			{
				var ringCondition:RingCondition = new RingCondition();
				conditions[2] = ringCondition;
				ringCondition.init(ringId,condition,request);
				var linkText:LinkText = new LinkText();
				linkTexts[2] = linkText;
				linkText.lId=2;
				linkText.init(cfgDt.target2_hint1);
			}
			//
			condition = cfgDt.target2_condition2;
			request = cfgDt.target2_request2;
			if(condition && request)
			{
				ringCondition = new RingCondition();
				conditions[3] = ringCondition;
				ringCondition.init(ringId,condition,request);
				linkText = new LinkText();
				linkTexts[3] = linkText;
				linkText.lId=3;
				linkText.init(cfgDt.target2_hint2);
			}
		}
		
		public function get specialRingCfgData():SpecialRingCfgData
		{
			if(!_data)
			{
				_data = ConfigDataManager.instance.specialRingCfgData(ringId);
			}
			return _data;
		}
		
		public function get skillCfgDatas():Vector.<SkillCfgData>
		{
			if(!_skillCfgDatas)
			{
				_skillCfgDatas = new Vector.<SkillCfgData>();
				var cfgDtGroups:Dictionary = ConfigDataManager.instance.skillCfgDatasByRing(ringId,0);
				getSkillCfgData(cfgDtGroups);
				var job:int = RoleDataManager.instance.job;
				cfgDtGroups = ConfigDataManager.instance.skillCfgDatasByRing(ringId,job);
				getSkillCfgData(cfgDtGroups);
			}
			return _skillCfgDatas;
		}
		
		private function getSkillCfgData(cfgDtGroups:Dictionary):void
		{
			var cfgDtGroup:Dictionary,cfgDt:SkillCfgData,cfgDtMin:SkillCfgData,i:int;
			for each(cfgDtGroup in cfgDtGroups)
			{
				cfgDt = null;
				cfgDtMin = null;
				for(i=0;i<=level;i++)//遍历所有等级
				{
					if(cfgDtGroup[i])
					{
						cfgDt = cfgDtGroup[i];
//						break;
					}
				}
				if(cfgDt)//若取得技能配置，表示该技能已激活存入技能数据管理类
				{
					SkillDataManager.instance.setSkillData(cfgDt);
				}
				else//若当前等级没有对应的技能配置，取最小等级技能配置信息作为TIP显示数据
				{
					for each(cfgDt in cfgDtGroup)
					{
						if(!cfgDtMin || cfgDtMin.ring_level > cfgDt.ring_level)
						{
							cfgDtMin = cfgDt;
						}
					}
					cfgDt = cfgDtMin;
				}
				if(cfgDt)
				{
					_skillCfgDatas.push(cfgDt);
				}
			}
		}
		
		public function get target1():String
		{
			if(isActive)
			{
				return "";
			}
			var replace:String = "";
			var color:String="";
			
			if(conditions[0])
			{
				conditions[0].refresh(false);
				var currentNum:String = conditions[0].condition == TaskCondition.TC_PLAYER_LEVEL ? conditions[0].currentLvStr : conditions[0].currentNum + "";
				var needNum:String = conditions[0].condition == TaskCondition.TC_PLAYER_LEVEL ? conditions[0].needLvStr : conditions[0].needNum + "";
				if(conditions[0].completed)  //这个地方做了一个简单的写法，如果后期一条数据里面要有两个‘点击完成’，这个地方要用count属性来循环
				{
					color="#2dfb05";
					replace += linkTexts[0] ? linkTexts[0].htmlText.replace("<c/>", "<font color='"+color+"'> (" + /*currentNum + "/" + needNum*/StringConst.SPECIAL_RING_PANEL_0043 + ")</font><br/>"):"";
				}
				else
				{
					color="#ff0000";
					if(conditions[0].condition==TaskCondition.TC_DUNGEON)  //如果是副本
					{
						replace += linkTexts[0] ? linkTexts[0].htmlText.replace("<c/>", "<font color='"+color+"'> (" + currentNum + "/" + needNum + ") " +
							"</font><font color='#2dfb05'><u><a href='event:0|1'>"+StringConst.SPECIAL_RING_PANEL_0039+"</a></u></font><br/>"):"";
					}
					else
					{
						replace += linkTexts[0] ? linkTexts[0].htmlText.replace("<c/>", "<font color='"+color+"'> (" + currentNum + "/" + needNum + ")</font><br/>"):"";
					}
				}
				
				if(isInit && !isActive && (conditions[0]==null||conditions[0].completed)&&(conditions[1]==null||conditions[1].completed)) //条件达成时的判断
				{
					var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
					if(!openedPanel)
					{
						SpecialRingDataManager.instance.ringGet = ringId;
						PanelMediator.instance.openPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
					}
				}
			}
			
			if(conditions[1])
			{
				conditions[1].refresh(false);
				currentNum = conditions[1].condition == TaskCondition.TC_PLAYER_LEVEL ? conditions[1].currentLvStr : conditions[1].currentNum + "";
				needNum = conditions[1].condition == TaskCondition.TC_PLAYER_LEVEL ? conditions[1].needLvStr : conditions[1].needNum + "";
				if(conditions[1].completed)  //这个地方做了一个简单的写法，如果后期一条数据里面要有两个‘点击完成’，这个地方要用count属性来循环
				{
					color="#2dfb05";
					replace += linkTexts[1] ? linkTexts[1].htmlText.replace("<c/>", "<font color='"+color+"'> (" + /*currentNum + "/" + needNum*/StringConst.SPECIAL_RING_PANEL_0043 + ")</font><br/>"):"";
				}
				else
				{
					color="#ff0000";
					if(conditions[1].condition==TaskCondition.TC_DUNGEON)  //如果是副本
					{
						replace += linkTexts[1] ? linkTexts[1].htmlText.replace("<c/>", "<font color='"+color+"'> (" + currentNum + "/" + needNum + ") " +
							"</font><font color='#2dfb05'><u><a href='event:1|1'>"+StringConst.SPECIAL_RING_PANEL_0039+"</a></u></font><br/>"):"";					
					}
					else
					{
						replace += linkTexts[1] ? linkTexts[1].htmlText.replace("<c/>", "<font color='"+color+"'> (" + currentNum + "/" + needNum + ")</font><br/>"):"";
					}
				}
				if(isInit && !isActive && (conditions[0]==null||conditions[0].completed)&&(conditions[1]==null||conditions[1].completed)) //条件达成时的判断
				{
					openedPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
					if(!openedPanel)
					{
						SpecialRingDataManager.instance.ringGet = ringId;
						PanelMediator.instance.openPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
					}
				}
			}
			_target1 = HtmlUtils.createHtmlStr(0xffe1aa,replace,12,false,6);
			
			return _target1;
		}
		
		public function get target2():String
		{
			if(isActive)
			{
				return "";
			}
			var replace:String = "";
			var color:String="";
			
			if(conditions[2] )
			{
				conditions[2].refresh(false);
				var currentNum:String = conditions[2].condition == TaskCondition.TC_PLAYER_LEVEL ? conditions[2].currentLvStr : conditions[2].currentNum + "";
				var needNum:String = conditions[2].condition == TaskCondition.TC_PLAYER_LEVEL ? conditions[2].needLvStr : conditions[2].needNum + "";
				if(conditions[2].completed)  //这个地方做了一个简单的写法，如果后期一条数据里面要有两个‘点击完成’，这个地方要用count属性来循环
				{
					color="#2dfb05";
					replace += linkTexts[2] ? linkTexts[2].htmlText.replace("<c/>", "<font color='"+color+"'> (" + /*currentNum + "/" + needNum*/StringConst.SPECIAL_RING_PANEL_0043 + ")</font><br/>"):"";
				}
				else
				{
					color="#ff0000";
					if(conditions[2].condition==TaskCondition.TC_DUNGEON)  //如果是副本
					{
						replace += linkTexts[2] ? linkTexts[2].htmlText.replace("<c/>", "<font color='"+color+"'> (" + currentNum + "/" + needNum + ") " +
							"</font><font color='#2dfb05'><u><a href='event:2|1'>"+StringConst.SPECIAL_RING_PANEL_0039+"</a></u></font><br/>"):"";					
					}
					else
					{
						replace += linkTexts[2] ? linkTexts[2].htmlText.replace("<c/>", "<font color='"+color+"'> (" + currentNum + "/" + needNum + ")</font><br/>"):"";
					}
				}
				if(isInit && !isActive && (conditions[2]==null||conditions[2].completed)&&(conditions[3]==null||conditions[3].completed)) //条件达成时的判断
				{
					var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
					if(!openedPanel)
					{
						SpecialRingDataManager.instance.ringGet = ringId;
						PanelMediator.instance.openPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
					}
				}
			}
			
			
			if(conditions[3])
			{
				conditions[3].refresh(false);
				currentNum = conditions[3].condition == TaskCondition.TC_PLAYER_LEVEL ? conditions[3].currentLvStr : conditions[3].currentNum + "";
				needNum = conditions[3].condition == TaskCondition.TC_PLAYER_LEVEL ? conditions[3].needLvStr : conditions[3].needNum + "";
				if(conditions[3].completed)  //这个地方做了一个简单的写法，如果后期一条数据里面要有两个‘点击完成’，这个地方要用count属性来循环
				{
					color="#2dfb05";
					replace += linkTexts[3] ? linkTexts[3].htmlText.replace("<c/>", "<font color='"+color+"'> (" + /*currentNum + "/" + needNum*/StringConst.SPECIAL_RING_PANEL_0043 + ")</font><br/>"):"";
				}
				else
				{
					color="#ff0000";
					if(conditions[3].condition==TaskCondition.TC_DUNGEON)  //如果是副本
					{
						replace += linkTexts[3] ? linkTexts[3].htmlText.replace("<c/>", "<font color='"+color+"'> (" + currentNum + "/" + needNum + ") " +
							"</font><font color='#2dfb05'><u><a href='event:3|1'>"+StringConst.SPECIAL_RING_PANEL_0039+"</a></u></font><br/>"):"";					
					}
					else
					{
						replace += linkTexts[3] ? linkTexts[3].htmlText.replace("<c/>", "<font color='"+color+"'> (" + currentNum + "/" + needNum + ")<font><br/>"):"";
					}
				}
				if(isInit && !isActive && (conditions[2]==null||conditions[2].completed)&&(conditions[3]==null||conditions[3].completed)) //条件达成时的判断
				{
					openedPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
					if(!openedPanel)
					{
						SpecialRingDataManager.instance.ringGet = ringId;
						PanelMediator.instance.openPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
					}
				}
			}
			
			_target2 = HtmlUtils.createHtmlStr(0xffe1aa,replace,12,false,6);
			return _target2;
		}
		
		public function checkOnlyRequest():void
		{
			if(!specialRingCfgData.is_ring_only_condition)
			{
				return;
			}
			var strOnlyRequests:String = specialRingCfgData.only_request;
			var onlyRequests:Array = strOnlyRequests.split("|");
			var i:int,l:int = onlyRequests.length;
			var isSatisfy:Boolean = true;
			for(i=0;i<l;i++)
			{
				var strOnlyRequest:String = onlyRequests[i] as String;
				var onlyRequest:Array = strOnlyRequest.split(":");
				var dtI:SpecialRingData = SpecialRingDataManager.instance.getDataById(onlyRequest[0]);
				var lvNeed:int = onlyRequest[1];
				var boolean:Boolean = dtI.level >= lvNeed;
				isSatisfy &&= boolean;
			}
			if(isInit && !isActive && isSatisfy)
			{
				SpecialRingDataManager.instance.getRing(ringId);
			}
		}
		
		public function get specialRingLevelCfgData():SpecialRingLevelCfgData
		{
			var data:SpecialRingLevelCfgData = ConfigDataManager.instance.specialRingLevelCfgData(ringId,level);
			return data;
		}
		
		public function get specialRingLevelCfgDataNext():SpecialRingLevelCfgData
		{
			var data:SpecialRingLevelCfgData = ConfigDataManager.instance.specialRingLevelCfgData(ringId,level+1);
			return data;
		}
		
		public function getSpecialRingLevelCfgData(level:int):SpecialRingLevelCfgData
		{
			var data:SpecialRingLevelCfgData = ConfigDataManager.instance.specialRingLevelCfgData(ringId,level);
			return data;
		}
		
		public function getLevelAttr(level:int):String
		{
			var str:String = "";
			var data:SpecialRingLevelCfgData = ConfigDataManager.instance.specialRingLevelCfgData(ringId,level);
			if(data)
			{
				var attrs:Vector.<String> = CfgDataParse.getAttHtmlStringArray(data.attr);
				var i:int,l:int = attrs.length;
				for(i=0;i<l;i++)
				{
					if(i+1==l)
					{
						str += attrs[i];
					}
					else
					{
						str += attrs[i] + "\n";
					}
				}
			}
			return str;
		}
		
		public function get totalAttr():Array
		{
			if(!_totalAttr)
			{
				var i:int,l:int,str1:String = "",str2:String="";
				var attrs:Vector.<String> = new Vector.<String>();
				attrs.push(specialRingCfgData.attr);
				for(i=1;i<=level;i++)
				{
					var data:SpecialRingLevelCfgData = ConfigDataManager.instance.specialRingLevelCfgData(ringId,i);
					attrs.push(data.attr);
				}
				var propertyDatas:Vector.<PropertyData> = CfgDataParse.getTAttrStringArray(attrs,true);
				l = propertyDatas.length;
				for(i=0;i<l;i++)
				{
					var tempStr:String = CfgDataParse.propertyToStr(propertyDatas[i],2,0xa56738,0xffe1aa);
					if(i%2)
					{
						str1 += tempStr + "\n";
					}
					else
					{
						str2 += tempStr + "\n";
					}
				}
				_totalAttr = [str2,str1];
			}
			return _totalAttr;
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set level(value:int):void
		{
			if(_level != value)
			{
				_skillCfgDatas = null;
				_totalAttr = null;
			}
			_level = value;
		}
	}
}