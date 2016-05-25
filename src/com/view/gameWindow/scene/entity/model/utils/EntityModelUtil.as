package com.view.gameWindow.scene.entity.model.utils
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.SexConst;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.AvatarHideFlagTypes;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;

	public class EntityModelUtil
	{
		public static function getEntityModel(cloth:int, fashion:int, weapon:int, magicWeapon:int, hair:int, shield:int, wing:int, sex:int, actionId:int, dir:int, isHideWeaponEffect:Boolean = false):EntityModel
		{
			var clothPath:String = "";
			var weaponPath:String = "";
			var weaponEffectPath:String = "";
			var hairPath:String = "";
			var smallWingPath:String = "";
			var largeWingPath:String = "";
			var shieldPath:String = "";
			var handEffectPath:String = "";
			var equips:Vector.<EquipCfgData> = new Vector.<EquipCfgData>();
			var clothEquipConfig:EquipCfgData = null;
			var weaponEquipConfig:EquipCfgData = null;
			var hairEquipConfig:EquipCfgData = null;
			var largeWingEquipConfig:EquipCfgData = null;
			var shieldEquipConfig:EquipCfgData = null;
			if (fashion > 0)
			{
				clothEquipConfig = ConfigDataManager.instance.equipCfgData(fashion);
			}
			else if (cloth > 0)
			{
				clothEquipConfig = ConfigDataManager.instance.equipCfgData(cloth);
			}
			if (clothEquipConfig)
			{
				equips.push(clothEquipConfig);
			}
			if (magicWeapon > 0)
			{
				weaponEquipConfig = ConfigDataManager.instance.equipCfgData(magicWeapon);
			}
			else if (weapon > 0)
			{
				weaponEquipConfig = ConfigDataManager.instance.equipCfgData(weapon);
			}
			if (weaponEquipConfig)
			{
				equips.push(weaponEquipConfig);
			}
			if (hair > 0)
			{
				hairEquipConfig = ConfigDataManager.instance.equipCfgData(hair);
				if (hairEquipConfig)
				{
					equips.push(hairEquipConfig);
				}
			}
			if (wing > 0)
			{
				largeWingEquipConfig = ConfigDataManager.instance.equipCfgData(wing);
				if (largeWingEquipConfig)
				{
					equips.push(largeWingEquipConfig);
				}
			}
			if (shield > 0)
			{
				shieldEquipConfig = ConfigDataManager.instance.equipCfgData(shield);
				if (shieldEquipConfig)
				{
					equips.push(shieldEquipConfig);
				}
			}
			if (sex == SexConst.TYPE_MALE)
			{
				clothPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + "ty100/";
			}
			else if (sex === SexConst.TYPE_FEMALE)
			{
				clothPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + "ty200/";
			}
			if (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_WEAPON) == 0)
			{
				if (sex == SexConst.TYPE_MALE)
				{
					weaponPath = ResourcePathConstants.ENTITY_RES_EQUIP_LOAD + "tywq100/";
				}
				else if (sex === SexConst.TYPE_FEMALE)
				{
					weaponPath = ResourcePathConstants.ENTITY_RES_EQUIP_LOAD + "tywq200/";
				}
			}
			if (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_HAIR) == 0)
			{
				if (sex == SexConst.TYPE_MALE)
				{
					hairPath = ResourcePathConstants.ENTITY_RES_HAIR_LOAD + "tytf100/";
				}
				else if (sex === SexConst.TYPE_FEMALE)
				{
					hairPath = ResourcePathConstants.ENTITY_RES_HAIR_LOAD + "tytf200/";
				}
			}
			for each (var equipCfgData:EquipCfgData in equips)
			{
				if (sex == SexConst.TYPE_MALE)
				{
					if (equipCfgData.male_cloth)
					{
						clothPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.male_cloth + "/";
					}
					if (equipCfgData.male_hair && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_HAIR) == 0)))
					{
						hairPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.male_hair + "/";
					}
					if (equipCfgData.male_weapon && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_WEAPON) == 0)))
					{
						weaponPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.male_weapon + "/";
					}
					if (equipCfgData.male_weapon_effect && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_WEAPON_EFFECT) == 0) && (!weaponEquipConfig || (weaponEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_WEAPON_EFFECT) == 0)))
					{
						weaponEffectPath = ResourcePathConstants.ENTITY_RES_EQUIP_EFFETCT_LOAD + equipCfgData.male_weapon_effect + "/";
					}
					if (equipCfgData.male_shield && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_SHIELD) == 0)))
					{
						shieldPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.male_shield + "/";
					}
					if (equipCfgData.male_small_wing && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_SMALL_WING) == 0)))
					{
						smallWingPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.male_small_wing + "/";
					}
					if (equipCfgData.male_large_wing && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_LARGE_WING) == 0)))
					{
						largeWingPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.male_large_wing + "/";
					}
					if (equipCfgData.male_hand_effect && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_HAND_EFFECT) == 0)))
					{
						largeWingPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.male_large_wing + "/";
					}
					if(actionId == ActionTypes.MINING)
					{
						weaponPath = ResourcePathConstants.ENTITY_RES_EQUIP_LOAD + "hzc101/";
						weaponEffectPath = "";
					}
					else if (actionId == ActionTypes.WATERMELON)
					{
						weaponPath = ResourcePathConstants.ENTITY_RES_EQUIP_LOAD + "dmc101/";
						weaponEffectPath = "";
					}
				}
				else if (sex === SexConst.TYPE_FEMALE)
				{
					if (equipCfgData.female_cloth)
					{
						clothPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.female_cloth + "/";
					}
					if (equipCfgData.female_hair && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_HAIR) == 0)))
					{
						hairPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.female_hair + "/";
					}
					if (equipCfgData.female_weapon && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_WEAPON) == 0)))
					{
						weaponPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.female_weapon + "/";
					}
					if (equipCfgData.female_weapon_effect && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_WEAPON_EFFECT) == 0) && (!weaponEquipConfig || (weaponEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_WEAPON_EFFECT) == 0)))
					{
						weaponEffectPath = ResourcePathConstants.ENTITY_RES_EQUIP_EFFETCT_LOAD + equipCfgData.female_weapon_effect + "/";
					}
					if (equipCfgData.female_shield && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_SHIELD) == 0)))
					{
						shieldPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.female_shield + "/";
					}
					if (equipCfgData.female_small_wing && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_SMALL_WING) == 0)))
					{
						smallWingPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.female_small_wing + "/";
					}
					if (equipCfgData.female_large_wing && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_LARGE_WING) == 0)))
					{
						largeWingPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.female_large_wing + "/";
					}
					if (equipCfgData.female_hand_effect && ((equipCfgData == clothEquipConfig) || (!clothEquipConfig || (clothEquipConfig.hide_flag & AvatarHideFlagTypes.AHFT_HAND_EFFECT) == 0)))
					{
						largeWingPath = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + equipCfgData.female_large_wing + "/";
					}
					if(actionId == ActionTypes.MINING)
					{
						weaponPath = ResourcePathConstants.ENTITY_RES_EQUIP_LOAD + "hzc201/";
						weaponEffectPath = "";
					}
					else if (actionId == ActionTypes.WATERMELON)
					{
						weaponPath = ResourcePathConstants.ENTITY_RES_EQUIP_LOAD + "dmc201/";
						weaponEffectPath = "";
					}
				}
			}
			if (isHideWeaponEffect) weaponEffectPath = null;
			return EntityModelsManager.getInstance().getAndUseEntityModel(clothPath, hairPath, largeWingPath, smallWingPath, weaponPath, weaponEffectPath, handEffectPath, shieldPath, dir);
		}
	}
}