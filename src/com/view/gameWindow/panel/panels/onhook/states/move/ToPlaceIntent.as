package com.view.gameWindow.panel.panels.onhook.states.move
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.map.path.MapPathManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	import flash.geom.Point;
	
	
	/**
	 * @author wqhk
	 * 2014-9-28
	 */
	public class ToPlaceIntent implements IIntention
	{
		public var destination:Point;
		public var targetTileDist:int;
		public var entity:IPlayer;
		public var pkMode:Boolean;
		public function ToPlaceIntent()
		{
		}
		
		public function check(state:IState):IState
		{
//			if(!MapPathManager.getInstance().isWalkable(destination.x,destination.y, entity.cid, entity.sid))
//			{
//				trace("寻路的点不可通过："+destination.x+","+destination.y)
//				return new WaitingState();
//			}
//			
			var dis:int = entity.tileDistance(destination.x,destination.y);
			
			//需要寻路
//			if(dis>AutoJobManager.RUN_DIST)
//			if(dis > 1 && !AxFuncs.isPassRoad(entity.tileX,entity.tileY,destination.x,destination.y))
			if(dis > 0)
			{
				var mapId:int = SceneMapManager.getInstance().mapId;
				var mapConfig:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
				var mapRows:int = Math.floor(mapConfig.height/MapTileUtils.TILE_HEIGHT);
				var mapCols:int = Math.floor(mapConfig.width/MapTileUtils.TILE_WIDTH);
				
				var path:Array = AxFuncs.findPath(new Point(entity.tileX,entity.tileY), destination, 0, 0, mapCols, mapRows, targetTileDist);
				
				if(path)
				{
					trace("寻路");
					entity.targetPixelX = entity.pixelX;
					entity.targetPixelY = entity.pixelY;
					return new MovingState(path.concat(),entity,pkMode,pkMode); 
				}
				else
				{
					trace("找不到路径");
				}
			}
			//因为加上了 targetTileDist 所以直接走会有距离没判断
//			//直接走
//			else if(dis>0)
//			{
////				entity.targetPixelX = entity.pixelX;
////				entity.targetPixelY = entity.pixelY;
//				return new MovingState([destination],entity,pkMode,pkMode);
//			}
			
			return new WaitingState();
		}
	}
}