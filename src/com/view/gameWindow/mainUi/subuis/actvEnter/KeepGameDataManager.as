package com.view.gameWindow.mainUi.subuis.actvEnter
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.KeepRewardCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.newMir.NewMirMediator;

    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/1/28.
     */
    public class KeepGameDataManager extends DataManagerBase
    {
        /**收藏游戏次数*/
        public var count:int = 0;

        public function KeepGameDataManager()
        {
            super();

            DistributionManager.getInstance().register(GameServiceConstants.SM_GET_GAME_COLLECTION_REWORD, this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_GAME_COLLECTION_REWORD, this);
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_GET_GAME_COLLECTION_REWORD:
                    handlerSM_GET_GAME_COLLECTION_REWORD(data);
                    break;
                case GameServiceConstants.CM_GET_GAME_COLLECTION_REWORD:
                    handlerSuccess();
                    break;
                default :
                    break;
            }
            super.resolveData(proc, data);
        }

        private function handlerSuccess():void
        {
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var startPoint:Point = new Point(newMirMediator.width >> 1, newMirMediator.height >> 1);
            var endPoint:Point;

            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                endPoint = mc.localToGlobal(new Point(mc.btnBag.x + (mc.btnBag.width) * .5 - 5, mc.btnBag.y + ((mc.btnBag.height) >> 1)));
            }
            FlyEffectMediator.instance.doFlyTicket(startPoint, endPoint);
            var cfg:KeepRewardCfgData = ConfigDataManager.instance.keepGameCfgData(1);
            var ticket:int = 0;
            if (cfg)
            {
                ticket = cfg.bind_gold;
            }
            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.KEEP_GAME_001, ticket));
        }

        private function handlerSM_GET_GAME_COLLECTION_REWORD(data:ByteArray):void
        {
            if (!data) return;
            count = data.readInt();
        }

        /**收藏游戏*/
        public function sendKeepGame():void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_GAME_COLLECTION_REWORD, byte);
            byte = null;
        }

        override public function clearDataManager():void
        {
            super.clearDataManager();
        }

        private static var _instance:KeepGameDataManager = null;
        public static function get instance():KeepGameDataManager
        {
            if (_instance == null)
            {
                _instance = new KeepGameDataManager();
            }
            return _instance;
        }
    }
}
