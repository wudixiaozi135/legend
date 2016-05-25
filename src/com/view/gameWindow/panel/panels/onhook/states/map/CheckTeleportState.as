package com.view.gameWindow.panel.panels.onhook.states.map
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AsFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	import flash.geom.Point;
	
	
	/**
	 * @author wqhk
	 * 2014-10-6
	 */
	public class CheckTeleportState implements IState
	{
		private var _teleportDataList:Array;
		private var _player:IPlayer;
		
		/**
		 * @param teleportDataList [MapTeleportCfgData,MapTeleportCfgData,...,Point];
		 */
		public function CheckTeleportState(teleportDataList:Array,player:IPlayer)
		{
			_teleportDataList = teleportDataList.concat();
			_player = player;
		}
		
		private function getMap(teleport:MapTeleportCfgData):int
		{
			var reg:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(teleport.region_to);
			
			return reg.map_id;
		}
		
		// 为了处理传送
		private function checkInRoad(curMapId:int,road:Array):int
		{
			for(var i:int = 0; i < road.length; ++i)
			{
				var node:* = road[i];
				if(node is Array)
				{
					if(curMapId == node[0])
					{
						return i;
					}
				}
				else if(node is MapTeleportCfgData)
				{
					if(MapTeleportCfgData(node).map_from == curMapId)
					{
						return i;
					}
				}
			}
			
			return -1;
		}
		
		// 为了处理传送
		private function clearRoad(index:int,road:Array):void
		{
			if(index>-1)
			{
				if(index != road.length-1)
				{
					road.splice(index+1,road.length - index - 1);
				}
			}
		}
		
		public function next(i:IIntention=null):IState
		{
			var data:* = null;
			if(!AutoFuncs.isAutoMove())
			{
				if(_teleportDataList.length == 0)
				{
					return new WaitingState();
				}
				else
				{
					var index:int = checkInRoad(AxFuncs.getCurMapId(),_teleportDataList);
					
					if(index == -1)
					{
						AutoFuncs.stopMap();
						return this;
					}
					else
					{
						clearRoad(index,_teleportDataList);
					}
					
					data = _teleportDataList[_teleportDataList.length - 1];
					
					if(data is Array)
					{
						var p:Point = new Point(data[1],data[2]);
						
						if(_player.tileDistance(p.x,p.y) == 0)
						{
							_teleportDataList.pop();
							return new WaitingState();
						}
						else
						{
							//有可能不能通过 特别是怪物  传的是刷新的中心点
							var newPos:Point = AxFuncs.getCanMoveLct(p.x,p.y);
							if(newPos)
							{
								p.x = newPos.x;
								p.y = newPos.y;
								AutoFuncs.move(_player, p.x, p.y, AutoJobManager.TO_TELEPORT_TILE_DIST);
							}
						}
					}
					else if(data is MapTeleportCfgData)
					{
						var t:MapTeleportCfgData = MapTeleportCfgData(data);
						
						if(t.map_from == AxFuncs.getCurMapId())
						{
							if(_player.tileDistance(t.x_from,t.y_from) == 0)
							{
								AsFuncs.sendSwitchMap(t.id);
								_teleportDataList.pop();
							}
							else
							{
								AutoFuncs.move(_player, t.x_from, t.y_from, AutoJobManager.TO_TELEPORT_TILE_DIST);
							}
						}
						else
						{
							// 出现传送了 直接停掉
							AutoFuncs.stopMap();
						}
					}
				}
			}
			else
			{
				data = _teleportDataList[_teleportDataList.length - 1];
				if(data is MapTeleportCfgData)
				{
					if(data.map_from != AxFuncs.getCurMapId())
					{
						// 出现传送了 直接停掉
						AutoFuncs.stopMap();
					}
				}
			}
			
			return this;
		}
	}
}