package com.view.gameWindow.panel.panels.team.tabHandle.nearPlayer
{
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.team.data.PlayerInfoVo;
    import com.view.gameWindow.panel.panels.team.data.TeamInfoVo;
    import com.view.gameWindow.panel.panels.team.data.TeamStatus;
    import com.view.gameWindow.panel.panels.team.tab.McTabNear;
    import com.view.gameWindow.panel.panels.team.tab.TabNearPlayer;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.entityItem.Player;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.scrollBar.IScrollee;
    import com.view.gameWindow.util.scrollBar.ScrollBar;
    import com.view.selectRole.SelectRoleDataManager;

    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /**
 * Created by Administrator on 2014/11/10.
 */
public class TabNearViewHandle implements IScrollee
{
    public function TabNearViewHandle(tab:TabNearPlayer)
    {
        this._tab = tab;
        this._skin = _tab.skin as McTabNear;
        init();
    }
    private var _tab:TabNearPlayer;
    private var _skin:McTabNear;
    private var _scrollBar:ScrollBar;
    private var _scrollRect:Rectangle;

    private var _contentHeight:int;

    public function get contentHeight():int
    {
        return _contentHeight;
    }

        private var _selectPlayer:PlayerInfoVo;

        public function get selectPlayer():PlayerInfoVo
    {
        return _selectPlayer;
    }

    public function get scrollRectHeight():int
    {
        return _scrollRect.height;
    }

    public function get scrollRectY():int
    {
        return _scrollRect.y;
    }

    public function initScrollBar(mc:MovieClip):void
    {
        _scrollBar = new ScrollBar(this, mc, 0, _skin.mcLayer, 10);
        _scrollBar.resetHeight(_scrollRect.height);
    }

    public function update():void
    {
        var i:int = 0;
        _contentHeight = 0;
        ObjectUtils.clearAllChild(_skin.mcLayer);

        var data:Array = filterArr().sort(sortFunc);
        for each(var p:Player in data)
        {
            var tabItem:TabNearItem = new TabNearItem();
            tabItem.player = new PlayerInfoVo(p);
            _skin.mcLayer.addChild(tabItem);
            tabItem.x = 10;
            tabItem.y = 36 * i + 1;

            tabItem.callBack = callBackHandle;
            tabItem.rollOutClick = itemRollOut;
            tabItem.rollOverClick = itemRollOver;
            tabItem.clickHandle = clickHandle;
            i++;
        }
        _contentHeight = _skin.mcLayer.height;
        if (_scrollBar)
        {
            _scrollBar.resetScroll();
        }
    }

    public function scrollTo(pos:int):void
    {
        _scrollRect.y = pos;
        _skin.mcLayer.scrollRect = _scrollRect;
    }

    public function destroy():void
    {
        if (_skin)
        {
            _skin = null;
        }
        if (_tab)
        {
            _tab = null;
        }
        if (_scrollBar)
        {
            _scrollBar.destroy();
            _scrollBar = null;
        }
    }

    private function init():void
    {
        _scrollRect = new Rectangle(0, 0, _skin.mcLayer.width, _skin.mcLayer.height);
        _skin.mcLayer.scrollRect = _scrollRect;
    }

    private function filterArr():Array
    {
        var newArr:Array = [];
        var dic:Dictionary = EntityLayerManager.getInstance().playerDic;
        var allArr:Array = ObjectUtils.dicToArr(dic);
        var teamArr:Vector.<TeamInfoVo> = TeamDataManager.instance.teamInfoVec;
        var selfCid:int = SelectRoleDataManager.getInstance().selectCid;
        var isFind:Boolean;
        for (var i:int = 0; i < allArr.length; i++)
        {
            isFind = false;
            var cid:int = allArr[i].cid;
            var sid:int = allArr[i].sid;

            for (var j:int = 0; j < teamArr.length; j++)
            {
                if (cid == teamArr[j].cid && sid == teamArr[j].sid)
                {
                    isFind = true;
                    break;
                }
            }
            if (cid == selfCid)
            {
                isFind = true;
            }
            if (!isFind)
            {
                newArr.push(allArr[i]);
            }
        }
        return newArr;
    }

    private function clickHandle(item:TabNearItem):void
    {
        _skin.mcItemSelect.visible = true;
        _skin.mcItemSelect.x = 10;
        _skin.mcItemSelect.y = item.y + 33;
    }

    private function itemRollOut(item:TabNearItem):void
    {
        _skin.mcItemOver.visible = false;
        _skin.mcItemOver.x = 10;
        _skin.mcItemOver.y = item.y + 33;
    }

    private function itemRollOver(item:TabNearItem):void
    {
        _skin.mcItemOver.visible = true;
        _skin.mcItemOver.x = 10;
        _skin.mcItemOver.y = item.y + 33;
    }

        private function callBackHandle(player:PlayerInfoVo):void
    {
        if (_selectPlayer != player)
        {
            _selectPlayer = player;
        }
        if (EntityLayerManager.getInstance().firstPlayer.teamStatus)//自己已组队
        {
            if (player.teamStatus != TeamStatus.TS_FREE)
            {
                _skin.inviteBtn.visible = true;
                _skin.applyBtn.visible = false;
                _skin.inviteJoinBtn.visible = false;
            } else
            {
                _skin.inviteBtn.visible = false;
                _skin.applyBtn.visible = false;
                _skin.inviteJoinBtn.visible = true;
            }
        } else
        {
            if (player.teamStatus != TeamStatus.TS_FREE)
            {//已组队
                _skin.applyBtn.visible = true;
                _skin.inviteBtn.visible = false;
                _skin.inviteJoinBtn.visible = false;
            } else
            {
                _skin.inviteBtn.visible = true;
                _skin.applyBtn.visible = false;
                _skin.inviteJoinBtn.visible = false;
            }
        }
    }

    private function sortFunc(player1:Player, player2:Player):int
    {
        var dataManager:TeamDataManager = TeamDataManager.instance;
        var hasTeam:Boolean = dataManager.hasTeam;
        if (hasTeam)
        {//玩家有队伍
            if (dataManager.isHeader)
            {//是队长 未组队玩家-组队玩家
                if (player1.teamStatus > player2.teamStatus)
                {
                    return 1;
                } else if (player1.teamStatus < player2.teamStatus)
                {
                    return -1;
                } else
                {
                    return 0;
                }
            } else
            {
                //不是队长时，排序=组队玩家-未组队玩家
                if (player1.teamStatus > player2.teamStatus)
                {
                    return -1;
                } else if (player1.teamStatus < player2.teamStatus)
                {
                    return 1;
                } else
                {
                    return 0;
                }
            }
        } else
        {//当玩家未加入队伍时，排序=组队玩家-未组队玩家
            if (player1.teamStatus > player2.teamStatus)
            {
                return -1;
            } else if (player1.teamStatus < player2.teamStatus)
            {
                return 1;
            } else
            {
                return 0;
            }
        }
        return 0;
    }
}
}
