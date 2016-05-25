package com.model.consts
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.QualityCfgData;

    public class ItemType
	{
		//道具id常量
		public static const IT_EXP : int = 1;
		public static const IT_MONEY : int = 2;
		public static const IT_MONEY_BIND : int = 3;
		public static const IT_GOLD : int = 4;
		public static const IT_GOLD_BIND : int = 5;
		/**声望*/
		public static const IT_REPUTE : int = 6;
		public static const IT_NEIGONG : int = 7;
		
		public static const IT_SP : int = 8;//内力值
		public static const IT_ANIMA : int = 9;//灵气值
		public static const IT_SAVVY : int = 10;//悟性值
		public static const IT_ENERGY : int = 11;//活力值
		public static const IT_LOVE : int = 12;//爱慕值
		public static const IT_SUICIDE : int = 13;//转生值
		public static const IT_MP : int = 14;//技力值
		public static const IT_SOUL : int = 15;//灵魂值
		public static const IT_CONTRIBUTE : int = 16;//帮会贡献值
		public static const IT_EXPLOIT : int = 17;//功勋
		
		//强化石
		public static const IT_101:int = 101;
		public static const IT_102:int = 102;
		public static const IT_103:int = 103;
		public static const IT_104:int = 104;

        //金刚石（装备石）
        public static const IT_111:int = 111;//40级装备石
        public static const IT_112:int = 112;//50级装备石
        public static const IT_113:int = 113;//60级装备石
        public static const IT_114:int = 114;//70级装备石
        public static const IT_115:int = 115;//80级装备石
        public static const IT_116:int = 116;//90级装备石


		public static const IT_EXP2 : int = 201;
		public static const IT_MONEY2 : int = 202;
		public static const IT_MONEY_BIND2 : int = 203;
		public static const IT_GOLD2 : int = 204;
		public static const IT_GOLD_BIND2 : int = 205;
		/**声望*/
        public static const IT_REPUTE2:int = 206;//火龙之力类型
		public static const IT_NEIGONG2 : int = 207;

        public static const IT_SHIELD:int = 207;//神盾

		public static const IT_SP2 : int = 208;//内力值
		public static const IT_ANIMA2 : int = 209;//灵气值
		public static const IT_SAVVY2 : int = 210;//悟性值
		public static const IT_ENERGY2 : int = 211;//活力值
		public static const IT_LOVE2 : int = 212;//爱慕值
		public static const IT_SUICIDE2 : int = 213;//转生值
		public static const IT_MP2 : int = 214;//技力值
		public static const IT_SOUL2 : int = 215;//灵魂值
		public static const IT_CONTRIBUTE2 : int = 216;//帮会贡献值
		public static const IT_EXP_DRAG : int = 250;//经验丹（限制次数）
		public static const IT_HERO_EXP:int = 251;//英雄经验丹
		public static const IT_LOONG_POWER:int = 252;//火龙之力（限制次数）
		public static const IT_TREASURE_MAP:int = 311;//寻宝图
		
		public static const IT_REDUCE_PK : int = 423;//减红药水
		public static const IT_GIFT : int = 801;//礼包
		public static const IT_GIFT_RANDOM : int = 802;//随机礼包
		public static const IT_GIFT_FAMILY:int = 804;//帮会礼包
        public static const IT_GIFT_NEED_COST:int = 806;//付费礼包
        public static const IT_GIFT_NEED_VIP:int = 807;//vip等级礼包

		public static const IT_GUARD_THUNDER : int = 4201;//雷电守卫令牌
		public static const IT_GUARD_FIRE : int = 4202;//炎爆守卫令牌
		public static const IT_GUARD_ICE : int = 4203;//冰陨守卫令牌
		public static const IT_GUARD_POSION : int = 4204;//释毒守卫令牌
		
		//矿石
		public static const IT_5001:int = 5001;
		public static const IT_5002:int = 5002;
		public static const IT_5003:int = 5003;
		public static const IT_5004:int = 5004;
		public static const IT_5005:int = 5005;

		//道具类型常量
		public static const STRENGTHEN_STONE:int = 101;
		public static const PROTECTED_STONE:int = 103;
		public static const JUMP_STRENGTHEN_STONE:int = 102;
		public static const SPECIAL_RING_PIECES:int = 136;
		public static const SKILL_BOOK:int = 901;
		public static const HERO_SKILL_BOOK:int = 902;
		public static const BUFFER_DRUG:int = 301;
		public static const INTERVAL_HP_DRUG:int = 321;
		public static const INTERVAL_MP_DRUG:int = 322;
		public static const NSTANTANEOUS_HP_DRUG:int = 323;
		public static const NSTANTANEOUS_MP_DRUG:int = 324;
		public static const NSTANTANEOUS_HP_AND_MP_DRUG:int = 325;
		public static const BLOOD_STONE:int = 331;
		public static const BLOOD_MAGIC_STONE:int = 332;
		public static const BLESS_OIL:int = 341;
		public static const SUPER_BLESS_OIL:int = 342;
		public static const IT_BATTLE_YOU:int = 346;  //战神游
		public static const HEJI_ANGRY_DRUG:int = 351;//合击怒气丹
		public static const SMALL_FLY_SHOES:int = 433;
		public static const CLOSET_LV_UP:int = 439;
		public static const TASK_ITEM:int = 701;
		public static const MINE:int = 601;
		public static const GIFT:int = 801;
		public static const RANDOM_GIFT:int = 802;
		public static const CHESTS:int = 803;
		public static const EXP_STONE_A:int = 400;
		public static const EXP_STONE:int = 401;
		public static const IT_RUNE:int=146;
		public static const SHENYU:int=138;
		/**优惠券类型*/
		public static const IT_COUPON:int = 443;
		public static const LOUD_SPEAK:int = 436;//喇叭

		//复活玫瑰类型
		public static const REVIVE_ROSE_TYPE:int=424;
		public static const REVIVE_ROSE_ID:int=3121;
		
		//item_type
		public static const ITEM_TYPE_OTHER:int = 0;
		public static const ITEM_TYPE_DRUG:int = 1;
		public static const ITEM_TYPE_MATERIAL:int = 2;
		public static const ITEM_TYPE_COIN:int = 3;
		public static const ITEM_TYPE_MALL:int = 4;
		public static const QUALITY_WHITE:int = 1;
		public static const QUALITY_GREEN:int = 2;
		public static const QUALITY_BLUE:int = 3;
		public static const QUALITY_PURPLE:int = 4;
		public static const QUALITY_RED:int = 5;
		public static const QUALITY_ORANGE:int = 6;
		public static const QUALITY_WINE:int = 7;
		public static const QUALITY_GOLDEN:int = 8;

		public static const NTUT_ALL:int = 0;
		public static const NTUT_VIP :int = 1;
		public static const NTUT_ITEM:int = 2;
		public static const NTUT_COIN:int = 3;
		public static const NTUT_BINDGOLD:int = 4;
		public static const NTUT_UNGOLD:int = 5;

        //每日充值奖励Id
        public static const GOD_RING_ID:int = 147;
        public static const BLESS_OIL_ID:int = 2581;
        public static const DIAMOND_ID:int = 125;

		public static function itemName(type:int):String
		{
			var itemName:String = "";
			switch (type)
			{
				case STRENGTHEN_STONE:
					itemName = StringConst.STRENGTHEN_STONE;
					break;
				case PROTECTED_STONE:
					itemName = StringConst.PROTECTED_STONE;
					break;
				case SKILL_BOOK:
					itemName = StringConst.SKILL_BOOK;
					break;
				case HERO_SKILL_BOOK:
					itemName = StringConst.HERO_SKILL_BOOK;
					break;
				case BUFFER_DRUG:
					itemName = StringConst.BUFFER_DRUG;
					break;
				case INTERVAL_HP_DRUG:
					itemName = StringConst.INTERVAL_HP_DRUG;
					break;
				case INTERVAL_MP_DRUG:
					itemName = StringConst.INTERVAL_MP_DRUG;
					break;
				case NSTANTANEOUS_HP_DRUG:
					itemName = StringConst.NSTANTANEOUS_HP_DRUG;
					break;
				case NSTANTANEOUS_MP_DRUG:
					itemName = StringConst.NSTANTANEOUS_MP_DRUG;
					break;
//				case INTERVAL_HP_AND_MP_DRUG:
//					itemName = StringConst.INTERVAL_HP_AND_MP_DRUG;
//					break;
				case NSTANTANEOUS_HP_AND_MP_DRUG:
					itemName = StringConst.NSTANTANEOUS_HP_AND_MP_DRUG;
					break;
				case BLOOD_STONE:
					itemName = StringConst.BLOOD_STONE;
					break;
				case BLOOD_MAGIC_STONE:
					itemName = StringConst.BLOOD_MAGIC_STONE;
					break;
				case BLESS_OIL:
					itemName = StringConst.BLESS_OIL;
					break;
				case GIFT:
					itemName = StringConst.GIFT;
					break;
				default:
					break;
			}
			return itemName;
		}

		/**
		 *获取道具使用提示的名字
		 * @param type
		 * @return
		 *
		 */
		public static function itemTypeName(type:int):String
		{
			var itemTypeName:String = "";
			switch (type)
			{
				case IT_EXP:
					itemTypeName = StringConst.ITEM_USE_01;
					break;
				case IT_EXP2:
					itemTypeName = StringConst.ITEM_USE_01;
					break;
				case IT_MONEY:
					itemTypeName = StringConst.ITEM_USE_02;
					break;
				case IT_MONEY2:
					itemTypeName = StringConst.ITEM_USE_02;
					break;
				case IT_MONEY_BIND:
					itemTypeName = StringConst.ITEM_USE_03;
					break;
				case IT_MONEY_BIND2:
					itemTypeName = StringConst.ITEM_USE_03;
					break;
				case IT_GOLD:
					itemTypeName = StringConst.ITEM_USE_04;
					break;
				case IT_GOLD2:
					itemTypeName = StringConst.ITEM_USE_04;
					break;
				case IT_GOLD_BIND:
					itemTypeName = StringConst.ITEM_USE_05;
					break;
				case IT_GOLD_BIND2:
					itemTypeName = StringConst.ITEM_USE_05;
					break;
				case IT_REPUTE:
					itemTypeName = StringConst.ITEM_USE_06;
					break;
				case IT_REPUTE2:
					itemTypeName = StringConst.ITEM_USE_06;
					break;
				case IT_NEIGONG:
					itemTypeName = StringConst.ITEM_USE_07;
					break;
				case IT_NEIGONG2:
					itemTypeName = StringConst.ITEM_USE_07;
					break;
				case IT_SP:
					itemTypeName = StringConst.ITEM_USE_08;
					break;
				case IT_SP2:
					itemTypeName = StringConst.ITEM_USE_08;
					break;
				case IT_ANIMA:
					itemTypeName = StringConst.ITEM_USE_09;
					break;
				case IT_ANIMA2:
					itemTypeName = StringConst.ITEM_USE_09;
					break;
				case IT_SAVVY:
					itemTypeName = StringConst.ITEM_USE_10;
					break;
				case IT_SAVVY2:
					itemTypeName = StringConst.ITEM_USE_10;
					break;
				case IT_ENERGY:
					itemTypeName = StringConst.ITEM_USE_11/* + "xx"*//* + "\t" + StringConst.ITEM_USE_111 + "xx"*/;
					break;
				case IT_ENERGY2:
					itemTypeName = StringConst.ITEM_USE_11/* + "xx"*//* + "\t" + StringConst.ITEM_USE_111 + "xx"*/;
					break;
				case IT_LOVE:
					itemTypeName = StringConst.ITEM_USE_12;
					break;
				case IT_LOVE2:
					itemTypeName = StringConst.ITEM_USE_12;
					break;
				case IT_SUICIDE:
					itemTypeName = StringConst.ITEM_USE_13;
					break;
				case IT_SUICIDE2:
					itemTypeName = StringConst.ITEM_USE_13;
					break;
				case IT_MP:
					itemTypeName = StringConst.ITEM_USE_14;
					break;
				case IT_MP2:
					itemTypeName = StringConst.ITEM_USE_14;
					break;
				case IT_SOUL:
					itemTypeName = StringConst.ITEM_USE_15;
					break;
				case IT_SOUL2:
					itemTypeName = StringConst.ITEM_USE_15;
					break;
				case IT_CONTRIBUTE:
					itemTypeName = StringConst.ITEM_USE_16;
					break;
				case IT_CONTRIBUTE2:
					itemTypeName = StringConst.ITEM_USE_16;
					break;
				case IT_REDUCE_PK:
					itemTypeName = StringConst.ITEM_USE_17;
					break;
				case IT_GIFT:
//					itemTypeName = StringConst.ITEM_USE_18;
					break;
				case IT_GIFT_RANDOM:
//					itemTypeName = StringConst.ITEM_USE_18;
					break;
//				case IT_RING_GIFT:
//					itemTypeName = "";
//					break;
			}
			return itemTypeName;
		}

		/**
		 *根据道具类型显示颜色
		 * @param type
		 * @return
		 *
		 */
		public static function itemTypeColor(type:int):uint
		{
			var itemTypeColor:uint = 0;
			switch (type)
			{
				case IT_EXP:
					itemTypeColor = 0x00ff00;
					break;
				case IT_EXP2:
					itemTypeColor = 0x00ff00;
					break;
				case IT_MONEY:
					itemTypeColor = 0xffcc00;
					break;
				case IT_MONEY2:
					itemTypeColor = 0xffcc00;
					break;
				case IT_MONEY_BIND:
					itemTypeColor = 0xffcc00;
					break;
				case IT_MONEY_BIND2:
					itemTypeColor = 0xffcc00;
					break;
				case IT_GOLD:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_GOLD2:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_GOLD_BIND:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_GOLD_BIND2:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_REPUTE:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_REPUTE2:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_NEIGONG:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_NEIGONG2:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_SP:
					itemTypeColor = 0xffcc00;
					break;
				case IT_SP2:
					itemTypeColor = 0xffcc00;
					break;
				case IT_ANIMA:
					itemTypeColor = 0x00a2ff;
					break;
				case IT_ANIMA2:
					itemTypeColor = 0x00a2ff;
					break;
				case IT_SAVVY:
					itemTypeColor = 0xffcc00;
					break;
				case IT_SAVVY2:
					itemTypeColor = 0xffcc00;
					break;
				case IT_ENERGY:
					itemTypeColor = 0x00ff00;
					break;
				case IT_ENERGY2:
					itemTypeColor = 0x00ff00;
					break;
				case IT_LOVE:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_LOVE2:
					itemTypeColor = 0xea5bcd;
					break;
				case IT_SUICIDE:
					itemTypeColor = 0x00a2ff;
					break;
				case IT_SUICIDE2:
					itemTypeColor = 0x00a2ff;
					break;
				case IT_MP:
					itemTypeColor = 0x00ff00;
					break;
				case IT_MP2:
					itemTypeColor = 0x00ff00;
					break;
				case IT_SOUL:
					itemTypeColor = 0x00a2ff;
					break;
				case IT_SOUL2:
					itemTypeColor = 0x00a2ff;
					break;
				case IT_CONTRIBUTE:
					itemTypeColor = 0x00ff00;
					break;
				case IT_CONTRIBUTE2:
					itemTypeColor = 0x00ff00;
					break;
				case IT_REDUCE_PK:
//					itemTypeColor = StringConst.ITEM_USE_17;
					break;
				case IT_GIFT:
//					itemTypeColor = StringConst.ITEM_USE_18;
					break;
				case IT_GIFT_RANDOM:
//					itemTypeColor = StringConst.ITEM_USE_18;
					break;
			}
			return itemTypeColor;
		}
		
		public static function getStrItemGet(type:int):String
		{
			var strItemGet:String = "";
			switch (type)
			{
				case IT_EXP_DRAG:
					strItemGet = StringConst.ITEM_DAILY_LIMIT_0001;
					break;
				case IT_LOONG_POWER:
					strItemGet = StringConst.ITEM_DAILY_LIMIT_0002;
					break;
			}
			return strItemGet;
		}
		
		public static function getColorByQuality(quality:int):int
		{
			/*switch(quality)
			{
				default:
				case QUALITY_WHITE:
					return 0xffe1aa;
				case QUALITY_GREEN:
					return 0x00ff00;
				case QUALITY_BLUE:
					return 0x00a2ff;
				case QUALITY_PURPLE:
					return 0xe616b6;
				case QUALITY_RED:
					return 0xff0000;
				case QUALITY_ORANGE:
					return 0x000000;
				case QUALITY_WINE:
					return 0x000000;
				case QUALITY_GOLDEN:
					return 0xFFFF00;
			}*/
			var qualityCfgData:QualityCfgData = ConfigDataManager.instance.qualityCfgData(quality);
			if(!qualityCfgData)
			{
				trace("ItemType.getColorByQuality 品质:"+quality+"，配置信息不存在");
				return 0xffe1aa;
			}
			var value:Number = parseInt(qualityCfgData.rgb_num);
			return value ? value : 0xffe1aa;
		}
		/**
		 * 根据品质获取特效完整url
		 * @param quality 品质
		 * @return 完整url
		 */		
		public static function getEffectUrlByQuality(quality:int):String
		{
			/*switch(quality)
			{
				default:
				case QUALITY_WHITE:
					return "/icon/white.swf";
				case QUALITY_GREEN:
					return "/icon/green.swf";
				case QUALITY_BLUE:
					return "/icon/blue.swf";
				case QUALITY_PURPLE:
					return "/icon/purple.swf";
				case QUALITY_RED:
					return "/icon/red.swf";
				case QUALITY_ORANGE:
					return "/icon/orange.swf";
				case QUALITY_WINE:
					return "/icon/wine.swf";
				case QUALITY_GOLDEN:
					return "/icon/golden.swf";
			}*/
			var qualityCfgData:QualityCfgData = ConfigDataManager.instance.qualityCfgData(quality);
			if(!qualityCfgData)
			{
				trace("ItemType.getEffectUrlByQuality 品质:"+quality+"，配置信息不存在");
				return "";
			}
			return qualityCfgData.quality_effect;
		}
		/**
		 * 根据品质获取特效颜色
		 * @param quality 品质
		 * @return 完整url
		 */		
		public static function getEffectRectColorByQuality(quality:int):int
		{
			var qualityCfgData:QualityCfgData = ConfigDataManager.instance.qualityCfgData(quality);
			if(!qualityCfgData)
			{
				trace("ItemType.getExtraEffectUrlByQuality 品质:"+quality+"，配置信息不存在");
				return 0;
			}
			return parseInt(qualityCfgData.effect);
		}
		
		public static function isItemNumShow(id:int):Boolean
		{
			var boolean:Boolean;
			switch(id)
			{
				default:
					boolean = true;
					break;
				case ItemType.IT_EXP:
				case ItemType.IT_GOLD:
				case ItemType.IT_GOLD_BIND:
				case ItemType.IT_MONEY:
				case ItemType.IT_MONEY_BIND:
					boolean = false;
					break;
			}
			return boolean;
		}
	}
}