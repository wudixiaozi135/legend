package com.view.gameWindow.scene.movie
{
	import com.core.toArray;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MovieCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.scene.GameSceneManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.constants.MonsterSideTypes;
	import com.view.gameWindow.scene.entity.entityItem.LivingUnit;
	import com.view.gameWindow.scene.entity.entityItem.Monster;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	/**
	 * @author wqhk
	 * 2014-12-3
	 */
	public class MovieControl implements IMovieControl
	{
		private static const CALLLABERTIME:int = 90;
		public function MovieControl()
		{
		}
		
		//1
		public function movieBegin(mid:int,isCover:Boolean):void
		{
			if(isCover)
			{
				UICenter.hideMainUI();
				UICenter.hidePanels();
				openCurtain(1);
				EntityLayerManager.getInstance().showOtherPlayer = false;
				UICenter.showMaskTop(true);
			}
		}
		
		//2
		public function movieEnd(mid:int):void
		{
			UICenter.showMainUI();
			closeCurtain(1);
			EntityLayerManager.getInstance().showOtherPlayer = true;
			UICenter.showMaskTop(false);
			GameSceneManager.getInstance().resumeCamera();
		}
		
		//3
		
		//11
		public function addMonster(data:Array):void
		{
			var byte:ByteArray = new ByteArray();
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeShort(1);//count
			byte.writeByte(EntityTypes.ET_MONSTER);
			
			var entityId:int = parseInt(data[0]);
			byte.writeInt(entityId);// entityId
			byte.writeInt(parseInt(data[1]));// monsterId
			byte.writeShort(parseInt(data[2]));//tileX
			byte.writeShort(parseInt(data[3]));//tileY
			byte.writeShort(parseInt(data[2]));//targettileX
			byte.writeShort(parseInt(data[3]));//targettileY
			byte.writeInt(parseInt(data[4]));//hp
			byte.writeShort(parseInt(data[5]));//speed
			byte.writeByte(MonsterSideTypes.MS_FRIEND);//side 
			byte.writeInt(0);//怪物消失时间
			byte.writeInt(0);//killerCid角色id
			byte.writeInt(0);//killerSid服务器id
			byte.writeShort(0);//dig count
			DistributionManager.getInstance().dispatch(GameServiceConstants.SM_ENTITY_INTO_MAP,byte);
		}
		
		//12
		public function moveMonster(data:Array):void
		{
			var byte:ByteArray = new ByteArray();
			byte.endian = Endian.LITTLE_ENDIAN;
			
			var entityId:int = parseInt(data[0]);
			byte.writeInt(entityId);//id
			byte.writeByte(EntityTypes.ET_MONSTER);//type
			
			byte.writeShort(parseInt(data[1])); //targetTileX
			byte.writeShort(parseInt(data[2]));//targetTileY
			
			DistributionManager.getInstance().dispatch(GameServiceConstants.SM_MOVE,byte);
		}
		
		//13
		public function monsterAttack(data:Array):void
		{
			var entityId:int = parseInt(data[0]);
			
			var unit:LivingUnit = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_MONSTER,entityId) as LivingUnit;
			
			if(unit)
			{
				unit.pAttackLoop();
			}
		}
		
		//14
		public function monsterDied(data:Array):void
		{
			var entityId:int = parseInt(data[0]);
			
			var unit:LivingUnit = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_MONSTER,entityId) as LivingUnit;
			
			if(unit)
			{
				stopMove(unit);
				unit.hp = 0;
				unit.die();
			}
		}
		
		//15
		public function monsterStand(data:Array):void
		{
			var entityId:int = parseInt(data[0]);
			
			var unit:LivingUnit = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_MONSTER,entityId) as LivingUnit;
			
			if(unit)
			{
				stopMove(unit);
				unit.idle();
			}
		}
		
		private function getEntity(launcherType:int,launcherId:int):ILivingUnit
		{
			var launcher:ILivingUnit = null;
			if(launcherId == 1 && launcherType == EntityTypes.ET_PLAYER)
			{
				launcher = EntityLayerManager.getInstance().firstPlayer;
			}
			else if(launcherId == 2 && launcherType == EntityTypes.ET_HERO)
			{
				launcher = EntityLayerManager.getInstance().myHero;
			}
			else
			{
				launcher = EntityLayerManager.getInstance().getEntity(launcherType,launcherId) as ILivingUnit;
			}
				
			return launcher;
		}
		
		//16
		//3:0:8001:1:3:123:3:124:0:100
		public function spellSkill(data:Array):void
		{
			var byte:ByteArray = new ByteArray();
			byte.endian = Endian.LITTLE_ENDIAN;
			
			
			var skillId:int = parseInt(data[0]);
			var skillCfg:SkillCfgData = ConfigDataManager.instance.skillCfgData1(skillId);
			
			if(!skillCfg)
			{
				return;
			}
			
			byte.writeByte(skillCfg.entity_type);//entityType
			byte.writeByte(skillCfg.job);//job
			byte.writeInt(skillCfg.group_id);//skillGroupId
			byte.writeShort(skillCfg.level);//skillLevel
			
			var launcherType:int = parseInt(data[1]);
			var launcherId:int = parseInt(data[2]);
			
			var launcher:ILivingUnit = getEntity(launcherType,launcherId);
			
			if(!launcher)
			{
				return;
			}
			
			byte.writeByte(launcher.entityType);//launcherType
			byte.writeInt(launcher.entityId);//launcherId
			byte.writeShort(launcher.tileX);//launcherTileX
			byte.writeShort(launcher.tileY);//launcherTileY
			byte.writeByte(launcher.direction);//launcherDir
			byte.writeShort(0);//groundX
			byte.writeShort(0);//groundY
			
			byte.writeShort(1);//count
			
			var tType:int = parseInt(data[3]);
			var tId:int = parseInt(data[4]);
			
			var target:ILivingUnit = getEntity(tType,tId);
			if(!target)
			{
				return;
			}
			
			byte.writeByte(target.entityType);//targetType
			byte.writeInt(target.entityId);//targetId
			byte.writeShort(target.tileX);//targetTileX
			byte.writeShort(target.tileY);//targetTileY
			byte.writeByte(parseInt(data[5]));//attackState
			byte.writeInt(parseInt(data[6]));//damage
			
			DistributionManager.getInstance().dispatch(GameServiceConstants.SM_SKILL_RESULT,byte);
		}
		
		//17
		public function monsterFacing(data:Array,time:Object = null):void
		{
			if(time)
			{
				clearTimeout(time.id);
				time = null;
			}
			
			var entityId:int = parseInt(data[0]);
			
			var unit:LivingUnit = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_MONSTER,entityId) as LivingUnit;
			
			var direct:int = parseInt(data[1]);
			if(unit && unit.isShow)
			{
				unit.direction = direct;
			}
			else
			{
				var t:Object = {};
				t.id = setTimeout(monsterFacing,CALLLABERTIME,data,t);
			}
		}
		
		//18
		public function removeUnit(data:Array):void
		{
			var byte:ByteArray = new ByteArray();
			byte.endian = Endian.LITTLE_ENDIAN;
			
			byte.writeShort(1);//count
			byte.writeByte(EntityTypes.ET_MONSTER);//type
			byte.writeInt(parseInt(data[0]));//id
			
			DistributionManager.getInstance().dispatch(GameServiceConstants.SM_LEAVE_MAP,byte);
		}
		
		//19
		public function chat(data:Array):void
		{
			UICenter.addMovieTalk(data[0],parseInt(data[1]),ResourcePathConstants.IMAGE_BOSS_HEAD_ICON+data[2],parseFloat(data[3]));
		}
		
		//31
		public function moveFirstPlayer(data:Array):void
		{
			var fp:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			
			if(!fp)
			{
				return;
			}
			
			AutoSystem.instance.startAutoMap(parseInt(data[0]),parseInt(data[1]),parseInt(data[2]));
		}
		
		//32
		public function moveCamera(data:Array):void
		{
			var scene:GameSceneManager = GameSceneManager.getInstance();
			var x:int = parseInt(data[0])*MapTileUtils.TILE_WIDTH + MapTileUtils.TILE_WIDTH/2;
			var y:int = parseInt(data[1])*MapTileUtils.TILE_HEIGHT + MapTileUtils.TILE_HEIGHT/2;
			var time:int = parseInt(data[2]);
			scene.cameraMove(x,y,time,true);
		}
		
		//41
		public function showCover(data:Array):void
		{
			UICenter.showCover(parseInt(data[0]),parseFloat(data[1]),parseInt(data[2]));
		}
		
		//42
		public function addSubtitle(data:Array):void
		{
			UICenter.addSubtitle(data[0],parseInt(data[1]),parseInt(data[2]));
		}
		
		//43
		public function hideCover():void
		{
			UICenter.hideCover();
		}
		
		public function createMovieQueue(mid:int,list:*):Array
		{
			var re:Array = [];
			var past:int = 0;
			var dict:* = list;
			for each(var config:MovieCfgData in dict)
			{
				if(config.movie_id != mid)
					continue;
				
				var clip:MovieInfo = new MovieInfo;
				clip.id = config.id;
				clip.type = config.type;
				clip.data = config.data;
				clip.waitTime = config.time_line - past;
				if(clip.waitTime < 0)
				{
					clip.waitTime = 0;
				}
				past += clip.waitTime;
				
				re.push(clip);
			}
			
			return re;
		}
		
		
		private function stopMove(unit:ILivingUnit):void
		{
			unit.targetTileX = unit.tileX;
			unit.targetTileY = unit.tileY;
		}
		
		public function openCurtain(time:Number):void
		{
			UICenter.openCurtain(time);
		}
		
		public function closeCurtain(time:Number):void
		{
			UICenter.closeCurtain(time);
		}
	}
}