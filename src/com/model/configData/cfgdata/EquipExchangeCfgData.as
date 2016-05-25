package com.model.configData.cfgdata
{
	/**
	 * @author wqhk
	 * 2014-8-28
	 */
	public class EquipExchangeCfgData
	{
		public var id:int;//	11	装备id
		public var name:String;
		public var next_id:int;	//11	下一阶装备id
		public var player_reincarn:int;	//11	升阶需要角色转生次数
		public var player_level:int;	//11	升阶需要角色等级
		public var coin:int;	//11	消耗金币（绑定优先）
		public var zhuangyuanshengwang:int;	//11	消耗声望
		public var shendunzhili:int//	11	消耗神盾之力
		public var item:int;	//11	消耗道具id
		public var item_count:int;	//11	消耗道具数量
		public var hero_grade:int;	//11	需要英雄等阶
		public var hero_love:int;	//11	需要英雄爱慕度
		
		public var des:String; //描述
		public var link_tab:int; //11 点击链接 跳转的页面
		public var step:int;  //当前阶段
		public var step_name:String; //阶段名称
		public var current_star:int; //当前星级
	}
}