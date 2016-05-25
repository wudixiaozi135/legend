package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;

	public class DungeonCfgData
	{
		public var id:int; //副本id
		public var name:String; //名称
		public var npc:int; //副本进入NPC
		/**功能类型1.常规|2.塔防|3.个人BOSS|4.主线|5.转生|6.主线塔防|7.英雄进阶|8.特戒副本*/
		public var func_type:int;
		/**结果类型<br>副本进入npc面板上使用*/
		public var result_type:String;
		/**内容类型1.主线|2.BOSS|3.转生|4.单人塔防|5.组队塔防|6.帮会|7.通天塔|8.VIP|9.特戒|10.英雄进阶*/
		public var content_type:int;
		public var player_num:int; //人数上限
		public var region:int; //出生区域
		public var duration:int; //持续时间(单位秒)
		public var reincarn:int; //最低转生
		public var level:int; //最低等级
		public var online:int;//当然在线时间（分钟）
		public var free_count:int; //每日免费次数
		public var toll_count:int; //收费次数
		public var complete_count:int;//完成次数 限制
		public var coin:int; //金币消耗(优先绑定金币)
		public var unbind_coin:int; //非绑金币消耗
		public var bind_gold:int; //元宝消耗(优先绑定金币)
		public var unbind_gold:int; //非绑元宝消耗
		public var player_daily_vit:int;//日常活力值消耗
		public var hero_daily_vit:int;//英雄活力值消耗
		public var item:int; //消耗道具
		public var item_count:int; //消耗道具数量
		public var item_gain:String;
		public var desc:String; //描述
		public var finally_reward:String; //BOSS/通关奖励
		
		public function get npcCfgData():NpcCfgData
		{
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npc);
			return npcCfgData;
		}
		
		public function get regionCfgData():MapRegionCfgData
		{
			var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(region);
			return mapRegionCfgData;
		}
		
		public function get mapCfgData():MapCfgData
		{
			if(!regionCfgData)
			{
				return null;
			}
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(regionCfgData.map_id);
			return mapCfgData;
		}
		
		public function get itemCfgData():ItemCfgData
		{
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(item);
			return itemCfgData;
		}
		
		public function DungeonCfgData()
		{
		}
	}
}