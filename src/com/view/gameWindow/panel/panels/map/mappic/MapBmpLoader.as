package com.view.gameWindow.panel.panels.map.mappic
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	/**
	 * 地图图片加载类
	 * @author Administrator
	 */	
	public class MapBmpLoader implements IUrlBitmapDataLoaderReceiver
	{
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _layer:MovieClip;
		private var _bitmap:Bitmap;
		
		public function MapBmpLoader(layer:MovieClip)
		{
			_layer = layer;
		}
		
		public function loadPic(id:String):void
		{
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			var url:String = ResourcePathConstants.IMAGE_MAP_FOLDER_LOAD+"/m"+id+ResourcePathConstants.POSTFIX_JPG;
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(_bitmap)
			{
				if(_bitmap.bitmapData)
					_bitmap.bitmapData.dispose();
				if(_bitmap.parent)
					_bitmap.parent.removeChild(_bitmap);
			}
			if(_layer)
			{
				if(_bitmap==null)
				{
					_bitmap =new Bitmap(bitmapData,"auto",true);
				}
				else
				{
					_bitmap.bitmapData = bitmapData;
				}
				_layer.addChildAt(_bitmap,0);
			}
			
			if(_urlBitmapDataLoader)
			{
				_urlBitmapDataLoader.destroy();
			}
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			_urlBitmapDataLoader.destroy();
		}
		
		public function destroy():void
		{
			if(_bitmap)
			{
				if(_bitmap.bitmapData)
					_bitmap.bitmapData.dispose();
				if(_bitmap.parent)
					_bitmap.parent.removeChild(_bitmap);
			}
			_bitmap = null;
			_layer = null;
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
	}
}