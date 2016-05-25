package com.view.gameWindow.scene.stateAlert
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 * 飘字，以在面板中的偏移位置设计 
	 * @author Administrator
	 * 
	 */	
	
	public class StateAlertEx extends Bitmap
	{
		private var _moveXFrom : Number;
		private var _moveXTo : Number;
		private var _moveYFrom : Number;
		private var _moveYTo : Number;
		
		private var _zoomXFrom : Number;
		private var _zoomXTo : Number;
		private var _zoomYFrom : Number;
		private var _zoomYTo : Number;
		
		private var _fadeAlphaFrom : Number;
		private var _fadeAlphaTo : Number;
		
		private var _moveDuration : int;
		private var _zoomDuration : int;
		private var _fadeDuration : int;
		
		private var _totalFrame : int;
		private var _currentFrame : int;
		
		private var _tempBitmapData : BitmapData;
		
		private var _moveOffsetX : Number;
		private var _moveOffsetY : Number;
		private var _zoomOffsetX : Number;
		private var _zoomOffsetY : Number;
		private var _fadeOffsetAlpha : Number;
		
		private var _object : DisplayObjectContainer;
		private var _lastUserTime : Number;
		/**
		 * 
		 * @param bitmapDatas 图像数据
		 * @param overlapPixel 
		 * @param object 飘字面板
		 * @param startX 偏移位置
		 * @param startY 偏移位置
		 * @param moveDuration 移动帧数
		 * @param zoomDuration 缩放帧数
		 * @param fadeDuration 消失帧数
		 * @param zoomFrom 缩放参数：最大
		 * @param zoomTo 缩放参数：最小
		 * 
		 */
		public function init( bitmapDatas : Array, overlapPixel:int , object : DisplayObjectContainer, startX : int , startY : int , moveDuration : int , zoomDuration : int , fadeDuration : int , zoomFrom : Number = 1 , zoomTo : Number = 1 ) : void
		{
			genBitmapData(bitmapDatas, overlapPixel);
			
			_object = object;
			
			_moveXFrom = startX;
			_moveYFrom = startY - 80;
			_moveXTo = _moveXFrom;
			_moveYTo = _moveYFrom - 150;
			
			_zoomXFrom = _zoomYFrom = zoomFrom;
			_zoomXTo = _zoomYTo = zoomTo;
			
			_fadeAlphaFrom = 1.0;
			_fadeAlphaTo = 0;
			
			_moveDuration = moveDuration;
			_zoomDuration = zoomDuration;
			_fadeDuration = fadeDuration;
			
			_moveOffsetX = ( _moveXTo - _moveXFrom ) / _moveDuration;
			_moveOffsetY = ( _moveYTo - _moveYFrom ) / _moveDuration;
			if ( _zoomDuration > 0 )
			{
				_zoomOffsetX = ( _zoomXTo - _zoomXFrom ) / _zoomDuration;
				_zoomOffsetY = ( _zoomYTo - _zoomXFrom ) / _zoomDuration;
			}
			else
			{
				_zoomOffsetX = 0;
				_zoomOffsetY = 0;
			}
			_fadeOffsetAlpha = ( _fadeAlphaTo - _fadeAlphaFrom ) / _fadeDuration; //1秒内消失
			
			enterframe();
			
			_totalFrame = Math.max( _moveDuration , _zoomDuration , _fadeDuration );
			_currentFrame = 0;
		}
		
		private function genBitmapData(bitmapDatas : Array, overlapPixel:int) : void
		{
			if ( bitmapDatas.length > 1 )
			{
				var bitmapWidth : int = overlapPixel * 2;
				var bitmapHeight : int = 0;
				var bd : BitmapData;
				for each ( bd in bitmapDatas )
				{
					bitmapWidth += bd.width - overlapPixel;
					bitmapHeight = Math.max( bitmapHeight , bd.height );
				}
				_tempBitmapData = new BitmapData( bitmapWidth , bitmapHeight , true , 0x00000000 );
				var xPos : int = overlapPixel;
				var point : Point = new Point();
				while ( bitmapDatas.length > 0 )
				{
					bd = bitmapDatas.shift();
					point.x = xPos - overlapPixel;
					_tempBitmapData.copyPixels( bd , bd.rect , point,null,null,true);
					xPos += bd.width - overlapPixel;
				}
				bitmapData = _tempBitmapData;
			}
			else if ( bitmapDatas.length == 1 )
			{
				bitmapData = bitmapDatas[ 0 ];
			}
		}
		
		public function enterframe() : void
		{
			if ( _currentFrame < _zoomDuration )
			{
				scaleX = _zoomXFrom + _zoomOffsetX * _currentFrame;
				scaleY = _zoomYFrom + _zoomOffsetY * _currentFrame;
			}
			if ( _currentFrame < _moveDuration || _currentFrame < _zoomDuration )
			{
				if(_object)
				{
					x = _object.x + _moveXFrom + _moveOffsetX * _currentFrame - bitmapData.width * scaleX / 2.0;
					y = _object.y + _moveYFrom + _moveOffsetY * _currentFrame - bitmapData.height * scaleY / 2.0;
				}
				else
				{
					x =_moveXFrom + _moveOffsetX * _currentFrame - bitmapData.width * scaleX / 2.0;
					y =_moveYFrom + _moveOffsetY * _currentFrame - bitmapData.height * scaleY / 2.0;
				}
			}
			if ( _currentFrame >= _totalFrame - _fadeDuration)
			{
				alpha = Math.max( 0 , 1 + _fadeOffsetAlpha * (_currentFrame -_totalFrame + _fadeDuration) );
			}
			else
			{
				alpha = 1;
			}
			_currentFrame ++;
		}
		
		public function get over() : Boolean
		{
			return _currentFrame >= _totalFrame;
		}
		
		public function get lastUserTime():Number
		{
			return _lastUserTime;
		}
		
		public function set lastUserTime(vaule:Number):void
		{
			_lastUserTime = vaule;
		}
		
		public function destroy() : void
		{
			if ( _tempBitmapData )
			{
				_tempBitmapData.dispose();
				_tempBitmapData = null;
			}
			if (parent)
			{
				parent.removeChild(this);
			}
		}
	}
}