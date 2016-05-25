package com.view.gameWindow.scene.effect
{
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.TypeInterval;
	import com.view.gameWindow.scene.effect.item.delay.DelayEffect;
	import com.view.gameWindow.scene.effect.item.delay.DelaySceneGroundEffect;
	import com.view.gameWindow.scene.effect.item.delay.DelaySceneGroundRandomEffect;
	import com.view.gameWindow.scene.effect.item.delay.DelayScenePathEffect;
	import com.view.gameWindow.scene.effect.item.sceneEffect.interf.ISceneEffectBase;
	import com.view.gameWindow.scene.effect.item.sceneEffect.utils.SceneEffectUtils;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.ViewTile;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * 场景特效管理者类
	 * @author Administrator
	 */	
	public class SceneEffectManager
	{
		private static var _instance:SceneEffectManager;
		
		private var _effectLayer:Sprite;
		private var _inViewEffects:Vector.<ISceneEffectBase>;
		private var _lastInViewEffects:Vector.<ISceneEffectBase>;
		private var _delayEffects:Vector.<DelayEffect>
		
		public static function get instance():SceneEffectManager
		{
			if(!_instance)
				_instance = new SceneEffectManager(new PrivateClass());
			return _instance;
		}
		
		public function SceneEffectManager(pc:PrivateClass)
		{
			if(!pc)
				throw new Error(this+"该类使用单例模式");
		}
		
		public function init(layer:Sprite):void
		{
			_effectLayer = layer;
			_inViewEffects = new Vector.<ISceneEffectBase>();
			_lastInViewEffects = new Vector.<ISceneEffectBase>();
			_delayEffects = new Vector.<DelayEffect>();
		}
		
		public function onEnterMap():void
		{
			clearEffects(_inViewEffects);
			clearEffects(_lastInViewEffects);
			_lastInViewEffects.length=0;
			_inViewEffects.length = 0;
			_delayEffects.length = 0;
		}
		
		private function clearEffects(iEffects:Vector.<ISceneEffectBase>):void
		{
			// TODO Auto Generated method stub
			while(iEffects!=null&&iEffects.length>0)
			{
				var iEffect:ISceneEffectBase = iEffects.shift();
				iEffect.destory();
				var rubbish:DisplayObject= (iEffect as DisplayObject);
				if(rubbish)
				{
					rubbish.parent&&rubbish.parent.removeChild(rubbish);
				}
				rubbish=null;
			}
		}
		
		public function addPathEffect(skillCfgData:SkillCfgData, launcher:ILivingUnit, launcherPos:Point, targets:Vector.<ILivingUnit>, groundPos:Point):void
		{
			if (skillCfgData.effect_path && skillCfgData.effect_path != "0")
			{
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				var split:Array = skillCfgData.effect_path.split(":");
				if(split.length != 2)
				{
					return;
				}
				var folder:String = split[0];
				var totalDir:int = int(split[1]);
				if(totalDir != 1)
				{
					return;
				}
				var delayEffect:DelayScenePathEffect = new DelayScenePathEffect(skillCfgData.before_interval, folder + "/1", skillCfgData.speed, launcher, launcherPos, targets, groundPos, 0);
				_delayEffects.push(delayEffect);
			}
		}
		
		public function addGroundEffect(skillCfgData:SkillCfgData, launcherPos:Point, targets:Vector.<ILivingUnit>, groundPos:Point):void
		{
			if (skillCfgData.effect_ground && skillCfgData.effect_ground != "0")
			{
				var delay:int = 0;
				if(skillCfgData.after_interval_type == TypeInterval.FIXED)
				{
					delay = skillCfgData.before_interval + skillCfgData.after_interval;
				}
				else if(skillCfgData.after_interval_type == TypeInterval.VARIABLE)
				{
					var tileDist:Number = MapTileUtils.tileDistance(launcherPos.x, launcherPos.y, groundPos.x, groundPos.y);
					if(skillCfgData.speed)
					{
						delay = skillCfgData.before_interval + tileDist * MapTileUtils.TILE_WIDTH / skillCfgData.speed * 1000;
					}
				}
				var split:Array = skillCfgData.effect_ground.split(":");
				if(split.length != 2)
				{
					return;
				}
				var folder:String = split[0];
				var totalDir:int = int(split[1]);
				if(totalDir != 1)
				{
					return;
				}
				var target:ILivingUnit = null;
				if (targets && targets.length == 1)
				{
					target = targets[0];
				}
				var delayEffect:DelaySceneGroundEffect = new DelaySceneGroundEffect(delay, folder + "/1", skillCfgData.sound_hit, target, groundPos);
				_delayEffects.push(delayEffect);
			}
		}
		
		public function addGroundRandomEffect(skillCfgData:SkillCfgData, launcherPos:Point, targets:Vector.<ILivingUnit>, groundPos:Point):void
		{
			if (skillCfgData.effect_ground_random && skillCfgData.effect_ground_random != "0")
			{
				var delay:int = 0;
				if(skillCfgData.after_interval_type == TypeInterval.FIXED)
				{
					delay = skillCfgData.before_interval + skillCfgData.after_interval;
				}
				else if(skillCfgData.after_interval_type == TypeInterval.VARIABLE)
				{
					var tileDist:Number = MapTileUtils.tileDistance(launcherPos.x, launcherPos.y, groundPos.x, groundPos.y);
					if(skillCfgData.speed)
					{
						delay = skillCfgData.before_interval + tileDist * MapTileUtils.TILE_WIDTH / skillCfgData.speed * 1000;
					}
				}
				var split:Array = skillCfgData.effect_ground_random.split(":");
				if(split.length != 2)
				{
					return;
				}
				var folder:String = split[0];
				var totalDir:int = int(split[1]);
				if(totalDir != 1)
				{
					return;
				}
				var target:ILivingUnit = null;
				if (targets.length == 1)
				{
					target = targets[0];
				}
				var delayEffect:DelaySceneGroundRandomEffect = new DelaySceneGroundRandomEffect(delay, folder + "/1", skillCfgData.sound_hit, target, groundPos);
				_delayEffects.push(delayEffect);
			}
		}
		
		public function updateView(timeDiff:int):void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var i:int = 0;
			var effect:ISceneEffectBase;
			for (i = 0; i < _inViewEffects.length;)
			{
				effect = _inViewEffects[i];
				if (effect.expire() || Math.abs(effect.tileX - firstPlayer.tileX) > ViewTile.W || Math.abs(effect.tileY - firstPlayer.tileY) > ViewTile.H)
				{
					_inViewEffects.splice(i, 1);
					effect.destory();
				}
				else
				{
					effect.updateFrame(timeDiff);
					++i;
				}
			}
			for (i = 0; i < _delayEffects.length; )
			{
				var delayEffect:DelayEffect = _delayEffects[i];
				delayEffect.delay -= timeDiff;
				if (delayEffect.delay <= 0)
				{
					_delayEffects.splice(i, 1);
					effect = delayEffect.genEffect() as ISceneEffectBase;
					if (Math.abs(effect.tileX - firstPlayer.tileX) <= ViewTile.W && Math.abs(effect.tileY - firstPlayer.tileY) <= ViewTile.H)
					{
						_inViewEffects.push(effect);
					}
					else
					{
						effect.destory();
					}
					delayEffect=null;
				}
				else
				{
					++i;
				}
			}
			_inViewEffects.sort(SceneEffectUtils.sortOnY);
			clearAndAddSortedEffects();
		}
		
		private function clearAndAddSortedEffects():void
		{
			var newEffectLength:int = _inViewEffects.length;
			var oldEffectLength:int = _lastInViewEffects.length;
			
			var i:int;
			for (i = 0; i < newEffectLength; ++i)
			{
				var effect:ISceneEffectBase = _inViewEffects[i];
				var effectDispObj:DisplayObject = effect as DisplayObject;
				if (!_effectLayer.contains(effectDispObj))
				{
					_effectLayer.addChildAt(effectDispObj, i);
					++oldEffectLength;
				}
				else if (_effectLayer.getChildIndex(effectDispObj) != i)
				{
					_effectLayer.setChildIndex(effectDispObj, i);
				}
			}
			while (i < oldEffectLength)
			{
				if (_effectLayer.getChildAt(i))
				{
					var effectRubbish:ISceneEffectBase = _effectLayer.removeChildAt(i) as ISceneEffectBase;
					effectRubbish.destory();
					effectRubbish=null;
				}
				--oldEffectLength;
			}
			if(_lastInViewEffects!=null)
			{
				_lastInViewEffects.length=0;
			}
			_lastInViewEffects = _inViewEffects.concat();
		}
	}
}

class PrivateClass{}