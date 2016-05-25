package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;

    /**
     * Created by Administrator on 2015/1/27.
     */
    public class TeamSetLeaderAlert extends AlertCellBase
    {
        public function TeamSetLeaderAlert()
        {
            super();
        }

        override protected function getIconUrl():String
        {
            return "mainUiBottom/teamInvite.swf";
        }


        override protected function getTipStr():String
        {
            return StringConst.TEAM_ERROR_00025;
        }
    }
}
