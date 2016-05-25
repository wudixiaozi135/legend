package com.view.gameWindow.panel.panels.specialRing.upgrade
{
	import com.greensock.TweenMax;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class TipArrow extends Sprite implements IUrlBitmapDataLoaderReceiver
	{
		private var loader:UrlBitmapDataLoader;
		private var bmp:Bitmap;
		private var tween:TweenMax;
		public function TipArrow()
		{
			super();
			init();
		}
		
		protected function init():void
		{
			loader = new UrlBitmapDataLoader(this);
			loader.loadBitmap(ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"common/tipArrow"+ResourcePathConstants.POSTFIX_PNG);
			mouseEnabled = false;
			mouseChildren = false;
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
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			bmp = new Bitmap(bitmapData);
			bmp.x = -bmp.width/2;
			bmp.y = 0;
			this.addChild(bmp);
			
			tween = TweenMax.to(bmp,0.8,{y:-bmp.height/2,repeat:-1,yoyo:true});
			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
		}
	}
}