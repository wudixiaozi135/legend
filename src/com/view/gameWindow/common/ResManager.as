package com.view.gameWindow.common
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/***
	 * 
	 * 简单的加载工具，支持位图和元件的加载
	 * 
	 * */
	public class ResManager implements IUrlBitmapDataLoaderReceiver
	{
		public function ResManager()
		{
			_dic=new Dictionary();
			_loadDic=new Dictionary();
		}
		private var _dic:Dictionary;
		private var _loadDic:Dictionary;
		
		private static var _instance:ResManager;
		
		public static function getInstance():ResManager
		{
			if(_instance==null)
			{
				_instance=new ResManager();
			}
			return _instance;
		}
		/**根据URL获取显示列表中包含对应urlRes的影片剪辑*/
		public function mcByUrl(view:MovieClip,url:String):MovieClip
		{
			var i:int,numChildren:int,j:int,totalFrames:int;
			totalFrames = view.totalFrames;
			numChildren = view.numChildren;
			for(j=1;j<=totalFrames;j++)
			{
				view.gotoAndStop(j);
				for(i=0;i<numChildren;i++)
				{
					var mc:MovieClip = view.getChildAt(i) as MovieClip;
					if(mc)
					{
						if(mc.hasOwnProperty("resUrl"))
						{
							var resUrl:String = mc.resUrl as String;
							var indexOf:int = url.indexOf(resUrl);
							if(indexOf != -1)
							{
								return mc;
							}
						}
						else
						{
							mcByUrl(mc,url);
						}
					}
				}
			}
			return null;
		}
		
		public function loopLoadBitmap(view:MovieClip,preUrl:String,callBack:Function):void
		{
			loopThrough(view,preUrl,callBack);
		}
		/**遍历所有子MC对象*/
		private function loopThrough(view:MovieClip,preUrl:String,callBack:Function):void
		{
			var i:int,numChildren:int,j:int,totalFrames:int;
			totalFrames = view.totalFrames;
			numChildren = view.numChildren;
			for(j=1;j<=totalFrames;j++)
			{
				view.gotoAndStop(j);
				for(i=0;i<numChildren;i++)
				{
					var mc:MovieClip = view.getChildAt(i) as MovieClip;
					if(mc)
					{
						if(mc.hasOwnProperty("resUrl"))
						{
							var resUrl:String = mc.resUrl as String;
							var url:String = preUrl + resUrl;
							loadBitmap(url,callBack);
						}
						else
						{
							loopThrough(mc,preUrl,callBack);
						}
					}
				}
			}
		}
		
		public function loadBitmap(url:String, callBack:Function):void
		{
			if(url=="")return;

			if(_dic[url]==null)
			{
				_dic[url]=[callBack];
				var load:UrlBitmapDataLoader=new UrlBitmapDataLoader(getInstance());
				load.loadBitmap(url);
				_loadDic[url]=load;
			}else
			{
				_dic[url].push(callBack);
			}
		}
			
		public function loadSwf(url:String, pcallBack:Function):void
		{
			if(url=="")return;
			var swfLoad:SwfLoadImpl=new SwfLoadImpl();
			swfLoad.callBack=pcallBack;
			swfLoad.destroy=loadSwfDestroy;
			swfLoad.loadSwf(url);
		}
		
		private function loadSwfDestroy(swfLoad:SwfLoadImpl):void
		{
			swfLoad=null;
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(_dic[url])
			{
				var array:Array=_dic[url] as Array;
				while(array.length>0)
				{
					var callBack:Function =array.shift();
					callBack(bitmapData.clone(),url);
				}
				bitmapData.dispose();
				array=null;
				delete _dic[url];
			}
			
			if(_loadDic[url])
			{
				var load:UrlBitmapDataLoader=_loadDic[url];
				load.destroy();
				load=null;
				delete _loadDic[url];
			}
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			if(_dic[url])
			{
				_dic[url]=null;
				delete _dic[url];
			}
			
			if(_loadDic[url])
			{
				var load:UrlBitmapDataLoader=_loadDic[url];
				load.destroy();
				load=null;
				delete _loadDic[url];
			}
		}
	}
}