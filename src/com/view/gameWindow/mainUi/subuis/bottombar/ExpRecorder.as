package com.view.gameWindow.mainUi.subuis.bottombar
{
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;

    /**
     * Created by Administrator on 2015/3/18.
     * 缓存某个条件下的经验和等级变量
     */
    public class ExpRecorder
    {
        public static var record_exp:int;
        public static var record_lv:int;

        public function ExpRecorder()
        {
        }

        public static function storeData():void
        {
            record_exp = RoleDataManager.instance.exp;
            record_lv = RoleDataManager.instance.lv;
        }
    }
}
