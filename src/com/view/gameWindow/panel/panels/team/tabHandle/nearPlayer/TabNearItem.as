package com.view.gameWindow.panel.panels.team.tabHandle.nearPlayer
{
    import com.model.consts.JobConst;
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.team.data.PlayerInfoVo;
    import com.view.gameWindow.panel.panels.team.data.TeamStatus;
    import com.view.gameWindow.panel.panels.team.tab.McNearListItem;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.utils.StringUtil;

    /**
 * Created by Administrator on 2014/11/10.
 */
public class TabNearItem extends Sprite
{
    public function TabNearItem()
    {
        _item = new McNearListItem();
        _item.mouseEnabled = false;
        mouseEnabled = true;

        addChild(_item);
        addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        addEventListener(MouseEvent.ROLL_OUT, onRollClick, false, 0, true);
        addEventListener(MouseEvent.ROLL_OVER, onRollClick, false, 0, true);
        addEventListener(Event.REMOVED, onRemove, false, 0, true);
    }

    private var _item:McNearListItem;

    public function get item():McNearListItem
    {
        return _item;
    }

        private var _player:PlayerInfoVo;

        public function get player():PlayerInfoVo
    {
        return _player;
    }

        public function set player(value:PlayerInfoVo):void
    {
        _player = value;
        item.txtVip.textColor = 0xb4b4b4;
        item.txtVip.text = StringConst.TIP_VIP + " " + _player.vip;

        item.txtPlayer.textColor = 0xb4b4b4;
        var dataManager:TeamDataManager = TeamDataManager.instance;
        if (_player.teamStatus == TeamStatus.TS_LEADER)
        {
            item.txtPlayer.text = _player.entityName + StringConst.TEAM_PANEL_00041;
        } else
        {
            item.txtPlayer.text = _player.entityName;
        }

        item.txtLv.textColor = 0xb4b4b4;
        item.txtLv.text = StringUtil.substitute(StringConst.TEAM_PANEL_00025, _player.reincarn, _player.level);

        item.txtJob.textColor = 0xb4b4b4;
        item.txtJob.text = JobConst.jobName(_player.job);

        if (_player.teamStatus)
        {
            item.txtStatus.textColor = 0x00ff00;
            item.txtStatus.text = _player.teamMemberCount + "/" + TeamDataManager.TOTAL_MEMBER;
        } else
        {
            item.txtStatus.textColor = 0xb4b4b4;
            item.txtStatus.text = StringConst.TEAM_PANEL_00026;
        }

        item.txtFaction.textColor = 0xb4b4b4;
        if (_player.familyId != 0)
        {
            item.txtFaction.text = _player.familyName;
        } else
        {
            item.txtFaction.text = StringConst.TEAM_PANEL_00024;
        }
    }

    private var _callBack:Function;

    public function get callBack():Function
    {
        return _callBack;
    }

    public function set callBack(value:Function):void
    {
        _callBack = value;
    }

    private var _rollOverClick:Function;

    public function get rollOverClick():Function
    {
        return _rollOverClick;
    }

    public function set rollOverClick(value:Function):void
    {
        _rollOverClick = value;
    }

    private var _rollOutClick:Function;

    public function get rollOutClick():Function
    {
        return _rollOutClick;
    }

    public function set rollOutClick(value:Function):void
    {
        _rollOutClick = value;
    }

    private var _clickHandle:Function;

    public function get clickHandle():Function
    {
        return _clickHandle;
    }

    public function set clickHandle(value:Function):void
    {
        _clickHandle = value;
    }

    public function destroy():void
    {
        removeEventListener(MouseEvent.CLICK, onClick);
        removeEventListener(MouseEvent.ROLL_OUT, onRollClick);
        removeEventListener(MouseEvent.ROLL_OVER, onRollClick);
        removeEventListener(Event.REMOVED, onRemove);
        if (_item && contains(_item))
        {
            removeChild(_item);
            _item = null;
        }
        if (_player)
        {
            _player.destory();
            _player = null;
        }
    }

    private function onRemove(event:Event):void
    {
        destroy();
    }

    private function onRollClick(event:MouseEvent):void
    {
        if (event.type == MouseEvent.ROLL_OVER)
        {
            if (_rollOverClick != null)
            {
                _rollOverClick(this);
            }
        } else if (event.type == MouseEvent.ROLL_OUT)
        {
            if (_rollOutClick != null)
            {
                _rollOutClick(this);
            }
        }
    }

    private function onClick(event:MouseEvent):void
    {
        if (_clickHandle != null)
        {
            _clickHandle(this);
        }
        if (_callBack != null && _player)
        {
            _callBack(_player);
        }
    }
}
}
