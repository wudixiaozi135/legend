package com.view.gameWindow.mainUi.subuis.onlineReward
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.OnlineRewardShieldCfgData;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.util.UtilItemParse;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.utils.StringUtil;

    public class OnlineRewardDataManager extends DataManagerBase
	{
		private static var _instance:OnlineRewardDataManager;
		public static function get instance():OnlineRewardDataManager
		{
			return _instance ||= new OnlineRewardDataManager(new PrivateClass());
		}

        /// 在线装备
        public static const FIRE_DRAGON_TYPE:int = 1;//火龙
        public static const SHIELD_TYPE:int = 2;//在线盾
        public static const WING_TYPE:int = 3;//在线翅膀

		public var startTime:int;
		private var _get:int;
        public var count:int = -1;
        public var rewardId:int;//在线盾牌奖励的id
		public var _callBack:Function;

        public var activeFire:int = -1;//是否激活火龙之力
        public var activeShield:int = -1;//是否激活盾牌
        public var activeWing:int = -1;//是否激活翅膀
		public function OnlineRewardDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_ONLINE_REWARD_GET,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ONLINE_SHIELD_REWARD_GET,this);
            DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVATE_REWARD_GET, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_ONLINE_REWARD,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_ONLINE_SHIELD_REWARD,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_ACTIVATE_ONLINE_SHIELD_REWARD,this);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_ONLINE_REWARD_GET:
					dealOnlineRewardGet(data);
					break;
				case GameServiceConstants.SM_ONLINE_SHIELD_REWARD_GET:
					dealOnlineShieldGet(data);
					break;
				case GameServiceConstants.CM_GET_ONLINE_REWARD:
					if(_callBack != null)
					{
						_callBack();
					}
					break;
				case GameServiceConstants.CM_GET_ONLINE_SHIELD_REWARD:
                    handlerCM_GET_ONLINE_SHIELD_REWARD(data);
					break;
                case GameServiceConstants.SM_ACTIVATE_REWARD_GET:
                    handlerSM_ACTIVATE_REWARD_GET(data);
                    break;
				case GameServiceConstants.CM_ACTIVATE_ONLINE_SHIELD_REWARD:
					dealTip(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealTip(data:ByteArray):void
		{
			var type:int = data.readByte();
            var equipId:int = getEquipIdOrItemId(type);
            var cfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipId);
            if (cfg)
            {
                Alert.reward(StringUtil.substitute(StringConst.CONVERT_030, cfg.name));
            }
		}
		
        private function handlerSM_ACTIVATE_REWARD_GET(data:ByteArray):void
        {
            activeFire = data.readInt();
            activeShield = data.readInt();
            activeWing = data.readInt();
        }

        private function handlerCM_GET_ONLINE_SHIELD_REWARD(data:ByteArray):void
        {
            rewardId = data.readInt();
        }
		
		private function dealOnlineRewardGet(data:ByteArray):void
		{
			startTime = data.readInt();
			_get = data.readInt();
		}
		
		private function dealOnlineShieldGet(data:ByteArray):void
		{
            count = data.readInt();
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		public function sendData(id:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);//奖励Id
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_ONLINE_REWARD,byteArray);		
		}

        /**
         * @param type 1.火龙之心，2.盾牌  3.翅膀
         * */
        public function sendActiveEquip(type:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeInt(type);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ACTIVATE_ONLINE_SHIELD_REWARD, byte);
        }
		
		public function sendShieldData(id:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);//奖励盾牌Id
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_ONLINE_SHIELD_REWARD,byteArray);		
		}
		
		/**根据index获取该奖励是否领取*/
		public function isRewardGetted(index:int):Boolean
		{
			var b:Boolean = Boolean(_get & (1 << index));
			return b;
		}

        public function getEquipIdOrItemId(shieldId:int):int
        {
            var cfg:OnlineRewardShieldCfgData = null;
            cfg = ConfigDataManager.instance.onlineRewardShieldCfgData(shieldId);

            if (cfg == null) return 0;
            var desc:String = cfg.gift_reward;
            var arr:Array = desc.split("|");
            if (arr && arr.length <= 1)
            {
                return int(UtilItemParse.getItemString(arr[0])[3]);
            }

            var job:int = RoleDataManager.instance.job;
            var sex:int = RoleDataManager.instance.sex;
            var adds:Array, item_sex:int, item_job:int;

            for (var i:int = 0, len:int = arr.length; i < len; i++)
            {
                adds = UtilItemParse.getLoginReward(arr[i]);
                if (adds[1] == SlotType.IT_EQUIP)
                {
                    item_job = adds[3];
                    item_sex = adds[4];
                    if (item_job == 0 || item_job == job)
                    {
                        if (item_sex == 0 || item_sex == sex)
                        {
                            return adds[0];
                        }
                    }
                }
            }
            return 0;
        }
	}
}
class PrivateClass{}