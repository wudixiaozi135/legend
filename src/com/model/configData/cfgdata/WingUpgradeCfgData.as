package com.model.configData.cfgdata
{
    /**
     * Created by Administrator on 2015/3/19.
     */
    public class WingUpgradeCfgData
    {
//        id	int	11	序列
//        name	char	16	名称
//        next_id	int	11	升阶后id
//        cost_item_id	int	11	消耗材料ID
//        cost_item_num	int	11	每次消耗材料数量
//        cost_gold	int	11	单个材料消耗的元宝数
//        cost_coin	int	11	消耗金币（优先消耗绑定金币）
//        add_bless	int	11	每次增加祝福值
//        max_bless	int	11	祝福值上限
//        broadcastid	int	11	广播id

        public var id:int;
        public var name:String;
        public var next_id:int;
        public var cost_item_id:int;
        public var cost_item_num:int;
        public var cost_gold:int;
        public var cost_coin:int;
        public var add_bless:int;
        public var max_bless:int;
        public var broadcastid:int;
        public var upgrade:int;
        public function WingUpgradeCfgData()
        {
        }
    }
}
