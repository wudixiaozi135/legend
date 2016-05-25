package com.model.business.fileService.loaderManager
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ByteArrayToBitmapDataManager implements IBitmapDataLoaderReceiver
	{
		private static const N_MAX_LOADING:int = 2;
		private static var _instance:ByteArrayToBitmapDataManager;
		
		private var _waitingBytes:Vector.<ByteArray>;
		private var _loaderDic:Dictionary;
		private var _receiverDic:Dictionary;
		private var _nLoading:int;
		
		public static function getInstance():ByteArrayToBitmapDataManager
		{
			if (!_instance)
			{
				_instance = new ByteArrayToBitmapDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function ByteArrayToBitmapDataManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_waitingBytes = new Vector.<ByteArray>();
			_loaderDic = new Dictionary();
			_receiverDic = new Dictionary();
			_nLoading = 0;
		}
		
		public function unloadBitmapData(bytes:ByteArray, receiver:IByteArrayToBitmapDataManagerReceiver):void
		{
			var receivers:Vector.<IByteArrayToBitmapDataManagerReceiver> = _receiverDic[bytes];
			
			if(receivers)
			{
				var index:int = receivers.indexOf(receiver);
				
				if(index != -1)
				{
					receivers.splice(index,1);
				}
				
				if(receivers.length == 0)
				{
					var loader:BitmapDataLoader = _loaderDic[bytes];
					if(loader)
					{
						--_nLoading;
						loader.destroy();
						delete _loaderDic[bytes];
					}
					else
					{
						index = _waitingBytes.indexOf(bytes);
						
						if(index != -1)
						{
							_waitingBytes.splice(index,1);
						}
					}
					
					delete _receiverDic[bytes];
				}
			}
		}
		
		public function loadBitmapData(bytes:ByteArray, receiver:IByteArrayToBitmapDataManagerReceiver, noQueue:Boolean = false):void
		{
//			bytes.position = 0;
//			var bytesCopy:ByteArray = new ByteArray();
//			bytes.readBytes(bytesCopy, 0, bytes.length);
//			var receivers:Vector.<IByteArrayToBitmapDataManagerReceiver> = _receiverDic[bytesCopy];
//			if (receivers)
//			{
//				receivers.push(receiver);
//			}
//			else
//			{
//				if (_nLoading < N_MAX_LOADING || noQueue)
//				{
//					var loader:BitmapDataLoader = new BitmapDataLoader(this);
//					loader.loadBitmap(bytesCopy);
//					_loaderDic[bytesCopy] = loader;
//					++_nLoading;
//				}
//				else
//				{
//					_waitingBytes.push(bytesCopy);
//				}
//				receivers = _receiverDic[bytesCopy] = new Vector.<IByteArrayToBitmapDataManagerReceiver>();
//				receivers.push(receiver);
//			}
			
			if(!receiver)
			{
				return;
			}
			
			bytes.position = 0;
			var receivers:Vector.<IByteArrayToBitmapDataManagerReceiver> = _receiverDic[bytes];
			if (receivers)
			{
				receivers.push(receiver);
			}
			else
			{
				if (_nLoading < N_MAX_LOADING || noQueue)
				{
					var loader:BitmapDataLoader = new BitmapDataLoader(this);
					loader.loadBitmap(bytes);
					_loaderDic[bytes] = loader;
					++_nLoading;
				}
				else
				{
					_waitingBytes.push(bytes);
				}
				receivers = _receiverDic[bytes] = new Vector.<IByteArrayToBitmapDataManagerReceiver>();
				receivers.push(receiver);
			}
		}
		
		private function fillLoadingQueue():void
		{
			if (_nLoading < N_MAX_LOADING && _waitingBytes.length > 0)
			{
				var bytes:ByteArray = _waitingBytes.shift();
				var loader:BitmapDataLoader = new BitmapDataLoader(this);
				loader.loadBitmap(bytes);
				_loaderDic[bytes] = loader;
				++_nLoading;
			}
		}
		
		public function bitmapDataReceive(bytes:ByteArray, bitmapData:BitmapData):void
		{
			--_nLoading;
			var receivers:Vector.<IByteArrayToBitmapDataManagerReceiver> = _receiverDic[bytes];
			while (receivers && receivers.length > 0)
			{
				var receiver:IByteArrayToBitmapDataManagerReceiver = receivers.pop();
				if (receiver)
				{
					if (receivers.length > 0)
					{
						receiver.bitmapDataReceive(bytes, bitmapData.clone());
					}
					else
					{
						receiver.bitmapDataReceive(bytes, bitmapData);
					}
				}
			}
			delete _receiverDic[bytes];
			var loader:BitmapDataLoader = _loaderDic[bytes];
			if (loader)
			{
				loader.destroy();
			}
			delete _loaderDic[bytes];
//			bytes.clear();
			
			fillLoadingQueue();
		}
		
		public function bitmapDataError(bytes:ByteArray):void
		{
			--_nLoading;
			var receivers:Vector.<IByteArrayToBitmapDataManagerReceiver> = _receiverDic[bytes];
			while (receivers && receivers.length > 0)
			{
				var receiver:IByteArrayToBitmapDataManagerReceiver = receivers.pop();
				if (receiver)
				{
					receiver.bitmapDataError(bytes);
				}
				delete _receiverDic[bytes];
			}
			var loader:BitmapDataLoader = _loaderDic[bytes];
			if (loader)
			{
				loader.destroy();
			}
			delete _loaderDic[bytes];
			
			fillLoadingQueue();
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.utils.ByteArray;

interface IBitmapDataLoaderReceiver
{
	function bitmapDataReceive(bytes:ByteArray, bitmapData:BitmapData):void;
	function bitmapDataError(bytes:ByteArray):void;
}

class BitmapDataLoader
{
	private var _receiver:IBitmapDataLoaderReceiver;
	
	private var _bytes:ByteArray;
	private var _loader:Loader;
	private var _loaded:Boolean;
	
	public function BitmapDataLoader(receiver:IBitmapDataLoaderReceiver):void
	{
		_receiver = receiver;
		_loaded = false;
	}
	
	public function loadBitmap(bytes:ByteArray):void
	{
		_bytes = bytes;
		_loader = new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandle, false, 0 , true);
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandle, false, 0 , true);
		_loader.loadBytes(_bytes);
	}
	
	private function completeHandle(event:Event):void
	{
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandle);
		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandle);
		
		var bitmap:BitmapData = (_loader.content as Bitmap).bitmapData.clone();
		_loaded = true;
		
		if(_receiver)
		{
			_receiver.bitmapDataReceive(_bytes, bitmap);
		}
		
		if(_loader)
		{
			_loader.unloadAndStop(false);
			_loader = null;
		}
		_bytes = null;
		_receiver = null;
	}
	
	private function errorHandle(event:IOErrorEvent):void
	{
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandle);
		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandle);
		
		_receiver.bitmapDataError(_bytes);
		
		if(_loader)
		{
			_loader.unloadAndStop(false);
			_loader = null;
		}
		_bytes = null;
		_receiver = null;
	}
	
	public function destroy():void
	{
		if (_loader)
		{
			try
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandle);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandle);
				_loader.unloadAndStop(false);
//				_loader.close();
				_loader = null;
				_bytes = null;
				_receiver = null;
			}
			catch (error:Error)
			{
//				trace(error.message);
			}
		}
	}
}

class PrivateClass{}