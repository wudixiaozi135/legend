package com.view.gameWindow.panel.panels.everydayReward.item
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.ItemType;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.panel.panels.everydayReward.McEveryRewardItem;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.UtilItemParse;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/3/2.
     */
    public class EveryDayRewardItem extends McEveryRewardItem
    {
        private const REWARD_COUNT:int = 5;

        private var _rsrLoader:RsrLoader;

        private var _cellExs:Vector.<IconCellEx>;
        private var _dts:Vector.<ThingsData>;

        public var clickHandler:Function;
        public var align:String;// left center right
        private var _flyDatas:Array = [];
        private var _hight:HighlightEffectManager;
        private var _hightLight:Boolean;
        private var _bgLoader:Boolean;
        public function EveryDayRewardItem()
        {
            super();

            initSkin();
            initialize();
            addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
        }

        private function initSkin():void
        {
            _rsrLoader = new RsrLoader();

            _hight = new HighlightEffectManager();
            var that:EveryDayRewardItem = this;
            _rsrLoader.addCallBack(cardBg, function (mc:MovieClip):void
            {
                _bgLoader = true;
                if (hightLight)
                {
                    _hight.show(that, that);
                } else
                {
                    _hight.hide(that);
                }
            });
            _rsrLoader.load(this, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
        }

        private function onClickHandler(event:MouseEvent):void
        {
            if (clickHandler != null)
            {
                clickHandler(this);
            }
        }

        public function get hightLight():Boolean
        {
            return _hightLight;
        }

        public function set hightLight(value:Boolean):void
        {
            _hightLight = value;
            if (_bgLoader)
            {
                if (_hightLight)
                {
                    _hight.show(this, this);
                } else
                {
                    _hight.hide(this);
                }
            }
        }
        public function refreshData(rewardStr:String):void
        {
            if (rewardStr)
            {
                destroyTips();
                var totalArr:Array = rewardStr.split("|");
                var dt:ThingsData, cell:IconCellEx;

                var temp:Array = UtilItemParse.getItemString(totalArr[0]);
                var url:String;
                if (temp[3] == ItemType.GOD_RING_ID)
                {
                    url = "everydayReward/giftRing" + ResourcePathConstants.POSTFIX_PNG;
                    if (titleContainer.title.resUrl != url)
                    {
                        titleContainer.title.resUrl = url;
                        _rsrLoader.load(titleContainer, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
                    }
                } else if (temp[3] == ItemType.BLESS_OIL_ID)
                {
                    url = "everydayReward/giftOil" + ResourcePathConstants.POSTFIX_PNG;
                    if (titleContainer.title.resUrl != url)
                    {
                        titleContainer.title.resUrl = url;
                        _rsrLoader.load(titleContainer, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
                    }
                } else if (temp[3] == ItemType.DIAMOND_ID)
                {
                    url = "everydayReward/giftDiamond" + ResourcePathConstants.POSTFIX_PNG;
                    if (titleContainer.title.resUrl != url)
                    {
                        titleContainer.title.resUrl = url;
                        _rsrLoader.load(titleContainer, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
                    }
                }

                for (var i:int = 0, len:int = _cellExs.length; i < len; i++)
                {
                    dt = _dts[i];
                    cell = _cellExs[i];
                    if (i < totalArr.length)
                    {
                        var arr:Array = UtilItemParse.getItemString(totalArr[i]);
                        dt.id = arr[3];
                        dt.type = arr[4];
                        dt.count = arr[2];
                        IconCellEx.setItemByThingsData(cell, dt);
                        ToolTipManager.getInstance().attach(cell);
                    }
                }
            }
        }

        private function initialize():void
        {
            _cellExs = new Vector.<IconCellEx>();
            _dts = new Vector.<ThingsData>();

            var iconSize:int = 0;
            var icon:MovieClip;
            for (var i:int = 0; i < REWARD_COUNT; i++)
            {
                if (i == 0)//第一个使用大图标
                {
                    iconSize = 60;
                } else
                {
                    iconSize = 32;
                }
                icon = this["icon" + (i + 1)];
                var cellEx:IconCellEx = new IconCellEx(icon, (icon.width - iconSize) >> 1, (icon.height - iconSize) >> 1, iconSize, iconSize);
                _cellExs.push(cellEx);

                var dt:ThingsData = new ThingsData();
                _dts.push(dt);
            }
        }

        public function disableBtn(bool:Boolean):void
        {
            this.mouseEnabled = !bool;
            this.mouseChildren = !bool;
        }
        public function getBitmapDatas():Array
        {
            destroyFlyDatas();
            if (_cellExs)
            {
                _cellExs.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
                {
                    var bmp:Bitmap = element.getBitmap();
                    if (bmp)
                    {
                        bmp.width = bmp.height = 40;
                        element.addChild(bmp);
                        bmp.name = element.id.toString();
                        _flyDatas.push(bmp);
                    }
                });
            }
            return _flyDatas;
        }

        public function destroyFlyDatas():void
        {
            if (_flyDatas)
            {
                _flyDatas.forEach(function (element:Bitmap, index:int, arr:Array):void
                {
                    if (element && element.parent)
                    {
                        element.parent.removeChild(element);
                        if (element.bitmapData)
                        {
                            element.bitmapData.dispose();
                        }
                        element = null;
                    }
                });
                _flyDatas.length = 0;
            }
        }
        private function destroyTips():void
        {
            if (_cellExs)
            {
                _cellExs.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
                {
                    ToolTipManager.getInstance().detach(element);
                });
            }
        }

        public function destroy():void
        {
            removeEventListener(MouseEvent.CLICK, onClickHandler);
            destroyFlyDatas();
            if (_flyDatas)
            {
                _flyDatas = null;
            }
            if (clickHandler != null)
            {
                clickHandler = null;
            }
            destroyTips();
            if (_hight)
            {
                _hight.hide(this);
                _hight = null;
            }
            if (_cellExs)
            {
                _cellExs.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
                {
                    element.destroy();
                    element = null;
                });
                _cellExs.length = 0;
                _cellExs = null;
            }
            if (_dts)
            {
                _dts.forEach(function (element:ThingsData, index:int, vec:Vector.<ThingsData>):void
                {
                    element = null;
                });
                _dts.length = 0;
                _dts = null;
            }
            if (_rsrLoader)
            {
                _rsrLoader.destroy();
                _rsrLoader = null;
            }
        }
    }
}
