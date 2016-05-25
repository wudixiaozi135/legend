package com.view.gameWindow.panel.panels.activitys.castellanWorship
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.dataManager.IDataManager;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.consts.StringConst;
	import com.pattern.Observer.Observe;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirmData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 膜拜城主数据管理类
	 * @author Administrator
	 */	
	public class WorshipDataManager extends Observe implements IDataManager
	{
		public var dtInfo:DataWorshipInfo;
		public var dtsRecord:Vector.<DataWorshipRecord>;
		public var dtTrace:DataWorshipTrace;

		public function get strPer():String
		{
			return dtTrace.time + "";
		}
		
		public function get strExpPer():String
		{
			return dtTrace.addExp + "";
		}
		
		public function get strExpTotal():String
		{
			return dtTrace.exp + "";
		}
		
		public function get actvCfgDt():ActivityCfgData
		{
			var cfgDt:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(ActivityFuncTypes.AFT_WORSHIP);
			return cfgDt;
		}
		
		public function get isReinLvEnough():Boolean
		{
			if(!actvCfgDt)
			{
				return false;
			}
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(actvCfgDt.reincarn,actvCfgDt.level);
			return checkReincarnLevel;
		}
		
		public function WorshipDataManager()
		{
			dtInfo = new DataWorshipInfo();
			dtsRecord = new Vector.<DataWorshipRecord>();
			dtTrace = new DataWorshipTrace();
			//
			DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_MASTER_WORSHIP,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_MASTER_WORSHIP_RECORD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MASTER_WORSHIP_TOTAL_EXP,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MASTER_WORSHIP_STATUS_BROADCAST,this);
			//
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_MASTER_WORSHIP_ACTION,this);
		}
		/**初始化面板*/
		public function cmQueryMasterWorship():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_MASTER_WORSHIP,byteArray);
		}
		/**
		 * 对雕像进行操作
		 * @param type 1:点赞  2:扔肥皂  3:调戏  4:养护  5:泼硫酸
		 */		
		public function cmMasterWorshipAction(type:int):void
		{
			if((dtInfo.isFirstType(type) && dtInfo.isFirstCountOver) || (dtInfo.isFamilyType(type) && dtInfo.isFamilyCountOver))
			{
				Alert.warning(StringConst.WORSHIP_TIP_0001);
				return;
			}
			var isNeedBuyItem:Boolean = dtInfo.isNeedBuyItem(type);
			if(isNeedBuyItem)
			{
				PanelBuyItemConfirmData.cfgDt = dtInfo.shopCfgDt[type];
				PanelMediator.instance.openPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);//1字节有符号整形  
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MASTER_WORSHIP_ACTION,byteArray);
		}
		/**查看消息记录*/
		public function cmQueryMasterWorshipRecord():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_MASTER_WORSHIP_RECORD,byteArray);
		}
		
		public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.CM_MASTER_WORSHIP_ACTION:
					dealCmMasterWorshipAction(data);
					break;
				case GameServiceConstants.SM_QUERY_MASTER_WORSHIP:
					dealSmQueryMasterWorship(data);
					break;
				case GameServiceConstants.SM_QUERY_MASTER_WORSHIP_RECORD:
					dealSmQueryMasterWorshipRecord(data);
					break;
				case GameServiceConstants.SM_MASTER_WORSHIP_TOTAL_EXP:
					dealSmMasterWorshipTotalExp(data);
					break;
				case GameServiceConstants.SM_MASTER_WORSHIP_STATUS_BROADCAST:
					dealSmMasterWorshipStatusBroadcast(data);
					break;
				default:
					break;
			}
			notify(proc);
		}
		
		private function dealCmMasterWorshipAction(data:ByteArray):void
		{
			/*var exp:int = data.readInt();
			Alert.reward(StringConst.WORSHIP_TIP_0002 + exp);*/
		}
		
		private function dealSmQueryMasterWorship(data:ByteArray):void
		{
			var cid:int = data.readInt();//  4字节有符号整形 0代表无
			var sid:int = data.readInt();//  4字节有符号整形 0代表无
			var name:String = data.readUTF();// utf8 名字 ""代表无
			var sex:int = data.readByte();//  1字节有符号整形	 城主性别
			var dignity:int = data.readInt();//	4字节有符号整形  当前尊严值
			var firstNum:int = data.readByte();// 1字节有符号整形 (点赞，扔肥皂今日已用次数)
			//如果是帮主，下发缩进部分
			var familyNum:int = data.bytesAvailable ? data.readByte() : -1;// 1字节有符号整形 （养护，泼硫酸已用次数）
			dtInfo.cid = cid;
			dtInfo.sid = sid;
			dtInfo.name = name;
			dtInfo.sex = sex;
			dtInfo.dignity = dignity;
			dtInfo.firstNum = firstNum;
			dtInfo.familyNum = familyNum;
			//
			dtInfo.changeNpcDynamicMode();
		}
		
		private function dealSmQueryMasterWorshipRecord(data:ByteArray):void
		{
			dtsRecord.length = 0;
			var size:int = data.readInt();//4字节有符号整形 数量
			while(size--)//下面缩进部分为按照size数量的循环
			{
				var time:int = data.readInt();//       4字节有符号整形  时间
				var familyName:String = data.readUTF();// utf8             帮会名称
				var name:String = data.readUTF();//	   utf8             玩家名字
				var type:int = data.readByte();//       1字节有符号整形  4:养护  5:泼硫酸
				var value:int = data.readInt();//      4字节有符号整形  雕像尊严值的变化
				var dtRecord:DataWorshipRecord = new DataWorshipRecord();
				dtRecord.time = time;
				dtRecord.familyName = familyName;
				dtRecord.name = name;
				dtRecord.type = type;
				dtRecord.value = value;
				dtsRecord.push(dtRecord);
			}
		}
		
		private function dealSmMasterWorshipTotalExp(data:ByteArray):void
		{
			var exp:int = data.readInt();// 4字节有符号整形 累计经验
			var time:int = data.readInt();// 4字节有符号整形 几秒增加的经验
			var addExp:int = data.readInt();// 4字节有符号整形 增加的经验
			dtTrace.exp = exp;
			dtTrace.time = time;
			dtTrace.addExp = addExp;
			ActivityDataManager.instance.notify(ModelEvents.UPDATE_MAP_ACTIVITY);
			/*Alert.reward(StringConst.WORSHIP_TIP_0002 + addExp);*/
		}
		
		private function dealSmMasterWorshipStatusBroadcast(data:ByteArray):void
		{
			var dignity:int = data.readInt();//	4字节有符号整形  当前尊严值
			var sex:int = data.readByte();//  1字节有符号整形	 城主性别
			var name:String = data.readUTF();
			dtInfo.dignity = dignity;
			dtInfo.sex = sex;
			dtInfo.name = name;
			//
			dtInfo.changeNpcDynamicMode();
		}
	}
}