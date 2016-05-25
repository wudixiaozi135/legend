package com.model.consts
{
	
	/**
	 * tip类型常量
	 * @author jhj
	 */
	public class ToolTipConst
	{
		public static const NONE_TIP:int = -1;
		/** * 文本  */		
		public static const TEXT_TIP:int = 0;
		/** * 道具  */
		public static const ITEM_BASE_TIP:int = 1;
		/** * 基础装备  */
	    public static const EQUIP_BASE_TIP:int = 2;
		/** * 基础装备比对  */
		public static const COMPLETE_EQUIP_BASE_TIP:int = 3;
		/** * 商店面板装备  */
		public static const SHOP_EQUIP_TIP:int = 4;
		/**时装*/
		public static const FASHION_TIP:int = 5;
		/** * 锻造进度  */		
		public static const FORGE_PROGRESS_TIP:int = 6;
		/** * 商店物品tip  */		
		public static const SHOP_ITEM_TIP:int = 7;
		
		public static const SKILL_TIP:int = 8;
		
		public static const BOSS_TIP:int = 9;
		
		public static const EQUIP_UPGRADE_TIP:int = 10;
		
		public static const EQUIP_BASE_TIP_NO_COMPLETE:int = 11;
		
		public static const LASTING_TIP:int = 12;
		
		public static const JOINT_TIP:int = 13;
		
		public static const EQUIP_BASE_TIP_HERO:int = 14;
		
		public static const HERO_UGRADE_TIP:int = 15;
		/** * 英雄基础装备比对  */
		public static const COMPLETE_HERO_EQUIP_BASE_TIP:int = 16;
		/** * 英雄基础装备不比对  */
		public static const EQUIP_BASE_TIP_NO_COMPLETE_HERO:int = 17;
		/**装备强化额外加成*/
		public static const EQUIP_STRENG_SUITE_TIP:int=18;
		public static const EQUIP_BAPTIZE_SUITE_TIP:int=19;
		public static const EQUIP_REINCAIN_SUITE_TIP:int=20;
		public static const POSITION_SUITE_TIP:int=21;
		
		
		public function ToolTipConst()
		{
			
		}
		
		public static function isHeroTips(type:int):Boolean
		{
			if(type == EQUIP_BASE_TIP_HERO || type == HERO_UGRADE_TIP || type == COMPLETE_HERO_EQUIP_BASE_TIP || type == EQUIP_BASE_TIP_NO_COMPLETE_HERO)
			{
				return true;
			}
			return false;
		}
	}
}