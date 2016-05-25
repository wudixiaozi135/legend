package com.model.business.fileService
{
	import com.model.business.fileService.interf.IBytesSwfLoaderReceiver;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.business.fileService.loaderManager.ByteArrayLoaderManager;
	import com.model.business.fileService.loaderManager.IByteArrayLoaderManagerReceiver;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	/**
	 * 资源加载类
	 * @author Administrator
	 */	
	public class UrlSwfLoader implements IByteArrayLoaderManagerReceiver, IBytesSwfLoaderReceiver
	{
		private var _url:String;
		private var _info:Object;
		
		private var _receiver:IUrlSwfLoaderReceiver;
		
		private var _bytesSwfLoader:BytesSwfLoader;
		
		private var _bytes:ByteArray;
		
		private var _isNewDomain:Boolean;
		
		public function UrlSwfLoader(receiver:IUrlSwfLoaderReceiver)
		{
			_receiver = receiver;
		}
		
		public function loadSwf(url:String, info:Object = null, isNewDomain:Boolean = false):void
		{
			_url = url;
			_info = info;
			_isNewDomain = isNewDomain;
			ByteArrayLoaderManager.getInstance().loadBytes(_url, this);
		}
		
		public function byteArrayReceive(url:String, byteArray:ByteArray):void
		{
			//字节数据加载完成开始解析
			_bytes = byteArray;
			_bytesSwfLoader = new BytesSwfLoader(this);
			_bytesSwfLoader.loadSwf(_bytes,_isNewDomain);
		}
		
		public function byteArrayProgress(url:String, progress:Number):void
		{
			_receiver.swfProgress(url, progress,_info);
		}
		
		public function byteArrayError(url:String):void
		{
			_receiver.swfError(url,_info);
		}
		
		public function bytesSwfReceive(bytes:ByteArray, swf:Sprite):void
		{
			_receiver.swfReceive(_url, swf,_info);
			_bytesSwfLoader&&_bytesSwfLoader.destroy() ;
			_receiver = null;
		}
		
		public function bytesSwfError(bytes:ByteArray):void
		{
			_receiver.swfError(_url,_info);
			_bytesSwfLoader = null;
			_receiver = null;
		}
		
		public function parse():void
		{
			if (_bytes && !_bytesSwfLoader)
			{
				_bytesSwfLoader = new BytesSwfLoader(this);
				_bytesSwfLoader.loadSwf(_bytes,_isNewDomain);
			}
		}
		
		public function get bytes():ByteArray
		{
			return _bytes;
		}
		
		public function destroy():void
		{
			ByteArrayLoaderManager.getInstance().stopLoad(_url, this);
			if (_bytesSwfLoader)
			{
				_bytesSwfLoader.destroy();
				_bytesSwfLoader = null;
				_bytes = null;
			}
		}
	}
}