package com.view.gameWindow.panel.panels.thingNew.equipAlert
{
    import com.greensock.TweenMax;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.consts.ConstStorage;
    import com.model.consts.ItemType;
    import com.model.consts.StringConst;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
    import com.view.gameWindow.panel.panels.thingNew.McEquipWear;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.NumPic;
    import com.view.newMir.NewMirMediator;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
     * 获得新装备提示面板类
     * @author Administrator
     */
    public class PanelEquipAlert extends PanelBase
    {
        private var _equipCell:EquipCell;
        private var _bagData:BagData;
        private var _btnHight:HighlightEffectManager;
        private var _delay:int = 5000;
        private var _timeId:uint = 0;
        private var _isDoing:Boolean = false;

        public function PanelEquipAlert()
        {
            super();
        }

        override protected function initSkin():void
        {
            var mc:McEquipWear = new McEquipWear();
            _skin = mc;
            addChild(_skin);
            setTitleBar(mc.mcDrag);

            _btnHight = new HighlightEffectManager();
            _timeId = setTimeout(function ():void
            {
                autoCarry();
            }, _delay);
        }

        public function autoCarry():void
        {
            if (_isDoing == false)
            {
                dealDo();
                _isDoing = true;
            }
            clearTimeout(_timeId);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McEquipWear = _skin as McEquipWear;
            rsrLoader.addCallBack(skin.btnDo, function (mc:MovieClip):void
            {
                _btnHight.show(mc, mc);
            });
        }

        override protected function initData():void
        {
            var mc:McEquipWear = _skin as McEquipWear;
            mc.txtInfo.mouseEnabled = false;
            mc.title.mouseEnabled = false;
            mc.title.textColor = 0xffcc00;
            mc.title.text = StringConst.THING_NEW_PANEL_0006;

            var equipCfgData:EquipCfgData;
            _bagData = EquipCanWearManager.bagData;
            var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(_bagData.bornSid, _bagData.id);
            equipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);

            var slot:int = ConstEquipCell.getRoleEquipSlot(equipCfgData.type);
            _equipCell = new EquipCell(mc.mcBg, slot, equipCfgData.type);
            _equipCell.refreshData(_bagData.id, _bagData.bornSid);
            ToolTipManager.getInstance().attach(_equipCell);

            //
            var color:int = ItemType.getColorByQuality(equipCfgData.color);
            mc.txtInfo.htmlText = HtmlUtils.createHtmlStr(color, equipCfgData.name, 17, true);

            dealNumPic(1, mc);
            //
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            //
            handlerEffect();
        }

        private function dealNumPic(isUniqueEquip:int, mc:McEquipWear):void
        {
            var fightPower:Number = 0, fightPowerEquiped:Number = 0;
            var equipCfgData:EquipCfgData;
            if (isUniqueEquip == 1)
            {
                var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(_bagData.bornSid, _bagData.id);
                equipCfgData = memEquipData.equipCfgData;
                fightPower = memEquipData.getTotalFightPower();
            }
            var slot:int = ConstEquipCell.getRoleEquipSlot(equipCfgData.type);
            if (slot != -1)
            {
                fightPowerEquiped = RoleDataManager.instance.getEquipPower(slot);
                fightPower -= fightPowerEquiped;
            }
            var numPic:NumPic = new NumPic();
            numPic.init("red_", int(fightPower) + "", mc.mcNumLayer, function ():void
            {
                if (mc && mc.mcNumLayer && mc.upArrow)
                {
                    mc.upArrow.x = mc.mcNumLayer.x + mc.mcNumLayer.width + 3;
                }
            });
        }

        protected function onClick(event:MouseEvent):void
        {
            var mc:McEquipWear = _skin as McEquipWear;
            if (event.target == mc.btnDo)
            {
                if (_isDoing) return;
                _isDoing = true;
                dealDo();
            }
        }

        private function dealClose():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_WEAR_ALERT);
        }

        private function dealDo():void
        {
            var bagData:BagData = BagDataManager.instance.getBagDataById(_bagData.id, _bagData.type, _bagData.bornSid);
            if (!bagData)
            {
                closeHandler();
                trace("PanelEquipNew.dealDo bagData == null");
                return;
            }
            var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagData.bornSid, bagData.id);
            if (!memEquipData)
            {
                closeHandler();
                trace("PanelEquipNew.dealDo memEquipData == null");
                return;
            }
            var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
            if (!equipCfgData)
            {
                closeHandler();
                trace("PanelEquipNew.dealDo equipCfgData == null");
                return;
            }
            var type:int = equipCfgData.type;
            var shizhuang:int = ConstEquipCell.TYPE_SHIZHUANG;
            var chibang:int = ConstEquipCell.TYPE_CHIBANG;
            var zuji:int = ConstEquipCell.TYPE_ZUJI;
            var douli:int = ConstEquipCell.TYPE_DOULI;
            var huanwu:int = ConstEquipCell.TYPE_HUANWU;
            if (type == shizhuang || type == chibang || type == zuji || type == douli || type == huanwu)
            {
                ClosetDataManager.instance.request(type, bagData.slot);
                PanelMediator.instance.openPanel(PanelConst.TYPE_CLOSET);
            } else if (type == ConstEquipCell.TYPE_HERO_SHIZHUANG)
            {
                ClosetDataManager.instance.requestHero(bagData.storageType, bagData.slot);
            }
            else
            {
                var slot:int = ConstEquipCell.getRoleEquipSlot(type);
                sendData(ConstStorage.ST_CHR_BAG, bagData.slot, ConstStorage.ST_CHR_EQUIP, slot);
                var mc:McEquipWear = _skin as McEquipWear;
                var replace:String = StringConst.THING_NEW_PANEL_0003.replace("&x", mc.txtInfo.text);
                RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, replace);
            }
            closeHandler();
        }

        private function sendData(oldStorage:int, oldSlot:int, newStorage:int, newSlot:int):void
        {
            var byteArray:ByteArray = new ByteArray();
            byteArray.endian = Endian.LITTLE_ENDIAN;
            byteArray.writeByte(oldStorage);
            byteArray.writeByte(oldSlot);
            byteArray.writeByte(newStorage);
            byteArray.writeByte(newSlot);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE_ITEM, byteArray);
        }

        override public function setPostion():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int((newMirMediator.width - rect.width));
            var newY:int = int((newMirMediator.height + rect.height - 10));
            x != newX ? x = newX : null;
            y != newY ? y = newY : null;
        }

        override public function resetPosInParent():void
        {
            super.resetPosInParent();
            setPostion();
        }

        private function handlerEffect():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int(newMirMediator.width - rect.width) - 50;
            var newY:int = int(newMirMediator.height - rect.height) - 100;

            TweenMax.fromTo(this, 2, {alpha: 0}, {
                x: newX, y: newY, alpha: 1, onComplete: function ():void
                {
                    TweenMax.killTweensOf(this);
                }
            });
        }

        private function closeHandler():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int(newMirMediator.width + rect.width);

            alpha = 1;
            TweenMax.to(this, 3, {
                x: newX, alpha: 0, onComplete: function ():void
                {
                    TweenMax.killTweensOf(this);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_WEAR_ALERT);
                }
            });
        }

        override public function destroy():void
        {
            if (_timeId)
            {
                clearTimeout(_timeId);
            }
            if (_bagData)
            {
                _bagData = null;
            }
            if (_equipCell)
            {
                ToolTipManager.getInstance().detach(_equipCell);
                _equipCell.destory();
                _equipCell = null;
            }
            if (_skin)
            {
                if (_btnHight)
                {
                    _btnHight.hide(_skin.btnDo);
                    _btnHight = null;
                }
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
            }
            super.destroy();
            EquipCanWearManager.bagData = null;
            EquipCanWearManager.isCanShow = true;
        }
    }
}