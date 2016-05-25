package com.view.gameWindow.mainUi.subuis.minimap
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.BitmapData;
	
	/**
	 * 迷你地图图片加载类
	 * @author Administrator
	 */	
	public class MiniMapBmpLoader implements IUrlBitmapDataLoaderReceiver
	{
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _bitmapData:BitmapData;
		private var _callback:Function;
		public function MiniMapBmpLoader()
		{
			
		}
		
		public function loadPic(id:String,completeCallback:Function):void
		{
			_callback = completeCallback;
			_bitmapData = null;
			var url:String = ResourcePathConstants.IMAGE_MAP_FOLDER_LOAD+"/m"+id+ResourcePathConstants.POSTFIX_JPG;
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			_bitmapData = bitmapData;
			_urlBitmapDataLoader.destroy();
			
			if(_callback != null)
			{
				_callback();
				_callback = null;
			}
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			_urlBitmapDataLoader.destroy();
			_callback = null;
		}
		
		public function destroy():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
			_callback = null;
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
	}
}