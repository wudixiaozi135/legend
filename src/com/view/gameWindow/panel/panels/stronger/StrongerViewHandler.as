package com.view.gameWindow.panel.panels.stronger
{
    import com.model.configData.cfgdata.StrongerCfgData;
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.stronger.data.StrongerEvent;
    import com.view.gameWindow.panel.panels.stronger.item.ItemRow;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.scrollBar.IScrollee;
    import com.view.gameWindow.util.scrollBar.ScrollBar;

    import flash.display.MovieClip;
    import flash.geom.Rectangle;

    /**
     * Created by Administrator on 2014/12/22.
     */
    public class StrongerViewHandler implements IScrollee
    {
        private var _panel:PanelStronger;
        private var _skin:McStronger;

        private var _scrollBar:ScrollBar;
        private var _scrollRect:Rectangle;
        private var _contentHeight:int;
        private var _litters:Array = [];

        public function StrongerViewHandler(panel:PanelStronger)
        {
            _panel = panel;
            _skin = _panel.skin as McStronger;
            initialize();
            StrongerEvent.addEventListener(StrongerEvent.SWITCH_TAB, update, false, 0, true);
        }

        private function update(event:StrongerEvent):void
        {
            clearContainer();
            var param:Object = event.param as Object;
            var itemRow:ItemRow;
            if (param != null)
            {
                var selectIndex:int = param.tabIndex;
                var datas:Vector.<StrongerCfgData>, data:StrongerCfgData, rowItem:ItemRow, i:int = 0, len:int = 0;
                var pos:int;
                var title:TitleRow = new TitleRow();
                datas = StrongerDataManager.instance.getDatasByTypeAndTitle(selectIndex + 1, StrongerDataManager.TITLE_1);//第一个子标签
                if (datas)
                {
                    title.title.textColor = 0xd5b300;
                    title.x = 0;
                    title.y = pos;
                    pos = title.height;
                    _skin.mcContainer.addChild(title);

                    for (i = 0, len = datas.length; i < len; i++)
                    {
                        data = datas[i];
                        if (i == 0)
                        {
                            title.visible = true;
                            title.title.text = data.title_name;
                        }
                        rowItem = new ItemRow();
                        rowItem.data = data;
                        _skin.mcContainer.addChild(rowItem);
                        rowItem.y = pos;
                        pos += rowItem.height + 3;
                        _litters.push(rowItem);
                    }
                }

                datas = StrongerDataManager.instance.getDatasByTypeAndTitle(selectIndex + 1, StrongerDataManager.TITLE_2);//第二个子标签
                if (datas)
                {
                    title = new TitleRow();
                    title.title.textColor = 0xd5b300;
                    title.x = 0;
                    title.y = pos;
                    pos += title.height;
                    _skin.mcContainer.addChild(title);
                    for (i = 0, len = datas.length; i < len; i++)
                    {
                        data = datas[i];
                        if (i == 0)
                        {
                            title.visible = true;
                            title.title.text = data.title_name;
                        }
                        rowItem = new ItemRow();
                        rowItem.data = data;
                        _skin.mcContainer.addChild(rowItem);
                        rowItem.y = pos;
                        pos += rowItem.height + 3;
                        _litters.push(rowItem);
                    }
                }

                //更新滚动条位置
                _contentHeight = pos;
                refreshScroll();
            }
        }

        public function refreshScroll():void
        {
            if (_scrollBar)
            {
                _scrollBar.resetScroll();
            }
        }

        private function clearContainer():void
        {
            _litters.forEach(function (element:ItemRow, index:int, array:Array):void
            {
                element.destroy();
            });
            if (_skin.mcContainer && _skin.mcContainer.numChildren)
            {
                ObjectUtils.clearAllChild(_skin.mcContainer);
            }
        }

        private function initialize():void
        {
            _skin.txtName.mouseEnabled = false;
            _skin.txtName.textColor = 0xffe1aa;
            _skin.txtName.text = StringConst.STRONGER_001;

            initData();
        }

        private function initData():void
        {
            _scrollRect = new Rectangle(0, 0, _skin.mcLayer.width, _skin.mcLayer.height);
            _skin.mcContainer.scrollRect = _scrollRect;
        }

        public function initScroll(mc:MovieClip):void
        {
            _scrollBar = new ScrollBar(this, mc, 0, _skin.mcContainer, 10);
            _scrollBar.resetHeight(_scrollRect.height);
            _scrollBar.resetScroll();
        }

        public function scrollTo(pos:int):void
        {
            _scrollRect.y = pos;
            _skin.mcContainer.scrollRect = _scrollRect;
        }

        public function get contentHeight():int
        {
            return _contentHeight;
        }

        public function get scrollRectHeight():int
        {
            return _scrollRect.height;
        }

        public function get scrollRectY():int
        {
            return _scrollRect.y;
        }

        public function destroy():void
        {
            StrongerEvent.removeEventListener(StrongerEvent.SWITCH_TAB, update);
            if (_scrollBar)
            {
                _scrollBar.destroy();
                _scrollBar = null;
            }
            if (_scrollRect)
            {
                _scrollRect = null;
            }
        }
    }
}

import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.gameWindow.rsr.RsrLoader;
import com.view.gameWindow.panel.panels.stronger.McStrongerTitle;

class TitleRow extends McStrongerTitle
{
    private var _rsrLoader:RsrLoader;

    public function TitleRow()
    {
        mouseEnabled = false;
        mouseChildren = false;
        _rsrLoader = new RsrLoader();
        _rsrLoader.load(this, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
    }

    public function destroy():void
    {
        if (_rsrLoader)
        {
            _rsrLoader.destroy();
            _rsrLoader = null;
        }
    }
}