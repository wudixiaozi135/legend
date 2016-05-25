package com.view.gameWindow.panel.panels.team.prompt
{
import com.view.gameWindow.tips.toolTip.TipVO;

/**
 * Created by Administrator on 2014/11/12.
 */
public class TeamPromptData
{
    public static var TXT_LINE_1:String = "";
    public static var TXT_LINE_2:String = "";
    public static var TXT_LINE_3:String = "";
    public static var TXT_LINE_4:String = "";

    public static var BUTTON_TXT_1:String = "";
    public static var BUTTON_TXT_2:String = "";

    public static var okFunction:Function;
    public static var cancelFunction:Function;
    public static var TIP_VO:TipVO;

    public static function destroy():void
    {
        TeamPromptData.TXT_LINE_1 = "";
        TeamPromptData.TXT_LINE_2 = "";
        TeamPromptData.TXT_LINE_3 = "";
        TeamPromptData.TXT_LINE_4 = "";

        TeamPromptData.BUTTON_TXT_1 = "";
        TeamPromptData.BUTTON_TXT_2 = "";

        TeamPromptData.TIP_VO = null;
        TeamPromptData.okFunction = null;
        TeamPromptData.cancelFunction = null;
    }

    public function TeamPromptData()
    {
    }
}
}
