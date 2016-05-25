package com.model.gameWindow.rsr
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getTimer;

	/**
	 * 运行时共享资源加载项类
	 * @author Administrator
	 */	
	internal class RsrLoaderItem implements IUrlBitmapDataLoaderReceiver,IUrlSwfLoaderReceiver
	{
		public static const TYPE_PIC:int = 0;
		public static const TYPE_SWF:int = 1;
		
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _urlSwfLoader:UrlSwfLoader;
		private var _mc:MovieClip;
		private var _mcBmpParents:Vector.<MovieClip>;
		private var _callBacks:Vector.<Function>;
		public function set callBack(value:Function):void
		{
			if(!_callBacks)
			{
				_callBacks = new Vector.<Function>();
			}
			_callBacks.push(value);
		}
		
		public function RsrLoaderItem()
		{
		}
		
		public function init(type:int, url:String, mc:MovieClip, isNewDomain:Boolean = false,noQueue:Boolean = true):void
		{
			if(type == TYPE_PIC)
			{
				var isLodad:Boolean;
				if(!_urlBitmapDataLoader)
				{
					_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
					_urlBitmapDataLoader.loadBitmap(url,null,noQueue);
//					trace("RsrLoaderItem.init(type, url, mc, isNewDomain, noQueue) 加载PIC："+url);
					isLodad = true;
				}
				if(!_mcBmpParents)
				{
					_mcBmpParents = new Vector.<MovieClip>();
				}
				_mcBmpParents.push(mc);
//				!isLodad ? trace("RsrLoaderItem.init(type, url, mc, isNewDomain, noQueue) 重复PIC："+url) : null;
			}
			else if(type == TYPE_SWF)
			{
				_urlSwfLoader = new UrlSwfLoader(this);
				_urlSwfLoader.loadSwf(url,null,isNewDomain);
				_mc = mc;
//				trace("RsrLoaderItem.init(type, url, mc, isNewDomain, noQueue) 加载SWF："+url);
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			trace("加载图片出错，"+url);
			destroy();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			var time:int = getTimer();
			var mc:MovieClip;
			for each(mc in _mcBmpParents)
			{
				if(mc)
				{
					var bitmap:Bitmap = new Bitmap(bitmapData.clone(),"auto",true);
					bitmap.width = mc.width;
					bitmap.height = mc.height;
					mc.scaleX = 1;
					mc.scaleY = 1;
					mc.addChild(bitmap);
					mc.removeChildAt(0);
					mc.mouseEnabled = false;
				}
			}
			doCallBack(TYPE_PIC);
			destroy();
		}
		
		public function swfError(url:String, info:Object):void
		{
			trace("加载SWF出错，"+url);
			destroy();
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			if(_mc)
			{
				var movieClip:MovieClip = swf.getChildAt(0) as MovieClip;
				movieClip.width = _mc.width;
				movieClip.height = _mc.height;
				movieClip.x = _mc.x;
				movieClip.y = _mc.y;
				movieClip.visible = _mc.visible;
				movieClip.filters = _mc.filters;
				/*movieClip.mouseChildren = _mc.mouseChildren;
				movieClip.mouseEnabled = _mc.mouseEnabled;*/
				if (_mc.parent)
				{
					var index:int = _mc.parent.getChildIndex(_mc);
					_mc.parent.addChildAt(movieClip,index);
					_mc.parent.removeChild(_mc);
					movieClip.parent[_mc.name] = movieClip;
					_mc = movieClip;
				}
			}
			doCallBack(TYPE_SWF);
			destroy();
		}
		
		private function doCallBack(type:int):void
		{
			if(!_callBacks)
			{
				return;
			}
			if(type == TYPE_SWF)
			{
				if(_callBacks.length && _callBacks[0])
				{
					_callBacks[0](_mc);
					_callBacks[0] = null;
				}
			}
			else if(type == TYPE_PIC)
			{
				var i:int,l:int = _callBacks.length;
				for (i=0;i<l;i++) 
				{
					var mc:MovieClip = _mcBmpParents && _mcBmpParents.length > i ? _mcBmpParents[i] : null;
					if(_callBacks[i] && mc)
					{
						_callBacks[i](mc);
						_callBacks[i] = null;
					}
				}
			}
		}
		
		public function destroy():void
		{
			_mcBmpParents = null;
			_mc = null;
			if(_callBacks != null)
			{
				_callBacks = null;
			}
			if(_urlBitmapDataLoader)
			{
				_urlBitmapDataLoader.destroy();
				_urlBitmapDataLoader = null;
			}
			if(_urlSwfLoader)
			{
				_urlSwfLoader.destroy();
				_urlSwfLoader = null;
			}
		}
	}
}