package com.view.gameWindow.scene.entity.entityItem
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class LivingUnitHpBar extends Sprite implements IUrlBitmapDataLoaderReceiver
	{
		private static var _store:Dictionary = new Dictionary();
		
		private var _bottom:Bitmap;
		private var _hp:Bitmap;
		private var _hpMask:Shape;
		
		private var _loaderB:UrlBitmapDataLoader;
		private var _loaderH:UrlBitmapDataLoader;
		private var _bottomUrl:String;
		private var _hpUrl:String;
		private var _width:int;
		private var _height:int;
		private var _scale:Number = -1;
		private var _anim:TweenLite;
		
		public function LivingUnitHpBar(width:int,height:int,bottomUrl:String,hpUrl:String)
		{
			super();
			
			_bottom = new Bitmap();
			_hp = new Bitmap();
			_width = width;
			_height = height;
//			_hp.width = width;
//			_hp.height = height;
//			_bottom.width = width;
//			_bottom.height = height;
			
			_hpMask = new Shape();
			_hpMask.graphics.beginFill(0xcccccc);
			_hpMask.graphics.drawRect(0, 0, width, height);
			_hpMask.graphics.endFill();
			
			addChild(_bottom);
			addChild(_hp);
			addChild(_hpMask);
			_hp.mask = _hpMask;
			
			_bottomUrl = bottomUrl;
			_hpUrl = hpUrl;
			
			if(_store[_bottomUrl])
			{
				_bottom.bitmapData = _store[_bottomUrl];
			}
			else
			{
				_loaderB = new UrlBitmapDataLoader(this);
				_loaderB.loadBitmap(_bottomUrl,0);
			}
			
			if(_store[_hpUrl])
			{
				_hp.bitmapData = _store[_hpUrl];
			}
			else
			{
				_loaderH = new UrlBitmapDataLoader(this);
				_loaderH.loadBitmap(_hpUrl,1);
			}
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function setValue(value:Number,max:Number,isImmediate:Boolean):void
		{
			var scale:Number = value/max;
			
			if(Math.abs(scale - _scale) < 0.01)
			{
				return;
			}
			
			_scale = scale;
			
			if(_anim)
			{
				_anim.kill();
				_anim = null;
			}
			
			var w:int = int(_scale*_width);
			if(isImmediate)
			{
				_hpMask.width = w;
			}
			else
			{
				_anim = TweenLite.to(_hpMask,1-_scale,{width:w});
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(info == 0)
			{
				_bottom.bitmapData = bitmapData;
				_bottom.width = _width;
				_bottom.height = _height;
			}
			else
			{
				_hp.bitmapData = bitmapData;
				_hp.width = _width;
				_hp.height = _height;
			}
			
			_store[url] = bitmapData;
		}
		
		public function destroy():void
		{
			if(_anim)
			{
				_anim.kill();
				_anim = null;
			}
			
			if(_loaderB)
			{
				_loaderB.destroy();
				_loaderB = null;
			}
			
			if(_loaderH)
			{
				_loaderH.destroy();
				_loaderH = null;
			}
		}
	}
}