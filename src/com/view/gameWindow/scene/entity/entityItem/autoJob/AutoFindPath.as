package com.view.gameWindow.scene.entity.entityItem.autoJob
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.configData.cfgdata.MapPlantCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.model.configData.cfgdata.MapTrapCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * 自动寻路类
	 * @author Administrator
	 */	
	public class AutoFindPath
	{
		private var _targetId:int;
		private var _targetType:int;
		private var _targetPos:Point;
		private var _targetMapId:int;
		private var _targetTileDist:int;//允许离目标点的距离算到达
		
		private var _targetNode:Node;
		
		public function AutoFindPath()
		{
		}
		
		internal function gotoAutoTarget():void
		{
			if(_targetPos && _targetMapId)
			{
				gotoPostion();
				return;
			}
			if(!_targetId)
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
			var cfgDatas:Dictionary;
			var tileX:int,tileY:int;
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(_targetType == EntityTypes.ET_NPC)
			{
				var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(_targetId);
				if(npcCfgData.mapid == mapId)//该npc在当前地图
				{
					var entity:IEntity = EntityLayerManager.getInstance().getEntity(_targetType,_targetId);
					if(entity && entity.isShow && entity.selectable/* && entity.viewBitmapExist*/)//已能获取到自动目标实体//NPC不管是否加载完成都弹出面板
					{
						AutoJobManager.getInstance().selectEntity = entity;
						AutoJobManager.getInstance().runToEntity(entity);
						reset();
					}
					else
					{
						AutoJobManager.getInstance().runTo(npcCfgData.x, npcCfgData.y, AutoJobManager.TO_NPC_TILE_DIST);
					}
				}
				else
				{
					searchTlpt(mapId,npcCfgData.mapid);
				}
			}
			else if(_targetType == EntityTypes.ET_TELEPORTER)
			{
				var tptCfgData:MapTeleportCfgData = ConfigDataManager.instance.mapTeleporterCfgData(_targetId);
				if(tptCfgData.map_from == mapId)//该传送点在当前地图
				{
					entity = EntityLayerManager.getInstance().getEntity(_targetType,_targetId);
					if(entity && entity.isShow && entity.selectable && entity.viewBitmapExist)//已能获取到自动目标实体
					{
						AutoJobManager.getInstance().selectEntity = entity;
						AutoJobManager.getInstance().runToEntity(entity);
						reset();
					}
					else
					{
						AutoJobManager.getInstance().runTo(tptCfgData.x_from,tptCfgData.y_from, AutoJobManager.TO_TELEPORT_TILE_DIST);
					}
				}
				else
				{
					searchTlpt(mapId,tptCfgData.map_from);
				}
			}
			else if(_targetType == EntityTypes.ET_TRAP)
			{
				cfgDatas = ConfigDataManager.instance.mapTrapCfgDatas(_targetId);
				var mapTrapCfgData:MapTrapCfgData;
				for each(mapTrapCfgData in cfgDatas)
				{
					if(mapTrapCfgData.map_id == mapId)
					{
						/*destroyEffect();
						tileX = (Math.random()*2-1)*mapTrapCfgData.h_radius+mapTrapCfgData.x;
						tileY = (Math.random()*2-1)*mapTrapCfgData.v_radius+mapTrapCfgData.y;
						AutoJobManager.getInstance().runTo(tileX,tileY);
						AutoJobManager.getInstance().setAutoCollectPlantId(_targetId);//必须修改
						reset();*/
						entity = EntityLayerManager.getInstance().getEntity(_targetType,_targetId);
						if(entity && entity.isShow && entity.selectable && entity.viewBitmapExist)//已能获取到自动目标实体
						{
							AutoJobManager.getInstance().selectEntity = entity;
							AutoJobManager.getInstance().runToEntity(entity);
							reset();
						}
						else
						{
							AutoJobManager.getInstance().runTo(mapTrapCfgData.x, mapTrapCfgData.y, AutoJobManager.TO_TRAP_TILE_DIST);
						}
						break;
					}
					else
					{
						searchTlpt(mapId,mapTrapCfgData.map_id);
					}
				}
			}
			else if(_targetType == EntityTypes.ET_MONSTER)
			{
				cfgDatas = ConfigDataManager.instance.mapMstCfgDatas(_targetId);
				var mapMstfgData:MapMonsterCfgData;
				for each(mapMstfgData in cfgDatas)
				{
					if(mapMstfgData.map_id == mapId)
					{
						destroyEffect();
						tileX = (Math.random()*2-1)*mapMstfgData.h_radius+mapMstfgData.x;
						tileY = (Math.random()*2-1)*mapMstfgData.v_radius+mapMstfgData.y;
						AutoJobManager.getInstance().runTo(tileX, tileY , 0);
						AutoJobManager.getInstance().setAutoKillMstId(_targetId);
						_targetX = tileX;
						_targetY = tileY;
						reset();
						break;
					}
					else
					{
						searchTlpt(mapId,mapMstfgData.map_id);
					}
				}
			}
			else if(_targetType == EntityTypes.ET_PLANT)
			{
				cfgDatas = ConfigDataManager.instance.mapPlantCfgDatas(_targetId);
				var mapPlantCfgData:MapPlantCfgData;
				for each(mapPlantCfgData in cfgDatas)
				{
					if(mapPlantCfgData.map_id == mapId)
					{
						destroyEffect();
						tileX = (Math.random()*2-1)*mapPlantCfgData.h_radius/4+mapPlantCfgData.x; //    /4 缩小范围 防止寻不到
						tileY = (Math.random()*2-1)*mapPlantCfgData.v_radius/4+mapPlantCfgData.y;
						AutoJobManager.getInstance().runTo(tileX, tileY, 0);
						AutoJobManager.getInstance().setAutoCollectPlantId(_targetId);
						_targetX = tileX;
						_targetY = tileY;
						reset();
						break;
					}
					else
					{
						searchTlpt(mapId,mapPlantCfgData.map_id);
					}
				}
			}
			else if(_targetType == EntityTypes.ET_REGION)
			{
				var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(_targetId);
				if(mapRegionCfgData.map_id == mapId)
				{
					tileX = Math.random()*mapRegionCfgData.x_max+mapRegionCfgData.x_min;
					tileY = Math.random()*mapRegionCfgData.y_max+mapRegionCfgData.y_min;
					AutoJobManager.getInstance().runTo(tileX, tileY, 0);
					_targetX = tileX;
					_targetY = tileY;
					reset();
				}
				else
				{
					searchTlpt(mapId,mapRegionCfgData.map_id);
				}
			}
		}
		
		private var _targetX:int = -1;
		private var _targetY:int = -1;
		
		public function checkFlagShow():void
		{
			if(_targetX != -1 && _targetY != -1)
			{
				var fp:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				
				if(fp && _targetX == fp.tileX && _targetY == fp.tileY)
				{
					destroyEffect();
					_targetX = -1;
					_targetY = -1;
				}
			}
		}
		
		private function gotoPostion():void
		{
			var tileX:int,tileY:int;
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(_targetMapId == mapId)
			{
				tileX = _targetPos.x;
				tileY = _targetPos.y;
				_targetX = tileX;
				_targetY = tileY;
				var needRun:Boolean = AutoJobManager.getInstance().runTo(tileX, tileY, _targetTileDist);
				if(!needRun)
				{
					destroyEffect();
				}
				reset();
			}
			else
			{
				searchTlpt(mapId,_targetMapId);
			}
		}
		/**
		 * 搜索当前地图通向目标地图的传送点路径
		 */
		private function searchTlpt(crntMapId:int,tgtMapId:int):void
		{
			_targetX = -1;
			_targetY = -1;
			if(_targetNode)
			{
				var mapTeleporterCfgData:MapTeleportCfgData,entity:IEntity;
				var	nodeTemp:Node = _targetNode;
				while(nodeTemp && nodeTemp.connection && nodeTemp.mapTeleporterCfgData.map_from != crntMapId)
				{
					nodeTemp = nodeTemp.connection;
				}
				mapTeleporterCfgData = nodeTemp.mapTeleporterCfgData;
				entity = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_TELEPORTER,mapTeleporterCfgData.id);
				if(!entity)
				{
					trace("AutoFindPath.searchTlpt entity"+entity);
					return;
				}
				if(entity.isShow)//已能获取到自动目标实体
				{
					AutoJobManager.getInstance().runToEntity(entity);
				}
				else
				{
					AutoJobManager.getInstance().runTo(entity.tileX, entity.tileY, AutoJobManager.TO_TELEPORT_TILE_DIST);
				}
				return;
			}
			var dealMaps:Dictionary = new Dictionary();
			var nodes:Vector.<Node>,node:Node,nodesTemp:Vector.<Node>;
			dealMaps[crntMapId] = true;
			nodes = initNodes(tgtMapId,dealMaps,crntMapId);
			while(!_targetNode)
			{
				nodesTemp = new Vector.<Node>();
				for each(node in nodes)
				{
					var nodesInit:Vector.<Node> = initNodes(tgtMapId,dealMaps,0,node);
					nodesTemp = nodesTemp.concat(nodesInit);
				}
				nodes = nodesTemp;
				if(!nodes || nodes.length == 0)
				{
					break;
				}
			}
		}
		
		private function initNodes(tgtMapId:int,dealMaps:Dictionary,crntMapId:int,node:Node = null):Vector.<Node>
		{
			var vector:Vector.<Node> = new Vector.<Node>();
			var mapTeleporterCfgDatas:Dictionary,mapTeleporterCfgData:MapTeleportCfgData,entity:IEntity,mapRegionCfgData:MapRegionCfgData;
			var mapId:int = crntMapId ? crntMapId : node.mapTeleporterCfgData.mapRegionCfgData ? node.mapTeleporterCfgData.mapRegionCfgData.map_id : 0;
			if(!mapId)
			{
				trace("AutoFindPath.initNode mapId"+mapId);
				return new Vector.<Node>();
			}
			mapTeleporterCfgDatas = ConfigDataManager.instance.mapTeleporterCfgDatas(mapId);//当前地图的所有传送点
			for each(mapTeleporterCfgData in mapTeleporterCfgDatas)
			{
				mapRegionCfgData = mapTeleporterCfgData.mapRegionCfgData;
				if(mapRegionCfgData)
				{
					if(!dealMaps[mapRegionCfgData.map_id])
					{
						dealMaps[mapRegionCfgData.map_id] = true;
						if(!node || (node && mapRegionCfgData.map_id != node.mapTeleporterCfgData.map_from))//当前地图传动点的目标不是来源地图
						{
							var nodeNow:Node = new Node(node,mapTeleporterCfgData);
							vector.push(nodeNow);
							if(mapRegionCfgData.map_id == tgtMapId)//当前地图传动点的目标是目标地图
							{
								_targetNode = nodeNow;
							}
						}
					}
				}
				else
				{
					trace("AutoFindPath.initNode mapRegionCfgData："+mapRegionCfgData);
				}
			}
			return vector;
		}
		
		internal function reset():void
		{
			_targetId = 0;
			_targetType = 0;
			_targetPos = null;
			_targetMapId = 0;
			_targetTileDist = 0;
			_targetNode = null;
		}
		
		internal function destroyEffect():void
		{
			if(MainUiMediator.getInstance().autoSign)
			{
				MainUiMediator.getInstance().autoSign.hideFindPathEffect();
			}
		}
		
		internal function newEffect():void
		{
			if(MainUiMediator.getInstance().autoSign)
			{
				MainUiMediator.getInstance().autoSign.showFindPathEffect();
			}
		}
		
		internal function set targetId(value:int):void
		{
			_targetId = value;
		}
		
		internal function get targetId():int
		{
			return _targetId;
		}

		internal function set targetType(value:int):void
		{
			_targetType = value;
		}
		
		internal function get targetType():int
		{
			return _targetType
		}

		internal function setTargetPos(value:Point, mapId:int, targetTileDist:int):void
		{
			_targetPos = value;
			_targetMapId = mapId;
			_targetTileDist = targetTileDist;
		}
	}
}
import com.model.configData.cfgdata.MapTeleportCfgData;

class Node
{
	public var connection:Node;
	public var mapTeleporterCfgData:MapTeleportCfgData;
	
	public function Node(connection:Node,mapTeleporterCfgData:MapTeleportCfgData)
	{
		this.connection = connection;
		this.mapTeleporterCfgData = mapTeleporterCfgData;
	}
}