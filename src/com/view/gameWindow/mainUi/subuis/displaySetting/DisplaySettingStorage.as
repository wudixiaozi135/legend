package com.view.gameWindow.mainUi.subuis.displaySetting
{
    import com.view.selectRole.SelectRoleDataManager;

    import flash.net.SharedObject;

    /**
     * Created by Administrator on 2015/2/7.
     */
    public class DisplaySettingStorage
    {
        public function DisplaySettingStorage()
        {
        }

        public static function updateData(data:DisplaySettingStorageData):void
        {
            var key:String = SelectRoleDataManager.getInstance().selectCid.toString();
            var so:SharedObject = SharedObject.getLocal(key, "/");
            if (so)
            {
                so.data.display = data;
                so.flush();
            }
        }

        public static function getDisplayData():Object
        {
            var key:String = SelectRoleDataManager.getInstance().selectCid.toString();
            var so:SharedObject = SharedObject.getLocal(key, "/");
            if (so)
            {
                return so.data.display;
            }
            return null;
        }
    }
}
