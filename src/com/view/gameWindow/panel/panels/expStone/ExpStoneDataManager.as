package com.view.gameWindow.panel.panels.expStone
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.consts.ConstStorage;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.common.ModelEvents;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.subuis.bottombar.ExpRecorder;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.bag.BagPanel;
    import com.view.gameWindow.panel.panels.bag.cell.BagCell;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.newMir.NewMirMediator;
    
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    
    import mx.utils.StringUtil;

    /**
	 * @author wqhk
	 * 2014-11-13
	 */
	public class ExpStoneDataManager extends DataManagerBase implements IObserver
	{
        public static var bagCell:BagCell;
		private var bagStates:Array = [0,0];
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_BAG_ITEMS)
			{
				bagStates[0] = 1;
				initData();
			}
			else if(proc == GameServiceConstants.SM_HERO_INFO)
			{
				bagStates[1] = 1;
				initData();
			}
			
		}
		
		public function ExpStoneDataManager()
		{
			super();
			info = new Dictionary();
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_DAILY_USE_EXPYU_NUM,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_EXP_PANLE_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ALL_EXP_YU_INFO,this);
		    SuccessMessageManager.getInstance().register(GameServiceConstants.CM_USE_EXPYU,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_EXP_PANLE,this);
			
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
		}
		
		private static var _instance:ExpStoneDataManager;
		
		public static function get instance():ExpStoneDataManager
		{
			if(!_instance)
			{
				_instance = new ExpStoneDataManager();
			}
			
			return _instance;
		}
		
		private const ITEMID:int = 3001;//经验玉ID
		
		public var numUse:int;
		public var numTotal:int;
		public var info:Dictionary;//按slot存 注意如果物品移动或消失，这里的数据并不会清除，
		
		public var type:int = 0;
		public var exp:int;
		public var num:int;
		public var sum:int;
		private var firstMax:int = 0;
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(proc == GameServiceConstants.SM_DAILY_USE_EXPYU_NUM)
			{
				resolveInfoOne(data);
			}
			else if(proc == GameServiceConstants.CM_USE_EXPYU)
			{
				resolveUseSuccess(data);
			}
			else if(proc == GameServiceConstants.SM_EXP_PANLE_INFO)
			{
				resolveExpInfo(data);
			}
			else if(proc == GameServiceConstants.SM_ALL_EXP_YU_INFO)
			{
				resolveInfo(data);
			}
			
			super.resolveData(proc,data);
		}
		
		private function resolveInfoOne(value:ByteArray):void
		{
			// TODO Auto Generated method stub
			var data:ExpStoneData = new ExpStoneData;
			data.storage = value.readByte();
			data.slot = value.readByte();
			data.exp = value.readInt();
			data.item = getItem(data.storage,data.slot);
			numUse = value.readInt();
			numTotal = value.readInt();
			if(data.storage == ConstStorage.ST_CHR_BAG || data.storage == ConstStorage.ST_HERO_BAG)
			{
				info[data.storage+"_"+data.slot] = data;
			}
		}
		
		private function resolveExpInfo(data:ByteArray):void
		{
			var newType:int = data.readByte();
			
			var oldExp:int = exp;
			exp = data.readInt();
			num = data.readInt();
			sum = data.readInt();
			
			if(type != newType)
			{
				type = newType;
				GuideSystem.instance.updateExpStone(type);
			}
			
			if(type == 1)
			{
				if(oldExp != exp)
				{
					if(firstMax == 0)
					{
						firstMax = ExpStoneData.getMaxExp(ConfigDataManager.instance.itemCfgData(ITEMID));
					}
					
					if(exp == firstMax)
					{
						notify(ModelEvents.SHOW_VIP_EXPERIENCE);
					}
				}
			}
		}
		
		public function initData():void
		{
			if(bagStates[0] && bagStates[1])
			{
				var bag:Vector.<BagData> = BagDataManager.instance.bagCellDatas;
				var hero:Vector.<BagData> = HeroDataManager.instance.bagCellDatas;
				
				if(bag && hero)
				{
					var list:Vector.<BagData> = bag.concat(hero);
					
//					for each(var data:BagData in list)
//					{
//						if(data && getItem(data.storageType,data.slot))
//						{
//							requestQueryInfo(data.storageType,data.slot);
//						}
//					}
					requestQueryInfo(2);
				}
			}
		}
		
		public function getVipTipText():String
		{
			var txt:String = HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.EXP_STONE_TIP9+VipDataManager.instance.lv+"\n");
			txt+=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.EXP_STONE_TIP10+"\n");
			var arr:Array = [10,12,12,12,15,15,15,18,18,20];
			
			for(var i:int = 0; i < arr.length; ++i)
			{
				txt+=HtmlUtils.createHtmlStr(0xcccccc,StringUtil.substitute(StringConst.EXP_STONE_TIP11,(i+1),arr[i])+"\n");
			}
			
			return txt;
		}
		
		public function resolveUseSuccess(data:ByteArray):void
		{
			var value:int = data.readInt();
            handlerEffect();
			Alert.message(StringUtil.substitute(StringConst.EXP_STONE_TIP8,value));	
		}

        private function handlerEffect():void
        {
            if (bagCell)
            {
                var bagPanel:BagPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG) as BagPanel;
                var point:Point;
                if (bagPanel && bagCell.parent)
                {
                    point = bagCell.parent.localToGlobal(new Point(bagCell.x + (bagCell.width * .5), bagCell.y + (bagCell.height * .5)));
                } else
                {
                    point = new Point(NewMirMediator.getInstance().width * .5, NewMirMediator.getInstance().height * .5);
                }
                FlyEffectMediator.instance.deExpStoneEffect(point);
                bagCell = null;
            }
        }
		
		public function resolveInfo(value:ByteArray):void
		{
			var num:int = value.readInt();
			for(var i:int = 0;i<num;i++)
			{
				var data:ExpStoneData = new ExpStoneData;
				data.storage = value.readByte();
				data.slot = value.readByte();
				data.exp = value.readInt();
				data.item = getItem(data.storage,data.slot);
				if(data.storage == ConstStorage.ST_CHR_BAG || data.storage == ConstStorage.ST_HERO_BAG)
				{
					info[data.storage+"_"+data.slot] = data;
				}
			}
			
		}
		
		public function getFullExpStoneNum():int
		{
			var count:int;
			for each(var data:ExpStoneData in info)
			{
				var item:ItemCfgData = getItem(data.storage,data.slot);
				if(item&&(item.type == ItemType.EXP_STONE || item.type == ItemType.EXP_STONE_A)&&data.exp>=data.maxExp)
					count++;
			}
			return count;
		}
		
		public function getCurrrntExpStone():ExpStoneData
		{
			var exp:int = int.MAX_VALUE;
			var expData:ExpStoneData;
			for each(var data:ExpStoneData in info)
			{
				var item:ItemCfgData = getItem(data.storage,data.slot);
				if(item&&(item.type == ItemType.EXP_STONE || item.type == ItemType.EXP_STONE_A)&&data.exp>=data.maxExp)
				{
					if(data.exp<exp)
					{
						exp = data.exp;
						expData = data;
					}
				}
			}
			return expData;
		}
		
		/**
		 * 面板经验开启
		 * 
		 */		
		public function openExpPanel():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_OPEN_EXP_PANLE,byteArray);
		}
		
		/**
		 * 经验玉面板获得
		 * 
		 */		
		public function getExpYuPanel():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_EXP_YU_AWARD,byteArray);
		}
		
		/**
		 * 领取面板经验
		 * @param type 1:普通领取 2:两倍领取
		 * 
		 */		
		public function getExpPanel(type:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_EXP_PANLE,byteArray);
		}
		
		public function getExpInfo(storage:int,slot:int):ExpStoneData
		{
			if(storage == ConstStorage.ST_CHR_BAG || storage == ConstStorage.ST_HERO_BAG)
			{
				return info[storage+"_"+slot];
			}
			
			return null;
		}
		
		public function getItem(storage:int,slot:int):ItemCfgData
		{
			var item:ItemCfgData = null;
			
			var bagData:BagData;
			
			if(storage == ConstStorage.ST_CHR_BAG)
			{
				bagData = BagDataManager.instance.getBagCellData(slot);
			}
			else if(storage == ConstStorage.ST_HERO_BAG)
			{
				bagData = HeroDataManager.instance.getBagCellData(slot);
			}
			
			if(bagData && bagData.id &&  bagData.type == SlotType.IT_ITEM)
			{
				item = ConfigDataManager.instance.itemCfgData(bagData.id);
				
				if(item && (item.type == ItemType.EXP_STONE||item.type==ItemType.EXP_STONE_A))
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function requestQueryInfo(type:int,storage:int = 0,slot:int = 0):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeByte(type);
			if(type == 1)
			{
				data.writeByte(storage);
				data.writeByte(slot);
			}
			
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_EXPYU,data);
		}
		
		public function requestUseStone(storage:int,slot:int,multiple:int):void
		{
			var info:ExpStoneData = getExpInfo(storage,slot);
			
			if(info)
			{
				if(storage != ConstStorage.ST_CHR_BAG)
				{
					Alert.warning(StringConst.EXP_STONE_TIP7);
				}
				else if(multiple == 2 && info.VIP>VipDataManager.instance.lv)
				{
					Alert.warning(StringConst.EXP_STONE_TIP6);
				}
				else if(info.exp<info.maxExp)
				{
					Alert.warning(StringConst.EXP_STONE_TIP5);
				}
				else
				{
					var isExpFull:Boolean = RoleDataManager.instance.isExpFull();
					if(isExpFull)
					{
						Alert.warning(StringConst.EXP_STONE_TIP16);
						return;
					}
                    ExpRecorder.storeData();
					var data:ByteArray = new ByteArray();
					data.endian = Endian.LITTLE_ENDIAN;
					data.writeByte(storage);
					data.writeByte(slot);
					data.writeByte(multiple);
					
					ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_USE_EXPYU,data);
				}
			}
		}
	}
}