package com.view.gameWindow.panel.panels.welfare
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.WorldLevelCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.convert.ConvertDataManager;
    import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
    import com.view.gameWindow.panel.panels.everydayOnlineReward.EverydayOnlineRewardDatamanager;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
    import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
    import com.view.gameWindow.panel.panels.position.PositionDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.smartLoad.SmartLoadDatamanager;
    import com.view.gameWindow.util.ServerTime;
    
    import flash.net.SharedObject;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import mx.utils.StringUtil;

    public class WelfareDataMannager extends DataManagerBase
	{
		private static var _instance:WelfareDataMannager;
		public static function get instance():WelfareDataMannager
		{
			return _instance ||= new WelfareDataMannager(new PrivateClass());
		}
		public var fillSignCount:int;  //补签次数
		public var qianInMonthNum:int;
		public var awardList:Array = [0,0,0,0,0];
		public var awardCount:int = 2;   // 2 5 10 ，18 ，26
		public var signList:Array = [];
        ////////////flag 和 isGetOffLineExp这两个字段来判断离线经验是否领取 flag=1,isGetOffLineExp=true
        public var flag:int = 0;//
		public var isGetOffLineExp:Boolean = false;
        ////////////////
		//离线经验
		public var offLineTime:int;  //4字节有符号整形  离线时间（秒 数）
		public var openServiceDay:int;  //4字节有符号整形 开服时间
		public var openDay:int;
		public var worldLevel:int; //世界等级
        public var signState:int;   // 是否已经签到
		public var signFlag:Boolean = false;
		public var selectTab:int;
		public var awardIndex:int;
		public var initOpenTime:Boolean = false;
		private var itemID:String;
		 
		public function WelfareDataMannager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			/*public static const ERR_EXCHANGE_CODE_NOT_EXIST:int = 89;
			public static const ERR_EXCHANGE_CODE_USED:int = 90;
			public static const ERR_EXCHANGE_CODE_ITEM_MORE_TIMES:int = 91;*/
			DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_SIGN,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_OFF_LINE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SYS_SERVER_CONFIG_INFO,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_SIGN,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FILL_SIGN,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_SIGN_REWARD,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_OFF_LINE_EXP,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EXCHANGE_CODE,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_EXCHANGE_CODE_NOT_EXIST,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_EXCHANGE_CODE_USED,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_EXCHANGE_CODE_ITEM_MORE_TIMES,this);
		 	 
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{ 
			switch(proc)
			{
				case GameServiceConstants.SM_QUERY_SIGN:
				{
                    dealQuerySign(data); 
					break;
				} 
				case GameServiceConstants.CM_SIGN:
				{
					if(!signFlag)
					{
						Alert.message(StringConst.WELFARE_PANEL_0014);
					}
					break;
				}
				case GameServiceConstants.CM_GET_OFF_LINE_EXP:
				{
					Alert.message(StringConst.WELFARE_PANEL_0015);
					isGetOffLineExp = true;
					break;
				}
				case GameServiceConstants.CM_FILL_SIGN:
				{
					
					break;
				}
				case GameServiceConstants.CM_GET_SIGN_REWARD:
				{
					Alert.message(StringConst.WELFARE_PANEL_0016);
					break;
				}
			 	case GameServiceConstants.SM_QUERY_OFF_LINE:
				{
					dealQueryOffLine(data);
					break;
				} 
				case GameServiceConstants.SM_SYS_SERVER_CONFIG_INFO:
				{
					dealsysServerInfor(data);
					break;
				}	
				case GameServiceConstants.CM_EXCHANGE_CODE:
				{
					Alert.message(StringUtil.substitute(StringConst.WELFARE_PANEL_0036,itemID));
					break;
				}
				case GameServiceConstants.ERR_EXCHANGE_CODE_ITEM_MORE_TIMES:
				{
					Alert.message(StringConst.WELFARE_PANEL_0040);
					break;
				}
				case GameServiceConstants.ERR_EXCHANGE_CODE_USED:
				{
					Alert.message(StringConst.WELFARE_PANEL_0039);
					break;
				}
				case GameServiceConstants.ERR_EXCHANGE_CODE_NOT_EXIST:
				{
					Alert.message(StringConst.WELFARE_PANEL_0038);
					break;
				}
 	
			}
			super.resolveData(proc, data);
		}
		
		private function dealsysServerInfor(data:ByteArray):void
		{
			ServerTime.openTime =  data.readInt();
			ServerTime.firstLongChengOpen = data.readByte();
			initOpenTime = true;
			DgnDataManager.instance.queryChrDungeonInfo();
			PositionDataManager.instance.requestInfo();
			HeroDataManager.instance.requestHeroUpgradeData();
			ConvertDataManager.instance.initCfg();
			PanelMailDataManager.instance.getMailList();
			SmartLoadDatamanager.instance.getRewardInfo();
			EverydayOnlineRewardDatamanager.instance.askInfo();
		}
		//查询
		public function querySign():void
		{
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN; 
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_SIGN,byte);
		}
		
		//领取奖励物品
		public function getSignReward(count:int):void
		{
			var byte:ByteArray = new ByteArray();     
			byte.endian = Endian.LITTLE_ENDIAN; 
			byte.writeByte(count);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_SIGN_REWARD,byte);
		}
		//补签
		public function fillSign(day:int):void
		{
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN; 
			byte.writeInt(day);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FILL_SIGN,byte);
		}
		//签到
		public function sign():void
		{
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN; 
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SIGN,byte);
		}
		//离线经验查询
		public function queryOffLine():void
		{
			//
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN; 
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OFF_LINE,byte);
		}
		
		//领取连线经验
		public function getOffLineExp(type:int):void
		{
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN; 
			byte.writeByte(type);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_OFF_LINE_EXP,byte);
		}
		
		//领取激活码的奖励
		public function getActivateAward(str:String):void
		{
			itemID = str;
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN; 
			byte.writeUTF(str);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EXCHANGE_CODE,byte);
		}
		private function dealQuerySign(data:ByteArray):void
		{
			/*offLineTime 4字节有符号整形  离线时间（分钟）
			signInfo 4字节有符号整形  签到的信息
			fillSignCount 4字节有符号整形 还剩几次补签
			getRewardInfo 4字节有符号整形  领取的信息*/
			//offLineTime = data.readInt();
			qianInMonthNum = 0;
			signList = [];
			awardList = [];
			var signInfo:int = data.readInt();
			var getRewardInfo:int = data.readInt();
			fillSignCount = data.readInt();
			var i:int = 0,n:int,obj:Object;
			while(31 > i)
			{
				n = (signInfo >>i) & 1;
				/*if(n > 0)
				{
					signList.push(i);
				}*/
				signList.push(n);
				qianInMonthNum += n;
				i++;
			}
			//trace("qianInMonthNum fillSignCount>>>>>>>>>>>>>>>>>>>>",qianInMonthNum,"  ",fillSignCount);
			//trace("signList>>>>>>>>>>>>>>>>>>>>",signList);
			var temp:Array = [2,5,10,18,26];
			for(var j:int = 0;j < temp.length;j++)
			{
				awardList[j] = (getRewardInfo >> temp[j]) & 1;

			}
			for (var d:int=0;d<awardList.length;d++)
			{
				if(awardList[d]==0)
				{
					awardIndex=d;
					break;
				}
			}
			//trace("awardList>>>>>>>>>>>>>>>>>>>>",awardList);
		}
		private function dealQueryOffLine(data:ByteArray):void
		{
			offLineTime = data.readInt();
			openDay = data.readInt();
			openServiceDay = data.readInt();//世界等级的开服天数
			var maxday:int = ConfigDataManager.instance.maxOpenDay-1;
			var day:int = openServiceDay>maxday?maxday:openServiceDay;
			var worldCfg:WorldLevelCfgData =  ConfigDataManager.instance.worldLevel(day+1);
			if(worldCfg)
				worldLevel = worldCfg.world_level;  //世界等级
			signState = data.readByte();  //0未签到 1已签到  2
			
			if(30 > RoleDataManager.instance.lv)
				return;
			//var 
			if(signState == 0)
			{
				signFlag = true;
				if(offLineTime>=3600)
				{
					dealSwitchTab(1);
				}
				else
				{
					dealSwitchTab(0);
				}
			}
			else
			{
				if(!signFlag)
				{
					var bool:Boolean =getflag(); 
					if(bool)
						Alert.message(StringConst.WELFARE_PANEL_0017);  //该消息在今天已经签到的前提下，只提示一次
					signFlag = true;
				}
				if(checkOffLineTime())
					return;
				
				PanelMediator.instance.closePanel(PanelConst.TYPE_WELFARE);
			} 
		} 
		
		public   function checkOffLineTime():Boolean
		{
			var arr:Array = getRecivableAward();
			var bool:Boolean = false;
			if(arr.length>0)
			{
				dealSwitchTab(0);
				bool = true;
			}
			
			if(offLineTime>=3600 && arr.length==0)
			{
				dealSwitchTab(1); 
				bool = true;
			}
			return bool;
		}
		public function dealSwitchTab(index:int):void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_WELFARE);
			var panel:PanelWelfare = PanelMediator.instance.openedPanel(PanelConst.TYPE_WELFARE) as PanelWelfare;
			if(panel)
				panel.viewHandle.switchTab(index);
		}
		
		public function dealSwitchPanleWelfare():void
		{
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_WELFARE);
			if(!openedPanel)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_WELFARE);
				checkOffLineTime();
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_WELFARE);
			}
		}
		/**
		 * 
		 * 安全级别低，将数据存储本地，标识小时是否有提示
		 */
		public function getflag():Boolean
		{
			var currentDate:Date = ServerTime.date;
			var firstDate:Date = new Date(currentDate.fullYear,currentDate.month,currentDate.date,0,0,0);
			var endDate:Date = new Date(currentDate.fullYear,currentDate.month,currentDate.date,23,59,59);
			var so:SharedObject = SharedObject.getLocal('newMir');
			var roleName:String = RoleDataManager.instance.name;
			var obj:Object = so.data[roleName];  
			var flag:Boolean;//86400000
			if(obj)
			{
				if(obj['lastSignTime'])
				{
					var lastSignTime:Number = obj['lastSignTime'];
					
					if(firstDate.time >lastSignTime)
					{
						delete obj['isSign']; //过期了  第一次
						flag =  true; 
					}else if(lastSignTime > firstDate.time && endDate.time > lastSignTime)
					{
						if(obj['isSign'])	
						{
							flag = false; // 第2次以上
						}
						else
						{
							obj['isSign'] = 1;
							flag = true; // 第1次 
						}
					}
					 
					obj['lastSignTime'] = currentDate.time;
					 
				}
				else
				{
					flag =  true;
					obj['lastSignTime']	= currentDate.time;
					obj['isSign'] = 1;
				}
			}
			else
			{
				flag =  true;
				obj = {};
				obj['lastSignTime']	= currentDate.time;
				obj['isSign'] = 1;
			}
			so.data[roleName] = obj;
			so.flush();
			return flag;
		}
		
		public function getRecivableAward():Array
		{
			var temp:Array = [2,5,10,18,26];
            var arr:Array = [];
			for(var i:int=0;i<temp.length;i++)
			{
				if(qianInMonthNum>=temp[i])
				{
					if(awardList[i]==0)
					{
						arr.push(i);
					}
				}
			}
//			if(qianInMonthNum<temp[0])
//			{
//				return arr ;
//			}
//			var index:int;
//			if(qianInMonthNum>temp[4]){
//				index = 4;
//			}else
//			{
//				for(var i:int = 0;i<temp.length;i++)
//				{
//					if(temp[i] <= qianInMonthNum && temp[i+1]>qianInMonthNum)
//						index = i;
//				}
//			}
//			
//			var count:int;
//			for(i = 0;i< index+1;i++)
//			{
//				if(awardList[i] == 0)
//					arr.push(i);
//			}
			return arr;
			
			
		}
		
		public function getSignNum():int
		{
			return fillSignCount + 1 - signState;
		}
		
		public function reset():void
		{ 
			selectTab = 0;
		}
	}
}
class PrivateClass{}