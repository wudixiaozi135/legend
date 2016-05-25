package com.model.business.fileService
{
	import com.model.business.fileService.interf.IBytesBitmapDataLoaderReceiver;
	import com.model.business.fileService.loaderManager.ByteArrayToBitmapDataManager;
	import com.model.business.fileService.loaderManager.IByteArrayToBitmapDataManagerReceiver;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class BytesBitmapDataLoader implements IByteArrayToBitmapDataManagerReceiver
	{
		private var _receiver:IBytesBitmapDataLoaderReceiver;
		private var _bytes:ByteArray;
		private var _info:Object;
		private var _loaded : Boolean;
		public function BytesBitmapDataLoader(receiver:IBytesBitmapDataLoaderReceiver):void
		{
			_receiver = receiver;
			_loaded = false;
		}
		
		public function loadBitmap(bytes:ByteArray, info:Object = null, noQueue:Boolean = false):void
		{
			_info = info;
			_bytes = bytes;
			ByteArrayToBitmapDataManager.getInstance().loadBitmapData(bytes, this, noQueue);
		}
		
		public function bitmapDataReceive(byteArray:ByteArray, bitmapData:BitmapData):void
		{
			if (_receiver)
			{
				_receiver.bytesBitmapDataReceive(byteArray, bitmapData, _info);
				_receiver = null;
			}
			else
			{
				bitmapData.dispose();
			}
		}
		
		public function bitmapDataError(byteArray:ByteArray):void
		{
			if (_receiver)
			{
				_receiver.bytesBitmapDataError(byteArray, _info);
				_receiver = null;
			}
		}
		
		public function destroy():void
		{
			if(_bytes)
			{
				ByteArrayToBitmapDataManager.getInstance().unloadBitmapData(_bytes,this);
				_bytes = null;
			}
			_receiver = null;//不再受到 bitmapDataReceive 的影响 。 不然UrlBitmapDataLoader::bytesBitmapDataReceive() 仍然会调用
		}
	}
}