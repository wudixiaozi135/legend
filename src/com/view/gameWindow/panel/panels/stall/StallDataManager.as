package com.view.gameWindow.panel.panels.stall
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapRegionCfgData;
    import com.model.consts.MapRegionType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
    import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagPanel;
    import com.view.gameWindow.panel.panels.map.MapDataManager;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.stall.data.StallDataInfo;
    import com.view.gameWindow.panel.panels.stall.data.StallLogData;
    import com.view.gameWindow.panel.panels.stall.otherstall.PanelOtherStall;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
    import com.view.gameWindow.scene.map.SceneMapManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import flash.utils.getTimer;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallDataManager extends DataManagerBase
    {
        //别人的数据
        public var otherInfos:Vector.<StallDataInfo> = new Vector.<StallDataInfo>();//他人的摆摊栏信息
        public var other_Cid:int;
        public var other_Sid:int;
        public var other_Name:String;

        //自己的数据
        public var selfInfos:Vector.<StallDataInfo> = new Vector.<StallDataInfo>();//自己的摆摊栏信息
        public var logInfos:Vector.<StallLogData> = new Vector.<StallLogData>();//日志信息

        /**金币*/
        public static const COST_MONEY_TYPE:int = 1;
        /**元宝*/
        public static const COST_GOLD_TYPE:int = 2;
        /**摆摊栏最大物品容量*/
        public static const STALL_MAX_COUNT:int = 12;

        public static const STALL_MAP_ID:int = 103;
        public static const MAP_REGION_ID:int = 10301;
        public static const STALL_LV:int = 65;//摆摊等级

        public function StallDataManager()
        {
            super();
            DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_OTHER_SELL, this);
            DistributionManager.getInstance().register(GameServiceConstants.SM_SELL_THING_INFOR, this);
            DistributionManager.getInstance().register(GameServiceConstants.SM_SELL_MSG_INFORMATION, this);
            DistributionManager.getInstance().register(GameServiceConstants.SM_SELL_POSITION, this);


            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CREATE_SELL, this);//表示摆摊成功
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_SELL_THING_MOVE, this);//拖动物品到摆摊栏成功
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_STOP_SELL, this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_QUERY_OTHER_SELL, this);//查看别人的信息成功返回
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BUY, this);//购买成功返回
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_QUERY_OTHER_SELL:
                    handlerSM_QUERY_OTHER_SELL(data);
                    break;
                case GameServiceConstants.SM_SELL_THING_INFOR:
                    handlerSM_SELL_THING_INFOR(data);
                    break;
                case GameServiceConstants.SM_SELL_MSG_INFORMATION:
                    handlerLog(data);
                    break;
                case GameServiceConstants.SM_SELL_POSITION:
                    handlerSM_SELL_POSITION(data);
                    break;
                case GameServiceConstants.CM_CREATE_SELL:
                    handlerCM_CREATE_SELL();
                    break;
                case GameServiceConstants.CM_QUERY_OTHER_SELL:
                    handlerCM_QUERY_OTHER_SELL();
                    break;
                case GameServiceConstants.CM_BUY:
                    handlerCM_BUY();
                    break;
                default :
                    break;
            }
            super.resolveData(proc, data);
        }

        private function handlerSM_SELL_POSITION(data:ByteArray):void
        {
            var titleX:int = data.readInt();
            var titleY:int = data.readInt();

            var player:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
            player.tileX = titleX;
            player.tileY = titleY;
            player.targetTileX = player.tileX;
            player.targetTileY = player.tileY;
            AutoSystem.instance.stopAutoEx();
        }

        private function handlerCM_BUY():void
        {
            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.STALL_PANEL_0021);
            sendCM_QUERY_OTHER_SELL();
            PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_BUY);
        }

        private function handlerCM_QUERY_OTHER_SELL():void
        {
            if (!PanelMediator.instance.openedPanel(PanelConst.TYPE_STALL_OTHER))
            {
                PanelMediator.instance.openPanel(PanelConst.TYPE_STALL_OTHER);
            }
        }

        private function handlerCM_CREATE_SELL():void
        {
            var panelBag:BagPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG) as BagPanel;
            if (panelBag)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_BAG);
            }
            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.STALL_PANEL_0018);
        }

        private function handlerLog(data:ByteArray):void
        {
            if (logInfos.length > 0)
            {
                logInfos.forEach(function (element:StallLogData, index:int, vec:Vector.<StallLogData>):void
                {
                    element = null;
                });
                logInfos.length = 0;
            }

            var len:int = data.readInt();
            while (len--)
            {
                var log:StallLogData = new StallLogData();
                log.cid = data.readInt();
                log.sid = data.readInt();
                log.name = data.readUTF();
                log.itme_id = data.readInt();
                log.born_sid = data.readInt();
                log.item_type = data.readByte();
                log.item_count = data.readInt();
                log.cost_type = data.readByte();
                log.cost = data.readInt();
                logInfos.push(log);
            }
        }

        /**自己的摆摊信息*/
        private function handlerSM_SELL_THING_INFOR(data:ByteArray):void
        {
            if (selfInfos.length > 0)
            {
                selfInfos.forEach(function (element:StallDataInfo, index:int, vec:Vector.<StallDataInfo>):void
                {
                    element = null;
                });
                selfInfos.length = 0;
            }

            var len:int = data.readInt();
            while (len--)
            {
                var info:StallDataInfo = new StallDataInfo();
                info.item_id = data.readInt();//当type是物品时，item_id是物品id，当type是装备时item_id是onlyId
                info.born_sid = data.readInt();
                info.item_type = data.readByte();
                info.item_count = data.readInt();
                info.cost_type = data.readByte();
                info.cost = data.readInt();
                selfInfos.push(info);
            }
        }

        /**别人的摆摊信息*/
        private function handlerSM_QUERY_OTHER_SELL(data:ByteArray):void
        {
            if (otherInfos.length > 0)
            {
                otherInfos.forEach(function (element:StallDataInfo, index:int, vec:Vector.<StallDataInfo>):void
                {
                    element = null;
                });
                otherInfos.length = 0;
            }
            other_Cid = data.readInt();
            other_Sid = data.readInt();
            other_Name = data.readUTF();

            var len:int = data.readInt();
            while (len--)
            {
                var info:StallDataInfo = new StallDataInfo();
                info.item_id = data.readInt();//当type是物品时，item_id是物品id，当type是装备时item_id是onlyId
                info.born_sid = data.readInt();
                info.item_type = data.readByte();
                info.item_count = data.readInt();
                info.cost_type = data.readByte();
                info.cost = data.readInt();
                otherInfos.push(info);
            }
        }

        public function dealStallPanel():void
        {
            //预先判断是否在摆摊区
            if (canStall())
            {
                var panelStall:PanelStall = PanelMediator.instance.openedPanel(PanelConst.TYPE_STALL_PANEL) as PanelStall;
                closeOtherStallPanel();
                if (!panelStall)
                {
                    PanelMediator.instance.openPanel(PanelConst.TYPE_STALL_PANEL);
                }
            }
        }

        public function closeOtherStallPanel():void
        {
            var panelOtherStall:PanelOtherStall = PanelMediator.instance.openedPanel(PanelConst.TYPE_STALL_OTHER) as PanelOtherStall;
            if (panelOtherStall)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_OTHER);
                if (PanelMediator.instance.openedPanel(PanelConst.TYPE_STALL_BUY))
                {
                    PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_BUY);
                }
            }
        }

        /**是否超过摆摊栏容量*/
        public function get checkLimit():Boolean
        {
            if (selfInfos.length >= STALL_MAX_COUNT)
            {
                return true;
            }
            return false;
        }

        /**查看其他人的摆摊信息*/
        public function viewOtherStallInfo(cid:int, sid:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeInt(cid);
            byte.writeInt(sid);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OTHER_SELL, byte);
            byte = null;
        }

        /**开始摆摊*/
        public function startStall():void
        {
            if (canStall())
            {
                var player:IPlayer = EntityLayerManager.getInstance().firstPlayer;
                var byte:ByteArray = new ByteArray();
                byte.endian = Endian.LITTLE_ENDIAN;
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CREATE_SELL, byte);
                byte = null;
            }
        }

        public function canStall():Boolean
        {
            // 检测是否在可摆摊范围
            if (RoleDataManager.instance.lv < StallDataManager.STALL_LV)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.STALL_PANEL_0040, StallDataManager.STALL_LV));
                return false;
            }
            var regionType:int = MapDataManager.instance.regionType;
            var currentMapId:int = SceneMapManager.getInstance().mapId;
            var dic:Dictionary = ConfigDataManager.instance.mapRegionCfgDatasByMap(currentMapId);

            var safeRegions:Array = [];
            for each(var cfg:MapRegionCfgData in dic)
            {
                if (cfg.type == MapRegionType.SHAPE_RECT)
                {
                    safeRegions.push(cfg);

                }
            }

            var player:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
            var inRegion:Boolean = false;
            var cfgRegion:MapRegionCfgData;
            for (var i:int = 0, len:int = safeRegions.length; i < len; i++)
            {
                cfgRegion = safeRegions[i];
                if (cfgRegion)
                {
                    inRegion = cfgRegion.isIn(player.tileX, player.tileY);
                    if (inRegion)
                    {
                        break;
                    }
                }
            }

            if (regionType != MapRegionType.PEACE || currentMapId != StallDataManager.STALL_MAP_ID || !inRegion)
            {
                PanelMediator.instance.openPanel(PanelConst.TYPE_STALL_ALERT);
                return false;
            }
            return true;
        }

        /**未摆摊时拖动物品到摆摊栏*/
        public function sendDragItemToStall(storage:int, slot:int, count:int, cost_type:int, cost:int):void
        {
            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            data.writeByte(1);
            data.writeByte(storage);
            data.writeByte(slot);
            data.writeInt(count);
            data.writeByte(cost_type);
            data.writeInt(cost);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SELL_THING_MOVE, data);
            data = null;
        }

        /**未摆摊时将物品到背包*/
        public function sendDragItemToBag(item_id:int, born_sid:int, item_type:int, item_count:int, cost_type:int, cost:int):void
        {
            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            data.writeByte(2);
            data.writeInt(item_id);
            data.writeInt(born_sid);
            data.writeByte(item_type);
            data.writeInt(item_count);
            data.writeByte(cost_type);
            data.writeInt(cost);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SELL_THING_MOVE, data);
            data = null;
        }

        /**结束摆摊*/
        public function stopStall():void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_STOP_SELL, byte);
            byte = null;
        }

        public function sendBuyData(cid:int, sid:int, item_id:int, born_sid:int, item_type:int, item_count:int, cost_type:int, cost:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeInt(cid);
            byte.writeInt(sid);
            byte.writeInt(item_id);
            byte.writeInt(born_sid);
            byte.writeByte(item_type);
            byte.writeInt(item_count);
            byte.writeByte(cost_type);
            byte.writeInt(cost);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BUY, byte);
            byte = null;
        }

        /**购买完成后摊位信息*/
        public function sendCM_QUERY_OTHER_SELL():void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OTHER_SELL, byte);
            byte = null;
        }

        /**查看日志*/
        public function sendQueryLog():void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_SELL_EVENT, byte);
            byte = null;
        }

        /**下架物品*/
        public function sendUnShelve(item_id:int, born_sid:int, item_type:int, item_count:int, cost_type:int, cost:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeInt(item_id);
            byte.writeInt(born_sid);
            byte.writeByte(item_type);
            byte.writeInt(item_count);
            byte.writeByte(cost_type);
            byte.writeInt(cost);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SELL_UNSHELVE, byte);
            byte = null;
        }

        private var time:uint = 0;

        public function sendAdvertisement(info:StallDataInfo):void
        {
            if (getTimer() - time < 10000)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0035);
                return;
            }
            time = getTimer();
            var data:StallDataInfo = info;
            if (data)
            {
                var cfg:*;
                if (data.item_type == SlotType.IT_EQUIP)
                {
                    cfg = MemEquipDataManager.instance.memEquipData(data.born_sid, data.item_id).equipCfgData;
                } else
                {
                    cfg = ConfigDataManager.instance.itemCfgData(data.item_id);
                }
                var linkStr:String = "<p color='0xcccccc'>" + StringConst.STALL_PANEL_0012;
                linkStr += makeLink(0x00ff00, cfg.name, "stall", "123");
                if (data.cost_type == COST_GOLD_TYPE)
                {
                    linkStr += StringConst.STALL_PANEL_0033 + data.item_count + " " + StringConst.STALL_PANEL_0009 + data.cost + StringConst.STALL_PANEL_0031;
                } else
                {
                    linkStr += StringConst.STALL_PANEL_0033 + data.item_count + " " + StringConst.STALL_PANEL_0009 + data.cost + StringConst.STALL_PANEL_0032;
                }
                linkStr += makeLink(0xffffff, StringConst.STALL_PANEL_0034, "flyStall", "456");
                linkStr += "</p>";
                ChatDataManager.instance.sendPublicTalkEx(MessageCfg.CHANNEL_WOLD, linkStr, 1);
            }
        }

        /**
         * "<link event='stall' data='123456' color='0xff00'>金刚石</link>"
         * */
        private function makeLink(color:uint, content:String, event:String = "", param:String = ""):String
        {
            var msg:String = "";
            msg = "<link event='" + event + "' data='" + param + "' color='" + color + "'>" + content + "</link>";
            return msg;
        }


        /**检查是否剩余还有一个*/
        public function get checkRemainOne():Boolean
        {
            if (selfInfos)
            {
                return selfInfos.length == 1;
            }
            return false;
        }

        public function clearData():void
        {
            if (selfInfos)
            {
                selfInfos.forEach(function (element:StallDataInfo, index:int, vec:Vector.<StallDataInfo>):void
                {
                    element = null;
                });
                selfInfos.length = 0;
            }
            if (otherInfos)
            {
                otherInfos.forEach(function (element:StallDataInfo, index:int, vec:Vector.<StallDataInfo>):void
                {
                    element = null;
                });
                otherInfos.length = 0;
            }

            if (logInfos)
            {
                logInfos.forEach(function (element:StallLogData, index:int, vec:Vector.<StallLogData>):void
                {
                    element = null;
                });
                logInfos.length = 0;
            }
        }
        private static var _instance:StallDataManager = null;
        public static function get instance():StallDataManager
        {
            if (_instance == null)
            {
                _instance = new StallDataManager();
            }
            return _instance;
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }
    }
}
