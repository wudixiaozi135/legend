package com.view.gameWindow.mainUi.subuis.chatframe
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.MapBossCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.dataManager.TeleportDatamanager;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactType;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.menus.handlers.RoleMenuHandle;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.stall.StallDataManager;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.movie.MovieManager;
	import com.view.gameWindow.scene.stateAlert.HorizontalAlert;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.DebugUI;
	import com.view.newMir.NewMirMediator;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import mx.utils.StringUtil;

	/**
	 * @author wqhk
	 * 2014-8-9
	 */
	public class ChatDataManager extends DataManagerBase
	{
		public var chatList:Vector.<ChatData>;
		public var updateIndex:int = -1;
		
		private static var _instance:ChatDataManager;
		
		public static function get instance():ChatDataManager
		{
			if(!_instance)
				_instance = new ChatDataManager(hideFun);
			return _instance;
		}
		private static function hideFun():void{}
		
		public function ChatDataManager(fun:Function)
		{
			super();
			if(fun != hideFun)
				throw new Error("该类使用单例模式");
			
			chatList = new Vector.<ChatData>();//注意数据的清除
			DistributionManager.getInstance().register(GameServiceConstants.SM_PUBLIC_CHAT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_PRIVATE_CHAT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_CREATE_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_RANK_GOLD_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_ADD_MAX_COUNT_BROAD,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_GM_BAN_CHAT,this);
			
		}
		
		public function updateOutput():void
		{
			notify(GameServiceConstants.SM_PUBLIC_CHAT);
		}
		
		public function checkCmd(text:String):Boolean
		{
			var isCmd:Boolean = false;
            if(text=="debuger"||text=="-debuger"){
                DebugUI.instance.toggle();
                isCmd=true;
                return isCmd;
            }
			var cmd:Array = text.split(" ");
			if (cmd.length > 0)
			{
				var data:ByteArray = new ByteArray();
				data.endian=Endian.LITTLE_ENDIAN;
				
				switch(cmd[0])
				{
					case "item":
						if (cmd.length == 4)
						{
							data.writeByte(3);
							data.writeInt(parseInt(cmd[1]));
							data.writeInt(parseInt(cmd[2]));
							data.writeByte(parseInt(cmd[3]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "equip":
						if (cmd.length == 4)
						{
							data.writeByte(4);
							data.writeInt(parseInt(cmd[1]));
							data.writeInt(parseInt(cmd[2]));
							data.writeByte(parseInt(cmd[3]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "coin":
						if (cmd.length == 3)
						{
							data.writeByte(1);
							data.writeInt(parseInt(cmd[1]));
							data.writeInt(parseInt(cmd[2]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "move":
						if (cmd.length == 4)
						{
							data.writeByte(8);
							data.writeInt(parseInt(cmd[1]));
							data.writeShort(parseInt(cmd[2]));
							data.writeShort(parseInt(cmd[3]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
							
							//							MapManager.getInstance().clearScenePath();
							//							var firstPlayer:IFirstPlayer = SceneManager.getInstance()._self;
							//							if (firstPlayer)
							//							{
							//								firstPlayer.endMoving();
							//							}
						}
						break;
					case "move_auto":
						if (cmd.length == 4)
						{
							AutoSystem.instance.startAutoMap(parseInt(cmd[1]),parseInt(cmd[2]),parseInt(cmd[3]));
							isCmd = true;
						}
						break;
					case "target_auto":
						if (cmd.length == 3)
						{
							AutoSystem.instance.setTarget(parseInt(cmd[1]),parseInt(cmd[2]));
							isCmd = true;
						}
					case "exp":
						if (cmd.length == 2)
						{
							data.writeByte(5);
							data.writeInt(parseInt(cmd[1]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "attr":
						if (cmd.length == 3)
						{
							data.writeByte(6);
							data.writeInt(parseInt(cmd[1]));
							data.writeInt(parseInt(cmd[2]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "task":
						if(cmd.length == 2)
						{
							data.writeByte(7);
							data.writeInt(parseInt(cmd[1]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "gold"://元宝
						if(cmd.length == 3)
						{
							data.writeByte(2);
							data.writeInt(parseInt(cmd[1]));
							data.writeInt(parseInt(cmd[2]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "mail"://邮件
						if(cmd.length == 4)
						{
							data.writeByte(9);
							data.writeInt(parseInt(cmd[1]));
							data.writeInt(parseInt(cmd[2]));
							data.writeInt(parseInt(cmd[3]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "lv":
						if(cmd.length == 2)
						{
							data.writeByte(10);
							data.writeShort(parseInt(cmd[1]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "shengwang"://reputations 声望
						if(cmd.length == 2)
						{
							data.writeByte(11);
							data.writeInt(parseInt(cmd[1]));
							isCmd = true;
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD,data);
						}
						break;
					case "guide_lv":
						if(cmd.length == 3)
						{
							GuideSystem.instance.updateLevelState(cmd[1],cmd[2]);
						}
						isCmd = true;
						break;
					case "guide_map":
						if(cmd.length == 2)
						{
							GuideSystem.instance.updateEnterSceneState(cmd[1]);
						}
						isCmd = true;
						break;
					case "guide_task":
						if(cmd.length == 3)
						{
							GuideSystem.instance.updateTaskState(cmd[1],cmd[2]);
						}
						isCmd = true;
						break;
					case "guide_over":
						if(cmd.length == 2)
						{
							GuideSystem.instance.updateGuideState(cmd[1]);
						}
						isCmd = true;
						break;
					case "open":
						if(cmd.length == 2)
						{
							PanelMediator.instance.openPanel(cmd[1]);
						}
						isCmd = true;
						break;
					case "movie":
						if(cmd.length == 2)
						{
							MovieManager.instance.startMovie(cmd[1]);
						}
						isCmd = true;
						break;
					case "showFirstPlayerPos":
						if(cmd.length == 1)
						{
							
							var f:* = EntityLayerManager.getInstance().firstPlayer;
							trace(f.pixelX+":"+f.pixelY);
							trace(f.x+":"+f.y);
						}
						isCmd = true;
						break;
					case "rein":
						if (cmd.length == 2)
						{
							data.writeByte(12);
							data.writeByte(parseInt(cmd[1]));
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD, data);
						}
						isCmd = true;
						break;
					case "attack":
						if(cmd.length == 1)
						{
							var te:IEntity = AutoJobManager.getInstance().selectEntity;
							AutoSystem.instance.startIndepentAttack(te.entityType,te.entityId);
						}
						isCmd = true;
						break;
					case "sys_chat":
//						if(cmd.length == 3)
//						{
//							sendSystemNotice(cmd[1]+" "+cmd[2],0xffff00);
//						}
						
						var txt:String = "<p color='0xcccccc'>江湖风起云涌，一个新的帮会：<link event='school' data='123456' color='0xff00'>草尼玛</link>成立了。帮主是<link color='0x00ccff'>草T玛</link></p>";
//						sendSystemNotice(txt);
						
//						sendPublicTalkEx(MessageCfg.CHANNEL_FAMILY,txt,0);
						
//						var tip:String = ChatDataManager.instance.createRoleLink(0,0,"wq");
//						tip = StringUtil.substitute(StringConst.SYSTEM_ALERT_12,tip);
//						tip = ChatDataManager.instance.createLinkParagraph(0xff0000,tip);
//						ChatDataManager.instance.sendPublicTalkEx(MessageCfg.CHANNEL_FAMILY,tip,0);
						
						
						var cid:int = 11;
						var sid:int = 12;
						var name:String = "wq";
						var linkName:String = ChatDataManager.instance.createRoleLink(cid,sid,name,0x00b0f0);
						var linkTrans:String = ChatDataManager.instance.createLinkText(StringConst.TIP_TRANS,
							ChatEvent.TRAILER_MEMBER_HELP,
							ChatEvent.createTrailerMemberHelpEventData(cid,sid),
							0x00ff00);
						var tip:String = StringUtil.substitute(StringConst.TRAILER_HINT_STRING_014,linkName,linkTrans);
						tip = ChatDataManager.instance.createLinkParagraph(0xffc000,tip);
						ChatDataManager.instance.sendNativeNotice(MessageCfg.CHANNEL_FAMILY,tip);
						
						isCmd = true;
						break;
					case "test_npc":
						if(cmd.length == 2)
						{
							AutoJobManager.getInstance().setAutoTargetData(cmd[1],EntityTypes.ET_NPC);
						}
						isCmd = true;
						break;
					case "gx"://功勋
						if (cmd.length == 2)
						{
							data.writeByte(13);
							data.writeInt(parseInt(cmd[1]));
							ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEBUG_CMD, data);
						}
						isCmd = true;
						break;
					case "hideUI":
						UICenter.hideMainUI();
						isCmd = true;
						break;
					case "startTestHMsg":
						startTestHMsgTimeId =
//						setInterval(HorizontalAlert.getInstance().showMSG,20,"<TEXTFORMAT LEADING='3'><span><font face='SimSun' size='18' color='#a7dbe'>幹涸旳の記憶</font></span></TEXTFORMAT>" +
//																			"<TEXTFORMAT LEADING='3'><span><font face='SimSun' size='18' color='#ffc000'>成功地将 </font></span></TEXTFORMAT>" +
//																			"<TEXTFORMAT LEADING='3'><span><font face='SimSun' size='18' color='#e4ff'>雷霆战盔 </font></span>" +
//																			"</TEXTFORMAT><TEXTFORMAT LEADING='3'><span><font face='SimSun' size='18' color='#ffc000'>强化到</font></span></TEXTFORMAT>" +
//																			"<TEXTFORMAT LEADING='3'><span><font face='SimSun' size='18' color='#ff49f4'> +10 </font></span></TEXTFORMAT>" +
//																			"<TEXTFORMAT LEADING='3'><span><font face='SimSun' size='18' color='#ffc000'>！战斗力大大地提升！</font></span></TEXTFORMAT>",16709091,0,999,false);
						
						setInterval(sendSystemNotice,20,"<p><link event='cidMenu' data='2|54181|幹涸旳の記憶'color='0x0a7dbe'>幹涸旳の記憶</link>" +
														"<link color='0xffc000'>成功地将 </link>" +
														"<link event='equip' data='2|1604825|2'color='0xffdc96'>井中月 </link>" +
														"<link color='0xffc000'>强化到</link><link color='0xff49f4'> +20 </link>" +
														"<link color='0xffc000'>！战斗力大大地提升！</link>" +
														"<link event='openPanel' data='104|0|117' color='0x00ff00'>我也要强化</link></p>");
						isCmd = true;
						break;
					case "stopTestHMsg":
						clearInterval(startTestHMsgTimeId);
						isCmd = true;
						break;
					case "showGuides":
						var guides:Array = GuideSystem.instance.doingList;
						var guideTxt:String = guides.join(",");
						sendNativeNotice(MessageCfg.CHANNEL_SYSTEM,guideTxt);
						isCmd = true;
						break;
					//					case "job":
					//						if (cmd.length == 2)
					//						{
					//							sendDebugChangeJob(parseInt(cmd[1]));
					//							isCmd = true;
					//						}
					//						break;
					//					case "kingdom":
					//						if (cmd.length == 2)
					//						{
					//							sendDebugChangeKingdom(parseInt(cmd[1]));
					//							isCmd = true;
					//						}
					//						break;
					//					case "ask":
					//						if (cmd.length == 2)
					//						{
					//							var sentence:String = cmd[1];
					//							var count:int = 0;
					//							ChatOutputManager.getInstance().addWarningText("Items", 0xffffff, ZhushenMediator.getInstance().gameWindow.chatInputPanel.currentChannel);
					//							for each(var itemCfg:ItemConfigData in ConfigDataManager.getInstance().itemConfig)
					//							{
					//								if(itemCfg.name.indexOf(sentence) >= 0)
					//								{
					//									if(count < 15)
					//										ChatOutputManager.getInstance().addWarningText(" -"+ itemCfg.id+"."+itemCfg.name+(itemCfg.bind>0?"[Bind]":""), ArticleQuality.getColorNumByQuality(itemCfg.quality), ZhushenMediator.getInstance().gameWindow.chatInputPanel.currentChannel);
					//									count++;
					//								}
					//							}
					//							ChatOutputManager.getInstance().addWarningText("Equips", 0xffffff, ZhushenMediator.getInstance().gameWindow.chatInputPanel.currentChannel);
					//							for each(var equipCfg:EquipConfigData in ConfigDataManager.getInstance().equipConfig)
					//							{
					//								if(equipCfg.name.indexOf(sentence) >= 0)
					//								{
					//									if(count < 15)
					//										ChatOutputManager.getInstance().addWarningText(" -"+ equipCfg.id+"."+equipCfg.name+(equipCfg.bind>0?"[Bind]":""), ArticleQuality.getColorNumByQuality(equipCfg.quality), ZhushenMediator.getInstance().gameWindow.chatInputPanel.currentChannel);
					//									count++;
					//								}
					//							}
					//							ChatOutputManager.getInstance().addWarningText(count.toString()+"Total "+(count>15?(count-15).toString()+"Left":""), 0xffffff, ZhushenMediator.getInstance().gameWindow.chatInputPanel.currentChannel);
					//							isCmd = true;
					//						}
					//						break;						
					//					case "cake":
					//						if (cmd.length == 2)
					//						{
					//							var job:int = parseInt(cmd[1]);
					//							sendDebugGetItem(80000, 1);
					//							sendDebugGetItem(80001, 1);
					//							sendDebugGetItem(80002, 1);
					//							sendDebugGetItem(80003, 1);
					//							sendDebugGetItem(80004, 1);
					//							sendDebugGetItem(80005, 1);
					//							sendDebugGetItem(80006, 1);
					//							sendDebugGetItem(80018, 1);
					//							sendDebugGetItem(21047, 1);
					//							sendDebugGetItem(21074, 1);
					//							if(job < 6)
					//							{
					//								sendDebugGetItem(80007, 1);
					//								sendDebugGetItem(80009, 1);
					//								sendDebugGetItem(80011, 1);
					//							}
					//							else
					//							{
					//								sendDebugGetItem(80008, 1);
					//								sendDebugGetItem(80010, 1);
					//								sendDebugGetItem(80012, 1);
					//							}
					//							sendDebugChangeExp(1640000);
					//							sendDebugChangeJob(job);
					//							sendDebugChangeKingdom(1);
					//							sendDebugChangeTask(150);
					//							sendDebugChangePosition(10008,74,148);
					//							isCmd = true;
					//						}
					//						break;
					//					case "debug":
					//						if (cmd.length == 2)
					//						{
					//							var debug:int=parseInt(cmd[1]);
					//							if(debug>0)
					//							{
					//								ConfigDataManager.getInstance().bytesLoadWarning=true;
					//								SystemAlertManager.getInstance().showAlert("debug turn on",true,false,false,false);
					//							}
					//							else
					//							{
					//								ConfigDataManager.getInstance().bytesLoadWarning=false;
					//								SystemAlertManager.getInstance().showAlert("debug turn off",true,false,false,false);
					//							}
					//							isCmd = true;
					//						}
					default:
						break;
				}
			}
			
			return isCmd;
		}
		
		private var startTestHMsgTimeId:int;
		
		
		/**
		协议id：	SM_PUBLIC_CHAT</br>
		下发数据：	channel，为1字节有符号整形，频道</br>
		cid，4字节有符号整形，角色id</br>
		sid，4字节有符号整形，服务器id</br>
		sex，1字节有符号整形，性别</br>
		name，utf-8，玩家名字</br>
		buff，4字节整形，聊天信息，客户端自己组织结构，注意，这里包含从channel，equipCount开始的所有内容</br>
		 */
		private function resolvePublicChat(data:ByteArray):void
		{
			var chatData:ChatData = new ChatData();
			chatData.channel = data.readByte();
			chatData.cid = data.readInt();
			chatData.sid = data.readInt();
			data.readByte();//vip
			chatData.sex = data.readByte();
			chatData.name = data.readUTF();
			
			chatData.buff = data.readUTF();
//			chatData.buff = GuardManager.getInstance().replaceBannedWord(chatData.buff);
			chatList.push(chatData);
		}
		
		private function resolvePrivateChat(data:ByteArray):void
		{
			var chatData:ChatData = new ChatData();
			chatData.channel = MessageCfg.CHANNEL_PRIVATE;
			chatData.cid = data.readInt();
			chatData.sid = data.readInt();
			data.readByte();//vip
			chatData.sex = data.readByte();
			chatData.name = data.readUTF();
			
			chatData.toCid = data.readInt();
			chatData.toSid = data.readInt();
			chatData.toName = data.readUTF();
			data.readByte();//vip
			data.readByte();//sex
			
			chatData.buff = data.readUTF();
//			chatData.buff = GuardManager.getInstance().replaceBannedWord(chatData.buff);
			
			
			if(!ContactDataManager.instance.isInContact(chatData.sid,chatData.cid,ContactType.BLACK))
			{
				chatList.push(chatData);
			}
		}
		
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_PUBLIC_CHAT:
					resolvePublicChat(data);
					break;
				case GameServiceConstants.SM_PRIVATE_CHAT:
					resolvePrivateChat(data);
					break;
				case GameServiceConstants.SM_FAMILY_CREATE_BROAD:
					resolveFamilyBroad(data);
					break;
				case GameServiceConstants.SM_FAMILY_RANK_GOLD_BROAD:
					resolveFamilyRank(data);
					break;
				case GameServiceConstants.SM_FAMILY_ADD_MAX_COUNT_BROAD:
					resolveFamilyAddMember(data);
					break;
				case GameServiceConstants.ERR_GM_BAN_CHAT:
					Alert.show(StringConst.FORBITTALK);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function resolveFamilyAddMember(data:ByteArray):void
		{
			var name:String= data.readUTF();
			var count:int=data.readInt();
			sendSystemNotice(StringUtil.substitute(StringConst.SCHOOL_PANEL_0129,name,count));
//			RollTipMediator.instance.showRollTip(RollTipType.PLACARD,StringUtil.substitute(StringConst.SCHOOL_PANEL_0125,name));
		}
		
		private function resolveFamilyRank(data:ByteArray):void
		{
			var name:String= data.readUTF();
			sendSystemNotice(StringUtil.substitute(StringConst.SCHOOL_PANEL_0125,name));
			RollTipMediator.instance.showRollTip(RollTipType.PLACARD,StringUtil.substitute(StringConst.SCHOOL_PANEL_0125,name));
		}
		
		private function resolveFamilyBroad(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var name:String= data.readUTF();
			sendSystemNotice(StringUtil.substitute(StringConst.SCHOOL_PANEL_0021,name));
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		/**
		 * 	协议id：	CM_GAME_PUBLIC_CHAT </br>
			上发数据：	channel，频道，为1字节有符号整形 </br>
			equipCount，装备数量，为1字节有符号整形 </br>
			下面缩进部分表示依照equipCount数量循环的数据 </br>
				bornSid，装备出生服务器id，4字节有符号整形 </br>
				equipId，装备id，4字节有符号整形 </br>
			buff，要上传的聊天信息，客户端自己组织结构 </br>

		 */
		public function sendPublicTalk(channel:int,buff:String,equipCount:int,...equips):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(channel);
			byteArray.writeByte(equipCount);
			if(equipCount>0)
			{
				for each(var id:int in equips)
				{
					byteArray.writeInt(id);
				}
			}
			
			byteArray.writeUTF(buff);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_PUBLIC_CHAT,byteArray);
		}
		
		/**
		 * 	协议id：	CM_GAME_PUBLIC_CHAT </br>
		 上发数据：	channel，频道，为1字节有符号整形 </br>
		 equipCount，装备数量，为1字节有符号整形 </br>
		 下面缩进部分表示依照equipCount数量循环的数据 </br>
		 bornSid，装备出生服务器id，4字节有符号整形 </br>
		 equipId，装备id，4字节有符号整形 </br>
		 buff，要上传的聊天信息，客户端自己组织结构 </br>
		 * 
		 * @param linkTxt 例子：<p color='0xcccccc'>江湖风起云涌，一个新的帮会：<link event='' data='' color='0xff00'>草尼玛</link>成立了。帮主是<link color='0x00ccff'>草T玛</link></p>
		 * 
		 * link节点的属性和值中都不能有半角冒号逗号
		 */
		public function sendPublicTalkEx(channel:int,linkTxt:String,equipCount:int,...equips):void
		{
			var inputs:Array = [];
			inputs.push(channel);
			
			parseLinkText(linkTxt,linkOutput);
			
			if(linkOutput.content)
			{
				inputs.push(linkOutput.content);
				if(equipCount > 0 && equips && equips.length > 0)
				{
					inputs.push(equipCount);
					inputs = inputs.concat(equips);
				}
				else
				{
					inputs.push(0);
				}
				
				sendPublicTalk.apply(null,inputs);
			}
		}
		
		private var lastSendSystemTime:int = 0;
		private var storeSystemInfo:Array = [];
		private var sendSystemTimeId:int = 0;
		private var maxStore:int = 100;
		private function delaySendSystemNotice():void
		{
			if(storeSystemInfo.length)
			{
				//如果超出50*2条记录则  去掉前面的50条
				if(storeSystemInfo.length > maxStore*2)
				{
					storeSystemInfo = storeSystemInfo.slice(storeSystemInfo.length - maxStore,storeSystemInfo.length);
				}
				
				var txt:String = storeSystemInfo.shift();
				var color:uint = storeSystemInfo.shift();
				
				sendSystemNotice(txt,color,true);
			}
			else if(sendSystemTimeId)
			{
				clearInterval(sendSystemTimeId);
				sendSystemTimeId = 0;
			}
		}
		
		public function sendSystemNotice(txt:String,color:uint = 0,immediate:Boolean = false):void
		{
			var curTime:int = getTimer();
			if(!immediate)
			{
				if(storeSystemInfo.length > 0 || curTime - lastSendSystemTime < 50)
				{
					storeSystemInfo.push(txt,color);
					if(sendSystemTimeId == 0)
					{
						sendSystemTimeId = setInterval(delaySendSystemNotice,500);
					}
					return;
				}	
			}
			
			lastSendSystemTime = curTime;
			
			if(storeSystemInfo.length == 0 && sendSystemTimeId)
			{
				clearInterval(sendSystemTimeId);
				sendSystemTimeId = 0;
			}
			
			var chatFrame:IChatFrame = NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame;
//			chatFrame.pushOutputData("/0 "+txt,color);
			
			parseLinkText(txt,linkOutput);
			
			if(linkOutput.content)
			{
				var chatData:ChatData = new ChatData();
				chatData.channel = 0;
				chatData.buff = linkOutput.content;
				chatData.color = color != 0 ? color : linkOutput.color;
				chatList.push(chatData);
				updateOutput();
			}
			
//			chatFrame.pushOutputData("/0 "+linkOutput.content, color!=0 ? color : linkOutput.color);
		}
		
		/**
		 * 目前支持 系统 组队 帮会
		 */
		public function sendNativeNotice(channel:int,txt:String,color:uint = 0):void
		{
			var chatFrame:IChatFrame = NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame;
			
			parseLinkText(txt,linkOutput);
//			chatFrame.pushOutputData("/"+channel+" "+linkOutput.content, color!=0 ? color : linkOutput.color);
			
			if(linkOutput.content)
			{
				var chatData:ChatData = new ChatData();
				chatData.channel = channel;
				chatData.buff = linkOutput.content;
				chatData.color = color!=0 ? color : linkOutput.color;
				chatList.push(chatData);
				updateOutput();
			}
		}
		
		
		private var linkOutput:Object = {};
		/**
		 * @param output .color .content
		 * 
		 * <p color='0xcccccc'>江湖风起云涌，一个新的帮会：<link event='' data='' color='0xff00'>草尼玛</link>成立了。帮主是<link color='0x00ccff'>草T玛</link></p>
		 * 
		 * link节点的属性和值中都不能有半角冒号逗号
		 */
		public function parseLinkText(txt:*,output:Object):void
		{
			var xml:XML; 
			if(txt is String)
			{
				try
				{
					xml = new XML(txt);
				}
				catch(e:Error)
				{
					xml = null;
				}
			}
			else if(txt is XML)
			{
				xml = txt;
			}
			
			if(!xml)
			{
				output.content = null;
				return;
			}
			
			var color:uint = parseInt(xml.@color);
			
			var caretIndex:int = 0;
			var content:String = "";
			var head:String = "";
			
			var children:XMLList = xml.children();
			
			if(children.length() != 0)
			{
				for each(var node:XML in children)
				{
					var text:String = node.toString();
					
					if(node.name() == "link")
					{
						var index:int = text.indexOf(":");
						if(index != -1)
						{
							continue;//出错
						}
						
						var newCaretIndex:int = caretIndex+text.length;
						var type:int = String(node.@event) ? 4:0;
						var code:String =type+","+caretIndex+","+newCaretIndex+",0x"+parseInt(node.@color).toString(16)+":"+text+":"+node.@event+":"+node.@data;
						
						if(head)
						{
							head += ",";
						}
						
						head += code;
					}
					
					content += text;
					caretIndex += text.length;
				}
			}
			else
			{
				content = xml.toString();
			}
			
			var all:String = "";
			all += "style{0x"+color.toString(16)+"} ";
			all += "head{"+head+"} ";
			all += content;
			
			output.color = color;
			output.content = all;
		}
		
		public function sendPrivateTalk(sid:int,cid:int,buff:String,equipCount:int,...equips):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(cid);
			byteArray.writeInt(sid);
			byteArray.writeByte(equipCount);
			if(equipCount>0)
			{
				for each(var id:int in equips)
				{
					byteArray.writeInt(id);
				}
			}
			
			byteArray.writeUTF(buff);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_PRIVATE_CHAT,byteArray);
		}

		//其实 应该走 公告的配置的
		public function createRoleLink(cid:int,sid:int,name:String,color:uint = 0x00ff00):String
		{
			var tip:String = "{0}，{1}，{2}";
			tip = StringUtil.substitute(tip,cid,sid,name);
			tip = createLinkText(name,"cidMenu",tip,color);
			return tip;
		}
		//其实 应该走 公告的配置的
		public function createLinkParagraph(color:uint,txt:String):String
		{
			var c:String = "0x"+color.toString(16);
			var tip:String = "<p color='{0}'>{1}</p>";
			tip = StringUtil.substitute(tip,c,txt);
			
			return tip;
		}
		
		//其实 应该走 公告的配置的 data中分隔符不要出现 半角逗号 和单双引号
		public function createLinkText(des:String,eventName:String,data:String,color:uint):String
		{
			var c:String = "0x"+color.toString(16);
			var tip:String = "<link event='{0}' color='{1}' data='{2}'>{3}</link>";
			tip = StringUtil.substitute(tip,eventName,c,data,des);
			
			return tip
		}
		
		public function onClickCustomLink(eventName:String,data:String,mouseEvent:MouseEvent):void
		{
			var chatFrame:IChatFrame = NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame;
			if(eventName == ChatEvent.OPENPANEL)
			{
				var _uiCenter:UICenter = new UICenter();
				var split:Array = data.split("|");
				var tabIndex:int = int(split[1]);
				var uiFuncId:int = int(split[0]);
				var unlockId:int = int(split[2]);
				var uiName:String = UICenter.getUINameFromMenu(uiFuncId.toString());
				
				if(!unlockId || GuideSystem.instance.isUnlock(unlockId))
				{
					_uiCenter.openUI(uiName);
					if(tabIndex>0)
					{
						var tab:IPanelTab = UICenter.getUI(uiName) as IPanelTab;
						if(tab)
						{
							tab.setTabIndex(tabIndex);
						}
					}
				}
				else
				{
					var lockTip:String = GuideSystem.instance.getUnlockTip(unlockId);
					Alert.warning(lockTip);
				}
			}
			else if(eventName == ChatEvent.CIDMENU)
			{
				var roleMenuHandle:RoleMenuHandle = new RoleMenuHandle();
				var roleMenuData:Array = data.split("|");
				roleMenuHandle.onClick(mouseEvent,roleMenuData[1],roleMenuData[0],roleMenuData[2]);
			}
			else if (eventName == ChatEvent.FLYSTALL)
			{
				if (RoleDataManager.instance.stallStatue == 0)
				{
					if (RoleDataManager.instance.isCanFly == 0)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0008);
						return;
					}
					GameFlyManager.getInstance().flyToMapByRegId(StallDataManager.MAP_REGION_ID);
				}
			}
			else if(eventName==ChatEvent.FLYMAP)
			{
				var flyData:Array = data.split("|");
				var map_monster_id:int = int(flyData[0]);
				var map_id:int = int(flyData[1]);
				var monster_group_id:int = ConfigDataManager.instance.mapMstCfgData(map_monster_id).monster_group_id;
				var mapBossCfgData:MapBossCfgData = ConfigDataManager.instance.mapBossCfgDataById(monster_group_id,map_monster_id);
				if(mapBossCfgData==null)return;
				if (RoleDataManager.instance.stallStatue == 0)
				{
					if (RoleDataManager.instance.isCanFly == 0)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0008);
						return;
					}
					var mapId:int = SceneMapManager.getInstance().mapId;
					if(mapBossCfgData.maps_nofly.indexOf(String(mapId)) ==-1)
					{
						BossDataManager.instance.deliverBoss(mapBossCfgData,6);
					}
					else
					{
						if(mapId == map_id)
						{
							RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BOSS_PANEL_0029);
							return;
						} 
					}	
				}
			}
			else if(eventName==ChatEvent.FLYNPC)
			{
				var npcId:int=int(data);
				TeleportDatamanager.instance.setTargetEntity(npcId,EntityTypes.ET_NPC);
				GameFlyManager.getInstance().flyToMapByNPC(npcId);
			}
			else if (eventName == ChatEvent.STALL)
			{
				
			}
			else if(eventName == ChatEvent.TRAILER_MEMBER_HELP)
			{
				var tmh:Array = ChatEvent.parseData(data);
				if(tmh)
				{
					TrailerDataManager.getInstance().requestTrailerHelp(int(tmh[0]),int(tmh[1]));
				}
			}
			else if(eventName == ChatEvent.EQUIP)
			{
				var datas:Array = data.split("|");
				if(datas.length < 3)
				{
					return;
				}
				if(datas[2] == SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(datas[0],datas[1]);
					if(memEquipData)
					{
						chatFrame.showTip(datas[2],memEquipData);
					}
					else
					{
						var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(datas[1]);
						chatFrame.showTip(SlotType.IT_EQUIP,equipCfgData);
					}
				}
				else if(datas[2] == SlotType.IT_ITEM)
				{
					chatFrame.showTip(datas[2],ConfigDataManager.instance.itemCfgData(datas[1]));
				}
			}
			else if(eventName == ChatEvent.BASEEQUIP)
			{
				chatFrame.showTip(SlotType.IT_EQUIP,ConfigDataManager.instance.equipCfgData(int(data)));
			}
		}
	}
}