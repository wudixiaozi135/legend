/**
 * Created by Administrator on 2014/11/5.
 */
package com.view.gameWindow.panel.panels.team
{
import com.view.gameWindow.panel.PanelConst;
import com.view.gameWindow.panel.PanelMediator;
import com.view.gameWindow.panel.panels.team.tab.TabMyTeam;
import com.view.gameWindow.panel.panels.team.tab.TabNearPlayer;
import com.view.gameWindow.util.tabsSwitch.TabsSwitch;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

public class PanelTeamMouseHandle
{
    private static const TAB_MY:int = 0;
    private static const TAB_NEAR:int = 1;
    private static const TAB_TEMP:int = 2;

    private var _panel:PanelTeam;
    private var _skin:McTeam;
    private var _lastTab:MovieClip;
    private var _tabSwitch:TabsSwitch;

    public function PanelTeamMouseHandle(panel:PanelTeam)
    {
        this._panel = panel;
        this._skin = panel.skin as McTeam;
        init();
    }

    private function init():void
    {
        this._skin.addEventListener(MouseEvent.CLICK, onClickHandle, false, 0, true);
        _tabSwitch = new TabsSwitch(_skin.mcLayer, Vector.<Class>([TabMyTeam, TabNearPlayer]));
    }

    private function onClickHandle(event:MouseEvent):void
    {
        switch (event.target)
        {
            case _skin.btnClose:
                closeHandler();
                break;
            case _skin.tab1:
                dealBtnTab(TAB_MY, _skin.tab1);
                break;
            case _skin.tab2:
                dealBtnTab(TAB_NEAR, _skin.tab2);
                break;
            default:
                break;
        }
    }

    private function dealBtnTab(index:int, tab:MovieClip):void
    {
        TeamDataManager.instance.selectIndex = index;
        _tabSwitch.onClick(index, true);
        if (!_lastTab) return;

        _lastTab.selected = false;
        _lastTab.mouseEnabled = true;
        (_lastTab.txt as TextField).textColor = 0x675138;

        tab.selected = true;
        tab.mouseEnabled = false;
        (tab.txt as TextField).textColor = 0xffe1aa;
        _lastTab = tab;

        TeamDataManager.instance.subItemSelect = -1;
    }

    private function closeHandler():void
    {
        PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM);
    }

    public function get lastTab():MovieClip
    {
        return _lastTab;
    }

    public function set lastTab(value:MovieClip):void
    {
        _lastTab = value;
    }

    public function destroy():void
    {
        if (_tabSwitch)
        {
            _tabSwitch.destroy();
            _tabSwitch = null;
        }
        if (_skin)
        {
            _skin.removeEventListener(MouseEvent.CLICK, onClickHandle);
            _skin = null;
        }
        _panel = null;
    }
}
}
