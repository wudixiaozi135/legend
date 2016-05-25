package com.model.configData.cfgdata
{
	
	/**
	 * @author wqhk
	 * 2014-9-13
	 */
	public class BuffCfgData
	{
		public var id:int;	//11	序列
		public var name:String;	//12	名称
		public var desc:String;	//32	描述
		public var group:int;	//11	组id
		public var priority:int;	//11	组内优先级
		public var cover_type:int;	//11	叠加方式1:优先级覆盖2:效果不变时间延长3:效果不变时间覆盖4:同时存在
		public var save_type:int;	//11	保存方式1:下线清空2:下线计时3:下线不计时
		public var maintain_save:int;	//11	停服保存方式1:保存0:不保存
		public var interval:int;	//11	间隔时间
		public var attr_type_1:int;	//11	属性类型
		public var attr_addon_1:int;	//11	属性值
		public var attr_ratio_1:int;	//11	属性百分比
		public var attr_type_2:int;	//11	属性类型
		public var attr_addon_2:int;	//11	属性值
		public var attr_ratio_2:int;	//11	属性百分比
		public var attr_type_3:int;	//11	属性类型
		public var attr_addon_3:int;	//11	属性值
		public var attr_ratio_3:int;	//11	属性百分比
		public var attr_type_4:int;	//11	属性类型
		public var attr_addon_4:int;	//11	属性值
		public var attr_ratio_4:int;	//11	属性百分比
		public var attr_type_5:int;	//11	属性类型
		public var attr_addon_5:int;	//11	属性值
		public var attr_ratio_5:int;	//11	属性百分比
		public var attr_type_6:int;	//11	属性类型
		public var attr_addon_6:int;	//11	属性值
		public var attr_ratio_6:int;	//11	属性百分比
		public var hp_launcher_rate:int;
		public var special:int;	//11	特殊效果
		public var special_param:int;
		public var special_time_param:int;
		public var special_ratio_param:int;
		public var special_cd_param:int;
		public var broadcast:int;	//11	是否广播
		public var order:int;	//11	顺序(从小到大，但是0排在最后)
		public var icon:String;	//16	图标
		public var top_effect:String;	//32	特效
		public var top_effect_hit:String;	//32	被击特效
		public var bottom_effect:String;	//32	特效
		public var filter:int;
		public var buff_state:int;
		public var show:int;//主角是否显示该buff

	}
}