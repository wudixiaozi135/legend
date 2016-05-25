package com.view.gameWindow.panel.panels.team.prompt
{
import com.model.gameWindow.rsr.RsrLoader;
import com.view.gameWindow.panel.panelbase.PanelBase;
import com.view.gameWindow.panel.panels.team.tab.McTeamHint;
import com.view.gameWindow.tips.toolTip.ToolTipManager;

import flash.display.MovieClip;
import flash.events.MouseEvent;

/**
 * Created by Administrator on 2014/11/12.
 */
public class PanelTeamPrompt extends PanelBase
{
    public function PanelTeamPrompt()
    {
        super();
    }

    override protected function initSkin():void
    {
        _skin = new McTeamHint();
        addChild(_skin);
    }

    override protected function initData():void
    {
        var teamHint:McTeamHint = _skin as McTeamHint;
        teamHint.txtLine1.text = TeamPromptData.TXT_LINE_1;
        teamHint.txtLine2.text = TeamPromptData.TXT_LINE_2;
        teamHint.txtLine3.text = TeamPromptData.TXT_LINE_3;
        teamHint.txtLine4.text = TeamPromptData.TXT_LINE_4;

        teamHint.btnTxt1.text = TeamPromptData.BUTTON_TXT_1;
        teamHint.btnTxt2.text = TeamPromptData.BUTTON_TXT_2;
        teamHint.btnTxt1.mouseEnabled = false;
        teamHint.btnTxt2.mouseEnabled = false;

        addEventListener(MouseEvent.CLICK, onClick);

        for (var i:int = 1; i <= 4; i++)
        {

            ToolTipManager.getInstance().attach(teamHint["txtLine" + i]);
            ToolTipManager.getInstance().hashTipInfo(teamHint["txtLine" + i], TeamPromptData.TIP_VO);
    }
    }

    override protected function addCallBack(rsrLoader:RsrLoader):void
    {
        var skin:McTeamHint = _skin as McTeamHint;
        rsrLoader.addCallBack(skin.btn1, function (mc:MovieClip):void
        {
            ToolTipManager.getInstance().attach(mc);
            ToolTipManager.getInstance().hashTipInfo(mc, TeamPromptData.TIP_VO);
        });

        rsrLoader.addCallBack(skin.btn2, function (mc:MovieClip):void
        {
            ToolTipManager.getInstance().attach(mc);
            ToolTipManager.getInstance().hashTipInfo(mc, TeamPromptData.TIP_VO);
        });
    }

    override public function destroy():void
    {
        TeamPromptData.destroy();
        removeEventListener(MouseEvent.CLICK, onClick);
        var teamHint:McTeamHint = _skin as McTeamHint;
        for (var i:int = 1; i <= 4; i++)
        {
            if (i <= 2)
            {
                ToolTipManager.getInstance().detach(teamHint["btn" + i]);
            }
            ToolTipManager.getInstance().detach(teamHint["txtLine" + i]);
        }
        super.destroy();
    }

    protected function onClick(event:MouseEvent):void
    {
        var mcPanel2BtnPrompt:McTeamHint = _skin as McTeamHint;
        switch (event.target)
        {
            case mcPanel2BtnPrompt.btn1://确定
                if (null != TeamPromptData.okFunction)
                {
                    TeamPromptData.okFunction();
                }
                break;
            case mcPanel2BtnPrompt.btn2://取消
                if (null != TeamPromptData.cancelFunction)
                {
                    TeamPromptData.cancelFunction();
                }
                break;
        }
    }
}
}
