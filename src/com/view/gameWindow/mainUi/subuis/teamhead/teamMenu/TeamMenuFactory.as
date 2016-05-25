package com.view.gameWindow.mainUi.subuis.teamhead.teamMenu
{
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.menu.ITeamMenu;
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.menu.TeamMenuType;

/**
 * Created by Administrator on 2014/11/17.
 */
public class TeamMenuFactory
{

    private static var _instance:TeamMenuFactory = null;

    public static function get instance():TeamMenuFactory
    {
        if (_instance == null)
        {
            _instance = new TeamMenuFactory();
        }
        return _instance;
    }

    public function TeamMenuFactory()
    {
    }

    public function getMenu(type:int):ITeamMenu
    {
        if (type == TeamMenuType.MENU_HEADER)
        {
            return new MenuTeamHeader();
        } else if (type == TeamMenuType.MENU_MEMBER)
        {
            return new MenuTeamMember();
        }
        return null;
    }
}
}
