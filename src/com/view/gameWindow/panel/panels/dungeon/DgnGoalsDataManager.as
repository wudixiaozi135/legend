package com.view.gameWindow.panel.panels.dungeon
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.DgnEventCfgData;
    import com.model.configData.cfgdata.DgnRewardEvaluateCfgData;
    import com.model.configData.cfgdata.DgnRewardMultipleCfgData;
    import com.model.configData.cfgdata.DungeonCfgData;
    import com.model.configData.cfgdata.MapCfgData;
    import com.model.configData.cfgdata.MapMonsterCfgData;
    import com.model.configData.cfgdata.MapPlantCfgData;
    import com.model.configData.cfgdata.MapRegionCfgData;
    import com.model.configData.cfgdata.MapTrapCfgData;
    import com.model.configData.cfgdata.TaskCfgData;
    import com.model.consts.DungeonConst;
    import com.model.consts.FontFamily;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.dungeon.rewardCard.DataDgnRewardCard;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.ServerTime;
    import com.view.gameWindow.util.TimeUtils;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import flash.utils.getTimer;
    
    import mx.utils.StringUtil;

    /**
	 * @author wqhk
	 * 2014-9-5
	 */
	public class DgnGoalsDataManager extends DataManagerBase
	{
		private static var _instance:DgnGoalsDataManager;
		public static function get instance():DgnGoalsDataManager
		{
			if(!_instance)
			{
				_instance = new DgnGoalsDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		/**正在进入副本*/
		private var _isEntering:Boolean;
		
		private var _dungeonId:int;
		private var _dungeonCfg:DungeonCfgData;
		private var _step:int;
		private var _triggerId:int;
		private var _triggerCfg:DgnEventCfgData;
		private var _totalTrigger:int;
		private var _waveDatas:Array;//WaveData
		private var _starList:Vector.<DgnRewardEvaluateCfgData>;
		private var _multipleList:Array;// DgnRewardMultipleCfgData;
		private var _finishCode:int = -1; // 1 成功  0 失败
		private var _finishTime:int;
		
		private var _startTime:int = 0;
		private var _stepStartTime:int = 0;
		private var _stepRemainSecond:int  = 0;
		private var _remainSecond:int = 0;
		public var isFullStar:Boolean = false;
		
		public var dtDgnRewardCard:DataDgnRewardCard;
		
		public function get isFinish():Boolean
		{
			return _finishCode != -1;
		}
		
		public function resetFinishState():void
		{
			_finishCode = -1;
		}
		
		public function DgnGoalsDataManager(p:PrivateClass)
		{
			super();
			dtDgnRewardCard = new DataDgnRewardCard();
			//
			DistributionManager.getInstance().register(GameServiceConstants.SM_DUNGEON_STEP_PROGRESS,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FINISH_DUNGEON,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_BAG_FULL_SENDMAIL,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_ENTER_TASK_DUNGEON,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_DUNGEON_CARD_DRAW,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_ENTER_DUNGEON,this);
		}
		
		public function requestReward(index:int):Boolean
		{
			var multi:DgnRewardMultipleCfgData = findMultiple(index);
			
			if(multi)
			{
				if(multi.vip > VipDataManager.instance.lv)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.DGN_GOALS_001,multi.vip,multi.multiple));
					return false;
				}
				else if(multi.gold > BagDataManager.instance.goldUnBind)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.DGN_GOALS_002,multi.multiple));
					return false;
				}
				else
				{
					var data:ByteArray = new ByteArray();
					data.endian = Endian.LITTLE_ENDIAN;
					data.writeByte(multi.multiple);
					data.writeByte(isFullStar?1:0);
					
					ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_DUNGEON_REWARD,data);
					return true;
				}
			}
			
			return false;
		}
		
		public function requestCancel():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeByte(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LEAVE_DUNGEON,data);
			
			reset();
		}
		/**翻牌*/
		public function cmDungeonCardDraw(postion:int):void
		{
			if(dtDgnRewardCard.ids[postion])
			{
				trace("DgnGoalsDataManager.cmDungeonCardDraw(postion) 位置："+postion+"已经被翻了");
				return;
			}
			if(!dtDgnRewardCard.isCountRemain)
			{
				Alert.warning(StringConst.DUNGEON_REWARD_CARD_TIP_0001);
				return;
			}
			if(!dtDgnRewardCard.isGoldEnough)
			{
				Alert.warning(StringConst.DUNGEON_REWARD_CARD_TIP_0002);
				return;
			}
			if(dtDgnRewardCard.isGoldNeed && !dtDgnRewardCard.isSelect)
			{
                Alert.show3(dtDgnRewardCard.goldTipText, sendData, postion, function (select:Boolean):void
				{
					dtDgnRewardCard.isSelect = select;
				},null,StringConst.DUNGEON_REWARD_CARD_TIP_0004);
				return;
			}
			sendData(postion);
			function sendData(postion:int):void
			{
				dtDgnRewardCard.postion = postion;
				var data:ByteArray = new ByteArray();
				data.endian = Endian.LITTLE_ENDIAN;
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DUNGEON_CARD_DRAW,data);
			}
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_BAG_FULL_SENDMAIL:
					resolveBagFullSendMail();
					break;
				case GameServiceConstants.SM_DUNGEON_STEP_PROGRESS:
					resolveStepProgress(data);
					break;
				case GameServiceConstants.SM_FINISH_DUNGEON:
					resolveFinish(data);
					break;
				case GameServiceConstants.CM_DUNGEON_CARD_DRAW:
					dealCmDungeonCardDraw(data);
					break;
				case GameServiceConstants.CM_ENTER_TASK_DUNGEON:
					_isEntering = false;
					break;
				case GameServiceConstants.ERR_ENTER_DUNGEON:
					_isEntering = false;
					break;
				default:
					break;
			}
			super.resolveData(proc,data);
		}
		
		private function resolveBagFullSendMail():void
		{
			Alert.message(StringConst.DGN_GOALS_027);
		}
		
		public function resolveStepProgress(data:ByteArray):void
		{
			_finishCode = -1;
			dungeonId = data.readInt();
			_step = data.readByte();
			var newTriggerId:int = data.readInt();
			_triggerCfg = ConfigDataManager.instance.dungeonEventCfgData(_dungeonId,newTriggerId);
			var endTime:int = data.readInt();
			
			_stepRemainSecond = endTime - ServerTime.time;
			if(_stepRemainSecond < 0)
			{
				_stepRemainSecond = 0
			}
			_stepStartTime = getTimer();
			
			var count:int = data.readByte();
			_waveDatas = [];
			for(var i:int = 0; i < count; ++i)
			{
				var wd:WaveData = new WaveData();
				wd.wave = data.readInt();
				wd.finish = data.readShort();
				wd.total = data.readShort();
				
				_waveDatas.push(wd);
			}
			
			
			if(newTriggerId != _triggerId)
			{
				_triggerId = newTriggerId;
			}
		}
		
		public function resolveFinish(data:ByteArray):void
		{
			_finishCode = data.readByte();
			_finishTime = data.readInt();
			dtDgnRewardCard.rewardGroupId = data.readInt();
			if(_dungeonCfg)
			{
				if(_dungeonCfg.func_type == DungeonConst.FUNC_TYPE_NORMAL)
				{
					if(dtDgnRewardCard.rewardGroupId > 0)
					{
						PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_REWARD_CARD);
					}
					else
					{
						PanelMediator.instance.switchPanel(PanelConst.TYPE_DUNGEON_REWARD);
					}
				}
				else if(_dungeonCfg.func_type == DungeonConst.FUNC_TYPE_SPECIAL_RING)
				{
					PanelMediator.instance.switchPanel(PanelConst.TYPE_DUNGEON_REWARD);
				}
			}
			AutoSystem.instance.startPickUpBeforeTask();
		}
		
		private function dealCmDungeonCardDraw(data:ByteArray):void
		{
			var id:int = data.readInt();//翻牌奖励组的序号
			dtDgnRewardCard.ids[dtDgnRewardCard.postion] = id;
			trace("DgnGoalsDataManager.dealCmDungeonCardDraw(data) postion:"+dtDgnRewardCard.postion+",id:"+id);
		}
		
		public function findRewardDataByStar(star:int):DgnRewardEvaluateCfgData
		{
			for each(var data:DgnRewardEvaluateCfgData in _starList)
			{
				if(data.star == star)
				{
					return data;
				}
			}
			
			return null;
		}
		
		public function set dungeonId(value:int):void
		{
			if(_dungeonId != value)
			{
				_dungeonId = value;	
				_dungeonCfg = ConfigDataManager.instance.dungeonCfgDataId(_dungeonId);
				
				var eventDict:Dictionary = ConfigDataManager.instance.dungeonEventCfgDataDict(_dungeonId);
				
				_totalTrigger = 0;
				for each(var eData:DgnEventCfgData in eventDict)
				{
					if(eData.step != 0)
					{
						++_totalTrigger;
					}
				}
				
				_startTime = getTimer();
				_remainSecond = _dungeonCfg.duration;
				
				_starList = new Vector.<DgnRewardEvaluateCfgData>;
				
				for(var i:int = 5; i > 0; --i)
				{
					try
					{
						var sd:DgnRewardEvaluateCfgData = 
							ConfigDataManager.instance.dungeonRewardEvaluateCfgData(_dungeonId,i);
						if(sd)
						{
							_starList.push(sd);
						}
					}
					catch(e:Error)
					{
						trace(e.message);
					}
				}
				
				_multipleList = [];
				
				var md:Dictionary =
					ConfigDataManager.instance.dungeonRewardMultipleCfgData(_dungeonId);
				
				for each(var multiple:DgnRewardMultipleCfgData in md)
				{
					_multipleList.push(multiple);
				}
				
				_multipleList.sortOn("multiple",Array.NUMERIC);
			}
		}
		
		//ui setter
		//---------------
		
		public function reset():void
		{
			_dungeonId = 0;
			_dungeonCfg = null;
			_step = 0;
			
			_step = 0;
			_triggerId = 0;
			_triggerCfg = null;
			_totalTrigger = 0;
			_waveDatas = null;//WaveData
			_starList = null;
			_multipleList = null;// DgnRewardMultipleCfgData;
			_finishCode = -1; // 1 成功  0 失败
			_finishTime = 0;
			
			_startTime = 0;
			_stepStartTime = 0;
			_stepRemainSecond  = 0;
			_remainSecond = 0;
			isFullStar = false;
			
			dtDgnRewardCard.reset();
		}
		
		public function findMultiple(index:int):DgnRewardMultipleCfgData
		{
			if(_multipleList && index >= 0 && index < _multipleList.length)
			{
				return _multipleList[index];
			}
			
			return null;
		}
		
		public function getBtnTxt(index:int):String
		{
			var re:String = "";
			var multi:DgnRewardMultipleCfgData = findMultiple(index);
			
			if(multi)
			{
				re = StringUtil.substitute(StringConst.DGN_GOALS_003,multi.multiple);
			}
			
			return re;
		}
		
		public function getBtnTip(index:int):String
		{
			var re:String = "";
			var multi:DgnRewardMultipleCfgData = findMultiple(index);
			if(multi)
			{
				if(multi.vip > 0)
				{
					re = StringUtil.substitute(StringConst.DGN_GOALS_004,multi.vip)+"\n";
				}
				var lvVip:int = VipDataManager.instance.lv;
				if(lvVip >= multi.vip)
				{
					if(multi.gold > 0)
					{
						re = StringUtil.substitute(StringConst.DGN_GOALS_005,multi.gold);
					}
					else if(multi.vip > 0 && multi.gold == 0)
					{
						re =StringConst.DGN_GOALS_006;
					}
				}
			}
			return re;
		}
		
		public function getFullStar():int
		{
			var star:int = 1;
			if(_dungeonCfg)
			{
				/*if(_dungeonCfg.content_type == DungeonConst.CONTENT_TYPE_HERO_UP)
				{
					star = 3;
				}
				else
				{*/
					star = 5;
				/*}*/
			}
			return star;
		}
		
		public var autoGoldCost:int;
		public function getAutoTxt():String
		{
			autoGoldCost = 0;
			if(_dungeonCfg)
			{
				var ev:DgnRewardEvaluateCfgData;
				var star:int;
				
				star = 5;
				
				var curStar:int = getRealStar();
				
				ev = findRewardDataByStar(curStar);
			
				if(ev)
				{
					autoGoldCost = ev.gold_cost;
					if(autoGoldCost==0)
						return "";
					return StringUtil.substitute(StringConst.DGN_GOALS_007,star,ev.gold_cost);
				}
			}
			return "";
		}
		
		/**
		 * @return {tip:"...",result:1}
		 */
		public function getAutoTip(selected:Boolean):Object
		{
			if(selected == false)
			{
				return {tip:StringConst.DGN_GOALS_008,result:1};
			}
			else
			{
				if(autoGoldCost > BagDataManager.instance.goldUnBind)
				{
					return {tip:StringConst.DGN_GOALS_009,result:0};
				}
				else
				{
					return {tip:StringUtil.substitute(StringConst.DGN_GOALS_010,autoGoldCost),result:1};
				}
			}
		}
		
		public function getStarTxt0():String
		{
			var star:int = getRealStar();
			var data:DgnRewardEvaluateCfgData = findRewardDataByStar(star);
			
			if(data)
			{
				var timeObj:Object = TimeUtils.calcTime(data.time);
				return TimeUtils.formatS(timeObj)+StringConst.DGN_GOALS_011;
			}
			
			return "";
		}
		
		public function getStarTxt1():String
		{
			var star:int = getRealStar();
			
			return star>0?star+StringConst.DGN_GOALS_012:"";
		}
		
		public function getStar():int
		{
			if(isFullStar)
			{
				return getFullStar();
			}
			
			return getRealStar();
		}
		
		public function getRealStar():int
		{
            var second:int = 0;
			
			if(_finishCode == -1)
			{
				second = (getTimer() - _startTime)/1000;
			}
			else
			{
				second = _finishTime;//防止误差
			}
			
			for each(var data:DgnRewardEvaluateCfgData in _starList)
			{
				if(second<=data.time)
				{
					return data.star;
				}
			}
			return 1;//最低
		}
		
		public function getStarTime():String
		{
			var star:int = getRealStar();
			
			var data:DgnRewardEvaluateCfgData = findRewardDataByStar(star);
			
			if(data)
			{
				var second:int = 0;
				if(_finishCode == -1)
				{
					second = (getTimer() - _startTime)/1000;
				}
				else
				{
					second = _finishTime;
				}
				var timeObj:Object =  TimeUtils.calcTime(data.time - second);
				return TimeUtils.formatClock(timeObj);
			}
			
			return "";
		}
		
		public function getStarTimeDec():Number
		{
			var star:int = getRealStar();
			
			var data:DgnRewardEvaluateCfgData = findRewardDataByStar(star);
			
			var preData:DgnRewardEvaluateCfgData;
			
			preData = findRewardDataByStar(star+1);
			
			if(data)
			{
				var second:int = 0;
				if(_finishCode == -1)
				{
					second = (getTimer() - _startTime)/1000;
				}
				else
				{
					second = _finishTime;
				}
				
				var re:Number = 0;
				if(preData)
				{
					re = (data.time - second) / (data.time - preData.time);
					if(re < 0)
					{
						re = 0;
					}
					return re;
				}
				else
				{
					re = (data.time - second) / data.time;
					if(re < 0)
					{
						re = 0;
					}
					return re;
				}
			}
			return 0;
		}
		
		//---------------
		public function getTitle():String
		{
			return _dungeonCfg ? _dungeonCfg.name : "";
		}
		
		public function getElapsedTimeStr():String
		{
			var timeObj:Object = TimeUtils.calcTime((getTimer() - _startTime)/1000);
			var timeStr:String = TimeUtils.formatClock(timeObj);
			//set
			return timeStr;
		}
		
		public function getStepTitle():String
		{
			return StringConst.DGN_GOALS_013+_step+"/"+_totalTrigger;
		}
		
		public function getStepDes():String
		{
			var des:String = CfgDataParse.pareseDes(_triggerCfg?_triggerCfg.step_desc:"").join("\n");
			return des;
		}
		
		public function getMapId(dungeonCfg:DungeonCfgData):int
		{
			var reg:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(dungeonCfg.region);
			
			return reg.map_id;
		}
		
		public function excuteStepTarget():void
		{
			if(!_triggerCfg)
				return ;
			
			var waveData:WaveData;
			for each(var data:WaveData in _waveDatas)
			{
				if(data.finish < data.total)
				{
					waveData = data;
					break;
				}
			}
			
			var mapId:int = getMapId(_dungeonCfg);
			var tType:int = _triggerCfg.trigger_type;
			if(tType == DungeonConst.TRIGGER_KILL_MULTI_M ||
				tType == DungeonConst.TRIGGER_KILL_SINGLE_M_LIMIT ||
				tType == DungeonConst.TRIGGER_KILL_SINGLE_RATE ||
				tType == DungeonConst.TRIGGER_KILL_SINGLE_RATE_LIMIT)
			{
				// "击杀";
				if(waveData)
				{
					var monsters:Array = ConfigDataManager.instance.mapMstCfgDataByWave(mapId,waveData.wave);
					
					if(monsters)
					{
						for each(var monster:MapMonsterCfgData in monsters)
						{
							/*AutoJobManager.getInstance().setAutoTargetData(monster.monster_group_id,EntityTypes.ET_MONSTER);*/
							AutoSystem.instance.setTarget(monster.monster_group_id,EntityTypes.ET_MONSTER);
							break;
						}
					}
				}
			}
			else if(tType == DungeonConst.TRIGGER_REGION)
			{
				//"到达";
				var regionId:int = parseInt(_triggerCfg.trigger_param);
				
				if(regionId>0)
				{
					AutoJobManager.getInstance().setAutoTargetData(regionId,EntityTypes.ET_REGION);
				}
			}
			else if(tType == DungeonConst.TRIGGER_COLLECT)
			{
				//"采集";
				if(waveData)
				{
					var plants:Array = ConfigDataManager.instance.mapPlantCfgDatasByWave(mapId,waveData.wave);
					
					if(plants)
					{
						for each(var plant:MapPlantCfgData in plants)
						{
							AutoJobManager.getInstance().setAutoTargetData(plant.plant_group_id,EntityTypes.ET_PLANT);
							break;
						}
					}
				}
			}
			else if(tType == DungeonConst.TRIGGER_ITEM)
			{
				//"需要物品";
			}
			else if(tType == DungeonConst.TRIGGER_TRAP_MULTI)
			{
				//"打开";
				
				if(waveData)
				{
					var traps:Array = ConfigDataManager.instance.mapTrapCfgDataByWave(mapId,waveData.wave);
					
					if(traps)
					{
						for each(var trap:MapTrapCfgData in traps)
						{
							AutoJobManager.getInstance().setAutoTargetData(trap.trap_group_id,EntityTypes.ET_TRAP);
							break;
						}
					}
				}
			}
			
		}
		
		public function getStepTarget():String
		{
			if(!_triggerCfg)
				return "";
			
			var progress:int = 0;
			var total:int = 0;
			
			for each(var data:WaveData in _waveDatas)
			{
				progress += data.finish;
				total += data.total;
			}
			
			var prefix:String = "";
			var tType:int = _triggerCfg.trigger_type;
			var eventType:int = _triggerCfg.event_type;
			var isShowProgress:Boolean = true;
			
			if(tType == DungeonConst.TRIGGER_KILL_MULTI_M ||
				tType == DungeonConst.TRIGGER_KILL_SINGLE_M_LIMIT)
			{
				prefix = StringConst.DGN_GOALS_014;
			}
			else if(tType == DungeonConst.TRIGGER_KILL_SINGLE_RATE ||
				tType == DungeonConst.TRIGGER_KILL_SINGLE_RATE_LIMIT)
			{
				prefix = StringConst.DGN_GOALS_024;
			}
			else if(tType == DungeonConst.TRIGGER_REGION)
			{
				prefix = StringConst.DGN_GOALS_015;
				isShowProgress = false;
			}
			else if(tType == DungeonConst.TRIGGER_COLLECT)
			{
				prefix = StringConst.DGN_GOALS_016;
			}
			else if(tType == DungeonConst.TRIGGER_ITEM)
			{
				prefix = StringConst.DGN_GOALS_017;
			}
			else if(tType == DungeonConst.TRIGGER_TRAP_MULTI)
			{
				prefix = StringConst.DGN_GOALS_025;
			}
			else if(tType == DungeonConst.TRIGGER_TIME)
			{
				if(eventType == DungeonConst.TRIGGER_EVENT_ADD_MONSTERS)
				{
					prefix = StringConst.DGN_GOALS_014;
					isShowProgress = false;
				}
			}
			
			
			var re:String = "";
			re += HtmlUtils.createHtmlStr(0xd4a460,prefix+StringConst.COLON);
			re += HtmlUtils.createHtmlStr(progress>=total ? 0x00ff00 : 0xff0000,_triggerCfg.target_desc,12,false,2,FontFamily.FONT_NAME,true);
			
			if(isShowProgress && total>0 && progress>=0)
			{
				re += HtmlUtils.createHtmlStr(progress>=total ? 0x00ff00 : 0xff0000,"("+progress+"/"+total+")");
			}
			
			return re;
		}
		
		public function getStepCountdownTimeStr():String
		{
			if(!_triggerCfg)
			{
				return "";
			}
			var time:int = _stepRemainSecond - (getTimer() - _stepStartTime)/1000;
			
			if(time <= 0)
			{
				return "";
			}
			
			var timeObj:Object = TimeUtils.calcTime(time);
			var timeStr:String = TimeUtils.format(timeObj);
			
			var prefix:String = StringConst.DGN_GOALS_019;
			if(_triggerCfg.trigger_type == DungeonConst.TRIGGER_TIME && _triggerCfg.event_type == DungeonConst.TRIGGER_EVENT_ADD_MONSTERS)
			{
				prefix = StringConst.DGN_GOALS_023;
			}
			
			return HtmlUtils.createHtmlStr(0xd4a460,prefix)+HtmlUtils.createHtmlStr(0x00ff00,timeStr);
		}
		
		public function getCountdownTimeStr():String
		{
			if(isFinish)
			{
				return "";
			}
			_remainSecond = _dungeonCfg ?  _dungeonCfg.duration : 0;
			var timeObj:Object = TimeUtils.calcTime(_remainSecond - (getTimer() - _startTime)/1000);
			var timeStr:String = TimeUtils.format(timeObj);
			
			return HtmlUtils.createHtmlStr(0xd4a460,StringConst.DGN_GOALS_020)+HtmlUtils.createHtmlStr(0xff6600,timeStr);
		}
		
		public function getCancelBtnTxt():String
		{
			return StringConst.DGN_GOALS_021;
		}
		
		public function requestTaskDungeon(taskId:int):void
		{
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
			if(!taskCfgData)
			{
				trace("DgnGoalsDataManager.requestTaskDungeon(taskId) 任务配置信息不存在");
				return;
			}
			var lv:int = RoleDataManager.instance.lv;
			if(lv < taskCfgData.level)
			{
				trace("DgnGoalsDataManager.requestTaskDungeon(taskId) 等级不足");
				return;
			}
			if(_isEntering)
			{
				trace("DgnGoalsDataManager.requestTaskDungeon(taskId) 正在进入副本中");
				return;
			}
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(taskId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_TASK_DUNGEON,data);
			_isEntering = true;
		}
		
		public function get boss_drop():String
		{
			var dungeonCfg:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(_dungeonId);
			if(!dungeonCfg)
			{
				return "";
			}
			var mapCfgData:MapCfgData = _dungeonCfg.mapCfgData;
			if(!mapCfgData)
			{
				return "";
			}
			return mapCfgData.boss_drop;
		}
	}
}

class WaveData
{
	public var wave:int;
	public var finish:int;
	public var total:int;
}

class PrivateClass{}