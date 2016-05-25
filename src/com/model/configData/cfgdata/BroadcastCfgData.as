package com.model.configData.cfgdata
{
	public class BroadcastCfgData
	{
		public function BroadcastCfgData()
		{
		}
		
		public var id:int	//11	序列
		public var name:String//	char	30	名称
		public var text:String//	char	512	公告描述
		public var link_type:int//	11	链接类型
		public var link_text:String//	char	16	链接名字
		public var link_content:String//	char	16	链接面板
		public var begin_day:int	//11	起始日期
		public var end_day:int//	11	结束日期
		public var start_time:int//	int	11	开始时间(分钟)
		public var duration:int//int	11	持续时间(分钟)
		public var duration_show:int//	int	11	持续显示时间(秒)
		public var interval:int//	int	11	间隔时间(分钟)
		public var npc_id:int
	}
}