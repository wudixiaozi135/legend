package com.view.gameWindow.scene.effect.model
{
	import com.model.business.fileService.BytesBitmapDataLoader;
	import com.model.business.fileService.interf.IBytesBitmapDataLoaderReceiver;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class EffectImageItem implements IBytesBitmapDataLoaderReceiver
	{
		private var _offsetX:int;
		private var _offsetY:int;
		private var _bitmapData:BitmapData;
		
		private var _loader:BytesBitmapDataLoader;
		
		public function init(bytes:ByteArray):void
		{
			_offsetX = bytes.readShort();
			_offsetY = bytes.readShort();
			var imgSize:int = bytes.readInt();
			var imgBytes:ByteArray = new ByteArray();
			imgBytes.endian = Endian.LITTLE_ENDIAN;
			bytes.readBytes(imgBytes,0,imgSize);
			if(_loader!=null)
			{
				_loader.destroy();
				_loader=null;
			}
			_loader = new BytesBitmapDataLoader(this);
			_loader.loadBitmap(imgBytes, null, true);
		}
		
		public function bytesBitmapDataReceive(bytes:ByteArray, bitmapData:BitmapData, info:Object):void
		{
			if(_bitmapData!=null)
			{
				_bitmapData.dispose();
			}
			
			if(_loader!=null)
			{
				_bitmapData = bitmapData;
				_loader.destroy();
				_loader = null;
			}else
			{
				bitmapData.dispose();
			}
		}
		
		public function bytesBitmapDataError(bytes:ByteArray, info:Object):void
		{
			trace("解析图片失败 in"+this+".bytesBitmapDataError");
			if (_loader)
			{
				_loader.destroy();
				_loader = null;
			}
		}
		
		public function get offsetX():int
		{
			return _offsetX;
		}
		
		public function get offsetY():int
		{
			return _offsetY;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}
		
		public function get ready():Boolean
		{
			return _bitmapData != null;
		}
		
		public function destroy():void
		{
			if (_bitmapData)
			{
				_bitmapData.dispose();
			}
			_bitmapData = null;
			if (_loader)
			{
				_loader.destroy();
				_loader = null;
			}
		}
	}
}