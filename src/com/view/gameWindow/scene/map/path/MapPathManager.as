package com.view.gameWindow.scene.map.path
{
	import com.model.business.fileService.BytesLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IBytesLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.INpcStatic;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 地图寻路管理类
	 * @author Administrator
	 */	
	public class MapPathManager implements IBytesLoaderReceiver
	{
		public static const TM_NORMAL:int = 0;
		public static const TM_BLOCK:int = 1;
		public static const TM_SHADOW:int = 2;
		public static const TM_MINE:int = 3;
		public static const TM_PLAYER_BLOCK:int = 6;
		public static const TM_PLAYER_BLOCK_SHADOW:int = 7;
		
		private static var _instance:MapPathManager;
		public static function getInstance():MapPathManager
		{
			if(!_instance)
				_instance = new MapPathManager(hideFun);
			return _instance;
		}
		private static function hideFun():void{}
		
		private var _rdUrl:String;
		private var _mapIndex:Vector.<Vector.<int>>;//地图数据，记录地图中哪个网格不可到达

		private var _bMove:Boolean;
		private var _aPath:Vector.<Vector.<int>>;
		private var _pathFinder:PathFinder;
		
		private var _nMapRows:int;
		private var _nMapCols:int;
		
		public function MapPathManager(fun:Function)
		{
			if(fun != hideFun)
			{
				throw new Error("该类使用单例模式");
			}
			_pathFinder = new PathFinder();
			
			_nMapRows = 0;
			_nMapCols = 0;
		}
		
		public function loadMapPathData(mapId:int):void
		{
			_mapIndex = null;
			_nMapRows = 0;
			_nMapCols = 0;
			var mapDataItem:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			var bytesLoader:BytesLoader = new BytesLoader(this);
			_rdUrl = ResourcePathConstants.IMAGE_MAP_FOLDER_LOAD + mapDataItem.url + ResourcePathConstants.POSTFIX_RD;
			bytesLoader.loadBytes(_rdUrl);
		}
		
		public function bytesError(url:String, info:Object):void
		{
		}
		
		public function bytesProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function bytesReceive(url:String, bytes:ByteArray, info:Object):void
		{
			if (url != _rdUrl)
			{
				return;
			}
			var sceneMapManager:SceneMapManager = SceneMapManager.getInstance();
			var mapId:int = sceneMapManager.mapId;
			var mapDataItem:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			_nMapRows = Math.floor(mapDataItem.height/MapTileUtils.TILE_HEIGHT);
			_nMapCols = Math.floor(mapDataItem.width/MapTileUtils.TILE_WIDTH);
			
			var uncompressBytes:ByteArray = new ByteArray();
			uncompressBytes.endian = Endian.LITTLE_ENDIAN;
			bytes.position = 0;
			bytes.readBytes(uncompressBytes, 0, bytes.bytesAvailable);
			uncompressBytes.uncompress();
			
			var count:int = 0;
			var tilesByte:int = 0;
			_mapIndex = new Vector.<Vector.<int>>();
			for(var i:int = 0; i < _nMapRows; i++)
			{
				var tmpArray:Vector.<int> = new Vector.<int>();
				for(var j:int=0; j < _nMapCols; j++)
				{
					if(count == 0)
					{
						tilesByte = uncompressBytes.readUnsignedByte();
					}
					var tileByte:int = (tilesByte>>count*4)&15;
					tmpArray.push(tileByte);
					count++;
					if(count == 2)
					{
						count = 0;
					}
				}
				_mapIndex.push(tmpArray);
			}
			
			setNpcBlock();
			_pathFinder.resetMapInfo(_nMapRows, _nMapCols, _mapIndex);
		}
		
		private function setNpcBlock():void
		{
			for each (var npc:INpcStatic in EntityLayerManager.getInstance().getAllStaticNpcs())
			{
				if (npc.tileY >= 0 && _mapIndex && _mapIndex.length > npc.tileY)
				{
					var mapRow:Vector.<int> = _mapIndex[npc.tileY];
					if (npc.tileX >= 0 && mapRow && mapRow.length > npc.tileX)
					{
						mapRow[npc.tileX] = TM_BLOCK;
					}
				}
			}
			for each (npc in EntityLayerManager.getInstance().getAllDynamicNpcs())
			{
				if (npc.tileY >= 0 && _mapIndex && _mapIndex.length > npc.tileY)
				{
					mapRow = _mapIndex[npc.tileY];
					if (npc.tileX >= 0 && mapRow && mapRow.length > npc.tileX)
					{
						mapRow[npc.tileX] = TM_BLOCK;
					}
				}
			}
		}
		
		public function findPath(startTile:Point, targetTile:Point, topLeftX:int, topLeftY:int, bottomRightX:int, bottomRightY:int, tileDist:int):Array
		{
			if(ready)
			{
				var isMineBool:Boolean = isMine(targetTile.x, targetTile.y);
				if (isMineBool)
				/*var isWalkable:Boolean = isWalkable(targetTile.x,targetTile.y);
				if(!isWalkable)*/
				{
					var nearTargetTile:Point = _pathFinder.getNearWalkableTile(startTile,targetTile);
					if(nearTargetTile)
					{
						targetTile = nearTargetTile;
					}
				}
				return _pathFinder.find(startTile, targetTile, topLeftX, topLeftY, bottomRightX, bottomRightY, tileDist);
			}
			return null;
		}

		public function get bMove():Boolean
		{
			return _bMove;
		}

		public function get aPath():Vector.<Vector.<int>>
		{
			return _aPath;
		}
		
		public function get ready():Boolean
		{
			return _mapIndex != null;
		}
		
		public function checkAlpha(tileX:int, tileY:int):Boolean
		{
			if (_mapIndex)
			{
				try
				{
					var mask:int = _mapIndex[tileY][tileX];
					return mask == TM_SHADOW || mask == TM_PLAYER_BLOCK_SHADOW;
				}
				catch(e:Error)
				{
					trace("MapPathManager.checkAlpha(tileX, tileY)" + e.message);
				}
			}
			return false;
		}
		
		public function isWalkable(tileX:int, tileY:int, cid:int, sid:int):Boolean
		{
			if(_mapIndex.length <= tileY)
				return false;
			if(_mapIndex[tileY].length <= tileX)
				return false;
			var mask:int = _mapIndex[tileY][tileX];
			if (mask == TM_NORMAL || mask == TM_SHADOW)
			{
				return true;
			}
			else if (mask == TM_PLAYER_BLOCK || mask == TM_PLAYER_BLOCK_SHADOW)
			{
				return !EntityLayerManager.getInstance().isPlayerOnPosExcept(tileX, tileY, cid, sid);
			}
			return false;
		}
		/**是否为矿物*/
		public function isMine(tileX:int, tileY:int):Boolean
		{
			if (!_mapIndex)
			{
				return false;
			}
			if(_mapIndex.length <= tileY)
			{
				return false;
			}
			if(_mapIndex[tileY].length <= tileX)
			{
				return false;
			}
			return _mapIndex[tileY][tileX] == TM_MINE;
		}
	}
}