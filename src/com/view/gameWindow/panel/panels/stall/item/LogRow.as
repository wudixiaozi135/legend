package com.view.gameWindow.panel.panels.stall.item
{
    import com.model.configData.ConfigDataManager;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.panel.panels.stall.StallDataManager;
    import com.view.gameWindow.panel.panels.stall.data.StallLogData;

    import flash.display.Sprite;
    import flash.events.TextEvent;
    import flash.text.TextField;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/1/21.
     */
    public class LogRow extends Sprite
    {
        private var _data:StallLogData;
        private var _content:TextField;

        public function LogRow()
        {
            super();
            _content = new TextField();
            _content.textColor = 0xffe1aa;
            _content.autoSize = "left";
            addChild(_content);
            _content.addEventListener(TextEvent.LINK, onLinkEvt, false, 0, true);
        }

        private function onLinkEvt(event:TextEvent):void
        {

        }

        public function get data():StallLogData
        {
            return _data;
        }

        public function set data(value:StallLogData):void
        {
            if (_data != value)
            {
                _data = value;
                var costType:String;
                if (_data.cost_type == StallDataManager.COST_GOLD_TYPE)
                {
                    costType = StringConst.STALL_PANEL_0031;
                } else
                {
                    costType = StringConst.STALL_PANEL_0032;
                }
                var cfg:*;
                if (_data.item_type == SlotType.IT_ITEM)
                {
                    cfg = ConfigDataManager.instance.itemCfgData(_data.itme_id);
                } else
                {
                    cfg = MemEquipDataManager.instance.memEquipData(_data.born_sid, _data.itme_id).equipCfgData;
                }
                if (cfg)
                {
                    _content.htmlText = StringUtil.substitute(StringConst.STALL_PANEL_0013, _data.name, costType, _data.cost, (cfg.name + "X" + _data.item_count));
                }
            }
        }

        public function destroy():void
        {
            if (_data)
            {
                _data = null;
            }
            if (_content)
            {
                _content.removeEventListener(TextEvent.LINK, onLinkEvt);
                if (contains(_content))
                {
                    removeChild(_content);
                }
                _content = null;
            }
        }
    }
}
