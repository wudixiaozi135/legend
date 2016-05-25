package com.view.gameWindow.mainUi.subuis.teamhead.teamMenu
{
import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.consts.StringConst;
import com.model.gameWindow.rsr.RsrLoader;
import com.view.gameWindow.mainUi.MainUi;
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.handler.HeaderMenuMouseHandle;
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.menu.ITeamMenu;

/**
 * Created by Administrator on 2014/11/17.
 */
public class MenuTeamHeader extends MainUi implements ITeamMenu
{
    public function MenuTeamHeader()
    {
        _skin = new McHeaderMenu();
        addChild(_skin);
        initData();
        initView();
    }

    public var _mouseHandle:HeaderMenuMouseHandle;

    override public function initView():void
    {
        var rsrLoader:RsrLoader = new RsrLoader();
        addCallBack(rsrLoader);
        rsrLoader.load(_skin, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
    }

    override protected function addCallBack(rsrLoader:RsrLoader):void
    {
        var skin:McHeaderMenu = _skin as McHeaderMenu;
        for (var i:int = 0; i < 6; i++)
        {
            skin["txt" + i].textColor = 0xffcc00;
            skin["txt" + i].text = StringConst["TEAM_MENU_0000" + (i + 1)];
            skin["txt" + i].mouseEnabled = false;
        }
    }

    public function position(x:Number, y:Number):void
    {
        this.x = x;
        this.y = y;
    }

    public function destroy():void
    {
        if (_mouseHandle)
        {
            _mouseHandle.destroy();
            _mouseHandle = null;
        }
        if (_skin)
        {
            _skin = null;
        }
    }

    private function initData():void
    {
        _mouseHandle = new HeaderMenuMouseHandle(this);
    }
}
}
