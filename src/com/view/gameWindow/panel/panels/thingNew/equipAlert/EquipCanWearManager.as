package com.view.gameWindow.panel.panels.thingNew.equipAlert
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.consts.SlotType;
    import com.model.frame.FrameManager;
    import com.model.frame.IFrame;
    import com.model.gameWindow.mem.MemEquipData;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;

    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2015/2/10.
     */
    public class EquipCanWearManager implements IObserver,IFrame
    {
        public static var bagData:BagData;//已经显示的数据

        public static var isCanShow:Boolean = false;

        private var _equipPools:Vector.<BagData>;//存放待弹出的装备
        private var _equipPop:Dictionary;//存放已经弹出的装备
        public function EquipCanWearManager()
        {
            super();
            _equipPools = new Vector.<BagData>();
            _equipPop = new Dictionary(true);
            FrameManager.instance.addObj(this);
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_BAG_ITEMS)
            {
                if (RoleDataManager.instance.lv >= 50)
                {//人物到了50级不需要
                    FrameManager.instance.removeObj(this);
                    return;
                }
                handlerBagData();
            } else if (proc == GameServiceConstants.SM_CHR_INFO)
            {
                handPanelShow();
            }
        }

        public function handPanelShow():void
        {
            if (RoleDataManager.instance.lv >= 50)
            {//人物到了50级不需要
                FrameManager.instance.removeObj(this);
                return;
            }
            var panelAlert:PanelEquipAlert = PanelMediator.instance.openedPanel(PanelConst.TYPE_EQUIP_WEAR_ALERT) as PanelEquipAlert;
            if (!panelAlert)
            {
                var bagData:BagData = checkSatisfyEquip();
                if (bagData)
                {
                    if (checkDataInBag(bagData))
                    {//在背包里
                        var memEquipData:MemEquipData = bagData.memEquipData;
                        var equipCfgData:EquipCfgData = memEquipData ? memEquipData.equipCfgData : null;
                        if (equipCfgData)
                        {
                            if (RoleDataManager.instance.checkReincarnLevel(equipCfgData.reincarn, equipCfgData.level))
                            {
                                EquipCanWearManager.bagData = bagData;
                                PanelMediator.instance.openPanel(PanelConst.TYPE_EQUIP_WEAR_ALERT);
                            }
                        }
                    }
                }
            }
        }

        private function checkDataInBag(bagData:BagData):Boolean
        {
            var bagDatas:Vector.<BagData> = BagDataManager.instance.bagCellDatas;
            for each(var data:BagData in bagDatas)
            {
                if (data)
                {
                    if (bagData.id == data.id && bagData.type == data.type && bagData.bornSid == data.bornSid)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        /**检查是否有装备满足条件*/
        private function checkSatisfyEquip():BagData
        {
            var lv:int = RoleDataManager.instance.lv;
            for each(var data:BagData in _equipPools)
            {
                if (lv >= data.level)
                {
                    if (_equipPop[data.id])
                        continue;

                    _equipPop[data.id] = data;
                    return data;
                }
            }
            return null;
        }

        /**当背包的数据增加或删除时检测*/
        private function handlerBagData():void
        {
            checkExistInBagData();
            var bagDatas:Vector.<BagData> = BagDataManager.instance.bagCellDatas;
            var noPos:int = 0;
            for each(var data:BagData in bagDatas)
            {
                if (!data) continue;
                if (isCanWearForFuture(data))
                {
                    noPos = _equipPools.indexOf(data);
                    if (noPos != -1)
                    {
                        continue;
                    }
                    _equipPools.push(data);
                    handPanelShow();
                }
            }
        }

        /**检查是否还在背包*/
        private function checkExistInBagData():void
        {
            var data:BagData;
            var bagDatas:Vector.<BagData> = BagDataManager.instance.bagCellDatas;
            for (var i:int = _equipPools.length - 1; i > 0; i--)
            {
                data = _equipPools[i];
                if (!checkDataInBag(data))
                {
                    _equipPools.slice(i, 1);
                }
            }
        }

        /**判断装备是否在以后可以穿戴*/
        private function isCanWearForFuture(bagData:BagData):Boolean
        {
            if (!bagData) return false;
            var memEquipData:MemEquipData = bagData.memEquipData;
            var equipCfgData:EquipCfgData = memEquipData ? memEquipData.equipCfgData : null;
            if (!equipCfgData) return false;
            if (bagData.type != SlotType.IT_EQUIP) return false;

            var roleSex:int = RoleDataManager.instance.sex;
            var roleJob:int = RoleDataManager.instance.job;

            if (bagData.sex != 0 && bagData.sex != roleSex)
            {
                return false;
            }
            if (bagData.job != 0 && bagData.job != roleJob)
            {
                return false;
            }
            if (bagData.level <= RoleDataManager.instance.lv)
            {
                return false;
            }
            return true;
        }

        private static var _instance:EquipCanWearManager = null;
        public static function get instance():EquipCanWearManager
        {
            if (_instance == null)
            {
                _instance = new EquipCanWearManager();
            }
            return _instance;
        }

        public function updateTime(time:int):void
        {
            if (isCanShow)
            {
                if (!PanelMediator.instance.openedPanel(PanelConst.TYPE_EQUIP_WEAR_ALERT))
                {
                    handPanelShow();
                    EquipCanWearManager.isCanShow = false;
                }
            }
        }
    }
}
