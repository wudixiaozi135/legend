package com.view.gameWindow.panel.panels.hejiSkill
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff.JointHaloData;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	public class HejiSkillDataManager extends DataManagerBase
	{
		private static var _instance:HejiSkillDataManager;

		public static function get instance():HejiSkillDataManager
		{
			return _instance ||= new HejiSkillDataManager(new PrivateClass());
		}
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		public static const MAIN_BUFF:int=1;
		
		public var buffArr:Array;
		public var mainBuffIndex:int;
		/**第一页为0*/
		public var selectTab:int;
		/**合击技能等级*/
		public var level:int = 1;
		
		public var cellID1:int;
		public var cellID2:int;
		public var replaceID:int;
		//
		private var _cfgDtHeji:SkillCfgData;
		/**合击技能配置信息*/
		public function get cfgDtHeji():SkillCfgData
		{
			if(!_cfgDtHeji)
			{
				var jobRole:int = RoleDataManager.instance.job;
				var jobHero:int = HeroDataManager.instance.job;
				_cfgDtHeji = ConfigDataManager.instance.skillCfgDataHeji(SkillConstants.HJ,level,EntityTypes.ET_PLAYER,jobRole,jobHero);
			}
			return _cfgDtHeji;
		}
		//
		private var _isAngryFull:Boolean;
		/**是否满怒气*/
		public function get isAngryFull():Boolean
		{
			var manager:RoleDataManager = RoleDataManager.instance;
			return _isAngryFull && manager.angry >= manager.angryMax;
		}
		/**@param value*/		
		public function set isAngryFull(value:Boolean):void
		{
			_isAngryFull = value;
		}
		
		public function get isAngryFullInUI():Boolean
		{
			return _isAngryFull;
		}
		
		private var _isAngryPlaying:Boolean;
		public function get isAngryPlaying():Boolean
		{
			return _isAngryPlaying;
		}
		public function set isAngryPlaying(value:Boolean):void
		{
			_isAngryPlaying = value;
		}
		private var time:int;
		/**
		 * 是否在CD中
		 * @return cd值
		 */		
		public function get isInCD():int
		{
			var cd:int= 5 - (getTimer()/1000 - time);
			return cd < 0 ? 0 : cd;
		}
		
		public function HejiSkillDataManager(pc:PrivateClass)
		{
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			buffArr=[];
			DistributionManager.getInstance().register(GameServiceConstants.SM_JOINT_HALO_INFO_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.CM_QUERY_JOINT_HALO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_RUNE_TRANSFORM,this);
			
		}
		
		public function getJointHaloData():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_JOINT_HALO,byteArray);
		}
		
		/**
		 * 
		 * 嵌入
		 */
		public function runeJointHalo(id:int,index:int,storage:int,slot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeByte(index);
			byteArray.writeByte(storage);
			byteArray.writeByte(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RUNE_JOINT_HALO,byteArray);
		}
		
		public function runeUpgrade(id:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_UPGRADE_JOINT_HALO,byteArray);
		}
		
		public function setMainRune(id:int):void
		{
			if(buffArr[mainBuffIndex].id == id)
			{
				return
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SET_MAIN_JOINT_HALO,byteArray);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.JOINT_PANEL_0020);
			time = getTimer()/1000;
		}
		
		public function runeTransform(storage:int,slot:int,viceStorage:int,viceSlot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(storage);
			byteArray.writeByte(slot);
			byteArray.writeByte(viceStorage);
			byteArray.writeByte(viceSlot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RUNE_TRANSFORM,byteArray);
		}
		
		private function dealJointHaloData(data:ByteArray):void
		{
			buffArr.splice(0,buffArr.length);
			var l:int=data.readInt();
			for(var i:int=0;i<l;i++)
			{
				var jointData:JointHaloData=new JointHaloData();
				jointData.id=data.readInt();
				jointData.level=data.readInt();
				jointData.type=data.readInt();
				if(jointData.type==MAIN_BUFF)
				{
					mainBuffIndex=i;
				}
				var jos:Array=[];
				jos.push(data.readInt());
				jos.push(data.readInt());
				jos.push(data.readInt());
				jos.push(data.readInt());
				jos.push(data.readInt());
				jos.push(data.readInt());
				jointData.buffs=jos;
				buffArr.push(jointData);
			}
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_JOINT_HALO_INFO_LIST:
					dealJointHaloData(data);
					break;
				case GameServiceConstants.SM_RUNE_TRANSFORM:
					dealRuneTransform(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealRuneTransform(data:ByteArray):void
		{
			replaceID=data.readInt();
		}
	}
}
class PrivateClass{}