package com.view.gameWindow.panel.panels.friend
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.common.Alert;
    import com.view.selectRole.SelectRoleDataManager;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.utils.StringUtil;

    /**
	 * 好友 敌人 黑名单
	 * @author wqhk
	 * 2014-11-5
	 */
	public class ContactDataManager extends DataManagerBase
	{
		public static const UPDATE_LIST_LATEST:int = -4;
		public static const UPDATE_LIST_FRIEND:int = -1;
		public static const UPDATE_LIST_ENEMY:int = -2;
		public static const UPDATE_LIST_BLACK:int = -3;
		
		public static const UPDATE_MOOD:int = -5;
		
		private var latestList:Array;
		private var friendList:Array;
		private var enemyList:Array;
		private var backList:Array;
		
		private var _searchOutList:Array;
		
		private var latestNum:int;
		private var friendNum:int;
		private var enemyNum:int;
		private var backNum:int;
		
		protected var sId:int;//for search
		protected var rId:int;//for search
		
		public var mood:String;
		public var defaultMood:String = StringConst.FRIEND_PANEL_MOOD;
		private var _isShowOffline:Boolean = true;
		
		private static var _instance:ContactDataManager;
		
		public static function get instance():ContactDataManager
		{
			if(!_instance)
			{
				_instance = new ContactDataManager();
			}
			
			return _instance;
		}
		
		public function ContactDataManager()
		{
			latestList = [];
			friendList = [];
			enemyList = [];
			backList = [];
			
			super();
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_RELATION_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SEARCH_RESULT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ADD_FRIEND_PUSH_MESSAGE,this);
			
//			ErrorMessageManager.getInstance().register(GameServiceConstants.CM_ADD_RELATION,this);
			
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_PLAYER_RELATION_MAX_NUM,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_PLAYER_RELATION_EXIST,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_PLAYER_OFF_LINE,this);
			
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_DEL_RELATION,this);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_RELATION_LIST:
					resolveContactList(data);
					break;
				case GameServiceConstants.SM_SEARCH_RESULT:
					resolveSearchList(data);
					notify(proc);
					break;
				case GameServiceConstants.SM_ADD_FRIEND_PUSH_MESSAGE:
					resolveMessage(data);
					notify(proc);
					break;
				case GameServiceConstants.ERR_PLAYER_RELATION_MAX_NUM:
					Alert.message(StringConst.TIP_LIST_FULL);
					break;
				case GameServiceConstants.ERR_PLAYER_RELATION_EXIST:
					Alert.message(StringConst.TIP_OTHER_CONTACT_EXIST);
					break;
				case GameServiceConstants.ERR_PLAYER_OFF_LINE:
					Alert.message(StringConst.TIP_PLAYER_OFF_LINE);
					break;
//				case GameServiceConstants.CM_ADD_RELATION:
//					resolveAddContact(data);
//					break;
				case GameServiceConstants.CM_DEL_RELATION:
					Alert.message(StringConst.TIP_DELETE_SUCCESS);
					break;
			}
			
//			super.resolveData(proc,data);
		}
		
		/**
		 * 匹配玩家名字
		 */
		public function findNameAt(type:int,txt:String):Array
		{
			var list:Array = getList(type);
			
			var re:Array = [];
			
			if(StringUtil.trim(txt) == "")
			{
				return re;
			}
			
			for each(var item:ContactEntry in list)
			{
				var index:int = item.name.indexOf(txt);
				if(index != -1)
				{
					re.push(item);
				}
			}
			
			return re;
		}
		
		public function requestUpdateMood(mood:String):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeUTF(mood);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_UPD_PERSONALMOOD,data);
			
			updateMood(mood);
		}
		
		public function updateMood(value:String):void
		{
			mood = value;
			notify(UPDATE_MOOD);
		}
		
		public function getTotalNum(type:int):int
		{
			var num:int = 0;
			switch(type)
			{
				case ContactType.LATEST:
					num = 20;
					break;
				case ContactType.FRIEND:
					num = 100;
					break;
				case ContactType.ENEMY:
					num = 20;
					break;
				case ContactType.BLACK:
					num = 100;
					break;
			}
			
			return num;
		}
		
//		private function resolveAddContact(data:ByteArray):void
//		{
////			var ret:int = data.readUnsignedByte();
////			
////			if(ret == 0)
////			{
//				var err:int = data.readInt();
//				
//				if(err == GameServiceConstants.ERR_PLAYER_RELATION_MAX_NUM)
//				{
//					Alert.message(StringConst.TIP_LIST_FULL);
//				}
//				else if(err == GameServiceConstants.ERR_PLAYER_RELATION_EXIST)
//				{
//					Alert.message(StringConst.TIP_OTHER_CONTACT_EXIST);
//				}
//				else if(err == GameServiceConstants.ERR_PLAYER_OFF_LINE)
//				{
//					Alert.message(StringConst.TIP_PLAYER_OFF_LINE);
//				}
////			}
//		}
		
		public function updateMessageState():void
		{
			notify(GameServiceConstants.SM_ADD_FRIEND_PUSH_MESSAGE);
		}
		
		public function popMessage():ContactEntry
		{
			return messageList.pop();
		}
		
		private var messageList:Array = [];
		
		private function resolveMessage(data:ByteArray):void
		{
			var addType:int = data.readInt();
			var type:int = data.readByte();
			var name:String = data.readUTF();
			
			var entry:ContactEntry = new ContactEntry();
			entry.roleId = data.readInt();
			entry.serverId = data.readInt();
			entry.job = data.readInt();
			entry.reincarn = data.readInt();
			entry.lv = data.readInt();
			entry.name = name;
			entry.messageType = type;
			
			var isPush:int = data.readByte();
			
			// 好友  && 被申请人
			if(addType == 1 &&type == 2 && !isInContact(entry.serverId,entry.roleId,ContactType.MESSAGE))
			{
				trace(name);
				messageList.push(entry);
			}
			
			if(type == 1)//申请者
			{
				if(addType == 1)
				{
					Alert.message(StringUtil.substitute(StringConst.TIP_ADD_FRIEND_SUCESS,name));
				}
				else if(addType == 2)
				{
					Alert.message(StringUtil.substitute(StringConst.TIP_ADD_ENEMY_SUCESS,name));
				}
				else if(addType == 3)
				{
					Alert.message(StringUtil.substitute(StringConst.TIP_ADD_BLACK_SUCESS,name));
				}
			}
			else if(type == 2) //被申请人
			{
				if(addType == 1)
				{
					Alert.message(StringUtil.substitute(StringConst.TIP_OTHER_ADD_FRIEND_SUCESS,name));
				}
			}
			else if(type == 3)//好友变仇人 
			{
				if(addType == 2)
				{
					Alert.message(StringUtil.substitute(StringConst.TIP_ADD_ENEMY_SUCESS,name));
				}
			}
			
		}
		
		public function updateList(type:int):void
		{
			var proc:int = 0;
			switch(type)
			{
				case ContactType.LATEST:
					proc = UPDATE_LIST_LATEST;
					break;
				case ContactType.FRIEND:
					proc = UPDATE_LIST_FRIEND;
					break;
				case ContactType.ENEMY:
					proc = UPDATE_LIST_ENEMY;
					break;
				case ContactType.BLACK:
					proc = UPDATE_LIST_BLACK;
					break;
			}
			
			if(proc != 0)
			{
				notify(proc);
			}
		}
		
		public function resolveContactList(data:ByteArray):void
		{
			var mood:String = data.readUTF();
            if (!mood || StringUtil.trim(mood) == "")
			{
				mood = defaultMood;
			}
			updateMood(mood);
			
			var type:int = data.readInt();
			clearList(type);
			var list:Array = getList(type);
			var size:int = data.readInt();
			for(var i:int = 0; i < size; ++i)
			{
				var entry:ContactEntry = new ContactEntry();
				
				entry.roleId = data.readInt();
				entry.serverId = data.readInt();
				entry.name = data.readUTF();
				entry.job = data.readInt();
				entry.vip = data.readByte();
				entry.reincarn = data.readInt();
				entry.lv = data.readInt();
				entry.mood = data.readUTF();
				entry.online = data.readByte();
				entry.type = type;
				
				list.push(entry);
			}
			
			
			list.sortOn("online",Array.NUMERIC|Array.DESCENDING);
			
			var rank:int = data.readInt();
			
			updateList(type);
		}
		
		public function resolveSearchList(data:ByteArray):void
		{
			var size:int = data.readInt();
			
			_searchOutList = [];
			for(var i:int = 0; i < size; ++i)
			{
				var item:ContactEntry = new ContactEntry();
				item.roleId = data.readInt();
				item.serverId = data.readInt();
				item.name = data.readUTF();
				item.job = data.readInt();
				item.reincarn = data.readInt();
				item.lv = data.readInt();
				_searchOutList.push(item);
			}
		}
		
		
		/**
		 * @param state 1:只显示在线 2:都显示
		 * @see com.view.gameWindow.panel.panels.friend.ContactType
		 */
		public function requestContactList(type:int,state:int = 2):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			
			data.writeInt(type);
			data.writeInt(state);// 1 只显示在线 2 都显示
			
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_RELATION_INFO,data);
		}
		
		public function requestContactListAll():void
		{
			requestContactList(ContactType.LATEST);
			requestContactList(ContactType.FRIEND);
			requestContactList(ContactType.ENEMY);
			requestContactList(ContactType.BLACK);
		}
		
		/**
		 * 
		 * @param type ContactType
		 * @see com.view.gameWindow.panel.panels.friend.ContactType
		 */
		public function requestAddContact(sid:int,cid:int,type:int):int
		{
			if(isInContact(sid,cid,type))
			{
				return 1;
			}
			
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			data.writeInt(type);
			
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ADD_RELATION,data);
			return 0;
		}
		
		public function requestRemoveContact(sid:int,cid:int,type:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			data.writeInt(type);
			
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEL_RELATION,data);
		}
		
		public function requestSearch(name:String):void
		{
			if(name)
			{
				var data:ByteArray = new ByteArray();
				data.endian = Endian.LITTLE_ENDIAN;
				data.writeUTF(name);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SEARCH_BY_NAME,data);
			}
		}
		
		public function requestClearSearchResult():void
		{
			_searchOutList = [];
			notify(GameServiceConstants.SM_SEARCH_RESULT);
		}
		
		public function isInContact(sId:int,rId:int,type:int):Boolean
		{
			this.sId = sId;
			this.rId = rId;
			var list:Array = getList(type);
			return list.some(isSamePerson);
		}
		
		public function checkSelf(sId:int,rId:int):int
		{
			var role:SelectRoleDataManager = SelectRoleDataManager.getInstance();
			
			if(role.selectSid == sId && role.selectCid == rId)
			{
				Alert.warning(StringConst.TIP_SELF_FORBIDDEN);
				return 1;
			}
			
			return 0;
		}
		
		public function checkInList(sId:int,rId:int):int
		{
			var dataMgr:ContactDataManager = this;
			
			if(dataMgr.isInContact(sId,rId,ContactType.FRIEND))
			{
				Alert.warning(StringConst.TIP_FRIEND_EXIST);
			}
			else if(dataMgr.isInContact(sId,rId,ContactType.ENEMY))
			{
				Alert.warning(StringConst.TIP_ENEMY_EXIST);
			}
			else if(dataMgr.isInContact(sId,rId,ContactType.BLACK))
			{
				Alert.warning(StringConst.TIP_BLACK_EXIST);
			}
			else
			{
				return 0;
			}
			
			return 1;
		}
		
		protected function isSamePerson(item:ContactEntry,index:int, array:Array):Boolean
		{
			return item.serverId == sId && item.roleId == rId;
		}
		
		public function getRank(type:int,lv:int):int
		{
			var list:Array = getList(type);
			
			var index:int = 1;
			
			for each(var entry:ContactEntry in list)
			{
				if(entry.lv>lv)
				{
					++index;
				}
			}
			
			return index;
		}
		
		/**
		 * online num
		 */
		public function getNum(type:int):int
		{
			var num:int = 0;
			switch(type)
			{
				case ContactType.LATEST:
					num = latestNum;
					break;
				case ContactType.FRIEND:
					num = friendNum;
					break;
				case ContactType.ENEMY:
					num = enemyNum;
					break;
				case ContactType.BLACK:
					num = backNum;
					break;
			}
			return num;
		}
		
//		public function getTotal(type:int):int
//		{
//			var num:int = 0;
//			var list:Array = getList(type);
//			
//			return list.length;
//		}
		
		public function getList(type:int):Array
		{
			var re:Array;
			switch(type)
			{
				case ContactType.LATEST:
					re = latestList;
					break;
				case ContactType.FRIEND:
					re = friendList;
					break;
				case ContactType.ENEMY:
					re = enemyList;
					break;
				case ContactType.BLACK:
					re = backList;
					break;
				case ContactType.MESSAGE:
					re = messageList;
					break;
				case ContactType.SCHOOL:
					re=_searchOutList;
				default:
					re = [];
					break;
			}
			
			return re;
		}
		
		public function clearList(type:int):void
		{
			switch(type)
			{
				case ContactType.LATEST:
					latestList = [];
					break;
				case ContactType.FRIEND:
					friendList = [];
					break;
				case ContactType.ENEMY:
					enemyList = [];
					break;
				case ContactType.BLACK:
					backList = [];
					break;
				default:
					break;
			}
		}

		public function get searchOutList():Array
		{
			return _searchOutList;
		}

		public function get isShowOffline():Boolean
		{
			return _isShowOffline;
		}

		public function set isShowOffline(value:Boolean):void
		{
			_isShowOffline = value;
		}

		
	}
}