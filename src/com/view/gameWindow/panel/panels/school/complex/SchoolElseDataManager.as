package com.view.gameWindow.panel.panels.school.complex
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.FamilyPositionCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.gameWindow.mem.AttrRandomData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.school.complex.information.SchoolInfoData;
	import com.view.gameWindow.panel.panels.school.complex.information.donate.DonateData;
	import com.view.gameWindow.panel.panels.school.complex.information.eventList.item.SchoolEventData;
	import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberData;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.PageListData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;
	import com.view.selectRole.SelectRoleDataManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;

	public class SchoolElseDataManager extends DataManagerBase
	{
		private static var _instance:SchoolElseDataManager;
		
		public var schoolInfoData:SchoolInfoData;
		public var schoolEventList:Array;
		public var schoolEventListPage:PageListData;
		public var schoolApplyList:Array;
		public var schoolApplyListPage:PageListData;
		
		public var schoolHostilityList:Vector.<SchoolInfoData>;
		public static const PAGE_DATA_COUNT:int=10;
		public var selectMemberPosition:int=0;
		public var selectApplyType:int=0;
		public var schoolName:String;
		public var selectTab:int;
		public var donateData:DonateData;
		public var schoolMembers:Vector.<SchoolMemberData>;
		public var beAttackTrailerData:SchoolMemberData;
		public var schoolBagListPage:PageListData;
		public var schoolBagList:Array;
		private var dic:Dictionary;
		public var bagDatas:Vector.<BagData>;
		public function SchoolElseDataManager()
		{
			if(_instance==null)
			{
				_instance=this;
			}
			schoolEventList=[];
			schoolEventListPage=new PageListData(PAGE_DATA_COUNT);
			schoolApplyList=[];
			schoolApplyListPage=new PageListData(PAGE_DATA_COUNT);
			schoolHostilityList=new Vector.<SchoolInfoData>();
			schoolBagListPage=new PageListData(36);
			schoolBagList=new Array(180);
			schoolBagListPage.changeList(schoolBagList);
			dic=new Dictionary();
			bagDatas=new Vector.<BagData>();
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_INFO_QUERY,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FAMILY_UPDATE_NOTICE,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FAMILY_EDIT,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FAMILY_CALL,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_RANK_GOLD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_ADD_MAX_COUNT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_LEAVE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_DISSOLVE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_CONTRIBUTE_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_EVENT_QUERY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_OFF_MEMBER,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_MEMBER_LIST_QUERY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_APPLY_LIST_QUERY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_APPOINTMENT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_CALL_ACTION,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_MEMBER_TRAILER_ASK_HELP,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FIGHT_FAMILY_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_STORAGE_INFO,this);
		}	
		
		public static function getInstance():SchoolElseDataManager
		{
			return _instance||new SchoolElseDataManager();
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_FAMILY_INFO_QUERY:
					dealSchoolInfo(data);
					break;
				case GameServiceConstants.CM_FAMILY_UPDATE_NOTICE:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0121);
					break;
				case GameServiceConstants.SM_FAMILY_RANK_GOLD:
					dealFamilyNewRank(data);
					break;
				case GameServiceConstants.SM_FAMILY_ADD_MAX_COUNT:
					dealFamilyAddMember(data);
					break;
				case GameServiceConstants.SM_FAMILY_LEAVE:
					dealExitSchool(data);
					break;
				case GameServiceConstants.SM_FAMILY_DISSOLVE:
					dealDissolveSchool(data);
					break;
				case GameServiceConstants.SM_FAMILY_CONTRIBUTE_INFO:
					dealFamilyContribute(data);
					break;
				case GameServiceConstants.SM_FAMILY_EVENT_QUERY:
					dealFamilyEvent(data);
					break;
				case GameServiceConstants.SM_FAMILY_OFF_MEMBER:
					dealSchoolMemberOut(data);
					break;
				case GameServiceConstants.SM_FAMILY_MEMBER_LIST_QUERY:
					dealSchoolMemberList(data);
					break;
				case GameServiceConstants.SM_FAMILY_APPLY_LIST_QUERY:
					dealSchoolApplyList(data);
					break;
				case GameServiceConstants.SM_FAMILY_APPOINTMENT:
					dealSchoolAppointment(data);
					break;
//				case GameServiceConstants.SM_FAMILY_CALL:
//					break;
				case GameServiceConstants.SM_FAMILY_CALL_ACTION:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_2021);
					break;
				case GameServiceConstants.CM_FAMILY_EDIT:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_2017);
					break;
				case GameServiceConstants.CM_FAMILY_CALL:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_5009);
					break;
//				case GameServiceConstants.SM_FAMILY_MEMBER_TRAILER_ASK_HELP:
//					dealTrailerAskDAta(data);
					break;
				case GameServiceConstants.SM_FIGHT_FAMILY_LIST:
					dealFightFamilyList(data);
					break;
				case GameServiceConstants.SM_FAMILY_STORAGE_INFO:
					dealFamilyStorageInfo(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealFamilyStorageInfo(data:ByteArray):void
		{
			clearBagDatas();

			var job:int = RoleDataManager.instance.job;
			var size:int = data.readInt();
			while(size-- > 0)
			{
				var onlyId:int = data.readInt();
				var bornSid:int = data.readInt();
				var slot:int = data.readInt();
				if (!dic[bornSid])
				{
					dic[bornSid] = new Dictionary();
				}
				var memEquipData:MemEquipData = dic[bornSid][onlyId];
				if(!memEquipData)
				{
					memEquipData = new MemEquipData();
					memEquipData.onlyId = onlyId;
					memEquipData.bornSid = bornSid;
					dic[memEquipData.bornSid][memEquipData.onlyId] = memEquipData;
				}
				memEquipData.baseId = data.readInt();
				memEquipData.duralibility = data.readInt();
				memEquipData.strengthen = data.readByte();
				memEquipData.polish = data.readByte();
				memEquipData.polishExp = data.readShort();
				memEquipData.bind = data.readByte();
				memEquipData.goodLuck = data.readInt();
				
				var bagData:BagData = new BagData();
				bagData.slot = slot;
				bagData.id = onlyId;
				bagData.bornSid = bornSid;
				bagData.type = SlotType.IT_EQUIP;
				bagData.count =1;
				bagData.bind = 0;
				bagData.isHide = 0;
				bagData.storageType = ConstStorage.ST_SCHOOL_BAG;
				schoolBagList[bagData.slot] = bagData;
				
				var attrRds:Vector.<AttrRandomData> = new Vector.<AttrRandomData>();
				var attrRdCount:int = data.readInt();
				memEquipData.attrRdCount = attrRdCount;
				memEquipData.attrRdStars = 0;
				var attrRdMaxStar:int;
				var attrRdMinStar:int=999;
				while(attrRdCount--)
				{
					var index:int = data.readByte();//洗炼属性的属性下标，为1字节有符号整形
					var star:int = data.readByte();//洗炼星级，为1字节有符号整形
					var type:int = data.readByte();//属性加成为1.值加成 2.百分比，为1字节有符号整形
					var addon_rate:int = data.readInt();//属性加成数，为4字节有符号整形
					if(index)
					{
						var attrRdDt:AttrRandomData = new AttrRandomData();
						attrRds.push(attrRdDt);
						attrRdDt.star = star;
						var attrDt:PropertyData = CfgDataParse.getPropertyDatas(index+":"+type+":"+addon_rate,false,null,job)[0];
						attrRdDt.attrDt = attrDt;
						memEquipData.attrRdStars += star;
						attrRdMaxStar < star ? attrRdMaxStar = star : null;
						if(star<attrRdMinStar)
						{
							attrRdMinStar=star;
						}
					}
					else
					{
						attrRdMinStar=0;
						attrRds.push(null);
					}
				}
				if(attrRdMinStar==999)attrRdMinStar=0;
				memEquipData.attrRdMaxStar = attrRdMaxStar;
				memEquipData.attrRdMinStar=attrRdMinStar;
				memEquipData.setAttrRds(attrRds);
			}
		}
		
		private function clearBagDatas():void
		{
			for(var index:int=0;index<schoolBagList.length;index++)
			{
				schoolBagList[index]=null;
			}
		}
		
		private function dealFightFamilyList(data:ByteArray):void
		{
			schoolHostilityList.length=0;
			var size:int = data.readInt();
			while(size>0)
			{
				var sc:SchoolInfoData = new SchoolInfoData;
				sc.id=data.readInt();
				sc.sid=data.readInt();
				schoolHostilityList.push(sc);
				size--;
			}
		}
		
		private function dealTrailerAskDAta(data:ByteArray):void
		{
			beAttackTrailerData=beAttackTrailerData||new SchoolMemberData();
			beAttackTrailerData.cid=data.readInt();
			beAttackTrailerData.sid=data.readInt();
			beAttackTrailerData.name=data.readUTF();
		}
		
		private function dealSchoolAppointment(data:ByteArray):void
		{
			var type:int=data.readByte();
			var name:String=data.readUTF();
			var position:int=data.readInt();
			if(type==1)
			{
				if(position==1)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_2024,name));
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_2025,SchoolDataManager.getInstance().positionDic[6]));
					return;
				}
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_2018,name,SchoolDataManager.getInstance().positionDic[position]));
			}else
			{
				if(position==1)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_2023,name));
					return;
				}
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_2019,SchoolDataManager.getInstance().positionDic[position]));
			}
		}
		
		private function dealSchoolApplyList(data:ByteArray):void
		{
			schoolApplyList.splice(0,schoolApplyList.length);
			selectApplyType=data.readByte();
			var count:int=data.readInt();
			while(count>0)
			{
				var schoolMemberData:SchoolMemberData = new SchoolMemberData();
				schoolMemberData.name=data.readUTF();
				schoolMemberData.cid=data.readInt();
				schoolMemberData.sid=data.readInt();
				schoolMemberData.sex=data.readByte();
				schoolMemberData.reincarn=data.readInt();
				schoolMemberData.level=data.readInt();
				schoolMemberData.job=data.readByte();
				schoolApplyList.push(schoolMemberData);
				count--;
			}
			schoolApplyListPage.changeList(schoolApplyList);
		}
		
		private function dealSchoolMemberList(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			schoolMembers = schoolMembers||new Vector.<SchoolMemberData>();
			schoolMembers.splice(0,schoolMembers.length);
			var count:int=data.readInt();
			while(count>0)
			{
				var schoolMemberData:SchoolMemberData = new SchoolMemberData();
				schoolMemberData.cid=data.readInt();
				schoolMemberData.sid=data.readInt();
				schoolMemberData.position=data.readInt();
				schoolMemberData.name=data.readUTF();
				schoolMemberData.reincarn=data.readInt();
				schoolMemberData.level=data.readInt();
				schoolMemberData.job=data.readByte();
				schoolMemberData.sex=data.readByte();
				schoolMemberData.fightPow=data.readInt();
				schoolMemberData.contribute=data.readInt();
				schoolMemberData.contribute_sum=data.readInt();
				schoolMemberData.state=data.readByte();
				if(schoolMemberData.state==0)
				{
					schoolMemberData.time=data.readInt();
				}
				schoolMembers.push(schoolMemberData);
				count--;
			}
			schoolMembers.sort(sortMemberFunc);
		}
		
		private function sortMemberFunc(s1:SchoolMemberData,s2:SchoolMemberData):int
		{
			if(s1.position>s2.position)
			{
				if(s1.state==1)
				{
					return -1;
				}
				return 1;
			}
			return -1;
		}
		
		private function dealSchoolMemberOut(data:ByteArray):void
		{
			var name:String= data.readUTF();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0135,name));
			PanelMediator.instance.closePanel(PanelConst.TYPE_SCHOOL);
		}
		
		private function dealFamilyEvent(data:ByteArray):void
		{
			var count:int= data.readInt();
			schoolEventList.splice(0,schoolEventList.length);
			for(var i:int=0;i<count;i++)
			{
				var sch:SchoolEventData=new SchoolEventData();
				sch.time=data.readInt();
				sch.eventTpye=data.readInt();
				sch.name=data.readUTF();
				sch.content=data.readUTF();
				schoolEventList.push(sch);
			}
			schoolEventListPage.changeList(schoolEventList);
		}
		
		private function dealFamilyContribute(data:ByteArray):void
		{
			donateData =donateData|| new DonateData();
			donateData.contribute=data.readInt();
			donateData.money=data.readInt();
			donateData.surplus=data.readInt();
		}
		
		private function dealDissolveSchool(data:ByteArray):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0134);
			PanelMediator.instance.closePanel(PanelConst.TYPE_SCHOOL);
		}
		
		private function dealExitSchool(data:ByteArray):void
		{
			 var readUTF:String = data.readUTF();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0132,readUTF));
			PanelMediator.instance.closePanel(PanelConst.TYPE_SCHOOL);
		}
		
		private function dealFamilyAddMember(data:ByteArray):void
		{
			schoolInfoData.maxCount= data.readInt();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0128,schoolInfoData.maxCount));
		}
		
		private function dealFamilyNewRank(data:ByteArray):void
		{
			schoolInfoData.rank=data.readInt();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.SCHOOL_PANEL_0126,schoolInfoData.rank));
		}
		
		private function dealSchoolInfo(data:ByteArray):void
		{
			schoolInfoData=schoolInfoData||new SchoolInfoData();
			schoolInfoData.id=data.readInt();
			schoolInfoData.sid=data.readInt();
			schoolInfoData.rank=data.readInt();
			schoolInfoData.name=data.readUTF();
			schoolInfoData.leaderName=data.readUTF();
			schoolInfoData.count=data.readInt();
			schoolInfoData.maxCount=data.readInt();
			schoolInfoData.money=data.readInt();
			schoolInfoData.notice=data.readUTF();
			schoolInfoData.noticeExter=data.readUTF();
			schoolInfoData.position=data.readInt();
			schoolInfoData.contribute=data.readInt();
		}		
		
		public function getSchoolInfoRequest():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_INFO_QUERY,byteArray);
		}
		
		public function updateNoticeRequest(type:int,value:String):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			byteArray.writeUTF(value);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_UPDATE_NOTICE,byteArray);
		}	
		
		public function schoolAddMember():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_ADD_MAX_COUNT,byteArray);
		}
		
		public function sendAuctionReq():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_RANK_GOLD,byteArray);
		}
		
		public function getSchoolJurisdictionCMD(cmd:int):Boolean
		{
			var schoolInfoData:SchoolInfoData = SchoolElseDataManager.getInstance().schoolInfoData;
			if(schoolInfoData==null)return false;
			var familyPositionCfgData:FamilyPositionCfgData=ConfigDataManager.instance.familyPositionCfgData(schoolInfoData.position);
			return (familyPositionCfgData.jurisdiction&cmd)==cmd;
		}
		
		public function exitSchoolRequest():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_LEAVE,byteArray);
		}
		
		public function dissolveSchoolRequest():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_DISSOLVE,byteArray);
		}
		
		public function sendInviteAction(cid:int,sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_INVITE,byteArray);
		}
		
		public function donateDataReq():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_CONTRIBUTE_INFO,byteArray);
		}
		
		public function sendDonateRequest(value:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(value);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_CONTRIBUTE,byteArray);
		}
		
		public function getSchoolEventListRequest():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_EVENT_QUERY,byteArray);
		}
		
		public function getSchoolMemberList():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_MEMBER_LIST_QUERY,byteArray);
		}
		
		public function getSchoolApplyListRequest():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_APPLY_LIST_QUERY,byteArray);
		}
		
		public function setAutoAuditRequest(type:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_SETTING_REVIEW,byteArray);
		}
		
		public function sendAuditResult(type:int, cid:int, sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_APPLY_ACTION,byteArray);
		}
		
		public function expelMemberReq(cid:int, sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_OFF_MEMBER,byteArray);
		}
		
		public function sendCallMember(cid:int, sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_CALL,byteArray);
		}
		
		public function sendAppointMentReq(cid:int, sid:int, position:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			byteArray.writeInt(position);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_APPOINTMENT,byteArray);
		}
		
		public function setNickName(type:int, para1:String="",para2:String="",para3:String="",para4:String=""):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			if(type==1)
			{
				byteArray.writeUTF(StringUtil.trim(para1));
				byteArray.writeUTF(StringUtil.trim(para2));
				byteArray.writeUTF(StringUtil.trim(para3));
				byteArray.writeUTF(StringUtil.trim(para4));
			}
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_EDIT,byteArray);
		}
		
		public function sendCallAction(type:int, cid:int, sid:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_CALL_ACTION,byteArray);
		}
		
		public function sendRequestAction(type:int, cid:int, sid:int, leaderCid:int, leaderSid:int):void
		{
			// TODO Auto Generated method stub
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			byteArray.writeInt(leaderCid);
			byteArray.writeInt(leaderSid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_INVITE_ACTION,byteArray);
		}

		/**根据玩家cid和sid判断是否在同一个帮派*/
		public function checkInSameSchool(cid:int, sid:int):Boolean
		{
			var manager:SelectRoleDataManager = SelectRoleDataManager.getInstance();
			if (!schoolMembers || schoolMembers.length < 1) return false;
			for each(var member:SchoolMemberData in schoolMembers)
			{
				if (member.sid == manager.selectSid && member.cid == manager.selectCid) continue;
				if (member.sid == sid && member.cid == cid) return true;
			}
			return false;
		}
		
		public function checkHostilitySchool(_familyId:int, _familySid:int):Boolean
		{
			for each(var sc:SchoolInfoData in schoolHostilityList)
			{
				if(sc.id==_familyId&&sc.sid==_familySid)
				{
					return true;
				}
			}
			return false;
		}
		
		public function getSchoolBagsRequest():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_STORAGE_INFO,byteArray);
		}
		
		public function sendEquipDonateRequest(storage:int,slot:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeByte(storage);
			byteArray.writeByte(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_DONATE_EQUIP,byteArray);
		}
		
		public function sendEquipExchangeRequest(id:int,bornSid:int,slot:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeInt(bornSid);
			byteArray.writeInt(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EXCHANGE_FAMILY_STORAGE_EQUIP,byteArray);
		}
		
		public function sendEquipDistroyRequest(id:int, bornSid:int, slot:int):void
		{
			// TODO Auto Generated method stub
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeInt(bornSid);
			byteArray.writeInt(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DESTROY_FAMILY_STORAGE_EQUIP,byteArray);
		}
		
		public function getMemEquipData(bornSid:int,id:int):MemEquipData
		{
			if (!dic[bornSid])
			{
				return null;
			}
			return dic[bornSid][id];
		}
	}
}