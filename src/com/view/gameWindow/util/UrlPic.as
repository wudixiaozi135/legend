package com.view.gameWindow.util
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	public class UrlPic implements IUrlBitmapDataLoaderReceiver
	{
		private var _bmp:Bitmap;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		
		private var _layer:DisplayObjectContainer;

		public function set callBack(value:Function):void
		{
			_callBack = value;
		}

		private var _callBack:Function;
		private var _args:*;
		
		public function UrlPic(layer:DisplayObjectContainer,callBack:Function = null,...args)
		{
			_layer = layer;
			_callBack = callBack
			_args = args;
		}
		
		public function load(url:String):void
		{
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			destroyBmp();
			newBmp(bitmapData);
			destroyLoader();
			if(_callBack != null)
			{
				_callBack.call(null,_args);
			}
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyBmp();
			destroyLoader();
		}
		
		public function destroyBmp():void
		{
			if(_bmp)
			{
				if(_bmp.parent)
				{
					_bmp.parent.removeChild(_bmp);
				}
				if(_bmp.bitmapData)
				{
					_bmp.bitmapData.dispose();
				}
				_bmp = null;
			}
		}
		
		private function newBmp(bmpDt:BitmapData):void
		{
			if(_layer)
			{
				_bmp = new Bitmap(bmpDt,"auto",true);
				_layer.addChild(_bmp);
			}
		}
		
		private function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
			{
				_urlBitmapDataLoader.destroy();
				_urlBitmapDataLoader = null;
			}
		}
		
		public function destroy():void
		{
			destroyBmp();
			destroyLoader();
			_layer = null;
			_callBack = null;
			_args = null;
		}
	}
}