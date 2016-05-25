package com.view.gameWindow.scene.entity.entityItem.autoJob
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.PlantCfgData;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.PlantStates;
	import com.view.gameWindow.scene.entity.constants.ViewTile;
	import com.view.gameWindow.scene.entity.entityItem.Plant;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * 自动采集物品类
	 * @author Administrator
	 */	
	public class AutoCollectPlant
	{
		private var _groupId:int;
		private var _sqrt:Number;
		
		public function AutoCollectPlant()
		{
			_sqrt = Math.sqrt(Math.pow(ViewTile.W,2)+Math.pow(ViewTile.H,2));
		}
		
		internal function collectPlant():void
		{
			if(!_groupId)
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
			//现在只有主线一个任务有采集先把这个去掉 。 在发送采集目标后就reset
//			var autoTaskList:Vector.<AutoTaskItem> = TaskDataManager.instance.autoTaskList,autoTaskItem:AutoTaskItem;
//			for each(autoTaskItem in autoTaskList)
//			{
//				if(autoTaskItem.click)
//				{
//					var state:int = TaskDataManager.instance.getTaskState(autoTaskItem.taskId);
//					if(state == TaskStates.TS_CAN_SUBMIT)
//					{
//						autoTaskItem.click = false;
//						reset();
//						break;
//					}
//				}
//			}
			var dic:Dictionary,plant:Plant,minTileDistance:int,minPlant:Plant,cfgData:PlantCfgData;
			minTileDistance = int.MAX_VALUE;
			dic = EntityLayerManager.getInstance().plantDic;
			for each(plant in dic)
			{
				cfgData = ConfigDataManager.instance.plantCfgData(plant.plantId);
				if(cfgData.group_id == _groupId && plant.isShow && plant.state == PlantStates.PS_IDLE && plant.viewBitmapExist)
				{
					tileDistance = firstPlayer.tileDistance(plant.tileX,plant.tileY);
					if(tileDistance <= AutoJobManager.TO_PLANT_TILE_DIST)
					{
						minPlant = plant;
						break;
					}
					else if(tileDistance < minTileDistance)
					{
						minTileDistance = tileDistance;
						minPlant = plant;
					}
				}
			}
			if(minPlant)
			{
				AutoJobManager.getInstance().selectEntity = minPlant;
				AutoJobManager.getInstance().runToEntity(minPlant);
				reset();
			}
		}
		
		internal function reset():void
		{
			_groupId = 0;
			if(MainUiMediator.getInstance().autoSign)
			{
				MainUiMediator.getInstance().autoSign.hideFightEffect();
			}
		}
		
		internal function get plantGroupId():int
		{
			return _groupId;
		}
		
		internal function set plantGroupId(value:int):void
		{
			_groupId = value;
			MainUiMediator.getInstance().autoSign.showFightEffect();
		}
	}
}