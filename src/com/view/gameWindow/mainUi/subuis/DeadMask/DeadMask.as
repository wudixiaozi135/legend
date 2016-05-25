package com.view.gameWindow.mainUi.subuis.DeadMask
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.util.Cover;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	/**死亡遮罩面板*/
	public class DeadMask extends Sprite implements  IUrlBitmapDataLoaderReceiver
	{
		private var _picVec:Vector.<BitmapData>;
		private var _cover:Cover;
		private var _loader:UrlBitmapDataLoader;
		private var _intervalId:uint = 0;
		private var _delay:int=1000;
		private var _curIndex:int=0;
		private var _bitmap:Bitmap;
        private var _curCount:int=6;
		
		public function DeadMask():void
		{
			super();
			_picVec = new Vector.<BitmapData>;
			_cover = new Cover(0x000000,0.5);
			addChild(_cover);
			addNumPic();
		}
		
		public function addTimer():void
		{
			changeCount();
			_intervalId = setInterval(changeCount,_delay);
		}
		
		private function addNumPic():void
		{
			if(_loader)
			{
				_loader.destroy();
				_loader = null;
			}
			
			var url:String = ResourcePathConstants.IMAGE_NUMS_FOLDER_LOAD+"dailyPep_"+_curIndex+ResourcePathConstants.POSTFIX_PNG;
			_loader = new UrlBitmapDataLoader(this);
			_curIndex++;
			_loader.loadBitmap(url);
		}
		
		private function changeCount():void
		{
			_curCount--;
			var bmd:BitmapData = _curCount < _picVec.length ? _picVec[_curCount] : null;
			if(_bitmap)
			{
				if(bmd)
				{
					_bitmap.bitmapData = bmd;
					_bitmap.width = bmd.width;
					_bitmap.height = bmd.height;
				}
			}
			else
			{
				if(bmd)
				{
					_bitmap = new Bitmap(bmd,"auto",true);
					_bitmap.width = bmd.width;
					_bitmap.height = bmd.height;
					addChild(_bitmap);
					
					_bitmap.x = stage.stageWidth/2;
					_bitmap.y = stage.stageHeight/2;
				}
			}
			
			if(_curCount == 0)
			{
				clearInterval(_intervalId);
				_intervalId = 0;
				if(_bitmap)
				{
					removeChild(_bitmap);
					_bitmap = null;
				}
				destroyStrengthenLoader();
				MainUiMediator.getInstance().removeMask();
			}
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if (_picVec)
			{
				_picVec.push(bitmapData);
				if(_curIndex <= 5)
				{
					addNumPic();
				}
			}
		}
		
		public function destroyStrengthenLoader():void
		{
			if(_loader)
				_loader.destroy();
			_loader = null;
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
		}
		
		public function destroy():void
		{
			if(_intervalId != 0)
			{
				clearInterval(_intervalId);
				_intervalId = 0;
			}
			
			destroyStrengthenLoader();
			_cover = null;
			_picVec = null;
		}
	}
}