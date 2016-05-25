package com.view.gameWindow.panel.panels.task.item
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.PlantCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.configData.cfgdata.TrapCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskCondition;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.stateAlert.TaskAlert;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;

	public class TaskItem
	{
		private var _id:int;
		
		private var _elementId:int;
		private var _elementType:int;
		private var _needNum:int;
		private var _equipLv:int;//装备使用等级
		private var _equipRe:int//装备使用等级
		
		private var _currentNum:int;
		
		private var _progress:int;
		//玩家等级
		private var _needPlayerReincarn:int;
		private var _needPlayerLevel:int;
		//英雄等级
		private var _needHeroReincarn:int;
		private var _needHeroLevel:int;
		//押镖相关
		private var _arriveMapId:int;
		private var _arriveXTile:int;
		private var _arriveYTile:int;
		//强化
		private var _strengthenLv:int;
		
		private var taskAutoTraceHandle:uint;
		
		private var _state : int;
		/**
		 * 任务是否已经达到提交状态 
		 */		
		private var _completed:Boolean;
		private var _times:int;//叠加倍数
		
		public function get isCanShow():Boolean
		{
			var isTaskReincarnLevelEnough:Boolean = TaskDataManager.instance.isTaskReincarnLevelEnough(_id);
			var taskConfig:TaskCfgData = ConfigDataManager.instance.taskCfgData(_id);
			return isTaskReincarnLevelEnough || taskConfig.is_show;
		}
		
		public function TaskItem(id:int)
		{
			_id = id;
			_needPlayerLevel = 0;
			_times = 1;
		}
		
		
		public function init():void
		{
			_completed = false;
			
			var configData:TaskCfgData = ConfigDataManager.instance.taskCfgData(_id);
			if(!configData)
			{
				return;
			}
			var condition:int = configData.condition;
			var requests:Array = configData.request.split(":");
			switch (condition)
			{
				case TaskCondition.TC_RECEIVE:
					_completed = true;
					break;
				
				case TaskCondition.TC_ITEM:
					if (requests.length == 3)
					{
						_elementId = parseInt(requests[0]);//item id
						_elementType = parseInt(requests[1]);//物品的类型
						_needNum = parseInt(requests[2]);//item count
					}
					break;
				
				case TaskCondition.TC_COST_ITEM:
					if (requests.length == 1)
					{
						_elementId = parseInt(requests[0]); //item id
						_needNum = 0;
					}
					break;
				
				case TaskCondition.TC_MONSTER_GROUP:
					if (requests.length == 2)
					{
						_elementId = parseInt(requests[0]);//monster id
						_needNum = parseInt(requests[1]);//monster count
					}
					break;
				case TaskCondition.TC_MONSTER_LEVEL:
					if (requests.length == 2)
					{
						_elementId = parseInt(requests[0]);//monster level
						_needNum = parseInt(requests[1]);//monster count
					}
					break;
				case TaskCondition.TC_PLAYER_LEVEL:
					if (requests.length == 2)
					{
						_needPlayerReincarn = parseInt(requests[0]);
						_needPlayerLevel = parseInt(requests[1]); //player level
						_needNum = 1;
					}
					break;
				case TaskCondition.TC_HERO_LEVEL:
					if (requests.length == 2)
					{
						_needHeroReincarn = parseInt(requests[0]);
						_needHeroLevel = parseInt(requests[1]); //player level
						_needNum = 1;
					}
					break;
				case TaskCondition.TC_MONSTER_RANDOM:
					if (requests.length == 3)
					{
						_elementId = parseInt(requests[0]);//monster id
						_needNum = parseInt(requests[1]);//monster count
					}
					break;
				case TaskCondition.TC_PROTECT_CLIENT:
					if (requests.length == 3)
					{
						_arriveMapId = parseInt(requests[0]);
						_arriveXTile = parseInt(requests[1]);
						_arriveYTile = parseInt(requests[2]);
					}
					break;
				case TaskCondition.TC_PLANT_ID:
					if (requests.length == 2)
					{
						_elementId = parseInt(requests[0]);//plant id
						_needNum = parseInt(requests[1]);//plant count
					}
					break;
				case TaskCondition.TC_DUNGEON:
					if(requests.length == 2)
					{
						_elementId = parseInt(requests[0]);//dungeon id
						_needNum = parseInt(requests[1]);//dungeon count
					}
					break;
				case TaskCondition.TC_MINING:
					if(requests.length == 2)
					{
						_elementId = parseInt(requests[0]);//区域 id
						_needNum = parseInt(requests[1]);// count
					}
					break;
				case TaskCondition.TC_DIG:
					if(requests.length == 2)
					{
						_elementId = parseInt(requests[0]);//group id
						_needNum = parseInt(requests[1]);// count
					}
					break;
				case TaskCondition.TC_STAR_TASK:
					if(requests.length == 1)
					{
						_needNum = parseInt(requests[0]);// count
					}
					break;
				case TaskCondition.TC_ENTER_DUNGEON:
					if(requests.length == 2)
					{
						_elementId = parseInt(requests[0]);//DUNGEON id
						_needNum = parseInt(requests[1]);// count
					}
					break;
				case TaskCondition.TC_REWARD_TASK:
					if(requests.length == 1)
					{
						_needNum = parseInt(requests[0]);// count
					}
					break;
				case TaskCondition.TC_EQUIP_RECYCLE:
					if(requests.length == 1)
					{
						_needNum = parseInt(requests[0]);// count
					}
					break;
				case TaskCondition.TC_EQUIP_WEAR:
				case TaskCondition.TC_EQUIP_WEAR_HERO:
				case TaskCondition.TC_EQUIP_GET:
					if(requests.length == 3)
					{
						_equipRe = parseInt(requests[0]);
						_equipLv = parseInt(requests[1]);
						_needNum = parseInt(requests[2]);// count
					}
					break;
				case TaskCondition.TC_KILL_PLAYER:
					if(requests.length == 3)
					{
						_needPlayerReincarn = parseInt(requests[0]);
						_needPlayerLevel = parseInt(requests[1]); //player level
						_needNum = parseInt(requests[2]);
					}
					break;
				case TaskCondition.TC_PLAYER_STRENGTHEN:
				case TaskCondition.TC_HERO_STRENGTHEN:
					if(requests.length == 2)
					{
						_strengthenLv = parseInt(requests[0]);
						_needNum = parseInt(requests[1]);
					}
					break;
				default:
					break;
			}
			_currentNum = 0;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get currentNum():int
		{
			return _currentNum;
		}
		
		public function set currentNum(num:int):void
		{
			_currentNum = num;
		}
		
		public function get needNum():int
		{
			return _needNum * _times;
		}
		
		public function set needNum(num:int):void
		{
			_needNum = num;
		}
		
		public function get times():int
		{
			return _times;
		}
		
		public function set times(value:int):void
		{
			_times = value;
		}
		
		public function setProgressCount(count:int):void
		{
			_progress = count;
			
			refresh(true);
		}
		
		public function getProgressCount():int
		{
			return _progress;
		}
		
		public function refresh(showAlert:Boolean):void
		{
			var configData:TaskCfgData = ConfigDataManager.instance.taskCfgData(_id);
			if(!configData)
			{
				return;
			}
			var condition:int = configData.condition;
			var oldstate:Boolean = _completed;
			var self:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var tile:Point,templeNum:int;
			switch (condition)
			{
				case TaskCondition.TC_RECEIVE:
					break;
				case TaskCondition.TC_ITEM:
					dealItem();
					break;
				case TaskCondition.TC_COST_ITEM:
					dealCostItem();
					break;
				case TaskCondition.TC_MONSTER_GROUP:
					dealMstGroup(showAlert);
					break;
				case TaskCondition.TC_MONSTER_LEVEL:
					dealMstLv();
					break;
				case TaskCondition.TC_PLAYER_LEVEL:
					dealPlayerLv();
					break;
				case TaskCondition.TC_HERO_LEVEL:
					dealHeroLv();
					break;
				case TaskCondition.TC_MONSTER_RANDOM:
					dealMstRandom(showAlert);
					break;
				case TaskCondition.TC_PLANT_ID:
					dealPlant(showAlert);
					break;
				case TaskCondition.TC_DUNGEON:
					dealDungeon(showAlert);
					break;
				case TaskCondition.TC_MINING:
					dealMining(showAlert);
					break;
				case TaskCondition.TC_DIG:
					dealDig(showAlert);
					break;
				case TaskCondition.TC_STAR_TASK:
					dealStarTask(showAlert);
					break;
				case TaskCondition.TC_ENTER_DUNGEON:
					dealEnterDungeon(showAlert);
					break;
				case TaskCondition.TC_REWARD_TASK:
					dealRewardTask(showAlert);
					break;
				case TaskCondition.TC_EQUIP_RECYCLE:
					dealEquipRecycle(showAlert);
					break;
				case TaskCondition.TC_EQUIP_WEAR:
				case TaskCondition.TC_EQUIP_WEAR_HERO:
					dealEquipWearLv(showAlert);
					break;
				case TaskCondition.TC_EQUIP_GET:
					dealEquipWearLv(showAlert,false);
					break;
				case TaskCondition.TC_KILL_PLAYER:
					dealKillPlayer(showAlert);
					break;
				case TaskCondition.TC_PLAYER_STRENGTHEN:
				case TaskCondition.TC_HERO_STRENGTHEN:
					dealStrengthen(showAlert);
					break;
				default:
					break;
			}
			
			if(_completed && !oldstate) //任务变为可交时的判断
			{
//				GuideManager.getInstance().updateTaskState(_id, TaskStates.TS_CAN_SUBMIT);
				var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(_id);
				if(/*!ConfigDataManager.instance.mapInitPeriod && */MainUiMediator.getInstance().taskTrace && TaskDataManager.instance.autoTask)
				{
					clearTimeout(taskAutoTraceHandle);
					taskAutoTraceHandle = setTimeout(taskAutoTraceFunc,500,_id);
				}
				
				if (taskCfg.complete_alert)
				{
					
					TaskAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(taskCfg.complete_alert,0xfef5e3,3,24));
					trace("任务完成提示文字");
				}
			}
		}
		
		private function dealStrengthen(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				/*if (_progress > 0 && _progress <= needNum && showAlert)
				{
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,monsterConfig.name + " " + _progress + "/" + needNum);
				}*/
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
			else
			{
				_completed = false;
			}
		}
		
		private function dealItem():void
		{
			/*var nItem:int = ArticlesPanelDataManager.getInstance().getArticleNum(_elementId, _elementType,7);
			if (nItem != _currentNum && nItem <= needNum && showAlert)
			{
				var itemConfig:ItemConfigData = ConfigDataManager.instance.itemConfig[_elementId];
				if (itemConfig && nItem > 0 && nItem <= needNum)
				{
					HorizontalAlert.getInstance().showMSG(itemConfig.name + " " + nItem + "/" + needNum, 0xffffff);
				}
			}
			_currentNum = nItem > needNum ? needNum : nItem;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
			else
			{
				_completed = false;
			}*/
		}
		
		private function dealCostItem():void
		{
			/*if (ArticlesPanelDataManager.getInstance().getArticleNum(_elementId, ArticleTypes.TYPE_ITEM,7) <= needNum)
			{
				_completed = true;
			}
			else
			{
				_completed = false;
			}*/
		}
		
		private function dealMstGroup(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				var monsterCfgDatas:Dictionary = ConfigDataManager.instance.monsterCfgDatas(_elementId);
				var monsterConfig:MonsterCfgData;
				for each(monsterConfig in monsterCfgDatas)
				{
					if (monsterConfig && _progress > 0 && _progress <= needNum && showAlert)
					{
						RollTipMediator.instance.showRollTip(RollTipType.PLACARD,monsterConfig.name + " " + _progress + "/" + needNum);
					}
					break;
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealMstLv():void
		{
			/*if (_nMonster > _currentNum && _nMonster <= needNum)
			{
				if (_nMonster > 0 && _nMonster <= needNum && showAlert)
				{
					HorizontalAlert.getInstance().showMSG(_elementId + InternationalConstants.getGameString(10206) + " " + _nMonster + "/" + needNum, 0xffffff);
				}
			}
			_currentNum = _nMonster > needNum ? needNum : _nMonster;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}*/
		}
		
		private function dealPlayerLv():void
		{
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(_needPlayerReincarn,_needPlayerLevel);
			if (checkReincarnLevel)
			{
				_completed = true;
			}
		}
		
		private function dealHeroLv():void
		{
			var checkReincarnLevel:Boolean = HeroDataManager.instance.checkReincarnLevel(_needHeroReincarn,_needHeroLevel);
			if (checkReincarnLevel)
			{
				_completed = true;
			}
		}
		
		private function dealMstRandom(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				var monsterCfgDatas:Dictionary = ConfigDataManager.instance.monsterCfgDatas(_elementId);
				var monsterConfig:MonsterCfgData;
				for each(monsterConfig in monsterCfgDatas)
				{
					if (monsterConfig && _progress > 0 && _progress <= needNum && showAlert)
					{
						var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(_id);
						var linkText:LinkText = new LinkText();
						linkText.init(taskCfgData.pre_hint);
						var textField:TextField = new TextField();
						textField.htmlText = linkText.htmlText;
						RollTipMediator.instance.showRollTip(RollTipType.PLACARD,textField.text + " " + _progress + "/" + needNum);
					}
					break;
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealPlant(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				var plantConfig:PlantCfgData = ConfigDataManager.instance.plantCfgData(_elementId);
				if (plantConfig && _progress > 0 && _progress <= needNum && showAlert)
				{
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,plantConfig.name + " " + _progress + "/" + needNum);
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealDungeon(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				var dungeonCfg:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(_elementId);
				if (dungeonCfg && _progress > 0 && _progress <= needNum && showAlert)
				{
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,StringConst.TRANS_PANEL_0022 + dungeonCfg.name + " " + _progress + "/" + needNum);
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealMining(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				var trapCfgDt:TrapCfgData = ConfigDataManager.instance.trapCfgData(_elementId);
				var regionCfgDt:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(_elementId);
				if ((trapCfgDt || regionCfgDt) && _progress > 0 && _progress <= needNum && showAlert)
				{
					var name:String = trapCfgDt ? trapCfgDt.name : (regionCfgDt ? regionCfgDt.name : "");
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,name + " " + _progress + "/" + needNum);
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealDig(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				var monsterCfgDatas:Dictionary = ConfigDataManager.instance.monsterCfgDatas(_elementId);
				var cfgDt:MonsterCfgData;
				for each(cfgDt in monsterCfgDatas)
				{
					if (cfgDt && _progress > 0 && _progress <= needNum && showAlert)
					{
						RollTipMediator.instance.showRollTip(RollTipType.PLACARD,cfgDt.name + " " + _progress + "/" + needNum);
					}
					break;
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealStarTask(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				if (_progress > 0 && _progress <= needNum && showAlert)
				{
					var string:String = StringConst.TASK_0016 + TaskTypes.taskTitleName(TaskTypes.TT_MINING) + " " + _progress + "/" + needNum;
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,string);
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealEnterDungeon(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				var dungeonCfg:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(_elementId);
				if (dungeonCfg && _progress > 0 && _progress <= needNum && showAlert)
				{
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,StringConst.TRANS_PANEL_0016 + dungeonCfg.name + " " + _progress + "/" + needNum);
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealRewardTask(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				if (_progress > 0 && _progress <= needNum && showAlert)
				{
					var string:String = StringConst.TASK_0016 + TaskTypes.taskTitleName(TaskTypes.TT_REWARD) + " " + _progress + "/" + needNum;
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,string);
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealKillPlayer(showAlert:Boolean):void
		{
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealEquipWearLv(showAlert:Boolean,isWear:Boolean = true):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				if (_progress > 0 && _progress <= needNum && showAlert)
				{
					var string:String = StringUtil.substitute(isWear ? StringConst.EQUIP_WEAR : StringConst.EQUIP_GET,
							_equipRe > 0 ? _equipRe + StringConst.REINCARN + _equipLv : _equipLv, _progress + "/" + needNum);
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,string);
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function dealEquipRecycle(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				if (_progress > 0 && _progress <= needNum && showAlert)
				{
					var string:String = StringConst.RECYCLE_EQUIP_PANEL_0035 + " " + _progress + "/" + needNum;
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,string);
				}
			}
			_currentNum = _progress > needNum ? needNum : _progress;
			if (_currentNum >= needNum)
			{
				_completed = true;
			}
		}
		
		private function taskAutoTraceFunc(tid:int):void
		{
			clearTimeout(taskAutoTraceHandle);
			TaskDataManager.instance.taskAutoTrace(tid,true);
		}
		
		public function get completed():Boolean
		{
			return _completed;
		}
		
		public function setCompleted(value:Boolean, isShowAlert:Boolean):void
		{
			/*var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(_id);
			if(!taskCfg)
			{
				return;
			}
			if (!_completed && value && isShowAlert)
			{
				if (taskCfg.completeAlert)
				{
					TaskAlert.getInstance().showMSG(taskCfg.completeAlert);
				}
			}
			if (taskCfg.condition == TaskCondition.TC_PROTECT_CLIENT)
			{
				SceneManager.getInstance().removeSimulateDartCar();
			}
			
			if(taskCfg.condition != TaskCondition.TC_RECEIVE)
			{
				_completed = value;
			}*/
		}
		
		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			_state = value;
		}

		public function get elementId():int
		{
			return _elementId;
		}

	}
}