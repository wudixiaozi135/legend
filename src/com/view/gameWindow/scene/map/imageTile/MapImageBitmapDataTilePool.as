package com.view.gameWindow.scene.map.imageTile
{
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	import flash.display.BitmapData;

	public class MapImageBitmapDataTilePool
	{
		private static const MAX_LENGTH:int = 40;
		private static var _instance:MapImageBitmapDataTilePool;
		
		private var _bitmapDataTilePool:Vector.<BitmapData>;
		
		public static function getInstance():MapImageBitmapDataTilePool
		{
			if (!_instance)
			{
				_instance = new MapImageBitmapDataTilePool(new PrivateClass());
			}
			return _instance;
		}
		
		public function MapImageBitmapDataTilePool(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_bitmapDataTilePool = new Vector.<BitmapData>();
		}
		
		public function popBitmapData():BitmapData
		{
			if (_bitmapDataTilePool.length > 0)
			{
				return _bitmapDataTilePool.pop();
			}
			return new BitmapData(SceneMapManager.IMAGE_TILE_WIDTH, SceneMapManager.IMAGE_TILE_HEIGHT, false, 0x000000);
		}
		
		public function pushBitmapData(bitmapData:BitmapData):void
		{
			if (_bitmapDataTilePool.length >= MAX_LENGTH)
			{
				bitmapData.dispose();
			}
			else
			{
				_bitmapDataTilePool.push(bitmapData);
			}
		}
	}
}

class PrivateClass{};