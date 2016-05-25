package com.view.gameWindow.panel.panels.stronger
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.stronger.data.StrongerEvent;
    import com.view.gameWindow.panel.panels.stronger.data.StrongerTabType;
    import com.view.gameWindow.util.ObjectUtils;

    import flash.display.MovieClip;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2014/12/22.
     * 我要为强面板
     */
    public class PanelStronger extends PanelBase implements IPanelTab
    {
		private var _viewHandler:StrongerViewHandler;
        private var _mouseHandler:StrongerMouseHandler;

        public function PanelStronger()
        {
            super();
        }
		
		public function getTabIndex():int
		{
			return StrongerDataManager.selectIndex;
		}
		
		public function setTabIndex(index:int):void
		{
			switchToTab(index);
		}

        override protected function initSkin():void
        {
            _skin = new McStronger();
            addChild(_skin);
            setTitleBar(_skin.mcTitleBar);
        }

        override protected function initData():void
        {
            _viewHandler = new StrongerViewHandler(this);
            _mouseHandler = new StrongerMouseHandler(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McStronger = _skin as McStronger;
            var i:int = 0, len:int = 8;

            for (; i < len; i++)
            {
                rsrLoader.addCallBack(skin["pic" + i], getPic(i));
            }
            i = 0;

            for (; i < len; i++)
            {
                rsrLoader.addCallBack(skin["tab" + i], getTab(i));
            }

            rsrLoader.addCallBack(skin.mcScrollBar, function (mc:MovieClip):void
            {
                if (_viewHandler)
                {
                    _viewHandler.initScroll(mc);
                    _viewHandler.refreshScroll();
                }
            });

            /////////以下是屏蔽功能
            skin.tab7.visible = skin.pic7.visible = false;
        }

        private function getTab(i:int):Function
        {
            var func:Function = function (mc:MovieClip):void
            {
                var selectIndex:int = StrongerDataManager.selectIndex;
                var lastMc:MovieClip;
                if (selectIndex >= 0)
                {
                    if (i == selectIndex)
                    {
                        switchToTab(selectIndex);
                        StrongerDataManager.lastMc = mc;
                        lastMc = StrongerDataManager.lastMc;
                        lastMc.selected = true;
                        lastMc.mouseEnabled = false;
                    }
                } else
                {
                    if (i == 0)
                    {
                        switchToTab();
                        StrongerDataManager.lastMc = mc;
                        lastMc = StrongerDataManager.lastMc;
                        lastMc.selected = true;
                        lastMc.mouseEnabled = false;
                    }
                }
            };
            return func;
        }

        /**切换到某一个标签页
         * @type 使用StrongerTabType
         * 默认选择第一个
         * */
        public function switchToTab(type:int = StrongerTabType.TAB_EXPERIENCE):void
        {
            StrongerDataManager.selectIndex = type;
            StrongerEvent.dispatchEvent(new StrongerEvent(StrongerEvent.SWITCH_TAB, {tabIndex: StrongerDataManager.selectIndex}));
        }

        private function getPic(i:int):Function
        {
            var func:Function = function (mc:MovieClip):void
            {
                mc.mouseEnabled = false;
                mc.mouseChildren = false;
                var selectIndex:int = StrongerDataManager.selectIndex;
                var lastMc:MovieClip;
                if (selectIndex >= 0)
                {
                    if (i == selectIndex)
                    {
                        mc.filters = [ObjectUtils.btnlightFilter];
                    }
                } else
                {
                    if (i == 0)
                    {
                        mc.filters = [ObjectUtils.btnlightFilter];
                    }
                }
            };
            return func;
        }


        override public function setPostion():void
        {
//            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
//            if (mc)
//            {
//                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnStronger.x, mc.mcBtns.mcLayer.btnStronger.y));
//                isMount(true, popPoint.x, popPoint.y);
//            } else
//            {
//                isMount(true);
//            }

            var mc:McMapProperty = (MainUiMediator.getInstance().miniMap as MiniMap).skin as McMapProperty;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnStronger.x, mc.btnStronger.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }

        }

        override public function destroy():void
        {
            StrongerDataManager.selectIndex = -1;
            StrongerDataManager.lastMc = null;

            if (_viewHandler)
            {
                _viewHandler.destroy();
                _viewHandler = null;
            }
            if (_mouseHandler)
            {
                _mouseHandler.destroy();
                _mouseHandler = null;
            }
            super.destroy();
        }
    }
}
