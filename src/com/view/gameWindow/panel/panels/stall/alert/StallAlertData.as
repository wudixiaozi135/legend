package com.view.gameWindow.panel.panels.stall.alert
{
    /**
     * Created by Administrator on 2015/1/21.
     */
    public class StallAlertData
    {
        public static var content:String;
        public static var btnFunc:Function;
        public static var funcParam:Object;

        public function StallAlertData()
        {
        }

        public static function destroy():void
        {
            content = null;
            btnFunc = null;
            funcParam = null;
        }
    }
}
