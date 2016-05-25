package com.view.gameWindow.scene.effect.item.sceneEffect
{
	import com.view.gameWindow.scene.effect.item.sceneEffect.interf.ISceneGroundEffect;

	public class SceneGroundEffect extends SceneEffectBase implements ISceneGroundEffect
	{
		public function SceneGroundEffect(path:String)
		{
			super(path);
		}
		
		protected override function repeat():Boolean
		{
			return false;
		}
		
		public override function expire():Boolean
		{
			return _model && _model.ready && _currentFrame >= _model.totalFrame;
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}