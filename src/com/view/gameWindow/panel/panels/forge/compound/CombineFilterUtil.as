package com.view.gameWindow.panel.panels.forge.compound
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.CombineCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.consts.ItemType;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;

    /**
     * Created by Administrator on 2015/1/30.
     */
    public class CombineFilterUtil
    {
        public function CombineFilterUtil()
        {
        }

        public static function getSatisfyCombineDatas(type:int, type2:int):Vector.<CombineCfgData>
        {
            var data:Vector.<CombineCfgData> = new Vector.<CombineCfgData>();
            var vec:Vector.<CombineCfgData> = ConfigDataManager.instance.getType2Data(type, type2);
            var lv:int = RoleDataManager.instance.lv;
            var itemCfg:ItemCfgData, itemLv:int;
            for each(var item:CombineCfgData in vec)
            {
                itemCfg = ConfigDataManager.instance.itemCfgData(item.id);
                if (itemCfg)
                {
                    itemLv = getLv(itemCfg.id);
                    if (itemLv > lv)
                        continue;
                    data.push(item);
                }
            }
            return data;
        }

        private static function getLv(itemId:int):int
        {
            switch (itemId)
            {
                case ItemType.IT_111:
                    return 40;
                case ItemType.IT_112:
                    return 50;
                case ItemType.IT_113:
                    return 60;
                case ItemType.IT_114:
                    return 70;
                case ItemType.IT_115:
                    return 80;
                case ItemType.IT_116:
                    return 90;
            }
            return 0;
        }
    }
}
