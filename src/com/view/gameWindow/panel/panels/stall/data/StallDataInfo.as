package com.view.gameWindow.panel.panels.stall.data
{
    /**
     * Created by Administrator on 2015/1/20.
     * 摆摊信息
     */
    public class StallDataInfo
    {
//        item_id，物品id，为4字节有符号整形
//        item_type, 物品类型（1.道具 2.装备），为1字节有符号整形
//        item_count 道具数量 ，4字节有符号整形
//        cost_type 道具出售类型（1.金币 2.元宝） ，1字节有符号整形
//        cost  道具价格 ，4字节有符号整形

        public var item_id:int;
        public var item_type:int;
        public var item_count:int;
        public var cost_type:int;
        public var cost:int;
        public var born_sid:int;

        public function StallDataInfo()
        {
        }
    }
}
