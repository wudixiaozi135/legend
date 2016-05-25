package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;

    /**
     * Created by Administrator on 2015/1/27.
     */
    public class OthersApplyAlert extends AlertCellBase
    {
        private var _item:TeamApplyItem;

        public function OthersApplyAlert()
        {
            super();
            _item = new TeamApplyItem();
			skin.addChild(_item);
        }
		
		override protected function getIconUrl():String
		{
			// TODO Auto Generated method stub
			var url:String="mainUiBottom/teamInvite.swf";
			return url;
		}

        public function refreshNum(count:int):void
        {
            if (_item)
            {
                _item.refreshNum(count);
            }
        }

        override protected function getTipStr():String
        {
            return StringConst.TEAM_ERROR_00025;
        }

        override public function destroy():void
        {
            if (_item && contains(_item))
            {
                skin.removeChild(_item);
                _item.destroy();
                _item = null;
            }
        }
    }
}

import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.iconAlert.IconAlertBase;

class TeamApplyItem extends IconAlertBase
{

    public function TeamApplyItem()
    {
        initView();
    }

}