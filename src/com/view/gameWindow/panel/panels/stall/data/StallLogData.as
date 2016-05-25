package com.view.gameWindow.panel.panels.stall.data
{
    /**
     * Created by Administrator on 2015/1/20.
     */
    public class StallLogData
    {

//        count， 购买记录数量，4字节有符号整形，
//        cid，购买角色id，4字节有符号整形，
//        sid，购买角色的服务器id，4字节有符号整形
//        name，购买角色的名字，utf_8字符串类型
//        item_id，购买物品id，为4字节有符号整形
//        item_type, 类型（1.道具 2.装备），为1字节有符号整形
//        item_count 道具数量 ，4字节有符号整形

        public var cid:int;
        public var sid:int;
        public var name:String;
        public var itme_id:int;
        public var item_type:int;
        public var item_count:int;
        public var born_sid:int;
        public var cost_type:int;
        public var cost:int;

        public function StallLogData()
        {
        }
    }
}
