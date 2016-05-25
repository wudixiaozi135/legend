package com.view.gameWindow.panel.panels.trailer
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatEvent;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guardSystem.BenefitType;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;
	
	public class TrailerDataManager extends DataManagerBase
	{
		
		private static var _instance:TrailerDataManager;
		public var trailerData:TrailerData;
		public var refreshTrailerId:int=0;
		private var taskTrailer:TaskCfgData;
		
		public function TrailerDataManager()
		{
			super();
			trailerData = new TrailerData();
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_TRAILER_INFO, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TRAILER_KILLED_INFO, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_KILL_TRAILER_INFO, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_MEMBER_TRAILER_ASK_HELP, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_TRAILER_REWARD, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_REFERSH_TASK_TRAILER,this);
		}
		
		public static function getInstance():TrailerDataManager
		{
			if(_instance==null)
			{
				_instance=new TrailerDataManager();
			}
			return _instance;
		}
		
		public function queryTrailerInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_TASK_TRAILER, data);
		}
		
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_TASK_TRAILER_INFO:
					dealTrailerInfo(data);
					break;
				case GameServiceConstants.SM_TRAILER_KILLED_INFO:
					dealTrailerkilledInfo(data);
					break;
				case GameServiceConstants.SM_KILL_TRAILER_INFO:
					dealKillTrailerInfo(data);
					break;
				case GameServiceConstants.SM_TASK_TRAILER_REWARD:
					dealTaskTrailerReward(data);
					break;
				case GameServiceConstants.SM_FAMILY_MEMBER_TRAILER_ASK_HELP:
					dealAskHelp(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealTaskTrailerReward(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			/*var exp:int = data.readInt();
			var coin:int = data.readInt()
			if(coin>0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.REWARD,StringUtil.substitute(StringConst.TRAILER_STRING_40,coin));
			}
			if(exp>0)
			{
				setTimeout(function ():void{RollTipMediator.instance.showRollTip(RollTipType.REWARD,StringUtil.substitute(StringConst.TRAILER_STRING_42,exp))},500);
			}*/
		}
		
		private function dealAskHelp(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			
			var linkName:String = ChatDataManager.instance.createRoleLink(cid,sid,name,0x00b0f0);
			var linkTrans:String = ChatDataManager.instance.createLinkText(StringConst.TIP_TRANS,
				ChatEvent.TRAILER_MEMBER_HELP,
				ChatEvent.createTrailerMemberHelpEventData(cid,sid),
				0x00ff00);
			var tip:String = StringUtil.substitute(StringConst.TRAILER_HINT_STRING_014,linkName,linkTrans);
			tip = ChatDataManager.instance.createLinkParagraph(0xffc000,tip);
			ChatDataManager.instance.sendNativeNotice(MessageCfg.CHANNEL_FAMILY,tip);
		}
		
		private function dealKillTrailerInfo(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var coin:int = data.readInt();
			var benefitType:int = data.readByte();
			var gongxun:int = data.readInt();
			var killTrailerCount:int = data.readShort();
			if(3-killTrailerCount>0)
			{
				Alert.message(StringUtil.substitute(StringConst.TRAILER_STRING_43,3-killTrailerCount));
			}else
			{
				Alert.message(StringConst.TRAILER_STRING_44);
			}
			coin*=BenefitType.proportion(benefitType);
			gongxun*=BenefitType.proportion(benefitType);
			if(coin>0)
			{
				Alert.message(StringUtil.substitute(StringConst.TRAILER_STRING_40,coin));
			}
			if(gongxun>0)
			{
				Alert.message(StringUtil.substitute(StringConst.TRAILER_STRING_41,gongxun));
			}
		}
		
		private function dealTrailerkilledInfo(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			Alert.show2(StringUtil.substitute(StringConst.SYSTEM_ALERT_12,name));
		}
		
		private function dealTrailerInfo(data:ByteArray):void
		{
			trailerData.tid = data.readInt();
			trailerData.level = data.readShort();
			trailerData.state=data.readByte();
			trailerData.quality=data.readByte();
			trailerData.count=data.readByte();
			trailerData.refreshCount=data.readInt();
			trailerData.mapId = data.readInt();
			trailerData.tileX = data.readShort();
			trailerData.tileY = data.readShort();
			trailerData.expire = data.readInt();
			trailerData.hp=data.readInt();
			trailerData.insure=data.readByte();
			
			if(trailerData.state==TaskStates.TS_DOING)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_TRAILER_HINT);
			}
		}
		
		public function refreshTrailer():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_REFERSH_TASK_TRAILER, data);
		}
		
		public function getTasktrailerCfg():TaskCfgData
		{
			if(taskTrailer==null)
			{
				var taskArr:Array = ConfigDataManager.instance.taskCfgDataByType(6);
				if(taskArr.length>0)
				{
					taskTrailer=taskArr[0] as TaskCfgData;
				}
			}
			return taskTrailer;
		}
		
		public function requestTrailer(tid:int,param:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(tid);
			data.writeInt(param);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RECEIVE_TASK, data);
		}
		
		public function requestTrailerHelp(cid:int,sid:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_TRAILER_HELP, data);
		}
		
		public function cancelTrailer(tid:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(tid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GIVEUP_TASK,data);
		}
	}
}