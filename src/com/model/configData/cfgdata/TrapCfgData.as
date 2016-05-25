package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;

	public class TrapCfgData
	{
		public static const TRAP_TYPE_NO:int = 0;//普通
		public static const TRAP_TYPE_MINING:int = 1;//采矿
		public static const TRAP_TYPE_TREASURE_HUNT:int = 2;//寻宝
		
		public static const TRIGGER_TYPE_NO:int = 0;//不触发
		public static const TRIGGER_TYPE_NEAR:int = 1;//走到附近
		public static const TRIGGER_TYPE_CLICK:int = 2;//点击
		public static const TRIGGER_TYPE_READING:int = 3;//读条
		
		public var id:int;//11	序列
		public var name:String;//16	名字
		public var group_id:int;//11	组id
		public var ratio:int;//11	组内出现几率
		public var show_name:int;//11	是否显示名字
		public var trigger_type:int;//11	触发类型
		public var trigger_param:int;//11	触发参数
		public var player_action:int;//11	触发动作
		public var touch_num:int;//11	可以触发几次
		public var survival_time:int;//11	存活时间(毫秒)
		public var corpse_time:int;
		public var revival_time:int;//11	复活时间(毫秒)
		public var is_block:int;//11	是否阻挡
		public var trap_type:int;//11	机关类型
		public var monster_wave:int;//	11	召唤怪物波次
		public var trap_wave:int;//	11	召唤机关波次
		public var buff_id:int;//11	增加状态的id
		public var buff_time:int;//11	状态的时间(毫秒)
		public var item_id:int;//11	获得道具装备id
		public var item_type:int;//11	道具装备类型
		public var item_count:int;//11	道具装备数量
		public var drop:int;//11	是否产生掉落
		public var map_region:int;//11	地图传送区域
		public var dungeon_id:int;//11	切换副本
		public var cd:int;//11	作用间隔时间
		public var skill_group_id:int;//11 技能group_id
		public var skill_level:int;//11 技能等级
		public var item_cost_id:int;//11	道具消耗id
		public var item_cost_count:int;//11	道具消耗数量
		public var dialog:String;//256	对话
		public var head:String;//16	头像
		public var avatar:String;//16	模型
		public var small_avatar:String;
		public var ai_target:int;//11
		public var unselectable:int;
		public var display:String;
		public var hide_shadow:int;
		
		public function get itemCfgData():ItemCfgData
		{
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(item_cost_id);
			return itemCfgData;
		}
		
		public function TrapCfgData()
		{
		}
	}
}