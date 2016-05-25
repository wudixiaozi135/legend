package com.view.gameWindow.common
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	
	import flash.display.Sprite;
	
	internal class SwfLoadImpl implements IUrlSwfLoaderReceiver
	{
		internal var load:UrlSwfLoader;
		public function loadSwf(url:String):void
		{
			load=new UrlSwfLoader(this);
			load.loadSwf(url);
		}
		public var callBack:Function;
		public var destroy:Function;
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			if(callBack!=null)
			{
				callBack(swf);
			}
			load&&load.destroy();
			load=null;
			destroy(this);
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function swfError(url:String, info:Object):void
		{
			load&&load.destroy();
			load=null;
			destroy(this);
		}
	}
}