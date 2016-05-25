package com.view.gameWindow.mainUi.subuis.bottombar.actBar
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.JointHaloCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillData;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;

	/**
	 * 动作条数据管理类
	 * @author Administrator
	 */	
	public class ActionBarDataManager extends DataManagerBase
	{
		private static var _instance:ActionBarDataManager;
		public static function get instance():ActionBarDataManager
		{
			if(!_instance)
				_instance = new ActionBarDataManager(new PrivateClass());
			return _instance;
		}
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		public const keyNum:int = 10;
		public var actBarDatas:Vector.<ActionBarData>;
		private var _dicActBarDatas:Dictionary;
		private var _clickSkillGroupId:int;

		public function ActionBarDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
				throw new Error("该类使用单例模式");
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTION_LIST,this);
		}
		
		public function groupId2Key(groupId:int):int
		{
			var dt:ActionBarData = actionBarData(groupId);
			if(dt && !dt.isPreinstall && dt.type == ActionBarCellType.TYPE_SKILL)//技能栏上有该技能
			{
				return dt.key;
			}
			else
			{
				var key:int = getEmptyKey();
				return key;
			}
		}
		/**
		 * 发送设置技能消息
		 * @param key 0-9
		 * @param key1 0-9
		 */		
		public function sendSetSkillData(key:int,groupId:int):void
		{
			var isHoleSkill:Boolean = SkillData.HOLE_SKILL_GROUP_ID[groupId];
			var isInCD:int = HejiSkillDataManager.instance.isInCD;
			if(isHoleSkill && isInCD)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.JOINT_PANEL_0018,isInCD));
				return;
			}
			cmExchangeAction(key,groupId);
			dealSetHoleSkill(key,groupId);
		}
		
		private function cmExchangeAction(key:int,groupId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			var dt:ActionBarData = actionBarData(groupId);
			if(!dt || dt.isPreinstall)
			{
				byteArray.writeByte(-1);
				byteArray.writeByte(key);
				byteArray.writeInt(groupId);
				byteArray.writeByte(ActionBarCellType.TYPE_SKILL);
			}
			else//交换技能
			{
				byteArray.writeByte(key);
				byteArray.writeByte(dt.key);
			}
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EXCHANGE_ACTION,byteArray);
		}
		
		private function dealSetHoleSkill(key:int,groupId:int):void
		{
			var holeSkillGroupIds:Object = SkillData.HOLE_SKILL_GROUP_ID;
			var isHoleSkill:Boolean = SkillData.HOLE_SKILL_GROUP_ID[groupId];
			if(!isHoleSkill)
			{
				return;
			}
			var groupIdOther:int;
			for each (groupIdOther in holeSkillGroupIds)
			{
				if(groupIdOther == groupId)
				{
					continue;
				}
				var dt:ActionBarData = actionBarData(groupIdOther);
				if(!dt || dt.isPreinstall)
				{
					continue;
				}
				var dtKey:ActionBarData = actBarDatas[key];
				if(dtKey && dtKey.groupId == groupIdOther)
				{
					continue;
				}
				sendExchangeSkillData(dt.key);
			}
			//
			var cfgDt:JointHaloCfgData = ConfigDataManager.instance.jointHaloCfgData1(groupId);
			if(!cfgDt)
			{
				return;
			}
			HejiSkillDataManager.instance.setMainRune(cfgDt.id);
		}
		
		public function sendExchangeSkillData(key1:int = -1,key2:int = -1):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(key1);
			byteArray.writeByte(key2);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EXCHANGE_ACTION,byteArray);
		}
		
		public function sendSetItemData(key:int,id:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(-1);
			byteArray.writeByte(key);
			byteArray.writeInt(id);
			byteArray.writeByte(SlotType.IT_ITEM);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EXCHANGE_ACTION,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(GameServiceConstants.SM_ACTION_LIST == proc)
			{
				readData(data);
			}
			super.resolveData(proc, data);
		}
		
		private function readData(data:ByteArray):void
		{
			_dicActBarDatas = new Dictionary();
			actBarDatas = new Vector.<ActionBarData>(keyNum,true);
			var size:int = data.readByte();
			while(size--)
			{
				var actionBarData:ActionBarData = new ActionBarData();
				actionBarData.key = data.readByte();
				actionBarData.groupId = data.readInt();
				actionBarData.type = data.readByte();
				actBarDatas[actionBarData.key] = actionBarData;
				_dicActBarDatas[actionBarData.groupId] = actionBarData;
			}
		}
		/**
		 * 获得动作条数据信息
		 * @param id 技能组id
		 * @return 
		 */		
		public function actionBarData(groupId:int):ActionBarData
		{
			if(!_dicActBarDatas)
			{
				return null;
			}
			return _dicActBarDatas[groupId];
		}
		
		public function getCurrentSkillGroupId(target:IEntity = null):int
		{
			if(clickSkillGroupId)
			{
				return clickSkillGroupId;
			}
			if(!target)
			{
				return getNormalSkillGroupId();
			}
			else
			{
				return AutoSystem.instance.getNormalSkill(target);
			}
		}
		
		public function getNormalSkillGroupId():int
		{
			var skillGroupId:int = 0;
			var job:int = RoleDataManager.instance.job;
			if (job == JobConst.TYPE_ZS)
			{
				skillGroupId = SkillConstants.COMMON_ATTACK_ZS;
			}
			else if (job == JobConst.TYPE_FS)
			{
				skillGroupId = SkillConstants.COMMON_ATTACK_FS;
			}
			else if (job == JobConst.TYPE_DS)
			{
				skillGroupId = SkillConstants.COMMON_ATTACK_DS;
			}
			return skillGroupId;
		}
		
		public function isCommonAttack(groupId:int):Boolean
		{
			return groupId == SkillConstants.COMMON_ATTACK_ZS || groupId == SkillConstants.COMMON_ATTACK_FS || groupId == SkillConstants.COMMON_ATTACK_DS;
		}
		
		public function get clickSkillCfgDt():SkillCfgData
		{
			//自动战斗需要频繁调用
			if(clickSkillGroupId == 0)
			{
				return null;
			}
			
			var skillCfgDt:SkillCfgData = ConfigDataManager.instance.skillCfgDataByGroupID(clickSkillGroupId);
			return skillCfgDt;
		}
		/**要点击使用的技能组id*/
		public function get clickSkillGroupId():int
		{
			//自动战斗需要频繁调用
			if(_clickSkillGroupId == 0)
			{
				return 0;
			}
			
			var skillCfgData:SkillCfgData = SkillDataManager.instance.skillCfgData(_clickSkillGroupId);
			if (!SkillDataManager.instance.checkSkillCd(skillCfgData))
			{
				return 0;
			}
			if (!SkillDataManager.instance.checkSkillMpCost(skillCfgData))
			{
				return 0;
			}
			
			return _clickSkillGroupId;
		}
		/**
		 * @private
		 */
		public function set clickSkillGroupId(value:int):void
		{
			_clickSkillGroupId = value;
		}
		/**
		 * @return -1表示没有空的格子
		 */		
		public function getEmptyKey():int
		{
			var i:int,l:int = actBarDatas.length;
			for (i=0;i<l;i++) 
			{
				if(!actBarDatas[i])
				{
					return i;
				}
			}
			return -1;
		}
		/**设置预设占位技能*/
		public function preinstallSkill(key:int):void
		{
			var dt:ActionBarData = new ActionBarData();
			dt.isPreinstall = true;
			actBarDatas[key] = dt;
		}
		
		public function isSkillKey(key:int):Boolean
		{
			if(!actBarDatas || actBarDatas.length < key)
			{
				return false;
			}
			var actionBarData:ActionBarData = actBarDatas[key];
			if(!actionBarData || actionBarData.isPreinstall)
			{
				return false;
			}
			if(actionBarData.type == ActionBarCellType.TYPE_SKILL)
			{
				if(actionBarData.groupId == SkillConstants.ZS_CSJS || actionBarData.groupId == SkillConstants.ZS_BYWD)
				{
					return false;
				}
				return true;
			}
			
			return false;
		}
		/**
		 * 按key对应的快捷键
		 * @param key 0-9
		 */		
		public function pressKey(key:int):void
		{
			if(!actBarDatas || actBarDatas.length < key)
			{
				return;
			}
			var actionBarData:ActionBarData = actBarDatas[key];
			if(!actionBarData || actionBarData.isPreinstall)
			{
				return;
			}
			if(actionBarData.type == ActionBarCellType.TYPE_SKILL)
			{
				AutoJobManager.getInstance().useSkill(actionBarData.groupId);
			}
			else
			{
				var manager:BagDataManager = BagDataManager.instance;
				var dt:BagData = manager.getItemById(actionBarData.groupId);
				if(dt)
				{
					manager.dealItemUse(dt.id);
				}
				else
				{
					trace("ActionBarCellClickHandle.onClick(event) 物品已用完");
				}
			}
		}
	}
}
class PrivateClass{}