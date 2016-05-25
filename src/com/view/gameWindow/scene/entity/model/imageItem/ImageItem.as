package com.view.gameWindow.scene.entity.model.imageItem
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ImageItem
	{
		private static const SHADOW_MAX_HEIGHT:int = 80;
		
		private var _offsetX:int;
		private var _offsetY:int;
		private var _shadowHeight:int;
		private var _bitmapData:BitmapData;
		private var _baseBitmapData:BitmapData;
		private var _baseOffsetX:int;
		private var _baseOffsetY:int;
		private var _shadow:BitmapData;
		private var _blendType:int;
		
		private var _oriBitmapData:BitmapData;
		private var _bitmapDataOffsetX:int;
		private var _bitmapDataOffsetY:int;
		private var _bitmapDataWidth:int;
		private var _bitmapDataHeight:int;
		
		public function initBySymItem(imageItem:ImageItem, width:int):void
		{
			var bitmapWidth:int;
			var bitmapHeight:int;
			var symMatrix:Matrix;
			if (imageItem.bitmapData)
			{
				bitmapWidth = imageItem.bitmapData.width;
				bitmapHeight = imageItem.bitmapData.height;
				
				_bitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0x00000000);
				symMatrix = new Matrix(-1, 0, 0, 1, bitmapWidth, 0);
				_bitmapData.draw(imageItem.bitmapData, symMatrix, null, null, null, true);
				_offsetX = width - bitmapWidth - imageItem.offsetX;
			}
			_offsetY = imageItem.offsetY;
			_shadowHeight = imageItem.shadowHeight;
			if (imageItem.baseBitmapData)
			{
				bitmapWidth = imageItem.baseBitmapData.width;
				bitmapHeight = imageItem.baseBitmapData.height;
				
				_baseBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0x00000000);
				symMatrix = new Matrix(-1, 0, 0, 1, bitmapWidth, 0);
				_baseBitmapData.draw(imageItem.baseBitmapData, symMatrix, null, null, null, true);
				_baseOffsetX = width - bitmapWidth - imageItem.baseOffsetX;
			}
			_baseOffsetY = imageItem.baseOffsetY;
		}
		
		public function initByBitmapData(bitmapData:BitmapData, offsetX:int, offsetY:int, baseBitmapData:BitmapData, baseOffsetX:int, baseOffsetY:int, shadowHeight:int):void
		{
			_bitmapData = bitmapData;
			_offsetX = offsetX;
			_offsetY = offsetY;
			_baseBitmapData = baseBitmapData;
			_baseOffsetX = baseOffsetX;
			_baseOffsetY = baseOffsetY;
			_shadowHeight = shadowHeight;
		}
		
		public function initByOriBitmapData(oriBitmapData:BitmapData, bitmapDataOffsetX:int, bitmapDataOffsetY:int, bitmapDataWidth:int, bitmapDataHeight:int, offsetX:int, offsetY:int, baseOffsetX:int, baseOffsetY:int, shadowHeight:int):void
		{
			_oriBitmapData = oriBitmapData;
			_bitmapDataOffsetX = bitmapDataOffsetX;
			_bitmapDataOffsetY = bitmapDataOffsetY;
			_bitmapDataWidth = bitmapDataWidth;
			_bitmapDataHeight = bitmapDataHeight;
			_offsetX = offsetX;
			_offsetY = offsetY;
			_baseOffsetX = baseOffsetX;
			_baseOffsetY = baseOffsetY;
			_shadowHeight = shadowHeight;
		}
		
		public function get offsetX():int
		{
			return _offsetX;
		}
		
		public function get offsetY():int
		{
			return _offsetY;
		}
		
		public function get baseOffsetX():int
		{
			return _baseOffsetX;
		}
		
		public function get baseOffsetY():int
		{
			return _baseOffsetY;
		}
		
		public function get shadowHeight():int
		{
			return _shadowHeight;
		}
		
		public function get bitmapData():BitmapData
		{
			if (!_bitmapData)
			{
				genBitmapDataFromOri();
			}
			return _bitmapData;
		}
		
		public function get baseBitmapData():BitmapData
		{
			if (!_baseBitmapData)
			{
				genBitmapDataFromOri();
			}
			return _baseBitmapData;
		}
		
		public function get shadow():BitmapData
		{
			if (_baseBitmapData)
			{
				if (!_shadow)
				{
					var bitmapdata1:BitmapData = new BitmapData(_baseBitmapData.width, _shadowHeight, true, 0xFFFFFF);
					var sprite:Sprite = new Sprite();
					var matrix:Matrix = new Matrix();
					matrix.createGradientBox(_baseBitmapData.width, SHADOW_MAX_HEIGHT, Math.PI * 3.0 / 2.0);
					sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000, 0x000000, 0x000000], [1.0, 0.8, 0.3, 0.0], [0, 64, 128, 255], matrix);
					sprite.graphics.drawRect(0, 0, _baseBitmapData.width, _shadowHeight);
					sprite.graphics.endFill();
					matrix.identity();
					matrix.translate(0, _shadowHeight - SHADOW_MAX_HEIGHT);
					bitmapdata1.draw(sprite, matrix);
					sprite.graphics.clear();
					bitmapdata1.copyChannel(_baseBitmapData, _baseBitmapData.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
					var bitmapdata2:BitmapData = bitmapdata1.clone();
					bitmapdata2.threshold(bitmapdata1, bitmapdata1.rect, new Point(0, 0), "<", 0x00200000, 0x00000000, 0x00FF0000, true);
					_shadow = bitmapdata1;
					_shadow.fillRect(_shadow.rect, 0x00000000);
					_shadow.copyChannel(bitmapdata2, bitmapdata2.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
					bitmapdata2.dispose();
					var bitmapFilter:BlurFilter = new BlurFilter(15, 15);
					_shadow.applyFilter(_shadow, _shadow.rect, new Point(0, 0), bitmapFilter);
				}
			}
			return _shadow;
		}
		
		public function get blendType():int
		{
			return _blendType;
		}
		
		public function set blendType(value:int):void
		{
			_blendType = value;
		}
		
		public function get ready():Boolean
		{
			return _bitmapData != null || _oriBitmapData != null;
		}
		
		private function genBitmapDataFromOri():void
		{
			var newBitmapData:BitmapData = new BitmapData(_bitmapDataWidth, _bitmapDataHeight, true, 0x00000000);
			newBitmapData.copyPixels(_oriBitmapData, new Rectangle(_bitmapDataOffsetX, _bitmapDataOffsetY, _bitmapDataWidth, _bitmapDataHeight), new Point(), null, null, true);
			_bitmapData = _baseBitmapData = newBitmapData;
		}
		
		public function destroy():void
		{
			if (_bitmapData)
			{
				_bitmapData.dispose();
				_bitmapData = null;
			}
			if (_baseBitmapData)
			{
				_baseBitmapData = null;
			}
			if (_shadow)
			{
				_shadow.dispose();
				_shadow = null;
			}
		}
	}
}