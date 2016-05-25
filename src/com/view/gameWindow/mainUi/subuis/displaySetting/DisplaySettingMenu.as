package com.view.gameWindow.mainUi.subuis.displaySetting
{
    import com.view.gameWindow.mainUi.subuis.common.MenuCheck;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2014/12/29.
     */
    public class DisplaySettingMenu extends MenuCheck
    {
        public function DisplaySettingMenu()
        {
            super();
        }

        override protected function addEvent():void
        {
            addEventListener(MouseEvent.ROLL_OUT, onRollHandler, false, 0, true);
        }

        private function onRollHandler(event:MouseEvent):void
        {
            visible = false;
        }

        override public function destroy():void
        {
            removeEventListener(MouseEvent.ROLL_OUT, onRollHandler);
            super.destroy();
        }
    }
}
