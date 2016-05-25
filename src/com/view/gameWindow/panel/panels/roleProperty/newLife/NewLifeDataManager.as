package com.view.gameWindow.panel.panels.roleProperty.newLife
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.dataManager.DataManagerBase;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class NewLifeDataManager extends DataManagerBase
	{
		private static var _instance:NewLifeDataManager;
		
		public static function get instance():NewLifeDataManager
		{
			if(!_instance)
				_instance = new NewLifeDataManager(new PrivateClass());
			return _instance;
		}
		
		public function NewLifeDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_REINCARN,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_REINCARN_DUNGEON_INFO,this);
		}
		
		public var reincarn:int;
		public var dungeon:int
		public var time:int;
		
		public function sendData():void
		{
			var byteArr:ByteArray = new ByteArray();
			byteArr.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_REINCARN,byteArr);
		}
		
		public function enterReincarnDungeon():void
		{
			var byteArr:ByteArray = new ByteArray();
			byteArr.endian = Endian.LITTLE_ENDIAN;
			byteArr.writeByte(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_REINCARN_DUNGEON,byteArr);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.CM_REINCARN:
					dealReincarn(data);
					break;
				case GameServiceConstants.SM_REINCARN_DUNGEON_INFO:
					dealReincarnDungeon(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealReincarn(data:ByteArray):void
		{
			reincarn = data.readInt();
		}
		
		private function dealReincarnDungeon(data:ByteArray):void
		{
			dungeon = data.readInt();
			time = data.readInt();
		}
	}
}
class PrivateClass{}