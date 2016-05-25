/**
 * Created by Administrator on 2014/11/5.
 */
package com.view.gameWindow.panel.panels.team.tab
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.team.tabHandle.myTeam.TabMyTeamMouseHandle;
    import com.view.gameWindow.panel.panels.team.tabHandle.myTeam.TabMyTeamViewHandle;
    import com.view.gameWindow.util.tabsSwitch.TabBase;

    public class TabMyTeam extends TabBase
{
    public function TabMyTeam()
    {
    }

    private var _viewHandle:TabMyTeamViewHandle;

    public function get viewHandle():TabMyTeamViewHandle
    {
        return _viewHandle;
    }

    private var _mouseHandle:TabMyTeamMouseHandle;

    public function get mouseHandle():TabMyTeamMouseHandle
    {
        return _mouseHandle;
    }

    override protected function initSkin():void
    {
        var skin:McTabMySub = new McTabMySub();
        _skin = skin as McTabMySub;
        addChild(_skin);
    }

    override protected function addCallBack(rsrLoader:RsrLoader):void
    {
        _viewHandle = new TabMyTeamViewHandle(this, rsrLoader);
    }

    override protected function initData():void
    {
        _mouseHandle = new TabMyTeamMouseHandle(this);
    }

    override public function destroy():void
    {
        if (_viewHandle)
        {
            _viewHandle.destroy();
            _viewHandle = null;
        }
        if (_mouseHandle)
        {
            _mouseHandle.destroy();
            _mouseHandle = null;
        }
    }

    override public function refresh():void
    {
        if (_viewHandle)
            _viewHandle.refresh();
    }

    override public function update(proc:int = 0):void
    {
        switch (proc)
        {
            case GameServiceConstants.SM_TEAM_INFO:
                refresh();
                break;
            case GameServiceConstants.SM_OTHER_SETTING:
                if (_viewHandle)
                {
                    _viewHandle.refreshSetting();
                }
                break;
            case GameServiceConstants.SM_KICKED_FROM_TEAM:
                if (_viewHandle)
                {
                    _viewHandle.leaveTeamRefresh();
                }
                break;
            case GameServiceConstants.CM_LEAVE_TEAM:
                if (_viewHandle)
                {
                    _viewHandle.leaveTeamRefresh();
                }
                break;
            case GameServiceConstants.SM_TEAM_DIMISSED:
            case GameServiceConstants.CM_TEAM_DISMISS:
                if (_viewHandle)
                {
                    _viewHandle.dismissRefresh();
                }
                break;
            default :
                break;
        }
    }
	
	override protected function attach():void
	{
		// TODO Auto Generated method stub
		TeamDataManager.instance.attach(this);
		super.attach();
	}
	
	override protected function detach():void
	{
		// TODO Auto Generated method stub
		TeamDataManager.instance.detach(this);
		super.detach();
	}
	
	}
}
