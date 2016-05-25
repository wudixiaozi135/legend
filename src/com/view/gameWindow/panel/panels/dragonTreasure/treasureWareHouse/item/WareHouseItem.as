package com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse.item
{
    import com.model.consts.SlotType;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.StorageDataInfo;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/2/13.
     */
    public class WareHouseItem extends Sprite
    {
        private const ICON_SIZE:int = 36;
        private var _cell:TreasureWareHouseCell;
        private var _cellEx:IconCellEx;
        private var _dt:*;
        private var _data:StorageDataInfo;

        private var _onClickHandler:Function;
        private var _doubleClickHandler:Function;
        private var _id:int;
        private var _slot:int;
        private var _count:int;
        private var _bind:int;
        private var _type:int;
        private var _bornId:int;

        public function WareHouseItem()
        {
            super();
            init();
            addEvent();
            mouseEnabled = false;
        }

        private function addEvent():void
        {
            _cellEx.doubleClickEnabled = true;
            _cellEx.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
            _cellEx.addEventListener(MouseEvent.CLICK, onCellClick, false, 0, true);
        }

        private function onDoubleClick(event:MouseEvent):void
        {
            if (_doubleClickHandler != null)
            {
                _doubleClickHandler(this);
            }
        }

        public function doubleClickHandler(value:Function):WareHouseItem
        {
            if (_doubleClickHandler != value)
            {
                _doubleClickHandler = value;
            }
            return this;
        }

        private function onCellClick(event:MouseEvent):void
        {
            if (_onClickHandler != null)
            {
                _onClickHandler(this);
            }
        }

        public function clickHandler(value:Function):WareHouseItem
        {
            if (_onClickHandler != value)
            {
                _onClickHandler = value;
            }
            return this;
        }

        private function init():void
        {
            _cell = new TreasureWareHouseCell();
            addChild(_cell);
            _cellEx = new IconCellEx(_cell, 0, 0, ICON_SIZE, ICON_SIZE);
        }

        public function setData(data:StorageDataInfo):void
        {
            ToolTipManager.getInstance().detach(_cellEx);
            this._data = data;
            if (_data != null)
            {
                if (_data.type == SlotType.IT_ITEM)
                {
                    if (_id != _data.id || _type != _data.type || _slot != _data.slot || _bind != _data.bind || _count != _data.count)
                    {
                        _dt = null;
                        _dt = new ThingsData();
                        _dt.id = _data.id;
                        _dt.type = _data.type;
                        _dt.slot = _data.slot + 1;//仓库里的位置
                        _dt.bind = _data.bind;
                        _dt.count = _data.count;
                        IconCellEx.setItemByThingsData(_cellEx, _dt);//保证数据正确
                    }
                } else
                {
                    if (_id != _data.id || _bornId != _data.born_sid || _type != _data.type || _slot != _data.slot || _bind != _data.bind || _count != _data.count)
                    {
                        _dt = null;
                        _dt = new BagData();
                        _dt.bornSid = _data.born_sid;
                        _dt.id = _data.id;
                        _dt.type = _data.type;
                        _dt.slot = _data.slot + 1;//仓库里的位置
                        _dt.bind = _data.bind;
                        _dt.count = _data.count;
                        IconCellEx.setEquipMemByBagData(_cellEx, _dt);
                    }
                }
                ToolTipManager.getInstance().attach(_cellEx);
                if (_cellEx.visible != true)
                {
                    _cellEx.visible = true;
                }
            } else
            {
                _cellEx.setNull();
                _cellEx.visible = false;
            }
        }

        public function destroy():void
        {
            if (_data)
            {
                _data = null;
            }
            if (_cellEx)
            {
                _cellEx.removeEventListener(MouseEvent.CLICK, onCellClick);
                _cellEx.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
                ToolTipManager.getInstance().detach(_cellEx);
                _cellEx.destroy();
                _cellEx = null;
            }
            if (_cell && contains(_cell))
            {
                removeChild(_cell);
                _cell = null;
            }
            if (_dt)
            {
                _dt = null;
            }
            if (_onClickHandler != null)
            {
                _onClickHandler = null;
            }
            if (_doubleClickHandler != null)
            {
                _doubleClickHandler = null;
            }
        }

        public function get cellEx():IconCellEx
        {
            return _cellEx;
        }
    }
}
