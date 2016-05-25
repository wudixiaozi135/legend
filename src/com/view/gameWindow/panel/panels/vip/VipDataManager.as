package com.view.gameWindow.panel.panels.vip
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.PeerageCfgData;
    import com.model.configData.cfgdata.PeerageDescCfgData;
    import com.model.configData.cfgdata.VipCfgData;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.panels.vip.vipPrivilege.PrivilegeData;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    /**
	 * vip特权数据管理类
	 * @author Administrator
	 */	
	public class VipDataManager extends DataManagerBase
	{
		/**爵位福利描述总行数*/
		public static const TOTAL_WORDS:int = 8;
		/**vip等级奖励总个数*/
		public static const TOTAL_REWARDS:int = 6;
		/**vip最大等级*/
		public static const MAX_LV:int = 10;
		/**特权显示总行数*/
		public static const TOTAL_PRIVILEGES:int = 8;
		
		private static var _instance:VipDataManager;
		public static function get instance():VipDataManager
		{
			return _instance ||= new VipDataManager(new PrivateClass());
		}
		/**爵位*/
		public var peerage:int;
		
		/**爵位结束时间*/
		public var peerage_end:int;
		/**vip等级*/
		public var lv:int;
		/**vip经验*/
		public var exp:int;
		/**vip奖励领取情况，按等级左移位决定*/
		private var _vipGift:int;

		private var _privilegeDatas:Vector.<PrivilegeData>;
		
		private var _lvCanAutoSellStrongstone:int = -1;
		/**可自动出售非强化石需要的等级*/
		public function get lvCanAutoSellStrongstone():int
		{
			if(_lvCanAutoSellStrongstone == -1)
			{
				var cfgDts:Dictionary = ConfigDataManager.instance.getAllVipCfgData();
				var cfgDt:VipCfgData;
				var minLv:int;
				for each (cfgDt in cfgDts)
				{
					if(cfgDt.auto_sell_strongstone && (!minLv || minLv > cfgDt.level))
					{
						minLv = cfgDt.level;
					}
				}
				_lvCanAutoSellStrongstone = minLv;
			}
			return _lvCanAutoSellStrongstone;
		}
		
		public function VipDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_VIP_INFO,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_NOBILITY_BUY,this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_VIP_GIFT_GET, this);
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		/**请求VIP信息*/
		public function queryVipInfo():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_VIP_INFO,byteArray);
		}
		/**购买或续期爵位*/
		public function peerageBuy(value:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(value);//爵位值
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_NOBILITY_BUY,byteArray);
		}
		/**获得VIP奖励*/
		public function vipGiftGet(lv:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(lv);//vip等级
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_VIP_GIFT_GET,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				default:
					break;
				case GameServiceConstants.SM_VIP_INFO:
					dealVipInfo(data);
					break;
				case GameServiceConstants.CM_NOBILITY_BUY:
					trace("VipDataManager.resolveData(proc, data) 购买VIP成功");
					break;
			}
			super.resolveData(proc, data);
		}
		
		public var isInited:Boolean = false;
		private function dealVipInfo(data:ByteArray):void
		{
			isInited = true;
			var nobility:int = data.readInt();//4字节有符号整形，爵位id
			var nobility_end:int = data.readInt();//4字节有符号整形，爵位过期时间
			var vip:int = data.readByte();//1字节有符号整形，vip等级
			var vip_point:int = data.readInt();//4字节有符号整形，当前等级vip积分
			_vipGift = data.readInt();//4字节有符号整形，vip奖励领取情况，按等级左移位决定
			peerage = nobility;
			peerage_end = nobility_end;
			lv = vip;
			exp = vip_point;
			//测试代码
			/*peerage = 1;
			lv = 5;
			exp = 356;*/
			//
		}
		/**获得爵位配置信息*/
		public function get peerageCfgData():PeerageCfgData
		{
			var data:PeerageCfgData = ConfigDataManager.instance.peerageCfgData(peerage);
			return data;
		}
		/**获得爵位描述配置信息*/
		public function getPeerageDesc(peerage:int):String
		{
			var cfgDts:Dictionary,cfgDt:PeerageDescCfgData,temp:Vector.<String>;
			cfgDts = ConfigDataManager.instance.peerageDescCfgData(peerage);
			temp = new Vector.<String>();
			for each(cfgDt in cfgDts)
			{
				temp.length < cfgDt.index ? temp.length = cfgDt.index : null;
				temp[cfgDt.index] = cfgDt.desc;
			}
			var desc:String = '';
			var i:int,l:int = temp.length;
			for(i=1;i<l;i++)
			{
				desc += i != l-1 ? temp[i] + "|n|" : temp[i];
			}
			return desc;
		}
		/**获得VIP等级配置信息*/
		public function get vipCfgData():VipCfgData
		{
			return vipCfgDataByLv(lv);
		}
		/**获得下一级VIP等级配置信息*/
		public function get vipCfgDataNext():VipCfgData
		{
			return vipCfgDataByLv(lv+1);
		}
		/**根据VIP等级获取对应的配置信息*/
		public function vipCfgDataByLv(lv:int):VipCfgData
		{
			var data:VipCfgData = ConfigDataManager.instance.vipCfgData(lv);
			return data;
		}
		/**根据级别获取该级别奖励是否领取*/
		public function isRewardGetted(lv:int):Boolean
		{
			var b:Boolean = Boolean(_vipGift & (1 << lv));
			return b;
		}
		
		public function getPrivilegeData():Vector.<PrivilegeData>
		{
			if(!_privilegeDatas)
			{
				var i:int,l:int = MAX_LV;
				var j:int,jl:int = 17;
				_privilegeDatas = new Vector.<PrivilegeData>(jl,true);
				for(i=1;i<=l;i++)
				{
					var vipData:VipCfgData = ConfigDataManager.instance.vipCfgData(i);
					for(j=0;j<jl;j++)
					{
						var varName:String = VipCfgData.getVarName(j);
						if(varName=="")continue;
						var value:int = vipData[varName];
						if(!_privilegeDatas[j])
						{
							_privilegeDatas[j] = new PrivilegeData();
						}
						_privilegeDatas[j].name = VipCfgData.getVarStrName(j);
						_privilegeDatas[j].privileges.push(value);
					}
				}
			}
			return _privilegeDatas;
		}
	}
}
class PrivateClass{}