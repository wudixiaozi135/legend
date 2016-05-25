package com.view.gameWindow.panel.panels.thingNew.equipUpgrade
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipDegreeCfgData;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.cell.CellData;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    /**
     * Created by Administrator on 2015/1/30.
     */
    public class EquipUpgradeViewHandler implements IObserver
    {
        private var _panel:PanelEquipUpgradeAlert;
        private var _skin:McEquipAlert;
        private var _thing:ThingsData;
        private var _iconEx:IconCellEx;
        private var _cellData:CellData;//检测的是否有可进阶的装备
        private var _nextCfg:EquipDegreeCfgData;
        private var _currentCfg:EquipDegreeCfgData;
        public function EquipUpgradeViewHandler(panel:PanelEquipUpgradeAlert)
        {
            _panel = panel;
            _skin = _panel.skin as McEquipAlert;
            init();
            EquipUpgradeDataManager.instance.attach(this);
            refresh();
        }

        private function init():void
        {
            _skin.title.mouseEnabled = false;
            _skin.title.textColor = 0xffcc00;
            _skin.title.text = StringConst.PANEL_EQUIP_UPGRADE_ALERT_001;

            _skin.txtRadio.mouseEnabled = false;
            _skin.txtRadio.textColor = 0x53b436;
            _skin.txtRadio.text = StringConst.PROMPT_PANEL_0027;

            _skin.txtContent.mouseEnabled = false;
            _skin.txtContent.text = StringConst.PANEL_EQUIP_UPGRADE_ALERT_002;

            _thing = new ThingsData();
            _iconEx = new IconCellEx(_skin.mcIcon, 0, 0, _skin.mcIcon.width, _skin.mcIcon.height);
        }

        public function refresh():void
        {
            var cellData:CellData = EquipUpgradeDataManager.instance.cellData;
            if (_cellData != cellData)
            {
                _cellData = cellData;
                ToolTipManager.getInstance().detach(_iconEx);

                if (_cellData)
                {
                    _thing.id = _cellData.id;
                    _thing.type = SlotType.IT_EQUIP;
                    _thing.bornSid = _cellData.bornSid;
                    if (_cellData.memEquipData)
                    {
                        _thing.bind = _cellData.memEquipData.bind;
                        _currentCfg = ConfigDataManager.instance.equipDegreeCfgData(_cellData.memEquipData.baseId);
                        if (_currentCfg)
                        {
                            _nextCfg = ConfigDataManager.instance.equipDegreeCfgData(_currentCfg.next_id);
                            if (_nextCfg)
                            {
                                _skin.txtContent.htmlText = "<font color='#ffffff'>" + StringConst.PANEL_EQUIP_UPGRADE_ALERT_002 + "</font>" +
                                "<font color='#096898'> " + _nextCfg.name + "</font>";
                            }
                        }
                    }
                    IconCellEx.setItemByThingsData(_iconEx, _thing);
                    ToolTipManager.getInstance().attach(_iconEx);
                }
            }
        }

        public function destroy():void
        {
            EquipUpgradeDataManager.instance.detach(this);
            if (_thing)
            {
                _thing = null;
            }
            if (_iconEx)
            {
                ToolTipManager.getInstance().detach(_iconEx);
                _iconEx.destroy();
                _iconEx = null;
            }
            if (_nextCfg)
            {
                _nextCfg = null;
            }
            if (_currentCfg)
            {
                _currentCfg = null;
            }
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_BAG_ITEMS || proc == GameServiceConstants.SM_MEM_UNIQUE_EQUIP_INFO)
            {
                refresh();
            }
        }
    }
}
