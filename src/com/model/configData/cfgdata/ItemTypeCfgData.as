package com.model.configData.cfgdata
{
	public class ItemTypeCfgData
	{
		public static const CantUse:int = 0;
		public static const CantBatch:int = 1;
		public static const Single:int = 2;
		public static const Muti:int = 3;
		
		public var id:int;//11	道具类型id
		public var name:String;//16	类型名
		public var type:int;//11	分类
		public var panel:int;//11	打开面板
		public var panel_param:int;//11	面板参数
		public var batch:int;//11	批量使用
		public var batch_default:int;//11	批量默认数量
		public var cd:int;//11	冷却时间
		public var drop:int;//11	死亡是否掉落
		public var prompt:int;//11	新道具提示
		
		public function get canBatch():Boolean
		{
			return batch == Single || batch == Muti;
		}
		
		public function ItemTypeCfgData()
		{
		}
	}
}