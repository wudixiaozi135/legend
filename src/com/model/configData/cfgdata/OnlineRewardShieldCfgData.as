package com.model.configData.cfgdata
{
	public class OnlineRewardShieldCfgData
	{
		public var id:int;//序列
		public var index:int;//顺序
		/**
		 * 在线总时间(秒)
		 */
        public var level:int;//解锁等级
        public var reincarn:int;//转生等级
        public var gift_reward:String;//礼包
		public var bind:int;//绑定类型
        public var isuse:int;//是否激活
        public var icon:String;//图标名称
        public var big_icon:String;
        //// 废弃字段
        public var seconds:int;
        public var shield:int;
        public var open_lv:int;

        public function OnlineRewardShieldCfgData()
		{
			
		}
	}
}