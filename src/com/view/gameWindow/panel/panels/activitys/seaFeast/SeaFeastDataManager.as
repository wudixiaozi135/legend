package com.view.gameWindow.panel.panels.activitys.seaFeast
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.dataManager.IDataManager;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivitySeaFeastCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.StringConst;
	import com.pattern.Observer.Observe;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirmData;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.constants.SpecialActionTypes;
	import com.view.gameWindow.scene.entity.entityItem.FirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.ITrap;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * 海天盛宴数据类
	 * <br>在ActivityDataManager类中实现对象
	 * @author Administrator
	 */	
	public class SeaFeastDataManager extends Observe implements IDataManager
	{
		public static const BTNS_SUNBATHE:int = 0;//日光浴
		public static const BTNS_FOOTSIE:int = 1;//挑逗
		public static const BTNS_MASSAGE:int = 2;//推油
		public static const BTNS_WATERMELON:int = 3;//砸西瓜
		//
		public static const ASSBT_LAY:int = 1;//日光浴
		public static const ASSBT_TEASE:int = 2;//挑逗
		public static const ASSBT_BE_TEASE:int = 3;//被挑逗
		public static const ASSBT_PUSH_OIL:int = 4;//推油
		public static const ASSBT_BE_PUSH_OIL:int = 5;//被推油
		public static const ASSBT_WATERMELON:int = 6;//砸西瓜
		public static const ASSBT_PICK:int = 7;//捡内衣
		public static const ASSBT_TOTAL:int = 8;
		//
		public static const PROC_SHOW_CD:int = 123123;
		//
		public static const NUM_BTNS:int = 4;

		public static const SEA_FEAST_NPC_ID:int = 80501;//海天盛宴二小姐
		
		public var exp_gain:int;
		public var clickIndex:int = -1;
		/**剩余总次数数组*/
		public var arrayRemainTotal:Vector.<int>;
		/**剩余免费次数数组*/
		public var arrayRemainFree:Vector.<int>;
		/**商店配置数组*/
		public var arrayShopCfgDt:Vector.<NpcShopCfgData>;
		/**消耗物品数组*/
		public var arrayItemId:Vector.<int>;
		/**cd结束时间数组*/
		public var arrayCDOverTime:Vector.<int>;
		/**所有气泡数组*/
		public var arrayBubbles:Vector.<String>;
		/**上次获得的经验*/
		private var lastGainExp:int;

		private var _timerIdSunBathe:uint;
		private var _timerIdMassage:uint;
		private var _timerIdBeMassage:uint;
		
		public function SeaFeastDataManager()
		{
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_SEA_SIDE_BUBBLE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_SEA_SIDE_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_SEA_SIDE_TEASE,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_ACTIVITY_SEA_SIDE_SUBMIT, this);
			//
			arrayRemainTotal = new Vector.<int>(NUM_BTNS,true);
			arrayRemainFree = new Vector.<int>(NUM_BTNS,true);
			arrayShopCfgDt = new Vector.<NpcShopCfgData>(NUM_BTNS,true);
			arrayItemId = new Vector.<int>(NUM_BTNS,true);
			arrayCDOverTime = new Vector.<int>(NUM_BTNS,true);
			arrayBubbles = new Vector.<String>(ASSBT_TOTAL,true);
			//
			try
			{
				var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
				var npcShopCfgDt:NpcShopCfgData = ConfigDataManager.instance.npcShopCfgData1(cfgDt.tease_item_shop);
				arrayShopCfgDt[BTNS_FOOTSIE] = npcShopCfgDt;
				npcShopCfgDt = ConfigDataManager.instance.npcShopCfgData1(cfgDt.push_oil_item_shop);
				arrayShopCfgDt[BTNS_MASSAGE] = npcShopCfgDt;
				npcShopCfgDt = ConfigDataManager.instance.npcShopCfgData1(cfgDt.watermelon_item_shop);
				arrayShopCfgDt[BTNS_WATERMELON] = npcShopCfgDt;
				//
				arrayItemId[BTNS_FOOTSIE] = cfgDt.tease_item;
				arrayItemId[BTNS_MASSAGE] = cfgDt.push_oil_item;
				arrayItemId[BTNS_WATERMELON] = cfgDt.watermelon_item;
				//
				arrayBubbles[ASSBT_LAY] = cfgDt.lay_bubble;
				arrayBubbles[ASSBT_TEASE] = cfgDt.teaser_bubble;
				arrayBubbles[ASSBT_BE_TEASE] = cfgDt.teasee_bubble;
				arrayBubbles[ASSBT_PUSH_OIL] = cfgDt.oil_pusher_bubble;
				arrayBubbles[ASSBT_BE_PUSH_OIL] = cfgDt.oil_pushee_bubble;
				arrayBubbles[ASSBT_WATERMELON] = cfgDt.watermelon_bubble;
				arrayBubbles[ASSBT_PICK] = cfgDt.pick_bubble;
			} 
			catch(error:Error) 
			{
				trace(error.message);
			}
		}
		
		public function get seaFeastCfgData():ActivitySeaFeastCfgData
		{
			var seaFeastCfgData:ActivitySeaFeastCfgData = ConfigDataManager.instance.seaFeastCfgData();
			return seaFeastCfgData;
		}
		
		public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_ACTIVITY_SEA_SIDE_BUBBLE:
					smActivitySeaSideBubble(data);
					break;
				case GameServiceConstants.SM_ACTIVITY_SEA_SIDE_TEASE:
					smActivitySeaSideTease(data);
					break;
				case GameServiceConstants.SM_ACTIVITY_SEA_SIDE_INFO:
					smActivitySeaSideInfo(data);
					break;
				case GameServiceConstants.CM_ACTIVITY_SEA_SIDE_SUBMIT:
					handlerCM_ACTIVITY_SEA_SIDE_SUBMIT(data);
					break;
				default:
					break;
			}
			notify(proc);
		}

		private function handlerCM_ACTIVITY_SEA_SIDE_SUBMIT(data:ByteArray):void
		{
			var ticketCount:int = data.readInt();
			RollTipMediator.instance.showRollTip(RollTipType.PROPERTY, StringConst.ITEM_USE_05 + ticketCount);
		}
		
		private function smActivitySeaSideBubble(byteArray:ByteArray):void
		{
			var bubblerEntityId:int = byteArray.readInt();//4字节有符号整形，发出者唯一id
			var bubbleType:int = byteArray.readByte();//1字节有符号整形，泡泡类型
			var bubbleId:int = byteArray.readByte();//1字节有符号整形，泡泡id
			//
			var player:IPlayer = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_PLAYER,bubblerEntityId) as IPlayer;
			if(!(player is FirstPlayer))
			{
				var bubble:String = getBubble(arrayBubbles[bubbleType],bubbleId);
				player ? player.say(bubble) : null;
			}
		}
		
		private function smActivitySeaSideTease(byteArray:ByteArray):void
		{
			var teaserEntityId:int = byteArray.readInt();//4字节有符号整形，发出者唯一id
			var teaseeEntityId:int = byteArray.readInt();//4字节有符号整形，接收者唯一id
			var teaserBubbleId:int = byteArray.readByte();//1字节有符号整形，挑逗者泡泡id
			var teaseeBubbleId:int = byteArray.readByte();//1字节有符号整形，被挑逗者泡泡id
			var entityId:int = EntityLayerManager.getInstance().firstPlayer.entityId;
			if(entityId == teaserEntityId)
			{
				return;
			}
			//
			var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
			var bubble:String = getBubble(cfgDt.teaser_bubble,teaserBubbleId);
			var player:IPlayer = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_PLAYER,teaserEntityId) as IPlayer;
			player ? (player.say(bubble), player.footsie()) : null;
			bubble = getBubble(cfgDt.teasee_bubble,teaseeBubbleId);
			player = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_PLAYER,teaseeEntityId) as IPlayer;
			var timerId:int = setTimeout(function ():void
			{
				clearTimeout(timerId);
				player ? player.say(bubble) : null;
			},500);
		}
		
		private function getBubble(bubbles:String,bubbleId:int):String
		{
			var arrayBubble:Array = bubbles.split("|");
			var bubble:String = arrayBubble.length > bubbleId ? arrayBubble[bubbleId] : "";
			return bubble;
		}
		
		private function smActivitySeaSideInfo(byteArray:ByteArray):void
		{
			var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
			var tease_count:int = byteArray.readByte();//1字节有符号整形，今日已挑逗次数
			var push_oil_count:int = byteArray.readByte();//1字节有符号整形,今日已推油次数
			var watermelon_count:int = byteArray.readByte();//1字节有符号整形,今日砸西瓜次数
			exp_gain = byteArray.readInt();//4字节有符号整形，今日参加海天活动获得的经验
			if(exp_gain-lastGainExp>0)
				/*Alert.reward(StringConst.WORSHIP_TIP_0002 + (exp_gain-lastGainExp));*/
			lastGainExp = exp_gain;
			arrayRemainTotal[BTNS_SUNBATHE] = int.MAX_VALUE;
			arrayRemainTotal[BTNS_FOOTSIE] = cfgDt.free_tease_count + cfgDt.toll_tease_count - tease_count;
			arrayRemainTotal[BTNS_MASSAGE] = cfgDt.free_push_oil_count + cfgDt.toll_push_oil_count - push_oil_count;
			arrayRemainTotal[BTNS_WATERMELON] = cfgDt.free_watermelon_count + cfgDt.toll_watermelon_count - watermelon_count;
			//
			arrayRemainFree[BTNS_SUNBATHE] = int.MAX_VALUE;
			arrayRemainFree[BTNS_FOOTSIE] = cfgDt.free_tease_count - tease_count;
			arrayRemainFree[BTNS_MASSAGE] = cfgDt.free_push_oil_count - push_oil_count;
			arrayRemainFree[BTNS_WATERMELON] = cfgDt.free_watermelon_count - watermelon_count;
		}
		
		public function dealBtnClick(index:int):void
		{
			var remianTotal:int = arrayRemainTotal[index];
			if(remianTotal)
			{
				var remianFree:int = arrayRemainFree[index];
				if(remianFree > 0)
				{
					dealCm(index);
				}
				else
				{
					var isCostExist1:Boolean = isCostExist(index);
					if (isCostExist1)
					{
						dealCm(index);
					}
					else
					{
						showBuyConfirm(index);
					}
				}
			}
			else
			{
				Alert.warning(StringConst.SEA_FEAST_0002);
			}
		}
		
		private function dealCm(index:int):void
		{
			switch(index)
			{
				case BTNS_SUNBATHE:
					cmSunbathe(index);
					break;
				case BTNS_FOOTSIE:
					cmFootsie(index);
					break;
				case BTNS_MASSAGE:
					cmMassage(index);
					break;
				case BTNS_WATERMELON:
					cmWatermelon(index);
					break;
				default:
					break;
			}
		}
		
		private function checkTarget(select:IEntity):Boolean
		{
			if(!select)
			{
				Alert.warning(StringConst.SEA_FEAST_0001);
				return false;
			}
			return true;
		}
		
		private function checkSex(select:IPlayer):Boolean
		{
			if(select.sex == RoleDataManager.instance.sex)
			{
				Alert.warning(StringConst.SEA_FEAST_0003);
				return false;
			}
			return true;
		}
		
		private function checkSunbathe(select:IPlayer):Boolean
		{
			if(select.specialAction != SpecialActionTypes.PSA_LAY)
			{
				Alert.message(StringConst.SEA_FEAST_0012);
				return false;
			}
			return true;
		}
		
		private function checkCD(index:int):Boolean
		{
			if(getTimer() < arrayCDOverTime[index])
			{
				Alert.warning(StringConst.SEA_FEAST_0004);
				return false;
			}
			return true;
		}
		
		private function cmSunbathe(index:int):void
		{
			var boolean:Boolean = checkCD(index);
			if(!boolean)
			{
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			var direction:int = EntityLayerManager.getInstance().firstPlayer.direction;
			byteArray.writeByte(direction);//dir，1字节有符号整形，方向
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ACTIVITY_SEA_SIDE_LAY,byteArray);
			//
			arrayCDOverTime[index] = getTimer() + seaFeastCfgData.lay_cd*1000;
			notifyData(PROC_SHOW_CD,index);
		}
		
		private function cmFootsie(index:int):void
		{
			var select:IPlayer = AutoJobManager.getInstance().selectEntity as IPlayer;
			var boolean:Boolean = checkTarget(select) && checkSex(select) && checkCD(index);
			if(!boolean)
			{
				return;
			}
			var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
			//
			var cid:int = select.cid;
			var sid:int = select.sid;
			var teaserBubbleId:int = bubbleIdRandom(cfgDt.teaser_bubble);
			var teaseeBubbleId:int = bubbleIdRandom(cfgDt.teasee_bubble);
			//
			var bubble:String = getBubble(cfgDt.teaser_bubble,teaserBubbleId);
			var player:IPlayer = EntityLayerManager.getInstance().firstPlayer as IPlayer;
			player.say(bubble);
			player.footsie();
			bubble = getBubble(cfgDt.teasee_bubble,teaseeBubbleId);
			var timerId:int = setTimeout(function ():void
			{
				clearTimeout(timerId);
				select.say(bubble);
			},500);
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(cid);//4字节有符号整形，对方角色id
			byteArray.writeInt(sid);//4字节有符号整形，对方服务器id
			byteArray.writeByte(teaserBubbleId);//1字节有符号整形，挑逗者泡泡id
			byteArray.writeByte(teaseeBubbleId);//1字节有符号整形，被挑逗者泡泡id
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ACTIVITY_SEA_SIDE_TEASE,byteArray);
			//
			arrayCDOverTime[index] = getTimer() + cfgDt.tease_cd*1000;
			notifyData(PROC_SHOW_CD,index);
		}
		
		private function cmMassage(index:int):void
		{
			var select:IPlayer = AutoJobManager.getInstance().selectEntity as IPlayer;
			var boolean:Boolean = checkTarget(select) && checkSunbathe(select) && checkSex(select) && checkCD(index);
			if(!boolean)
			{
				return;
			}
			clickIndex = index;
			var entity:IEntity = AutoJobManager.getInstance().selectEntity;
			AutoJobManager.getInstance().runToEntity(entity);
		}
		/**仅在AutoJobManager.checkReachPushOil(livingUnit)中调用*/		
		public function sendMassage():void
		{
			var select:IPlayer = AutoJobManager.getInstance().selectEntity as IPlayer;
			var cid:int = select.cid;
			var sid:int = select.sid;
			//
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			firstPlayer.direction = Direction.getDirectionByTile(firstPlayer.tileX, firstPlayer.tileY, select.tileX, select.tileY);
			firstPlayer.massage();
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(cid);//4字节有符号整形，对方角色id
			byteArray.writeInt(sid);//4字节有符号整形，对方服务器id
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ACTIVITY_SEA_SIDE_PUSH_OIL,byteArray);
			//
			arrayCDOverTime[clickIndex] = getTimer() + seaFeastCfgData.push_oil_cd*1000;
			notifyData(PROC_SHOW_CD,clickIndex);
			clickIndex = -1;
		}
		
		private function cmWatermelon(index:int):void
		{
			var select:ITrap = AutoJobManager.getInstance().selectEntity as ITrap;
			var boolean:Boolean = checkTarget(select);
			if(!boolean)
			{
				return;
			}
			var entity:IEntity = AutoJobManager.getInstance().selectEntity;
			AutoJobManager.getInstance().runToEntity(entity);
		}
		/**仅在AutoJobManager.sendTrigger(entityId)中调用*/
		public function sendWatermelon():void
		{
			var select:ITrap = AutoJobManager.getInstance().selectEntity as ITrap;
			var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
			//
			var entityId:int = select.entityId;
			var bubbleId:int = bubbleIdRandom(seaFeastCfgData.watermelon_bubble);
			//
			var bubble:String = getBubble(cfgDt.watermelon_bubble,bubbleId);
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			firstPlayer.direction = Direction.getDirectionByTile(firstPlayer.tileX, firstPlayer.tileY, select.tileX, select.tileY);
			firstPlayer.watermelon();
			firstPlayer.changeModel();
			firstPlayer.say(bubble);
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(entityId);//4字节有符号整形，西瓜机关的id
			byteArray.writeByte(bubbleId);//1字节有符号整形，泡泡的id
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ACTIVITY_SEA_SIDE_WATERMELON,byteArray);
		}
		
		private function bubbleIdRandom(bubbles:String):int
		{
			var arrayBubble:Array = bubbles.split("|");
			var bubbleId:int = int(Math.random()*arrayBubble.length);
			return bubbleId;
		}
		
		private function isCostExist(index:int):Boolean
		{
			var itemId:int = arrayItemId[index];
			var num:int = BagDataManager.instance.getItemNumById(itemId);
			num += HeroDataManager.instance.getItemNumById(itemId);
			return Boolean(num);
		}
		
		private function showBuyConfirm(index:int):void
		{
			PanelBuyItemConfirmData.cfgDt = arrayShopCfgDt[index];
			PanelMediator.instance.openPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
		}
		
		public function remainCDTime(index:int):int
		{
			var remain:int = arrayCDOverTime[index] - getTimer();
			return remain > 0 ? remain : 0;
		}
		
		public function startSunBatheBubble():void
		{
			stopBubble();
			var delay:int = getDelay(15000);
			_timerIdSunBathe = setTimeout(function onTimer():void
			{
				var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
				var bubbleId:int = bubbleIdRandom(cfgDt.lay_bubble);
				var bubble:String = getBubble(cfgDt.lay_bubble,bubbleId);
				var player:IPlayer = EntityLayerManager.getInstance().firstPlayer as IPlayer;
				player.say(bubble);
				cmActivitySeaSideBubble(ASSBT_LAY,bubbleId);
				clearTimeout(_timerIdSunBathe);
				var delay:int = getDelay(15000);
				_timerIdSunBathe = setTimeout(onTimer,delay);
			},delay);
		}
		
		public function startMassageBubble():void
		{
			stopBubble();
			var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
			var delay:int = getDelay(cfgDt.push_oil_time*300);
			_timerIdMassage = setTimeout(function onTimer():void
			{
				var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
				var bubbleId:int = bubbleIdRandom(cfgDt.oil_pusher_bubble);
				var bubble:String = getBubble(cfgDt.oil_pusher_bubble,bubbleId);
				var player:IPlayer = EntityLayerManager.getInstance().firstPlayer as IPlayer;
				player.say(bubble);
				cmActivitySeaSideBubble(ASSBT_PUSH_OIL,bubbleId);
				clearTimeout(_timerIdMassage);
				var delay:int = getDelay(cfgDt.push_oil_time*300);
				_timerIdMassage = setTimeout(onTimer,delay);
			},delay);
		}
		
		public function startBeMassageBubble():void
		{
			stopBubble();
			var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
			var delay:int = getDelay(cfgDt.push_oil_time*500);
			_timerIdBeMassage = setTimeout(function onTimer():void
			{
				var cfgDt:ActivitySeaFeastCfgData = seaFeastCfgData;
				var bubbleId:int = bubbleIdRandom(cfgDt.oil_pushee_bubble);
				var bubble:String = getBubble(cfgDt.oil_pushee_bubble,bubbleId);
				var player:IPlayer = EntityLayerManager.getInstance().firstPlayer as IPlayer;
				player.say(bubble);
				cmActivitySeaSideBubble(ASSBT_BE_PUSH_OIL,bubbleId);
				clearTimeout(_timerIdBeMassage);
				var delay:int = getDelay(cfgDt.push_oil_time*500);
				_timerIdBeMassage = setTimeout(onTimer,delay);
			},delay);
		}
		
		public function stopBubble():void
		{
			clearTimeout(_timerIdSunBathe);
			clearTimeout(_timerIdMassage);
			clearTimeout(_timerIdBeMassage);
		}
		
		public function get isBePusheOil():Boolean
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if(firstPlayer.specialAction == SpecialActionTypes.PSA_BE_PUSH_OIL)
			{
				Alert.show2(StringConst.SEA_FEAST_0013,function():void
				{
					cmActivitySeaSideStand();
				});
				return true;
			}
			return false;
		}
		/**
		 * 
		 * @param interval 时间间隔（毫秒）
		 * @return 
		 */		
		private function getDelay(interval:int):int
		{
			var delay:int = .7*interval + Math.random()*.3*interval;
			return delay;
		}
		/**是否为海天盛宴活动中的互动目标*/
		public function get isSeaFeastInteractive():Boolean
		{
			var entity:IEntity = AutoJobManager.getInstance().selectEntity;
			var player:IPlayer = entity as IPlayer;
			if(player && player.specialAction == SpecialActionTypes.PSA_LAY)
			{
				return true;
			}
			var isEqual:Boolean = ActivityDataManager.instance.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_SEA_SIDE);
			var trap:ITrap = entity as ITrap;
			if(isEqual && trap)
			{
				return true;
			}
			return false;
		}	
		
		public function cmActivitySeaSideStand():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ACTIVITY_SEA_SIDE_STAND,byteArray);
		}
		/**
		 * @param bubbleType 泡泡类型
		 * @param bubbleId 泡泡的id
		 */		
		public function cmActivitySeaSideBubble(bubbleType:int,bubbleId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(bubbleType);
			byteArray.writeByte(bubbleId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ACTIVITY_SEA_SIDE_BUBBLE,byteArray);
		}
		
		public function cmLeaveActivityMap():void
		{
			stopBubble();
			ActivityDataManager.instance.cmLeaveActivityMap();
		}

		/**海天盛宴提交道具*/
		public function cmCM_ACTIVITY_SEA_SIDE_SUBMIT():void
		{
			var byte:ByteArray = new ByteArray();
			byte.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ACTIVITY_SEA_SIDE_SUBMIT, byte);
			byte = null;
		}
	}
}