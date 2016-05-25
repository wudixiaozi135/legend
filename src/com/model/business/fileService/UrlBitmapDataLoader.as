package com.model.business.fileService
{
	import com.model.business.fileService.interf.IBytesBitmapDataLoaderReceiver;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.business.fileService.loaderManager.ByteArrayLoaderManager;
	import com.model.business.fileService.loaderManager.IByteArrayLoaderManagerReceiver;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public class UrlBitmapDataLoader implements IByteArrayLoaderManagerReceiver, IBytesBitmapDataLoaderReceiver
	{
		private var _bytesBitmapDataLoader:BytesBitmapDataLoader;
		
		private var _receiver:IUrlBitmapDataLoaderReceiver;
		
		private var _url:String;
		private var _info:Object;
		private var _noQueue:Boolean;

		private var _isSign:Boolean;
		
		public function UrlBitmapDataLoader(receiver:IUrlBitmapDataLoaderReceiver)
		{
			_receiver = receiver;
		}
		
		public function loadBitmap(url:String, info:Object = null, noQueue:Boolean = false,isSign:Boolean=false):void
		{
			this._isSign = isSign;
			_url = url;
			_info = info;
			_noQueue = noQueue;
			ByteArrayLoaderManager.getInstance().loadBytes(url, this);
		}
		
		public function byteArrayReceive(url:String, byteArray:ByteArray):void
		{
			_bytesBitmapDataLoader = new BytesBitmapDataLoader(this);
			_bytesBitmapDataLoader.loadBitmap(byteArray, null, _noQueue);
		}
		
		public function byteArrayProgress(url:String, progress:Number):void
		{
			_receiver.urlBitmapDataProgress(url, progress, _info);
		}
		
		public function byteArrayError(url:String):void
		{
			_receiver.urlBitmapDataError(url, _info);
			_bytesBitmapDataLoader&&_bytesBitmapDataLoader.destroy();
		}
		
		public function bytesBitmapDataReceive(bytes:ByteArray, bitmapData:BitmapData, info:Object):void
		{
			if (_receiver)
			{
				_receiver.urlBitmapDataReceive(_url, bitmapData, _info);
				_receiver = null;
			}
			else
			{
				bitmapData.dispose();
			}
			_bytesBitmapDataLoader&&_bytesBitmapDataLoader.destroy();
		}
		
		public function bytesBitmapDataError(bytes:ByteArray, info:Object):void
		{
			_receiver.urlBitmapDataError(_url, _info);
			_bytesBitmapDataLoader = null;
			_receiver = null;
		}
		
		public function destroy():void
		{
			ByteArrayLoaderManager.getInstance().stopLoad(_url, this);
			if (_bytesBitmapDataLoader)
			{
				_bytesBitmapDataLoader.destroy();				
				_bytesBitmapDataLoader = null;
			}
			_receiver = null;
		}
	}
}