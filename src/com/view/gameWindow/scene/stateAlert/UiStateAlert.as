package com.view.gameWindow.scene.stateAlert
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class UiStateAlert extends Bitmap
	{
		private static const START_ZOOM : int = 5;
		private static const ALPHA_DURATION : int = 3;
		private static const DELAY_FRAME : int = 15;
		private var _startZoom : Number = 0.5;
		private var _startOffsetY : Number;
		private var _startY : int;
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
		private var _startZoomOffsetX : Number;
		private var _startZoomOffsetY : Number;
		private var _timer : int;
		/**
		 * 
		 * @param bitmapDatas 图像数据
		 * @param overlapPixel 
		 * @param startX 偏移位置
		 * @param startY 偏移位置
		 * @param moveDuration 移动帧数
		 * @param zoomDuration 缩放帧数
		 * @param fadeDuration 消失帧数
		 * @param zoomFrom 缩放参数：最大
		 * @param zoomTo 缩放参数：最小
		 * 
		 */		
		public function init( bitmapDatas : Array, overlapPixel:int, startX : int , startY : int , moveDuration : int , zoomDuration : int , fadeDuration : int , zoomFrom : Number = 0.5 , zoomTo : Number = 0.5 ) : void
		{
			genBitmapData(bitmapDatas, overlapPixel);
			
			_moveXFrom = startX;
			_moveYFrom = startY -50;
			_moveXTo = _moveXFrom;
			_moveYTo = _moveYFrom - 80;
			_startY = startY;
			_startOffsetY = (_moveYFrom - _startY) / START_ZOOM;
			
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
				_zoomOffsetY = ( _zoomYTo - _zoomYFrom ) / _zoomDuration;
			}
			else
			{
				_zoomOffsetX = 0;
				_zoomOffsetY = 0;
			}
			if(zoomFrom > _startZoom)
			{
				_startZoomOffsetX = (zoomFrom - _startZoom) / START_ZOOM;
				_startZoomOffsetY = (zoomFrom - _startZoom) / START_ZOOM;
			}
			else
			{
				_startZoomOffsetX = 0;
				_startZoomOffsetY = 0;
			}
			
			_fadeOffsetAlpha = ( _fadeAlphaTo - _fadeAlphaFrom ) / _fadeDuration; //1秒内消失
			
			_currentFrame = 0;
			_totalFrame = Math.max( _moveDuration , _zoomDuration , _fadeDuration );
			
			clearInterval(_timer);
			enterframe();
			_timer = setInterval(enterframe,33);		
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
					try{
					bitmapWidth += bd.width - overlapPixel;
					bitmapHeight = Math.max( bitmapHeight , bd.height );
					}
					catch(e:Error)
					{
						trace(e.message + " in UiStateAlert.genBitmapData");
					}
				}
				_tempBitmapData = new BitmapData( bitmapWidth , bitmapHeight , true , 0x00000000 );
				var xPos : int = overlapPixel;
				var point : Point = new Point();
				while ( bitmapDatas.length > 0 )
				{
					try{
					bd = bitmapDatas.shift();
					point.x = xPos - overlapPixel;
					_tempBitmapData.copyPixels( bd , bd.rect , point ,null,null,true);
					xPos += bd.width - overlapPixel;
					}
					catch(e:Error)
					{
						trace(e.message + " in UiStateAlert.genBitmapData");
					}
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
			if(_currentFrame < START_ZOOM)
			{
				scaleX = _startZoom + _startZoomOffsetX * (_currentFrame);
				scaleY = _startZoom + _startZoomOffsetY * (_currentFrame);
			}
			else if ( _currentFrame - START_ZOOM < _zoomDuration )
			{
				scaleX = _zoomXFrom + _zoomOffsetX * (_currentFrame - START_ZOOM);
				scaleY = _zoomYFrom + _zoomOffsetY * (_currentFrame - START_ZOOM);
			}
			else
			{
				scaleX = _zoomXTo;
				scaleY = _zoomYTo;
			}
			if(_currentFrame < START_ZOOM)
			{
				x = _moveXFrom + _moveOffsetX * _currentFrame - bitmapData.width * scaleX / 2.0;
				y = _startY + _startOffsetY * _currentFrame - bitmapData.height * scaleY / 2.0;
			}
			else if ( (_currentFrame - START_ZOOM) < _moveDuration || (_currentFrame - START_ZOOM) < _zoomDuration )
			{
				x = _moveXFrom + _moveOffsetX * (_currentFrame - START_ZOOM) - bitmapData.width * scaleX / 2.0;
				y = _moveYFrom + _moveOffsetY * (_currentFrame - START_ZOOM) - bitmapData.height * scaleY / 2.0;
			}

			if ( (_currentFrame - START_ZOOM) >= _totalFrame - _fadeDuration)
			{
				alpha = Math.max( 0 , 1 + _fadeOffsetAlpha * (_currentFrame - START_ZOOM -_totalFrame + _fadeDuration) );
			}
			else
			{
				alpha = 1;
			}
			_currentFrame ++;
			if(over)
			{
				destroy();
			}
		}
		
		public function get over() : Boolean
		{
			return _currentFrame >= _totalFrame;
		}
		
		public function destroy() : void
		{
			clearInterval(_timer);
			if ( _tempBitmapData )
			{
				_tempBitmapData.dispose();
				_tempBitmapData = null;
			}
			
			if(parent && parent.contains(this))
			{
				parent.removeChild(this);
			}
		}
	}
}