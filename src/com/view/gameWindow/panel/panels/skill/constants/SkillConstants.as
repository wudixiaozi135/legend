package com.view.gameWindow.panel.panels.skill.constants
{
	/**
	 * 技能类型常量类
	 * @author Administrator
	 */	
	public class SkillConstants
	{
		/**主动技能*/
		public static const ZD:int = 1;
		/**被动技能*/
		public static const BD:int = 2;
		/**触发技能*/
		public static const CF:int = 3;
		/**合击技能*/
		public static const HJ:int = 4;
		
		//界面技能分类
		/**玩家*/
		public static const TYPE_ROLE:int = 1;
		/**英雄*/
		public static const TYPE_HERO:int = 2;
		/**合击*/
		public static const TYPE_COMBINED:int = 3;
		/**内技*/
		public static const TYPE_WITHIN:int = 4;
		
		
		public static const ACTION_TYPE_PATTACK:int = 1;
		public static const ACTION_TYPE_MATTACK:int = 2;
		public static const ACTION_TYPE_JOINT:int = 3;
		
		public static const SKILL_TARGET_TYPE_TARGET:int = 1;
		public static const SKILL_TARGET_TYPE_GROUND:int = 2;
		public static const SKILL_TARGET_TYPE_SHIFT:int = 3;
		
		public static const RANGE_SELF:int = 1;//range 自己
		public static const RANGE_SINGLE:int = 2;//range  单个
		public static const RANGE_LINE:int = 3;//range 直线
		
		/**special 召唤宝宝*/
		public static const SPECIAL_SUMMON:int = 1;
		/**special 召唤机关（火墙）*/
		public static const SPECIAL_TRAP:int = 2;
		/**special 野蛮冲撞*/
		public static const SPECIAL_KNOCK:int = 3;
		
		/**beneficial 伤害*/
		public static const BENEFICIAL_FALSE:int = 0;
		/**beneficial 治疗 等 增益*/
		public static const BENEFICIAL_TRUE:int = 1;
		
		public static const COMMON_ATTACK_ZS:int = 1001;
		public static const COMMON_ATTACK_FS:int = 2001;
		public static const COMMON_ATTACK_DS:int = 3001;
		
		/**刺杀剑术组id*/
		public static const ZS_CSJS:int = 1011;
		/**半月弯刀组id*/
		public static const ZS_BYWD:int = 1041;
		
		public static const CENTER_SELF:int = 1;
		public static const CENTER_TARGET:int = 2;
		public static const CENTER_MOUSE:int = 3;
		
		public static const VIEW_TYPE_PLAYER:int = 1;
		public static const VIEW_TYPE_HERO:int = 2;
		public static const VIEW_TYPE_JOINT:int = 3;
		
	}
}