package com.view.gameWindow.panel.panels.skill
{
	import com.model.business.fileService.PreBytesLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BuffCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.PetCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.JobConst;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.mainUi.subuis.pet.PetDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.buff.BuffData;
	import com.view.gameWindow.panel.panels.buff.BuffDataManager;
	import com.view.gameWindow.panel.panels.buff.BuffListData;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.gameWindow.scene.skillDeal.SkillDealManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	public class SkillDataManager extends DataManagerBase
	{
		public static const LEARN_RE:int = 0;
		public static const LEARN_LV:int = 35;
		private static var _instance:SkillDataManager;
		
		private var _skillDatas:Dictionary;
		private var _skillCds:Dictionary;
		
		public static function get instance():SkillDataManager
		{
			if(!_instance)
			{
				_instance = new SkillDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		/**技能类型；1：玩家，2：英雄，3：合击，4：内技*/
		public var entity_type:int;
		private var _selectSkillData:SkillData;

		private var _skillDataNew:SkillData;
		
		public var hasInit:Boolean = false;
		
		public function SkillDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_SKILL_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SKILL_STUDIED,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ADD_PROFICIENCY_SKILL,this);
			
			entity_type = SkillConstants.TYPE_ROLE;
			_skillCds = new Dictionary();
		}
		
		
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		public function useSkillBook(itemId:int,cellId:int):void
		{
			var boolean:Boolean = checkCanUse(itemId,cellId);
			if(boolean)
			{
				sendUseSkillBook(cellId);
			}
		}
		
		private function sendUseSkillBook(cellId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(ConstStorage.ST_CHR_BAG);
			byteArray.writeByte(cellId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SKILL_UPGRADE,byteArray);
		}
		
		/**检测是否能使用技能书*/
		private function checkCanUse(itemId:int,cellId:int):Boolean
		{
			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(0,0,0,0,itemId);
			if(!skillCfgData)
			{
				return false;
			}
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(itemId);
			if(!itemCfgData)
			{
				return false;
			}
			var dt:SkillData = _skillDatas[skillCfgData.group_id] as SkillData;
			if(!dt)
			{
				if(skillCfgData.ring_id)
				{
					Alert.warning(StringConst.SKILL_PANEL_0025);
					return false;
				}
				return true;
			}
			if(dt.proficiencyMax == int.MAX_VALUE)
			{
				Alert.warning(StringConst.SKILL_PANEL_0024);
				return false;
			}
			if(itemCfgData.effect)//使用熟练度技能书
			{
				if(dt.isNextNeedLvGet)
				{
					return true;
				}
				if(!dt.proficiencyNeed)
				{
					Alert.warning(StringConst.SKILL_PANEL_0019);
					return false;
				}
				else if(dt.proficiencyNeed < itemCfgData.effectValue)
				{
					Alert.show2(StringConst.SKILL_PANEL_0027,sendUseSkillBook,cellId);
					return false;
				}
				return true;
			}
			else
			{
				if(dt.level != skillCfgData.level-1)
				{
					Alert.warning(StringConst.SKILL_PANEL_0020);
					return false;
				}
				if(!dt.isProficiencyFull)
				{
					Alert.warning(StringConst.SKILL_PANEL_0023);
					return false;
				}
				return true;
			}
		}
		/**
		 * 切换英雄技能开启关闭状态
		 * @param groupId 技能组id
		 * @param open 打开和关闭，0表示关闭，1表示打开
		 */		
		public function switchHeroSkillState(groupId:int,open:int):void
		{
			var dt:SkillData = _skillDatas[groupId] as SkillData;
			if(dt.isZd)
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeInt(groupId);
				byteArray.writeByte(open);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_OPEN_SKILL,byteArray);
			}
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_SKILL_LIST:
					readData(data);
					if(!hasInit)
						hasInit = true;
					break;
				case GameServiceConstants.SM_SKILL_STUDIED:
					dealSkillStudied(data);
					break;
				case GameServiceConstants.SM_ADD_PROFICIENCY_SKILL:
					dealSmAddProficiencySkill(data);
					break;
				default:
					break;
			}
			super.resolveData(proc,data);
		}
		
		private function dealSmAddProficiencySkill(bytearray:ByteArray):void
		{
			var itemId:int = bytearray.readInt();
			var add:int = bytearray.readInt();
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(itemId);
			if(!itemCfgData)
			{
				return;
			}
			var str:String = StringConst.SKILL_PANEL_0021 + itemCfgData.name;
			if(add)
			{
				str += StringConst.SKILL_PANEL_0022 + add;
			}
			Alert.message(str);
		}
		
		private function readData(data:ByteArray):void
		{
			_skillDatas = new Dictionary();
			var size:int;
			//角色技能
			clearGuideSkillState();
			size = data.readByte();
			while (size-- > 0)
			{
				var skillData:SkillData = new SkillData();
				skillData.group_id = data.readInt();
				skillData.level = data.readShort();//level
				skillData.proficiency = data.readInt();
				skillData.open = data.readByte();
				_skillDatas[skillData.group_id] = skillData;
				
				checkRoleGuideLearnSkill(skillData);
			}
			//英雄技能
			size = data.readByte();
			while (size-- > 0)
			{
				skillData = new SkillData();
				skillData.group_id = data.readInt();
				skillData.level = data.readShort();//level
				skillData.proficiency = data.readInt();
				skillData.open = data.readByte();
				_skillDatas[skillData.group_id] = skillData;
			}
		}
		
//		public var isGuideSkillLearned:Boolean = false;
		
		public function clearGuideSkillState():void
		{
			_guideSkillState = {};
		}
		
		private var _guideSkillState:Object = {};
		
		private function checkRoleGuideLearnSkill(skillData:SkillData):void
		{
			var skill:SkillCfgData = ConfigDataManager.instance.skillCfgData(RoleDataManager.instance.job,EntityTypes.ET_PLAYER,skillData.group_id,1);
			if(skill && skill.player_reincarn == LEARN_RE && skill.player_level == LEARN_LV)
			{
//				isGuideSkillLearned = true;
				_guideSkillState[LEARN_LV] = skill;
			}
		}
		
		public function getGuideSkillState(lv:int = LEARN_LV):SkillCfgData
		{
			return _guideSkillState[lv]
		}
		
		/**
		 * 引导购买的技能
		 */
		public function getGuideLearnSkillId(lv:int = LEARN_LV):int
		{
			switch(RoleDataManager.instance.job)
			{
				case JobConst.TYPE_ZS:
					return 1051;//烈火
				case JobConst.TYPE_FS:
					return 2051;//冰咆哮
				case JobConst.TYPE_DS:
					return 3051;//召唤神兽
			}
			
			return 0;
		}
		
		private function dealSkillStudied(byteArray:ByteArray):void
		{
			var skillBaseGroupId:int = ActionBarDataManager.instance.getCurrentSkillGroupId();
			var groupId:int = byteArray.readInt();//技能组id，4字节有符号整形
			var level:int = byteArray.readShort();//技能等级，2字节有符号整形
			if(skillBaseGroupId == groupId)
			{
				return;
			}
			//
			var dt:SkillData = new SkillData();
			dt.group_id = groupId;
			dt.level = level;
			//
			var skillCfgDt:SkillCfgData = dt.skillCfgDt;
			if(!skillCfgDt)
			{
				return;
			}
			//
			if(skillCfgDt.view_type == SkillConstants.VIEW_TYPE_PLAYER 
				|| skillCfgDt.view_type == SkillConstants.VIEW_TYPE_HERO
				|| skillCfgDt.view_type == SkillConstants.VIEW_TYPE_JOINT)//显示类型为玩家和英雄的技能弹出提示框
			{
				_skillDataNew = dt;
				if (skillCfgDt.view_type == SkillConstants.VIEW_TYPE_PLAYER || skillCfgDt.view_type == SkillConstants.VIEW_TYPE_JOINT)
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_SKILL_NEW, false);
				} 
				else if(skillCfgDt.view_type == SkillConstants.VIEW_TYPE_HERO)
				{
					//播放英雄获得技能特效
					if (level == 1)
					{
						FlyEffectMediator.instance.doFlyHeroSkillNew(dt.skillCfgDt);
					}
				}
				if(level == 1)
				{
					AutoDataManager.instance.learn(groupId);
					
					if(skillCfgDt.type == SkillConstants.HJ)
					{
						preloadSkillEffect(skillCfgDt);
					}
				}
			}
		}
		
		public function preloadSkillEffect(skill:SkillCfgData):void
		{
			var path:String = skill.effect_joint;
				
			var split:Array = path.split(":");
			if(split.length != 2)
			{
				return;
			}
			var folder:String = split[0];
			var totalDir:int = int(split[1]);
			var dir:int;
			//先就判断一方向
			dir = 0;
			
			var url:String = ResourcePathConstants.EFFECT_RES_LOAD+folder+"/"+(dir+1)+ResourcePathConstants.POSTFIX_EFFECT;
			PreBytesLoader.load(url);
		}
		
		public function setSkillData(cfgDt:SkillCfgData):void
		{
			var skillData:SkillData = new SkillData();
			skillData.group_id = cfgDt.group_id;
			skillData.level = cfgDt.level;//level
			skillData.proficiency = cfgDt.proficiency;
			_skillDatas[skillData.group_id] = skillData;
		}
		
		public function skillData(groupId:int):SkillData
		{
			return _skillDatas[groupId];
		}
		
		public function skillCDAfter(groupId:int):int
		{
			if (_skillCds.hasOwnProperty(groupId.toString()))
			{
				return getTimer() - _skillCds[groupId];
			}
			return 0;
		}
		/**
		 * 检测技能CD
		 * @param skillCfgData 由于烈火剑法的操蛋需求改为传SkillCfgData
		 * @return false CD中
		 */		
		public function checkSkillCd(skillCfgData:SkillCfgData):Boolean
		{
			if (!skillCfgData)
			{
				return true;
			}
			if (_skillCds.hasOwnProperty(skillCfgData.group_id.toString()))
			{
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				if (!firstPlayer)
				{
					return false;
				}
				var time:int = getTimer();
				if (_skillCds[skillCfgData.group_id] + skillCfgData.cd > time)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public function checkJointSkillReady():Boolean
		{
			var skill:SkillCfgData = HejiSkillDataManager.instance.cfgDtHeji;
			
			if(!skill)
			{
				return false;
			}
			
			if(SkillDealManager.instance.state == 1)
			{
				return false;
			}
			
			if(!HejiSkillDataManager.instance.isAngryFull)
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * 判断召唤兽是否存在
		 */
		public function checkSkillSummonRemain(groupId:int):Boolean
		{
			var skillData:SkillData = _skillDatas[groupId];
			if (!skillData || skillData.level <= 0)
			{
				return false;
			}
			
			var cfg:SkillCfgData = skillData.skillCfgDt;
			if(!cfg)
			{
				return false;
			}
			
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (!firstPlayer)
			{
				return false;
			}
			
			if(cfg.special == SkillConstants.SPECIAL_SUMMON)
			{
				if(cfg.special_param)
				{
					var petcfg:PetCfgData = ConfigDataManager.instance.petCfgData(cfg.special_param);
					
					if(petcfg && petcfg.group_id == PetDataManager.instance.group_id)//不同种宝宝 要重新召唤
					{
						return true;
					}
					
//					if(PetDataManager.instance.group_id)//不同种宝宝 不重新召唤
//					{
//						return true;
//					}
				}
			}
			
			return false;
		}
		
		/**
		 * 判断buff是否存在 
		 * 还需要判断buff的优先级。目标上的buff优先级高则不能替换
		 */
		public function checkSkillBuffRemain(groupId:int,entityId:int,entityType:int):Boolean
		{
			var skillData:SkillData = _skillDatas[groupId];
			if (!skillData || skillData.level <= 0)
			{
				return false;
			}
			
			var cfg:SkillCfgData = skillData.skillCfgDt;
			if(!cfg)
			{
				return false;
			}
			
			if(entityType == EntityTypes.ET_MONSTER)
			{
				var iMonster:IMonster = EntityLayerManager.getInstance().getEntity(entityType,entityId) as IMonster;
				if(!iMonster)
				{
					return false;
				}
				
				var monster:MonsterCfgData = ConfigDataManager.instance.monsterCfgData(iMonster.monsterId);
				
				if(!monster)
				{
					return false;
				}
				
				if(monster.no_skill_buffed)
				{
					return true;
				}
			}
			
//			/*var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
//			if (!firstPlayer)
//			{
//				return false;
//			}*/
//			
//			if(/*cfg.beneficial == SkillConstants.BENEFICIAL_TRUE && */cfg.buff_id>0 && cfg.buff_remain>0)
//			{
//				var time:int = BuffDataManager.instance.getBufferTime(entityType,entityId,cfg.buff_id);
//				
//				if(time != 0)
//				{
//					return true;
//				}
//			}
			
			var list:BuffListData = BuffDataManager.instance.getBuffList(entityType,entityId);
			
			if(!list)
			{
				return false;
			}
			
			var buff:BuffCfgData = ConfigDataManager.instance.buffCfgData(cfg.buff_id);
			
			if(!buff)
			{
				return false;
			}
			
			var doingBuff:BuffData = list.findBuffByGroupId(buff.group);
			
			if(!doingBuff)
			{
				return false;
			}
			
			var time:int = BuffDataManager.instance.getBufferTime(entityType,entityId,doingBuff.cfg.id);
			
			if(time == 0)
			{
				return false;
			}
			
			if(doingBuff.cfg.priority <= buff.priority)//优先级更高 .只所以加上 等号是因为 没法判断自己是否放上去
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		/**
		 * 检测耗魔
		 * @param skillCfgData 由于烈火剑法的操蛋需求改为传SkillCfgData
		 * @return false 魔不足
		 */		
		public function checkSkillMpCost(skillCfgData:SkillCfgData):Boolean
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (!firstPlayer)
			{
				return false;
			}
			/*var skillData:SkillData = _skillDatas[groupId];
			if (!skillData || skillData.level <= 0)
			{
				return false;
			}
			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(firstPlayer.job, firstPlayer.entityType, groupId, skillData.level);*/
			if (!skillCfgData)
			{
				return false;
			}
			var attrMp:int = RoleDataManager.instance.attrMp;
			if (skillCfgData.mp_cost > attrMp)
			{
				return false;
			}
			return true;
		}
		
		
		public function skillCfgData(groupId:int):SkillCfgData
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (!firstPlayer)
			{
				return null;
			}
			var skillData:SkillData = _skillDatas[groupId];
			if (!skillData || skillData.level <= 0)
			{
				return null;
			}
			
//			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(firstPlayer.job, firstPlayer.entityType, groupId, skillData.level);
//			if(!skillCfgData)
//			{
//				skillCfgData = ConfigDataManager.instance.skillCfgData(JobConst.TYPE_NO, firstPlayer.entityType, groupId, skillData.level);
//			}
//			if (!skillCfgData)
//			{
//				return null;
//			}
//			return skillCfgData;
			
			var skillCfgData:SkillCfgData = skillData.skillCfgDt;//自动战斗需要频繁调用
			return skillCfgData;
		}
		
		public function skillDone(groupId:int):void
		{
			var time:int = getTimer();
			_skillCds[groupId] = time;
			playCoolDownEffect(groupId);
		}
		
		private function playCoolDownEffect(groupId:int):void
		{
			if(MainUiMediator.getInstance().bottomBar)
			{
				MainUiMediator.getInstance().bottomBar.playCoolDownEffect(groupId);
			}
		}

		public function get selectSkillData():SkillData
		{
			var _selectSkillData2:SkillData = _selectSkillData;
			_selectSkillData = null;
			return _selectSkillData2;
		}

		public function set selectSkillData(value:SkillData):void
		{
			_selectSkillData = value;
		}
		
		public function getNextSkillCfgData(data:SkillCfgData):SkillCfgData
		{
			var re:SkillCfgData = ConfigDataManager.instance.skillCfgData(data.job,data.entity_type,data.group_id,data.level+1);
			return re;
		}
		/**新技能数据类*/
		public function get skillDataNew():SkillData
		{
			var _skillDataNew2:SkillData = _skillDataNew;
			_skillDataNew = null;
			return _skillDataNew2;
		}
	}
}
class PrivateClass{}