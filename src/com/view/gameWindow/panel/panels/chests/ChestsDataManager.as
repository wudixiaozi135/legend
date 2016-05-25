package com.view.gameWindow.panel.panels.chests
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class ChestsDataManager extends DataManagerBase
	{
		private static var _instance:ChestsDataManager;
        public var chestDatas:Vector.<ChestRewardData>;
		public static function get instance():ChestsDataManager
		{
			if(!_instance)
				_instance = new ChestsDataManager(new PrivateClass());
			return _instance;
		}
		
		public var _num :int;
		public function ChestsDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_BAOXIANG,this);
            DistributionManager.getInstance().register(GameServiceConstants.SM_GET_BAOXIANG_THING, this);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(proc == GameServiceConstants.SM_QUERY_BAOXIANG)
			{
				readChestsInfo(data);
            } else if (proc == GameServiceConstants.SM_GET_BAOXIANG_THING)
            {
                handlerSM_GET_BAOXIANG_THING(data);
            }
			super.resolveData(proc, data);
		}

        private function handlerSM_GET_BAOXIANG_THING(data:ByteArray):void
        {
            chestDatas = new Vector.<ChestRewardData>();
            var size:int = data.readInt();
            var item:ChestRewardData;
            while (size--)
            {
                item = new ChestRewardData();
                item.id = data.readInt();
                item.bornId = data.readInt();
                item.type = data.readByte();
                item.count = data.readInt();
                chestDatas.push(item);
            }
            FlyEffectMediator.instance.doChestRewardEffect();
        }
		
		private function readChestsInfo(data:ByteArray):void
		{
			_num = data.readInt();
		}
		
		public function requestChest(itemId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(itemId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_BAOXIANG,byteArray);

		}
	}
}
class PrivateClass{}