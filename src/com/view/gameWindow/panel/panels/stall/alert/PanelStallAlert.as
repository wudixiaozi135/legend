package com.view.gameWindow.panel.panels.stall.alert
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapRegionCfgData;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.McStallAlert;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.stall.StallDataManager;
    import com.view.gameWindow.scene.GameFlyManager;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.SimpleStateButton;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/1/21.
     */
    public class PanelStallAlert extends PanelBase
    {
        public function PanelStallAlert()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McStallAlert();
            addChild(_skin);
            var skin:McStallAlert = _skin as McStallAlert;
            skin.content.textColor = 0xffe1aa;
            skin.content.mouseEnabled = false;
            skin.content.htmlText = StringConst.STALL_PANEL_0029;
            skin.txtGo.mouseEnabled = false;
            skin.txtGo.textColor = 0xd4a460;
            skin.txtGo.text = StringConst.PROMPT_PANEL_0012;
            skin.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
            SimpleStateButton.addLinkState(skin.contentValue, StringConst.STALL_PANEL_0030);
            SimpleStateButton.addState(skin.feixieBtn);
        }

        private function onClickHandler(event:MouseEvent):void
        {
            var skin:McStallAlert = _skin as McStallAlert;

            switch (event.target)
            {
                case skin.btnGo:
                    PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_ALERT);
                    break;
                case skin.feixieBtn:
                    flyHandler();
                    break;
                case skin.contentValue:
                    goHandler();
                    break;
                default :
                    break;
            }
        }

        private function goHandler():void
        {
            closePanel();
            var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(StallDataManager.MAP_REGION_ID);
            if (!mapRegionCfgData)
            {
                return;
            }
            AutoJobManager.getInstance().setAutoFindPathPos(mapRegionCfgData.randomPoint, mapRegionCfgData.map_id, 0);
        }

        private function flyHandler():void
        {
            closePanel();
            if (RoleDataManager.instance.isCanFly == 0)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0008);
                return;
            }
            GameFlyManager.getInstance().flyToMapByRegId(StallDataManager.MAP_REGION_ID);
        }

        private function closePanel():void
        {
            if (PanelMediator.instance.openedPanel(PanelConst.TYPE_STALL_ALERT))
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_ALERT);
            }
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McStallAlert = _skin as McStallAlert;
            rsrLoader.addCallBack(skin.feixieBtn, function (mc:MovieClip):void
            {
                mc.mouseEnabled = true;
                mc.buttonMode = true;
            });
        }

        override public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClickHandler);
                SimpleStateButton.removeState(_skin.feixieBtn);
                SimpleStateButton.removeState(_skin.contentValue);
            }
            super.destroy();
        }
    }
}
