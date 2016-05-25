package com.view.gameWindow.panel.panels.thingNew.equipUpgrade
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.EquipDegreeCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.consts.ConstStorage;
    import com.model.dataManager.DataManagerBase;
    import com.model.frame.FrameManager;
    import com.model.frame.IFrame;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.forge.degree.DegreeFilterUtil;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
    import com.view.gameWindow.util.cell.CellData;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
     * Created by Administrator on 2015/1/30.
     */
    public class EquipUpgradeDataManager extends DataManagerBase implements IObserver,IFrame
    {
        public static const DOWN_40_LEVEL:int = 40;//40级以下的
        public var cellData:CellData;//检测的是否有可进阶的装备
        private var _cellDatas:Vector.<CellData> = new Vector.<CellData>();//处理进阶装备数据
        public var isFlying:Boolean;

        public static var TYPE_SLOT:int = -1;
        public function EquipUpgradeDataManager()
        {
            super();
            BagDataManager.instance.attach(this);
            MemEquipDataManager.instance.attach(this);
            HeroDataManager.instance.attach(this);
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }

        /**检测是否有装备可以进阶*/
        public function checkSatisfyEquipDegree():CellData
        {
            var result:CellData;
            result = fromBagData();
            if (result)
            {
                TYPE_SLOT = ConstStorage.ST_CHR_BAG;
                return result;
            }
            result = fromRoleData();
            if (result)
            {
                TYPE_SLOT = ConstStorage.ST_CHR_EQUIP;
                return result;
            }
            result = fromHeroData();
            if (result)
            {
                TYPE_SLOT = ConstStorage.ST_HERO_EQUIP;
                return result;
            }
            TYPE_SLOT = -1;
            return result;
        }

        /// 从背包里获取
        private function fromBagData():CellData
        {
            var datas:Vector.<BagData> = DegreeFilterUtil.getSatisfyDegreeBagEquips();
            var isHas:Boolean = false;
            for each(var item:BagData in datas)
            {
                isHas = judgeOne(item, ConstStorage.ST_CHR_BAG);
                if (isHas)
                {
                    return item;
                    break;
                }
            }
            return null;
        }

        /// 从角色里获取
        private function fromRoleData():CellData
        {
            var datas:Vector.<EquipData> = DegreeFilterUtil.getSatisfyDegreeRoleEquips();
            var isHas:Boolean = false;
            for each(var item:EquipData in datas)
            {
                isHas = judgeOne(item, ConstStorage.ST_CHR_EQUIP);
                if (isHas)
                {
                    return item;
                    break;
                }
            }
            return null;
        }

        /// 从英雄里获取
        private function fromHeroData():CellData
        {
            var datas:Vector.<EquipData> = HeroDataManager.instance.getDegreeEquipDatas();
            var isHas:Boolean = false;
            for each(var item:EquipData in datas)
            {
                if (item.memEquipData.equipCfgData.level > HeroDataManager.instance.lv)
                    continue;
                if (item.memEquipData.equipCfgData.job != 0)
                {
                    if (item.memEquipData.equipCfgData.job != HeroDataManager.instance.job)
                    {
                        continue;
                    }
                }
                isHas = judgeOne(item, ConstStorage.ST_HERO_EQUIP);
                if (isHas)
                {
                    return item;
                    break;
                }
            }
            return null;
        }

        private function judgeOne(select:CellData, type:int):Boolean
        {
            var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(select.bornSid, select.id);
            if (!memEquipData)
            {
                return false;
            }
            var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
            if (!equipDegreeCfgData)
            {
                return false;
            }
            var num:int;
            var bagData:BagData = BagDataManager.instance.getItemById(equipDegreeCfgData.material_id);
            if (!bagData)
            {
                var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(equipDegreeCfgData.material_id);
                if (!itemCfgData)
                {
                    return false;
                }
                num = 0;
            }
            else
            {
                num = BagDataManager.instance.getItemNumById(equipDegreeCfgData.material_id);
                num += HeroDataManager.instance.getItemNumById(equipDegreeCfgData.material_id);
            }
            if (num < equipDegreeCfgData.material_count)
            {
                return false;
            }

            //下一阶装备
            var equipCfgData0:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.id);
            var equipCfgData1:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.next_id);
            if (!equipCfgData0 || !equipCfgData1)
            {
                return false;
            }

            if (equipCfgData0.level < DOWN_40_LEVEL)
            {
                return false;
            }

            var roleJob:int = RoleDataManager.instance.job;
            if (equipCfgData0.job != 0 && equipCfgData0.job != roleJob)
            {
                return false;
            }

            //金币
            var JB:int = BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind;
            if (JB < equipDegreeCfgData.coin)
            {
                return false;
            }

            var checkReincarnLevel:Boolean;
            if (type == ConstStorage.ST_CHR_EQUIP)
            {
                checkReincarnLevel = RoleDataManager.instance.checkReincarnLevel(equipCfgData1.reincarn, equipCfgData1.level);
            }
            else if (type == ConstStorage.ST_HERO_EQUIP)
            {
                checkReincarnLevel = HeroDataManager.instance.checkReincarnLevel(equipCfgData1.reincarn, equipCfgData1.level);
            }
            else
            {
                checkReincarnLevel = true;
            }
            return checkReincarnLevel;
        }

        /*装备升阶*/
        public function sendEquipDegree(cellData:CellData):void
        {
            var byteArray:ByteArray = new ByteArray();
            byteArray.endian = Endian.LITTLE_ENDIAN;
            byteArray.writeByte(cellData.storageType);
            byteArray.writeByte(cellData.slot);
            var isUseGold:int = 0;
            byteArray.writeByte(isUseGold);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_UPGRADE, byteArray);
        }

        private static var _instance:EquipUpgradeDataManager = null;
        public static function get instance():EquipUpgradeDataManager
        {
            if (_instance == null)
            {
                _instance = new EquipUpgradeDataManager();
            }
            return _instance;
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_BAG_ITEMS || proc == GameServiceConstants.SM_MEM_UNIQUE_EQUIP_INFO || proc == -999)
            {
                var temp:CellData = checkSatisfyEquipDegree();
                var select:Boolean = SelectPromptBtnManager.getSelect(SelectPromptType.SELECT_EQUIP_UPGRADE_ALERT);
                if (select) return;
                if (temp)
                {
                    _cellDatas.length = 0;
                    var position:int = _cellDatas.indexOf(temp);
                    if (position == -1)
                    {
                        _cellDatas.push(temp);
                    }
                }
                if (_cellDatas.length)
                    FrameManager.instance.addObj(this);
            }
        }

        public function popPanel():void
        {
            if (_cellDatas.length > 0)
            {
                if (isFlying)
                {
                    return;
                }
                cellData = _cellDatas.pop();
                if (cellData)
                {
                    PanelMediator.instance.openPanel(PanelConst.TYPE_EQUIP_UPGRADE_ALERT, true);
                    isFlying = true;
                }
            } else
            {
                FrameManager.instance.removeObj(this);
            }
        }

        public function updateTime(time:int):void
        {
            popPanel();
        }
    }
}
