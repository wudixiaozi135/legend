package com.view.gameWindow.panel.panels.smartLoad
{
	import com.model.business.flashVars.FlashVarsManager;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.dataManager.DataManagerBase;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SmartLoadDatamanager extends DataManagerBase
	{
		private static var _instance:SmartLoadDatamanager = null;
		public static function get instance():SmartLoadDatamanager
		{
			if (_instance == null)
			{
				_instance = new SmartLoadDatamanager();
			}
			return _instance;
		}
		public var count:int;
		public function SmartLoadDatamanager()
		{
			super();
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_MICRO_REWARD, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_GET_MICRO_REWARD_REWORD, this);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.CM_MICRO_REWARD:
					break;
				case GameServiceConstants.SM_GET_MICRO_REWARD_REWORD:
					dealCount(data);
					break;
			}
			notify(proc);
		}
		
		private function dealCount(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			count = data.readInt();
		}
		
		public function getRewardInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			var mini:int = FlashVarsManager.getInstance().isMini;
			if(mini==1)
				data.writeInt(1);
			else
				data.writeInt(2);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LOGIN_TYPE,data);
		}
		
		public function getSmartReward():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MICRO_REWARD,data);
		}
	}
}