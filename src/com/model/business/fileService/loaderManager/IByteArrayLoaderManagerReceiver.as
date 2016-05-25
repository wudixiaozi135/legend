package com.model.business.fileService.loaderManager
{
	import flash.utils.ByteArray;

	public interface IByteArrayLoaderManagerReceiver
	{
		/**字节数据加载完成<br>在ByteArrayLoaderManager类中调用*/
		function byteArrayReceive(url:String, byteArray:ByteArray):void;
		/**字节数据加载进度<br>在ByteArrayLoaderManager类中调用*/
		function byteArrayProgress(url:String, progress:Number):void;
		/**字节数据加载错误<br>在ByteArrayLoaderManager类中调用*/
		function byteArrayError(url:String):void;
	}
}