package com.view.gameWindow.mainUi.subuis.displaySetting
{
    /**
     * Created by Administrator on 2014/12/29.
     */
    public class DisplaySettingHandlers
    {
        private var _hideAll:Boolean = false;//隐藏全部
        private var _hideOtherPlayer:Boolean = false;//隐藏其他玩家
        private var _hideOtherHero:Boolean = false;//隐藏其他英雄
        private var _hideAllMonster:Boolean = false;//隐藏所有怪物
        private var _hideAllSkillEffect:Boolean = false;//隐藏全部技能特效
        private var _hideMonsterSkillEffect:Boolean = false;//隐藏怪物技能特效
        private var _hideFireWallEffect:Boolean = false;//隐藏火墙特效
        private var _hideFactionName:Boolean = false;//隐藏帮会名称
        private var _hideSameFactionMember:Boolean = false;//隐藏同帮成员
        private var _hideSameTeamMember:Boolean = false;//隐藏同组成员
        private var _hideWing:Boolean = false;//隐藏羽翼
        private var _hideOtherWeaponEffect:Boolean = false;//隐藏其他武器特效
        private var _hideOtherPlayerDesignation:Boolean = false;//隐藏其他玩家称号
        private var _nameInBody:Boolean = false;//名字置于中间
        private var _displayData:DisplaySettingStorageData;
        public function DisplaySettingHandlers()
        {
            _displayData = new DisplaySettingStorageData();
        }

        public function checkDisplaySettingState():void
        {
            var state:Boolean;
            var manager:DisplaySettingManager = DisplaySettingManager.instance;

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_ALL);
            if (_hideAll != state)
            {
                _hideAll = state;
                _displayData.hide_1 = _hideAll;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_OTHER_PLAYER);
            if (_hideOtherPlayer != state)
            {
                _hideOtherPlayer = state;
                _displayData.hide_2 = _hideOtherPlayer;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_OTHER_HERO);
            if (_hideOtherHero != state)
            {
                _hideOtherHero = state;
                _displayData.hide_3 = _hideOtherHero;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_ALL_MONSTER);
            if (_hideAllMonster != state)
            {
                _hideAllMonster = state;
                _displayData.hide_4 = _hideAllMonster;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_ALL_SKILL_EFFECT);
            if (_hideAllSkillEffect != state)
            {
                _hideAllSkillEffect = state;
                _displayData.hide_5 = _hideAllSkillEffect;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_MONSTER_EFFECT);
            if (_hideMonsterSkillEffect != state)
            {
                _hideMonsterSkillEffect = state;
                _displayData.hide_6 = _hideMonsterSkillEffect;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_FIRE_WALL_EFFECT);
            if (_hideFireWallEffect != state)
            {
                _hideFireWallEffect = state;
                _displayData.hide_7 = _hideFireWallEffect;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_FACTION_NAME);
            if (_hideFactionName != state)
            {
                _hideFactionName = state;
                _displayData.hide_8 = _hideFactionName;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_SAME_FACTION_MEMBER);
            if (_hideSameFactionMember != state)
            {
                _hideSameFactionMember = state;
                _displayData.hide_9 = _hideSameFactionMember;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_SAME_TEAM_MEMBER);
            if (_hideSameTeamMember != state)
            {
                _hideSameTeamMember = state;
                _displayData.hide_10 = _hideSameTeamMember;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_WING);
            if (_hideWing != state)
            {
                _hideWing = state;
                _displayData.hide_11 = _hideWing;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_WEAPON_EFFECT);
            if (_hideOtherWeaponEffect != state)
            {
                _hideOtherWeaponEffect = state;
                _displayData.hide_12 = _hideOtherWeaponEffect;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.HIDE_OTHER_PLAYER_DESIGNATION);
            if (_hideOtherPlayerDesignation != state)
            {
                _hideOtherPlayerDesignation = state;
                _displayData.hide_13 = _hideOtherPlayerDesignation;
                manager.sendDisplaySetting(_displayData);
            }

            state = manager.getDisplaySettingState(DisplaySettingConst.NAME_IN_MIDDLE);
            if (_nameInBody != state)
            {
                _nameInBody = state;
                _displayData.hide_14 = _nameInBody;
                manager.sendDisplaySetting(_displayData);
            }
//            DisplaySettingStorage.updateData(_displayData);
        }

        private static var _instance:DisplaySettingHandlers = null;
        public static function get instance():DisplaySettingHandlers
        {
            if (_instance == null)
            {
                _instance = new DisplaySettingHandlers();
            }
            return _instance;
        }
    }
}
