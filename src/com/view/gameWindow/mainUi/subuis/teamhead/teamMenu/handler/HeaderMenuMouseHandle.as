package com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.handler
{
import com.model.consts.StringConst;
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.McHeaderMenu;
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.MenuTeamHeader;
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.event.TeamMenuEvent;

import flash.events.MouseEvent;

/**
 * Created by Administrator on 2014/11/17.
 */
public class HeaderMenuMouseHandle
{
    public function HeaderMenuMouseHandle(menu:MenuTeamHeader)
    {
        this._menu = menu;
        this._menu.skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    private var _menu:MenuTeamHeader;

    public function destroy():void
    {
        if (_menu)
        {
            _menu.skin.removeEventListener(MouseEvent.CLICK, onClick);
            _menu = null;
        }
    }

    private function dispatchRequest(params:String):void
    {
        var evt:TeamMenuEvent = new TeamMenuEvent(TeamMenuEvent.SELECT_MENU_ITEM, params);
        TeamMenuEvent.dispatchEvent(evt);
        evt = null;
    }

    private function onClick(event:MouseEvent):void
    {
        var skin:McHeaderMenu = _menu.skin as McHeaderMenu;
        var param:String;
        switch (event.target)
        {
            default :
                break;
            case skin.item0:
                param = StringConst.TEAM_MENU_00001;
                break;
            case skin.item1:
                param = StringConst.TEAM_MENU_00002;
                break;
            case skin.item2:
                param = StringConst.TEAM_MENU_00003;
                break;
            case skin.item3:
                param = StringConst.TEAM_MENU_00004;
                break;
            case skin.item4:
                param = StringConst.TEAM_MENU_00005;
                break;
            case skin.item5:
                param = StringConst.TEAM_MENU_00006;
                break;
        }
        if (param != null)
        {
            dispatchRequest(param);
        }
    }
}
}
