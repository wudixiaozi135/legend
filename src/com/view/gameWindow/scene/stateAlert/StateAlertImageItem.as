package com.view.gameWindow.scene.stateAlert
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.BitmapData;
	
	public class StateAlertImageItem implements IUrlBitmapDataLoaderReceiver
	{
		/*private var _url : String;
		private var _loader : Loader;
		private var _bitmap : Bitmap;*/

		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		
		public function init( url : String ) : void
		{
			/*_url = url;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE , completeHandle );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR , errorHandle );
			var trueUrl:String = VersionToDic.getTrueUrl(url,GlobalInterface.resPath);
			_loader.load( new URLRequest( trueUrl != "" ? trueUrl : _url ),new LoaderContext(true) );*/
			
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		/*private function completeHandle( event : Event ) : void
		{
			_bitmap = _loader.content as Bitmap;
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE , completeHandle );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR , errorHandle );
			
			StateAlertManager.initStateImages( _url , _bitmap.bitmapData );
		}
		
		private function errorHandle( event : IOErrorEvent ) : void
		{
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE , completeHandle );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR , errorHandle );
			
			StateAlertManager.loadImageError( _url );
		}*/
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			StateAlertManager.loadImageError(url);
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			StateAlertManager.initStateImages(url,bitmapData);
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
		}
		
	}
}