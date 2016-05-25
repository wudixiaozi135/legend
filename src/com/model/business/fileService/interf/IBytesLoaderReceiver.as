package com.model.business.fileService.interf
{
	import flash.utils.ByteArray;

	public interface IBytesLoaderReceiver
	{
		function bytesReceive(url:String, bytes:ByteArray, info:Object):void;
		function bytesProgress(url:String, progress:Number, info:Object):void;
		function bytesError(url:String, info:Object):void;
	}
}