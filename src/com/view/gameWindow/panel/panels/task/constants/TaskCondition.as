package com.view.gameWindow.panel.panels.task.constants
{
	import com.model.consts.StringConst;
	

	public class TaskCondition
	{
		public static const TC_RECEIVE:int = 1;//直接对话
		public static const TC_ITEM:int = 2;//需求物品
		public static const TC_COST_ITEM:int = 3;//消耗物品
		public static const TC_MONSTER_GROUP:int = 4;//杀死特定怪物组
		public static const TC_MONSTER_LEVEL:int = 5;//杀死等级怪物
		public static const TC_PLAYER_LEVEL:int = 6;//玩家等级
		public static const TC_MONSTER_RANDOM:int = 7;//怪物组有概率计数
		public static const TC_PROTECT_CLIENT:int = 12;//押镖
		public static const TC_PLANT_ID:int = 13;//采集
		public static const TC_DUNGEON:int = 14;//通关副本
		public static const TC_MINING:int = 15;//采矿
		public static const TC_DIG:int = 16;//挖掘
		public static const TC_STAR_TASK:int = 17;//星级任务
		public static const TC_ENTER_DUNGEON:int = 18;//进入副本完成任务
		public static const TC_REWARD_TASK:int = 19;//悬赏任务
		public static const TC_EQUIP_RECYCLE:int = 20;//装备回收
		public static const TC_SPECIAL_LEVEL:int = 21; //特戒等级
		public static const TC_VIP_LEVEL:int=22;  //VIP等级
		public static const TC_COUNT_GOLD:int=23; //累计充值元宝
		public static const TC_LOGIN_DAY:int=24;  //登录天数
		public static const TC_TASK_COMPLE:int=25; //任务完成
		public static const TC_EQUIP_WEAR:int = 33;//穿上装备 
		public static const TC_EQUIP_WEAR_HERO:int = 34;//英雄穿上装备 
		public static const TC_KILL_PLAYER:int = 35;//击杀玩家
		public static const TC_EQUIP_GET:int = 36;//获得装备
		public static const TC_PLAYER_STRENGTHEN:int = 37;//人物装备强化
		public static const TC_HERO_STRENGTHEN:int = 38;//英雄装备强化
		public static const TC_HERO_LEVEL:int = 39;//英雄等级
		public static const TC_NO_COMPLE:int=100; //无法满足
		
		public static function getDes(cond:int):String
		{
			var des:String = "";
			switch(cond)
			{
				case TC_RECEIVE:
					des = StringConst.TIP_TASK_PREFIX_0;
					break;
				case TC_MONSTER_GROUP:
					des = StringConst.TIP_TASK_PREFIX_1;
					break;
				case TC_PLAYER_LEVEL:
				case TC_HERO_LEVEL:
					des = StringConst.TIP_TASK_PREFIX_12;
					break;
				case TC_MONSTER_RANDOM:
					des = StringConst.TIP_TASK_PREFIX_2;
					break;
				case TC_PLANT_ID:
					des = StringConst.TIP_TASK_PREFIX_3;
					break;
				case TC_DUNGEON:
					des = StringConst.TIP_TASK_PREFIX_4;
					break;
				case TC_MINING:
					des = StringConst.TIP_TASK_PREFIX_5;
					break;
				case TC_DIG:
					des = StringConst.TIP_TASK_PREFIX_6;
					break;
				case TC_STAR_TASK:
					des = StringConst.TIP_TASK_PREFIX_7;
					break;
				case TC_ENTER_DUNGEON:
					des = StringConst.TIP_TASK_PREFIX_8;
					break;
				case TC_REWARD_TASK:
					des = StringConst.TIP_TASK_PREFIX_9;
					break;
				case TC_EQUIP_RECYCLE:
					des = StringConst.TIP_TASK_PREFIX_10;
					break;
				case TC_EQUIP_WEAR:
				case TC_EQUIP_WEAR_HERO:
				case TC_EQUIP_GET:
					des = StringConst.TIP_TASK_PREFIX_13;
					break;
				case TC_KILL_PLAYER:
					des = StringConst.TIP_TASK_PREFIX_14;
					break;
				case TC_HERO_STRENGTHEN:
				case TC_PLAYER_STRENGTHEN:
					des = StringConst.TIP_TASK_PREFIX_15;
					break;
			}
			
			return des;
		}
		
	}
}