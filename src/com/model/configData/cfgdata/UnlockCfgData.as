package com.model.configData.cfgdata
{
	
	/**
	 * @author wqhk
	 * 2014-10-29
	 */
	public class UnlockCfgData
	{
		public var id:int;
		public var name:String;
		
		public var task_id:int;
		public var task_state:int;
		public var lv:int;
		
		public var lock_state:int; //0 解锁 1不解锁
		public var func_id:int; //解锁的功能
		
		public var panel_id:int;//0 不弹出 1解锁面板 2功能开启目标面板
		public var panel_txt:String;//描述文字
		public var panel_icon:String;//url
		
		public var equip_type:int;//装备类型 鞋子 头等等
	}
}