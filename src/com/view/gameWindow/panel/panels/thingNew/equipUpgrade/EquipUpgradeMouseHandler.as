package com.view.gameWindow.panel.panels.thingNew.equipUpgrade
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
    import com.view.gameWindow.panel.panels.forge.PanelForge;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
    import com.view.gameWindow.util.cell.CellData;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/1/30.
     */
    public class EquipUpgradeMouseHandler
    {
        private var _panel:PanelEquipUpgradeAlert;
        private var _skin:McEquipAlert;

        public function EquipUpgradeMouseHandler(panel:PanelEquipUpgradeAlert)
        {
            _panel = panel;
            _skin = _panel.skin as McEquipAlert;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                default :
                    break;
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.btnDo:
                    sendUpgrade();
                    break;
                case _skin.btnRadio:
                    setRadio();
                    break;
            }
        }

        private function setRadio():void
        {
            SelectPromptBtnManager.setSelect(SelectPromptType.SELECT_EQUIP_UPGRADE_ALERT, _skin.btnRadio.selected);
        }

        private function closeHandler():void
        {
            if (_panel)
            {
                _panel.closeHandler();
            }
        }

        private function sendUpgrade():void
        {
            var cellData:CellData = EquipUpgradeDataManager.instance.cellData;
            if (cellData)
            {
                ForgeDataManager.instance.updateTabSecond(EquipUpgradeDataManager.TYPE_SLOT, cellData.id, cellData.bornSid);
                var panel:PanelForge = PanelMediator.instance.openedPanel(PanelConst.TYPE_FORGE) as PanelForge;
                if (panel)
                {
                    panel.setTabIndex(ForgeDataManager.typeDegree);
                }
                else
                {
                    PanelMediator.instance.openPanel(PanelConst.TYPE_FORGE);
                    panel = PanelMediator.instance.openedPanel(PanelConst.TYPE_FORGE) as PanelForge;
                    panel.setTabIndex(ForgeDataManager.typeDegree);
                }
            }
            closeHandler();
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
