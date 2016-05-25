package com.model.configData.cfgdata
{
	public class DailyCfgData
	{
		public var id:int;//11	序列
		public var order:int;//11	主面板顺序
		public var type:int;//11	日常类型
		public var activity_id:int;//11	日常活动id
		public var task_type:int;//11	任务
		public var dungeon_id:int;//11	日常副本id
		public var condition_desc:String;//256	条件描述
		public var count:int;//11	需要完成次数
		public var player_daily_vit:int;//11	玩家活力值奖励
		public var hero_daily_vit:int;//11	英雄活力值奖励
		public var sub_order:int;//11	子面板顺序
		public var url1:String;//16	可参加图片路径
		public var url2:String;//16	不可参加图片路径
		public var url3:String;//16	地图图片路径
		public var game_desc:String;//256	玩法描述
		public var reward:String;//64	奖励展示
		public var reward_desc:String;//64	主要奖励
		public var npc_id:int;//11 入口npcId
		
		public function DailyCfgData()
		{
		}
	}
}