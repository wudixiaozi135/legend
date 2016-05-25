package com.view.gameWindow.panel.panels.charge
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.SlotType;
    import com.model.gameWindow.mem.MemEquipData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UtilItemParse;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.Sprite;

    /**
     * Created by Administrator on 2015/2/11.
     */
    public class ChargeViewHandler
    {
        private var _panel:PanelCharge;
        private var _skin:McCharge;
        private var _cellExs:Vector.<IconCellEx>;
        private var _dts:Vector.<ThingsData>;
        private var _uiEffectLoader:UIEffectLoader;
        private var _btnEffect:UIEffectLoader;
        private var _btnEffectContainer:Sprite;
        public function ChargeViewHandler(panel:PanelCharge)
        {
            _panel = panel;
            _skin = _panel.skin as McCharge;
            initContent();
            _skin.addChild(_btnEffectContainer = new Sprite());
            _btnEffectContainer.mouseEnabled = false;
            _btnEffectContainer.mouseChildren = false;
            _btnEffect = new UIEffectLoader(_btnEffectContainer, 0, 0, 1, 1, EffectConst.RES_CHARGE_BTN_EFFECT);
            _btnEffectContainer.x = _skin.btnGet.x - ((168 - _skin.btnGet.width) >> 1);
            _btnEffectContainer.y = _skin.btnGet.y - ((85.5 - _skin.btnGet.height) >> 1);
            _btnEffectContainer.visible = false;
        }

        private function initContent():void
        {
            _cellExs = new Vector.<IconCellEx>();
            _dts = new Vector.<ThingsData>();
            var equipAttrs:Array = ChargeDataManager.instance.getRewardEquipArr();
            var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipAttrs[0]);
            var otherRewards:Array = ChargeDataManager.instance.getRewardItemArr();
            var otherS:Array;
            var mc:MovieClip;
            for (var i:int = 0; i < 4; i++)
            {
                mc = _skin["icon" + (i + 1)];
                mc.mouseEnabled = false;
                var cellEx:IconCellEx = new IconCellEx(mc, 2, 2, 60, 60);
                _cellExs[i] = cellEx;
                var dt:ThingsData = new ThingsData();
                var tempMemData:MemEquipData;
                if (i == 0)
                {
                    if (equipCfg)
                    {
                        dt.type = SlotType.IT_EQUIP;
                        dt.id = equipCfg.id;
                        mc.txtCount.textColor = 0x009900;
                        mc.txtCount.filters = null;
                        mc.txtCount.text = "+".concat(equipAttrs[5]);
                        tempMemData = createTempMemData(equipCfg.id);
                    }
                } else
                {
                    tempMemData = null;
                    otherS = UtilItemParse.getItemString(otherRewards[i - 1]);
                    dt.count = otherS[2];
                    dt.id = otherS[3];
                    dt.type = otherS[4];
                }
                _dts[i] = dt;
                IconCellEx.setItemByThingsData(cellEx, dt);
                if (tempMemData)
                {
                    cellEx.setTipData(tempMemData);
                }
                ToolTipManager.getInstance().attach(_cellExs[i]);
            }
            initWeaponEffect();
        }

        /**虚拟的假数据*/
        private function createTempMemData(equipId:int):MemEquipData
        {
            var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipId);
            var newMemEquipData:MemEquipData;
            if (equipCfg)
            {
                newMemEquipData = new MemEquipData();
                newMemEquipData.baseId = equipCfg.id;
                newMemEquipData.strengthen = 6;
            }
            return newMemEquipData;
        }

        private function initWeaponEffect():void
        {
            _uiEffectLoader = new UIEffectLoader(_skin.weaponContainer, 0, 0, 1, 1, EffectConst["RES_CHARGE_" + RoleDataManager.instance.job]);
        }

        /**飘物品数据*/
        public function getBitmaps():Array
        {
            var arr:Array = [];
            _cellExs.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
            {
                var bmp:Bitmap = element.getBitmap();
                bmp.width = bmp.height = 40;
                bmp.name = element.id.toString();
                element.addChild(bmp);
                arr.push(bmp);
            });
            return arr;
        }
        public function refresh():void
        {
            var pay_count:int = ChargeDataManager.instance.alreadyChargeCount;
            var unExtractGold:int = BagDataManager.instance.unExtractGold;
            if (pay_count <= 0)//
            {
                if (unExtractGold)
                {
                    _skin.btnPlay.visible = false;
                    _skin.btnGet.visible = true;
                    _btnEffectContainer.visible = _skin.btnGet.visible;
                    return;
                }
                _skin.btnPlay.visible = true;
                _skin.btnGet.visible = false;
                _btnEffectContainer.visible = _skin.btnGet.visible;
            } else
            {
                _skin.btnPlay.visible = false;
                _skin.btnGet.visible = true;
                _btnEffectContainer.visible = _skin.btnGet.visible;
            }
        }

        public function destroy():void
        {
            if (_btnEffect)
            {
                _btnEffect.destroy();
                _btnEffect = null;
            }
            if (_btnEffectContainer && _btnEffectContainer.parent)
            {
                _skin.removeChild(_btnEffectContainer);
                _btnEffectContainer = null;
            }
            if (_uiEffectLoader)
            {
                _uiEffectLoader.destroy();
                _uiEffectLoader = null;
            }
            if (_cellExs)
            {
                _cellExs.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
                {
                    ToolTipManager.getInstance().attach(element);
                    element.destroy();
                    element = null;
                });
                _cellExs.length = 0;
                _cellExs = null;
            }

            if (_dts)
            {
                _dts.forEach(function (element:ThingsData, index:int, vec:Vector.<ThingsData>):void
                {
                    element = null;
                });
                _dts.length = 0;
                _dts = null;
            }
            if (_skin)
            {
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
