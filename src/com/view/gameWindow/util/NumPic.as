package com.view.gameWindow.util
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 获取数字图片工具类
	 * @author Administrator
	 */	
	public class NumPic implements IUrlBitmapDataLoaderReceiver
	{
		private var _urlBitmapDataLoaders:Vector.<UrlBitmapDataLoader>;
		private var _layer:MovieClip;
		private var _layerW:int = -1;
		private var _bitmap:Bitmap;
		private var _picNum:int;
		private var _callBack:Function;
		private var _argument:*;
		
		public var interval:int = -5;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var isCenter:Boolean;
		
		public function NumPic()
		{
		}
		/**
		 * @param url '/'至数字之间的字符串
		 * @param num 要转化为图片的数字
		 * @param layer 父对象
		 */		
		public function init(url:String,num:String,layer:MovieClip,callBack:Function = null,argument:* = null):void
		{
			if(!url || !num || !layer)
			{
				return;
			}
			if(_bitmap)
			{
				_bitmap.bitmapData = null;
			}
			_callBack = callBack;
			_argument = argument;
			_layer = layer;
			_layerW = _layerW == -1 ? _layer.width : _layerW;
			_urlBitmapDataLoaders = new Vector.<UrlBitmapDataLoader>();
			url = ResourcePathConstants.IMAGE_NUMS_FOLDER_LOAD+url+"&x"+ResourcePathConstants.POSTFIX_PNG;
			var arrNum:Array = num.split("");
			if(arrNum && arrNum.length)
			{
				_picNum = arrNum.length;
				var i:int,l:int = arrNum.length;
				for(i=0;i<l;i++)
				{
					var replace:String = url.replace("&x",arrNum[i]);
					var urlBitmapDataLoader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
					urlBitmapDataLoader.loadBitmap(replace,i);
					_urlBitmapDataLoaders.push(urlBitmapDataLoader);
				}
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyLoader(int(info));
			destroyCallBack();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			var index:int = int(info);
			destroyLoader(index);
			if(!_bitmap)
			{
				_bitmap = new Bitmap();
			}
			if(!_bitmap.bitmapData)
			{
				var bmpDt:BitmapData = new BitmapData(_picNum*(bitmapData.width+interval)-interval,bitmapData.height,true,0);
				_bitmap.bitmapData = bmpDt;
			}
			_bitmap.bitmapData.draw(bitmapData,new Matrix(scaleX,0,0,scaleY,index*(bitmapData.width+interval)),null,null,null,true);
			var i:int,l:int = _urlBitmapDataLoaders.length;
			for(i=0;i<l;i++)
			{
				if(_urlBitmapDataLoaders[i])
				{
					return;
				}
			}
			if (_layer)
			{
				while (_layer.numChildren > 0)
				{
					_layer.removeChildAt(_layer.numChildren-1);
				}
				if(isCenter)
				{
					var realRect:Rectangle = _bitmap.bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
					_bitmap.x = (_layerW - realRect.width)*.5;
				}
				_layer.addChild(_bitmap);
				_layer = null;
				if (_callBack != null)
				{
					_argument != null ? _callBack(_argument) : _callBack();
				}
			} 
			destroyCallBack();
		}
		
		public function destroyLoader(i:int):void
		{
			if(_urlBitmapDataLoaders.length > i && _urlBitmapDataLoaders[i])
			{
				_urlBitmapDataLoaders[i].destroy();
				_urlBitmapDataLoaders[i] = null;
			}
		}
		
		public function destroyCallBack():void
		{
			if(_callBack != null)
			{
				_callBack = null;
			}
			if(_argument != null)
			{
				_argument = null;
			}
		}
		
		public function destory():void
		{
			if(_urlBitmapDataLoaders)
			{
				var i:int,l:int = _urlBitmapDataLoaders.length;
				for (i=0;i<l;i++) 
				{
					destroyLoader(i);
				}
			}
			destroyCallBack();
			_layer = null;
		}
	}
}