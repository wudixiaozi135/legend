/**
 * Created by Administrator on 2014/11/6.
 */
package com.view.gameWindow.panel.panels.team.tabHandle.myTeam
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapCfgData;
    import com.model.consts.JobConst;
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.team.data.TeamInfoVo;
    import com.view.gameWindow.panel.panels.team.tab.McInfo;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class SubItemInfo
{
    public function SubItemInfo(mc:MovieClip)
    {
        super();
        _item = mc as McInfo;
        _item.nameTxt.mouseEnabled = false;
        _item.jobAndLv.mouseEnabled = false;
        _item.locationTxt.mouseEnabled = false;
        _item.headerContainer.mouseEnabled = false;
        _item.headerContainer.mouseChildren = false;
        _item.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
    }

        private var _headerFlag:HeaderFlag;

    private var _data:TeamInfoVo;

    public function get data():TeamInfoVo
    {
        return _data;
    }

    public function set data(value:TeamInfoVo):void
    {
        _data = value;
        if (_data != null)
        {
            _item.nameTxt.text = _data.name;
            _item.jobAndLv.text = JobConst.jobName(_data.job) + ":" + _data.level + StringConst.ROLE_HEAD_0001;
            _item.locationTxt.text = combineMsg(_data);
            if (_data.leaderFlag)
            {
                if (_headerFlag == null) {
                    _headerFlag = new HeaderFlag();
                }
                if (_item.headerContainer.contains(_headerFlag) == false) {
                    _item.headerContainer.addChild(_headerFlag);
                }
                _headerFlag.visible = true;
            } else
            {
                if (_headerFlag) {
                    _headerFlag.visible = false;
                }
            }
        } else
        {
            _item.nameTxt.text = "";
            _item.jobAndLv.text = "";
            _item.locationTxt.text = "";
        }
    }

    private var _callBack:Function;

    public function get callBack():Function
    {
        return _callBack;
    }

    public function set callBack(value:Function):void
    {
        _callBack = value;
    }

    private var _item:McInfo;

    public function get item():McInfo
    {
        return _item;
    }

    public function destroy():void
    {
        if (_headerFlag) {
            _headerFlag = null;
        }
        _item.headerContainer = null;
        _callBack = null;
        _data = null;
        _item.removeEventListener(MouseEvent.CLICK, onClickHandler);
    }

    private function combineMsg(data:TeamInfoVo):String
    {
        var mapConfig:MapCfgData = ConfigDataManager.instance.mapCfgData(data.mapId);
        if (mapConfig)
        {
            return mapConfig.name + "(" + data.x + "," + data.y + ")";
        }
        return "";
    }

    private function onClickHandler(event:MouseEvent):void
    {
        if ((null != _data) && (null != _callBack))
        {
            _callBack(_data);
        }
    }
}
}

import com.model.business.fileService.constants.ResourcePathConstants;
import com.view.gameWindow.common.ResManager;
import com.view.gameWindow.util.ObjectUtils;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;

class HeaderFlag extends Sprite
{
    private var _rsrLoader:ResManager;

    public function HeaderFlag()
    {
        mouseChildren = false;
        mouseEnabled = false;
        _rsrLoader = ResManager.getInstance();
        _rsrLoader.loadBitmap(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "team/headerFlag.png", function (bmd:BitmapData,url:String):void
        {
            addChild(new Bitmap(bmd));
        });
        addEventListener(Event.REMOVED, onRemove);
    }

    private function onRemove(event:Event):void
    {
        removeEventListener(Event.REMOVED, onRemove);
        ObjectUtils.clearAllChild(this);
        if (_rsrLoader)
        {
            _rsrLoader = null;
        }
    }
}