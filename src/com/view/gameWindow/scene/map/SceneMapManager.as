package com.view.gameWindow.scene.map
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.consts.MapConst;
	import com.view.gameWindow.mainUi.subuis.musicSet.MusicConst;
	import com.view.gameWindow.mainUi.subuis.musicSet.MusicSettingManager;
	import com.view.gameWindow.scene.map.imageTile.MapImageTile;
	import com.view.gameWindow.scene.map.path.MapPathManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	import com.view.newMir.sound.SoundManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SceneMapManager implements IUrlBitmapDataLoaderReceiver
	{
		private static var _instance:SceneMapManager;
		
		public static const IMAGE_TILE_WIDTH:int = 192;
		public static const IMAGE_TILE_HEIGHT:int = 192;
		public static const THUMB_WIDTH:int = 187;
		
		public static const VIEW_MAP_ENLARGE:int = 2;
		
		private var _container:Sprite;
		private var _mapPathManager:MapPathManager;
		private var _lastRect:Rectangle;
		private var _xPos:int;
		private var _yPos:int;
		private var _newX:int;//保存切换地图时新的位置
		private var _newY:int;//保存切换地图时新的位置
		private var _width:int;
		private var _height:int;
		
		private var _mapId:int;
		private var _mapConfig:MapCfgData;
		private var _imageTiles:Vector.<Vector.<MapImageTile>>;
		
		private var _thumbReady:Boolean;
		private var _thumbMapLoader:UrlBitmapDataLoader;
		private var _thumb:BitmapData;
		
		private var _mapPathUrl:String;
		public var alertBoss:Boolean;
		
		public static function getInstance():SceneMapManager
		{
			if (!_instance)
			{
				_instance = new SceneMapManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function SceneMapManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
		}
		
		public function init(container:Sprite):void
		{
			_container = container;
			_imageTiles = new Vector.<Vector.<MapImageTile>>();
			_thumbReady = false;
			_lastRect = new Rectangle(-1, -1, 0, 0);
			
			_mapPathManager = MapPathManager.getInstance();
		}
		
		public function resize(width:int, height:int):void
		{
			_width = width;
			_height = height;
		}
		
		public function switchMap(mapId:int, xPos:int, yPos:int):void
		{
			_mapId = mapId;
			if (_thumbMapLoader)
			{
				_thumbMapLoader.destroy();
			}
			_thumbReady = false;
			_newX = xPos;
			_newY = yPos;
			var mapConfig:MapCfgData = ConfigDataManager.instance.mapCfgData(_mapId);
			_thumbMapLoader = new UrlBitmapDataLoader(this);
			_thumbMapLoader.loadBitmap(ResourcePathConstants.IMAGE_MAP_FOLDER_LOAD + mapConfig.url + ResourcePathConstants.POSTFIX_JPG, null);
			if (mapConfig.sound)
			{
				var musicState:Boolean = MusicSettingManager.instance.getMusicSettingState(MusicConst.BG_MUSIC);
				if (!musicState)
				SoundManager.getInstance().playBgSound(mapConfig.sound);
			}
			else
			{
				SoundManager.getInstance().stopBgSound();
			}
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if (_thumb)
			{
				_thumb.dispose();
			}
			_thumb = bitmapData;
			
			switchMapHandle();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			_mapConfig = ConfigDataManager.instance.mapCfgData(_mapId);
			var thumbHeight:int = THUMB_WIDTH / _mapConfig.width * _mapConfig.height;
			if (thumbHeight > 0)
			{
				_thumb = new BitmapData(THUMB_WIDTH, thumbHeight, false, 0x000000);
			}
			switchMapHandle();
		}
		
		private var _col:int;
		private var _row:int;
		
		private function switchMapHandle():void
		{
			
			
			_xPos = _newX;
			_yPos = _newY;
			_mapConfig = ConfigDataManager.instance.mapCfgData(_mapId);
			var nCol:int = (_mapConfig.width + IMAGE_TILE_WIDTH - 1) / IMAGE_TILE_WIDTH;
			var nRow:int = (_mapConfig.height + IMAGE_TILE_HEIGHT - 1) / IMAGE_TILE_HEIGHT;
			
			_col = nCol;
			_row = nRow;
			var i:int, j:int;
			var imageTile:MapImageTile;
			var imageTileRow:Vector.<MapImageTile>;
			
			
			if(_showList && _showList.length > 0)
			{
				for each(imageTile in  _showList)
				{
					imageTile.destroy();
				}
			}
			
			_showList = [];
			
			if (_imageTiles.length > nRow)
			{
				for (i = nRow; i < _imageTiles.length; ++i)
				{
					imageTileRow = _imageTiles[i];
					for each (imageTile in imageTileRow)
					{
						if (imageTile)
						{
							imageTile.destroy();
						}
					}
				}
			}
			_imageTiles.length = nRow;
			for (i = 0; i < _imageTiles.length; ++i)
			{
				if (!_imageTiles[i])
				{
					_imageTiles[i] = new Vector.<MapImageTile>();
				}
				if (_imageTiles[i].length > nCol)
				{
					for (j = nCol; j < _imageTiles[i].length; ++j)
					{
						imageTile = _imageTiles[i][j];
						if (imageTile)
						{
							imageTile.destroy();
						}
					}
				}
				_imageTiles[i].length = nCol;
			}
			for (i = 0; i < nRow; ++i)
			{
				for (j = 0; j < nCol; ++j)
				{
					imageTile = _imageTiles[i][j];
					if (imageTile)
					{
						imageTile.clear();
						imageTile.init(_thumb, _mapConfig);
					}
				}
			}
			
			_lastRect.x = _lastRect.y = -1;
			_lastRect.width = _lastRect.height = 0;
			_thumbReady = true;
			
		}
		
		/**刷新地图数据*/		
		public function showMap(xPos:Number, yPos:Number):void
		{
			if (!_mapConfig)
			{
				return;
			}
			
			//测试代码
//			var w:int = 300;
//			var h:int = 50;
//			
//			var dw:Number = (_width - w)/2;
//			var dh:Number = (_height - h)/2;
//			
//			xPos += dw;
//			yPos += dh;
//			
//			var _width:int = w;
//			var _height:int = h;
			
			var topLeftTile:Point = MapImageTile.pixelToTile(xPos, yPos);
			
			var bottomRightTile:Point = new Point();
			var bx:int = (xPos + _width)/SceneMapManager.IMAGE_TILE_WIDTH;
			var by:int = (yPos + _height)/SceneMapManager.IMAGE_TILE_HEIGHT;
				
			bottomRightTile.x = (xPos + _width) % SceneMapManager.IMAGE_TILE_WIDTH != 0 ? bx : bx - 1;
			bottomRightTile.y = (yPos + _height) % SceneMapManager.IMAGE_TILE_HEIGHT != 0 ? by : by - 1;
			
			
			if(Math.abs(topLeftTile.x - _lastRect.x) >= 1 || Math.abs(topLeftTile.y - _lastRect.y) >= 1 || Math.abs(bottomRightTile.x - _lastRect.x -  _lastRect.width) >= 1 || Math.abs(bottomRightTile.y - _lastRect.y - _lastRect.height) >= 1)
			{
				var centerTile:Point = MapImageTile.pixelToTile(xPos + _width / 2, yPos + _height / 2);
				
				var imageTile:MapImageTile;
				var i:int, j:int;
				
				var numDestroy:int = 0;
				
				if(_lastRect.x != -1 && _lastRect.y != -1)
				{
					var delIndexList:Array = [];
					for (i = _lastRect.x - VIEW_MAP_ENLARGE; i <= _lastRect.x + _lastRect.width + VIEW_MAP_ENLARGE; ++i)
					{
						for (j = _lastRect.y - VIEW_MAP_ENLARGE; j <= _lastRect.y + _lastRect.height + VIEW_MAP_ENLARGE; ++j)
						{
							if (i >= 0 && j >= 0 && j < _row && i < _col && 
								(i < topLeftTile.x - VIEW_MAP_ENLARGE ||
								i > bottomRightTile.x + VIEW_MAP_ENLARGE || 
								j < topLeftTile.y - VIEW_MAP_ENLARGE || 
								j > bottomRightTile.y + VIEW_MAP_ENLARGE))
							{
								imageTile = _imageTiles[j][i];
								if (imageTile)
								{
									var delIndex:int = _showList.indexOf(imageTile);
									
									delIndexList.push(delIndex);
									
									imageTile.destroy();
									++numDestroy;
									_imageTiles[j][i] = null;
								}
							}
						}
					}
					
					delIndexList.sort(Array.NUMERIC);
					
					while(delIndexList.length)
					{
						_showList.splice(delIndexList.pop(),1);
					}
				}
				
				var mapImageTiles:Array = [];
				for (i = topLeftTile.x - VIEW_MAP_ENLARGE; i <= bottomRightTile.x + VIEW_MAP_ENLARGE; ++i)
				{
					for (j = topLeftTile.y - VIEW_MAP_ENLARGE; j <= bottomRightTile.y + VIEW_MAP_ENLARGE; ++j)
					{
						if (i >= 0 && j >= 0 && j < _row && i < _col && 
							(i < _lastRect.x  - VIEW_MAP_ENLARGE || 
								i > _lastRect.x + _lastRect.width + VIEW_MAP_ENLARGE || 
								j < _lastRect.y - VIEW_MAP_ENLARGE ||
								j > _lastRect.y + _lastRect.height + VIEW_MAP_ENLARGE))
						{
							if (!_imageTiles[j][i])
							{
								_imageTiles[j][i] = new MapImageTile(_container, j, i);
								_imageTiles[j][i].init(_thumb, _mapConfig);
							}
							imageTile = _imageTiles[j][i];
							
							imageTile.dist = Math.sqrt((i - centerTile.x) * (i - centerTile.x) + (j - centerTile.y) * (j - centerTile.y));
							mapImageTiles.push(imageTile);
						}
					}
				}
				
				mapImageTiles.sort(MapImageTile.compare);
				for each(imageTile in mapImageTiles)
				{
//					if (imageTile.iCol >= topLeftTile.x && imageTile.iCol <= bottomRightTile.x && imageTile.iRow >= topLeftTile.y && imageTile.iRow <= bottomRightTile.y)
//					{
//						trace("showThumb");
//						imageTile.showThumb();
//					}
					imageTile.loadMap();
					
					if(_showList.indexOf(imageTile) == -1)
					{
						_showList.push(imageTile);
					}
				}
				
				_lastRect.x = topLeftTile.x;
				_lastRect.y = topLeftTile.y;
				_lastRect.width = bottomRightTile.x - topLeftTile.x;
				_lastRect.height = bottomRightTile.y - topLeftTile.y;
			}
			
//			trace(_showList.length);
			var num:int = 0;
			for each(imageTile in _showList)
			{
				if (imageTile.iCol >= topLeftTile.x && imageTile.iCol <= bottomRightTile.x && imageTile.iRow >= topLeftTile.y && imageTile.iRow <= bottomRightTile.y)
				{
					imageTile.showThumb();
				}
				
				if(num == 0 && imageTile.showMap())
				{
					++num;
				}
			}
		}
		
		private var _showList:Array = [];
		
		public function get thumb():BitmapData
		{
			return _thumb;
		}
		
		public function get ready():Boolean
		{
			return _thumbReady && _mapPathManager.ready;
		}

		public function get mapId():int
		{
			return _mapId;
		}
		
		public function get mapWidth():int
		{
			if (_mapConfig)
			{
				return _mapConfig.width;
			}
			return 0;
		}
		
		public function get mapHeight():int
		{
			if (_mapConfig)
			{
				return _mapConfig.height;
			}
			return 0;
		}
		
		public function get mapRealWidth():int
		{
			return int(mapWidth / MapTileUtils.TILE_WIDTH) * MapTileUtils.TILE_WIDTH;
		}
		
		public function get mapRealHeight():int
		{
			return int(mapHeight / MapTileUtils.TILE_HEIGHT) * MapTileUtils.TILE_HEIGHT;
		}
		
		public function get isDungeon():Boolean
		{
			if(_mapConfig)
			{
				return _mapConfig.type == MapConst.DUNGEON;
			}
			
			return false;
		}
		
		public function update():void
		{
			
		}
	}
}

class PrivateClass{}