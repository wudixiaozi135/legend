package com.view.gameWindow.panel.panels.team.tabHandle.nearPlayer
{
import com.model.consts.StringConst;
import com.model.gameWindow.rsr.RsrLoader;
import com.view.gameWindow.panel.panels.team.tab.McTabNear;
import com.view.gameWindow.panel.panels.team.tab.TabNearPlayer;

import flash.display.MovieClip;
import flash.text.TextField;

/**
 * Created by Administrator on 2014/11/10.
 */
public class TabNearCallBackHandle
{
    private var _tab:TabNearPlayer;
    private var _skin:McTabNear;

    public function TabNearCallBackHandle(tab:TabNearPlayer, rsrLoader:RsrLoader)
    {
        this._tab = tab;
        this._skin = _tab.skin as McTabNear;
        init(rsrLoader);
    }

    private function init(rsrLoader:RsrLoader):void
    {
        var txt:TextField;
        rsrLoader.addCallBack(_skin.inviteBtn, function (mc:MovieClip):void//邀请组队
        {
            txt = mc.txt as TextField;
            txt.textColor = 0xd4a460;
            txt.text = StringConst.TEAM_PANEL_00017;
        });

        rsrLoader.addCallBack(_skin.applyBtn, function (mc:MovieClip):void//申请入队
        {
            mc.visible = false;
            txt = mc.txt as TextField;
            txt.textColor = 0xd4a460;
            txt.text = StringConst.TEAM_PANEL_00027;
        });

        rsrLoader.addCallBack(_skin.inviteJoinBtn, function (mc:MovieClip):void//入组邀请
        {
            mc.visible = false;
            txt = mc.txt as TextField;
            txt.textColor = 0xd4a460;
            txt.text = StringConst.TEAM_PANEL_00036;
        });

        rsrLoader.addCallBack(_skin.refreshBtn, function (mc:MovieClip):void
        {
            txt = mc.txt as TextField;
            txt.textColor = 0xd4a460;
            txt.text = StringConst.TEAM_PANEL_00015;
        });

        rsrLoader.addCallBack(_skin.viewBtn, function (mc:MovieClip):void
        {
            txt = mc.txt as TextField;
            txt.textColor = 0xd4a460;
            txt.text = StringConst.TEAM_PANEL_00016;
        });


        rsrLoader.addCallBack(_skin.mcItemSelect, function (mc:MovieClip):void
        {
            mc.visible = false;
            mc.mouseChildren = false;
            mc.mouseEnabled = false;
        });

        rsrLoader.addCallBack(_skin.mcItemOver, function (mc:MovieClip):void
        {
            mc.visible = false;
            mc.mouseChildren = false;
            mc.mouseEnabled = false;
        });

        rsrLoader.addCallBack(_skin.mcScrollBar, function (mc:MovieClip):void//滚动条资源加载完成后构造滚动条控制类
        {
            if (_tab.viewHandle)
            {
                _tab.viewHandle.initScrollBar(mc);
            }
        });

        _skin.txtVip.textColor = 0xd4a460;
        _skin.txtVip.text = StringConst.TEAM_PANEL_00018;

        _skin.txtPlayer.textColor = 0xd4a460;
        _skin.txtPlayer.text = StringConst.TEAM_PANEL_00019;

        _skin.txtLv.textColor = 0xd4a460;
        _skin.txtLv.text = StringConst.TEAM_PANEL_00020;

        _skin.txtJob.textColor = 0xd4a460;
        _skin.txtJob.text = StringConst.TEAM_PANEL_00021;

        _skin.txtStatus.textColor = 0xd4a460;
        _skin.txtStatus.text = StringConst.TEAM_PANEL_00022;

        _skin.txtFaction.textColor = 0xd4a460;
        _skin.txtFaction.text = StringConst.TEAM_PANEL_00023;
    }

    public function destroy():void
    {
        _skin = null;
        _tab = null;
    }
}
}
