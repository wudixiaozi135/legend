package com.view.gameWindow.scene.entity.effect
{
	import com.greensock.TweenLite;
	import com.view.gameWindow.scene.effect.item.EffectBase;
	import com.view.gameWindow.scene.effect.model.EffectImageItem;
	import com.view.gameWindow.scene.entity.effect.interf.IEntityUnPermEffect;
	
	import flash.utils.getTimer;
	
	public class EntityUnPermEffect extends EffectBase implements IEntityUnPermEffect
	{
		protected var _reverse:Boolean;
		protected var _startTime:int;

		public var isTween:Boolean;
		private var _from:TweenLite;
		
		public function EntityUnPermEffect(path:String, reverse:Boolean)
		{
			super(path);
			
			_reverse = reverse;
			_startTime = getTimer();
		}
		
		protected override function repeat():Boolean
		{
			return false;
		}
		
		public override function expire():Boolean
		{
			return _model && _model.ready && _currentFrame >= _model.totalFrame;
		}
		
		public override function updateFrame(timeDiff:int):void
		{
			if (ready())
			{
				var waitTime:int = 0;
				if (_startTime > 0)
				{
					waitTime = getTimer() - _startTime;
					_startTime = 0;
				}
				_frameStartTime += timeDiff + waitTime;
				if(_frameStartTime >= (_model.frameRate - 0.5) * FRAME_TIME)
				{
					_currentFrame += (_frameStartTime + FRAME_TIME * 0.5) / (_model.frameRate * FRAME_TIME);
					_frameStartTime = 0;
					if(_currentFrame >= _model.totalFrame)
					{
						if(repeat())
						{
							_currentFrame = 0;
						}
					}
					if (_currentFrame < _model.totalFrame)
					{
						var imageItem:EffectImageItem = _model.getImageItem(_currentFrame);
						_viewBitmap.bitmapData = imageItem.bitmapData;
						if (_reverse)
						{
							_viewBitmap.x = - (imageItem.offsetX - _model.focusX + _model.offset1X);
							_viewBitmap.scaleX = -1;
						}
						else
						{
							_viewBitmap.x = imageItem.offsetX - _model.focusX + _model.offset1X;
						}
						_viewBitmap.y = imageItem.offsetY - _model.focusY + _model.offset1Y;
					}
				}
				if(isTween && !_from)
				{
					var startX:int = x - _viewBitmap.width*2;
					var startY:int = y - _viewBitmap.height*2;
					_from = TweenLite.from(_viewBitmap,.2,{x:startX,y:startY,scaleX:(_reverse ? -3 : 3),scaleY:3});
				}
			}
		}
		
		public override function destory():void
		{
			if(_from)
			{
				_from.kill();
			}
			_from = null;
			super.destory();
		}
	}
}