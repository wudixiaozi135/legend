package com.view.gameWindow.panel.panels.unlock
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class ExperiencePanel extends PanelBase implements IUrlBitmapDataLoaderReceiver
	{
		public static const VIP:int = 1;
		
		private var _loader:UrlBitmapDataLoader;
		private var _img:Bitmap;
		private var _rect:Rectangle;
		private var _anim:TweenLite;
		private var _hl:HighlightEffectManager;
		
		public function ExperiencePanel()
		{
			super();
			
			_img = new Bitmap;
			_hl = new HighlightEffectManager();
		}
		
		public function getType():int
		{
			if(args && args.length)
			{
				return args[0];
			}
			return 0;
		}
		
		public function getCloseCallback():Function
		{
			if(args && args.length)
			{
				return args[1];
			}
			return null;
		}
		
		public function getUrl():String
		{
			var type:int = getType();
			
			if(type == VIP)
			{
				return ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"unlock/vip_exp"+ResourcePathConstants.POSTFIX_PNG;
			}
			
			return "";
		}
		
		override protected function initSkin():void
		{
			_skin = new MovieClip;
			_loader = new UrlBitmapDataLoader(this);
			_loader.loadBitmap(getUrl());
			addChild(_img);
		}
		
		private var closeId:int = 0;
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			_img.alpha = 0;
			_img.bitmapData = bitmapData;
			
			if(_anim)
			{
				_anim.kill();
				_anim = null;
			}
			_anim = TweenLite.to(_img,1,{alpha:1,onComplete:showAnimComplete});
			
			if(closeId)
			{
				clearTimeout(closeId);
				closeId = 0;
			}
			closeId = setTimeout(close,5000);
			
			setPostion();
		}
		
		private function showAnimComplete():void
		{
			_hl.show(this,_img);
		}
		
		private function close():void
		{
			var callback:Function = getCloseCallback();
			
			if(callback != null)
			{
				var type:int = getType();
				callback(type);
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		override public function getPanelRect():Rectangle
		{
			if(!_rect)
			{
				_rect = new Rectangle(0,0,_img.width,_img.height);
			}
			
			_rect.width = _img.width;
			_rect.height = _img.height;
			return _rect;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			if(closeId)
			{
				clearTimeout(closeId);
				closeId = 0;
			}
			
			if(_loader)
			{
				_loader.destroy();
				_loader = null;
			}
			
			if(_anim)
			{
				_anim.kill();
				_anim = null;
			}
			
			if(_hl)
			{
				_hl.hide(_img);
				_hl = null;
			}
		}
		
	}
}