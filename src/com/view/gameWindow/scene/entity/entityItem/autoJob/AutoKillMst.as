package com.view.gameWindow.scene.entity.entityItem.autoJob
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.item.AutoTaskItem;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.ViewTile;
	import com.view.gameWindow.scene.entity.entityItem.Monster;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * 自动攻击怪物类
	 * @author Administrator
	 */	
	public class AutoKillMst
	{
		private var _mstGroupId:int;
		private var _sqrt:Number;
		private var _lastTileX:int,_lastTileY:int;
		private var _lastSearchTime:int,_searchOtherMstInternal:int = 3000;
		
		public function AutoKillMst()
		{
			_sqrt = Math.sqrt(Math.pow(ViewTile.W,2)+Math.pow(ViewTile.H,2));
		}
		
		internal function killingMst():void
		{
			if(!_mstGroupId)
			{
				return;
			}
			var checkRigor:Boolean = AutoJobManager.getInstance().checkRigor();
			if(checkRigor)
			{
				return;
			}
			var targetEntity:IEntity = AutoJobManager.getInstance().targetEntity;
			if(targetEntity)
			{
				return;
			}
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var inMapPath:Array = AutoJobManager.getInstance().inMapPath;
			if(inMapPath && inMapPath.length)
			{
				var pathTile:Point = inMapPath[inMapPath.length-1];
				var tileDistance:int = firstPlayer.tileDistance(pathTile.x, pathTile.y);
				/*trace("tileDistance:"+tileDistance+",_sqrt:"+_sqrt);*/
				if(tileDistance > _sqrt)
					return;
			}
			var autoTaskList:Vector.<AutoTaskItem> = TaskDataManager.instance.autoTaskList,autoTaskItem:AutoTaskItem;
			for each(autoTaskItem in autoTaskList)
			{
				if(autoTaskItem.click)
				{
					var state:int = TaskDataManager.instance.getTaskState(autoTaskItem.taskId);
					if(state == TaskStates.TS_CAN_SUBMIT)
					{
						autoTaskItem.click = false;
						reset();
						TaskDataManager.instance.doAutoTask();
						break;
					}
				}
			}
			var monsterDic:Dictionary,monster:Monster,minTileDistance:int,minMonster:Monster,monsterCfgData:MonsterCfgData;
			minTileDistance = int.MAX_VALUE;
			monsterDic = EntityLayerManager.getInstance().monsterDic;
			for each(monster in monsterDic)
			{
				monsterCfgData = ConfigDataManager.instance.monsterCfgData(monster.monsterId);
				if(monsterCfgData.group_id == _mstGroupId && monster.isShow && monster.hp > 0 && monster.viewBitmapExist)
				{
					tileDistance = firstPlayer.tileDistance(monster.tileX,monster.tileY);
					if(tileDistance <= 2)
					{
						minMonster = monster;
						break;
					}
					else if(tileDistance < minTileDistance)
					{
						minTileDistance = tileDistance;
						minMonster = monster;
					}
				}
			}
			if(minMonster)
			{
				AutoJobManager.getInstance().selectEntity = minMonster;
				AutoJobManager.getInstance().runToEntity(minMonster);
			}
			else
			{
				var nowSearchTime:int = getTimer();
				if(nowSearchTime - _lastSearchTime > _searchOtherMstInternal)
				{
					_lastSearchTime = nowSearchTime;
					var cfgDatas:Dictionary = ConfigDataManager.instance.mapMstCfgDatas(_mstGroupId);
					var mapId:int = SceneMapManager.getInstance().mapId;
					var mapMstfgData:MapMonsterCfgData;
					var tileX:int,tileY:int;
					for each(mapMstfgData in cfgDatas)
					{
						if(mapMstfgData.map_id == mapId)
						{
							tileX = (Math.random()*2-1)*mapMstfgData.h_radius+mapMstfgData.x;
							tileY = (Math.random()*2-1)*mapMstfgData.v_radius+mapMstfgData.y;
							var isLastLctNear:Boolean = isLastLctNear(tileX,tileY);
							if(!isLastLctNear)
							{
								_lastTileX = tileX;
								_lastTileY = tileY;
								AutoJobManager.getInstance().runTo(tileX, tileY, 0);
							}
						}
					}
				}
			}
		}
		/**判断上次寻路的点是否在附近*/
		private function isLastLctNear(tileX:int,tileY:int):Boolean
		{
			if(_lastTileX && _lastTileY)
			{
				var dx:int = _lastTileX - tileX;
				var dy:int = _lastTileX - tileY;
				var length:Number = Math.sqrt(dx*dx+dy*dy);
				if(length < _sqrt)
				{
					return true;
				}
			}
			return false;
		}
		
		internal function reset():void
		{
			_mstGroupId = 0;
			if(MainUiMediator.getInstance().autoSign)
			{
				MainUiMediator.getInstance().autoSign.hideFightEffect();
			}
		}
		
		internal function get mstGroupId():int
		{
			return _mstGroupId;
		}

		internal function set mstGroupId(value:int):void
		{
			_mstGroupId = value;
			MainUiMediator.getInstance().autoSign.showFightEffect();
		}
	}
}