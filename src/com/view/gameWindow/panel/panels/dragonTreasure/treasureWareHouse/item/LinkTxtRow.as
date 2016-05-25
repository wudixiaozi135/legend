package com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse.item
{
    import com.model.configData.ConfigDataManager;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.TreasureEventData;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.scrollBar.IScrolleeCell;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    /**
     * Created by Administrator on 2014/12/4.
     */
    public class LinkTxtRow extends Sprite implements IScrolleeCell
    {
        private var _txtRoleName:TextField;
        private var _txtContent:TextField;
        private var _txtItemName:TipTxt;
        private var _container:Sprite;

        private var _data:TreasureEventData;

        public function LinkTxtRow()
        {
            addChild(_container = new Sprite());
            _txtRoleName = new TextField();
            _txtRoleName.autoSize = "left";
            _txtRoleName.selectable = false;
            _container.addChild(_txtRoleName);

            _txtContent = new TextField();
            _txtContent.autoSize = "left";
            _txtContent.mouseEnabled = false;
            _container.addChild(_txtContent);

            _txtItemName = new TipTxt();
            _txtItemName.autoSize = "left";
            _txtItemName.selectable = false;
            _container.addChild(_txtItemName);
            addEvent();
        }

        private function addEvent():void
        {
            addEventListener(Event.REMOVED, onRemove, false, 0, true);
            _txtItemName.addEventListener(MouseEvent.ROLL_OUT, onRollEvt, false, 0, true);
            _txtItemName.addEventListener(MouseEvent.ROLL_OVER, onRollEvt, false, 0, true);
            ToolTipManager.getInstance().attach(_txtItemName);
        }

        private function onRemove(event:Event):void
        {
            destroy();
        }

        private function onRollEvt(event:MouseEvent):void
        {
            if (event.type == MouseEvent.ROLL_OUT)
            {
                _txtItemName.filters = null;
            } else if (event.type == MouseEvent.ROLL_OVER)
            {
                ObjectUtils.addFilter(_txtItemName, ObjectUtils.highlightFilter);
            }
        }

        private function resetLayout():void
        {
            _txtRoleName.x = 0;
            _txtRoleName.y = 0;
            _txtContent.x = _txtRoleName.x + _txtRoleName.width;
            _txtContent.y = _txtRoleName.y;
            _txtItemName.x = _txtContent.x + _txtContent.width;
            _txtItemName.y = _txtContent.y;
        }

        public function get data():TreasureEventData
        {
            return _data;
        }

        public function set data(value:TreasureEventData):void
        {
            _data = value;

            var str:String = "", middle:String = "";
            var goodsName:String = "", username:String = "", cfg:Object;
            var color:int = 0;

            if (_data.itemType == SlotType.IT_ITEM)
            {
                cfg = ConfigDataManager.instance.itemCfgData(_data.itemId);
                color = ItemType.getColorByQuality(cfg.quality);
            } else if (_data.itemType == SlotType.IT_EQUIP)
            {
                cfg = DragonTreasureManager.instance.getMemEquipData(_data.bornSid, _data.itemId).equipCfgData;
                color = ItemType.getColorByQuality(cfg.color);
            }

            var colorStr:String = "#" + color.toString(16);
            username = "<font color='#ffc000'><u>" + data.name + "</u></font>";
            middle = "<font color='#bb4b4b4'>" + StringConst.PANEL_DRAGON_TREASURE_016 + "</font>";
            goodsName = "<font color='" + colorStr + "'><u>" + cfg.name + "</u></font>";

            var linkStr:String = data.itemType + ":" + data.itemId;
            if (_txtRoleName)
            {
                _txtRoleName.htmlText = username;
            }
            if (_txtContent)
            {
                _txtContent.htmlText = middle;
            }
            if (_txtItemName)
            {
                _txtItemName.data = data;
                _txtItemName.htmlText = goodsName;
            }
            resetLayout();
        }

        private function removeEvent():void
        {
            removeEventListener(Event.REMOVED, onRemove);
            ToolTipManager.getInstance().detach(_txtItemName);
            _txtItemName.removeEventListener(MouseEvent.ROLL_OUT, onRollEvt);
            _txtItemName.removeEventListener(MouseEvent.ROLL_OVER, onRollEvt);
        }

        public function destroy():void
        {
            removeEvent();
            if (_container && _container.numChildren)
            {
                ObjectUtils.clearAllChild(_container);
                if (_container.parent)
                {
                    _container.parent.removeChild(_container);
                    _container = null;
                }
            }
        }
    }
}

import com.model.configData.ConfigDataManager;
import com.model.consts.SlotType;
import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
import com.view.gameWindow.panel.panels.dragonTreasure.data.TreasureEventData;
import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;

import flash.text.TextField;

class TipTxt extends TextField implements IToolTipClient
{

    private var _data:TreasureEventData;

    public function TipTxt()
    {
    }

    public function getTipData():Object
    {
        var cfg:Object;
        if (_data.itemType == SlotType.IT_ITEM)
        {
            cfg = ConfigDataManager.instance.itemCfgData(_data.itemId);
        } else if (_data.itemType == SlotType.IT_EQUIP)
        {
            cfg = DragonTreasureManager.instance.getMemEquipData(_data.bornSid, _data.itemId);
        }
        return cfg;
    }

    public function getTipType():int
    {
        return _data.itemType;
    }

    public function get data():TreasureEventData
    {
        return _data;
    }

    public function set data(value:TreasureEventData):void
    {
        _data = value;
    }
	
	public function getTipCount():int
	{
		// TODO Auto Generated method stub
		return 1;
	}
}