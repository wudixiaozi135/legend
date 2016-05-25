package com.view.gameWindow.scene.effect.item.sceneEffect.utils
{
	import com.view.gameWindow.scene.effect.item.sceneEffect.interf.ISceneEffectBase;

	public class SceneEffectUtils
	{
		public static function sortOnY(effect1:ISceneEffectBase, effect2:ISceneEffectBase):Number
		{
			return effect1.pixelY - effect2.pixelY || effect1.pixelX - effect2.pixelX;
		}
	}
}