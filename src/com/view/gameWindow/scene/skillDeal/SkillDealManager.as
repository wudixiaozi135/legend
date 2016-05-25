package com.view.gameWindow.scene.skillDeal
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.SkillCfgData;
    import com.model.consts.TypeInterval;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.mainUi.subuis.displaySetting.DisplaySettingConst;
    import com.view.gameWindow.mainUi.subuis.displaySetting.DisplaySettingManager;
    import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
    import com.view.gameWindow.scene.GameSceneManager;
    import com.view.gameWindow.scene.effect.SceneEffectManager;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.FirstPlayer;
    import com.view.gameWindow.scene.entity.entityItem.Monster;
    import com.view.gameWindow.scene.entity.entityItem.Player;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
    import com.view.gameWindow.scene.map.utils.MapTileUtils;
    import com.view.gameWindow.scene.shake.ShakingManager;
    import com.view.newMir.sound.SoundManager;
    
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    public class SkillDealManager extends DataManagerBase
	{
		private static var _instance:SkillDealManager;
		public static function get instance():SkillDealManager
		{
			return _instance ||= new SkillDealManager(new PrivateClass());
		}
		/**0表示结束或者取消合击准备，1表示开启合击准备*/
		public var state:int;

		public function clearInstance():void
		{
			_instance = null;
		}

		public function SkillDealManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_SKILL_RESULT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_JOINT_SKILL_STATE,this);
		}
		/**
		 * 发送准备使用合击消息
		 * @param state 开启或者取消，为1字节有符号整形，0表示结束合击准备，1表示开启合击准备（后面两个参数仅在此值为1时有效）
		 * @param entityId 选中对象的id，为4字节有符号整形
		 * @param entityType 选中对象的类型，为1字节有符号整形
		 */
		public function sendJiontSkillPrepare(state:int = 0,entityId:int = 0,entityType:int = 0):void
		{
			if(this.state)
			{
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(state);
			byteArray.writeInt(entityId);
			byteArray.writeByte(entityType);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_JOINT_SKILL_PREPARE,byteArray);
		}

		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_SKILL_RESULT:
					dealSkillResult(data);
					break;
				case GameServiceConstants.SM_JOINT_SKILL_STATE:
					dealJointSkillState(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}

		public function dealSkillResult(data:ByteArray):void
		{
			var entityType:int = data.readByte();
			var job:int = data.readByte();
			var skillGroupId:int = data.readInt();
			var skillLevel:int = data.readShort();
			var launcherType:int = data.readByte();
			var launcherId:int = data.readInt();
			var launcherTileX:int = data.readShort();
			var launcherTileY:int = data.readShort();
			var launcherDir:int = data.readByte();
			var groundX:int = data.readShort();
			var groundY:int = data.readShort();
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var launcher:ILivingUnit = EntityLayerManager.getInstance().getEntity(launcherType, launcherId) as ILivingUnit;
			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(job, entityType, skillGroupId, skillLevel);
			if(!skillCfgData)
			{
				return;
			}
			var isFirstPlayer:Boolean = launcherType == EntityTypes.ET_PLAYER && launcherId == firstPlayer.entityId;
			var isHj:Boolean = skillCfgData.type == SkillConstants.HJ;
			if (launcher && (!isFirstPlayer || (isFirstPlayer && isHj)))//怪物及其他玩家
			{
				if(isHj)
				{
					if(isFirstPlayer)
					{
						trace("SkillDealManager.dealSkillResult(data) 播放玩家合击动作");
					}
					else
					{
						trace("SkillDealManager.dealSkillResult(data) 播放英雄合击动作");
					}
				}
				if(isFirstPlayer && isHj)
				{
					AutoJobManager.getInstance().setLastSkillTime();
				}
				launcher.direction = launcherDir;
				if (skillCfgData.action_type == SkillConstants.ACTION_TYPE_PATTACK)
				{
					launcher.pAttack();
				}
				else if (skillCfgData.action_type == SkillConstants.ACTION_TYPE_MATTACK)
				{
					launcher.mAttack();
				}
			}
			var count:int = data.readShort();
			var targets:Vector.<ILivingUnit> = new Vector.<ILivingUnit>();
			var enemy:ILivingUnit = null;
			while (count-- > 0)
			{
				var targetType:int = data.readByte();
				var targetId:int = data.readInt();
				var targetTileX:int = data.readShort();
				var targetTileY:int = data.readShort();
				var attackState:int = data.readByte();
				var damage:int = data.readInt();
				var target:ILivingUnit = EntityLayerManager.getInstance().getEntity(targetType, targetId) as ILivingUnit;
				var delay:int = 0;
				if(target && target.isShow)
				{
					targets.push(target);
					var timerId:uint;
					if(skillCfgData.after_interval_type == TypeInterval.FIXED)
					{
						delay = skillCfgData.before_interval + skillCfgData.after_interval;
					}
					else if(skillCfgData.after_interval_type == TypeInterval.VARIABLE)
					{
						var tileDist:Number = MapTileUtils.tileDistance(launcherTileX, launcherTileY, targetTileX, targetTileY);
						if(skillCfgData.speed)
						{
							delay = skillCfgData.before_interval + tileDist * MapTileUtils.TILE_WIDTH / skillCfgData.speed * 1000;
						}
					}
					timerId = setTimeout(function(target:ILivingUnit,damage:int,attackState:int):void
					{
						clearTimeout(timerId);
						target.showStateAlert(damage,attackState);
					},delay,target,damage,attackState);
					
					if(skillCfgData.entity_type == SkillConstants.TYPE_ROLE && 
						skillCfgData.beneficial == SkillConstants.BENEFICIAL_FALSE &&
						target.entityType == firstPlayer.entityType && target.entityId == firstPlayer.entityId)
					{
						enemy = launcher;
					}
				}
			}
			if (!isFirstPlayer || (isFirstPlayer && isHj))
			{
				if(isHj)
				{
					if(isFirstPlayer)
					{
						ShakingManager.getInstance().shakeObj(GameSceneManager.getInstance().gameScene, delay);
						launcher.addUnPermTopEffect(skillCfgData.effect_joint,true);
					}
					else
					{
						trace("播放英雄合击特效");
					}
				}
				addEffects(skillCfgData, launcher, new Point(launcherTileX, launcherTileY), targets, new Point(groundX, groundY));
			}
			
			if(enemy)
			{
				notifyData(GameServiceConstants.SM_SKILL_RESULT,enemy);
			}
		}

		private function dealJointSkillState(data:ByteArray):void
		{
			state = data.readByte();
			trace("更改合击状态："+state);
		}

		public function addEffects(skillCfgData:SkillCfgData, launcher:ILivingUnit, launcherPos:Point, targets:Vector.<ILivingUnit>, groundPos:Point):void
		{
            var effectState:Boolean = DisplaySettingManager.instance.hideSkillEffect(DisplaySettingConst.HIDE_MONSTER_EFFECT);
			if(skillCfgData.effect_action && skillCfgData.effect_action != "0")
			{
				if (launcher)
				{
					if (launcher is FirstPlayer)
					{//优先判断玩家自己 因为FirstPlayer也是Player
						launcher.addUnPermTopEffect(skillCfgData.effect_action);
					} else if (launcher is Player || launcher is Monster)
					{
						if (!effectState)
						{
							launcher.addUnPermTopEffect(skillCfgData.effect_action);
						}
					} else
					{
						launcher.addUnPermTopEffect(skillCfgData.effect_action);
					}
				}
			}
			SoundManager.getInstance().playSkillEffect(skillCfgData.sound_action);
			if (skillCfgData.effect_path && skillCfgData.effect_path != "0")
			{
				if (launcher)
				{
					if (launcher is FirstPlayer)
					{
						SceneEffectManager.instance.addPathEffect(skillCfgData, launcher, launcherPos, targets, groundPos);
					}
					else if (launcher is Player || launcher is Monster)
					{//其他玩家
						if (!effectState)
						{
							SceneEffectManager.instance.addPathEffect(skillCfgData, launcher, launcherPos, targets, groundPos);
						}
					} else
					{
						SceneEffectManager.instance.addPathEffect(skillCfgData, launcher, launcherPos, targets, groundPos);
					}
				}
			}
			if (skillCfgData.effect_ground && skillCfgData.effect_ground != "0")
			{
				if (launcher)
				{
					if (launcher is FirstPlayer)
					{
						SceneEffectManager.instance.addGroundEffect(skillCfgData, launcherPos, targets, groundPos);
					}
					else if (launcher is Player || launcher is Monster)
					{//其他玩家
						if (!effectState)
						{
							SceneEffectManager.instance.addGroundEffect(skillCfgData, launcherPos, targets, groundPos);
						}
					} else
					{
						SceneEffectManager.instance.addGroundEffect(skillCfgData, launcherPos, targets, groundPos);
					}
				}
			}
			if (skillCfgData.effect_ground_random && skillCfgData.effect_ground_random != "0")
			{
				if (launcher)
				{
					if (launcher is FirstPlayer)
					{
						SceneEffectManager.instance.addGroundRandomEffect(skillCfgData, launcherPos, targets, groundPos);
					}
					else if (launcher is Player || launcher is Monster)
					{//其他玩家
						if (!effectState)
						{
							SceneEffectManager.instance.addGroundRandomEffect(skillCfgData, launcherPos, targets, groundPos);
						}
					} else
					{
						SceneEffectManager.instance.addGroundRandomEffect(skillCfgData, launcherPos, targets, groundPos);
					}
				}
			}
			if (skillCfgData.effect_hit && skillCfgData.effect_hit != "0")
			{
				var split:Array = skillCfgData.effect_hit.split(":");
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
				for each (var target:ILivingUnit in targets)
				{
					if(target)
					{
						target.addTopHitEffect(skillCfgData, launcherPos, groundPos);
					}
				}
			}
		}
	}
}
class PrivateClass{}