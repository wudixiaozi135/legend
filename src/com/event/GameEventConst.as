package com.event
{
    /**
     * Created by Administrator on 2015/2/6.
     * 全局游戏事件常量
     */
    public class GameEventConst
    {
        /**东西进入背包事件
         * @param type 1角色 2背包 3技能 4帮会 5锻造 6官印 7神炉 8特戒 9英雄 10商城 11翅膀
         * */
        public static const THING_INTO_BAG_EFFECT:String = "thing_into_bag_effect";

        /**官印领取特效
         * @param int type:1 人物 2 英雄
         * */
        public static const POSITION_EFFECT:String = "position_effect";

        public static const EXP_INTO_BOTTOM:String = "exp_into_bottom";//回收装备经验

        public static const PK_MODE_EVENT:String = "pk_mode_event";//显示pk菜单

        public static const ICON_CHANGE:String = "icon_change";//icon显示状态发生改变
    }
}
