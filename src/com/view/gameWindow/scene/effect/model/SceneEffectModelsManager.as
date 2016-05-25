package com.view.gameWindow.scene.effect.model
{
	import flash.utils.getTimer;

	public class SceneEffectModelsManager
	{
		private static const N_MODEL:int = 20;
		private static var _instance:SceneEffectModelsManager;
		
		private var _models:Vector.<SceneEffectModel>;
		
		public static function getInstance():SceneEffectModelsManager
		{
			if(!_instance)
			{
				_instance = new SceneEffectModelsManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function SceneEffectModelsManager(pc:PrivateClass)
		{
			if(!pc)
			{
				throw new Error(this+"该类使用单例模式");
			}
			_models = new Vector.<SceneEffectModel>();
		}
		
		public function getAndUseSceneEffectModel(path:String):SceneEffectModel
		{
			var model:SceneEffectModel;
			for each (model in _models)
			{
				if (model.isMatch(path))
				{
					model.nUse++;
					return model;
				}
			}
			model = new SceneEffectModel(path);
			model.init();
			model.nUse++;
			_models.push(model);
			clearUnUsedModel();
			return model;
		}
		
		public function unUseModel(model:SceneEffectModel):void
		{
			if (model)
			{
				model.nUse--;
				clearUnUsedModel();
			}
		}
		
		private function clearUnUsedModel():void
		{
			while (_models.length > N_MODEL)
			{
				var index:int = -1;
				var endTime:int = getTimer();
				var model:SceneEffectModel;
				for (var i:int = 0; i < _models.length; ++i)
				{
					model = _models[i];
					if (model.nUse <= 0 && model.endTime <= endTime)
					{
						index = i;
					}
				}
				if (index != -1)
				{
					model =_models.splice(index,1)[0];
					model&&model.destroy();
					model=null;
				}
				else
				{
					break;
				}
			}
		}
	}
}
class PrivateClass{}