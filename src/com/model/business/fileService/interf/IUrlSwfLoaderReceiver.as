package com.model.business.fileService.interf
{
	import flash.display.Sprite;

	/**
	 * 资源加载接收者接口
	 * @author Administrator
	 */	
	public interface IUrlSwfLoaderReceiver
	{
		/**加载完成<br>在UrlSwfLoader类中调用*/
		function swfReceive(url:String, swf:Sprite,info:Object):void;
		/**加载进度<br>在UrlSwfLoader类中调用*/
		function swfProgress(url:String, progress:Number,info:Object):void;
		/**加载错误<br>在UrlSwfLoader类中调用*/
		function swfError(url:String,info:Object):void;
	}
}