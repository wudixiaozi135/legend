package com.view.gameWindow.mainUi.subuis.teamhead
{
    import com.model.business.fileService.UrlBitmapDataLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.subclass.McTeamHead;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.team.data.TeamInfoVo;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
 * Created by Administrator on 2014/11/14.
 */
public class TeamIconItem extends MainUi implements IUrlBitmapDataLoaderReceiver
{
    public function TeamIconItem()
    {
        _skin = new McTeamHead();
        addChild(_skin);
        _icon = new Bitmap();
        var mc:McTeamHead = _skin as McTeamHead;
        mc.imageContainer.addChild(_icon);
        initView();
        _hpMask = new Shape();
        _hpMask.graphics.beginFill(0, 0);
        _hpMask.graphics.drawRect(0, 0, 61, 7);
        _layerIcon = new IconLayer();
        mc.imageContainer.addChild(_layerIcon);
        mc.imageContainer.addChild(_menuLayer = new Sprite());
    }

    private var _layerIcon:IconLayer;
    private var _icon:Bitmap;
    private var _loadBitmap:UrlBitmapDataLoader;
    private var _hpMask:Shape;

    private var _menuLayer:Sprite;

    public function get menuLayer():Sprite
    {
        return _menuLayer;
    }

    private var _teamInfo:TeamInfoVo;

    public function get teamInfo():TeamInfoVo
    {
        return _teamInfo;
    }

    public function set teamInfo(value:TeamInfoVo):void
    {
        _teamInfo = value;
        if (_loadBitmap)
        {
            _loadBitmap.destroy();
        }
        _loadBitmap = new UrlBitmapDataLoader(this);
        _loadBitmap.loadBitmap(ResourcePathConstants.IMAGE_CREATEROLE_FOLDER_LOAD + _teamInfo.job + "_" + _teamInfo.head + ResourcePathConstants.POSTFIX_PNG);

        var skin:McTeamHead = _skin as McTeamHead;
        _hpMask.width = (_teamInfo.hp / _teamInfo.maxHp) * 61;
        var headMapId:int = TeamDataManager.instance.headMapId;
        var headOnlyId:int = TeamDataManager.instance.headOnlyMapId;
        if (value.mapId != headMapId || value.mapOnlyId != headOnlyId)
        {
            _layerIcon.display(true);
        } else
        {
            _layerIcon.display(false);
        }
    }

    private var _clickHandler:Function;

    public function get clickHandler():Function
    {
        return _clickHandler;
    }

    public function set clickHandler(value:Function):void
    {
        _clickHandler = value;
    }

    override protected function addCallBack(rsrLoader:RsrLoader):void
    {
        var skin:McTeamHead = _skin as McTeamHead;
        rsrLoader.addCallBack(skin.bg, function (mc:MovieClip):void
        {
            mc.mouseChildren = false;
            mc.mouseEnabled = false;
        });
        rsrLoader.addCallBack(skin.hp, function (mc:MovieClip):void
        {
            skin.hp.addChild(_hpMask);
            skin.hp.mask = _hpMask;
        });
        rsrLoader.addCallBack(skin.viewBtn, function (mc:MovieClip):void
        {
            mc.mouseChildren = false;
            skin.viewBtn.buttonMode = true;
            skin.viewBtn.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        });
    }

    public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
    {
        _icon.bitmapData = bitmapData;
        _icon.scaleX = 56 / bitmapData.width;
        _icon.scaleY = 56 / bitmapData.height;
        _loadBitmap.destroy();
        _loadBitmap = null;
    }

    public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
    {
    }

    public function urlBitmapDataError(url:String, info:Object):void
    {
    }

    private function onClick(event:MouseEvent):void
    {
        if (_clickHandler != null)
        {
            _clickHandler(this);
        }
    }
}
}

import com.model.consts.StringConst;
import com.view.gameWindow.util.ObjectUtils;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

class IconLayer extends Sprite
{
    private var _label:TextField;

    public function IconLayer()
    {
        mouseEnabled = false;
        mouseChildren = false;
        var shape:Shape = new Shape();
        shape.graphics.clear();
        shape.graphics.beginFill(0xffffff, .4);
        shape.graphics.drawCircle(28, 28, 28);
        shape.graphics.endFill();
        addChild(shape);

        _label = new TextField();
        _label.autoSize = "left";
        _label.textColor = 0;
        _label.htmlText = StringConst.TEAM_PANEL_00045;
        ObjectUtils.addLineFilter(_label, "0xffffff");

        addChild(_label);
        _label.x = (width - _label.width) >> 1;
        _label.y = (height - _label.height) >> 1;
        addEventListener(Event.REMOVED, onDispose);
    }

    public function display(visible:Boolean):void
    {
        this.visible = visible;
    }

    private function onDispose(event:Event):void
    {
        removeEventListener(Event.REMOVED, onDispose);
        if (contains(_label))
        {
            _label.filters = null;
            removeChild(_label);
            _label = null;
        }
    }
}