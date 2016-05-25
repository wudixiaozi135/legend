package com.view.gameWindow.scene.entity.model
{
	import com.view.gameWindow.scene.entity.constants.EntityLayerType;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	

	public class EntityModelsManager
	{
		private static var _instance:EntityModelsManager;
		
		private var _models:Vector.<EntityModel>;
		
		private var _firstPlayerModel:EntityModel;
		
		public function EntityModelsManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_models = new Vector.<EntityModel>();
		}
		
		public static function getInstance():EntityModelsManager
		{
			if (!_instance)
			{
				_instance = new EntityModelsManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function getAndUseEntityModel(clothUrl:String, hairUrl:String, largeWingUrl:String, smallWingUrl:String, weaponUrl:String, weaponEffectUrl:String, handEffectUrl:String, shieldUrl:String, nDirection:int):EntityModel
		{
			var model:EntityModel;
			for each (model in _models)
			{
				if (model.isMatch(clothUrl, hairUrl, largeWingUrl, smallWingUrl, weaponUrl, weaponEffectUrl, handEffectUrl, shieldUrl))
				{
					model.nUse ++;
					return model;
				}
			}
			model = null;
			if (!hairUrl && !largeWingUrl && !weaponUrl && !shieldUrl)
			{
				model = new EntitySingleLayerModel(clothUrl, EntityLayerType.CLOTH, nDirection);
			}
			else
			{
				model = new EntityMutiLayersModel(clothUrl, hairUrl, largeWingUrl, smallWingUrl, weaponUrl, weaponEffectUrl, handEffectUrl, shieldUrl, nDirection);
			}
			model.init();
			_models.push(model);
			model.nUse++;
			return model;
		}
		
		public function getAndUseSingleLayerModel(layerUrl:String, layerType:int, nDirection:int):EntitySingleLayerModel
		{
			var clothUrl:String = "";
			var hairUrl:String = "";
			var largeWingUrl:String = "";
			var smallWingUrl:String = "";
			var weaponUrl:String = "";
			var weaponEffectUrl:String = "";
			var handEffectUrl:String = "";
			var shieldUrl:String = "";
			
			if (layerType == EntityLayerType.CLOTH)
			{
				clothUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.HAIR)
			{
				hairUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.LARGEWING)
			{
				largeWingUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.SMALLWING)
			{
				smallWingUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.WEAPON)
			{
				weaponUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.WEAPONEFFECT)
			{
				weaponEffectUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.HANDEFFECT)
			{
				weaponEffectUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.SHIELD)
			{
				shieldUrl = layerUrl;
			}
			var model:EntityModel;
			var singleLayerModel:EntitySingleLayerModel;
			for each (model in _models)
			{
				singleLayerModel = model as EntitySingleLayerModel;
				if (singleLayerModel && singleLayerModel.isMatch(clothUrl, hairUrl, largeWingUrl, smallWingUrl, weaponUrl, weaponEffectUrl, handEffectUrl, shieldUrl))
				{
					singleLayerModel.nUse ++;
					return singleLayerModel;
				}
			}
			singleLayerModel = new EntitySingleLayerModel(layerUrl, layerType, nDirection);
			singleLayerModel.init();
			_models.push(singleLayerModel);
			singleLayerModel.nUse++;
			return singleLayerModel;
		}
		
		public function unUseModel(model:EntityModel):void
		{
			if (!model)
			{
				return;
			}
			model.nUse --;
			if (model.nUse <= 0)
			{
				var index:int = _models.indexOf(model);
				if (index >= 0)
				{
					_models.splice(index, 1);
				}
				model.destroy();
			}
		}
		
		/**
		 * 为了保证玩家自己的Model不被释放而增加的一次引用 
		 * @param value
		 * 
		 */		
		public function set firstPlayerModel(value:EntityModel):void
		{
			if (_firstPlayerModel != value)
			{
				if (_firstPlayerModel)
				{
					unUseModel(_firstPlayerModel);
				}
				_firstPlayerModel = value;
				_firstPlayerModel.nUse ++;
			}
		}
	}
}

class PrivateClass{}