package com.model.business.fileService.interf
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	/**
	 * 字节数据解析接口
	 * @author Administrator
	 */	
	public interface IBytesSwfLoaderReceiver
	{
		/**解析完成<br>在BytesSwfLoader类中调用*/
		function bytesSwfReceive(bytes:ByteArray, swf:Sprite):void;
		/**解析错误<br>在BytesSwfLoader类中调用*/
		function bytesSwfError(bytes:ByteArray):void;
	}
}