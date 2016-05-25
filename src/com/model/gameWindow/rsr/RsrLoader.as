package com.model.gameWindow.rsr
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	/**
	 * 运行时共享资源加载类
	 * @author Administrator
	 */	
	public class RsrLoader
	{
		private var _preUrl:String;
		private var _callBacks:Dictionary;
		private var _rsrLoaderItems:Vector.<RsrLoaderItem>;
		private var _urlPics:Dictionary;
		private var _isNewDomain:Boolean;
		public var noQueue:Boolean = true;
		
		public function RsrLoader()
		{
			_rsrLoaderItems = new Vector.<RsrLoaderItem>();
			_urlPics = new Dictionary();
		}
		
		public function load(view:MovieClip,preUrl:String,isNewDomain:Boolean = false):void
		{
			_preUrl = preUrl;
			_isNewDomain = isNewDomain;
			loopThrough(view);
		}
		/**遍历所有子MC对象*/
		private function loopThrough(view:MovieClip):void
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
							loadRes(resUrl,mc);
						}
						else
						{
							loopThrough(mc);
						}
					}
				}
			}
		}
		/**加载资源*/
		private function loadRes(resUrl:String, mc:MovieClip):void
		{
			var url:String,split:Array,type:int,rsrLoaderItem:RsrLoaderItem;
			url = _preUrl + resUrl;
			split = resUrl.split(".");
			var suffix:String = "."+split[1];
			if(suffix == ResourcePathConstants.POSTFIX_PNG || suffix == ResourcePathConstants.POSTFIX_JPG)
			{
				type = RsrLoaderItem.TYPE_PIC;
			}
			else if(suffix == ResourcePathConstants.POSTFIX_SWF)
			{
				type = RsrLoaderItem.TYPE_SWF;
			}
			if(_urlPics[url] && _rsrLoaderItems.indexOf(_urlPics[url]))
			{
				rsrLoaderItem = _rsrLoaderItems[_urlPics[url]];
			}
			else
			{
				if(type == RsrLoaderItem.TYPE_PIC)
				{
					_urlPics[url] = _rsrLoaderItems.length;
				}
				rsrLoaderItem = new RsrLoaderItem();
				_rsrLoaderItems.push(rsrLoaderItem);
			}
			rsrLoaderItem.init(type,url,mc,_isNewDomain,noQueue);
			if(_callBacks && _callBacks[mc])
			{
				rsrLoaderItem.callBack = _callBacks[mc];
				delete _callBacks[mc];
			}
		}
		
		public function loadItemRes(mc:MovieClip):void
		{
			if(mc)
			{
				if(mc.hasOwnProperty("resUrl"))
				{
					var resUrl:String = mc.resUrl as String;
					loadRes(resUrl,mc);
				}
			}
		}
		/**
		 * 添加回调函数
		 * @param mc触发回调函数的加载元件
		 * @param callBack回调函数,格式function (mc:MovieClip):void
		 */		
		public function addCallBack(mc:MovieClip,callBack:Function):void
		{
			if(!_callBacks)
			{
				_callBacks = new Dictionary();
			}
			_callBacks[mc] = callBack;
		}
		
		public function destroy():void
		{
			_preUrl = null;
			_callBacks = null;
			_urlPics = null;
			var rsrLoaderItem:RsrLoaderItem;
			for each(rsrLoaderItem in _rsrLoaderItems)
			{
				rsrLoaderItem.destroy();
			}
			_rsrLoaderItems = null;
		}
	}
}