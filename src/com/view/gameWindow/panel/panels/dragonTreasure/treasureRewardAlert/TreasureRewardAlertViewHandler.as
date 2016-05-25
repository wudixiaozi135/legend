package com.view.gameWindow.panel.panels.dragonTreasure.treasureRewardAlert
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.StorageDataInfo;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.TreasureGetData;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse.item.TreasureWareHouseCell;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    /**
     * Created by Administrator on 2015/1/31.
     */
    public class TreasureRewardAlertViewHandler implements IObserver
    {

        private var _panel:PanelTreasureRewardAlert;
        private var _skin:McRewardAlert;
        private var _totalDatas:Vector.<TreasureGetData>;

        private var _cellIcons:Vector.<IconCellEx>;
        private var _cellData:Vector.<ThingsData>;
        private var _cells:Vector.<TreasureWareHouseCell>;
        private static const TOTAL_CELL_NUM:int = 64;//64个格子数量
        private static const ICON_SIZE:int = 36;//图片尺寸

        public function TreasureRewardAlertViewHandler(panel:PanelTreasureRewardAlert)
        {
            _panel = panel;
            _skin = _panel.skin as McRewardAlert;
            DragonTreasureManager.instance.attach(this);
            init();
        }

        private function init():void
        {
            _skin.sureTxt.mouseEnabled = false;
            _skin.sureTxt.textColor = 0xffe1aa;
            _skin.sureTxt.text = StringConst.PROMPT_PANEL_0003;
            _skin.container.mouseEnabled = false;
        }

        private function initData():void
        {
            var rewardTotal:int = DragonTreasureManager.instance.treasureGetDatas.length;
            var row:int = 0, column:int = 0;
            if (rewardTotal == DragonTreasureManager.COUNT_1)
            {
                row = 1;
                column = 1;
            } else if (rewardTotal == DragonTreasureManager.COUNT_5)
            {
                row = 1;
                column = 5;
            } else if (rewardTotal == DragonTreasureManager.COUNT_10)
            {
                row = 2;
                column = 5;
            }

            var cell:TreasureWareHouseCell;
            _cellIcons = new Vector.<IconCellEx>();
            _cellData = new Vector.<ThingsData>();
            _cells = new Vector.<TreasureWareHouseCell>();

            for (var i:int = 0; i < row; i++)
            {
                for (var j:int = 0; j < column; j++)
                {
                    cell = new TreasureWareHouseCell();
                    cell.mouseEnabled = false;
                    cell.x = (ICON_SIZE + 6) * j;
                    cell.y = (ICON_SIZE + 7) * i;
                    cell.bg.visible = true;
                    _skin.container.addChild(cell);
                    _cells.push(cell);
                    var cellEx:IconCellEx = new IconCellEx(cell, (cell.bg.width - ICON_SIZE) >> 1, (cell.bg.height - ICON_SIZE) >> 1, ICON_SIZE, ICON_SIZE);
                    _cellIcons.push(cellEx);

                    var dt:ThingsData = new ThingsData();
                    _cellData.push(dt);
                }
            }
        }

        public function refresh():void
        {
            destroyTip();
            initData();

            var mgt:DragonTreasureManager = DragonTreasureManager.instance;
            var iconData:StorageDataInfo, count:int = 0, dt:Object, iconEx:IconCellEx;
            _totalDatas = mgt.treasureGetDatas;

            _cellIcons.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
            {
                element.loadEffect("");
                element.visible = false;
                element.text = "";
            }, null);

            var getData:TreasureGetData;
            for (var i:int = 0, len:int = _totalDatas.length; i < len; i++)
            {
                getData = _totalDatas[i];
                iconData = getStorageData(getData.id, getData.born_sid);
                dt = _cellData[count];
                iconEx = _cellIcons[count];

                if (iconData.type == SlotType.IT_ITEM)
                {
                    dt.id = iconData.id;
                    dt.type = iconData.type;
                    dt.bind = iconData.bind;
                    dt.count = getData.count;
                    IconCellEx.setItemByThingsData(iconEx, (dt as ThingsData));//保证数据正确
                } else
                {
                    dt.bornSid = iconData.born_sid;
                    dt.id = iconData.id;
                    dt.type = iconData.type;
                    dt.bind = iconData.bind;
                    dt.count = getData.count;
                    IconCellEx.setEquipMemByBagData(iconEx, (dt as BagData));
                }
                iconEx.visible = true;
                ToolTipManager.getInstance().attach(iconEx);
                count++;
            }
            layOut();
        }

        private function getStorageData(id:int, bornId:int):StorageDataInfo
        {
            var storageDatas:Vector.<StorageDataInfo> = DragonTreasureManager.instance.storageDatas;
            for each(var item:StorageDataInfo in storageDatas)
            {
                if (item.id == id && item.born_sid == bornId)
                {
                    return item;
                }
            }
            return null;
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_FIND_TREASURE_GET)
            {
                refresh();
            }
        }

        /**界面重新布局*/
        private function layOut():void
        {
            var total:int = DragonTreasureManager.instance.treasureGetDatas.length;
            var cell:TreasureWareHouseCell;
            if (total == DragonTreasureManager.COUNT_1)
            {
                if (_cells)
                {
                    _skin.container.x = (_skin.mcBg.width - _skin.container.width) >> 1;
                    _skin.container.y = 15;
                    _skin.btnSure.x = (_skin.mcBg.width - _skin.btnSure.width) >> 1;
                    _skin.btnSure.y = (_skin.mcBg.height - _skin.btnSure.height) - 12;

                    _skin.sureTxt.x = _skin.btnSure.x + ((_skin.btnSure.width - _skin.sureTxt.width) >> 1);
                    _skin.sureTxt.y = _skin.btnSure.y + ((_skin.btnSure.height - _skin.sureTxt.height) >> 1);
                }
            } else
            {
                _skin.mcBg.width = _skin.container.width + 20;
                _skin.mcBg.height = (_skin.container.height + 28 + 31 + 12 + 20);

                _skin.btnClose.x = _skin.mcBg.width - _skin.btnClose.width;

                _skin.container.x = (_skin.mcBg.width - _skin.container.width) >> 1;
                _skin.container.y = 8 + _skin.btnClose.height;

                _skin.btnSure.x = (_skin.mcBg.width - _skin.btnSure.width) >> 1;
                _skin.btnSure.y = (_skin.mcBg.height - _skin.btnSure.height) - 12;

                _skin.sureTxt.x = _skin.btnSure.x + ((_skin.btnSure.width - _skin.sureTxt.width) >> 1);
                _skin.sureTxt.y = _skin.btnSure.y + ((_skin.btnSure.height - _skin.sureTxt.height) >> 1);
            }
            _panel.setPostion();
        }

        private function destroyTip():void
        {
            if (_cellIcons)
            {
                _cellIcons.forEach(function (cell:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
                {
                    ToolTipManager.getInstance().detach(cell);
                }, null);
            }
        }

        public function destroy():void
        {
            DragonTreasureManager.instance.detach(this);
            destroyTip();
            if (_cells)
            {
                for each(var cell:TreasureWareHouseCell in _cells)
                {
                    cell.destroy();
                    cell = null;
                }
                _cells.length = 0;
                _cells = null;
            }

            if (_skin && _skin.container)
            {
                ObjectUtils.clearAllChild(_skin.container);
            }

            if (_cellIcons)
            {
                for each(var cellIcon:IconCellEx in _cellIcons)
                {
                    cellIcon.destroy();
                    cellIcon = null;
                }
                _cellIcons.length = 0;
                _cellIcons = null;
            }

            if (_cellData)
            {
                for each(var cellData:Object in _cellData)
                {
                    cellData = null;
                }
                _cellData.length = 0;
                _cellData = null;
            }
        }
    }
}
