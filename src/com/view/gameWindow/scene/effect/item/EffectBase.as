package com.view.gameWindow.scene.effect.item
{
	import com.view.gameWindow.scene.effect.item.interf.IEffectBase;
	import com.view.gameWindow.scene.effect.model.EffectImageItem;
	import com.view.gameWindow.scene.effect.model.SceneEffectModel;
	import com.view.gameWindow.scene.effect.model.SceneEffectModelsManager;
	import com.view.gameWindow.scene.viewItem.SceneViewItem;
	import com.view.gameWindow.util.UtilType2BlendModel;
	
	import flash.display.Bitmap;
	
	public class EffectBase extends SceneViewItem implements IEffectBase
	{
		protected var _model:SceneEffectModel;
		protected var _ready:Boolean;
		
		protected var _currentFrame:int;
		protected var _frameStartTime:int;
		
		public function EffectBase(path:String)
		{
			_ready = false;
			_model = SceneEffectModelsManager.getInstance().getAndUseSceneEffectModel(path);
			
			mouseEnabled = false;
			mouseChildren = false;
			
			_frameStartTime = 0;
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
						_viewBitmap.x = imageItem.offsetX - _model.focusX + _model.offset1X;
						_viewBitmap.y = imageItem.offsetY - _model.focusY + _model.offset1Y;
					}
				}
			}
		}
		
		public function ready():Boolean
		{
			if (!_ready && _model && _model.ready)
			{
				_ready = true;
				_frameStartTime = (_model.frameRate - 0.5) * FRAME_TIME;
				_currentFrame = -1;
				
				_viewBitmap = new Bitmap();
				_viewBitmap.blendMode = UtilType2BlendModel.getBlendModel(_model.blendModeType);
				addChild(_viewBitmap);
			}
			return _ready;
		}
		
		protected function repeat():Boolean
		{
			return false;
		}
		
		public function expire():Boolean
		{
			return true;
		}
		
		public override function destory():void
		{
			super.destory();
			SceneEffectModelsManager.getInstance().unUseModel(_model);
			_model = null;
		}
	}
}