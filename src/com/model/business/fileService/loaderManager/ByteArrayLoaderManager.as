package com.model.business.fileService.loaderManager
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ByteArrayLoaderManager implements IByteArrayLoaderReceiver
	{
		private static const MAX_SIZE:int = 50 * 1024 * 1024;
		private static const N_MIN_LOADING:int = 6;//最小的同时下载量
		private static const N_MAX_LOADING:int = 20;//并发最大n
		
		private static const SPEED_DOUBLE_NEW_LOADING:int = 10 * 1024;
		private static const SPEED_ONE_NEW_LOADING:int = 2 * 1024;
		
		private static var _instance:ByteArrayLoaderManager;
		
		private var _bytesDic:Dictionary;
		private var _bytesSize:int;
		
		private var _receiversDic:Dictionary;
		private var _queueUrls:Vector.<String>;
		private var _loadingUrls:Vector.<String>;
		private var _loaderDic:Dictionary;
		private var _bytesUrls:Vector.<String>;
		
		private var _nLoadings:int;
		
		public static function getInstance():ByteArrayLoaderManager
		{
			if (!_instance)
			{
				_instance = new ByteArrayLoaderManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function ByteArrayLoaderManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_bytesDic = new Dictionary();
			_bytesSize = 0;
			_receiversDic = new Dictionary();
			_queueUrls = new Vector.<String>();
			_loadingUrls = new Vector.<String>();
			_loaderDic = new Dictionary();
			_bytesUrls = new Vector.<String>();
			
			_nLoadings = N_MIN_LOADING;
		}
		
		public function loadBytes(url:String, receiver:IByteArrayLoaderManagerReceiver):void
		{
			var bytes:ByteArray = _bytesDic[url];
			if (bytes)//若缓存中有责缓存中取
			{
				bytes.position = 0;
				receiver.byteArrayReceive(url, bytes);
				var index:int = _bytesUrls.indexOf(url);
				if (index != -1)
				{
					_bytesUrls.splice(index, 1);
				}
				_bytesUrls.push(url);
				return;
			}
			var receivers:Vector.<IByteArrayLoaderManagerReceiver> = _receiversDic[url];
			if (receivers)//若已使用该url调用过该方法这后续调用时值存储接收者
			{
				if (receivers.indexOf(receiver) == -1)
				{
					receivers.push(receiver);
				}
				return;
			}
			_queueUrls.push(url);
			receivers = new Vector.<IByteArrayLoaderManagerReceiver>();
			receivers.push(receiver);
			_receiversDic[url] = receivers;
			
			fillLoadingQueue();
		}
		
		private function fillLoadingQueue():void
		{
			if (_loadingUrls.length < _nLoadings && _queueUrls.length > 0)
			{
				var url:String = _queueUrls.shift();
				_loadingUrls.push(url);
				
				var bytesLoader:ByteArrayLoader = new ByteArrayLoader(this);
				bytesLoader.loadBytes(url);
				_loaderDic[url] = bytesLoader;
			}
		}
		
		public function byteArrayReceive(url:String, byteArray:ByteArray, time:int):void
		{
			for each (var receiver:IByteArrayLoaderManagerReceiver in _receiversDic[url])
			{
				receiver.byteArrayReceive(url, byteArray);
			}
			delete _receiversDic[url];
			delete _loaderDic[url];
			_bytesDic[url] = byteArray;
			var index:int = _bytesUrls.indexOf(url);
			if (index != -1)
			{
				_bytesUrls.splice(index, 1);
				_bytesUrls.push(url);
			}
			else
			{
				_bytesUrls.push(url);
				_bytesSize += byteArray.length;
				while (_bytesSize > MAX_SIZE)
				{
					var dropUrl:String = _bytesUrls.shift();
					var dropBytes:ByteArray = _bytesDic[url];
					delete _bytesDic[url];
					_bytesSize -= dropBytes.length;
					dropBytes.clear();
				}
			}
			
			index = _loadingUrls.indexOf(url);
			if (index != -1)
			{
				_loadingUrls.splice(index, 1);
			}
			
			var speed:int = byteArray.length / time;
			if (speed >= SPEED_DOUBLE_NEW_LOADING && _nLoadings < N_MAX_LOADING)
			{
				++_nLoadings;
			}
			else if (speed < SPEED_ONE_NEW_LOADING && _nLoadings > N_MIN_LOADING)
			{
				--_nLoadings;
			}
			fillLoadingQueue();
		}
		
		public function byteArrayProgress(url:String, progress:Number):void
		{
			for each (var receiver:IByteArrayLoaderManagerReceiver in _receiversDic[url])
			{
				receiver.byteArrayProgress(url, progress);
			}
		}
		
		public function byteArrayError(url:String):void
		{
			for each (var receiver:IByteArrayLoaderManagerReceiver in _receiversDic[url])
			{
				receiver.byteArrayError(url);
			}
			delete _receiversDic[url];
			delete _loaderDic[url];
			var index:int = _loadingUrls.indexOf(url);
			if (index != -1)
			{
				_loadingUrls.splice(index, 1);
			}
		}
		/**
		 * 停止请求地址是url的receiver的请求 
		 * @param url请求的url
		 * @param receiver接受数据的receiver,如果为空，将删除url对应的所有receiver
		 */	
		public function stopLoad(url:String, receiver:IByteArrayLoaderManagerReceiver = null):void
		{
			var receivers:Vector.<IByteArrayLoaderManagerReceiver> = _receiversDic[url];
			if (receivers)
			{
				var index:int;
				if (receiver)
				{
					index = receivers.indexOf(receiver);
					if (index != -1)
					{
						receivers.splice(index, 1);
					}
				}
				if (receivers && receivers.length == 0 || !receiver)
				{
					delete _receiversDic[url];
					index = _loadingUrls.indexOf(url)
					if (index != -1)
					{
						_loadingUrls.splice(index, 1);
					}
					var loader:ByteArrayLoader = _loaderDic[url];
					if (loader)
					{
						loader.destory();
					}
					delete _loaderDic[url];
				}
			}
		}
	}
}

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.utils.clearInterval;
import flash.utils.getTimer;
import flash.utils.setInterval;

interface IByteArrayLoaderReceiver
{
	function byteArrayReceive(url:String, byteArray:ByteArray, time:int):void;
	function byteArrayProgress(url:String, progress:Number):void;
	function byteArrayError(url:String):void;
}

class ByteArrayLoader
{
	private static const MAX_LOAD_ROUND:int = 5;
	private static const MAX_LOAD_SUB_ROUND:int = 3;
	private static const TIME_OUT:int = 10000;//超时时间，这个时间内没有progress事件，就认为超时了，单位毫秒
	
	private var _receiver:IByteArrayLoaderReceiver;
	private var _loader:URLStream;
	private var _intervalId:int;
	private var _startTime:int;
	
	private var _url:String;
	private var _iRound:int;
	private var _iSubRound:int;
	
	public function ByteArrayLoader(receiver:IByteArrayLoaderReceiver)
	{
		_receiver = receiver;
		_loader = null;
		_intervalId = 0;
	}
	
	public function loadBytes(url:String):void
	{
		_url = url;
		_iRound = 0;
		_iSubRound = 0;
		if(_url=="")
		{
			trace("请检查，有null路径下载请求");
			return
		}
		load();
	}
	
	private function load():void
	{
		++_iSubRound;
		if (_iSubRound >= MAX_LOAD_SUB_ROUND)
		{
			++_iRound;
			_iSubRound = 0;
		}
		_intervalId = setInterval(timeOutHandle, TIME_OUT);
		_loader = new URLStream();
		_loader.addEventListener(Event.COMPLETE, completeHandle, false, 0, true);
		_loader.addEventListener(ProgressEvent.PROGRESS, progressHandle, false, 0, true);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle, false, 0, true);
		_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandle, false, 0, true);
		
		_startTime = getTimer();
		if (_iRound > 0 )
		{
			_loader.load(new URLRequest(_url + "?t=" + _iRound));
		}
		else
		{
			_loader.load(new URLRequest(_url));
		}
	}
	
	private function completeHandle(event:Event):void
	{
		if (_intervalId > 0)
		{
			clearInterval(_intervalId);
		}
		if (_loader)
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandle);
			_loader.removeEventListener(ProgressEvent.PROGRESS, progressHandle);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandle);
		}
		
		var bytes:ByteArray = new ByteArray();
		bytes.endian = Endian.LITTLE_ENDIAN;
		_loader.readBytes(bytes, 0, _loader.bytesAvailable);
		if(_receiver)
		{
			_receiver.byteArrayReceive(_url, bytes, getTimer() - _startTime);
		}
		_receiver = null;
		if (_loader)
		{
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
				trace("close loader error" + e.toString());
			}
			_loader = null;
		}
	}
	
	private function progressHandle(event:ProgressEvent):void
	{
		if (_receiver)
		{
			_receiver.byteArrayProgress(_url, event.bytesLoaded / event.bytesTotal);
		}
		if (_intervalId > 0)
		{
			clearInterval(_intervalId);
		}
		_intervalId = setInterval(timeOutHandle, TIME_OUT);
	}
	
	private function ioErrorHandle(event:IOErrorEvent):void
	{
		trace("加载资源失败"+_url+" in ByteArrayLoaderManager.ioErrorHandle");
		if (_intervalId > 0)
		{
			clearInterval(_intervalId);
		}
		if (_loader)
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandle);
			_loader.removeEventListener(ProgressEvent.PROGRESS, progressHandle);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandle);
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
				trace("close loader error" + e.toString());
			}
			_loader = null;
		}
		
		nextLoad();
	}
	
	private function securityErrorHandle(event:SecurityErrorEvent):void
	{
		if (_intervalId > 0)
		{
			clearInterval(_intervalId);
			_intervalId = 0;
		}
		if (_loader)
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandle);
			_loader.removeEventListener(ProgressEvent.PROGRESS, progressHandle);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandle);
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
				trace("close loader error" + e.toString());
			}
			_loader = null;
		}
		
		nextLoad();
	}
	
	private function timeOutHandle():void
	{
		if (_intervalId > 0)
		{
			clearInterval(_intervalId);
			_intervalId = 0;
		}
		if (_loader)
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandle);
			_loader.removeEventListener(ProgressEvent.PROGRESS, progressHandle);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandle);
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
				trace("close loader error" + e.toString());
			}
			_loader = null;
		}
		
		nextLoad();
	}
	
	private function nextLoad():void
	{
		if (_iRound >= MAX_LOAD_ROUND)
		{
			_receiver.byteArrayError(_url);
		}
		else
		{
			load();
		}
	}
	
	public function destory():void
	{
		_receiver = null;
		if (_loader)
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandle);
			_loader.removeEventListener(ProgressEvent.PROGRESS, progressHandle);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandle);
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
				trace("close loader error");
			}
			_loader = null;
		}
		if (_intervalId > 0)
		{
			clearInterval(_intervalId);
			_intervalId = 0;
		}
	}
}

class PrivateClass{}