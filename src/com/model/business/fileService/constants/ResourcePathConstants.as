package com.model.business.fileService.constants
{
public class ResourcePathConstants
{
    public static const POSTFIX_PNG:String = ".png";
    public static const POSTFIX_JPG:String = ".jpg";
    public static const POSTFIX_UNIT:String = ".unit";
    public static const POSTFIX_EFFECT:String = ".effect";
    public static const POSTFIX_SWF:String = ".swf";
    public static const POSTFIX_RD:String = ".rd";
    public static const POSTFIX_URL:String = ".url";
    public static var RES_SERVER_PATH:String = "";
    public static var IMAGE_MAP_FOLDER_LOAD:String;
    public static var IMAGE_LOADING_FOLDER_LOAD:String;
    public static var IMAGE_MAINUI_FOLDER_LOAD:String;
	public static var IMAGE_GUIDE_FOLDER_LOAD:String;
    public static var IMAGE_PANEL_FOLDER_LOAD:String;
    public static var IMAGE_TOOLTIP_FOLDER_LOAD:String;
    public static var IMAGE_ROLLTIP_FOLDER_LOAD:String;
    public static var IMAGE_ICON_ITEM_FOLDER_LOAD:String;
    public static var IMAGE_ICON_EQUIP_FOLDER_LOAD:String;
    public static var IMAGE_ICON_SKILL_FOLDER_LOAD:String;
    public static var IMAGE_ICON_BUFF_FOLDER_LOAD:String;
    public static var IMAGE_NPC_DUTY_FOLDER_LOAD:String;
	public static var IMAGE_POSITION_FOLDER_LOAD:String;
    public static var IMAGE_NPC_HEAD_HP_LOAD:String;
    public static var IMAGE_DAILY_FOLDER_LOAD:String;
    public static var IMAGE_BOSS_HEAD_LOAD:String;
    public static var IMAGE_BOSS_HEAD_ICON:String;
    public static var IMAGE_BOSS_TIP_HEAD_LOAD:String;
    public static var IMAGE_CREATEROLE_FOLDER_LOAD:String;
    public static var IMAGE_SELECTROLE_FOLDER_LOAD:String;
    public static var IMAGE_EFFECT_FOLDER_LOAD:String;
    public static var IMAGE_NUMS_FOLDER_LOAD:String;
    public static var IMAGE_TASK_BOSS_LOAD:String;
    public static var IMAGE_UNLOCK_FOLDER_LOAD:String;
    public static var IMAGE_PANEL_TEAM_LOAD:String;
	public static var IMAGE_MOUSEEFFECT_LOAD:String;
    public static var ENTITY_RES_PLAYER_LOAD:String;
    public static var ENTITY_RES_HAIR_LOAD:String;
    public static var ENTITY_RES_EQUIP_LOAD:String;
	public static var ENTITY_RES_EQUIP_EFFETCT_LOAD:String;
    public static var ENTITY_RES_MONSTER_LOAD:String;
    public static var ENTITY_RES_NPC_LOAD:String;
    public static var ENTITY_RES_OTHER_LOAD:String;
    public static var ENTITY_RES_PLANT_LOAD:String;
    public static var ENTITY_RES_TRAP_LOAD:String;
	public static var ENTITY_RES_TRAILER_LOAD:String;
    public static var EFFECT_RES_LOAD:String;
	public static var VOICE_EFFECT_LOAD:String;
	public static var IMAGE_ANNOUCEMENT_LOAD:String;
	public static var IMAGE_SPECIAL_PREFERENCE_REWARD_LOAD:String;

    public static function initServerPath(path:String):void
    {
        RES_SERVER_PATH = path;
    }

    public static function initUrls():void
    {
        IMAGE_MAP_FOLDER_LOAD = RES_SERVER_PATH + "map/";
		IMAGE_LOADING_FOLDER_LOAD = RES_SERVER_PATH + "ui/loading/";
        IMAGE_MAINUI_FOLDER_LOAD = RES_SERVER_PATH + "ui/mainUi/";
		IMAGE_GUIDE_FOLDER_LOAD = RES_SERVER_PATH + "ui/guide/";
        IMAGE_TOOLTIP_FOLDER_LOAD = RES_SERVER_PATH + "ui/toolTip/";
        IMAGE_ROLLTIP_FOLDER_LOAD = RES_SERVER_PATH + "ui/rollTip/";
        IMAGE_PANEL_FOLDER_LOAD = RES_SERVER_PATH + "ui/panel/";
        IMAGE_CREATEROLE_FOLDER_LOAD = RES_SERVER_PATH + "ui/createrole/";
        IMAGE_SELECTROLE_FOLDER_LOAD = RES_SERVER_PATH + "ui/createrole/";
        IMAGE_EFFECT_FOLDER_LOAD = RES_SERVER_PATH + "ui/effect/";
        IMAGE_BOSS_HEAD_ICON = RES_SERVER_PATH + "images/head/monster/";
        IMAGE_TASK_BOSS_LOAD = IMAGE_PANEL_FOLDER_LOAD + "taskBoss/";
		IMAGE_POSITION_FOLDER_LOAD = RES_SERVER_PATH + "images/position/";
		IMAGE_SPECIAL_PREFERENCE_REWARD_LOAD = IMAGE_PANEL_FOLDER_LOAD+"openGift/";
        //
        IMAGE_NUMS_FOLDER_LOAD = RES_SERVER_PATH + "images/nums/";
        IMAGE_DAILY_FOLDER_LOAD = RES_SERVER_PATH + "images/daily/";
        IMAGE_BOSS_HEAD_LOAD = RES_SERVER_PATH + "images/boss/";
        IMAGE_BOSS_TIP_HEAD_LOAD = RES_SERVER_PATH + "images/boss/";
		IMAGE_MOUSEEFFECT_LOAD = RES_SERVER_PATH + "images/mouseEffect/";
        IMAGE_ICON_ITEM_FOLDER_LOAD = RES_SERVER_PATH + "images/icon/item/";
        IMAGE_ICON_EQUIP_FOLDER_LOAD = RES_SERVER_PATH + "images/icon/equip/";
        IMAGE_ICON_SKILL_FOLDER_LOAD = RES_SERVER_PATH + "images/icon/skill/";
        IMAGE_ICON_BUFF_FOLDER_LOAD = RES_SERVER_PATH + "images/icon/buff/";
        IMAGE_NPC_DUTY_FOLDER_LOAD = RES_SERVER_PATH + "images/npc/";
        IMAGE_NPC_HEAD_HP_LOAD = RES_SERVER_PATH + "ui/mainUi/headHp/";
		IMAGE_ANNOUCEMENT_LOAD = RES_SERVER_PATH + "ui/mainUi/annoucement/";
        IMAGE_UNLOCK_FOLDER_LOAD = RES_SERVER_PATH + "images/unlock/";
        IMAGE_PANEL_TEAM_LOAD = RES_SERVER_PATH + "ui/panel/team/";
        //
        ENTITY_RES_PLAYER_LOAD = RES_SERVER_PATH + "entity/player/";
        ENTITY_RES_HAIR_LOAD = RES_SERVER_PATH + "entity/player/";
		ENTITY_RES_EQUIP_LOAD = RES_SERVER_PATH + "entity/player/";
		ENTITY_RES_EQUIP_EFFETCT_LOAD = RES_SERVER_PATH + "entity/peffect/";
        ENTITY_RES_MONSTER_LOAD = RES_SERVER_PATH + "entity/monster/";
        ENTITY_RES_NPC_LOAD = RES_SERVER_PATH + "entity/npc/";
        ENTITY_RES_OTHER_LOAD = RES_SERVER_PATH + "entity/other/";
        ENTITY_RES_PLANT_LOAD = RES_SERVER_PATH + "entity/plant/";
        ENTITY_RES_TRAP_LOAD = RES_SERVER_PATH + "entity/trap/";

        EFFECT_RES_LOAD = RES_SERVER_PATH + "effect/";
		VOICE_EFFECT_LOAD = RES_SERVER_PATH + "sound/";
    }
}
}