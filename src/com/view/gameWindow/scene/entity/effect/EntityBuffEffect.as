package com.view.gameWindow.scene.entity.effect
{
	import com.view.gameWindow.scene.effect.model.EffectImageItem;
	import com.view.gameWindow.scene.effect.model.SceneEffectModel;
	import com.view.gameWindow.scene.effect.model.SceneEffectModelsManager;
	import com.view.gameWindow.scene.entity.effect.interf.IEntityBuffEffect;
	import com.view.gameWindow.util.UtilType2BlendModel;
	
	import flash.display.Bitmap;

	public class EntityBuffEffect extends EntityPermanentEffect implements IEntityBuffEffect
	{
		protected var _hitModel:SceneEffectModel;
		
		protected var _currentModel:SceneEffectModel;
		
		public function EntityBuffEffect(modelPath:String, hitModelPath:String)
		{
			super(modelPath);
			if (hitModelPath)
			{
				_hitModel = SceneEffectModelsManager.getInstance().getAndUseSceneEffectModel(hitModelPath)
			}
		}
		
		public override function ready():Boolean
		{
			if (!_ready && _model && _model.ready && _hitModel && _hitModel.ready)
			{
				_ready = true;
				_frameStartTime = (_model.frameRate - 0.5) * FRAME_TIME;
				_currentFrame = -1;
				
				_viewBitmap = new Bitmap();
				_viewBitmap.blendMode = UtilType2BlendModel.getBlendModel(_model.blendModeType);
				addChild(_viewBitmap);
				
				_currentModel = _model;
			}
			return _ready;
		}
		
		public function hit():void
		{
			if (ready())
			{
				changeModel(_hitModel);
			}
		}
		
		private function changeModel(model:SceneEffectModel):void
		{
			_currentModel = model;
			_frameStartTime = (_currentModel.frameRate - 0.5) * FRAME_TIME;
			_currentFrame = 0;
		}
		
		public override function updateFrame(timeDiff:int):void
		{
			if (ready())
			{
				_frameStartTime += timeDiff;
				if(_frameStartTime >= (_currentModel.frameRate - 0.5) * FRAME_TIME)
				{
					_frameStartTime = 0;
					_currentFrame++;
					if(_currentFrame >= _currentModel.totalFrame)
					{
						if (_currentModel == _hitModel)
						{
							changeModel(_model);
						}
						else if(repeat())
						{
							_currentFrame = 0;
						}
					}
					if (_currentFrame < _currentModel.totalFrame)
					{
						var imageItem:EffectImageItem = _currentModel.getImageItem(_currentFrame);
						_viewBitmap.bitmapData = imageItem.bitmapData;
						_viewBitmap.x = imageItem.offsetX - _currentModel.focusX;
						_viewBitmap.y = imageItem.offsetY - _currentModel.focusY;
					}
				}
			}
		}
		
		public override function destory():void
		{
			super.destory();
			SceneEffectModelsManager.getInstance().unUseModel(_hitModel);
			_hitModel = null;
		}
	}
}