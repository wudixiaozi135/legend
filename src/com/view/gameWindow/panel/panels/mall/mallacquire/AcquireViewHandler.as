package com.view.gameWindow.panel.panels.mall.mallacquire
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.AnnouncementCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.TeleportDatamanager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panels.guideSystem.UICenter;
    import com.view.gameWindow.panel.panels.mall.McAcquirePanel;
    import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.linkText.LinkText;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.scrollBar.IScrollee;
    import com.view.gameWindow.util.scrollBar.ScrollBar;

    import flash.display.MovieClip;
    import flash.events.TextEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2014/11/22.
     */
    public class AcquireViewHandler implements IScrollee
    {
        private var _panel:PanelAcquire;
        private var _skin:McAcquirePanel;
        private var _scrollBar:ScrollBar;
        private var _scrollRect:Rectangle;

        private var _contentHeight:int;
        private var _link:LinkText;
        private var _linkDesc:TextField;
        private var _uiCenter:UICenter;

        public function AcquireViewHandler(panel:PanelAcquire)
        {
            this._panel = panel;
            _skin = _panel.skin as McAcquirePanel;
            init();
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

        public function initScrollBar(mc:MovieClip):void
        {
            _scrollBar = new ScrollBar(this, mc, 0, _skin.mcLayer, 10);
            _scrollBar.resetHeight(_scrollRect.height);
        }

        public function update():void
        {
            updateLinkTxt();
            _contentHeight = _skin.mcLayer.height;
            if (_scrollBar)
            {
                _scrollBar.resetScroll();
            }
        }

        public function scrollTo(pos:int):void
        {
            _scrollRect.y = pos;
            _skin.mcLayer.scrollRect = _scrollRect;
        }


        private function init():void
        {
            _uiCenter = new UICenter();
            _skin.txtName.textColor = 0xd4a460;
            _skin.txtName.mouseEnabled = false;
            _skin.txtName.text = StringConst.MALL_ACQUIRE_1;

            _skin.txtTitle.mouseEnabled = false;

            _skin.txtOk.textColor = 0xd4a460;
            _skin.txtOk.mouseEnabled = false;
            _skin.txtOk.text = StringConst.MALL_ACQUIRE_2;

            _scrollRect = new Rectangle(0, 0, _skin.mcLayer.width, _skin.mcLayer.height);
            _link = new LinkText();
            _linkDesc = new TextField();
			_linkDesc.selectable = false;
			_linkDesc.width = _skin.mcLayer.width;
//            _linkDesc.wordWrap = true;
            _linkDesc.addEventListener(TextEvent.LINK, onLinkEvt, false, 0, true);
            _skin.mcLayer.addChild(_linkDesc);

            update();
        }

        private function onLinkEvt(event:TextEvent):void
        {
            var num:int = _link.getItemCount();
            var name:String;
			var regionId:int;
            var tabIndex:int;
            for (var i:int = 1; i < num + 1; i++)
            {
                if (event.text == i.toString())
                {
                    regionId = _link.getItemById(i).mapRegion;
                    if (regionId > 0)
                    {
                        if (RoleDataManager.instance.isCanFly == 0)
                        {
                            RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0008);
                            return;
                        }
                        TeleportDatamanager.instance.requestTeleportRegion(regionId);
                        PanelMediator.instance.closePanel(PanelConst.TYPE_MALL_ACQUIRE);
                    } else
                    {
                        name = UICenter.getUINameFromMenu(_link.getItemById(i).panelId.toString());
                        if (name)
                        {
                            _uiCenter.openUI(name);
                            tabIndex = _link.getItemById(i).panelPage;
                            if (tabIndex > 0)
                            {
                                var tab:IPanelTab = UICenter.getUI(name) as IPanelTab;
                                if (tab)
                                {
                                    tab.setTabIndex(tabIndex);
                                }
                            }
                        }
                    }
                }
            }
        }

        private function updateLinkTxt():void
        {
            var costType:int = AcquireManager.costType;
            var announceId:int = AcquireManager.instance.getIdByType(costType);
            var announceCfg:AnnouncementCfgData = ConfigDataManager.instance.announcementCfgData(announceId);
            _skin.txtTitle.htmlText = StringUtil.substitute(StringConst.MALL_ACQUIRE_3, StringConst["MALL_COST_TYPE_" + costType]);
            _link.init(CfgDataParse.pareseDesToStr(announceCfg.text));
            _linkDesc.htmlText = _link.htmlText;
        }

        public function destroy():void
        {
            if (_scrollRect)
            {
                _scrollRect = null;
            }
            if (_scrollBar)
            {
                _scrollBar.destroy();
                _scrollBar = null;
            }
            if (_uiCenter)
            {
                _uiCenter = null;
            }
            if (_skin)
            {
                if (_linkDesc)
                {
                    _linkDesc.removeEventListener(TextEvent.LINK, onLinkEvt);
                    if (_skin.mcLayer.contains(_linkDesc))
                    {
                        _skin.mcLayer.removeChild(_linkDesc);
                        _linkDesc = null;
                    }
                }
                _skin = null;
            }
        }
    }
}
