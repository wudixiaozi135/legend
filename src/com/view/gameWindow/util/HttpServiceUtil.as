package com.view.gameWindow.util
{
	import com.model.business.flashVars.FlashVarsManager;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class HttpServiceUtil
	{
		private static var inst:HttpServiceUtil;
		private var url:String;
		public static const STEP1:int = 100;
		public static const STEP2:int = 200;
		public static const STEP3:int = 300;
		public static const STEP4:int = 400;
		public static const STEP5:int = 500;
		public static const STEP6:int = 600;
		public static const STEP7:int = 700;
		public static const STEP8:int = 800;
		public static function getInst():HttpServiceUtil
		{
			if(!inst)
			{
				inst = new HttpServiceUtil();
			}
			return inst;
		}
		public function HttpServiceUtil()
		{
			
		}
		
		
		public function sendHttp(type:int,succeed:int):void
		{
			var lastStep:int = FlashVarsManager.getInstance().clientCtep;
			if(type<= lastStep)return;
			var requestVars:URLVariables = new URLVariables(); 
			requestVars.uid = FlashVarsManager.getInstance().uid; 
			requestVars.sid = FlashVarsManager.getInstance().sid; 
			if(requestVars.uid==null||requestVars.sid == null)return;
			requestVars.step = type; 
			requestVars.success = succeed; 
			var request:URLRequest = new URLRequest(); 
			request.url = url?url:currentURL; 
			request.method = URLRequestMethod.GET; 
			request.data = requestVars; 
			for (var prop:String in requestVars) { 
				trace("Sent " + prop + " as: " + requestVars[prop]); 
			} 
			var loader:URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler); 
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler); 
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler); 
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
			try 
			{ 
				loader.load(request); 
			} 
			catch (error:Error) 
			{ 
				trace("Unable to load URL"); 
			} 
		}
		
		private function get currentURL():String
		{    
			return FlashVarsManager.getInstance().httpUrl;
		}
		
		
		private function loaderCompleteHandler(e:Event):void 
		{ 
//			var variables:URLVariables = new URLVariables(e.target.data); 
//			if(variables.success) 
//			{ 
//				trace(variables.path);       
//			} 
		} 
		
		
		private function httpStatusHandler (e:Event):void 
		{ 
			//trace("httpStatusHandler:" + e); 
		} 
		
		
		private function securityErrorHandler (e:Event):void 
		{ 
			trace("securityErrorHandler:" + e); 
		} 
		
		
		private function ioErrorHandler(e:Event):void 
		{ 
			trace("ioErrorHandler: " + e); 
		} 

	}
}