package com.view.gameWindow.panel.panels.everydayOnlineReward
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class EverydayOnlineRewardDatamanager extends DataManagerBase
	{
		public var onlineTime:int;
		public var getArr:Array = [];
		public var curIndex:int;
		public function EverydayOnlineRewardDatamanager()
		{
			super();
			DistributionManager.getInstance().register(GameServiceConstants.SM_ONLINE_WELFARE_INFO, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_ONLINE_WELFARE, this);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_ONLINE_WELFARE_INFO:
					dealRewardInfo(data);
					break;
				case GameServiceConstants.CM_GET_ONLINE_WELFARE:
					curIndex = data.readInt();
					break;
			}
			notify(proc);
		}
		
		private function dealRewardInfo(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			onlineTime = data.readInt();
			var num:int = data.readInt();
			var n:int = ConfigDataManager.instance.onlineWelfareVec().length;
			for(var i:int = 1;i<=n;i++)
			{
				getArr[i-1] = (num>>i)&1;
			}
		}
		
		public function dealSwitchPanel():void
		{
			askInfo();
			PanelMediator.instance.switchPanel(PanelConst.TYPE_EVERYDAY_ONLINE_REWARD);
		}
		
		public function askInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ONLINE_WELFARE_INFO,data);
		}
		
		
		public function getReward(id:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_ONLINE_WELFARE,data);
		}
		
		override public function clearDataManager():void
		{
			_instance = null;
		}
		
		private static var _instance:EverydayOnlineRewardDatamanager = null;
		public static function get instance():EverydayOnlineRewardDatamanager
		{
			if (_instance == null)
			{
				_instance = new EverydayOnlineRewardDatamanager();
			}
			return _instance;
		}
	}
}