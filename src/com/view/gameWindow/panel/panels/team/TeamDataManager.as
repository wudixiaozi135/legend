/**
 * Created by Administrator on 2014/11/5.
 */
package com.view.gameWindow.panel.panels.team
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.roleProperty.otherRole.IOtherRolePanel;
	import com.view.gameWindow.panel.panels.roleProperty.otherRole.OtherPlayerDataManager;
	import com.view.gameWindow.panel.panels.team.data.KickData;
	import com.view.gameWindow.panel.panels.team.data.TeamInfoVo;
	import com.view.gameWindow.panel.panels.team.tabHandle.myTeam.SubItemInfo;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.selectRole.SelectRoleDataManager;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import mx.utils.StringUtil;

	public class TeamDataManager extends DataManagerBase
	{
		/**队员总数*/
		public static const TOTAL_MEMBER:int = 5;

		private static var _instance:TeamDataManager = null;

		public static function get instance():TeamDataManager
		{
			if (_instance == null)
			{
				_instance = new TeamDataManager();
			}
			return _instance;
		}

		public function TeamDataManager()
		{
			_teamInfoVec = new Vector.<TeamInfoVo>();
			DistributionManager.getInstance().register(GameServiceConstants.SM_TEAM_INFO, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_OTHER_SETTING, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_KICKED_FROM_TEAM, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TEAM_DIMISSED, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TEAM_INVITE_REFUSE, this);//邀请被拒绝
			DistributionManager.getInstance().register(GameServiceConstants.SM_SET_TEAM_LEADER_REFUSE, this);//对方拒绝设置队长
			DistributionManager.getInstance().register(GameServiceConstants.SM_TEAM_APPLY_REFUSE, this);//对方拒绝你的申请


			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CREATE_TEAM, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_KICK_FROM_TEAM, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_LEAVE_TEAM, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_SET_TEAM_LEADER, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_APPLY_INTO_TEAM, this);//申请入队请求发出
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_INVITE_INTO_TEAM, this);//入组邀请请求发出
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_INVITE_AND_CREATE_TEAM, this);//邀请玩家共同创建队伍
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_TEAM_DISMISS, this);//解散队伍
		}

		public var subItems:Vector.<SubItemInfo> = new Vector.<SubItemInfo>();

		private var _headMapId:int = 0;//默认队长所在地图
		private var _headOnlyMapId:int = 0;//默认队长所在唯一地图
		public function get headMapId():int
		{
			return _headMapId;
		}

		public function get headOnlyMapId():int
		{
			return _headOnlyMapId;
		}

		private var _teamInfoVec:Vector.<TeamInfoVo>;

		//////////服务端下发数据

		public function get teamInfoVec():Vector.<TeamInfoVo>
		{
			return _teamInfoVec;
		}//1字节有符号整形，自动允许组队，1表示自动，0表示不自动

		private var _selectIndex:int = 0;//1字节有符号整形，自动允许进组，1表示自动，0表示不自动

		public function get selectIndex():int
		{
			return _selectIndex;
		}//当前选择的队员信息

		public function set selectIndex(value:int):void
		{
			_selectIndex = value;
		}

		private var _subItemSelect:int = -1;

		public function get subItemSelect():int
		{
			return _subItemSelect;
		}

		public function set subItemSelect(value:int):void
		{
			_subItemSelect = value;
		}

		private var _teamId:int;

		public function get teamId():int
		{
			return _teamId;
		}

		public function set teamId(value:int):void
		{
			_teamId = value;
		}

		private var _headerCid:int;
		private var _headerSid:int;

		public function get headerCid():int
		{
			return _headerCid;
		}

		private var _allow_team_invite:int;

		public function get allow_team_invite():int
		{
			return _allow_team_invite;
		}

		public function set allow_team_invite(value:int):void
		{
			_allow_team_invite = value;
		}

		private var _allow_team_apply:int;

		public function get allow_team_apply():int
		{
			return _allow_team_apply;
		}

		public function set allow_team_apply(value:int):void
		{
			_allow_team_apply = value;
		}

		private var _selectTeamInfo:TeamInfoVo;

		public function get selectTeamInfo():TeamInfoVo
		{
			return _selectTeamInfo;
		}

		public function set selectTeamInfo(value:TeamInfoVo):void
		{
			_selectTeamInfo = value;
		}

		private var _kickData:KickData;

		public function get kickData():KickData
		{
			return _kickData;
		}

		public function set kickData(value:KickData):void
		{
			_kickData = value;
		}

		/**检查是否是队长*/
		public function get isHeader():Boolean
		{
			return _headerCid == SelectRoleDataManager.getInstance().selectCid && _headerSid == SelectRoleDataManager.getInstance().selectSid;
		}

		public function get hasTeam():Boolean
		{
			var roleManager:SelectRoleDataManager = SelectRoleDataManager.getInstance();
			for each(var vo:TeamInfoVo in _teamInfoVec)
			{
				if (roleManager.selectCid == vo.cid && roleManager.selectSid == vo.sid)
				{
					return true;
				}
			}
			return false;
		}

		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				default :
					break;
				case GameServiceConstants.SM_TEAM_INFO:
					handleTeamInfo(data);
					break;
				case GameServiceConstants.SM_OTHER_SETTING:
					handleOtherSetting(data);
					break;
				case GameServiceConstants.SM_KICKED_FROM_TEAM:
					handleKickFromTeam(data);
					break;
				case GameServiceConstants.SM_TEAM_DIMISSED:
					handlerTeamDismiss(data);
					break;
				case GameServiceConstants.SM_TEAM_INVITE_REFUSE://邀请被拒绝
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_ERROR_00011);
					break;
				case GameServiceConstants.SM_SET_TEAM_LEADER_REFUSE://设置队长被拒绝
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_ERROR_00013);
					break;
				case GameServiceConstants.SM_TEAM_APPLY_REFUSE://申请被拒绝
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_ERROR_00014);
					break;
				case GameServiceConstants.CM_CREATE_TEAM:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_PANEL_00012);
					break;
				case GameServiceConstants.CM_KICK_FROM_TEAM:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_PANEL_00013);
					break;
				case GameServiceConstants.CM_LEAVE_TEAM:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_PANEL_00014);
					break;
				case GameServiceConstants.CM_INVITE_AND_CREATE_TEAM:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_PANEL_00028);
					break;
				case GameServiceConstants.CM_SET_TEAM_LEADER:
					break;
				case GameServiceConstants.CM_APPLY_INTO_TEAM:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_PANEL_00042);
					break;
				case GameServiceConstants.CM_INVITE_INTO_TEAM:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_PANEL_00043);
					break;
				case GameServiceConstants.CM_TEAM_DISMISS:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_ERROR_0009);
					break;
			}
			super.resolveData(proc, data);
		}

		override public function clearDataManager():void
		{
			_instance = null;
		}

		public function dealSwitchPanelDaily():void
		{
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_TEAM);
			if (!openedPanel)
			{
				querySettingInfo();
				PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM);
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM);
			}
		}

		/**邀请组队*/
		public function inviteBuildTeam(cid:int, sid:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_INVITE_AND_CREATE_TEAM, data);
		}

		/**申请加入队伍*/
		public function applyJoinTeam(cid:int, sid:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_APPLY_INTO_TEAM, data);
		}

		/**邀请他人加入自己的队伍，只有队长才可以*/
		public function inviteJoinTeam(cid:int, sid:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_INVITE_INTO_TEAM, data);
		}

		private function handlerTeamDismiss(data:ByteArray):void
		{
			var cid:int, sid:int, name:String, job:int, reincarn:int, level:int;
			//cid，队长角色id，4字节有符号整形，
			//sid，队长角色的服务器id，4字节有符号整形
			//name，队长角色名，字符串形
			//job，队长职业，1字节有符号整形
			//reincarn，队长转生次数，1字节有符号整形
			//level，队长玩家等级，2字节有符号整形
			cid = data.readInt();
			sid = data.readInt();
			name = data.readUTF();
			job = data.readByte();
			reincarn = data.readByte();
			level = data.readShort();
			Alert.message(StringUtil.substitute(StringConst.TEAM_ERROR_00020, name));

		}

		/**踢除队友*/
		private function handleKickFromTeam(data:ByteArray):void
		{
			if (data == null) return;
			_kickData = new KickData();
			_kickData.cid = data.readInt();
			_kickData.sid = data.readInt();
			_kickData.name = data.readUTF();
			_kickData.job = data.readByte();
			_kickData.reincarn = data.readByte();
			_kickData.level = data.readShort();

		}

		/**组队相关设置*/
		private function handleOtherSetting(data:ByteArray):void
		{
			if (data == null) return;
			_allow_team_invite = data.readByte();
			_allow_team_apply = data.readByte();
		}

		/**组队信息*/
		private function handleTeamInfo(data:ByteArray):void
		{
			if (data == null) return;
			_teamInfoVec.length = 0;
			_teamId = data.readInt();
			var size:int = data.readByte();
			while (size-- > 0)
			{
				var vo:TeamInfoVo = new TeamInfoVo();
				vo.leaderFlag = false;//默认队伍所有人都不是队长
				vo.cid = data.readInt();
				vo.sid = data.readInt();
				vo.name = data.readUTF();
				vo.head = data.readByte();
				vo.vip = data.readByte();
				vo.reincarn = data.readByte();
				vo.level = data.readShort();
				vo.job = data.readByte();
				vo.hp = data.readInt();
				vo.maxHp = data.readInt();
				vo.mapId = data.readInt();
				vo.mapOnlyId = data.readInt();//map only id
				vo.x = data.readShort();
				vo.y = data.readShort();
				_teamInfoVec.push(vo);
			}
			if (_teamInfoVec.length)
			{
				_headerCid = _teamInfoVec[0].cid;
				_headerSid = _teamInfoVec[0].sid;
				_headMapId = _teamInfoVec[0].mapId;
				_headOnlyMapId = _teamInfoVec[0].mapOnlyId;

				_teamInfoVec[0].leaderFlag = true;//设置队长标识
				if (_headerCid != SelectRoleDataManager.getInstance().selectCid && _headerSid != SelectRoleDataManager.getInstance().selectSid)
				{
					_teamInfoVec = getSortVec();
				}
			}
		}

		private function getSortVec():Vector.<TeamInfoVo>
		{
			var vec:Vector.<TeamInfoVo> = new Vector.<TeamInfoVo>();
			var selfCid:int = SelectRoleDataManager.getInstance().selectCid;
			var selfSid:int = SelectRoleDataManager.getInstance().selectSid;
			var headerInfo:TeamInfoVo = _teamInfoVec.shift();//队长
			var selfInfo:TeamInfoVo;
			for (var i:int = 0; i < _teamInfoVec.length; i++)
			{
				if (_teamInfoVec[i].cid == selfCid && _teamInfoVec[i].sid == selfSid)
				{
					selfInfo = _teamInfoVec.splice(i, 1)[0];//自己
					break;
				}
			}
			vec.push(selfInfo, headerInfo);
			if (_teamInfoVec.length)
			{
				vec = vec.concat(_teamInfoVec);
			}
			return vec;
		}

		/**查询组队相关设置*/
		private function querySettingInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OTHER_SETTING, data);
		}

		public function get headerSid():int
		{
			return _headerSid;
		}

		public function set headerSid(value:int):void
		{
			_headerSid = value;
		}

		/**查看其他玩家信息 打开面板*/
		public function viewOtherPlayerInfo(cid:int, sid:int):void
		{
			OtherPlayerDataManager.instance.sendData(cid, sid);
			PanelMediator.instance.openPanel(PanelConst.TYPE_OTHER_PLAYER);
			var IPanel:IOtherRolePanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_OTHER_PLAYER) as IOtherRolePanel;
			IPanel.cid = cid;
			IPanel.sid = sid;
		}

		/** 获取数据*/
		public function sendOtherPlayerInfo(cid:int, sid:int):void
		{
			OtherPlayerDataManager.instance.sendData(cid, sid);
		}

		/**根据玩家的sid和cid判断是否在同一个队伍*/
		public function checkInSameTeam(cid:int, sid:int):Boolean
		{
			var manager:SelectRoleDataManager = SelectRoleDataManager.getInstance();
			if (!_teamInfoVec || (_teamInfoVec.length == 0)) return false;
			for each(var vo:TeamInfoVo in _teamInfoVec)
			{
				if (vo.cid == manager.selectCid && vo.sid == manager.selectSid) continue;
				if (vo.sid == sid && vo.cid == cid) return true;
			}
			return false;
		}
	}
}
