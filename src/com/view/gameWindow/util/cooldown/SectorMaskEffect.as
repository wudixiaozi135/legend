package com.view.gameWindow.util.cooldown
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 扇形遮罩特效类<br>缓动显示
	 * @author Administrator
	 * 
	 */	
	public class SectorMaskEffect
	{
		/**目标*/
		private var _target:DisplayObject;
		/**持续时间*/
		private var _duration:int;
		/**初始角度*/
		private var _initAngle:Number;
		/**完成角度*/
		private var _overAngle:Number;
		/**是否正在播放特效*/
		private var _isPlaying:Boolean;
		/**遮罩(_target被遮罩),在此遮罩上绘制不断改变的扇形,以达到特效效果.*/
		private var _mask:Shape;
		/**扇形的半径*/
		private var _radius:Number;
		/**扇形的中心点X坐标*/
		private var _centerX:Number;
		/**扇形的中心点Y坐标*/
		private var _centerY:Number;
		/**开始时间*/
		private var _startTime:int;
		/**上一次绘制扇形的角度*/
		private var _lastAngle:Number;
		/**冷却特效显示完成时的回调*/
		private var _completeCallback:Function;
		/**上一次进行回执的时刻*/
		private var _lastDraw:int;
		/**跳过的时间*/
		private var _jumpTime:int;

		/**是否正在播放特效*/
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		public function SectorMaskEffect(target:DisplayObject, completeCallback:Function = null)
		{
			_target = target;
			
			_mask = new Shape();
			_mask.x = _target.x;
			_mask.y = _target.y;
			
			_target.parent.addChild(_mask);
			_target.mask = _mask;
			
			_radius = Math.sqrt(_target.width * _target.width + _target.height * _target.height) / 2;
			_centerX = _target.width / 2;
			_centerY = _target.height / 2;
			
			_completeCallback = completeCallback;
		}
		/**
		 * 播放扇形遮罩特效
		 * @param duration 持续时间（值为0时无缓动效果）
		 * @param initAngle 初始角度
		 * @param overAngle 完成角度
		 */		
		public function play(duration:int, initAngle:Number = 0, overAngle:Number = 0):void
		{
			if(duration < 0)
			{
				return;
			}
			
			if(_target)
			{
				if(!_isPlaying)
				{
					_isPlaying = true;
					
					_duration = duration;
					_initAngle = initAngle;
					_overAngle = overAngle;
					_startTime = getTimer();
					_lastAngle = initAngle;
					_lastDraw -= _jumpTime;
					_jumpTime = 0;
					
					_mask.graphics.beginFill(16711680, 0.5);
					_target.addEventListener(Event.ENTER_FRAME, onFrame);
					trace("SectorMaskEffect.play(duration, initAngle, overAngle) 播放特效，_isInverse："+(initAngle > overAngle));
				}
			}
		}
		/**
		 * 若播放中调用，则会根据duration值重新计算播发速度<br>非播放中调用无效
		 * @param duration 持续时间（值为0时无缓动效果）
		 */		
		public function setDuration(duration:int):void
		{
			if(duration < 0 || _duration == duration)
			{
				return;
			}
			
			if(_target)
			{
				if(_isPlaying)
				{
					_startTime = (1-duration/_duration)*nowTime + duration/_duration*_startTime;
					_duration = duration;
				}
			}
		}
		/**
		 * 跳至某个值播放扇形遮罩特效
		 * @param jumpAngle 要跳至的角度
		 */		
		public function jumpTo(jumpAngle:int):void
		{
			if(!_target)
			{
				return;
			}
			if(!_isPlaying)
			{
				return;
			}
			if(jumpAngle <= _lastAngle)
			{
				return;
			}
			ShapeDraw.drawFan(_mask.graphics, _radius, _lastAngle, jumpAngle, _centerX, _centerY, 10);
			_jumpTime += _duration*(jumpAngle - _lastAngle)/(_overAngle - _initAngle);
			_lastAngle = jumpAngle;
			_lastDraw = nowTime;
			/*trace("SectorMaskEffect.jumpTo(jumpAngle) _lastDraw:"+_lastDraw);*/
		}
		
		protected function onFrame(event:Event):void
		{
			var interval:int = nowTime - _lastDraw;
			if(interval < 100)
			{
				return;
			}
			
			interval = nowTime - _startTime;
			if(_duration == 0 || _initAngle == _overAngle || interval >= _duration)
			{
				stop();
				return;
			}
			
			var timePercent:Number = interval / _duration;
			timePercent = (_duration ? (timePercent > 1 ? 1 : timePercent) : 1);
			var endAngle:Number = _initAngle + (_overAngle - _initAngle) * timePercent;
			
			ShapeDraw.drawFan(_mask.graphics, _radius, _lastAngle, endAngle, _centerX, _centerY, 10);
			/*trace("SectorMaskEffect.onFrame(event) _lastAngle:"+_lastAngle+",endAngle:"+endAngle);*/
			_lastAngle = endAngle;
			_lastDraw = nowTime;
			/*trace("SectorMaskEffect.onFrame(event) _lastDraw:"+_lastDraw);*/
		}
		
		private function get nowTime():int
		{
			var time:int = getTimer();
			return time + _jumpTime;
		}
		
		/**
		 * 停止特效播放
		 */
		public function stop():void
		{
			if(_isPlaying)
			{
				_isPlaying = false;
				
				_target.removeEventListener(Event.ENTER_FRAME, onFrame);
				
				if(_completeCallback != null)
				{
					_completeCallback();
				}
			}
		}
		
		public function clearGraphics():void
		{
			_mask.graphics.clear();
		}
		
		public function removeMask():void
		{
			_target.mask = null;
			clearGraphics();
			if(_mask.parent)
			{
				_mask.parent.removeChild(_mask);
			}
		}
		
		public function destroy():void
		{
			stop();
			removeMask();
			_target = null;
			_completeCallback = null;
		}
	}
}