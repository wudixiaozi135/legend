package com.view.gameWindow.scene.stateAlert
{
	import com.greensock.TweenLite;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class StateAlert extends Bitmap
	{
		private static const START_ZOOM : int = 5;
		private static const ALPHA_DURATION : int = 3;
		private static const DELAY_FRAME : int = 15;
		
		private static const DEFAULT_SPEED:Number = 20;
		private static const TOTAL_FRAME:Number = 30;
		private static const TOTAL_MONSTER_FRAME:Number = 90;
		
		private var _currentSpeed:Number;
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
		private var _unit:ILivingUnit;
		
		private var _moveOffsetX : Number;
		private var _moveOffsetY : Number;
		private var _zoomOffsetX : Number;
		private var _zoomOffsetY : Number;
		private var _fadeOffsetAlpha : Number;
		private var _startZoomOffsetX : Number;
		private var _startZoomOffsetY : Number;
		private var _delayFrame : int;
		private var _lastUserTime : Number;
		private var _isDestroy:Boolean;
		
		private var _stateAlertType:int;
		
		public function set stateAlertType(value:int):void
		{
			_stateAlertType = value;
		}

		/**
		 * 初始化
		 * @param bitmapDatas 图像数据
		 * @param overlapPixel 
		 * @param unit 飘字实体
		 * @param startX 偏移位置
		 * @param startY 偏移位置
		 * @param moveDuration 移动帧数
		 * @param zoomDuration 缩放帧数
		 * @param fadeDuration 消失帧数
		 * @param zoomFrom 缩放参数：最大
		 * @param zoomTo 缩放参数：最小
		 */		
		public function init( bitmapDatas : Array, overlapPixel:int, unit:ILivingUnit , startX : int , startY : int , moveDuration : int , zoomDuration : int , fadeDuration : int , zoomFrom : Number = 0.5 , zoomTo : Number = 0.5 ) : void
		{
			_isDestroy=false;
			this.smoothing=true;
			this.pixelSnapping="auto";
			genBitmapData(bitmapDatas, overlapPixel);
			
			_unit = unit;
			_moveXFrom = startX;
			//
			if(startY == 0)
			{
				_moveYFrom = -_unit.modelHeight / 2 - 50;
			}
			else
			{
				_moveYFrom = startY - 50;
			}
			_moveXTo = _moveXFrom;
			_moveYTo = _moveYFrom - 80;
			//
			if(startY == 0)
			{
				_startY = -_unit.modelHeight / 2 + 80;
			}
			else
			{
				_startY = startY + 80;
			}
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
			_delayFrame = 0;
			
			_moveOffsetY = 0;
			_currentSpeed = DEFAULT_SPEED;
			_totalFrame = TOTAL_FRAME;
			
			x = _unit.pixelX + _moveXFrom - bitmapData.width / 2.0;
			y = _unit.pixelY /*+ _startY */- _moveOffsetY - bitmapData.height/2.0;
			if(_stateAlertType == StateAlertType.MONSTER)
			{
				_totalFrame = TOTAL_MONSTER_FRAME;
				
//				x = _unit.pixelX + _moveXFrom - bitmapData.width / 2.0;
//				y = _unit.pixelY /*+ _startY */- _moveOffsetY - bitmapData.height/2.0;
				TweenLite.to(this, .5, {y:"-100",x:"60",onComplete:onComplete});
//				TweenLite.to(this, .5, {x:"60",onComplete:onComplete});
			}
			enterframe();			
		}
		
		private function onComplete():void
		{
			TweenLite.to(this, 2, {y:"100",x:"50",alpha:0,scaleX:.8, scaleY:.8});
//			TweenLite.to(this, 2, );
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
				
				if(bitmapData)
				{
					bitmapData.dispose();
					bitmapData=null;
				}
				if(_tempBitmapData!=null)
				{
					_tempBitmapData.dispose();
					_tempBitmapData=null;
				}
				
				_tempBitmapData = new BitmapData( bitmapWidth , bitmapHeight , true , 0x00000000 );
				var xPos : int = overlapPixel;
				var point : Point = new Point();
				while ( bitmapDatas.length > 0 )
				{
					bd = bitmapDatas.shift();
					point.x = xPos - overlapPixel;
					_tempBitmapData.copyPixels( bd , bd.rect , point ,null,null,true);
					xPos += bd.width - overlapPixel;
				}
				bitmapData = _tempBitmapData;
			}
			else if ( bitmapDatas.length == 1 )
			{
				bitmapData = bitmapDatas[0].clone();
			}
		}
		
		public function enterframe() : void
		{
			if(!_isDestroy&&_stateAlertType != StateAlertType.MONSTER)
			{
				_moveOffsetY += _currentSpeed;
				_currentSpeed *= 0.8;
				var newx:Number = _unit.pixelX + _moveXFrom - bitmapData.width / 2.0-x;
				if(newx<-2)
				{
					x-=2
				}
				else if(newx>2)
				{
					x+=2;
				}else
				{
					x =int(_unit.pixelX + _moveXFrom - bitmapData.width / 2.0);
				}
				y =int(_unit.pixelY + _startY - _moveOffsetY - bitmapData.height / 2.0);
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
			_isDestroy=true;
			TweenLite.killTweensOf(this);
			if(bitmapData)
			{
				bitmapData.dispose();
				bitmapData=null;
			}
			if ( _tempBitmapData )
			{
				_tempBitmapData.dispose();
				_tempBitmapData = null;
			}
		}
	}
}