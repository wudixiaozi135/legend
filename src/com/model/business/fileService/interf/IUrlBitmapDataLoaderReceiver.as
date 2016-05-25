package com.model.business.fileService.interf
{
	import flash.display.BitmapData;

	public interface IUrlBitmapDataLoaderReceiver
	{
		function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void;
		function urlBitmapDataProgress(url:String, progress:Number, info:Object):void;
		function urlBitmapDataError(url:String, info:Object):void;
	}
}