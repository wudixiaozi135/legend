package com.view.gameWindow.panel.panels.wing
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.WingUpgradeCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.LoaderCallBackAdapter;

    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/3/19.
     */
    public class PanelWing extends PanelBase implements IWingBlessPoint
    {
        private var _mouseHandler:WingMouseHandler;
        private var _viewHandler:WingViewHandler;
        private var _hightLight:HighlightEffectManager;
        private var _hightLightStart:HighlightEffectManager;
        public function PanelWing()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McPanelWing();
            addChild(_skin);
            setTitleBar(_skin.dragBox);
            _hightLight = new HighlightEffectManager();
            _hightLightStart = new HighlightEffectManager();
        }

        override protected function initData():void
        {
            _mouseHandler = new WingMouseHandler(this);
            _viewHandler = new WingViewHandler(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McPanelWing = _skin as McPanelWing;
            var adapt:LoaderCallBackAdapter = new LoaderCallBackAdapter();
            adapt.addCallBack(rsrLoader, function ():void
            {
                var cfg:WingUpgradeCfgData = ConfigDataManager.instance.wingUpgradeCfg(PanelWingDataManager.WING_MIN_ID);
                var name:String = ConfigDataManager.instance.itemCfgData(cfg.cost_item_id).name;
                var msg:String = HtmlUtils.createHtmlStr(0xebab5c, StringUtil.substitute(StringConst.WING_013, name, cfg.cost_gold));
                ToolTipManager.getInstance().attachByTipVO(skin.btnCheck, ToolTipConst.TEXT_TIP, msg);
                if (_viewHandler)
                {
                    var wingCfg:WingUpgradeCfgData = ConfigDataManager.instance.wingUpgradeCfg(_viewHandler.currentId);
                    if (wingCfg.next_id <= 0)
                    {
                        setHight(false);
                    } else
                    {
                        setHight(true);
                    }
                }

                if (_viewHandler)
                {
                    _viewHandler.refresh();
                }
                cfg = null;
                name = null;
                msg = null;
            }, skin.leftName, skin.rightName, skin.leftTitle, skin.rightTitle, skin.btnStart, skin.btnCheck);

            rsrLoader.addCallBack(skin.btnAuto, function (mc:MovieClip):void
            {
                if (mc)
                {
                    var msg:String = HtmlUtils.createHtmlStr(0xa56238, StringConst.WING_019, 12, false, 6);
                    ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, msg);
                }
            });
        }

        public function setHight(bool:Boolean):void
        {
            if (bool)
            {
                if (_hightLight && _skin.btnCheck)
                {
                    _hightLight.show(_skin.btnCheck, _skin.btnCheck);
                }
            } else
            {
                if (_hightLight && _skin.btnCheck)
                {
                    _hightLight.hide(_skin.btnCheck);
                }
            }
        }

        public function setStartHight(bool:Boolean):void
        {
            if (bool)
            {
                if (_hightLightStart && _skin.btnStart)
                {
                    _hightLightStart.show(_skin.btnStart, _skin.btnStart);
                }
            } else
            {
                if (_hightLightStart && _skin.btnStart)
                {
                    _hightLightStart.hide(_skin.btnStart);
                }
            }
        }

        override public function setPostion():void
        {
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnWing.x, mc.btnWing.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }


        override public function getPanelRect():Rectangle
        {
            return new Rectangle(0, 0, _skin.bg.width, _skin.bg.height);
        }

        override public function destroy():void
        {
            if (_hightLightStart)
            {
                if (_skin.btnStart)
                {
                    _hightLightStart.hide(_skin.btnStart);
                }
                _hightLightStart = null;
            }
            if (_skin.btnAuto)
            {
                ToolTipManager.getInstance().detach(_skin.btnAuto);
            }
            if (_skin.btnCheck)
            {
                ToolTipManager.getInstance().detach(_skin.btnCheck);
            }
            if (_hightLight)
            {
                if (_skin.btnCheck)
                {
                    _hightLight.hide(_skin.btnCheck);
                }
                _hightLight = null;
            }
            if (_mouseHandler)
            {
                _mouseHandler.destroy();
                _mouseHandler = null;
            }
            if (_viewHandler)
            {
                _viewHandler.destroy();
                _viewHandler = null;
            }
            super.destroy();
        }

        public function get mouseHandler():WingMouseHandler
        {
            return _mouseHandler;
        }

        public function get viewHandler():WingViewHandler
        {
            return _viewHandler;
        }

        public function get point():Point
        {
            var skin:McPanelWing = _skin as McPanelWing;
            if (skin)
            {
                return skin.localToGlobal(new Point(skin.txtBless.x, skin.txtBless.y - 50));
            }
            return new Point(0, 0);
        }
    }
}
