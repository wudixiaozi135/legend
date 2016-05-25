package com.model.configData.cfgdata
{
	public class TaskWantCfgData
	{
		public var task_id:int;  //任务id(来自任务表)
		public var level:int;	//等级
		public var max_level:int;	//最大等级
		public var bind_gold:int;	//绑定元宝需求
		public var unbind_gold:int; //元宝需求
		public var vip:int;	 //vip需求
		public var exp:int;	 //经验奖励
		public var bind_coin:int;	//奖励绑定金币
		public var reward_point:int;	//积分奖励
		public var gongxun_point:int;
		
		public function TaskWantCfgData()
		{
		}
	}
}