package com.view.gameWindow.scene.entity.entityItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.SceneEffectCfgData;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.ISceneAnimation;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.util.UtilType2BlendModel;
	
	public class SceneAnimation extends Unit implements ISceneAnimation
	{
		private var _sceneAnimationCfg:SceneEffectCfgData;
		
		public function SceneAnimation(sceneAnimationCfg:SceneEffectCfgData)
		{
			_sceneAnimationCfg = sceneAnimationCfg;
			_entityId = _sceneAnimationCfg.id;
			pixelX = _sceneAnimationCfg.x;
			pixelY = _sceneAnimationCfg.y;
		}
		
		public override function show():void
		{
			super.show();
			alpha = 1;
			_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(ResourcePathConstants.ENTITY_RES_OTHER_LOAD + _sceneAnimationCfg.url + "/", "", "", "", "", "", "", "", EntityModel.N_DIRECTION_1);
			_direction = Direction.DOWN;
			idle();
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_SCENEANIMATION;
		}
		
		public override function initViewBitmap():void
		{
			super.initViewBitmap();
			if (_viewBitmap && _entityModel)
			{
				_viewBitmap.blendMode = UtilType2BlendModel.getBlendModel(_entityModel.blendModeType);
			}
		}
		
		protected override function get isShowShadow():Boolean
		{
			return false;
		}
		
		public override function isMouseOn():Boolean
		{
			return false;
		}
		
		public override function destory():void
		{
			_sceneAnimationCfg = null;
			super.destory();
		}
	}
}