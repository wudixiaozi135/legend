package com.view.gameWindow.scene.effect.item.delay
{
	import com.view.gameWindow.scene.effect.item.interf.IEffectBase;
	import com.view.gameWindow.scene.effect.item.interf.IScenePathEffect;
	import com.view.gameWindow.scene.effect.item.sceneEffect.ScenePathEffect;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	
	import flash.geom.Point;

	public class DelayScenePathEffect extends DelayEffect
	{
		private var _speed:int;
		private var _launcher:ILivingUnit;
		private var _launcherPos:Point;
		private var _targets:Vector.<ILivingUnit>;
		private var _groundPos:Point;
		
		public function DelayScenePathEffect(delay:int, path:String, speed:int, launcher:ILivingUnit, launcherPos:Point, targets:Vector.<ILivingUnit>, groundPos:Point, sound:int)
		{
			super(delay, path, sound);
			_speed = speed;
			_launcher = launcher;
			_launcherPos = launcherPos;
			_targets = targets;
			_groundPos = groundPos;
		}
		
		public override function genEffect():IEffectBase
		{
			var effect:IScenePathEffect = new ScenePathEffect(_path, _speed, _launcher, _launcherPos, _targets, _groundPos);
			return effect;
		}
	}
}