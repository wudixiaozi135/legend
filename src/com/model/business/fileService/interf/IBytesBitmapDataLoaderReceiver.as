package com.model.business.fileService.interf
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public interface IBytesBitmapDataLoaderReceiver
	{
		function bytesBitmapDataReceive(bytes:ByteArray, bitmapData:BitmapData, info:Object):void;
		function bytesBitmapDataError(bytes:ByteArray, info:Object):void;
	}
}