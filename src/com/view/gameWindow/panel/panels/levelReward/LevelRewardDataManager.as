package com.view.gameWindow.panel.panels.levelReward
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.LevelGiftCfgData;
    import com.model.consts.SlotType;
    import com.model.dataManager.DataManagerBase;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.levelReward.data.LevelRewardVo;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    /**
     * Created by Administrator on 2014/12/8.
     */
    public class LevelRewardDataManager extends DataManagerBase implements IObserver
    {
        public var rewardIndex:int = 0;
        public static var dataIsLoaded:Boolean = false;//数据是否收到
        public function LevelRewardDataManager()
        {
            super();
            DistributionManager.getInstance().register(GameServiceConstants.SM_LEVEL_GIFT_INFO, this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_LEVEL_GIFT, this);
            RoleDataManager.instance.attach(this);
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_LEVEL_GIFT_INFO:
                    handlerSM_LEVEL_GIFT_INFO(data);
                    break;
                case GameServiceConstants.SM_CHR_INFO:
                    updateLevel();
                    break;
                default :
                    break;
            }
            super.resolveData(proc, data);
        }

        private function updateLevel():void
        {
            if (!LevelRewardDataManager.dataIsLoaded) return;
            var total:int = getTotalRewards();
            if (rewardIndex >= total)
            {
                RoleDataManager.instance.detach(this);
                PanelMediator.instance.closePanel(PanelConst.TYPE_LEVEL_REWARD);
                return;
            }

            var cfg:LevelGiftCfgData = ConfigDataManager.instance.levelGiftCfgDatas(rewardIndex + 1);
            var lv:int = RoleDataManager.instance.lv;
            if (cfg.gift_level <= lv)
            {
                if (!PanelMediator.instance.openedPanel(PanelConst.TYPE_LEVEL_REWARD))
                {
                    PanelMediator.instance.openPanel(PanelConst.TYPE_LEVEL_REWARD);
                }
            } else
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_LEVEL_REWARD);
            }
        }

        private function handlerSM_LEVEL_GIFT_INFO(data:ByteArray):void
        {
            rewardIndex = data.readInt();
            LevelRewardDataManager.dataIsLoaded = true;
            updateLevel();
        }

        private function getTotalRewards():int
        {
            var dic:Dictionary = ConfigDataManager.instance.levelGiftCfgDic();
            var total:int = 0;
            for each(var item:LevelGiftCfgData in dic)
            {
                total++;
            }
            return total;
        }

        public function sendGetReward(index:int):void
        {
            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            data.writeInt(index);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_LEVEL_GIFT, data);
            data = null;
        }

        /**获取所有等级奖励礼包*/
        public function getRewards(index:int):Vector.<LevelRewardVo>
        {
            var cfg:LevelGiftCfgData = ConfigDataManager.instance.levelGiftCfgDatas(index);
            if (cfg == null) return null;
            var rewards:Array = cfg.gift.split("|");
            var items:Array, vo:LevelRewardVo, vec:Vector.<LevelRewardVo> = new Vector.<LevelRewardVo>();
            for (var i:int = 0, len:int = rewards.length; i < len; i++)
            {
                items = rewards[i].split(":");
                vo = new LevelRewardVo();
                vo.id = items[0];
                vo.type = items[1];
                vo.count = items[2];
                vo.job = items[3];
                vo.sex = items[4];
                vec.push(vo);
            }
            return vec;
        }

        /**获取符合职业性别等级奖励礼包*/
        public function getLimitRewards(index:int):Vector.<LevelRewardVo>
        {
            var vec:Vector.<LevelRewardVo> = new Vector.<LevelRewardVo>();
            var source:Vector.<LevelRewardVo> = getRewards(index);
            var i:int = 0, j:int = 0, len:int = 0;
            var mgt:RoleDataManager = RoleDataManager.instance;
            var sex:int = mgt.sex, job:int = mgt.job;
            for each(var item:LevelRewardVo in source)
            {
                if (item.type == SlotType.IT_ITEM)
                {
                    vec.push(item);
                } else
                {
                    var cfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(item.id);
                    if (cfg.sex == 0 || cfg.sex == sex)
                    {
                        if (cfg.job == 0 || cfg.job == job)
                        {
                            vec.push(item);
                        }
                    }
                }
            }
            if (vec.length > 6)
            {
                return vec.slice(0, 6);
            }
            return vec;
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }

        private static var _instance:LevelRewardDataManager = null;
        public static function get instance():LevelRewardDataManager
        {
            if (_instance == null)
            {
                _instance = new LevelRewardDataManager();
            }
            return _instance;
        }

        public function update(proc:int = 0):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_CHR_INFO:
                    updateLevel();
                    break;
                default :
                    break;
            }
        }
    }
}
