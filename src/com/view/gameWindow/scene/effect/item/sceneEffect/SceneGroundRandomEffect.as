package com.view.gameWindow.scene.effect.item.sceneEffect
{
	import com.view.gameWindow.scene.effect.item.sceneEffect.interf.ISceneGroundRandomEffect;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;

	public class SceneGroundRandomEffect extends SceneEffectBase implements ISceneGroundRandomEffect
	{
		private static const SUB_EFFECT_COUNT:int = 8;
		private static const SUB_EFFECT_TIME_LAST:int = 2300;
		private static const SUB_EFFECT_RADIUS:int = 2;
		
		private var _path:String;
		private var _subSkillEffects:Vector.<SceneGroundRandomSubEffect>;
		
		public function SceneGroundRandomEffect(path:String)
		{
			_path = path;
			super(path);
			
			initSubEffects();
		}
		
		private function initSubEffects():void
		{
			_subSkillEffects = new Vector.<SceneGroundRandomSubEffect>();
			var time:int = 0;
			for (var i:int = 0; i < SUB_EFFECT_COUNT; ++i)
			{
				var subEffect:SceneGroundRandomSubEffect = new SceneGroundRandomSubEffect(_path);
				time += SUB_EFFECT_TIME_LAST / SUB_EFFECT_COUNT;
				subEffect.delay = time;
				subEffect.x = (-SUB_EFFECT_RADIUS + Math.random() * SUB_EFFECT_RADIUS * 2) * MapTileUtils.TILE_WIDTH;
				subEffect.y = (-SUB_EFFECT_RADIUS + Math.random() * SUB_EFFECT_RADIUS * 2) * MapTileUtils.TILE_HEIGHT;
				addChild(subEffect);
				_subSkillEffects.push(subEffect);
			}
		}
		
		protected override function repeat():Boolean
		{
			return false;
		}
		
		public override function updateFrame(timeDiff:int):void
		{
			for each (var subEffect:SceneGroundRandomSubEffect in _subSkillEffects)
			{
				if (subEffect.delay > 0)
				{
					subEffect.delay -= timeDiff;
				}
				else
				{
					subEffect.updateFrame(timeDiff);
				}
			}
		}
		
		public override function expire():Boolean
		{
			for each (var subEffect:SceneGroundRandomSubEffect in _subSkillEffects)
			{
				if (!subEffect.expire())
				{
					return false;
				}
			}
			return true;
		}
		
		public override function destory():void
		{
			for each (var subEffect:SceneGroundRandomSubEffect in _subSkillEffects)
			{
				subEffect.destory();
				removeChild(subEffect);
			}
			_subSkillEffects = null;
			super.destory();
		}
	}
}