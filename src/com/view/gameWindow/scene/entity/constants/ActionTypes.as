package com.view.gameWindow.scene.entity.constants
{
	public class ActionTypes
	{
		public static const NOACTION:int = 0;//无
		public static const IDLE:int = 1;//待机
		public static const RUN:int = 2;//跑步
		public static const HURT:int = 3;//受伤
		public static const DIE:int = 4;//死亡
		public static const PATTACK:int = 5;//物理攻击
		public static const MATTACK:int = 6;//法术攻击
		public static const RUSH_IDLE:int = 7;//冲刺
		public static const RUSH:int = 8;//冲刺待机
		public static const WALK:int = 9;//走
		public static const UNKNOW1:int = 10;//无
		public static const JOINT_ATTACK:int = 11;//合击
		public static const SUNBATHE:int = 12;//日光浴
		public static const FOOTSIE:int = 13;//挑逗
		public static const MASSAGE:int = 14;//按摩
		public static const BE_MASSAGE:int = 15;//被按摩
		public static const UNKNOW2:int = 16;//无
		public static const UNKNOW3:int = 17;//无
		public static const UNKNOW4:int = 18;//无
		public static const UNKNOW5:int = 19;//无
		public static const UNKNOW6:int = 20;//无
		public static const GATHER:int = 21;//采集
		public static const REVEAL:int = 22;//展示
		public static const NACTIONS:int = 22;//无
		
		public static const PATTACK_PREPARE:int = 105;
		public static const MATTACK_END:int = 106;
		public static const MATTACK_PREPARE:int = 107;
		
		public static const MINING:int = 200;
		public static const WATERMELON:int = 201;
		
		public static function getShowActionByCurrentAction(actionId:int):int
		{
			switch (actionId)
			{
				case WATERMELON:
				case MINING:
				case PATTACK_PREPARE:
					return PATTACK;
				case MATTACK_END:
				case MATTACK_PREPARE:
					return MATTACK;
				default:
					return actionId;
			}
		}
	}
}