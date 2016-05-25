package com.view.newMir
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.business.flashVars.FlashVarsManager;
	import com.view.gameWindow.IGameWindow;
	import com.view.gameWindow.util.HttpServiceUtil;
	
	import flash.display.Sprite;
	
	public class GameWindowLoader implements IUrlSwfLoaderReceiver
	{
		private var _loader:UrlSwfLoader;
		
		public function GameWindowLoader()
		{
		}
		
		public function initData():void
		{
			_loader = new UrlSwfLoader(this);
			/*_loader.loadSwf("GameWindow.swf");*/
			var gameWindow:String = FlashVarsManager.getInstance().gameWindow;
			_loader.loadSwf(gameWindow);
		}
		
		public function swfReceive(url:String, swf:Sprite,info:Object):void
		{
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			mediator.gameWindow = swf as IGameWindow;
			mediator.hideLoading(mediator.loadGwIndex);
			mediator.loadGwIndex = -1;
		}
		
		public function swfProgress(url:String, progress:Number,info:Object):void
		{
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			mediator.setLoading(mediator.loadGwIndex,progress);
		}
		
		public function swfError(url:String,info:Object):void
		{
			trace("GameWindowLoader.swfError 加载失败");
		}
	}
}