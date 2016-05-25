/**
 * Created by Administrator on 2014/11/5.
 */
package com.view.gameWindow.panel.panels.team
{
import com.model.consts.StringConst;

import flash.text.TextFormat;

public class PanelTeamViewHandle
{
    private var _panel:PanelTeam;
    private var _skin:McTeam;

    public function PanelTeamViewHandle(panel:PanelTeam)
    {
        this._panel = panel;
        this._skin = panel.skin as McTeam;
        init();
    }

    private function init():void
    {
        var defaultTextFormat:TextFormat = _skin.txtTitle.defaultTextFormat;
        defaultTextFormat.bold = true;
        _skin.txtTitle.defaultTextFormat = defaultTextFormat;
        _skin.txtTitle.setTextFormat(defaultTextFormat);
        _skin.txtTitle.text = StringConst.TEAM_PANEL_0001;
    }

    public function destroy():void
    {
        _skin = null;
        _panel = null;
    }
}
}
