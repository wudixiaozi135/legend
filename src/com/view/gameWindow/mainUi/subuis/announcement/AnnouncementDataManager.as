package com.view.gameWindow.mainUi.subuis.announcement
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.AllBossRewardCfgData;
    import com.model.configData.cfgdata.AnnouncementCfgData;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.EveryDayRewardCfgData;
    import com.model.configData.cfgdata.FirstChargeRewardCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.LevelCompetitiveRewordCfgData;
    import com.model.configData.cfgdata.SpecialPreferenceRewordCfgData;
    import com.model.consts.ConstAnnouncement;
    import com.model.consts.SlotType;
    import com.model.dataManager.DataManagerBase;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
    import com.view.gameWindow.scene.announcement.AnnouncementVO;
    import com.view.gameWindow.scene.stateAlert.HorizontalAlert;
    import com.view.gameWindow.scene.stateAlert.TaskAlert;
    import com.view.gameWindow.util.HashMap;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    
    import flash.utils.ByteArray;
    
    import mx.utils.StringUtil;

    public class AnnouncementDataManager extends DataManagerBase
	{
		private static var _instance:AnnouncementDataManager;
		public static function get instance():AnnouncementDataManager
		{
			if(!_instance)
			{
				_instance = new AnnouncementDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function AnnouncementDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_ANNOUNCEMENT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_EQUIP_STRENGTHEN_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_EQUIP_POLISH_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_EQUIP_UPDATE_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_GOD_MAGIC_WEAPON_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_LONGCHENG_LEAGUE_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_LONGCHENG_LEADER_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TELEPORT_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FIND_TREASURE_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_OPEN_BOX_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MONSTER_DROP_DIE_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MONSTER_DIE_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MONSTER_REVIVE_BROAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FIRST_PAY_REWARD_GET_BROADCAST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SPECIAL_PREFERENCEREWORD_GET_BROADCAST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_GET_LEVEL_COMPETITIVE_REWARD_END_BROADCAST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ALL_BOSS_REWARD_GET_BROADCAST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_DAILY_PAY_REWARD_GET_BROADCAST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TRAILER_MAX_QUALITY,this);
			//GM
			DistributionManager.getInstance().register(GameServiceConstants.SM_ANNOUNCEMENT_OF_GM, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ANNOUNCEMENT_OPERATION_GM, this);

            DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_SEA_SIDE_SUBMIT_BROADCAST, this);
            DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_SEA_SIDE_TOTAL_SUBMIT_BROADCAST, this);
		}
		
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(proc == GameServiceConstants.SM_ANNOUNCEMENT)
			{
				dealAnnouncement(data);
			}
			else if(proc == GameServiceConstants.SM_EQUIP_STRENGTHEN_BROAD)
			{
				dealEquipStrengthenBroad(data);
			}
			else if(proc == GameServiceConstants.SM_EQUIP_POLISH_BROAD)
			{
				dealEquipPolishBroad(data);
			}
			else if(proc == GameServiceConstants.SM_EQUIP_UPDATE_BROAD)
			{
				dealEquipUpdateBroad(data);
			}
			else if(proc == GameServiceConstants.SM_GOD_MAGIC_WEAPON_BROAD)
			{
				dealGodMagicWeaponBroad(data);
			}
			else if(proc == GameServiceConstants.SM_FAMILY_LONGCHENG_LEAGUE_BROAD)
			{
				dealFamilyLongChengLeagueBroad(data);
			}
			else if(proc == GameServiceConstants.SM_FAMILY_LONGCHENG_LEADER_BROAD)
			{
				dealFamilyLongChengLeaderBroad(data);
			}
			else if(proc == GameServiceConstants.SM_TELEPORT_BROAD)
			{
				dealTeleportBroad(data);
			}
			else if(proc == GameServiceConstants.SM_FIND_TREASURE_BROAD)
			{
				dealFindTreasureBroad(data);
			}
			else if(proc == GameServiceConstants.SM_OPEN_BOX_BROAD)
			{
				dealOpenBox(data);
			}
			else if(proc == GameServiceConstants.SM_MONSTER_DROP_DIE_BROAD)
			{
				dealMonsterDropDieBroad(data);
			}
			else if(proc == GameServiceConstants.SM_MONSTER_DIE_BROAD)
			{
				dealMonsterDieBroad(data);
			}
			else if(proc == GameServiceConstants.SM_MONSTER_REVIVE_BROAD)
			{
				dealMonsterReviveBroad(data);
			}
			else if(proc == GameServiceConstants.SM_ANNOUNCEMENT_OF_GM)
			{
				dealGMAnnouncement(data,1);
			}else if(proc == GameServiceConstants.SM_ANNOUNCEMENT_OPERATION_GM)
			{
				dealGMAnnouncement(data,2);
            } else if (proc == GameServiceConstants.SM_ACTIVITY_SEA_SIDE_SUBMIT_BROADCAST)
            {
                dealSeaSideSubmitBroadCast(data);
            } else if (proc == GameServiceConstants.SM_ACTIVITY_SEA_SIDE_TOTAL_SUBMIT_BROADCAST)
            {
                dealSeaSideSubmitExpBroadCast(data);
            }else if(proc==GameServiceConstants.SM_FIRST_PAY_REWARD_GET_BROADCAST)
			{
				dealOpenServerActi(data,0);
			}else if(proc==GameServiceConstants.SM_SPECIAL_PREFERENCEREWORD_GET_BROADCAST)
			{
				dealOpenServerActi(data,1);
			}else if(proc==GameServiceConstants.SM_GET_LEVEL_COMPETITIVE_REWARD_END_BROADCAST)
			{
				dealLevelCompetitive(data);
			}else if(proc==GameServiceConstants.SM_ALL_BOSS_REWARD_GET_BROADCAST)
			{
				dealOpenServerActi(data,3);
			}else if(proc==GameServiceConstants.SM_DAILY_PAY_REWARD_GET_BROADCAST)
			{
				dealOpenServerActi(data,4);
			}else if(proc==GameServiceConstants.SM_TRAILER_MAX_QUALITY)
			{
				dealTrailerMaxQuality(data);
			}
			super.resolveData(proc, data);
		}
		
		private function dealTrailerMaxQuality(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var str:String = announcementCfg.text.replace("|cid|",name).replace("npc","");
			HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xffffff,0,999,false);
			ChatDataManager.instance.sendSystemNotice("<p>" +  StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"","event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","","")
				+ "<link event='flyNPC' data='"+announcementCfg.npc_id+ "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" +"</p>");
		}
		
		private function dealLevelCompetitive(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var gift_id:int = data.readInt();
			var count:int = data.readInt();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var str:String = "";
			var levelMatchReward:LevelCompetitiveRewordCfgData = ConfigDataManager.instance.levelMatchReward(gift_id);
			
			while(count--)
			{
				var item_id:int = data.readInt();
				var item_type:int = data.readByte();
				var item_bornsid:int = data.readInt();
				var item_count:int = data.readInt();
				var itemName:String;
				var equipColor:String;
				
				if(item_type == SlotType.IT_EQUIP)
				{
					equipColor = ConfigDataManager.instance.qualityCfgData(MemEquipDataManager.instance.memEquipData(item_bornsid,item_id).equipCfgData.color).rgb_text;
					itemName = "|" + equipColor + "|" + MemEquipDataManager.instance.memEquipData(item_bornsid,item_id).equipCfgData.name;
				}
				else if(item_type == SlotType.IT_ITEM)
				{
					equipColor = ConfigDataManager.instance.qualityCfgData(ConfigDataManager.instance.itemCfgData(item_id).quality).rgb_text;
					itemName = "|" + equipColor + "|" + ConfigDataManager.instance.itemCfgData(item_id).name;
				}
				str = announcementCfg.text.replace("|cid|",name).replace("|item|",itemName).replace("|name|",levelMatchReward.name).replace("panel","");
				HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xffffff,0,999,false);
				ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","","event='equip' data='"  + sid + "|"+ item_id + "|" + item_type +"'","") +
					"<link event='openPanel' data='" +announcementCfg.link_content  + "|" +  String(announcementCfg.para) + "|" +  String(announcementCfg.unlock_id) + "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" +"</p>");
			}
		}
		
		private function dealOpenServerActi(data:ByteArray, param:int):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var gift_id:int = data.readInt();
			
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var str:String = "";
			switch(param)
			{
				case 0:
					var firstChargeReward:FirstChargeRewardCfgData = ConfigDataManager.instance.firstChargeReward(gift_id);
					str = announcementCfg.text.replace("|cid|",name).replace("|name|",firstChargeReward.name);
					break;
				case 1:
					var cheapReward:SpecialPreferenceRewordCfgData = ConfigDataManager.instance.cheapReward(gift_id);
					str = announcementCfg.text.replace("|cid|",name).replace("|name|",cheapReward.name);
					break;
				case 2:
					var levelMatchReward:LevelCompetitiveRewordCfgData = ConfigDataManager.instance.levelMatchReward(gift_id);
					str = announcementCfg.text.replace("|cid|",name).replace("|name|",levelMatchReward.name);
					break;
				case 3:
					var allBossReward:AllBossRewardCfgData = ConfigDataManager.instance.allBossReward(gift_id);
					str = announcementCfg.text.replace("|cid|",name).replace("|name|",allBossReward.name);
					break;
				case 4:
					var everydayRewardCfg:EveryDayRewardCfgData = ConfigDataManager.instance.everydayRewardCfg(gift_id);
					str = announcementCfg.text.replace("|cid|",name).replace("|name|",everydayRewardCfg.name);
					break;
			}
			if(str != "")
			{
				str=str.replace("panel","");
				HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
				ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","","","","","") +
					"<link event='openPanel' data='" +announcementCfg.link_content  + "|" +  String(announcementCfg.para) + "|" +  String(announcementCfg.unlock_id) + "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" +"</p>");
			}
		}
		
        private function dealSeaSideSubmitBroadCast(data:ByteArray):void
        {
            var cid:int = data.readInt();
            var sid:int = data.readInt();
            var name:String = data.readUTF();
            var broadcast_id:int = data.readInt();
            var itemid:int = data.readInt();
            var item_count:int = data.readInt();
            var bindgold:int = data.readInt();
            var itemType:int = 1;

            var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
            if (!announcementCfg)
            {
                return;
            }
            var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(itemid);
            var itemName:String = itemCfg.name;
            var equipColor:String = ConfigDataManager.instance.qualityCfgData(itemCfg.quality).rgb_text;
            var str:String = announcementCfg.text.replace("|cid|", name).replace("|num1|", item_count).replace("|item|", "|" + equipColor + "|" + itemName).replace("|num2|", bindgold);
            HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str, 0xfef5e3, 3, 18), 0xfef5e3, 0, 999, false);
            var xmlStr:String = CfgDataParse.pareseDesToXml(str);
            var msg:String = "<p>" + StringUtil.substitute(xmlStr, "event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'", "", "event='equip' data='" + sid + "|" + itemid + "|" + itemType + "'", "", "") + "</p>";
            ChatDataManager.instance.sendSystemNotice(msg);
        }

        private function dealSeaSideSubmitExpBroadCast(data:ByteArray):void
        {
            var cid:int = data.readInt();
            var sid:int = data.readInt();
            var name:String = data.readUTF();
            var broadcast_id:int = data.readInt();
            var count:int = data.readInt();
            var bindgold:int = data.readInt();
            var exp:int = data.readInt();

            var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
            if (!announcementCfg)
            {
                return;
            }
            var str:String = announcementCfg.text.replace("|cid|", name).replace("|num1|", count).replace("|num2|", bindgold).replace("|num3|", exp);
            HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str, 0xfef5e3, 3, 18), 0xfef5e3, 0, 999, false);
            ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str), "event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'", "", "", "") + "</p>");
        }

		private function dealMonsterReviveBroad(data:ByteArray):void
		{
			var monster_id:int = data.readInt();
			var broadcast_id:int = data.readInt();
			var map_id:int = data.readInt();
			var map_monster_id:int = data.readInt();
			var mapName:String = ConfigDataManager.instance.mapCfgData(map_id).name;
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			var monsterName:String = ConfigDataManager.instance.monsterCfgData(monster_id).name;
			if(!announcementCfg)
			{
				return;
			}
			var str:String = "";
			var equipColor:String 
			str = announcementCfg.text.replace("|map|",mapName ).replace("|monster|",monsterName).replace("fly","");
			if(str != "")
			{
				HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
				ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"","","","","","","") +
					"<link event='flyMap' data='" +map_monster_id+ "|"+map_id+"' color='0x00ff00'>" + announcementCfg.link_text+ "</link></p>");
			}
		}
		
		private function dealMonsterDieBroad(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var monster_id:int = data.readInt();
			var broadcast_id:int = data.readInt();
			var map_id:int = data.readInt();
			var mapName:String = ConfigDataManager.instance.mapCfgData(map_id).name;
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			var monsterName:String = ConfigDataManager.instance.monsterCfgData(monster_id).name;
			if(!announcementCfg)
			{
				return;
			}
			var str:String = "";
			var equipColor:String 
			str = announcementCfg.text.replace("|cid|",name).replace("|map|",mapName ).replace("|monster|",monsterName);
			if(str != "")
			{
				HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
				ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","","","","","") + "</p>");
			}
		}
		
		private function dealOpenBox(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var baoxian_id :int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var count:int = data.readInt();
			while(count--)
			{
				var item_id:int = data.readInt();
				var item_type:int = data.readInt();
				var born_sid:int = data.readInt();
				var item_count:int = data.readInt();
				var itemName:String;
				var equipColor:String;
				if(item_type == SlotType.IT_EQUIP)
				{
					equipColor = ConfigDataManager.instance.qualityCfgData(MemEquipDataManager.instance.memEquipData(born_sid,item_id).equipCfgData.color).rgb_text;
					itemName = "|" + equipColor + "|" + MemEquipDataManager.instance.memEquipData(born_sid,item_id).equipCfgData.name;
				}
				else if(item_type == SlotType.IT_ITEM)
				{
					equipColor = ConfigDataManager.instance.qualityCfgData(ConfigDataManager.instance.itemCfgData(item_id).quality).rgb_text;
					itemName = "|" + equipColor + "|" + ConfigDataManager.instance.itemCfgData(item_id).name;
				}
				var str:String = announcementCfg.text.replace("|cid|",name).replace("|item|",ConfigDataManager.instance.itemCfgData(baoxian_id).name).replace("|item|",itemName);
				HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xffffff,0,999,false);
				ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","","event='equip' data='"  + sid + "|"+ item_id + "|" + item_type +"'","") + "</p>");
			}
		}
		
		private function dealMonsterDropDieBroad(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var monster_id:int = data.readInt();
			var broadcast_id:int = data.readInt();
			var map_id:int = data.readInt();
			var mapName:String = ConfigDataManager.instance.mapCfgData(map_id).name;
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			var monsterName:String = ConfigDataManager.instance.monsterCfgData(monster_id).name;
			if(!announcementCfg)
			{
				return;
			}
			var count:int = data.readInt();
			while(count--) 
			{
				var item_id:int = data.readInt();
				var item_type:int = data.readInt();
				var item_count:int = data.readInt();
				var x:int = data.readInt(); 
				var y:int = data.readInt(); 
				var str:String = "";
                var equipColor:String;
				if(item_type == SlotType.IT_EQUIP/* && ConfigDataManager.instance.equipCfgData(item_id).level >= 60*/)
				{
					equipColor = ConfigDataManager.instance.qualityCfgData(ConfigDataManager.instance.equipCfgData(item_id).color).rgb_text;
					str = announcementCfg.text.replace("|cid|",name).replace("|map|",mapName + "(" + String(x) + "，"  + String(y) + ")").replace("|monster|",monsterName).replace("|equip|","|" + equipColor + "|" +ConfigDataManager.instance.equipCfgData(item_id).name);
				}
				else if(item_type == SlotType.IT_ITEM)
				{
					equipColor = ConfigDataManager.instance.qualityCfgData(ConfigDataManager.instance.itemCfgData(item_id).quality).rgb_text;
					str = announcementCfg.text.replace("|cid|",name).replace("|map|",mapName + "(" + String(x) + "，"  + String(y) + ")").replace("|monster|",monsterName).replace("|equip|","|" + equipColor + "|" +ConfigDataManager.instance.itemCfgData(item_id).name);
				}
				if(str != "")
				{
					HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
					ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","","","","","event='equip' data='"  + sid + "|"+ item_id + "|" + item_type +"'") + "</p>");
				}
			}
		}
		
		private function dealFindTreasureBroad(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var count:int = data.readInt();
			while(count--)
			{
				var item_id:int = data.readInt();
				var item_type:int = data.readInt();
				var born_sid:int = data.readInt();
				var item_count:int = data.readInt();
				var itemName:String;
				var equipColor:String;
				if(item_type == SlotType.IT_EQUIP)
				{
					equipColor = ConfigDataManager.instance.qualityCfgData(MemEquipDataManager.instance.memEquipData(born_sid,item_id).equipCfgData.color).rgb_text;
					itemName = "|" + equipColor + "|" + MemEquipDataManager.instance.memEquipData(born_sid,item_id).equipCfgData.name;
				}
				else if(item_type == SlotType.IT_ITEM)
				{
					equipColor = ConfigDataManager.instance.qualityCfgData(ConfigDataManager.instance.itemCfgData(item_id).quality).rgb_text;
					itemName = "|" + equipColor + "|" + ConfigDataManager.instance.itemCfgData(item_id).name;
				}
				var str:String = announcementCfg.text.replace("|cid|",name).replace("|item|",itemName);
				HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
				ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","event='equip' data='"  + sid + "|"+ item_id + "|" + item_type +"'","")
					+ "<link event='openPanel' data='" +announcementCfg.link_content  + "|" +  String(announcementCfg.para) + "|" +  String(announcementCfg.unlock_id) + "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" + "</p>");
			}
		}
		
		private function dealTeleportBroad(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var map_id:int = data.readInt();
			var mapName:String = ConfigDataManager.instance.mapCfgData(map_id).name;
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var str:String = announcementCfg.text.replace("|cid|",name).replace("|map|",mapName).replace("|npc","");;
			HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
			if(announcementCfg.text.indexOf("#ffc000") == 0)
			{
				ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"","event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","","") 
					+ "<link event='flyNPC' data='"+announcementCfg.npc_id+ "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" +"</p>");
			}
			else
			{
				ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","","") 
					+ "<link event='flyNPC' data='"+announcementCfg.npc_id+ "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" +"</p>");
			}
		}
		
		private function dealFamilyLongChengLeaderBroad(data:ByteArray):void
		{
			var broadcast_id:int = data.readInt();
			var familyName:String = data.readUTF();
			var name:String = data.readUTF();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var str:String = announcementCfg.text.replace("|familyname1|",familyName).replace("|name|",name);
			HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
			ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"","","","","")+ "</p>");
		}
		
		private function dealFamilyLongChengLeagueBroad(data:ByteArray):void
		{
			var broadcast_id:int = data.readInt();
			var familyName1:String = data.readUTF();
			var familyName2:String = data.readUTF();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var str:String = announcementCfg.text.replace("|familyname1|",familyName1).replace("|familyname2|",familyName2);
			HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
			ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"","","","") + "</p>");
		}
		
		private function dealGodMagicWeaponBroad(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var equip_id:int = data.readInt();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(sid,equip_id);
			var equipName:String = memEquipData.equipCfgData.name;
			var equipColor:String = ConfigDataManager.instance.qualityCfgData(memEquipData.equipCfgData.color).rgb_text;
			var str:String = announcementCfg.text.replace("|cid|",name).replace("|equip|","|" + equipColor + "|" +equipName).replace("panel","");
			HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
			ChatDataManager.instance.sendSystemNotice("<p>" +  StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","event='equip' data='"  + sid + "|"+ equip_id + "|" + 2 +"'","")
				+ "<link event='openPanel' data='" +announcementCfg.link_content  + "|" +  String(announcementCfg.para) + "|" +  String(announcementCfg.unlock_id) + "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" + "</p>");
		}
		
		private function dealEquipUpdateBroad(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var begin_base_id:int = data.readInt();
			var equip_id:int = data.readInt();
			var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(begin_base_id);
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(sid,equip_id);
			var equipName:String = memEquipData.equipCfgData.name;
			var equipColor:String = ConfigDataManager.instance.qualityCfgData(equipCfg.color).rgb_text;
			var equipColor2:String = ConfigDataManager.instance.qualityCfgData(memEquipData.equipCfgData.color).rgb_text;
			var str:String = announcementCfg.text.replace("|cid|",name).replace("|equip|","|" + equipColor + "|" +equipCfg.name).replace("|equip|","|" + equipColor2 + "|" +equipName).replace("panel","");
			HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
			ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid + "|" + name + "'","","event='baseEquip' data='" + begin_base_id +"'",
				"","event='equip' data='"  + sid + "|"+ equip_id + "|" + 2 +"'","") + "<link event='openPanel' data='" + announcementCfg.link_content  + "|" +  String(announcementCfg.para) + "|" +  String(announcementCfg.unlock_id) + "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" + "</p>");
		}
		
		private function dealEquipPolishBroad(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var equip_id:int = data.readInt();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(sid,equip_id);
			var equipName:String = memEquipData.equipCfgData.name;
			var equipColor:String = ConfigDataManager.instance.qualityCfgData(memEquipData.equipCfgData.color).rgb_text;
			var str:String = announcementCfg.text.replace("|cid|",name).replace("|equip|","|" + equipColor + "|" +equipName).replace("|c2|",memEquipData.polish).replace("panel","");
			HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
			ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid  + "|" + name + "'","",
				"event='equip' data='"  + sid + "|"+ equip_id + "|" + 2 +"'","","","") + "<link event='openPanel' data='" +announcementCfg.link_content  + "|" +  String(announcementCfg.para) + "|" +  String(announcementCfg.unlock_id) + "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" + "</p>");
		}
		
		private function dealEquipStrengthenBroad(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			var broadcast_id:int = data.readInt();
			var equip_id:int = data.readInt();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(broadcast_id);
			if(!announcementCfg)
			{
				return;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(sid,equip_id);
			var equipName:String = memEquipData.equipCfgData.name;
			var equipColor:String = ConfigDataManager.instance.qualityCfgData(memEquipData.equipCfgData.color).rgb_text;
			var str:String = announcementCfg.text.replace("|cid|",name).replace("|equip|", "|" + equipColor + "|" +equipName).replace("|c2|",memEquipData.strengthen).replace("panel","");
			HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(str,0xfef5e3,3,18),0xfef5e3,0,999,false);
			
			ChatDataManager.instance.sendSystemNotice("<p>" + StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"event='cidMenu' data='" + sid + "|" + cid  + "|" + name + "'","",
				"event='equip' data='"  + sid + "|"+ equip_id + "|" + 2 +"'","","","") + "<link event='openPanel' data='" +announcementCfg.link_content  + "|" +  String(announcementCfg.para) + "|" +  String(announcementCfg.unlock_id) + "' color='0x00ff00'>" + announcementCfg.link_text+ "</link>" + "</p>");
		}
		
		private function dealAnnouncement(data:ByteArray):void
		{
			var type:int = data.readByte();
			var id:int = data.readInt();
			var announcementCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(id);
			if(announcementCfg && announcementCfg.text != "")
			{
				if(type == ConstAnnouncement.AT_GENERAL)
				{
					HorizontalAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(announcementCfg.text,0xfef5e3,3,24));
				}
				else if(type == ConstAnnouncement.AT_ACTIVITY_OR_DUNGEON)
				{
					TaskAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(announcementCfg.text,0xfef5e3,3,24));
				}
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////
		//GM  公告
		public var announcementList:HashMap = new HashMap;
		
		
		private function dealGMAnnouncement(data:ByteArray,type:int):void
		{
			/*	id，GM编号，4字节有符号整形
			tilte，标题，字符串形utf8格式
			content，内容，字符串形utf8格式
			type，类型（1.走马灯 2.聊天栏），1字节有符号整形
			begin_time，开始时间，4字节有符号整形
			end_time，结束时间，4字节有符号整形
			interval，间隔显示时间，4字节有符号整形
			duration，持续显示时间，4字节有符号整形*/
            var announcementVo:AnnouncementVO;
			if(type == 1)
			{
				announcementVo = new AnnouncementVO;
				announcementVo.id = data.readInt();
				announcementVo.title = data.readUTF();
				announcementVo.content = data.readUTF();
				announcementVo.type = data.readByte();
				announcementVo.begin_time = data.readInt();
				announcementVo.end_time = data.readInt();
				announcementVo.interval = data.readInt();
				//announcementVo.duration = data.readInt(); 
				AnnouncementDataManager.instance.addAnnouncement(announcementVo);
			}else if(type == 2)
			{
				/*type 发送操作类型 （1，增加 2.删除 3.修改），1字节有符号整形
				id  公告id ，4字节有符号整形
				tilte，标题，字符串形utf8格式
				content，内容，字符串形utf8格式
				type，类型（1.走马灯 2.聊天栏'），1字节有符号整形
				begin_time，开始时间，4字节有符号整形
				end_time，结束时间，4字节有符号整形
				interval，间隔显示时间，4字节有符号整形
				duration，持续显示时间，4字节有符号整形*/
				var type2:int = data.readByte();
				var id:int = data.readInt();
				if(type2 == 1)
				{
					announcementVo = new AnnouncementVO;
					announcementVo.id = id;
					announcementVo.title = data.readUTF();
					announcementVo.content = data.readUTF();
					announcementVo.type = data.readByte();
					announcementVo.begin_time = data.readInt();
					announcementVo.end_time = data.readInt();
					announcementVo.interval = data.readInt();
					//announcementVo.duration = data.readInt(); 
					AnnouncementDataManager.instance.addAnnouncement
						
						(announcementVo);
				}else if(type2 == 2)
				{
					AnnouncementDataManager.instance.delAnnouncement(id);
				}else if(type2 == 3)
				{
					announcementVo = new AnnouncementVO;
					announcementVo.id = id;
					announcementVo.title = data.readUTF();
					announcementVo.content = data.readUTF();
					announcementVo.type = data.readByte();
					announcementVo.begin_time = data.readInt();
					announcementVo.end_time = data.readInt();
					announcementVo.interval = data.readInt();
					//announcementVo.duration = data.readInt(); 
					AnnouncementDataManager.instance.changeAnnouncement
						
						(id,announcementVo);
				}                              
			} 
		}
		
		private function addAnnouncement(vo:AnnouncementVO):void
		{
			if(!announcementList.containsKey(vo.id))
			{
				announcementList.add(vo.id,vo);
			}
		}
		
		private function delAnnouncement(id:int):void
		{
			if(announcementList.containsKey(id))
			{
				announcementList.remove(id);
			}
		}
		
		private function changeAnnouncement(id:int,vo:AnnouncementVO):void
		{
			if(announcementList.containsKey(id))
			{
				announcementList.setValue(id,vo);
			}
		}

	}
}
class PrivateClass{}