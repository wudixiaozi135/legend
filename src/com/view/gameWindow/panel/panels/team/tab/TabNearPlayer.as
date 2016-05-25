/**
 * Created by Administrator on 2014/11/5.
 */
package com.view.gameWindow.panel.panels.team.tab
{
import com.model.gameWindow.rsr.RsrLoader;
import com.view.gameWindow.panel.panels.team.tabHandle.nearPlayer.TabNearCallBackHandle;
import com.view.gameWindow.panel.panels.team.tabHandle.nearPlayer.TabNearMouseHandle;
import com.view.gameWindow.panel.panels.team.tabHandle.nearPlayer.TabNearViewHandle;
import com.view.gameWindow.util.tabsSwitch.TabBase;

public class TabNearPlayer extends TabBase
{
    private var _viewHandle:TabNearViewHandle;
    private var _mouseHandle:TabNearMouseHandle;
    private var _callBack:TabNearCallBackHandle;

    public function TabNearPlayer()
    {
        super();
    }

    override protected function initSkin():void
    {
        var skin:McTabNear = new McTabNear();
        _skin = skin;
        addChild(_skin);
    }

    override public function refresh():void
    {
        _viewHandle.update();
    }

    override protected function addCallBack(rsrLoader:RsrLoader):void
    {
        _callBack = new TabNearCallBackHandle(this, rsrLoader);
    }

    override protected function initData():void
    {
        _mouseHandle = new TabNearMouseHandle(this);
        _viewHandle = new TabNearViewHandle(this);
    }

    public function get viewHandle():TabNearViewHandle
    {
        return _viewHandle;
    }

    public function get mouseHandle():TabNearMouseHandle
    {
        return _mouseHandle;
    }

    public function get callBack():TabNearCallBackHandle
    {
        return _callBack;
    }

    override public function destroy():void
    {
        if (_callBack)
        {
            _callBack.destroy();
            _callBack = null;
        }
        if (_mouseHandle)
        {
            _mouseHandle.destroy();
            _mouseHandle = null;
        }
        if (_viewHandle)
        {
            _viewHandle.destroy();
            _viewHandle = null;
        }
    }
	
	override protected function attach():void
	{
		// TODO Auto Generated method stub
		super.attach();
	}
	
	override protected function detach():void
	{
		// TODO Auto Generated method stub
		super.detach();
	}
	
}
}
