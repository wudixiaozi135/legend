package com.model.configData
{
    import com.model.configData.cfgdata.*;
    import com.model.configData.constants.ConfigType;

    public class ConfigDataGameWindow
	{
		[Embed("../../../../config/map.cfg",mimeType="application/octet-stream")]
		private const mapClass:Class;
		[Embed("../../../../config/drop_group.cfg",mimeType="application/octet-stream")]
		private const mstDrpGrpClass:Class;
		[Embed("../../../../config/level.cfg",mimeType="application/octet-stream")]
		private const levelClass:Class;
		[Embed("../../../../config/map_plant.cfg",mimeType="application/octet-stream")]
		private const mapPlantClass:Class;
		[Embed("../../../../config/map_vip.cfg",mimeType="application/octet-stream")]
		private const mapVipClass:Class;
		[Embed("../../../../config/map_monster.cfg",mimeType="application/octet-stream")]
		private const mapMstClass:Class;
		[Embed("../../../../config/map_region.cfg",mimeType="application/octet-stream")]
		private const mapRegionClass:Class;
		[Embed("../../../../config/map_teleporter.cfg",mimeType="application/octet-stream")]
		private const mapTlptClass:Class;
		[Embed("../../../../config/map_trap.cfg",mimeType="application/octet-stream")]
		private const mapTrapClass:Class;
		[Embed("../../../../config/monster.cfg",mimeType="application/octet-stream")]
		private const monsterClass:Class;
		[Embed("../../../../config/item.cfg",mimeType="application/octet-stream")]
		private const itemClass:Class;
		[Embed("../../../../config/exp_yu_award.cfg",mimeType="application/octet-stream")]
		private const expYuAwardClass:Class;
		[Embed("../../../../config/equip.cfg",mimeType="application/octet-stream")]
		private const equipClass:Class;
		[Embed("../../../../config/task.cfg",mimeType="application/octet-stream")]
		private const taskClass:Class;
		[Embed("../../../../config/npc.cfg",mimeType="application/octet-stream")]
		private const npcClass:Class;
		[Embed("../../../../config/skill.cfg",mimeType="application/octet-stream")]
		private const skillClass:Class;
		[Embed("../../../../config/npc_shop.cfg",mimeType="application/octet-stream")]
		private const npcShopClass:Class;
		[Embed("../../../../config/dungeon.cfg",mimeType="application/octet-stream")]
		private const dungeonClass:Class;
		[Embed("../../../../config/dungeon_event.cfg",mimeType="application/octet-stream")]
		private const dungeonEventClass:Class;
		[Embed("../../../../config/dungeon_shop.cfg",mimeType="application/octet-stream")]
		private const dungeonShopClass:Class;
		[Embed("../../../../config/dungeon_reward_evaluate.cfg",mimeType="application/octet-stream")]
		private const dungeonRewardEvaluateClass:Class;
		[Embed("../../../../config/dungeon_reward_mutiple.cfg",mimeType="application/octet-stream")]
		private const dungeonRewardMultipleClass:Class;
		[Embed("../../../../config/dungeon_card_reward_group.cfg",mimeType="application/octet-stream")]
		private const dungeonRewardCardGroupClass:Class;
		[Embed("../../../../config/dungeon_card_gold.cfg",mimeType="application/octet-stream")]
		private const dungeonRewardCardGoldClass:Class;
		[Embed("../../../../config/npc_teleport.cfg",mimeType="application/octet-stream")]
		private const npcTeleportClass:Class;
		[Embed("../../../../config/plant.cfg",mimeType="application/octet-stream")]
		private const plantClass:Class;
		[Embed("../../../../config/chest.cfg",mimeType="application/octet-stream")]
		private const closetClass:Class;
		[Embed("../../../../config/equip_strengthen.cfg",mimeType="application/octet-stream")]
		private const equipStrengthenClass:Class;
		[Embed("../../../../config/equip_duijie_suit.cfg",mimeType="application/octet-stream")]
		private const equipDuijieSuitClass:Class;
		[Embed("../../../../config/equip_strengthen_attr.cfg",mimeType="application/octet-stream")]
		private const equipStrengthenAttrClass:Class;
		[Embed("../../../../config/equip_recycle.cfg",mimeType="application/octet-stream")]
		private const equipRecycleClass:Class;
		[Embed("../../../../config/equip_recycle_daily_reward.cfg",mimeType="application/octet-stream")]
		private const equipRecycleRewardClass:Class;
		[Embed("../../../../config/task_star_reward.cfg",mimeType="application/octet-stream")]
		private const taskStarRewardClass:Class;
		[Embed("../../../../config/task_star_rate.cfg",mimeType="application/octet-stream")]
		private const taskStarRateClass:Class;
		[Embed("../../../../config/task_star_reward_cost.cfg",mimeType="application/octet-stream")]
		private const taskStarCostClass:Class;
		[Embed("../../../../config/task_wanted.cfg",mimeType="application/octet-stream")]
		private const taskWantCostClass:Class;
		[Embed("../../../../config/task_wanted_daily_reward.cfg",mimeType="application/octet-stream")]
		private const taskWantedDailyRewardClass:Class;
		[Embed("../../../../config/equip_upgrade.cfg",mimeType="application/octet-stream")]
		private const equipDegreeClass:Class;
		[Embed("../../../../config/equip_disassemble.cfg",mimeType="application/octet-stream")]
		private const equipResolveClass:Class;
		[Embed("../../../../config/entity_layer.cfg",mimeType="application/octet-stream")]
		private const entityLayerClass:Class;
		[Embed("../../../../config/quality.cfg",mimeType="application/octet-stream")]
		private const qualityClass:Class;
		[Embed("../../../../config/trap.cfg",mimeType="application/octet-stream")]
		private const trapClass:Class;
		[Embed("../../../../config/mail.cfg",mimeType="application/octet-stream")]
		private const mailClass:Class;
		[Embed("../../../../config/item_type.cfg",mimeType="application/octet-stream")]
		private const itemTypeClass:Class;
		[Embed("../../../../config/equip_exchange.cfg",mimeType="application/octet-stream")]
		private const equipExchangeClass:Class;
		[Embed("../../../../config/useless_sell.cfg",mimeType="application/octet-stream")]
		private const uselessSellClass:Class;
		[Embed("../../../../config/nobility.cfg",mimeType="application/octet-stream")]
		private const peerageClass:Class;
		[Embed("../../../../config/nobility_desc.cfg",mimeType="application/octet-stream")]
		private const peerageDescClass:Class;
		[Embed("../../../../config/vip.cfg",mimeType="application/octet-stream")]
		private const vipClass:Class;
		[Embed("../../../../config/ring.cfg",mimeType="application/octet-stream")]
		private const specialRingClass:Class;
		[Embed("../../../../config/ring_level.cfg",mimeType="application/octet-stream")]
		private const specialRingLevelClass:Class;
		[Embed("../../../../config/buff.cfg",mimeType="application/octet-stream")]
		private const buffClass:Class;
		[Embed("../../../../config/ring_dungeon.cfg",mimeType="application/octet-stream")]
		private const specialRingDungeonClass:Class;
		[Embed("../../../../config/daily.cfg",mimeType="application/octet-stream")]
		private const dailyClass:Class;
		[Embed("../../../../config/daily_vit_reward.cfg",mimeType="application/octet-stream")]
		private const dailyVitRewardClass:Class;
		[Embed("../../../../config/activity.cfg",mimeType="application/octet-stream")]
		private const activityClass:Class;
		[Embed("../../../../config/activity_event.cfg",mimeType="application/octet-stream")]
		private const activityEventClass:Class;
		[Embed("../../../../config/activity_time.cfg",mimeType="application/octet-stream")]
		private const activityTimeClass:Class;
		[Embed("../../../../config/activity_map_region.cfg",mimeType="application/octet-stream")]
		private const activityMapRegionClass:Class;
		[Embed("../../../../config/boss.cfg",mimeType="application/octet-stream")]
		private const bossClass:Class;
		[Embed("../../../../config/map_boss.cfg",mimeType="application/octet-stream")]
		private const mapBossClass:Class;
		[Embed("../../../../config/corpse_monster_dig.cfg",mimeType="application/octet-stream")]
		private const mstDigClass:Class;
		[Embed("../../../../config/combine.cfg",mimeType="application/octet-stream")]
		private const combineClass:Class;
		[Embed("../../../../config/job.cfg",mimeType="application/octet-stream")]
		private const jobClass:Class;
		[Embed("../../../../config/pet.cfg",mimeType="application/octet-stream")]
		private const petClass:Class;		
		[Embed("../../../../config/guide.cfg",mimeType="application/octet-stream")]
		private const guideClass:Class;		
		[Embed("../../../../config/hero_equip_upgrade.cfg",mimeType="application/octet-stream")]
		private const heroEquipUpgrad:Class;
		[Embed("../../../../config/hero_grade.cfg",mimeType="application/octet-stream")]
		private const heroGrade:Class;
		[Embed("../../../../config/hero_meridians.cfg",mimeType="application/octet-stream")]
		private const heroMeridians:Class;
		[Embed("../../../../config/unlock.cfg",mimeType="application/octet-stream")]
		private const unlockClass:Class;
		[Embed("../../../../config/attr.cfg",mimeType="application/octet-stream")]
		private const attrClass:Class;
		[Embed("../../../../config/achievement.cfg",mimeType="application/octet-stream")]
		private const achievementClass:Class;
		[Embed("../../../../config/achievement_group.cfg",mimeType="application/octet-stream")]
		private const achievementGroupClass:Class;
		[Embed("../../../../config/reincarn.cfg",mimeType="application/octet-stream")]
		private const reinCarnClass:Class;
		[Embed("../../../../config/equip_polish.cfg",mimeType="application/octet-stream")]
		private const equipPolishClass:Class;
		[Embed("../../../../config/equip_polish_attr.cfg",mimeType="application/octet-stream")]
		private const equipPolishAttrClass:Class;
		[Embed("../../../../config/cfg_baptize.cfg",mimeType="application/octet-stream")]
		private const equipRefinedClass:Class;
		[Embed("../../../../config/equip_baptize_cost.cfg",mimeType="application/octet-stream")]
		private const equipRefinedCostClass:Class;
		[Embed("../../../../config/equip_baptize_suite.cfg",mimeType="application/octet-stream")]
		private const equipRefinedSuiteClass:Class;
		[Embed("../../../../config/joint_halo.cfg",mimeType="application/octet-stream")]
		private const jointHaloClass:Class;
		[Embed("../../../../config/online_reward.cfg",mimeType="application/octet-stream")]
		private const onlineRewardClass:Class;
		[Embed("../../../../config/game_shop.cfg", mimeType="application/octet-stream")]
		private const gameShopClass:Class;
		[Embed("../../../../config/announcement.cfg", mimeType="application/octet-stream")]
		private const AnnouncementClass:Class;
		[Embed("../../../../config/rune_transform.cfg",mimeType="application/octet-stream")]
		private const RuneTransformClass:Class;
		[Embed("../../../../config/family.cfg",mimeType="application/octet-stream")]
		private const FamilyClass:Class;
		[Embed("../../../../config/pray.cfg", mimeType="application/octet-stream")]
		private const PrayClass:Class;
		[Embed("../../../../config/position.cfg", mimeType="application/octet-stream")]
		private const PositionClass:Class;
		[Embed("../../../../config/position_chop.cfg", mimeType="application/octet-stream")]
		private const PositionChopClass:Class;
		[Embed("../../../../config/family_position.cfg", mimeType="application/octet-stream")]
		private const FamilyPositionClass:Class;
		[Embed("../../../../config/family_add_member.cfg", mimeType="application/octet-stream")]
		private const FamilyAddMemberClass:Class;
		[Embed("../../../../config/find_treasure.cfg", mimeType="application/octet-stream")]
		private const FindTreasure:Class;
		[Embed("../../../../config/find_treasure_shop.cfg", mimeType="application/octet-stream")]
		private const FindTreasureShop:Class;
		[Embed("../../../../config/find_treasure_gift.cfg", mimeType="application/octet-stream")]
		private const FindTreasureGift:Class;
		[Embed("../../../../config/activity_sea_side.cfg", mimeType="application/octet-stream")]
		private const ActivitySeaSideClass:Class;
		[Embed("../../../../config/activity_longcheng.cfg", mimeType="application/octet-stream")]
		private const ActivityLoongWar:Class;
		[Embed("../../../../config/longcheng_activity_reward.cfg", mimeType="application/octet-stream")]
		private const ActivityLoongWarReward:Class;
		[Embed("../../../../config/activity_master_worship.cfg", mimeType="application/octet-stream")]
		private const ActivityWorship:Class;
		[Embed("../../../../config/god_magic_weapon.cfg", mimeType="application/octet-stream")]
		private const ArtifactClass:Class;
		[Embed("../../../../config/level_gift.cfg", mimeType="application/octet-stream")]
		private const LevelGiftClass:Class;
		[Embed("../../../../config/movie.cfg", mimeType="application/octet-stream")]
		private const MovieClass:Class;
		[Embed("../../../../config/sign_reward.cfg", mimeType="application/octet-stream")]
		private const signRewardClass:Class;
		[Embed("../../../../config/off_line_exp.cfg", mimeType="application/octet-stream")]
		private const offLineExpClass:Class;
		[Embed("../../../../config/off_line_exp_get.cfg", mimeType="application/octet-stream")]
		private const offLineExpGetClass:Class;
		[Embed("../../../../config/scene_effect.cfg", mimeType="application/octet-stream")]
		private const SceneEffectClass:Class;
		[Embed("../../../../config/become_strong.cfg", mimeType="application/octet-stream")]
		private const StrongerClass:Class;
		[Embed("../../../../config/task_trailer.cfg", mimeType="application/octet-stream")]
		private const TaskTrailerClass:Class;
		[Embed("../../../../config/trailer.cfg", mimeType="application/octet-stream")]
		private const TrailerClass:Class;
		[Embed("../../../../config/task_trailer_reward.cfg", mimeType="application/octet-stream")]
		private const TaskTrailerRewardClass:Class;
		[Embed("../../../../config/item_gift_random.cfg", mimeType="application/octet-stream")]
		private const ItemGiftRandomClass:Class;
		[Embed("../../../../config/item_gift.cfg", mimeType="application/octet-stream")]
		private const ItemGiftClass:Class;
		[Embed("../../../../config/equip_strengthen_suite.cfg", mimeType="application/octet-stream")]
		private const EquipStrengthenSuiteClass:Class;
		[Embed("../../../../config/equip_baptize_suite.cfg", mimeType="application/octet-stream")]
		private const EquipBaptizeSuiteClass:Class;
		[Embed("../../../../config/hero_reincarn_attr.cfg", mimeType="application/octet-stream")]
		private const HeroReincarnAttrClass:Class;
		[Embed("../../../../config/monster_group_drop.cfg", mimeType="application/octet-stream")]
		private const MonsterGroupDropClass:Class;
		[Embed("../../../../config/equip_suit_attr.cfg", mimeType="application/octet-stream")]
		private const EquipSuitAttrClass:Class;
		[Embed("../../../../config/activity_sea_side_gift.cfg", mimeType="application/octet-stream")]
		private const SeaSideGiftClass:Class;
		[Embed("../../../../config/world_level_exp.cfg", mimeType="application/octet-stream")]
		private const WorldLevelExpClass:Class;
		[Embed("../../../../config/world_level.cfg", mimeType="application/octet-stream")]
		private const WorldLevelClass:Class;
		[Embed("../../../../config/world_level_monster.cfg", mimeType="application/octet-stream")]
		private const WorldLevelMonsterClass:Class;
        [Embed("../../../../config/family_shop.cfg", mimeType="application/octet-stream")]
        private const SchoolShop:Class;
        [Embed("../../../../config/collect_reward.cfg", mimeType="application/octet-stream")]
        private const CollectReward:Class;
		[Embed("../../../../config/online_reward_shield.cfg", mimeType="application/octet-stream")]
		private const OnlineRewardShield:Class;
        [Embed("../../../../config/first_pay_reward.cfg", mimeType="application/octet-stream")]
        private const FirstPayReward:Class;
        [Embed("../../../../config/fifty_online_reward.cfg", mimeType="application/octet-stream")]
        private const FifteenReward:Class;
        [Embed("../../../../config/daily_pay_reword.cfg", mimeType="application/octet-stream")]
        private const DailyPayReward:Class;
		[Embed("../../../../config/special_preference_reword.cfg", mimeType="application/octet-stream")]
		private const CheapReward:Class;
		[Embed("../../../../config/level_competitive_reword.cfg", mimeType="application/octet-stream")]
		private const LevelMatchReward:Class;
		[Embed("../../../../config/all_boss_reword.cfg", mimeType="application/octet-stream")]
		private const AllBossReward:Class;
		[Embed("../../../../config/zhenyaota_map.cfg", mimeType="application/octet-stream")]
		private const demonTowerClass:Class;
		[Embed("../../../../config/broadcast.cfg", mimeType="application/octet-stream")]
		private const BroadcastClass:Class;
        [Embed("../../../../config/stone_exchange_shop.cfg", mimeType="application/octet-stream")]
        private const StoneExChangeShop:Class;
        [Embed("../../../../config/stone_exchange_shop_group_item.cfg", mimeType="application/octet-stream")]
        private const StoneExChangeShopItem:Class;

        [Embed("../../../../config/wing_upgrade.cfg", mimeType="application/octet-stream")]
        private const WingUpgrade:Class;
		[Embed("../../../../config/open_server_daily_reward.cfg", mimeType="application/octet-stream")]
		private const OSDR:Class;
		[Embed("../../../../config/open_server_journey_reward.cfg", mimeType="application/octet-stream")]
		private const OSJR:Class;
		[Embed("../../../../config/open_server_new_reward.cfg", mimeType="application/octet-stream")]
		private const OSNR:Class;
		[Embed("../../../../config/open_server_promote_reward.cfg", mimeType="application/octet-stream")]
		private const OSPR:Class;
		[Embed("../../../../config/open_server_reward.cfg", mimeType="application/octet-stream")]
		private const OSR:Class;
		
		[Embed("../../../../config/online_welfare.cfg", mimeType="application/octet-stream")]
		private const OnlineReward:Class;
		
		public function getAllConfigData():Vector.<ConfigDataItem>
		{
			var cfgInfos:Vector.<ConfigDataItem>,i:int,l:int;
			cfgInfos = new Vector.<ConfigDataItem>();
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMap,"id",mapClass,MapCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMstDrpGrp,"group_id,item_id",mstDrpGrpClass,DropGroupCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyLv,"level",levelClass,LevelCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMapPlant,"id",mapPlantClass,MapPlantCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMapVip,"id",mapVipClass,MapVipCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMapMst,"id",mapMstClass,MapMonsterCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyBoss,"monster_group_id",bossClass,BossCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMapBoss,"monster_group_id,map_monster_id",mapBossClass,MapBossCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMapRegion,"id",mapRegionClass,MapRegionCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMapTlpt,"map_from,id",mapTlptClass,MapTeleportCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMapTrap,"id",mapTrapClass,MapTrapCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMst,"id",monsterClass,MonsterCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyItem,"id",itemClass,ItemCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyExpYuAward,"id",expYuAwardClass,ExpYuAwardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquip,"id",equipClass,EquipCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTask,"id",taskClass,TaskCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyNpc,"mapid,id",npcClass,NpcCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySkill,"id",skillClass,SkillCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyNpcShop,"id",npcShopClass,NpcShopCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeon,"npc,id",dungeonClass,DungeonCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeonId,"id",dungeonClass,DungeonCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeonEvent,"dungeon_id,trigger_id",dungeonEventClass,DgnEventCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeonRewardEvaluate,"dungeon_id,star",dungeonRewardEvaluateClass,DgnRewardEvaluateCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeonRewardMultiple,"dungeon_id,multiple",dungeonRewardMultipleClass,DgnRewardMultipleCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeonEvent1,"dungeon_id,step",dungeonEventClass,DgnEventCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeonShop,"dungeon_id,item_id",dungeonShopClass,DgnShopCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeonRewardCardGroup,"group_id,id",dungeonRewardCardGroupClass,DgnRewardCardGroupCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDungeonRewardCardGold,"num",dungeonRewardCardGoldClass,DgnRewardCardGoldCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.npcTeleport,"id",npcTeleportClass,NpcTeleportCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyPlant,"id",plantClass,PlantCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipStrengthen,"level",equipStrengthenClass,EquipStrengthenCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyEquipDuiJieSuit,"id",equipDuijieSuitClass,EquipDuijieSuitCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyCloset,"type,level",closetClass,ClosetCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipStrengthenAttr,"type,level",equipStrengthenAttrClass,EquipStrengthenAttrCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipRecycle,"type,quality,level",equipRecycleClass,EquipRecycleCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipRecycleReward,"level_max,index",equipRecycleRewardClass,EquipRecycleRwdCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTaskStarReward,"level,task_type",taskStarRewardClass,TaskStarRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTaskStarRate,"star",taskStarRateClass,TaskStarRateCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTaskStarCost,"rate",taskStarCostClass,TaskStarCostCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTaskWantCost,"task_id,level",taskWantCostClass,TaskWantCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTaskWantedDailyReward,"index",taskWantedDailyRewardClass,TaskWantedDailyRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipDegree,"id",equipDegreeClass,EquipDegreeCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipResolve,"id",equipResolveClass,EquipResolveCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEntityLayer,"action,dir,frame",entityLayerClass,EntityLayerCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyQuality,"quality",qualityClass,QualityCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTrap,"id",trapClass,TrapCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMail,"id",mailClass,MailCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyItemType,"id",itemTypeClass,ItemTypeCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipExchange,"id",equipExchangeClass,EquipExchangeCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipExchangeNext,"next_id",equipExchangeClass,EquipExchangeCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyUselessSell,"level,world_level,index",uselessSellClass,UselessSellCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyPeerage,"id",peerageClass,PeerageCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyPeerageDesc,"id,index",peerageDescClass,PeerageDescCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyVip,"level",vipClass,VipCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySpecialRing,"id",specialRingClass,SpecialRingCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySpecialLevelRing,"ring_id,level",specialRingLevelClass,SpecialRingLevelCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyBuff,"id",buffClass,BuffCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySpecialDungeonRing,"cell",specialRingDungeonClass,SpecialRingDungeonCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDaily,"id",dailyClass,DailyCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDaily1,"order",dailyClass,DailyCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDailyVitReward,"order",dailyVitRewardClass,DailyVitRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyDailyVitReward1,"daily_vit",dailyVitRewardClass,DailyVitRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivity,"id",activityClass,ActivityCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivity1,"npc",activityClass,ActivityCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivityEvent,"activity_id,trigger_id",activityEventClass,ActivityEventCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivityTime,"id,index",activityTimeClass,ActivityTimeCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivityMapRegion,"activity_id,index",activityMapRegionClass,ActivityMapRegionCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyMstDig,"monster_id,time",mstDigClass,MstDigCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyCombine,"type,id",combineClass,CombineCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyJob,"id",jobClass,JobCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyHeroEquipUpgrade,"grade,order",heroEquipUpgrad,HeroEquipUpgradeCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyHeroUpgrade,"grade_level",heroGrade,HeroGradeCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyHeroMeridians,"grade_level,meridians_level",heroMeridians,HeroMeridiansCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyPet,"id",petClass,PetCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyGuide,"id",guideClass,GuideCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyUnlock,"id",unlockClass,UnlockCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyAttr,"attr_type",attrClass,AttrCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyAchievement, "achievement_id", achievementClass, AchievementCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyAchievementGroup, "type", achievementGroupClass, AchievementGroupCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyReinCarn,"reincarn",reinCarnClass,ReinCarnCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipPolish,"level",equipPolishClass,EquipPolishCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipPolishAttr,"type,level",equipPolishAttrClass,EquipPolishAttrCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipRefined,"quality,level_min",equipRefinedClass,EquipRefinedCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipRefinedCost,"level_min",equipRefinedCostClass,EquipRefinedCostCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipRefinedSuite,"level",equipRefinedSuiteClass,EquipRefinedSuiteCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyJointHalo,"id,level",jointHaloClass,JointHaloCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyOnlineReward,"id",onlineRewardClass,OnlineRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyGameShop, "id", gameShopClass, GameShopCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyAnnouncement, "id", AnnouncementClass, AnnouncementCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyRuneTransform, "id", RuneTransformClass, RuneTransformCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyFamily, "id", FamilyClass, FamilyCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyPray, "type,pray_count", PrayClass, PrayCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyPosition, "level", PositionClass, PositionCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyPositionChop, "level", PositionChopClass, PositionChopCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySchoolPosition, "position",FamilyPositionClass,FamilyPositionCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySchoolAddMember, "number",FamilyAddMemberClass,FamilyAddMemberCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyFindTreasure, "id", FindTreasure, TreasureCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyFindTreasureShop, "id", FindTreasureShop, TreasureShopCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivitySeaSide, "id", ActivitySeaSideClass, ActivitySeaFeastCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivityLoongWar, "id", ActivityLoongWar, ActivityLoongWarCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivityLoongWarReward, "id", ActivityLoongWarReward, ActivityLoongWarRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyActivityMasterWorship, "id", ActivityWorship, ActivityWorshipCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyArtifact, "type,part,equipid", ArtifactClass, ArtifactCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyLevelGift, "index", LevelGiftClass, LevelGiftCfgData));	
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyMovie, "movie_id,id", MovieClass, MovieCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySceneEffect, "id", SceneEffectClass, SceneEffectCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySignReward, "month,count", signRewardClass, SignRewardData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyOffLineExp, "level", offLineExpClass, OffLineExp));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyOffLineExpGet, "max_off_line", offLineExpGetClass, OffLineExpGet));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyFindTreasureShopGift, "id,item_id", FindTreasureGift, TreasureGiftCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyStronger, "type,title,name", StrongerClass, StrongerCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTaskTrailer, "quality", TaskTrailerClass, TaskTrailerCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyTrailer, "id", TrailerClass, TrailerCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyTrailerReward, "level",TaskTrailerRewardClass, TaskTrailerRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyItemGiftRandom, "id,item_id",ItemGiftRandomClass, ItemGiftRandomCfg));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyItemGift, "id,item_id",ItemGiftClass, ItemGiftCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyStrengthSuite, "level",EquipStrengthenSuiteClass,EquipStrengthenSuiteCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyBaptizeSuite, "level",EquipBaptizeSuiteClass,EquipBaptizeSuiteCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyReincarinSuite, "level",HeroReincarnAttrClass,HeroReincarnAttrCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyMonsterGroupDropClass, "monster_id,group_id",MonsterGroupDropClass,MonsterGroupDropCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keySeaSideGift, "item_id", SeaSideGiftClass, SeaFeastGift));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyEquipSuit, "quality,suit_type", EquipSuitAttrClass, EquipSuitAttrCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyWorldLevel, "world_level", WorldLevelClass, WorldLevelCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyWorldLevel, "open_day", WorldLevelClass, WorldLevelCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyWorldLevelExp, "world_level", WorldLevelExpClass, WorldLevelExpCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyWorldLevelMonster, "boss_group_id", WorldLevelMonsterClass, WorldLevelMonsterCfgData));
            cfgInfos.push(new ConfigDataItem(ConfigType.KeySchoolShop, "id", SchoolShop, SchoolShopCfgData));
            cfgInfos.push(new ConfigDataItem(ConfigType.KeyKeepGame, "id", CollectReward, KeepRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyOnlineRewardShield, "id", OnlineRewardShield, OnlineRewardShieldCfgData));
            cfgInfos.push(new ConfigDataItem(ConfigType.KeyFirstChargeReward, "id", FirstPayReward, FirstChargeRewardCfgData));
            cfgInfos.push(new ConfigDataItem(ConfigType.KeyFifteenReward, "day", FifteenReward, LoginRewardCfgData));
            cfgInfos.push(new ConfigDataItem(ConfigType.KeyEveryDayReward, "id", DailyPayReward, EveryDayRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyCheapReward, "id", CheapReward, SpecialPreferenceRewordCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyLevelMatchReward, "id", LevelMatchReward, LevelCompetitiveRewordCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyDemonTower, "id", demonTowerClass, DemonTowerCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyAllBossReward, "id", AllBossReward, AllBossRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyBroadcast, "id", BroadcastClass, BroadcastCfgData));
            cfgInfos.push(new ConfigDataItem(ConfigType.KeyExchangeShop, "id", StoneExChangeShop, StoneExchangeShopCfgData));
            cfgInfos.push(new ConfigDataItem(ConfigType.KeyExchangeShopItem, "group_id,index", StoneExChangeShopItem, StoneExchangeShopItemCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyWingUpgrade, "id", WingUpgrade, WingUpgradeCfgData));
            cfgInfos.push(new ConfigDataItem(ConfigType.KeyOSDR, "day,index", OSDR, OpenServerDailyRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyOSJR, "day,index", OSJR, OpenServerJourneyRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyOSNR, "day,index", OSNR, OpenServerNewRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyOSPR, "day,index", OSPR, OpenServerPromoteRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyOSR, "id", OSR, OpenServerRewardCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyOnlineWelfare,"id",OnlineReward,OnlineWelfareCfgData));
			return cfgInfos;
		}
	}
}