package com.model.consts
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AttrCfgData;
	import com.model.consts.JobConst;
	
	/**
	 * 角色基础属性
	 * @author jhj
	 */
	public class RolePropertyConst
	{
		/**生命上限，1*/
		public static const ROLE_PROPERTY_LIFE_UPPER_ID:int = 1;
		/**魔法上限，2*/
		public static const ROLE_PROPERTY_MAGIC_UPPER_ID:int = 2;
		/**物理攻击下限，3*/
		public static const ROLE_PROPERTY_PHSICAL_ATTACK_LOWER_ID:int= 3;
		/**物理攻击上限，4*/
		public static const ROLE_PROPERTY_PHYSICAL_ATTACK_UPPER_ID:int = 4;
		/**魔法攻击下限，5*/
		public static const ROLE_PROPERTY_MAGIC_ATTACK_LOWER_ID:int = 5;
		/**魔法攻击上限，6*/
		public static const ROLE_PROPERTY_MAGIC_ATTACK_UPPER_ID:int = 6;
		/**道术攻击下限，7*/
		public static const ROLE_PROPERTY_TAOISM_ATTACK_LOWER_ID:int = 7;
		/**道术攻击上限，8*/
		public static const ROLE_PROPERTY_TAOISM_ATTACK_UPPER_ID:int = 8;
		/**物理防御下限，9*/
		public static const ROLE_PROPERTY_PHYSICAl_DEFENSE_LOWER_ID:int = 9;
		/**物理防御上限，10*/
		public static const ROLE_PROPERTY_PHYSICAL_DEFENSE_UPPER_ID:int = 10;
		/**魔法防御下限，11*/
		public static const ROLE_PROPERTY_MAGIC_DEFENSE_LOWER_ID:int= 11;
		/**魔法防御上限，12*/
		public static const ROLE_PROPERTY_MAGIC_DEFENSE_UPPER_ID:int = 12;
		/**准确，13*/
		public static const ROLE_PROPERTY_ACCURATE_ID:int = 13;
		/**敏捷，14*/
		public static const ROLE_PROPERTY_AGILE_ID:int = 14;
		/**魔法闪避，15*/
		public static const ROLE_PROPERTY_MAGIC_EVASION_ID:int = 15;
		/**暴击，16*/
		public static const ROLE_PROPERTY_CRIT_ID:int = 16;
		/**暴击伤害，17*/
		public static const ROLE_PROPERTY_CRIT_HURT_ID:int = 17;
		/**韧性，18*/
		public static const ROLE_PROPERTY_RESILIENCE_ID:int = 18;
		/**会心一击，19*/
		public static const ROLE_PROPERTY_HEART_HURT_ID:int = 19;
		/**会心闪避，20*/
		public static const ROLE_PROPERTY_HEART_EVASION_ID:int = 20;
		/**幸运，21*/
		public static const ROLE_PROPERTY_LUCKY_ID:int = 21;
		/**抵抗幸运，22*/
		public static const ROLE_PROPERTY_ANTI_LUCKY_ID:int = 22;
		/**诅咒，23*/
		public static const ROLE_PROPERTY_DAMNATION_ID:int = 23;
		/**神圣，24*/
		public static const ROLE_PROPERTY_HOLY_ID:int = 24;
		/**攻速，25*/
		public static const ROLE_PROPERTY_ATTACK_SPEED_ID:int = 25;
		/**回血，26*/
		public static const ROLE_PROPERTY_BLOOD_RETURN_ID:int = 26;
		/**回魔，27*/
		public static const ROLE_PROPERTY_MAGIC_RETURN_ID:int = 27;
		/**中毒回复，28*/
		public static const ROLE_PROPERTY_ANTI_POISON_ID:int = 28;
		/**负重，29*/
		public static const ROLE_PROPERTY_HEAVY_ID:int = 29;
		/**移动速度，30*/
		public static const ROLE_PROPERTY_MOVE_SPEED_ID:int = 30;
		/**物理免伤，31*/
		public static const ROLE_PROPERTY_WU_LI_MIAN_SHANG_ID:int = 31;
		/**魔法免伤，32*/
		public static const ROLE_PROPERTY_MO_FA_MIAN_SHANG_ID:int = 32;
		/**免伤穿透，33*/
		public static const ROLE_PROPERTY_MIAN_SHANG_CHUAN_TOU_ID:int = 33;
		/**伤害增益，34*/
		public static const ROLE_PROPERTY_DAMAGE_UP:int = 34;
		/**麻痹几率，35*/
		public static const ROLE_PROPERTY_MA_BI_RATE_ID:int = 35;
		/**麻痹抗性，36*/
		public static const ROLE_PROPERTY_MA_BI_KANG_XING_ID:int = 36;
		/**麻痹恢复，37*/
		public static const ROLE_PROPERTY_MA_BI_RECOVER:int = 37;
		/**合击威力，38*/
		public static const ROLE_PROPERTY_HE_JI_WEI_LI_ID:int = 38;
		/**反射，39*/
		public static const ROLE_PROPERTY_REFLECT_ID:int = 39;
		/**反射比率，40*/
		public static const ROLE_PROPERTY_REFLECT_RATE_ID:int = 40;
		/**格挡，41*/
		public static const ROLE_PROPERTY_PARRY_ID:int = 41;
		/**格挡值，42*/
		public static const ROLE_PROPERTY_PARRY_VALUE_ID:int = 42;
		/**吸血，43*/
		public static const ROLE_PROPERTY_HP_DRAIN_ID:int = 43;
		/**吸血比率，44*/
		public static const ROLE_PROPERTY_HP_DRAIN_RATE_ID:int = 44;
		/**吸魔，45*/
		public static const ROLE_PROPERTY_MP_DRAIN_ID:int = 45;
		/**吸魔比率，46*/
		public static const ROLE_PROPERTY_MP_DRAIN_RATE_ID:int = 46;
		/**击杀回血，47*/
		public static const ROLE_PROPERTY_KILL_HP_RECOVER_ID:int = 47;
		/**击杀回魔，48*/
		public static const ROLE_PROPERTY_KILL_MP_RECOVER_ID:int = 48;
		/**药效增益，49*/
		public static const ROLE_PROPERTY_DRUG_INTENSIFY_ID:int = 49;
		/**复活增益，50*/
		public static const ROLE_PROPERTY_REVIVE_HP_UP:int = 50;
		/**抑生，51*/
		public static const ROLE_PROPERTY_ANTI_HP_RECOVER_ID:int = 51;
		
		/**人形杀手，52*/
		public static const ROLE_PROPERTY_HUMANOID_KILLER_ID:int = 52;
		/**野兽杀手，53*/
		public static const ROLE_PROPERTY_BEAST_KILLER_ID:int = 53;
		/**亡灵杀手，54*/
		public static const ROLE_PROPERTY_GHOST_KILLER_ID:int = 54;
		/**恶魔杀手，55*/
		public static const ROLE_PROPERTY_DEVIL_KILLER_ID:int = 55;
		/**掉宝几率，56*/
		public static const ROLE_PROPERTY_ITEM_RROP_RATE_ID:int = 56;
		/**寻宝几率，57*/
		public static const ROLE_PROPERTY_GAIN_RATE_ID:int = 57;
		/**吸取技力几率，58*/
		public static const ROLE_PROPERTY_CAPTURE_SKILL_RATE:int = 58;
		/**杀怪金钱，59*/
		public static const ROLE_PROPERTY_KILL_MONSTER_MONEY_ID:int = 59;
		/**杀怪经验，60*/
		public static const ROLE_PROPERTY_KILL_MONSTER_EXPERIENCE_ID:int= 60;
		
		/**怒气恢复速度，62*/
		public static const ROLE_PROPERTY_ANGER_RECOVER_SPEED:int = 62;
		/**攻击下限，63*/
		public static const ROLE_PROPERTY_DAMAGE_LOWER:int = 63;
		/**攻击上限，64*/
		public static const ROLE_PROPERTY_DAMAGE_UPPER:int = 64;
		
		/**对战士伤害增加，70*/
		public static const ROLE_PROPERTY_DAMAGE_TO_WARRIOR_RATE_UP:int = 70;
		/**受战士伤害减少，71*/
		public static const ROLE_PROPERTY_DAMAGE_FROM_WARRIOR_RATE_DOWN:int = 71;
		/**对法师伤害增加，72*/
		public static const ROLE_PROPERTY_DAMAGE_TO_MAGIC_RATE_UP:int = 72;
		/**受法师伤害减少，73*/
		public static const ROLE_PROPERTY_DAMAGE_FROM_MAGIC_RATE_DOWN:int = 73;
		/**对道士伤害增加，74*/
		public static const ROLE_PROPERTY_DAMAGE_TO_WIZARD_RATE_UP:int = 74;
		/**受道士伤害减少，75*/
		public static const ROLE_PROPERTY_DAMAGE_FROM_WIZARD_RATE_DOWN:int = 75;
		/**对怪物伤害增加，76*/
		public static const ROLE_PROPERTY_DAMAGE_TO_MONSTER_RATE_UP:int = 76;
		/**受怪物伤害减少，77*/
		public static const ROLE_PROPERTY_DAMAGE_FROM_MONSTER_RATE_DOWN:int = 77;
		/**对BOSS伤害增加，78*/
		public static const ROLE_PROPERTY_DAMAGE_TO_BOSS_RATE_UP:int = 78;
		/**受BOSS伤害减少，79*/
		public static const ROLE_PROPERTY_DAMAGE_FROM_BOSS_RATE_DOWN:int = 79;
		
		/**内力上限，80*/
		public static const ROLE_PROPERTY_MAX_INTERNAL_FORCE_ID:int = 80;
		/**内力回复，81*/
		public static const ROLE_PROPERTY_INTERNAL_FORCE_RECOVER_ID:int = 81;
		/**内力免伤，82*/
		public static const ROLE_PROPERTY_INTERNAL_FORCE_AVOIDENCE_ID:int = 82;
		
		/**生命值，91*/
		public static const ROLE_PROPERTY_HP_ID:int= 91;
		/**魔法值，92*/
		public static const ROLE_PROPERTY_MAGIC_ID:int= 92;
		/**怒气值，93*/
		public static const ROLE_PROPERTY_NU_QI_ID:int = 93;
		/**内力值，94*/
		public static const ROLE_INTERNAL_FORCE_ID:int = 94;
		
		public static const ROLE_INTERNAL_PKVALUE_ID:int = 95;
		
		public static const NUM_TYPE:int = 1;
		public static const PERCENT_TYPE:int = 2;
		
		public static function getPropertyName(propertyId:int):String
		{
			var propertyName:String = "";
			var attrCfgData:AttrCfgData = ConfigDataManager.instance.attrCfgData(propertyId);
			propertyName = attrCfgData.name;
			return propertyName;
		}
		/**
		 * 获取属性战斗力
		 * @param propertyId 属性id使用RolePropertyConst中的值
		 * @param value 属性值
		 * @param job 0表示无职业限制，当前职业值表示只取当前职业相关的战斗力<br>使用JobConst中的值
		 * @return 战斗力
		 */		
		public static function getPropertyFightPower(propertyId:int,value:Number,job:int):Number
		{
			var propertyFightPower:Number = 0;
			var cfgDt:AttrCfgData = ConfigDataManager.instance.attrCfgData(propertyId);
			propertyFightPower = value*cfgDt.getAttr_ratio(job)*.001;
			return propertyFightPower;
		}
		
		private static var _attrTypes:Vector.<int>;
		
		public static function get attrTypes():Vector.<int>
		{
			if(!_attrTypes)
			{
				_attrTypes = new <int>[
					ROLE_PROPERTY_LIFE_UPPER_ID,ROLE_PROPERTY_MAGIC_UPPER_ID,ROLE_PROPERTY_PHSICAL_ATTACK_LOWER_ID,ROLE_PROPERTY_PHYSICAL_ATTACK_UPPER_ID,
					ROLE_PROPERTY_MAGIC_ATTACK_LOWER_ID,ROLE_PROPERTY_MAGIC_ATTACK_UPPER_ID,ROLE_PROPERTY_TAOISM_ATTACK_LOWER_ID,ROLE_PROPERTY_TAOISM_ATTACK_UPPER_ID,
					ROLE_PROPERTY_PHYSICAl_DEFENSE_LOWER_ID,ROLE_PROPERTY_PHYSICAL_DEFENSE_UPPER_ID,ROLE_PROPERTY_MAGIC_DEFENSE_LOWER_ID,ROLE_PROPERTY_MAGIC_DEFENSE_UPPER_ID,
					ROLE_PROPERTY_ACCURATE_ID,ROLE_PROPERTY_AGILE_ID,ROLE_PROPERTY_MAGIC_EVASION_ID,ROLE_PROPERTY_CRIT_ID,ROLE_PROPERTY_CRIT_HURT_ID,ROLE_PROPERTY_RESILIENCE_ID,
					ROLE_PROPERTY_HEART_HURT_ID,ROLE_PROPERTY_HEART_EVASION_ID,ROLE_PROPERTY_LUCKY_ID,ROLE_PROPERTY_ANTI_LUCKY_ID,ROLE_PROPERTY_DAMNATION_ID,ROLE_PROPERTY_HOLY_ID,
					ROLE_PROPERTY_ATTACK_SPEED_ID,ROLE_PROPERTY_BLOOD_RETURN_ID,ROLE_PROPERTY_MAGIC_RETURN_ID,ROLE_PROPERTY_ANTI_POISON_ID,ROLE_PROPERTY_HEAVY_ID,
					ROLE_PROPERTY_MOVE_SPEED_ID,ROLE_PROPERTY_WU_LI_MIAN_SHANG_ID,ROLE_PROPERTY_MO_FA_MIAN_SHANG_ID,ROLE_PROPERTY_MIAN_SHANG_CHUAN_TOU_ID,ROLE_PROPERTY_DAMAGE_UP,
					ROLE_PROPERTY_MA_BI_RATE_ID,ROLE_PROPERTY_MA_BI_KANG_XING_ID,ROLE_PROPERTY_MA_BI_RECOVER,ROLE_PROPERTY_HE_JI_WEI_LI_ID,ROLE_PROPERTY_REFLECT_ID,ROLE_PROPERTY_REFLECT_RATE_ID,
					ROLE_PROPERTY_PARRY_ID,ROLE_PROPERTY_PARRY_VALUE_ID,ROLE_PROPERTY_HP_DRAIN_ID,ROLE_PROPERTY_HP_DRAIN_RATE_ID,ROLE_PROPERTY_MP_DRAIN_ID,ROLE_PROPERTY_MP_DRAIN_RATE_ID,
					ROLE_PROPERTY_KILL_HP_RECOVER_ID,ROLE_PROPERTY_KILL_MP_RECOVER_ID,ROLE_PROPERTY_DRUG_INTENSIFY_ID,ROLE_PROPERTY_REVIVE_HP_UP,ROLE_PROPERTY_ANTI_HP_RECOVER_ID,
					ROLE_PROPERTY_HUMANOID_KILLER_ID,ROLE_PROPERTY_BEAST_KILLER_ID,ROLE_PROPERTY_GHOST_KILLER_ID,ROLE_PROPERTY_DEVIL_KILLER_ID,ROLE_PROPERTY_ITEM_RROP_RATE_ID,
					ROLE_PROPERTY_GAIN_RATE_ID,ROLE_PROPERTY_CAPTURE_SKILL_RATE,ROLE_PROPERTY_KILL_MONSTER_MONEY_ID,ROLE_PROPERTY_KILL_MONSTER_EXPERIENCE_ID,ROLE_PROPERTY_ANGER_RECOVER_SPEED,
					ROLE_PROPERTY_DAMAGE_LOWER,ROLE_PROPERTY_DAMAGE_UPPER,ROLE_PROPERTY_DAMAGE_TO_WARRIOR_RATE_UP,ROLE_PROPERTY_DAMAGE_FROM_WARRIOR_RATE_DOWN,ROLE_PROPERTY_DAMAGE_TO_MAGIC_RATE_UP,
					ROLE_PROPERTY_DAMAGE_FROM_MAGIC_RATE_DOWN,ROLE_PROPERTY_DAMAGE_TO_WIZARD_RATE_UP,ROLE_PROPERTY_DAMAGE_FROM_WIZARD_RATE_DOWN,ROLE_PROPERTY_DAMAGE_TO_MONSTER_RATE_UP,
					ROLE_PROPERTY_DAMAGE_FROM_MONSTER_RATE_DOWN,ROLE_PROPERTY_DAMAGE_TO_BOSS_RATE_UP,ROLE_PROPERTY_DAMAGE_FROM_BOSS_RATE_DOWN,ROLE_PROPERTY_MAX_INTERNAL_FORCE_ID,
					ROLE_PROPERTY_INTERNAL_FORCE_RECOVER_ID,ROLE_PROPERTY_INTERNAL_FORCE_AVOIDENCE_ID,ROLE_PROPERTY_HP_ID,ROLE_PROPERTY_MAGIC_ID,ROLE_PROPERTY_NU_QI_ID,ROLE_INTERNAL_FORCE_ID,
					ROLE_INTERNAL_PKVALUE_ID]
			}
			return _attrTypes;
		}
			
		public function RolePropertyConst()
		{
			
		}
	}
}