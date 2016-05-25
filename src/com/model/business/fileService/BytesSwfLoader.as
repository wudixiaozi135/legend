package com.model.business.fileService
{
	import com.model.business.fileService.interf.IBytesSwfLoaderReceiver;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * 字节数据解析类
	 * @author Administrator
	 */	
	public class BytesSwfLoader
	{
		private var _bytes:ByteArray;
		private var _loader:Loader;
		private var _loaded : Boolean;
		private var _receiver:IBytesSwfLoaderReceiver;
		
		/**
		 * 构建字节数据解析对象
		 * @param receiver 解析完成的接收对象
		 */		
		public function BytesSwfLoader(receiver:IBytesSwfLoaderReceiver)
		{
			_receiver = receiver;
			_loaded = false;
		}
		
		public function loadSwf(bytes:ByteArray,isNewDomain:Boolean = false):void
		{
			_bytes = bytes;
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = isNewDomain ? new ApplicationDomain() : ApplicationDomain.currentDomain;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandle);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandle);
			_loader.loadBytes(_bytes, context);
		}
		private function completeHandle(event:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandle);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandle);
			
			_loaded = true;
			var swf:Sprite = _loader.content as Sprite;
			_loader.unload();
			if (swf)
			{
				_receiver.bytesSwfReceive(_bytes, swf);
			}
			else
			{
				_receiver.bytesSwfError(_bytes);
			}
			_loader = null;
			_bytes = null;
			_receiver = null;
			
		}
		
		private function errorHandle(event:IOErrorEvent):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandle);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandle);
			
			_receiver.bytesSwfError(_bytes);
			
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
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandle);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandle);
				try
				{
					_loader.unloadAndStop(false);
					if(!_loaded)
					{
						_loader.close();
					}					
				}
				catch (error:Error)
				{
					trace(error.message);
				}
				
				_loader = null;
				_bytes = null;
				_receiver = null;
			}
		}
	}
}