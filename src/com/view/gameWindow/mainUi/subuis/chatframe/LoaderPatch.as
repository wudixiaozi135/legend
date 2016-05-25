package com.view.gameWindow.mainUi.subuis.chatframe
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.BitmapData;
	import com.core.bind_t;
	
	/**
	 * @author wqhk
	 * 2014-8-8
	 * 
	 * 先只做简单的图片
	 */
	public class LoaderPatch implements IUrlBitmapDataLoaderReceiver
	{
		private var urls:Array;
		private var result:Object;
		private var callback:bind_t;
		
		public function LoaderPatch()
		{
			
		}
		
		public function destroy():void
		{
			if(callback)
			{
				callback.destroy();
			}
			
			result = null;
			callback = null;
			
//			if(loader)
//			{
//				loader.destroy();
//			}
			urls = null;
//			loader = null;
		}
		
		public function load(urls:Array,callback:bind_t):void
		{
			this.urls = urls;
			result = {};
			if(!urls || urls.length == 0)
			{
				callback.push(result);
				callback.call();
			}
			this.callback = callback;
			
			var loader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
			loader.loadBitmap(urls[0],1);
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			result[url] = bitmapData;
			var index:int = int(info);
			if(info == urls.length)
			{
				callback.push(result);
				callback.call();
			}
			else
			{
				var loader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
				loader.loadBitmap(urls[index],index+1);
			}
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
	}
}