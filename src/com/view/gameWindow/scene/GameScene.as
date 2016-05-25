package com.view.gameWindow.scene
{
	import com.view.gameWindow.panel.panels.guideSystem.view.MapGuideLayerManager;
	import com.view.gameWindow.scene.effect.SceneEffectManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.shake.interf.IShaker;
	import com.view.gameWindow.scene.stateAlert.StateAlertManager;
	
	import flash.display.Sprite;
	
	/**
	 * 游戏场景类<br>用于显示<br>包括地图与实体
	 * @author Administrator
	 */	
	public class GameScene extends Sprite implements IShaker
	{
		private var _mapLayer:Sprite;
		private var _entityLayer:Sprite;
		private var _sceneEffectLayer:Sprite;
		private var _entityLabelLayer:Sprite;
		private var _stateAlertLayer:Sprite;
		private var _mapGuideLayer:Sprite;
		
		public function init():void
		{
			_mapLayer = new Sprite();
			_mapLayer.mouseEnabled = false;
			_mapLayer.mouseChildren = false;
			addChild(_mapLayer);
			_mapGuideLayer = new Sprite();
			_mapGuideLayer.mouseEnabled = false;
			_mapGuideLayer.mouseChildren = false;
			addChild(_mapGuideLayer);
			_entityLayer = new Sprite();
			_entityLayer.mouseEnabled = false;
			_entityLayer.mouseChildren = false;
			addChild(_entityLayer);
			_sceneEffectLayer = new Sprite();
			_sceneEffectLayer.mouseEnabled = false;
			_sceneEffectLayer.mouseChildren = false;
			addChild(_sceneEffectLayer);
			_entityLabelLayer = new Sprite();
			_entityLabelLayer.mouseEnabled = false;
			_entityLabelLayer.mouseChildren = false;
			addChild(_entityLabelLayer);
			_stateAlertLayer = new Sprite();
			_stateAlertLayer.mouseEnabled = false;
			_stateAlertLayer.mouseChildren = false;
			addChild(_stateAlertLayer);
			
			SceneMapManager.getInstance().init(_mapLayer);
			MapGuideLayerManager.getInstance().init(_mapGuideLayer);
			EntityLayerManager.getInstance().init(_entityLayer, _entityLabelLayer);
			SceneEffectManager.instance.init(_sceneEffectLayer);
			StateAlertManager.getInstance().initLayer(_stateAlertLayer);
		}
		
		public function shake(shakeX:int, shakeY:int):void
		{
			_mapLayer.x = _mapGuideLayer.x = _entityLayer.x = _sceneEffectLayer.x = _stateAlertLayer.x = shakeX;
			_mapLayer.y = _mapGuideLayer.y = _entityLayer.y = _sceneEffectLayer.y = _stateAlertLayer.y = shakeY;
		}
		
		public function resetShake():void
		{
			shake(0, 0);
		}
	}
}