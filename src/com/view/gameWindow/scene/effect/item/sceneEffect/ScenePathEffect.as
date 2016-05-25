package com.view.gameWindow.scene.effect.item.sceneEffect
{
	import com.view.gameWindow.scene.effect.item.interf.IScenePathEffect;
	import com.view.gameWindow.scene.effect.model.EffectImageItem;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	import com.view.gameWindow.util.UtilType2BlendModel;
	
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class ScenePathEffect extends SceneGroundEffect implements IScenePathEffect
	{
		protected var _startTime:int;
		
		protected var _launcherModelHeight:int;
		protected var _targetModelHeight:int;
		
		protected var _launcherModel1Y:int;
		protected var _targetModel2Y:int;
		
		protected var _rotateMatrix:Matrix;
		
		protected var _launcher:ILivingUnit;
		protected var _launcherPos:Point;
		protected var _target:ILivingUnit;
		protected var _groundPos:Point;
		
		protected var _startPixelX:int;
		protected var _startPixelY:int;
		protected var _targetPixelX:int;
		protected var _targetPixelY:int;
		protected var _timeLast:int;
		
		protected var _speed:Number;
		
		public function ScenePathEffect(path:String, speed:int, launcher:ILivingUnit, launcherPos:Point, targets:Vector.<ILivingUnit>, groundPos:Point)
		{
			super(path);
			
			_launcher = launcher;
			_launcherPos = launcherPos;
			if (targets && targets.length == 1)
			{
				_target = targets[0];
			}
			_groundPos = groundPos;
			_speed = speed;
			
			if (_launcher)
			{
				_launcherModelHeight = launcher.modelHeight;
			}
			else
			{
				_launcherModelHeight = 0;
			}
			if (_target)
			{
				_targetModelHeight = _target.modelHeight;
			}
			else
			{
				_targetModelHeight = 0;
			}
			tileX = _launcherPos.x;
			tileY = _launcherPos.y;
			
			_startTime = getTimer();
		}
		
		public override function ready():Boolean
		{
			if (!_ready && _model && _model.ready)
			{
				_ready = true;
				_frameStartTime = (_model.frameRate - 0.5) * FRAME_TIME;
				_currentFrame = -1;
				
				_viewBitmap = new Bitmap();
				_viewBitmap.blendMode = UtilType2BlendModel.getBlendModel(_model.blendModeType);
				addChild(_viewBitmap);
				
				if (_model.offset1Type == 0)
				{
					_launcherModel1Y = 0;
				}
				else if (_model.offset1Type == 1)
				{
					_launcherModel1Y = _launcherModelHeight / 2;
				}
				else if (_model.offset1Type == 2)
				{
					_launcherModel1Y = _launcherModelHeight;
				}
				if (_model.offset2Type == 0)
				{
					_targetModel2Y = 0;
				}
				else if (_model.offset2Type == 1)
				{
					_targetModel2Y = _targetModelHeight / 2;
				}
				else if (_model.offset2Type == 2)
				{
					_targetModel2Y = _targetModelHeight;
				}
				
				var launcherPixelPos:Point = MapTileUtils.tileToPixel(_launcherPos.x, _launcherPos.y);
				var groundPixelPos:Point = MapTileUtils.tileToPixel(_groundPos.x, _groundPos.y);
				_targetPixelX = groundPixelPos.x + _model.offset2X;
				_targetPixelY = groundPixelPos.y - _model.offset2Y;
				_startPixelX = launcherPixelPos.x + _model.offset1X;
				_startPixelY = launcherPixelPos.y - _model.offset1Y;
				
				_timeLast = MapTileUtils.tileDistance(_launcherPos.x, _launcherPos.y, _groundPos.x, _groundPos.y) * MapTileUtils.TILE_WIDTH / _speed * 1000;
				
				var offsetX:int = _targetPixelX - _startPixelX;
				var offsetY:int = _targetPixelY - _startPixelY;
				var angle:Number = Math.atan2(offsetY,offsetX);
				angle -= Math.PI*.5;
				_rotateMatrix = new Matrix();
				_rotateMatrix.rotate(angle);
			}
			return _ready;
		}
		
		protected override function repeat():Boolean
		{
			return true;
		}
		
		public override function expire():Boolean
		{
			return _timeLast > 0 && getTimer() - _startTime >= _timeLast;
		}
		
		public override function updateFrame(timeDiff:int):void
		{
			if (ready())
			{
				_frameStartTime += timeDiff;
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
						
						var currentTime:int = getTimer() - _startTime;
						if (currentTime > _timeLast)
						{
							currentTime = _timeLast;
						}
						var matrix:Matrix = new Matrix();
						var translateMatrix1:Matrix = new Matrix();
						translateMatrix1.translate(imageItem.offsetX - _model.focusX, imageItem.offsetY - _model.focusY);
						var translateMatrix2:Matrix = new Matrix();
						var dx:int = _model.offset1X + (_model.offset2X - _model.offset1X) * currentTime / _timeLast;
						var dy:int = _model.offset1Y - _launcherModel1Y + (_model.offset2Y - _targetModel2Y - _model.offset1Y + _launcherModel1Y) * currentTime / _timeLast;
						translateMatrix2.translate(dx, dy);
						matrix.concat(translateMatrix1);
						matrix.concat(_rotateMatrix);
						matrix.concat(translateMatrix2);
						_viewBitmap.transform.matrix = matrix;
						
						pixelX = (_targetPixelX - _startPixelX) * currentTime / _timeLast + _startPixelX;
						pixelY = (_targetPixelY - _startPixelY) * currentTime / _timeLast + _startPixelY;
					}
				}
			}
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}