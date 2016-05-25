package com.view.gameWindow.mainUi.subuis.teamhead.teamMenu
{
import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.consts.StringConst;
import com.model.gameWindow.rsr.RsrLoader;
import com.view.gameWindow.mainUi.MainUi;
import com.view.gameWindow.mainUi.subuis.teamhead.teamMenu.menu.ITeamMenu;

/**
 * Created by Administrator on 2014/11/17.
 */
public class MenuTeamMember extends MainUi implements ITeamMenu
{
    public function MenuTeamMember()
    {
        _skin = new McMemberMenu();
        addChild(_skin);
        initData();
        initView();
    }

    private var _mouseHandle:MemberMenuMouseHandle;

    override public function initView():void
    {
        var rsrLoader:RsrLoader = new RsrLoader();
        addCallBack(rsrLoader);
        rsrLoader.load(_skin, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
    }

    override protected function addCallBack(rsrLoader:RsrLoader):void
    {
        var skin:McMemberMenu = _skin as McMemberMenu;
        for (var i:int = 0; i < 4; i++)
        {
            skin["txt" + i].textColor = 0xffcc00;
            skin["txt" + i].text = StringConst["TEAM_MENU_0000" + (i + 3)];
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
        _mouseHandle = new MemberMenuMouseHandle(this);
    }
}
}
