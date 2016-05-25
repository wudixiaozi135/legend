package com.model.configData.cfgdata
{
	/**
	 * 爵位配置信息类
	 * @author Administrator
	 */	
	public class PeerageCfgData
	{
		public var id:int;//11	序列
		public var name:String;//16	名称
		public var gold:int;//11	价格
		public var remain:int;//11	时间（分钟）
		public var buff:int;//11	状态id
		public var fairyland:int;//11	幻境开启
		public var skill_proficiency:int;//11	技能熟练度(*100)
		public var auto_sign:int;//11	自动签到
		public var vip:int;//11	开启的vip
		public var vip_point:int;//11	vip积分增长
		public var order:int;//11	爵位的高低
		public var attr:String;//32	属性加成
		
		public function PeerageCfgData()
		{
		}
	}
}