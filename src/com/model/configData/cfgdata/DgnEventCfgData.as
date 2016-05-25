package com.model.configData.cfgdata
{
	
	/**
	 * @author wqhk
	 * 2014-9-6
	 */
	public class DgnEventCfgData
	{
		public var dungeon_id:int;//	11	副本id
		public var trigger_id:int;//	11	触发id
		public var step:int;//	11	阶段
		public var trigger_type:int;//	11	触发类型
		public var trigger_param:String;//	128	触发参数
		public var event_type:int;//	11	事件类型[NL]
		public var delay:int;//	11	延迟时间(毫秒)
		public var effect:String;//	128	事件相关参数
		public var dialog:String;//	128	事件飘字
		public var step_desc:String;//	512	阶段描述
		public var target_desc:String;//	64	阶段描述
		public var repeat:int;
		public var interval:int;
	}
}