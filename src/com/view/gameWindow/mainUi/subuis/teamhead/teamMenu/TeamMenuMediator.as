package com.view.gameWindow.mainUi.subuis.teamhead.teamMenu
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.StringConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.event.TeamMenuEvent;
    import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.menu.ITeamMenu;
    import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.menu.TeamMenuType;
    import com.view.gameWindow.panel.panels.friend.ContactDataManager;
    import com.view.gameWindow.panel.panels.friend.ContactType;
    import com.view.gameWindow.panel.panels.menus.handlers.MenuFuncs;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.team.data.TeamInfoVo;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.utils.StringUtil;

    /**
 * Created by Administrator on 2014/11/17.
 */
public class TeamMenuMediator extends Sprite
{
    private static var _instance:TeamMenuMediator = null;

    public static function get instance():TeamMenuMediator
    {
        if (_instance == null)
        {
            _instance = new TeamMenuMediator();
        }
        return _instance;
    }

    public function TeamMenuMediator()
    {
        TeamMenuEvent.addEventListener(TeamMenuEvent.SELECT_MENU_ITEM, onSelectMenuItem, false, 0, true);
    }

    private var _container:DisplayObjectContainer;
    private var _params:Object;
    private var _menu:ITeamMenu;
        private var _menuProxy:MainUi;
    public function showInParentWindow(parent:DisplayObjectContainer, type:int, arg:Object):void
    {
        _container = parent;
        _params = arg;
        _menu = TeamMenuFactory.instance.getMenu(type);
        if (type == TeamMenuType.MENU_HEADER)
        {
            _menuProxy = _menu as MenuTeamHeader;
        } else if (type == TeamMenuType.MENU_MEMBER)
        {
            _menuProxy = _menu as MenuTeamMember;
        }
        _container.addChild(_menuProxy);
        _menuProxy.addEventListener(MouseEvent.ROLL_OUT, hide);

        var point:Point = parent.globalToLocal(new Point(parent.stage.mouseX, parent.stage.mouseY));
        _menu.position(point.x - 10, point.y - 10);
    }

    /**添加好友*/
    private function addFriend():void
    {
        var info:TeamInfoVo = _params as TeamInfoVo;
        if (info)
        {
            ContactDataManager.instance.requestAddContact(info.sid, info.cid, ContactType.FRIEND);
        }
    }

    /**查看信息*/
    private function viewPlayerInfo():void
    {
        var info:TeamInfoVo = _params as TeamInfoVo;
        if (info)
        {
            TeamDataManager.instance.viewOtherPlayerInfo(info.cid, info.sid);
        }
    }

    /**交易*/
    private function trade():void
    {

    }

    /**私聊*/
    private function closeChat():void
    {
        var info:TeamInfoVo = _params as TeamInfoVo;
        MenuFuncs.toPrivateTalk(info.sid, info.cid, info.name);
    }

    private function setLeader():void
    {
        var info:TeamInfoVo = _params as TeamInfoVo;
        if (info.cid == TeamDataManager.instance.headerCid && info.sid == TeamDataManager.instance.headerSid)
        {
            Alert.warning(StringConst.TEAM_ERROR_0004);
            return;
        }
        var data:ByteArray = new ByteArray();
        data.endian = Endian.LITTLE_ENDIAN;
        var cid:int = info.cid;
        var sid:int = info.sid;

        data.writeInt(cid);//cid
        data.writeInt(sid);//sid
        ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SET_TEAM_LEADER, data);
        RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.TEAM_PANEL_00037, info.name));
    }

    private function kickTeam():void
    {
        var info:TeamInfoVo = _params as TeamInfoVo;
        if (info.cid == TeamDataManager.instance.headerCid && info.sid == TeamDataManager.instance.headerSid)
        {
            Alert.warning(StringConst.TEAM_ERROR_0005);
            return;
        }
        var cid:int = info.cid;
        var sid:int = info.sid;
        var data:ByteArray = new ByteArray();
        data.endian = Endian.LITTLE_ENDIAN;
        data.writeInt(cid);//cid
        data.writeInt(sid);//sid
        ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_KICK_FROM_TEAM, data);
    }

    private function onSelectMenuItem(event:TeamMenuEvent):void
    {
        var label:String = event._param as String;
        switch (label)
        {
            case StringConst.TEAM_MENU_00001:
                kickTeam();
                break;
            case StringConst.TEAM_MENU_00002:
                setLeader();
                break;
            case StringConst.TEAM_MENU_00003:
                closeChat();
                break;
            case StringConst.TEAM_MENU_00004:
                trade();
                break;
            case StringConst.TEAM_MENU_00005:
                viewPlayerInfo();
                break;
            case StringConst.TEAM_MENU_00006:
                addFriend();
                break;
            default :
                break;
        }
        if (label != null)
        {
            hide();
        }
    }

    private function hide(event:MouseEvent = null):void
    {
        if (_menuProxy.hasEventListener(MouseEvent.ROLL_OUT))
        {
            _menuProxy.removeEventListener(MouseEvent.ROLL_OUT, hide);
        }
        if (_container)
        {
            if (_menu) {
                _menu.destroy();
                if (_container.contains(_menu as MainUi)) {
                    _container.removeChild(_menu as MainUi);
                    _menu = null;
                }
            }
            _container = null;
        }
    }
}
}
