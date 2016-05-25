package com.model.configData.cfgdata
{
	public class ActivityEventCfgData
	{
		public static const EVENT_TYPE_NONE:int = 0;//0.无
		public static const EVENT_TYPE_FINISH:int = 1;//1.完成活动
		public static const EVENT_TYPE_KICK:int = 2;//2.踢出活动
		public static const EVENT_TYPE_ADD_MST:int = 3;//3.增加波怪
		public static const EVENT_TYPE_REMOVE_MST:int = 4;//4.移除波怪
		public static const EVENT_TYPE_ADD_BUFF:int = 5;//5.给指定波怪加状态
		public static const EVENT_TYPE_REMOVE_BUFF:int = 6;//6.给指定波怪去状态
		public static const EVENT_TYPE_ADD_TRAP:int = 7;//7.刷出机关
		public static const EVENT_TYPE_REMOVE_TRAP:int = 8;//8.移除机关
		public static const EVENT_TYPE_ADD_PLANT:int = 9;//9.刷出波植物
		public static const EVENT_TYPE_REMOVE_PLANT:int = 10;//10.移除波植物
		public static const EVENT_TYPE_PLAY_MOVIE:int = 11;//11.播放电影
		public static const EVENT_TYPE_PLAY_MOVIE_ANE_TRIGGER:int = 12;//12.播放电影并触发事件
		
		public var activity_id:int;//11	活动id
		public var trigger_id:int;//11	触发id[NL]
		public var map_id:int;//11	地图id
		public var step:int;//11	阶段
		public var step_type:int;
		public var step_param:String;
		public var step_desc:String;//512	阶段描述
		public var target_desc:String;//64	阶段目标
		public var trigger_type:int;//11	触发类型
		public var trigger_param:String;//256	触发参数
		public var event_type:int;//11	事件类型[NL]
		public var delay:int;//11	延迟时间(毫秒)
		public var effect:String;//256	事件相关参数
		public var repeat:int;//11	重复次数
		public var interval:int;//11	时间间隔（毫秒）
		public var map_dialog:int;//11	地图事件飘字
		public var world_dialog:int;//11	世界事件飘字
		
		public function ActivityEventCfgData()
		{
		}
	}
}