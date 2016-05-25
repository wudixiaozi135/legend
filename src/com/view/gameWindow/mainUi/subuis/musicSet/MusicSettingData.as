package com.view.gameWindow.mainUi.subuis.musicSet
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subuis.musicSet.item.MusicItem;

    /**
     * Created by Administrator on 2014/12/27.
     */
    public class MusicSettingData
    {
        private const MENU_SIZE:int = 4;
        private var _datas:Array;
        private var _ids:Array;
        private var _values:Array;
        public function MusicSettingData()
        {
            _datas = [];
            initialize();
        }

        private function initialize():void
        {
            _values = [StringConst.MUSIC_SETTING_1, StringConst.MUSIC_SETTING_2, StringConst.MUSIC_SETTING_3, StringConst.MUSIC_SETTING_4];
            _ids = [MusicConst.BASIC_MUSIC, MusicConst.SKILL_MUSIC, MusicConst.MONSTER_MUSIC, MusicConst.BG_MUSIC];
            for (var i:int = 0; i < MENU_SIZE; i++)
            {
                createItem(i, _values[i]);
            }
        }

        private function createItem(key:int, value:String):void
        {
            var item:MusicItem = _datas[key] as MusicItem;
            if (!item)
            {
                item = new MusicItem();
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
