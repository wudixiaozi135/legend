/**
 * Created by Administrator on 2014/11/5.
 */
package com.view.gameWindow.panel.panels.team
{
import com.model.consts.StringConst;
import com.model.gameWindow.rsr.RsrLoader;

import flash.display.MovieClip;
import flash.text.TextField;

public class PanelTeamLoadCallBack
{
    private var _panel:PanelTeam;
    private var _skin:McTeam;

    public function PanelTeamLoadCallBack(panel:PanelTeam, load:RsrLoader)
    {
        this._panel = panel;
        this._skin = panel.skin as McTeam;
        init(load);
    }

    private function init(load:RsrLoader):void
    {
        for (var i:int = 0; i < 2; i++)
        {
            load.addCallBack(_skin["tab" + (i + 1)], getFunc(i));
        }
    }

    private function getFunc(index:int):Function
    {
        var func:Function = function (mc:MovieClip):void
        {
            var selectIndex:int = TeamDataManager.instance.selectIndex;
            var textField:TextField = mc.txt as TextField;
            textField.text = StringConst["TEAM_PANEL_000" + (2 + +index)];
            if (selectIndex == index)
            {
                mc.selected = true;
                mc.mouseEnabled = false;
                _panel.mouseHandle.lastTab = mc;
                textField.textColor = 0xffe1aa;
            }
            else
            {
                textField.textColor = 0x675138;
            }
        };
        return func;
    }

    public function destroy():void
    {
        _panel = null;
        _skin = null;
    }
}
}
