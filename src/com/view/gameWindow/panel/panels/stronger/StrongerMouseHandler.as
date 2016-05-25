package com.view.gameWindow.panel.panels.stronger
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.stronger.data.StrongerEvent;
    import com.view.gameWindow.panel.panels.stronger.data.StrongerTabType;
    import com.view.gameWindow.util.ObjectUtils;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2014/12/22.
     */
    public class StrongerMouseHandler
    {
        private var _panel:PanelStronger;
        private var _skin:McStronger;

        public function StrongerMouseHandler(panel:PanelStronger)
        {
            _panel = panel;
            _skin = _panel.skin as McStronger;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.tab0:
                    dealTab(_skin.tab0, StrongerTabType.TAB_EXPERIENCE);
                    break;
                case _skin.tab1:
                    dealTab(_skin.tab1, StrongerTabType.TAB_EQUIP);
                    break;
                case _skin.tab2:
                    dealTab(_skin.tab2, StrongerTabType.TAB_STRONGER);
                    break;
                case _skin.tab3:
                    dealTab(_skin.tab3, StrongerTabType.TAB_HERO);
                    break;
                case _skin.tab4:
                    dealTab(_skin.tab4, StrongerTabType.TAB_WEALTH);
                    break;
                case _skin.tab5:
                    dealTab(_skin.tab5, StrongerTabType.TAB_POSITION);
                    break;
                case _skin.tab6:
                    dealTab(_skin.tab6, StrongerTabType.TAB_PROPERTY);
                    break;
                case _skin.tab7:
                    dealTab(_skin.tab7, StrongerTabType.TAB_HERO_UPDATE);
                    break;
                default :
                    break;
            }
        }

        private function dealTab(tab:MovieClip, type:int):void
        {
            var lastMc:MovieClip = StrongerDataManager.lastMc;
            if (lastMc)
            {
                lastMc.selected = false;
                lastMc.mouseEnabled = true;
            }

            tab.selected = true;
            tab.mouseEnabled = false;

            StrongerDataManager.lastMc = tab;
            StrongerDataManager.selectIndex = type;
            dispatchEvt();
            updateMcTxt(_skin["pic" + type]);
        }

        private function updateMcTxt(mc:MovieClip):void
        {
            for (var i:int = 0; i < 8; i++)
            {
                if (_skin["pic" + i])
                {
                    _skin["pic" + i].filters = null;
                }
            }
            mc.filters = [ObjectUtils.btnlightFilter];
        }

        private function dispatchEvt():void
        {
            var param:Object = {};
            param.tabIndex = StrongerDataManager.selectIndex;
            var evt:StrongerEvent = new StrongerEvent(StrongerEvent.SWITCH_TAB, param);
            StrongerEvent.dispatchEvent(evt);
            evt = null;
            param = null;
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_BECOME_STRONGER);
        }

        private function initialize():void
        {

        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
            }
        }
    }
}
