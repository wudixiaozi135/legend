package com.view.gameWindow.panel.panels.position
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.PositionCfgData;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class PositionDataManager extends DataManagerBase
	{
		
		private static var _instance:PositionDataManager;
		
		public static function get instance():PositionDataManager
		{
			if(!_instance)
				_instance = new PositionDataManager(new PrivateClass());
			return _instance;
		}
		
		
		public var _callBack:Function;
		
		public function PositionDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_POSITION_INFO,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_ENTRY_POSITION,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_POSITION_CHOP,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_POSITION_SALARY,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_UPDATA_POSITION_CHOP,this);
		}
		
		public var position:int;// 官职
		public var role_chopid:int;//角色官印装备id
		public var hero_chopid:int;//英雄官印装备id
		public var rolePositionLevel:int;
		public var heroPositionLevel:int;
		public var isget:int;//是否领取过俸禄
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_POSITION_INFO:
					readPositionInfo(data);
					break;
				case GameServiceConstants.CM_ENTRY_POSITION:
					dealEnterPosition();
					break;
				case GameServiceConstants.CM_GET_POSITION_CHOP:
					dealGetPositionChop();
					break;
				case GameServiceConstants.CM_GET_POSITION_SALARY:
					break;
				case GameServiceConstants.CM_UPDATA_POSITION_CHOP:
					dealUpdatePositionChop();
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealEnterPosition():void
		{
			if(_callBack != null)
			{
				_callBack();
			}
		}
		
		private function dealGetPositionChop():void
		{
			if(_callBack != null)
			{
				_callBack();
			}
		}
		
		private function dealUpdatePositionChop():void
		{
			if(_callBack != null)
			{
				_callBack();
			}
		}
		
		public function requestInfo():void
		{
			var byteArray:ByteArray = new ByteArray();
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_POSITION,byteArray);
		}
		/**
		 * 查询官职信息
		 * @param data
		 * 
		 */		
		private function readPositionInfo(data:ByteArray):void
		{
 			position = data.readInt();
			role_chopid = data.readInt();
			hero_chopid = data.readInt();
			rolePositionLevel=data.readInt();
			heroPositionLevel=data.readInt();
			isget = data.readInt();
		}
		/**
		 * 入职官位
		 * @param positionlevel
		 * 
		 */		
		public function enterPosition(positionlevel:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(positionlevel);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTRY_POSITION,byteArray);
		}
		/**
		 *领取官印 
		 * @param index
		 * 
		 */	
		public function getPositionChop(index:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(index);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_POSITION_CHOP,byteArray);
		}
		/**
		 * 领取俸禄
		 * @param type
		 * 
		 */		
		public function getPositionSalary(type:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(type);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_POSITION_SALARY,byteArray);
		}
		/**
		 *升级官印掌握 
		 * @param type
		 * 
		 */		
		public function updatePositionChop():void
		{
			var byteArray:ByteArray = new ByteArray();
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_UPDATA_POSITION_CHOP,byteArray);
		}
		
		
		public function getPositionNum():int
		{
			var role:RoleDataManager = RoleDataManager.instance;
			var hero:HeroDataManager = HeroDataManager.instance;
			var data:PositionCfgData;
			var rolePosId:int= role.getPositionChopId();
			var heroPosId:int = hero.getPositionChopId();
			var count:int;
			if(role.position == 0){
				data =  ConfigDataManager.instance.positionCfgData(role.position+1);
				if(role.merit >data.exploit_cost)
					count++;
			}else{
				data = ConfigDataManager.instance.positionCfgData(role.position);
				if(rolePosId!=data.chopid&&(role.reincarn>data.change_count||(role.reincarn == data.change_count&&role.lv>=data.chr_level)))
					count++;
				if(heroPosId!=data.hero_chopid&&(hero.grade>data.hero_groude||(hero.grade == data.hero_groude&&hero.lv>=data.hero_level)))
					count++;
				if(rolePosId == data.chopid&&heroPosId==data.hero_chopid)
				{
					if(role.position == 30)
						return 0;
					data = ConfigDataManager.instance.positionCfgData(role.position+1);
					if(role.merit >data.exploit_cost)
						count++;
				}
			}
			return count;
		}
	}
}
class PrivateClass{}