package com.view.gameWindow.panel.panels.specialRing.upgrade
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.PlantCfgData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskCondition;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UtilGetStrLv;
	
	import flash.utils.Dictionary;

	public class RingCondition
	{
		private var _ringId:int;
		
		private var _condition:int;
		
		private var _elementId:int;
		private var _elementType:int;
		private var _needNum:int;
		
		private var _currentNum:int;
		
		private var _progress:int;
		//押镖相关
		private var _arriveMapId:int;
		private var _arriveXTile:int;
		private var _arriveYTile:int;
		//特戒相关
		private var _speciaId:int;
		
		/**
		 * 任务是否已经达到提交状态 
		 */		
		private var _completed:Boolean;
		
		public function RingCondition()
		{
			
		}
		
		public function init(ringId:int,condition:int,request:String):void
		{
			_ringId = ringId;
			_completed = false;
			
			_condition = condition;
			var requests:Array = request.split(":");
			
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
						_elementType = parseInt(requests[0]);//player reincarn
						_needNum = parseInt(requests[1]); //player level
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
				case TaskCondition.TC_SPECIAL_LEVEL:
					if(requests.length==2)
					{
						_elementId = parseInt(requests[0]);//SPECIAL id
						_needNum = parseInt(requests[1]);//SPECIAL level
					}
					break;
				case TaskCondition.TC_VIP_LEVEL:
					if(requests.length==1)
					{
						_needNum = parseInt(requests[0]);
					}
					break;
				case TaskCondition.TC_COUNT_GOLD:
					if(requests.length==1)
					{
						_needNum = parseInt(requests[0]);//
					}
					break;
				case TaskCondition.TC_LOGIN_DAY:
					if(requests.length==1)
					{
						_needNum = parseInt(requests[0]);//
					}
					break;
				case TaskCondition.TC_TASK_COMPLE:
					if(requests.length==2)
					{
						_elementId = parseInt(requests[0]);
						_needNum = parseInt(requests[1]);
					}
					break;
				case TaskCondition.TC_NO_COMPLE:
					if(requests.length==2)
					{
						_elementId = parseInt(requests[0]);
						_needNum = parseInt(requests[1]);
					}
					break;
				default:
					break;
			}
			_currentNum = 0;
		}
		
		public function setProgressCount(count:int):void
		{
			_progress = count;
			
			refresh(true);
		}
		
		public function refresh(showAlert:Boolean):void
		{
			switch (_condition)
			{
				case TaskCondition.TC_RECEIVE:
					break;
				case TaskCondition.TC_ITEM:
					dealItem(showAlert);
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
				case TaskCondition.TC_MONSTER_RANDOM:
					dealMstRandom(showAlert);
					break;
				case TaskCondition.TC_PLANT_ID:
					dealPlant(showAlert);
					break;
				case TaskCondition.TC_DUNGEON:
					dealDungeon(showAlert);
					break;
				case TaskCondition.TC_SPECIAL_LEVEL:
					dealSpecial(showAlert);
					break;
				case TaskCondition.TC_VIP_LEVEL:
					_progress=VipDataManager.instance.lv;
					dealVIPLevel(showAlert);
					break;
				case TaskCondition.TC_COUNT_GOLD:
					_progress=RoleDataManager.instance.recGoldCount;
					dealAllCommon(showAlert);
					break;
				case TaskCondition.TC_LOGIN_DAY:
					_progress=RoleDataManager.instance.loginCount;
					dealAllCommon(showAlert);
					break;
				case TaskCondition.TC_TASK_COMPLE:
					dealAllCommon(showAlert);
					break;
				case TaskCondition.TC_NO_COMPLE:
					dealAllCommon(showAlert);
					break;
				default:
					break;
			}
		}
		
		private function dealItem(showAlert:Boolean):void
		{
			var nItem:int = BagDataManager.instance.getItemNumById(_elementId);
			if (nItem != _currentNum && nItem <= needNum && showAlert)
			{
				var itemConfig:ItemCfgData = ConfigDataManager.instance.itemCfgData(_elementId);
				if (itemConfig && nItem > 0 && nItem <= needNum && showAlert)
				{
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,itemConfig.name + " " + nItem + "/" + needNum);
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
			}
		}
		
		private function dealCostItem():void
		{
			/*ArticlesPanelDataManager.getInstance().getArticleNum(_elementId, ArticleTypes.TYPE_ITEM,7);*/
			_currentNum = BagDataManager.instance.getItemNumById(_elementId);
			if(_currentNum <= needNum)
			{
				_completed = true;
			}
			else
			{
				_completed = false;
			}
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
			else
			{
				_completed = false;
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
			}
			else
			{
				_completed = false;
			}*/
		}
		
		private function dealPlayerLv():void
		{
			var reincarn:int = RoleDataManager.instance.reincarn;
			_currentNum = RoleDataManager.instance.lv;
			if(reincarn > _elementType || (reincarn == _elementType && _currentNum >= needNum))
			{
				_completed = true;
			}
			else
			{
				_completed = false;
			}
		}
		
		private function dealMstRandom(showAlert:Boolean):void
		{
			if (_progress > _currentNum && _progress <= needNum)
			{
				/*if(_pre_hint && _progress > 0 && _progress <= needNum && showAlert)
				{
					var linkText:LinkText = new LinkText();
					linkText.init(_pre_hint);
					var textField:TextField = new TextField();
					textField.htmlText = linkText.htmlText;
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,textField.text + " " + _progress + "/" + needNum);
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
			else
			{
				_completed = false;
			}
		}
		
		private function dealDungeon(showAlert:Boolean):void
		{
			var arr:Array= SpecialRingDataManager.instance.ringDgnData;
			for each(var paras:Array in arr)
			{
				if(paras[0]==_ringId&&paras[1]==_condition&&paras[2]==_elementId)
				{
					_progress=paras[3];
					break;
				}
			}

			if (_progress > _currentNum && _progress <= needNum)
			{
				var dungeonCfg:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(_elementId);
				if (dungeonCfg && _progress > 0 && _progress <= needNum && showAlert)
				{
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,dungeonCfg.name + " " + _progress + "/" + needNum);
				}
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
		
		private function dealSpecial(showAlert:Boolean):void
		{
//			if (_progress > _currentNum && _progress <= needNum)
//			{
//				var speciaCfg:SpecialRingCfgData = ConfigDataManager.instance.specialRingCfgData(_elementId);
//				if (speciaCfg && _progress > 0 && _progress <= needNum && showAlert)
//				{
//					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,speciaCfg.name + " " + _progress + "/" + needNum);
//				}
//			}
			
			_progress=SpecialRingDataManager.instance.getDataById(_elementId).level;
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
		
		private function dealVIPLevel(showAlert:Boolean):void
		{
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
		
		private function dealAllCommon(showAlert:Boolean):void
		{
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
			}
			else
			{
				_completed = false;
			}*/
		}
		
		public function get currentNum():int
		{
			return _currentNum;
		}
		
		public function get needNum():int
		{
			return _needNum;
		}
		
		public function get currentLvStr():String
		{
			var reincarn:int = RoleDataManager.instance.reincarn;
			var lv:int = RoleDataManager.instance.lv;
			var strReincarnLevel:String = UtilGetStrLv.strReincarnLevel(reincarn,lv);
			return strReincarnLevel;
		}
		
		public function get needLvStr():String
		{
			var strReincarnLevel:String = UtilGetStrLv.strReincarnLevel(_elementType,_needNum);
			return strReincarnLevel;
		}

		public function get condition():int
		{
			return _condition;
		}

	}
}