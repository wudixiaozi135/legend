/**
 * Created by Administrator on 2014/11/5.
 */
package com.view.gameWindow.panel.panels.team.tab
{
import com.view.gameWindow.util.tabsSwitch.TabBase;

public class TabTempTeam extends TabBase
{
    public function TabTempTeam()
    {
        super();
    }

    override protected function initSkin():void
    {
        var skin:McTabTemp = new McTabTemp();
        _skin = skin;
        addChild(_skin);
    }
}
}
