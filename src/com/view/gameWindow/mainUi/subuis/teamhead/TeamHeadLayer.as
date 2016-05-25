package com.view.gameWindow.mainUi.subuis.teamhead
{
    import com.greensock.TweenMax;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.TeamMenuMediator;
    import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.menu.TeamMenuType;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.team.data.TeamInfoVo;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.selectRole.SelectRoleDataManager;
    
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
     * Created by Administrator on 2014/11/14.
     */
    public class TeamHeadLayer extends Sprite implements IObserver
    {
        private var _container:Sprite;
        private var _items:Vector.<TeamIconItem>;
        private var _leftBar:LeftBar;
        private var _mask:Shape;

        public function TeamHeadLayer()
        {
            super();
            _items = new Vector.<TeamIconItem>();
            TeamDataManager.instance.attach(this);
            TeamMenuMediator.instance;
        }
		
		public function initView():void
        {
            mouseEnabled = false;
            _container = new Sprite();
            _container.mouseEnabled = false;
            addChild(_container);
            _leftBar = new LeftBar();
            addEvent(_leftBar);
            _container.addChild(_leftBar);
            _leftBar.y = 10;

            initData();
        }

        public function refresh():void
        {

            if (!_leftBar.skin)
            {
                _leftBar.initView();
            }
            var dataManager:TeamDataManager = TeamDataManager.instance;
            if (_leftBar)
            {
                _leftBar.visible = dataManager.hasTeam;
            }

            _items.forEach(function (element:TeamIconItem, index:int, vec:Vector.<TeamIconItem>):void
            {
                element.visible = false;
            });


            var teamVec:Vector.<TeamInfoVo> = filter(dataManager.teamInfoVec);
            for (var i:int = 0, len:int = teamVec.length; i < len; i++)
            {
                var vo:TeamInfoVo = teamVec[i];
                if (i < _items.length)
                {
                    var item:TeamIconItem = _items[i];
                    item.teamInfo = vo;
                    item.visible = true;
                }
            }
            adjustPosition();
        }

        public function update(proc:int = 0):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_TEAM_INFO:
                    refresh();
                    break;
                case GameServiceConstants.SM_KICKED_FROM_TEAM://被踢除者收到报文
                    Alert.message(StringConst.TEAM_ERROR_0008);
                    leaveRefresh();
                    break;
                case GameServiceConstants.SM_TEAM_DIMISSED://队伍解散
                    dismissRefresh();
                    break;
                case GameServiceConstants.CM_TEAM_DISMISS:
                    dismissRefresh();
                    break;
                case GameServiceConstants.CM_LEAVE_TEAM:
                    leaveTeamHandler();
                    break;
                default :
                    break;
            }
        }

        private function filter(vec:Vector.<TeamInfoVo>):Vector.<TeamInfoVo>
        {
            var newVec:Vector.<TeamInfoVo> = new Vector.<TeamInfoVo>();
            var mgt:SelectRoleDataManager = SelectRoleDataManager.getInstance();
            for each(var item:TeamInfoVo in vec)
            {
                if ((item.cid != mgt.selectCid) && (item.sid == mgt.selectSid))
                {
                    newVec.push(item);
                }
            }
            return newVec;
        }

        private function addEvent(_leftBar:LeftBar):void
        {
            /**解散队伍*/
            _leftBar.dismissHandler = function (mc:MovieClip):void
            {
                if (!TeamDataManager.instance.isHeader)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TEAM_ERROR_0001);
                    return;
                }
                var byte:ByteArray = new ByteArray();
                byte.endian = Endian.LITTLE_ENDIAN;
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_TEAM_DISMISS, byte);
            };
            _leftBar.leaveHandler = function (mc:MovieClip):void
            {
                var cid:int = SelectRoleDataManager.getInstance().selectCid;
                var sid:int = SelectRoleDataManager.getInstance().selectSid;
                var data:ByteArray = new ByteArray();
                data.endian = Endian.LITTLE_ENDIAN;
                data.writeInt(cid);
                data.writeInt(sid);
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LEAVE_TEAM, data);
            };
            _leftBar.toggleHandler = function (mc:MovieClip):void
            {
                if (mc.selected)
                {//left
                    TweenMax.to(_mask, .5, {
                        width: 30, onComplete: function ():void
                        {
                            TweenMax.killTweensOf(_mask);
                        }
                    });
                    _container.mask = _mask;
                } else
                {
                    TweenMax.to(_mask, .5, {
                        width: 510, onComplete: function ():void
                        {
                            TweenMax.killTweensOf(_mask);
                        }
                    });
                    _container.mask = _mask;
                }
            };
        }

        private function itemClickHandler(item:TeamIconItem):void
        {
            var mc:Sprite = item.menuLayer;
            if (TeamDataManager.instance.isHeader)
            {
                TeamMenuMediator.instance.showInParentWindow(this, TeamMenuType.MENU_HEADER, item.teamInfo);
            } else
            {
                TeamMenuMediator.instance.showInParentWindow(this, TeamMenuType.MENU_MEMBER, item.teamInfo);
            }
        }

        private function initData():void
        {
            _items.length = 0;
            for (var i:int = 0; i < 5; i++)
            {
                var item:TeamIconItem = new TeamIconItem();
                item.visible = false;
                item.clickHandler = itemClickHandler;
                _items.push(item);
                _container.addChild(item);
            }

            _mask = new Shape();
            _mask.graphics.beginFill(0x00, 0);
            _mask.graphics.drawRect(0, 0, 510, 100);
            _container.addChild(_mask);
        }

        private function adjustPosition():void
        {
            for (var i:int = 0, len:int = _items.length; i < len; i++)
            {
                var item:TeamIconItem = _items[i];
                item.x = 30 + (item.width + 5) * i;
            }
        }

        private function dismissRefresh():void
        {
            var dataManager:TeamDataManager = TeamDataManager.instance;
            dataManager.teamInfoVec.length = 0;
            refresh();
        }

        private function leaveRefresh():void
        {
            var dataManager:TeamDataManager = TeamDataManager.instance;
            dataManager.teamInfoVec.length = 0;
            refresh();
        }

        private function leaveTeamHandler():void
        {
            TeamDataManager.instance.teamInfoVec.length = 0;
            refresh();
        }

    }
}

import com.view.gameWindow.mainUi.MainUi;
import com.view.gameWindow.mainUi.subclass.McTeamLeft;

import flash.events.MouseEvent;

class LeftBar extends MainUi
{
    private var _dismissHandler:Function;
    private var _leaveHandler:Function;
    private var _toggleHandler:Function;

    override public function initView():void
    {
        _skin = new McTeamLeft();
        addChild(_skin);
        super.initView();
        _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    private function onClick(event:MouseEvent):void
    {
        var skin:McTeamLeft = _skin as McTeamLeft;
        switch (event.target)
        {
            case skin.dismissBtn:
                if (dismissHandler != null)
                {
                    dismissHandler(skin.dismissBtn);
                }
                break;
            case skin.leaveBtn:
                if (leaveHandler != null)
                {
                    leaveHandler(skin.leaveBtn);
                }
                break;
            case skin.toggleBtn:
                if (toggleHandler != null)
                {
                    toggleHandler(skin.toggleBtn);
                }
                break;
            default :
                break;
        }
    }

    public function get dismissHandler():Function
    {
        return _dismissHandler;
    }

    public function set dismissHandler(value:Function):void
    {
        _dismissHandler = value;
    }

    public function get leaveHandler():Function
    {
        return _leaveHandler;
    }

    public function set leaveHandler(value:Function):void
    {
        _leaveHandler = value;
    }

    public function get toggleHandler():Function
    {
        return _toggleHandler;
    }

    public function set toggleHandler(value:Function):void
    {
        _toggleHandler = value;
    }
}