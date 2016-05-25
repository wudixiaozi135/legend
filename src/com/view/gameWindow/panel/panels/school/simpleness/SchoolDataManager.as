package com.view.gameWindow.panel.panels.school.simpleness
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.FamilyCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberData;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.PageListData;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimerManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;
	
	public class SchoolDataManager extends DataManagerBase
	{
		private static var _instance:SchoolDataManager;
		public var selectTab:int;
		public var schoolList:Array;
		public var schoolListPage:PageListData;
		public var lookSchoolData:SchoolData;
		public var attackSchoolDic:Dictionary;
		public var selectSchoolListState:int;
		public static const PAGE_DATA_COUNT:int=10;
		public static const UPDATE_TAB_INDEX:int=-99;
		public function SchoolDataManager()
		{
			if(_instance==null)
			{
				_instance=this;
			}
			/**错误：ERR_PLAYER_NOT_EXIST 对方下线或者不存在
			ERR_LEAVE_FAMILY_TIME 对方退帮未达到2小时，无法创建或者加入帮会
			ERR_HAVE_FAMILY 对方已有帮会
			ERR_FAMILY_ENOUGH_NUM 帮派人员已满
			ERR_POSITION_NOT 权限不够
			ERR_NOT_IN_FAMILY 你不在帮会中*/
			schoolList=[];
			schoolListPage=new PageListData(PAGE_DATA_COUNT);
			schoolBaseData=new SchoolBasicData();
			attackSchoolDic=new Dictionary();
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_LEAVE_FAMILY_TIME,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_NAME_EXIST,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_HAVE_FAMILY,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_NOT_FAMILY,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_ENOUGH_NUM ,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_NOT_APPLY ,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_ALREADY_APPLY ,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_PLAYER_NOT_EXIST ,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_POSITION_NOT ,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_NOT_IN_FAMILY ,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_POSITION_ENOUGH_COUNT,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_EDIT_TIME,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_MAP_IS_NOT_NORMAL,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_CALLER_MAP_IS_NOT_NORMAL,this);
//			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_FIGHT_HAVE,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_FIGHT_ALREALY,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_FIGHT_HAVE,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_LONGCHENG_ACTIVITY_BEGIN,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_STORAGE_IS_FULL,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_STORAG_DESTROY,this);	
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_STORAGE_EQUIP_IS_EXCHANGE,this);	
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_FAMILY_STORAG_NOT_THIS_EQUIP,this);	
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_MASTER_WORSHIP_ACTIVITY_BEGIN,this);	
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FAMILY_CREATE,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FAMILY_FIGHT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_LIST_QUERY,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_APPLY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_APPLY_SUCCESS,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_LIST_QUERY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_APPLY_CANCEL_SUCCESS,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_INVITE_INFO,this);

			
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_BASIC_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_DISSOLVE_MONEY_NOT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_APPLY_ACTION,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_POSITION_TITLE_QUERY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_INVITE_REFUSE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_BROAD,this);

		}
		
		public var schoolName:String;
		public var schoolBaseData:SchoolBasicData;

		public var positionDic:Dictionary;
		public var positionArr:Array;
		
		public static function getInstance():SchoolDataManager
		{
			return _instance||new SchoolDataManager();
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.ERR_LEAVE_FAMILY_TIME :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0016);
					break;
				case GameServiceConstants.ERR_FAMILY_NAME_EXIST :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0017);
					break;
				case GameServiceConstants.ERR_HAVE_FAMILY :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0018);
					break;
				case GameServiceConstants.ERR_NOT_FAMILY :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0034);
					break;
				case GameServiceConstants.ERR_FAMILY_ENOUGH_NUM  :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0035);
					break;
				case GameServiceConstants.ERR_FAMILY_ALREADY_APPLY :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0036);
					break;
				case GameServiceConstants.ERR_FAMILY_NOT_APPLY :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0037);
					break;
				case GameServiceConstants.ERR_PLAYER_NOT_EXIST :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0039);
					break;
				case GameServiceConstants.ERR_POSITION_NOT :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0040);
					break;
				case GameServiceConstants.ERR_FAMILY_NOT_APPLY :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0041);
					break;
				case GameServiceConstants.ERR_POSITION_ENOUGH_COUNT  :
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0053);
					break;
				case GameServiceConstants.ERR_NOT_IN_FAMILY:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0054);
					break;
				case GameServiceConstants.ERR_EDIT_TIME:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0058);
					break;
				case GameServiceConstants.ERR_MAP_IS_NOT_NORMAL:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0059);
					break;
				case GameServiceConstants.ERR_CALLER_MAP_IS_NOT_NORMAL:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0060);
					break;
				case GameServiceConstants.ERR_FAMILY_FIGHT_ALREALY:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0062);
					break;
				case GameServiceConstants.ERR_FAMILY_FIGHT_HAVE:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0063);
					break;
				case GameServiceConstants.ERR_LONGCHENG_ACTIVITY_BEGIN:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0067);
					break;
				case GameServiceConstants.CM_FAMILY_FIGHT:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0066);
					break;
				case GameServiceConstants.ERR_FAMILY_STORAGE_IS_FULL:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0068);
					break;
				case GameServiceConstants.ERR_FAMILY_STORAG_DESTROY:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0069);
					break;
				case GameServiceConstants.ERR_FAMILY_STORAGE_EQUIP_IS_EXCHANGE:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0070);
					break;
				case GameServiceConstants.ERR_FAMILY_STORAG_NOT_THIS_EQUIP:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0071);
					break;
				case GameServiceConstants.ERR_MASTER_WORSHIP_ACTIVITY_BEGIN:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0074);
					break;
				case GameServiceConstants.CM_FAMILY_CREATE:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0020,SchoolDataManager.getInstance().schoolName));
					PanelMediator.instance.closePanel(PanelConst.TYPE_SCHOOL_CREATE);
					break;
				case GameServiceConstants.SM_FAMILY_APPLY_SUCCESS:
					dealFamilyJoinSuccess(data);
					break;
				case GameServiceConstants.SM_FAMILY_APPLY_CANCEL_SUCCESS:
					dealFamilyCancelJoinSuccess(data);
					break;
				case GameServiceConstants.SM_FAMILY_LIST_QUERY:
					dealSchoolList(data);
					break;
				case GameServiceConstants.SM_FAMILY_BASIC_INFO:
					dealSchoolBasicInfo(data);
					break;
				case GameServiceConstants.SM_FAMILY_DISSOLVE_MONEY_NOT:
					dealSchoolNotMoney(data);
					break;
				case GameServiceConstants.SM_FAMILY_APPLY_ACTION:
					dealSchoolApplyAction(data);
					break;
				case GameServiceConstants.SM_FAMILY_POSITION_TITLE_QUERY:
					dealSchoolPositionTitle(data);
					break;
				case GameServiceConstants.SM_FAMILY_INVITE_REFUSE:
					dealSchoolInviteResult(data);
					break;
				case GameServiceConstants.SM_FAMILY_BROAD:
					dealSchoolBroad(data);
					break;
				case GameServiceConstants.SM_FAMILY_INVITE_INFO:
					dealInviteSuccess(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealInviteSuccess(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var name:String = data.readUTF();
			Alert.message(StringUtil.substitute(StringConst.SCHOOL_PANEL_0072,name));
		}
		
		private function dealSchoolBroad(data:ByteArray):void
		{
			var type:int=data.readByte();
			var name:String=data.readUTF();
			if(type==1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0050,name));
				ChatDataManager.instance.sendNativeNotice(3,StringUtil.substitute(StringConst.SCHOOL_PANEL_0050,name));
			}else if(type==2)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0051,name));
			}else if(type==3)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0052,name));
			}
			else if(type==4)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_00521,name));
			}
			else if(type==5)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_00522,name));
			}
		}
		
		private function dealSchoolInviteResult(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var name:String=data.readUTF();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0049,name));
		}
		
		private function dealSchoolPositionTitle(data:ByteArray):void
		{
			positionDic = positionDic||new Dictionary();
			positionArr=positionArr||[];
			var count:int=6;
//			var isNull:Boolean=count==0;
			while(count>0)
			{
				var id:int=data.readInt();
				var name:String=data.readUTF();
				positionDic[id]=name;
				count--;
			}
			
			for (var i:int=1;i<7;i++)
			{
				positionArr[i-1]=positionDic[i];
			}
		}
		
		private function dealSchoolApplyAction(data:ByteArray):void
		{
			var type:int=data.readByte();
			var name:String=data.readUTF();
			if(type==2)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0047,name));
			}else
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0048,name));
				PanelMediator.instance.closePanel(PanelConst.TYPE_SCHOOL_CREATE);
			}
		}
		
		private function dealSchoolNotMoney(data:ByteArray):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0046);
		}
		
		private function dealSchoolBasicInfo(data:ByteArray):void
		{
			schoolBaseData.schoolId= data.readInt();
			schoolBaseData.schoolSid=data.readInt();
			schoolBaseData.schoolName=data.readUTF();
			schoolBaseData.schoolPosition=data.readInt();
		}
		
		private function dealFamilyCancelJoinSuccess(data:ByteArray):void
		{
			var id:int=data.readInt();
			var sid:int = data.readInt();
			setSchoolList(id,sid,0);
		}
		
		private function dealFamilyJoinSuccess(data:ByteArray):void
		{
			var id:int=data.readInt();
			var sid:int = data.readInt();
			setSchoolList(id,sid,1);
			var school:SchoolData= getSchoolData(id,sid);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0042,school.name));
		}
		
		private function getSchoolData(id:int, sid:int):SchoolData
		{
			for(var i:int=0;i<schoolList.length;i++)
			{
				if(schoolList[i].id==id&&schoolList[i].sid==sid)
				{
					return schoolList[i];
				}
			}
			return null;
		}
		
		private function dealSchoolList(data:ByteArray):void
		{
			var count:int= data.readInt();
			schoolList.splice(0,schoolList.length);
			for(var i:int=0;i<count;i++)
			{
				var sch:SchoolData=new SchoolData();
				sch.id=data.readInt();
				sch.sid=data.readInt();
				sch.rank=data.readInt();
				sch.name=data.readUTF();
				sch.leaderCid=data.readInt();
				sch.leaderSid=data.readInt();
				sch.leaderName=data.readUTF();
				sch.level=data.readInt();
				sch.count=data.readInt();
				sch.maxCount=data.readInt();
				sch.noticeExter=data.readUTF();
				sch.type=data.readByte();
				schoolList.push(sch);
			}
			count= data.readInt();
			while(count>0)
			{
				var schoolId:int= data.readInt();
				var schoolSid:int=data.readInt();
				attackSchoolDic[schoolId+"|"+schoolSid]=data.readInt();
				count--;
			}
			schoolListPage.changeList(schoolList);
		}
		
		public function filterPage():void
		{
			var filterArr:Array= schoolList.filter(filterListByState);
			schoolListPage.changeList(filterArr);
		}
		
		private function filterListByState(schoolData:SchoolData,index:int,schoolLists:Array):Boolean
		{
			if(selectSchoolListState==0)
				return true;
			if(selectSchoolListState==1)
			{
				if(attackSchoolDic[schoolData.id+"|"+schoolData.sid]==null)return true;
				var time:int=attackSchoolDic[schoolData.id+"|"+schoolData.sid];
				if(time<ServerTime.time)return true;
			}
			if(selectSchoolListState==2)
			{
				if(attackSchoolDic[schoolData.id+"|"+schoolData.sid]!=null)
				{
					var time1:int=attackSchoolDic[schoolData.id+"|"+schoolData.sid];
					if(time1>ServerTime.time)return true;
				}
			}
			return false;
		}	
		
		private function setSchoolList(id:int,sid:int,type:int):void
		{
			for(var i:int=0;i<schoolList.length;i++)
			{
				if(schoolList[i].id==id&&schoolList[i].sid==sid)
				{
					schoolList[i].type=type;
				}
			}
			var filterArr:Array= schoolList.filter(filterListByState);
			schoolListPage.changeList(filterArr);
		}
		
		public function getSchoolCreateCfg():FamilyCfgData
		{
			return ConfigDataManager.instance.familyCfgData(1);
		}
		
		public function createSchoolRequest(name:String,sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeUTF(name);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_CREATE,byteArray);
		}	
		
		public function joinSchoolRequest(id:int,sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_APPLY,byteArray);
		}	
		
		public function cancelJoinSchoolRequest(id:int,sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_APPLY_CANCEL,byteArray);
		}	
		
		public function inviteSchoolRequest(cid:int,sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_INVITE,byteArray);
		}
		
		/**
		 * 获取门派列表
		 */
		public function getSchoolListRequest():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_LIST_QUERY,byteArray);
		}		
		
		/**
		 * 
		 * 查询  根据name  本地数据
		 */
		public function getSchoolListByName(name:String):void
		{
			var eachList:Array=[];
			for (var i:int=0;i<schoolList.length;i++)
			{
				var school:SchoolData= schoolList[i] as SchoolData;
				if(school.name.indexOf(name)!=-1)
				{
					eachList.push(school);
				}
			}
			var filterArr:Array= eachList.filter(filterListByState);
			schoolListPage.changeList(filterArr);
		}	
		 
		/**
		 * 
		 * 神奇的界面调动方法
		 */
		public function setTabIndex(param:int):void
		{
			selectTab=param;
			super.resolveData(UPDATE_TAB_INDEX, null);
		}
		
		public function sendCallMember(id:int, sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_FIGHT,byteArray);
		}
	}
}