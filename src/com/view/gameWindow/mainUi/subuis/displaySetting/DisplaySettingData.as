package com.view.gameWindow.mainUi.subuis.displaySetting
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subuis.common.CheckItemBase;
    import com.view.gameWindow.mainUi.subuis.displaySetting.item.DisplaySettingItem;

    /**
     * Created by Administrator on 2014/12/27.
     */
    public class DisplaySettingData
    {
        private const MENU_SIZE:int = 14;
        private var _datas:Array;
        private var _ids:Array;
        private var _values:Array;

        public function DisplaySettingData()
        {
            _datas = [];
            initialize();
        }

        private function initialize():void
        {
            _values = [];
            _ids = [
                DisplaySettingConst.HIDE_ALL, DisplaySettingConst.HIDE_OTHER_PLAYER, DisplaySettingConst.HIDE_OTHER_HERO, DisplaySettingConst.HIDE_ALL_MONSTER,
                DisplaySettingConst.HIDE_ALL_SKILL_EFFECT, DisplaySettingConst.HIDE_MONSTER_EFFECT, DisplaySettingConst.HIDE_FIRE_WALL_EFFECT, DisplaySettingConst.HIDE_FACTION_NAME,
                DisplaySettingConst.HIDE_SAME_FACTION_MEMBER, DisplaySettingConst.HIDE_SAME_TEAM_MEMBER, DisplaySettingConst.HIDE_WING, DisplaySettingConst.HIDE_WEAPON_EFFECT,
                DisplaySettingConst.HIDE_OTHER_PLAYER_DESIGNATION, DisplaySettingConst.NAME_IN_MIDDLE
            ];
            for (var i:int = 0; i < MENU_SIZE; i++)
            {
                _values[i] = StringConst["DISPLAY_SETTING_" + (i + 1)];
                createItem(i, _values[i]);
            }
        }

        private function createItem(key:int, value:String):void
        {
            var item:CheckItemBase = _datas[key] as CheckItemBase;
            if (!item)
            {
                item = new DisplaySettingItem();
                item.id = _ids[key];
                item.label = value;
            }
            _datas[key] = item;
        }

        public function get datas():Array
        {
            if (_datas.length == 0)
            {
                initialize();
            }
            return _datas;
        }
    }
}
