package com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.StorageDataInfo;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse.item.WareHouseItem;
    import com.view.gameWindow.util.cell.IconCellEx;

    import flash.display.MovieClip;

    /**
     * Created by Administrator on 2014/12/1.
     */
    public class TreasureWareHouseViewHandler implements IObserver
    {
        private var _cellIcons:Vector.<WareHouseItem>;
        private static const TOTAL_CELL_NUM:int = 64;//64个格子数量
        private static const ICON_SIZE:int = 36;//图片尺寸

        public static const TOTAL_PAGES:int = 5;
        private var _totalPage:int = TOTAL_PAGES;
        private var _currentPage:int = 1;
        private var _totalDatas:Vector.<StorageDataInfo>;


        private var _panel:PanelTreasureWareHouse;
        private var _skin:McTreasureWareHouse;

        public function TreasureWareHouseViewHandler(panel:PanelTreasureWareHouse)
        {
            _panel = panel;
            _skin = _panel.skin as McTreasureWareHouse;
            _cellIcons = new Vector.<WareHouseItem>(TOTAL_CELL_NUM);
            initialize();
            updatePage();
            DragonTreasureManager.instance.attach(this);
        }

        private function onCellClick(wareItem:WareHouseItem):void
        {
            var item:IconCellEx = wareItem.cellEx;
            var mcSelect:MovieClip = _skin.mcSelect;
            if (item)
            {
                mcSelect.x = wareItem.x + _skin.container.x;
                mcSelect.y = wareItem.y + _skin.container.y;
                mcSelect.visible = true;
                DragonTreasureManager.lastSlotMc = item;
            }
        }

        private function onDoubleClick(item:WareHouseItem):void
        {
            var ex:IconCellEx = item.cellEx;
            if (ex)
            {
                DragonTreasureManager.instance.sendTakeOutGoods(ex.slot);
            }
        }

        public function refresh():void
        {
            var mgt:DragonTreasureManager = DragonTreasureManager.instance;
            _totalDatas = mgt.storageDatas;

            var item:WareHouseItem = null;
            var data:StorageDataInfo = null;
            var count:int = 0;

            var i:int = 0, len:int = 0;
            for (i = (_currentPage - 1) * TOTAL_CELL_NUM, len = _currentPage * TOTAL_CELL_NUM; i < len; i++)
            {
                item = _cellIcons[count];
                if (!item)
                {
                    item = new WareHouseItem().clickHandler(onCellClick)
                            .doubleClickHandler(onDoubleClick);
                    _skin.container.addChild(item);
                }

                if (i < _totalDatas.length)
                {
                    data = _totalDatas[i];
                } else
                {
                    data = null;
                }
                item.setData(data);
                _cellIcons[count] = item;
                count++;
            }

            setLayout();
            updateVolumeTxt();
        }

        private function setLayout():void
        {
            var pos:int = 0;
            var item:WareHouseItem = null;
            for (var i:int = 0, len:int = _cellIcons.length; i < len; i++)
            {
                item = _cellIcons[i];
                if (item && item.visible)
                {
                    _cellIcons[i].x = (ICON_SIZE + 6) * (pos % 8);
                    _cellIcons[i].y = (ICON_SIZE + 7) * int(pos / 8);
                    pos++;
                }
            }
        }

        public function turnLeft():void
        {
            if (_currentPage > 1)
            {
                _currentPage--;
            }
            updatePage();
        }

        public function turnRight():void
        {
            if (_currentPage < _totalPage)
            {
                _currentPage++;
            }
            updatePage();
        }

        private function updatePage():void
        {
            _skin.txtContent.text = _currentPage + "/" + _totalPage;

            if (_totalPage == 1)
            {
                _skin.btnLeft.btnEnabled = false;
                _skin.btnRight.btnEnabled = false;
            } else
            {
                if (_currentPage < _totalPage)
                {
                    if (_currentPage != 1)
                    {
                        _skin.btnLeft.btnEnabled = true;
                        _skin.btnRight.btnEnabled = true;
                    } else
                    {
                        _skin.btnLeft.btnEnabled = false;
                        _skin.btnRight.btnEnabled = true;
                    }
                } else if (_currentPage == _totalPage)
                {
                    _skin.btnLeft.btnEnabled = true;
                    _skin.btnRight.btnEnabled = false;
                }
            }
            refresh();
        }

        private function initialize():void
        {
            _skin.txtContent.mouseEnabled = false;
            _skin.txtVolume.mouseEnabled = false;

            _skin.txtMakeUp.text = StringConst.STORAGE_003;
            _skin.txtMakeUp.mouseEnabled = false;

            _skin.txtGetOut.text = StringConst.PANEL_DRAGON_TREASURE_018;
            _skin.txtGetOut.mouseEnabled = false;
            _skin.container.mouseEnabled = false;
        }

        public function update(proc:int = 0):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_FIND_TREASURE_STORAGE:
                    refresh();
                    break;
                case GameServiceConstants.CM_GET_FIND_TREASURE_STORAGE:
                    updateLastSlotMc();
                    break;
                case GameServiceConstants.CM_FIND_TREASURE_STORAGE_CLEARUP://整理成功
                    break;
                default :
                    break;
            }
        }

        private function updateVolumeTxt():void
        {
            var mgt:DragonTreasureManager = DragonTreasureManager.instance;
            _skin.txtVolume.text = mgt.storageDatas.length + "/" + DragonTreasureManager.STORAGE_MAX;
        }

        private function updateLastSlotMc():void
        {
            var mgt:DragonTreasureManager = DragonTreasureManager.instance;
            if (_skin)
            {
                _skin.mcSelect.visible = false;
                if (mgt.storageDatas && mgt.storageDatas.length && _cellIcons && _cellIcons.length)
                {
                    onCellClick(_cellIcons[0]);
                }
            }
        }

        public function destroy():void
        {
            DragonTreasureManager.instance.detach(this);
            if (_skin)
            {
                if (_cellIcons)
                {
                    _cellIcons.forEach(function (element:WareHouseItem, index:int, vec:Vector.<WareHouseItem>):void
                    {
                        if (element && element.parent)
                        {
                            _skin.container.removeChild(element);
                            element.destroy();
                            element = null;
                        }
                    });
                    _cellIcons.length = 0;
                    _cellIcons = null;
                }
                _skin.removeChild(_skin.container);
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
