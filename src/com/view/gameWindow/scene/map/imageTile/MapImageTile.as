package com.view.gameWindow.scene.map.imageTile
{
	import com.model.business.fileService.ThreadCall;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.cfgdata.MapCfgData;
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MapImageTile implements IUrlBitmapDataLoaderReceiver
	{
		private static var _threadCall:ThreadCall = new ThreadCall();
		
		public static function compare(ex1:MapImageTile, ex2:MapImageTile):Number
		{
			return ex1.dist - ex2.dist;
		}
		
		private var _container:Sprite;
		private var _iRow:int;
		private var _iCol:int;
		private var _thumb:BitmapData;
		private var _mapConfig:MapCfgData;
		private var _bitmap:Bitmap;
		private var _loader:UrlBitmapDataLoader;
		private var _isLoad:Boolean = false;
		
		public var dist:Number;
		
		public function MapImageTile(container:Sprite, iRow:int, iCol:int)
		{
			_container = container;
			_iRow = iRow;
			_iCol = iCol;
		}
		
		public function init(thumb:BitmapData, mapConfig:MapCfgData):void
		{
			_thumb = thumb;
			_mapConfig = mapConfig;
		}
		
		public function show():void
		{
//			var bitmapData:BitmapData = MapImageBitmapDataTilePool.getInstance().popBitmapData();
//			if (_thumb)
//			{
//				var thumbScale:Number = _mapConfig.width / _thumb.width;
//				var matrix:Matrix = new Matrix(thumbScale, 0, 0, thumbScale, -_iCol * SceneMapManager.IMAGE_TILE_WIDTH, -_iRow * SceneMapManager.IMAGE_TILE_HEIGHT);
//				bitmapData.draw(_thumb, matrix, null, null, null, true);//地体默认马赛克图形
//			}
//			if (!_bitmap)
//			{
//				_bitmap = new Bitmap();
//				_bitmap.smoothing = true;
//			}
//			if(_bitmap.bitmapData)
//			{
//				_bitmap.bitmapData.dispose();
//			}
//			_bitmap.bitmapData = bitmapData;
//			_bitmap.x = _iCol * SceneMapManager.IMAGE_TILE_WIDTH;
//			_bitmap.y = _iRow * SceneMapManager.IMAGE_TILE_HEIGHT;
//			_bitmap.parent&&_bitmap.parent.removeChild(_bitmap);
//			_container.addChild(_bitmap);
//			if(_loader!=null)
//			{
//				_loader.destroy();
//				_loader=null;
//			}
//			_loader = new UrlBitmapDataLoader(this);
//			_loader.loadBitmap(ResourcePathConstants.IMAGE_MAP_FOLDER_LOAD + _mapConfig.url + "/" + _iRow + "_" + _iCol + ResourcePathConstants.POSTFIX_JPG, null);
		}
		
		
		private var _isShowThumb:Boolean = false;
		public function showThumb():void
		{
			if (!_bitmap || !_bitmap.bitmapData)
			{
				var bitmapData:BitmapData = MapImageBitmapDataTilePool.getInstance().popBitmapData();
				if (_thumb)
				{
					var thumbScale:Number = _mapConfig.width / _thumb.width;
					var matrix:Matrix = new Matrix(thumbScale, 0, 0, thumbScale, -_iCol * SceneMapManager.IMAGE_TILE_WIDTH, -_iRow * SceneMapManager.IMAGE_TILE_HEIGHT);
					bitmapData.draw(_thumb, matrix, null, null, null, true);//地体默认马赛克图形
				}
				if (!_bitmap)
				{
					_bitmap = new Bitmap();
					_bitmap.smoothing = true;
				}
				if(_bitmap.bitmapData)
				{
					_bitmap.bitmapData.dispose();
				}
				_bitmap.bitmapData = bitmapData;
				_bitmap.x = _iCol * SceneMapManager.IMAGE_TILE_WIDTH;
				_bitmap.y = _iRow * SceneMapManager.IMAGE_TILE_HEIGHT;
				_bitmap.parent&&_bitmap.parent.removeChild(_bitmap);
				_container.addChild(_bitmap);
			}
			
			_isShowThumb = true;
//			if(_img)
//			{
////				_bitmap.bitmapData = _img;
//				draw(_img);
//				_img = null;
//			}
		}
		
		public function showMap():Boolean
		{
			if(_img && _isShowThumb)
			{
				if(!_bitmap)
				{
					_bitmap = new Bitmap();
					_container.addChild(_bitmap);
				}
				
				draw(_img);
				_img = null;
				return true;
			}
			
			return false;
		}
	
		public function loadMap():void
		{
			if(!_isLoad)
			{
				_threadCall.call(this,xloadMap);
//				xloadMap();
				_isLoad = true;
			}
		}
		
		private function xloadMap():void
		{
			if (!_loader)
			{
				_loader = new UrlBitmapDataLoader(this);
				_url = ResourcePathConstants.IMAGE_MAP_FOLDER_LOAD + _mapConfig.url + "/" + _iRow + "_" + _iCol + ResourcePathConstants.POSTFIX_JPG;
				_loader.loadBitmap(_url, null);
			}
		}
		
		private function draw(bitmapData:BitmapData):void
		{
			if(!_bitmap.bitmapData)
			{
				_bitmap.bitmapData = MapImageBitmapDataTilePool.getInstance().popBitmapData();
			}
			
//			_bitmap.bitmapData = bitmapData;
			_bitmap.bitmapData.copyPixels(bitmapData,new Rectangle(0,0,bitmapData.width,bitmapData.height),new Point(0,0));
		}
		
		private var _url:String;
		private var _img:BitmapData;
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if (_loader)
			{
//				if (!_bitmap)
//				{
//					_bitmap = new Bitmap();
//					_container.addChild(_bitmap);
//				}
//				
//				if (_bitmap.bitmapData)
//				{
//					MapImageBitmapDataTilePool.getInstance().pushBitmapData(_bitmap.bitmapData);
//				}
//				
//				_bitmap.bitmapData = bitmapData;
				
				
//				if(_isShowThumb)
//				{
////					_bitmap.bitmapData = bitmapData;
//					draw(bitmapData);
//				}
//				else
//				{
					_img = bitmapData;
//				}
				
//				_bitmap.x = _iCol * SceneMapManager.IMAGE_TILE_WIDTH;
//				_bitmap.y = _iRow * SceneMapManager.IMAGE_TILE_HEIGHT;
				
				_threadCall.complete(this);
				
//				_loader.destroy();
//				_loader=null;
			}
			else
			{
				bitmapData.dispose();
			}
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
		
		public function clear():void
		{
			_isLoad = false;
			_isShowThumb = false;
			_img = null;
			_threadCall.destroy(this);
			if (_bitmap)
			{
				if(_bitmap.bitmapData)
				{
					MapImageBitmapDataTilePool.getInstance().pushBitmapData(_bitmap.bitmapData);
				}
				_bitmap.parent&&_bitmap.parent.removeChild(_bitmap);
				_bitmap.bitmapData = null;
			}
			_bitmap = null;
			
			if (_loader)
			{
				_loader.destroy();
			}
			_loader=null;
		}
		
		public function get iRow():int
		{
			return _iRow;
		}
		
		public function get iCol():int
		{
			return _iCol;
		}
		
		public function destroy():void
		{
			clear();
		}
		
		public static function pixelToTile(pixelX:int, pixelY:int):Point
		{
			var tileX:int = pixelX / SceneMapManager.IMAGE_TILE_WIDTH;
			var tileY:int = pixelY / SceneMapManager.IMAGE_TILE_WIDTH;
			var point:Point = new Point(tileX, tileY);
			return point;
		}
	}
}