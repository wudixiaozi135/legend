package com.view.gameWindow.scene.effect.item.sceneEffect
{
	import com.view.gameWindow.scene.effect.item.EffectBase;

	public class SceneGroundRandomSubEffect extends EffectBase
	{
		private var _delay:int;
		
		public function SceneGroundRandomSubEffect(path:String)
		{
			super(path);
		}
		
		public function get delay():int
		{
			return _delay;
		}
		
		public function set delay(value:int):void
		{
			_delay = value;
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