package com.view.gameWindow.common
{
	
	/**
	 * 数据改变 通知界面更新
	 * @author wqhk
	 * 2014-11-26
	 */
	public class ModelEvents
	{
		/** 安全区域  危险区域 的改变*/
		public static const UPDATE_REGION_TYPE:int = -100;
		/** 安全区域  危险区域 的改变 需要通知的情况*/
		public static const UPDATE_REGION_TYPE_NOTICE:int = -101;
		/** 活动地图改变 */
		public static const UPDATE_MAP_ACTIVITY:int = -102;
		/**刷新位置信息*/
		public static const UPDATE_ACTIV_INFO_BY_POSTION:int = -103;
		
		/**
		 * 到达npc
		 */
		public static const NOTICE_REACH_NPC:int = -201;
		
		/**
		 * 英雄出战改变
		 */
		public static const HERO_BATTLE_MODE_CHANGE:int = -301;
		
		public static const HERO_RECYCLE_CHANGE:int = -401;
		
		/**
		 * 显示vip体验面板
		 */
		public static const SHOW_VIP_EXPERIENCE:int = -501;
	}
}