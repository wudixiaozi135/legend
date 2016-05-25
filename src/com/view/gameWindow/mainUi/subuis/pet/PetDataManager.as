package com.view.gameWindow.mainUi.subuis.pet
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.ConstPetMode;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class PetDataManager extends DataManagerBase
	{
		private static var _instance:PetDataManager;
		
		public static function get instance():PetDataManager
		{
			if(!_instance)
				_instance = new PetDataManager(new PrivateClass());
			return _instance;
		}
		
		public function PetDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_PET_BASIC_INFO,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_PET_LEVEL_UP,this);
		}
		
		public var group_id:int;
		public var grade:int;
		public var mode:int;
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(proc == GameServiceConstants.SM_PET_BASIC_INFO)
			{
				group_id = data.readInt();
				grade = data.readShort();
				mode = data.readByte();
			}
			else if(proc == GameServiceConstants.CM_PET_LEVEL_UP)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.PET_0003);
			}
			super.resolveData(proc, data);
		}
		
		public function changePetModel():void
		{
			var model:int;
			if(mode == ConstPetMode.PM_IDLE)
			{
				model = ConstPetMode.PM_ACTIVE;
				Alert.message(StringConst.PET_0008);
			}
			else if(mode == ConstPetMode.PM_ACTIVE)
			{
				model = ConstPetMode.PM_IDLE;
				Alert.message(StringConst.PET_0009);
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(model);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHANGE_PET_MODE,byteArray);
		}
		
		public function callPetBack():void
		{
			Alert.message(StringConst.PET_0010);
			var byteArray:ByteArray = new ByteArray();
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CALL_PET_BACK,byteArray);
		}
		
		public function petLvUp(costType:int,storage:int,slot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(costType);
			byteArray.writeByte(storage);
			byteArray.writeByte(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_PET_LEVEL_UP,byteArray);
		}
	}
}
class PrivateClass{}