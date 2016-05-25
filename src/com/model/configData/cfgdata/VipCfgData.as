package com.model.configData.cfgdata
{
	import com.model.consts.StringConst;

	/**
	 * vip等级配置信息类
	 * @author Administrator
	 */	
	public class VipCfgData
	{
		public static const PRIVILEGE_1:int = 0;
		public static const PRIVILEGE_2:int = 1;
//		public static const PRIVILEGE_3:int = 2;
		public static const PRIVILEGE_4:int = 2;
		public static const PRIVILEGE_5:int = 3;
		public static const PRIVILEGE_6:int = 4;
//		public static const PRIVILEGE_7:int = 6;
		public static const PRIVILEGE_9:int = 5;
		public static const PRIVILEGE_10:int =6;
		public static const PRIVILEGE_11:int = 7;
		public static const PRIVILEGE_12:int = 8;
		public static const PRIVILEGE_13:int = 9;
		public static const PRIVILEGE_14:int = 10;
		public static const PRIVILEGE_15:int = 11;
		public static const PRIVILEGE_16:int = 12;
		public static const PRIVILEGE_17:int = 13;
		public static const PRIVILEGE_18:int = 14;
		public static const PRIVILEGE_19:int = 15;
		public static const PRIVILEGE_20:int = 16;
//		public static const PRIVILEGE_21:int = 19;
		public static const PRIVILEGE_22:int = 17;
		
		public static function getVarName(id:int):String
		{
			var name:String;
			switch(id)
			{
				case PRIVILEGE_1:
					name = "add_sign_num";
					break;
				case PRIVILEGE_2:
					name = "auto_sell_strongstone";
					break;
//				case PRIVILEGE_3:
//					name = "vip_boss";
//					break;
				case PRIVILEGE_4:
					name = "unlock_bag_slot";
					break;
				case PRIVILEGE_5:
					name = "add_store_page";
					break;
				case PRIVILEGE_6:
					name = "recycle_btn";
					break;
//				case PRIVILEGE_7:
//					name = "unlock_classic_boss";
//					break;
				case PRIVILEGE_9:
					name = "exp_addon";
					break;
				case PRIVILEGE_10:
					name = "gift_owner_change";
					break;
				case PRIVILEGE_11:
					name = "strongthen_rate";
					break;
				case PRIVILEGE_12:
					name = "add_exp_yu";
					break;
				case PRIVILEGE_13:
					name="add_use_exp_yu_a";
					break;
				case PRIVILEGE_14:
					name="add_task_wanted_num";
					break;
				case PRIVILEGE_15:
					name="add_pray_count";
					break;
				case PRIVILEGE_16:
					name="add_fengmo_rate";
					break;
				case PRIVILEGE_17:
					name="add_ring_dungeon_rate";
					break;
				case PRIVILEGE_18:
					name="dungeon_card_num";
					break;
				case PRIVILEGE_19:
					name="sea_side_exp_addon";
					break;
				case PRIVILEGE_20:
					name="add_hero_grade_rate";
					break;
//				case PRIVILEGE_21:
//					name="add_task_star_num";
//					break;
				case PRIVILEGE_22:
					name="add_use_exp_yu_b";
					break;
				default:
					name = "";
					break;
			}
			return name;
		}
		
		public static function getVarStrName(id:int):String
		{
			var name:String;
			switch(id)
			{
				case PRIVILEGE_1:
					name = StringConst.VIP_PANEL_0014;
					break;
				case PRIVILEGE_2:
					name = StringConst.VIP_PANEL_0015;
					break;
//				case PRIVILEGE_3:
//					name = StringConst.VIP_PANEL_0016;
//					break;
				case PRIVILEGE_4:
					name = StringConst.VIP_PANEL_0017;
					break;
				case PRIVILEGE_5:
					name = StringConst.VIP_PANEL_0018;
					break;
				case PRIVILEGE_6:
					name = StringConst.VIP_PANEL_0019;
					break;
//				case PRIVILEGE_7:
//					name = StringConst.VIP_PANEL_0020;
//					break;
				case PRIVILEGE_9:
					name = StringConst.VIP_PANEL_0022;
					break;
				case PRIVILEGE_10:
					name = StringConst.VIP_PANEL_0023;
					break;
				case PRIVILEGE_11:
					name = StringConst.VIP_PANEL_0024;
					break;
				case PRIVILEGE_12:
					name = StringConst.VIP_PANEL_0025;
					break;
				case PRIVILEGE_13:
					name = StringConst.VIP_PANEL_0026;
					break;
				case PRIVILEGE_14:
					name = StringConst.VIP_PANEL_0027;
					break;
				case PRIVILEGE_15:
					name = StringConst.VIP_PANEL_0028;
					break;
				case PRIVILEGE_16:
					name = StringConst.VIP_PANEL_0029;
					break;
				case PRIVILEGE_17:
					name = StringConst.VIP_PANEL_0030;
					break;
				case PRIVILEGE_18:
					name = StringConst.VIP_PANEL_0031;
					break;
				case PRIVILEGE_19:
					name = StringConst.VIP_PANEL_0032;
					break;
				case PRIVILEGE_20:
					name = StringConst.VIP_PANEL_0033;
					break;
//				case PRIVILEGE_21:
//					name = StringConst.VIP_PANEL_0043;
//					break;
				default:
					name = "";
					break;
			}
			return name;
		}
		
		public var level:int;//11	序列
		public var order:int;//11	vip的高低
		public var point:int;//11	vip积分
		public var exp_addon:int;//11	经验加成(*100)
		public var gift:String;//64	礼包
		public var bind_gold_recycle:int;//11	回收绑定元宝加成(*100)
		public var recycle_btn:int;//11	回收功能快捷开启
		public var unlock_bag_slot:int;//11	开启包裹格子
		public var email:String;//64	时间到达发送邮件
		public var unlock_classic_boss:int;//11	开启经典BOSS传送
		public var unlock_world_boss:int;//11	开启世界BOSS传送
		public var add_exp_yu:int;//11	经验玉储存速度加成(百分比)
		public var add_use_exp_yu_a:int;//11  经验玉a使用次数
		public var add_use_exp_yu_b:int;//11  经验玉b使用次数
		public var strongthen_rate:int;//11	强化成功率加成
		public var add_store_page:int;//11开启仓库页数类型
		public var add_pray_count:int;
		public var sea_side_exp_addon:int;
		public var add_sign_num:int;	//11	补签次数
		public var add_hero_grade_rate:int;	//11	英雄升阶激活成功率增加（百分比）
		public var add_task_star_num:int; //11增加星级任务次数

		public var add_task_wanted_num:int;//增加悬赏任务次数
		public var add_task_trailer_num:int;//增加拉镖任务次数
		public var add_ring_dungeon_rate:int;//增加特戒副本倍率
		public var add_fengmo_rate:int;//增加封魔谷倍率
		public var gift_owner_change:int;//专属成就奖励
		public var auto_sell_strongstone:int;//自动出售非强化石
		public var vip_boss:int;//VIP专属boss个数
		public var buff_id:int;//buff效果
		public var dungeon_card_num:int;//翻牌次数
		public var	add_refresh_num:int;//增加兑换商店额外刷新次数

		public function VipCfgData()
		{
		}
	}
}