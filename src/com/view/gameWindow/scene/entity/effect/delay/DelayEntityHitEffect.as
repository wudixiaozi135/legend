package com.view.gameWindow.scene.entity.effect.delay
{
	import com.view.gameWindow.scene.effect.item.delay.DelayEffect;
	import com.view.gameWindow.scene.effect.item.interf.IEffectBase;
	import com.view.gameWindow.scene.entity.effect.EntityUnPermEffect;

	public class DelayEntityHitEffect extends DelayEffect
	{
		public function DelayEntityHitEffect(delay:int, path:String, sound:int)
		{
			super(delay, path, sound);
		}
		
		public override function genEffect():IEffectBase
		{
			var effect:IEffectBase = new EntityUnPermEffect(_path, false);
			return effect;
		}
	}
}