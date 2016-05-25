package com.view.gameWindow.panel.panels.keyBuy
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	public class LoadIcon implements IUrlBitmapDataLoaderReceiver
	{
		private var _mc:MovieClip;
		public function LoadIcon()
		{
		}
		
		public function load(mc:MovieClip,url:String):void
		{
			var _urlLoadBitmap:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_mc = mc;
			_urlLoadBitmap.loadBitmap(ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + url + ResourcePathConstants.POSTFIX_PNG);
		}
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			var bitmap:Bitmap = new Bitmap(bitmapData,"auto",true);
			bitmap.width = _mc.width;
			bitmap.height = _mc.height;
			_mc.addChild(bitmap);
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
		}
	}
}