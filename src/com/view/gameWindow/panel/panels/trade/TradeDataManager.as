package com.view.gameWindow.panel.panels.trade
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.gameWindow.mem.AttrRandomData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.trade.data.ExchangeData;
	import com.view.gameWindow.panel.panels.trade.data.OppositeDataInfo;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.Player;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	import mx.utils.StringUtil;

	/**
	 * Created by Administrator on 2014/12/16.
	 */
	public class TradeDataManager extends DataManagerBase
	{
		/**交易物品上限*/
		public static const CELL_CAPABILITY:int = 12;

		// 1.道具 2.元宝 3.金币
		public static const TRADE_TYPE_ITEM:int = 1;
		public static const TRADE_TYPE_GOLD:int = 2;
		public static const TRADE_TYPE_COIN:int = 3;
		
		/*超出范围是不是弹出alert  false 弹出  true 不弹出*/
		public var isOverRange:Boolean = false;
		/**玩家交易信息*/
		public var exchangeData:ExchangeData;
		/** 被交易方信息*/
		public var oppositeData:OppositeDataInfo;

		///自己的交易物品信息
		public var selfItems:Vector.<BagData>;
		//他人的交易物品信息
		public var otherItems:Vector.<BagData>;

		//服务端下发自己的元宝和金币
		public var selfGold:int;
		public var selfCoin:int;
		//自己的锁定状态
		public static var lock_state_self:Boolean = false;
		//他人的锁定状态
		public static var lock_state_other:Boolean = false;

		private var dic:Dictionary = new Dictionary();

		public function TradeDataManager()
		{
			super();
			DistributionManager.getInstance().register(GameServiceConstants.SM_CREATE_EXCHANGE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE_INFO, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE_APPLY_REFUSE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE_CANCLE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_APPLY_INTO_CHANGE_AGREE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE_THING_INFO, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MYSELF_EXCHANGE_ITEMS, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE_OFFLINE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE_LOCK_INFO, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MYEQUIP_TO_OTHER_PLAY, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE_SUCESS, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHANGE_CAN_CHANGE, this);

			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CREATE_EXCHANGE, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_APPLY_INTO_CHANGE_AGREE, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CHANGE_CANCLE, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CHANGE, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CHANGE_LOCK, this);
		}

		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_CREATE_EXCHANGE:
					handlerSM_CREATE_EXCHANGE(data);
					break;
				case GameServiceConstants.SM_CHANGE_INFO:
					handlerSM_CHANGE_INFO(data);
					break;
				case GameServiceConstants.SM_CHANGE_APPLY_REFUSE:
					handlerSM_CHANGE_APPLY_REFUSE(data);
					break;
				case GameServiceConstants.SM_CHANGE_CANCLE:
					handlerSM_CHANGE_CANCLE(data);
					break;
				case GameServiceConstants.SM_APPLY_INTO_CHANGE_AGREE:
					handlerSM_APPLY_INTO_CHANGE_AGREE(data);
					break;
				case GameServiceConstants.SM_CHANGE_THING_INFO:
					handlerSM_CHANGE_THING_INFO(data);
					break;
				case GameServiceConstants.SM_MYSELF_EXCHANGE_ITEMS:
					handlerSM_MYSELF_EXCHANGE_ITEMS(data);
					break;
				case GameServiceConstants.SM_CHANGE_OFFLINE:
					handlerSM_CHANGE_OFFLINE(data);
					break;
				case GameServiceConstants.SM_CHANGE:
					handlerSM_CHANGE(data);
					break;
				case GameServiceConstants.SM_CHANGE_LOCK_INFO:
					handlerSM_CHANGE_LOCK_INFO(data);
					break;
				case GameServiceConstants.SM_MYEQUIP_TO_OTHER_PLAY:
					resloveOtherEquipInfo(data);
					break;
				case GameServiceConstants.SM_CHANGE_SUCESS:
					handlerSM_CHANGE_SUCESS();
					break;
				case GameServiceConstants.SM_CHANGE_CAN_CHANGE:
					handlerSM_CHANGE_CAN_CHANGE();
					break;
				case GameServiceConstants.CM_CREATE_EXCHANGE:
					handlerCM_CREATE_EXCHANGE(data);
					break;
				case GameServiceConstants.CM_APPLY_INTO_CHANGE_AGREE:
					handlerCM_APPLY_INTO_CHANGE_AGREE();
					break;
				case GameServiceConstants.CM_CHANGE_CANCLE:
					handlerCM_CHANGE_CANCLE();
					break;
				case GameServiceConstants.CM_CHANGE:
					handlerCM_CHANGE();
					break;
				case GameServiceConstants.CM_CHANGE_LOCK:
					handlerCM_CHANGE_LOCK();
					break;
				default :
					break;
			}
			super.resolveData(proc, data);
		}

		/**交易锁定 自己收到*/
		private function handlerCM_CHANGE_LOCK():void
		{
			if (lock_state_other == false)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0010);
			} else
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0011);
			}
			lock_state_self = true;//已锁定
		}

		/**交易锁定对方收到*/
		private function handlerSM_CHANGE_LOCK_INFO(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();

			if (lock_state_self == false)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0028);
			} else
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0011);
			}
			lock_state_other = true;
		}

		/**对方已点交易，提示我可以点交易*/
		private function handlerSM_CHANGE_CAN_CHANGE():void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0013);
		}

		/**提示对方交易，对方收到*/
		private function handlerSM_CHANGE_SUCESS():void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0033);
			closeTradePanel();
		}

		/**  点击交易按钮 自己收到 禁用交易按钮*/
		private function handlerCM_CHANGE():void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0010);
		}

		/**对方点交易后我收到*/
		private function handlerSM_CHANGE(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0033);
			closeTradePanel();
		}

		/**有一方下线交易失败*/
		private function handlerSM_CHANGE_OFFLINE(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.TRADE_0026, name));
			closeTradePanel();
		}

		/**取消交易成功*/
		private function handlerCM_CHANGE_CANCLE():void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0021);
			closeTradePanel();
		}

		//他人交易栏里的信息
		private function handlerSM_CHANGE_THING_INFO(data:ByteArray):void
		{
			otherItems = new Vector.<BagData>();
			if (oppositeData == null)
			{
				oppositeData = new OppositeDataInfo();
			}
			oppositeData.cid = data.readInt();
			oppositeData.sid = data.readInt();
			oppositeData.bagFreeCount = data.readInt();
			oppositeData.gold = data.readInt();
			oppositeData.coin = data.readInt();
			var size:int = data.readInt();
			while (size--)
			{
				var bagData:BagData = new BagData();
				bagData.id = data.readInt();
				bagData.bornSid = data.readInt();
				bagData.type = data.readByte();
				bagData.count = data.readInt();
				bagData.bind = data.readByte();
				data.readInt();
				bagData.isHide = data.readByte();
				otherItems.push(bagData);
			}
		}

		//自己交易栏里的信息
		private function handlerSM_MYSELF_EXCHANGE_ITEMS(data:ByteArray):void
		{
			selfItems = new Vector.<BagData>();
			selfGold = data.readInt();
			selfCoin = data.readInt();
			var size:int = data.readInt();
			while (size--)
			{
				var bagData:BagData = new BagData();
				bagData.id = data.readInt();
				bagData.bornSid = data.readInt();
				bagData.type = data.readByte();
				bagData.count = data.readInt();
				bagData.bind = data.readByte();
				data.readInt();
				bagData.isHide = data.readByte();
				selfItems.push(bagData);
			}
		}

		private function handlerSM_APPLY_INTO_CHANGE_AGREE(data:ByteArray):void
		{
			if (oppositeData == null)
			{
				oppositeData = new OppositeDataInfo();
			}
			oppositeData.cid = data.readInt();
			oppositeData.sid = data.readInt();
			oppositeData.name = data.readUTF();
			oppositeData.level = data.readShort();
			oppositeData.bagFreeCount = data.readInt();
			openTradePanel();
		}

		/**打开交易面板*/
		private function openTradePanel():void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_TRADE);
			PanelMediator.instance.openPanel(PanelConst.TYPE_BAG, true);
		}

		/**关闭交易面板*/
		private function closeTradePanel():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_TRADE);
			PanelMediator.instance.closePanel(PanelConst.TYPE_BAG);
		}

		/**关闭面板 交易取消*/
		private function handlerSM_CHANGE_CANCLE(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.TRADE_0020, name));

			closeTradePanel();
		}

		/**邀请成功*/
		private function handlerCM_APPLY_INTO_CHANGE_AGREE():void
		{
		}

		private function handlerSM_CHANGE_APPLY_REFUSE(data:ByteArray):void
		{
			var cid:int = data.readInt();
			var sid:int = data.readInt();
			var name:String = data.readUTF();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.TRADE_0019, name));
		}

		private function handlerSM_CHANGE_INFO(data:ByteArray):void
		{
			if (oppositeData == null)
			{
				oppositeData = new OppositeDataInfo();
			}
			oppositeData.cid = data.readInt();
			oppositeData.sid = data.readInt();
			oppositeData.name = data.readUTF();
			oppositeData.level = data.readShort();
			oppositeData.mapId = data.readInt();
			oppositeData.bagFreeCount = data.readInt();

			openTradePanel();
		}

		private function handlerCM_CREATE_EXCHANGE(data:ByteArray):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TRADE_0018);
		}

		private function handlerSM_CREATE_EXCHANGE(data:ByteArray):void
		{
			var cid:int, sid:int;
			cid = data.readInt();
			sid = data.readInt();

			if (exchangeData)
			{
				if (exchangeData.cid == cid && exchangeData.sid == sid)
				{

				} else
				{
					exchangeData = new ExchangeData();
					exchangeData.cid = cid;
					exchangeData.sid = sid;
					exchangeData.name = data.readUTF();
					exchangeData.level = data.readShort();
					exchangeData.mapId = data.readInt();
				}
			} else
			{
				exchangeData = new ExchangeData();
				exchangeData.cid = cid;
				exchangeData.sid = sid;
				exchangeData.name = data.readUTF();
				exchangeData.level = data.readShort();
				exchangeData.mapId = data.readInt();
			}
		}

		override public function clearDataManager():void
		{
			_instance = null;
		}

		/**发送交易请求*/
		public function sendTradeQuest(cid:int, sid:int):void
		{
			var bool:Boolean = checkIsInTradeArea(cid, sid);
			if (bool == false)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0016);
				return;
			}
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CREATE_EXCHANGE, data);
		}

		/**同意或拒绝交易*/
		public function argreeOrRefuseTrade(cid:int, sid:int, isAgree:int):void
		{
			var bool:Boolean = checkIsInTradeArea(cid, sid);
			if (bool == false)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0016);
				return;
			}
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			data.writeByte(isAgree);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_APPLY_INTO_CHANGE_AGREE, data);
		}

		public function checkIsInTradeArea(cid:int, sid:int):Boolean
		{
			var self:Player = EntityLayerManager.getInstance().firstPlayer as Player;
			var player:Player = EntityLayerManager.getInstance().getPlayerByCidSid(cid, sid);
			if (player == null) return false;

			var distance:int = self.tileDistance(player.tileX, player.tileY);
			if (distance > 10)
			{
				return false;
			} else
			{
				return true;
			}
		}

		/**超出交易范围*/
		public function beyondArea():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BEYOND_CHANGE_LIMIT, data);
			data = null;
		}

		/**交易取消*/
		public function cancelTrade(cid:int, sid:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHANGE_CANCLE, data);
			data = null;
			closeTradePanel();
		}

		/**发送背包向交易栏拖动信息*/
		public function sendCM_BEGIN_CHANGE(cid:int, sid:int, type:int, storage:int, slot:int, count:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			data.writeByte(type);
			if (type == TRADE_TYPE_ITEM)
			{//道具时
				data.writeByte(storage);
				data.writeByte(slot);
			}
			data.writeInt(count);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BEGIN_CHANGE, data);
			data = null;
		}

		/**交易栏物品放回背包*/
		public function sendCM_CHANGE_THING_TOBAG(cid:int, sid:int, item_id:int, item_type:int, item_count:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			data.writeInt(item_id);
			data.writeByte(item_type);
			data.writeInt(item_count);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHANGE_THING_TOBAG, data);
			data = null;
		}

		private static var _instance:TradeDataManager = null;
		public static function get instance():TradeDataManager
		{
			if (_instance == null)
			{
				_instance = new TradeDataManager();
			}
			return _instance;
		}

		/**锁定交易*/
		public function sendLock(cid:int, sid:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHANGE_LOCK, data);
		}

		/**交易*/
		public function sendTrade(cid:int, sid:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(cid);
			data.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHANGE, data);
		}

		/**检查是否在交易范围*/
		public function checkDistance():Boolean
		{
			var entityManager:EntityLayerManager = EntityLayerManager.getInstance();
			var tradeManager:TradeDataManager = TradeDataManager.instance;
			var self:Player = entityManager.firstPlayer as Player;
			var other:Player = null;
			if (tradeManager.oppositeData)
			{
				other = entityManager.getPlayerByCidSid(tradeManager.oppositeData.cid, tradeManager.oppositeData.sid);
			}
			if (other == null)
			{
				return false;
			}
			if (self.tileDistance(other.tileX, other.tileY) > 10)
			{
				return false;
			}
			return true;
		}

		/**解析交易他人装备信息*/
		public function resloveOtherEquipInfo(data:ByteArray):void
		{
			var job:int, size:int;
			if (oppositeData == null)
			{
				oppositeData = new OppositeDataInfo();
			}
			oppositeData.cid = data.readInt();
			oppositeData.sid = data.readInt();

			job = data.readByte();
			size = data.readShort();
			while (size-- > 0)
			{
				var onlyId:int = data.readInt();
				var bornSid:int = data.readInt();
				if (!dic[bornSid])
				{
					dic[bornSid] = new Dictionary();
				}
				var memEquipData:MemEquipData = dic[bornSid][onlyId];
				if (!memEquipData)
				{
					memEquipData = new MemEquipData();
					memEquipData.onlyId = onlyId;
					memEquipData.bornSid = bornSid;
					dic[memEquipData.bornSid][memEquipData.onlyId] = memEquipData;
				}
				memEquipData.baseId = data.readInt();
				memEquipData.duralibility = data.readInt();
				memEquipData.strengthen = data.readByte();
				memEquipData.polish = data.readByte();
				memEquipData.polishExp = data.readShort();
				memEquipData.bind = data.readByte();
				memEquipData.goodLuck = data.readInt();
				var attrRds:Vector.<AttrRandomData> = new Vector.<AttrRandomData>();
				var attrRdCount:int = data.readInt();
				memEquipData.attrRdCount = attrRdCount;
				memEquipData.attrRdStars = 0;
				var attrRdMaxStar:int;
				while (attrRdCount--)
				{
					var index:int = data.readByte();//洗炼属性的属性下标，为1字节有符号整形
					var star:int = data.readByte();//洗炼星级，为1字节有符号整形
					var type:int = data.readByte();//属性加成为1.值加成 2.百分比，为1字节有符号整形
					var addon_rate:int = data.readInt();//属性加成数，为4字节有符号整形
					if (index)
					{
						var attrRdDt:AttrRandomData = new AttrRandomData();
						attrRds.push(attrRdDt);
						attrRdDt.star = star;
						var attrDt:PropertyData = CfgDataParse.getPropertyDatas(index + ":" + type + ":" + addon_rate, false, null, job)[0];
						attrRdDt.attrDt = attrDt;
						memEquipData.attrRdStars += star;
						attrRdMaxStar < star ? attrRdMaxStar = star : null;
					}
					else
					{
						attrRds.push(null);
					}
				}
				memEquipData.attrRdMaxStar = attrRdMaxStar;
				memEquipData.setAttrRds(attrRds);
			}
		}

		public function getOthermemEquipData(bornSid:int, onlyId:int):MemEquipData
		{
			if (!dic[bornSid])
			{
				return null;
			}
			return dic[bornSid][onlyId];
		}

		/**检查拖的物品是否超过对方背包的容量*/
		public function get checkSurpassOtherBagSizes():Boolean
		{
			if (oppositeData && selfItems)
			{
				return (selfItems.length >= oppositeData.bagFreeCount);
			}
			return false;
		}

		/**检查是否超过交易物品上限*/
		public function get checkLimit():Boolean
		{
			if (selfItems)
			{
				return selfItems.length >= CELL_CAPABILITY;
			}
			return false;
		}
	}
}
