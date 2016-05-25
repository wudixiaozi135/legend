package com.view.gameWindow.panel.panels.stronger.item
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapRegionCfgData;
    import com.model.configData.cfgdata.NpcCfgData;
    import com.model.configData.cfgdata.StrongerCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.TeleportDatamanager;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.stronger.McStrongerItem;
    import com.view.gameWindow.panel.panels.stronger.common.PanelSkipManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.SimpleStateButton;

    import flash.events.MouseEvent;
    import flash.events.TextEvent;

    /**
     * Created by Administrator on 2014/12/22.
     */
    public class ItemRow extends McStrongerItem
    {
        public var callBack:Function;
        private var _data:StrongerCfgData;
        private var _rsrLoader:RsrLoader;
        private var _skin:McStrongerItem;

        public function ItemRow()
        {
            initialize();
        }

        private function initialize():void
        {
            _skin = this;
            _skin.txt1.textColor = 0xd4a460;
            _skin.txt1.mouseEnabled = false;

            _skin.txt2.textColor = 0xffe1aa;
            _skin.txt2.mouseEnabled = false;

            _skin.txt3.textColor = 0x00ff00;
            _skin.txt3.selectable = false;

            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            _skin.txt3.addEventListener(TextEvent.LINK, onLinkTxt, false, 0, true);
            _rsrLoader = new RsrLoader();
            _rsrLoader.load(this, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
        }

        private function onLinkTxt(event:TextEvent):void
        {
            if (event.text)
            {
                var lv:int = RoleDataManager.instance.lv;
                if (_data.unlock_lv > lv)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TIP_LOCK);
                    return;
                }

                var link_arr:Array = event.text.split("_");
                var panelType:int = parseInt(link_arr[0]);
                var index:int = parseInt(link_arr[1]) - 1;//从0开始
                PanelSkipManager.instance.skipToPanel(panelType, index);
            }
            else
            {
                if (RoleDataManager.instance.stallStatue)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
                    return;
                }
                if (_data.npc)
                {
                    var npcId:int = parseInt(_data.npc);
                    AutoJobManager.getInstance().setAutoTargetData(npcId, EntityTypes.ET_NPC);
                }
                if (_data.map_region)
                {
                    var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(int(_data.teleport));
                    if (!mapRegionCfgData)
                    {
                        return;
                    }
                    AutoJobManager.getInstance().setAutoFindPathPos(mapRegionCfgData.randomPoint, mapRegionCfgData.map_id, 0);
                }

            }
        }

        private function onClick(event:MouseEvent):void
        {
            if (event.target == _skin.flyShoe)
            {
                if (RoleDataManager.instance.stallStatue)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
                    return;
                }
                if (_data.npc)
                {
                    var npcId:int = parseInt(_data.npc);
                    var cfg:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
                    TeleportDatamanager.instance.requestTeleportPostioin(cfg.mapid, cfg.teleport_x, cfg.teleport_y);
                } else if (_data.teleport)
                {
                    var teleportId:int = parseInt(_data.teleport);
                    TeleportDatamanager.instance.requestTeleportRegion(teleportId);
                }
                PanelMediator.instance.closePanel(PanelConst.TYPE_BECOME_STRONGER);
            }
        }

        public function get data():StrongerCfgData
        {
            return _data;
        }

        public function set data(value:StrongerCfgData):void
        {
            _data = value;
            if (_data)
            {
                var name_arr:Array = null;
                if (_skin)
                {
                    name_arr = getValue(_data);
                    if (name_arr)
                    {
                        _skin.txt1.text = name_arr[0];
                        _skin.txt2.text = name_arr[1];
                        if (_data.link_des)
                        {
                            SimpleStateButton.addLinkState(_skin.txt3, getName(name_arr[2]), _data.link_des);
                        } else
                        {
                            SimpleStateButton.addLinkState(_skin.txt3, getName(name_arr[2]));
                        }
                    }
                    _skin.flyShoe.visible = Boolean(_data.is_fly);
                }
            }
        }

        private function getValue(value:StrongerCfgData):Array
        {
            var desc:String = value.name_des;
            if (!desc) return null;
            return desc.split("|");
        }

        private function getName(value:String):String
        {
            var key:Number = parseInt(value);
            if (!isNaN(key))
            {
                var npc:NpcCfgData = ConfigDataManager.instance.npcCfgData(key);
                if (npc)
                {
                    return npc.name;
                }
            }
            return value;
        }

        public function destroy():void
        {
            if (_data)
            {
                _data = null;
            }
            if (_skin)
            {
                SimpleStateButton.removeState(_skin.txt3);
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
                _skin.txt3.removeEventListener(TextEvent.LINK, onLinkTxt);
            }
            if (_rsrLoader)
            {
                _rsrLoader.destroy();
                _rsrLoader = null;
            }
        }
    }
}
