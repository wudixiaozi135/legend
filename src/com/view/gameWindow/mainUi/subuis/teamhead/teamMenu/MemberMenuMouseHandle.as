package com.view.gameWindow.mainUi.subuis.teamhead.teamMenu
{
import com.model.consts.StringConst;
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.event.TeamMenuEvent;

import flash.events.MouseEvent;

/**
 * Created by Administrator on 2014/11/17.
 */
public class MemberMenuMouseHandle
{
    public function MemberMenuMouseHandle(menu:MenuTeamMember)
    {
        this._menu = menu;
        this._menu.skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    private var _menu:MenuTeamMember;

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
        var skin:McMemberMenu = _menu.skin as McMemberMenu;
        var param:String;
        switch (event.target)
        {
            default :
                break;
            case skin.item0:
                param = StringConst.TEAM_MENU_00003;
                break;
            case skin.item1:
                param = StringConst.TEAM_MENU_00004;
                break;
            case skin.item2:
                param = StringConst.TEAM_MENU_00005;
                break;
            case skin.item3:
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
