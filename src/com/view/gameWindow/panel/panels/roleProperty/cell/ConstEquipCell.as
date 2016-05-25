package com.view.gameWindow.panel.panels.roleProperty.cell
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;

    public class ConstEquipCell
	{
		public static const TYPE_WUQI:int = 1;
		public static const TYPE_TOUKUI:int = 2;
		public static const TYPE_XIANGLIAN:int = 3;
		public static const TYPE_YIFU:int = 4;
		public static const TYPE_SHOUZHUO:int = 5;
		public static const TYPE_JIEZHI:int = 6;
		public static const TYPE_YAODAI:int = 7;
		public static const TYPE_XIEZI:int = 8;
		public static const TYPE_XUNZHANG:int = 9;
		public static const TYPE_HUOLONGZHIXIN:int = 10;
		public static const TYPE_HUANJIE:int = 11;
		public static const TYPE_DUNPAI:int = 12;
        public static const TYPE_CHIBANG:int = 13;
        public static const TYPE_SHIZHUANG:int = 21;
        public static const TYPE_DOULI:int = 22;
        public static const TYPE_ZUJI:int = 23;
        public static const TYPE_HUANWU:int = 24;
        public static const TYPE_HERO_SHIZHUANG:int = 31;
		public static const TYPE_TOTAL:int = 17;
		//角色格子常量
		public static const CP_WUQI:int = 0;
		public static const CP_TOUKUI:int = 1;
		public static const CP_XIANGLIAN:int = 2;
		public static const CP_YIFU:int = 3;
		public static const CP_SHOUZHUO_LEFT:int = 4;
		public static const CP_SHOUZHUO_RIGHT:int = 5;
		public static const CP_JIEZHI_LEFT:int = 6;
		public static const CP_JIEZHI_RIGHT:int = 7;
		public static const CP_YAODAI:int = 8;
		public static const CP_XIEZI:int = 9;
		public static const CP_XUNZHANG:int = 10;
		public static const CP_HUOLONGZHIXIN:int = 11;
		public static const CP_HUANJIE:int = 12;
		public static const CP_DUNPAI:int = 13;
        public static const CP_CHIBANG:int = 14;
        public static const CP_TOTAL:int = 15;
		//英雄格子常量
		public static const HP_WUQI:int = 0;
		public static const HP_TOUKUI:int = 1;
		public static const HP_XIANGLIAN:int = 2;
		public static const HP_YIFU:int = 3;
		public static const HP_SHOUZHUO_LEFT:int = 4;
		public static const HP_SHOUZHUO_RIGHT:int = 5;
		public static const HP_JIEZHI_LEFT:int = 6;
		public static const HP_JIEZHI_RIGHT:int = 7;
		public static const HP_YAODAI:int = 8;
		public static const HP_XIEZI:int = 9;
		public static const HP_XUNZHANG:int = 10;
		public static const HP_HUANJIE:int = 11;
		public static const HP_TOTAL:int = 12;
		
		/**
		 * 获取装备名 
		 * @param type
		 * @return 
		 */		
		public static function getEquipName(type:int):String
		{
			var equipName:String = "";
			
			switch(type)
			{
				case TYPE_WUQI:
					 equipName = StringConst.EQUIP_TYPE_WEAPON;
					 break;
				case TYPE_TOUKUI:
				     equipName = StringConst.EQUIP_TYPE_HELMET;
					 break;
				case TYPE_XIANGLIAN:
					 equipName = StringConst.EQUIP_TYPE_NECKLACE;
					 break;
				case TYPE_YIFU:
					 equipName = StringConst.EQUIP_TYPE_CLOTH;
					 break;
				case TYPE_SHOUZHUO:
					 equipName = StringConst.EQUIP_TYPE_BRACELET;
					 break;
				case TYPE_JIEZHI:
					 equipName = StringConst.EQUIP_TYPE_RING;
					 break;
				case TYPE_YAODAI:
					 equipName = StringConst.EQUIP_TYPE_BELT;
					 break;
				case TYPE_XIEZI:
					 equipName = StringConst.EQUIP_TYPE_SHOES;
					 break;
				case TYPE_XUNZHANG:
					 equipName = StringConst.EQUIP_TYPE_MEDAL;
					 break;
				case TYPE_HUOLONGZHIXIN:
				     equipName = StringConst.EQUIP_TYPE_DRAGON_HEART;
					 break;
				case TYPE_HUANJIE:
					 equipName = StringConst.EQUIP_TYPE_MAGIC_RING;
					 break;
				case TYPE_DUNPAI:
					 equipName = StringConst.EQUIP_TYPE_SHIELD;
					 break;
				case TYPE_DOULI:
					 equipName = StringConst.EQUIP_TYPE_BAMBOO_HAT;
					 break;
				case TYPE_SHIZHUANG:
					 equipName = StringConst.EQUIP_TYPE_FASHION;
					 break;
				case TYPE_CHIBANG:
					 equipName = StringConst.EQUIP_TYPE_WING;
					 break;
				case TYPE_ZUJI:
					 equipName = StringConst.EQUIP_TYPE_FOOT_PRINT;
					 break;
				case TYPE_HUANWU:
					 equipName = StringConst.EQUIP_TYPE_HUANWU;
					 break;
				default:
				     break;
			}
			
			return equipName;
		}
		
		public static function getRoleEquipSlot(type:int):int
		{
			var slot:int;
			switch(type)
			{
				case TYPE_WUQI:
					slot = CP_WUQI;
					break;
				case TYPE_TOUKUI:
					slot = CP_TOUKUI;
					break;
				case TYPE_XIANGLIAN:
					slot = CP_XIANGLIAN;
					break;
				case TYPE_YIFU:
					slot = CP_YIFU;
					break;
				case TYPE_SHOUZHUO:
					slot = getRoleLRSlot(CP_SHOUZHUO_LEFT,CP_SHOUZHUO_RIGHT);
					break;
				case TYPE_JIEZHI:
					slot = getRoleLRSlot(CP_JIEZHI_LEFT,CP_JIEZHI_RIGHT);
					break;
				case TYPE_YAODAI:
					slot = CP_YAODAI;
					break;
				case TYPE_XIEZI:
					slot = CP_XIEZI;
					break;
				case TYPE_XUNZHANG:
					slot = CP_XUNZHANG;
					break;
				case TYPE_HUOLONGZHIXIN:
					slot = CP_HUOLONGZHIXIN;
					break;
				case TYPE_HUANJIE:
					slot = CP_HUANJIE;
					break;
				case TYPE_DUNPAI:
					slot = CP_DUNPAI;
					break;
				case TYPE_DOULI:
					slot = -1;
					break;
				case TYPE_SHIZHUANG:
					slot = -1;
					break;
				case TYPE_CHIBANG:
                    slot = CP_CHIBANG;
					break;
				case TYPE_ZUJI:
					slot = -1;
					break;
				case TYPE_HUANWU:
					slot = -1;
					break;
				default:
					break;
			}
			return slot;
		}
		
		public static function getHeroEquipSlot(type:int):int
		{
			var slot:int;
			switch(type)
			{
				case TYPE_WUQI:
					slot = HP_WUQI;
					break;
				case TYPE_TOUKUI:
					slot = HP_TOUKUI;
					break;
				case TYPE_XIANGLIAN:
					slot = HP_XIANGLIAN;
					break;
				case TYPE_YIFU:
					slot = HP_YIFU;
					break;
				case TYPE_SHOUZHUO:
					slot = getHeroLRSlot(HP_SHOUZHUO_LEFT,HP_SHOUZHUO_RIGHT);
					break;
				case TYPE_JIEZHI:
					slot = getHeroLRSlot(HP_JIEZHI_LEFT,HP_JIEZHI_RIGHT);
					break;
				case TYPE_YAODAI:
					slot = HP_YAODAI;
					break;
				case TYPE_XIEZI:
					slot = HP_XIEZI;
					break;
				case TYPE_XUNZHANG:
					slot = HP_XUNZHANG;
					break;
				case TYPE_HUANJIE:
					slot = HP_HUANJIE;
					break;
				case TYPE_DOULI:
					slot = -1;
					break;
				case TYPE_SHIZHUANG:
					slot = -1;
					break;
				case TYPE_CHIBANG:
					slot = -1;
					break;
				case TYPE_ZUJI:
					slot = -1;
					break;
				case TYPE_HUANWU:
					slot = -1;
					break;
				default:
					break;
			}
			return slot;
		}
		/**
		 * 从左右格子中取出战斗力最小的格子，左侧优先
		 * @param slotL
		 * @param slotR
		 * @return 
		 */		
		private static function getRoleLRSlot(slotL:int,slotR:int):int
		{
			var powerL:Number = RoleDataManager.instance.getEquipPower(slotL);
			if(powerL <= 0)
			{
				return slotL;
			}
			var powerR:Number = RoleDataManager.instance.getEquipPower(slotR);
			if(powerR <= 0)
			{
				return slotR;
			}
			if(powerL <= powerR)
			{
				return slotL;
			}
			else
			{
				return slotR;
			}
		}
		
		/**
		 * 从左右格子中取出战斗力最小的格子，左侧优先
		 * @param slotL
		 * @param slotR
		 * @return 
		 */		
		private static function getHeroLRSlot(slotL:int,slotR:int):int
		{
			var powerL:Number = HeroDataManager.instance.getEquipPower(slotL);
			if(powerL <= 0)
			{
				return slotL;
			}
			var powerR:Number = HeroDataManager.instance.getEquipPower(slotR);
			if(powerR <= 0)
			{
				return slotR;
			}
			if(powerL <= powerR)
			{
				return slotL;
			}
			else
			{
				return slotR;
			}
		}
		
		public function ConstEquipCell()
		{
			
		}
	}
}