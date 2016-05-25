package com.view.gameWindow.util
{
	import com.model.business.flashVars.FlashVarsManager;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;

	public class FileUtil
	{
		private static var inst:FileUtil;
		public static function getInst():FileUtil
		{
			if(!inst)
			{
				inst = new FileUtil();
			}
			return inst;
		}
		public function FileUtil()
		{
			
		}
		
		private var downloadURL:URLRequest;
		private var fileName:String;
		private var file:FileReference;
		
		public function loadSmart():void
		{
			file= new FileReference();
			downloadURL = new URLRequest();
			fileName = StringConst.DOWNLOAD_NAME;
			var url:String = FlashVarsManager.getInstance().smartUrl;
			if(url)
			{
				downloadURL.url = url;
			}
			else
			{
//				downloadURL.url = "http://res.cqll.g.yx-g.cn/mini/cqll.exe";
				return;
			}
			file = new FileReference();
			configureListeners(file);
			file.download(downloadURL, fileName);
		}
		

		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CANCEL, cancelHandler);
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(Event.SELECT, selectHandler);
		}
		
		private  function cancelHandler(event:Event):void {
			trace("cancelHandler: " + event);
		}
		
		private function completeHandler(event:Event):void {
			trace("completeHandler: " + event);
			PanelMediator.instance.closePanel(PanelConst.TYPE_SMART_LOAD);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var file:FileReference = FileReference(event.target);
			trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function selectHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			trace("selectHandler: name=" + file.name + " URL=" + downloadURL.url);
		}

	}
}