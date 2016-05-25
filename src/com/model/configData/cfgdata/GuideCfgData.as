package com.model.configData.cfgdata
{
	
	/**
	 * @author wqhk
	 * 2014-10-21
	 */
	public class GuideCfgData
	{
		public var id:int;
		
		public var name:String; 
		public var cond_type:int; //触发类型
		public var cond_param:String;
		
		public var action_type:int; //ActionType
		public var target_panel:String;
		public var target_tab:int;
		public var action_param:String;
		
		public var hit_area_type:int;//1rect 2circle
		public var hit_area:String;  //x:y:width:height
		
		public var arrow_rotation:int; //0 不显示 1 上  2下  3左  4右
		public var hit_area_show:int; //0显示 1不显示
		public var auto_task_state:int;//0不停止 1停止自动任务
		
		public var stop_dura:int;//state 持续时间
		public var effect_url:String;
		public var effect_x:int;
		public var effect_y:int;
		public var disappear_time:int;
	}
}