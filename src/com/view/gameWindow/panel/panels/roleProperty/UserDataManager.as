package com.view.gameWindow.panel.panels.roleProperty
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.guardSystem.TimeManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class UserDataManager extends DataManagerBase
	{
		private static var _instance:UserDataManager;
		
		private var _totalOnlineTime:int;
		private var _adult:int;
		
		public static function getInstance():UserDataManager
		{
			if (!_instance)
			{
				_instance = new UserDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function UserDataManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_LOGIN_INFO, this);
		}
		
		public override function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_LOGIN_INFO:
					resolveLoginInfo(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function resolveLoginInfo(data:ByteArray):void
		{
			_adult = data.readByte();
			_totalOnlineTime = data.readInt();
			
			if (_adult == 0)
			{
				TimeManager.getInstance().initOnlineTimeAndStart(_totalOnlineTime);
			}
			
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeByte(1);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SYNC_TIME,data);
		}
		
		public function get adult():int
		{
			return _adult;
		}
		
		public function get totalOnlineTime():int
		{
			return _totalOnlineTime;
		}
		
		public static function clearInstance():void
		{
			_instance = null;
		}
	}
}

class PrivateClass{}