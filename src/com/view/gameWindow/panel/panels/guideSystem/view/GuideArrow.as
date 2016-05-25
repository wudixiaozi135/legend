package com.view.gameWindow.panel.panels.guideSystem.view
{
	import com.greensock.TweenMax;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	
	/**
	 * @author wqhk
	 * 2014-10-27
	 */
	public class GuideArrow extends Sprite implements IUrlBitmapDataLoaderReceiver
	{
		private var loader:UrlBitmapDataLoader;
		private var bmp:Bitmap;
		private var tween:TweenMax;
		private var _isDestroy:Boolean;
		public function GuideArrow()
		{
			super();
			init();
			_isDestroy = false;
		}
		
		protected function init():void
		{
			loader = new UrlBitmapDataLoader(this);
			loader.loadBitmap(ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"common/guide_arrow"+ResourcePathConstants.POSTFIX_PNG);
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function set label(value:String):void
		{
			
		}
		
		public function destroy():void
		{
			if(loader)
			{
				loader.destroy();
				loader = null;
			}
			
			if(tween)
			{
				tween.kill();
				tween = null;
			}
			
			_isDestroy = true;
		}
		
		
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			bmp = new Bitmap(bitmapData);
			bmp.x = -bmp.width + 20;
			bmp.y = int(-bmp.height/2);
			this.addChild(bmp);
			
			tween = TweenMax.to(bmp,1,{x:-bmp.width,repeat:-1,yoyo:true});
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}

		public function get isDestroy():Boolean
		{
			return _isDestroy;
		}

	}
}