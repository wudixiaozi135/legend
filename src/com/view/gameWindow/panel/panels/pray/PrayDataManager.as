package com.view.gameWindow.panel.panels.pray
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.PrayCfgData;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.pray.data.PrayData;
    
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
	 * Created by Administrator on 2014/11/25.
	 */
	public class PrayDataManager extends DataManagerBase
	{
        //public static var clickType:int = 0;
		private static var _instance:PrayDataManager = null;
        public static var FREE_COIN_COUNT:int = 1;//免费金币次数
        public static var FREE_TICKET_COUNT:int = 1;//免费礼券次数
		public static function get instance():PrayDataManager
		{
			if (_instance == null) {
				_instance = new PrayDataManager();
			}
			return _instance;
		}

		public function PrayDataManager()
		{
			DistributionManager.getInstance().register(GameServiceConstants.SM_PRAY_INFO, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_PRAY_COST_INFO, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_QUERY_PRAY, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_PRAY, this);
		}

		private var _data:PrayData = new PrayData();
		public var currentTypeData:Array = [0,1];

		public function get data():PrayData
		{
			return _data;
		}

		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc) {
				case GameServiceConstants.SM_PRAY_INFO:
					handlerPrayInfo(data);
					break;
				case GameServiceConstants.SM_PRAY_COST_INFO:
					handlerCostInfo(data);
					break;
				case GameServiceConstants.CM_QUERY_PRAY:
					break;
				case GameServiceConstants.CM_PRAY:
					currentTypeData[1] = data.readInt();
					break;
				default :
					break;
			}
			super.resolveData(proc, data);
		}

		override public function clearDataManager():void
		{
			_instance = null;
		}

		public function queryInfo():void
		{
			var byte:ByteArray = new ByteArray();
			byte.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_PRAY, byte);
		}

		/**
		 * type 祈福花费类型
		 * */
		public function sendPrayRequest(type:int):void
		{
			var byte:ByteArray = new ByteArray();
			currentTypeData[0] = type;
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeByte(type);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_PRAY, byte);
		}

		public function dealSwitchPanlePray():void
		{
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_PRAY);
			if (!openedPanel)
			{
				PrayDataManager.instance.queryInfo();
				PanelMediator.instance.openPanel(PanelConst.TYPE_PRAY);
			}
			else {
				PanelMediator.instance.closePanel(PanelConst.TYPE_PRAY);
			}
		}

		public function getConfigData(type:int, count:int):PrayCfgData
		{
			var mgt:ConfigDataManager = ConfigDataManager.instance;
			return mgt.prayCfgData(type)[count];
		}

		private function handlerCostInfo(data:ByteArray):void
		{
			/*var prayCoin:int, prayTicket:int;
			prayCoin = data.readInt();
			prayTicket = data.readInt();
			if (prayCoin > 0) {
				RollTipMediator.instance.showRollTip(RollTipType.REWARD, StringConst.PANEL_PRAY_8 + prayCoin);
			}
			if (prayTicket > 0) {
				RollTipMediator.instance.showRollTip(RollTipType.REWARD, StringConst.PANEL_PRAY_9 + prayTicket);
			}*/

        }

		private function handlerPrayInfo(data:ByteArray):void
		{
			_data.coinCount = data.readInt();
			_data.coinTotal = data.readInt();
			_data.coinTotalCount = data.readInt();
			_data.goldCount = data.readInt();
			_data.goldTotal = data.readInt();
			_data.goldTotalCount = data.readInt();

            stasticFreeCount();
        }

        /**统计表里的免费次数*/
        public function stasticFreeCount():int
        {
            if (_data.coinCount)
            {
                FREE_COIN_COUNT = 0;
            }
            if (_data.goldCount)
            {
                FREE_TICKET_COUNT = 0;
            }
            return FREE_COIN_COUNT + FREE_TICKET_COUNT;
        }
	}
}
