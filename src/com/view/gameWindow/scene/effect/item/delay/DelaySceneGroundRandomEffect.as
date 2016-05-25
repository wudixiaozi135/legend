package com.view.gameWindow.scene.effect.item.delay
{
	import com.view.gameWindow.scene.effect.item.interf.IEffectBase;
	import com.view.gameWindow.scene.effect.item.sceneEffect.SceneGroundRandomEffect;
	import com.view.gameWindow.scene.effect.item.sceneEffect.interf.ISceneGroundRandomEffect;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	
	import flash.geom.Point;

	public class DelaySceneGroundRandomEffect extends DelayEffect
	{
		protected var _target:ILivingUnit;
		protected var _pos:Point;
		
		public function DelaySceneGroundRandomEffect(delay:int, path:String, sound:int, target:ILivingUnit, pos:Point)
		{
			super(delay, path, sound);
			
			_target = target;
			_pos = pos;
		}
		
		public override function genEffect():IEffectBase
		{
			var effect:ISceneGroundRandomEffect = new SceneGroundRandomEffect(_path);
			if (_target && _target.isShow)
			{
				effect.tileX = _target.tileX;
				effect.tileY = _target.tileY;
			}
			else
			{
				effect.tileX = _pos.x;
				effect.tileY = _pos.y;
			}
			
			return effect;
		}
	}
}