package com.model.configData.cfgdata
{
	public class SpecialRingCfgData
	{
		public var id:int;//11	特戒ID
		public var name:String;//16	名称
		public var target1_condition1:int;//11	完成条件
		public var target1_request1:String;//16	完成条件描述
		public var target1_hint1:String;//256	完成条件提示
		public var target1_condition2:int;//11	完成条件
		public var target1_request2:String;//16	完成条件描述
		public var target1_hint2:String;//256	完成条件提示
		public var target2_condition1:int;//11	完成条件
		public var target2_request1:String;//16	完成条件描述
		public var target2_hint1:String;//256	完成条件提示
		public var target2_condition2:int;//11	完成条件
		public var target2_request2:String;//16	完成条件描述
		public var target2_hint2:String;//256	完成条件提示
		public var job:int;//11 职业
		public var attr:String;//11	属性
		public var need_use:int;//11	是否需要使用
		public var double_use:int;//11	是否开启双使用
		public var desc:String;//256	描述
		public var is_ring_only_condition:int;//11	是否只需要此条件
		public var only_request:String;//32	完成条件 格式ringId：level|
		
		public function SpecialRingCfgData()
		{
		}
	}
}