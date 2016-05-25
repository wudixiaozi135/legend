package com.view.gameWindow.mainUi.subuis.rolehead
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class PkDataManager extends DataManagerBase
	{
		private static var _instance:PkDataManager;
		
		public static function get instance():PkDataManager
		{
			if(!_instance)
				_instance = new PkDataManager(new PrivateClass());
			return _instance;
		}
		
		public function PkDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_PK_MODE_INFO,this);
		}
		
		public var pkMode:int;//PK模式
		public var pkCamp:int;//活动阵营
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(proc == GameServiceConstants.SM_PK_MODE_INFO)
			{
				readPkModeInfo(data);
			}
			super.resolveData(proc, data);
		}	
		
		private function readPkModeInfo(data:ByteArray):void
		{
			pkMode = data.readByte();
			pkCamp = data.readByte();
			EntityLayerManager.getInstance().refreshPlayerTitle();
		}
		
		public function changePkMode(mode:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(mode);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_PK_MODE_CHANGE,byteArray);
		}
	}
}
class PrivateClass{}