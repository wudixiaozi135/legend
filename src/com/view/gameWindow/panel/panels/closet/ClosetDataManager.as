package com.view.gameWindow.panel.panels.closet
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ClosetCfgData;
    import com.model.consts.ConstStorage;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    public class ClosetDataManager extends DataManagerBase
	{
		public static const TYPE_UPDATE_MODE:int = -999;
		private static var _instance:ClosetDataManager;
		public static function get instance():ClosetDataManager
		{
			if(!_instance)
			{
				_instance = new ClosetDataManager(new PrivateClass());
			}
			return _instance;
		}
		public static function clearInstance():void
		{
			_instance = null;
		}
		/**ClosetData字典*/
		public var closetDatas:Dictionary;
		public var current:int;
		public var selectCellId:int = -1;

        private const types:Vector.<int> = new <int>[ConstEquipCell.TYPE_SHIZHUANG, ConstEquipCell.TYPE_DOULI, ConstEquipCell.TYPE_ZUJI, ConstEquipCell.TYPE_HUANWU];

		public function ClosetDataManager(pc:PrivateClass)
		{
			super();
			if (!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHEST_INFO, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CHEST_UPGRADE, this);
			initClosetDatas();
		}
		
		private function initClosetDatas():void
		{
			closetDatas = new Dictionary;
			var i:int,l:int = types.length;
			for (i=0;i<l;i++) 
			{
				var closetData:ClosetData = new ClosetData();
				closetData.type = types[i];
				closetDatas[closetData.type] = closetData;
			}
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_CHEST_INFO:
					readData(data);
					break;
				case GameServiceConstants.CM_CHEST_UPGRADE:
					cmChestUpgradeDeal(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		public function request(type:int = 0,cellId:int = -1):void
		{
			current = type != 0 ? type : ConstEquipCell.TYPE_HUANWU;
			selectCellId = selectCellId != -1 ? selectCellId : cellId;
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(1);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_CHEST_INFO,byteArray);
		}
		
		public function requestHero(storage:int,slot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(storage);
			byteArray.writeByte(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HERO_CHEST_INTO,byteArray);
		}
		
		
		/**
		 * 发送CM_CHEST_UPGRADE协议
		 * @param type 1：元宝,2：道具
		 */		
		public function closetUpgrade(type:int,bagCellSolt:int = 0):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			byteArray.writeByte(currentClosetData().type);
			if(type == 2)
			{
				byteArray.writeByte(ConstStorage.ST_CHR_BAG);
				byteArray.writeByte(bagCellSolt);
			}
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHEST_UPGRADE,byteArray);
		}
		/**
		 * 发送CM_CHEST_PUTON协议
		 * @param select 选中的时装
		 */		
		public function closetPutOn(select:int):void
		{
			if(currentClosetData().fashionIds.length > select)
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeByte(currentClosetData().type);
				if(select == -1)//脱下时装
				{
					byteArray.writeInt(0);
				}
				else
				{
					var id:int = currentClosetData().fashionIds[select];
					byteArray.writeInt(id);
				}
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHEST_PUTON,byteArray);
			}
		}
		
		public function currentClosetData():ClosetData
		{
			return closetDatas[current];
		}
		
		/**当前衣橱华丽度是否已满*/
		public function isGorgeousFull():Boolean
		{
			var closetDt:ClosetData = currentClosetData();
			var nextClosetCfgDt:ClosetCfgData = ConfigDataManager.instance.closetCfgData(closetDt.type, closetDt.level + 1);
			if (nextClosetCfgDt)
			{
				return false;
			}
			else
			{
				var closetCfgDt:ClosetCfgData = ConfigDataManager.instance.closetCfgData(closetDt.type, closetDt.level);
				if (closetDt.gorgeousLevel >= closetCfgDt.stylish)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		public function get isClosetUnlock():Boolean
		{
			var l0:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.ROLE_CLOSET);
			var l1:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.ROLE_CLOSET_0);
			var l2:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.ROLE_CLOSET_1);
//			var l3:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.ROLE_CLOSET_2);
			var l4:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.ROLE_CLOSET_3);
			var l5:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.ROLE_CLOSET_4);
			
			return l0 &&( l1 || l2 /*|| l3*/ || l4 || l5);
		}
		
		/**当前衣橱是否已放满*/
		public function isClosetFull():Boolean
		{
			var closetDt:ClosetData = currentClosetData();
			var closetCfgDt:ClosetCfgData = ConfigDataManager.instance.closetCfgData(closetDt.type, closetDt.level);
			if (closetDt.fashionIds.length >= closetCfgDt.max_count)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function cmChestUpgradeDeal(data:ByteArray):void
		{
			var isNew:int = data.readInt();
			var isGorgeous:Boolean = isGorgeousFull();
			var str:String = isNew ? StringConst.CLOSET_PANEL_0026 : "";
			str += isNew && !isGorgeous ? StringConst.CLOSET_PANEL_0027 : "";
			str += !isGorgeous ? StringConst.CLOSET_PANEL_0020 : "";
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, str);
		}
		
		private function readData(data:ByteArray):void
		{
			var size:int = data.readByte();
			while (size--)
			{
				var type:int = data.readByte();
				var closetData:ClosetData = closetDatas[type];
				closetData.level = data.readByte();
				closetData.gorgeousLevel = data.readInt();
				closetData.fashionId = data.readInt();
				closetData.fashionIds.length = 0;
				var num:int = data.readByte();
				while (num--)
				{
					var fashionId:int = data.readInt();
					closetData.fashionIds.push(fashionId);
				}
				closetData.fashionIds.sort(closetData.sortOn);
				closetDatas[closetData.type] = closetData;
			}
		}
		
		public function updateMode():void
		{
			notify(TYPE_UPDATE_MODE);
		}

		public function setDefaultIndex(tabIndex:int = -1):void
		{
			var index:int = -1;
            var arr:Array = [ConstEquipCell.TYPE_SHIZHUANG, ConstEquipCell.TYPE_DOULI, ConstEquipCell.TYPE_ZUJI, ConstEquipCell.TYPE_HUANWU];

			var firstIndex:int = -1;
			var type:int;
			var num:int = 0;
			for(var i:int = 0; i < arr.length; ++i)
			{
				type = arr[i];
				
				var unlockId:int = getUnlockId(type);
				
				if(unlockId)
				{
					var isUnlock:Boolean = GuideSystem.instance.isUnlock(unlockId);
					
					if(isUnlock)
					{
						if(firstIndex == -1)
						{
							firstIndex = type;
						}
						
						if(num == tabIndex)
						{
							index = type;
							break;
						}
						
						++num;
					}
				}
			}
			
			if(index == -1)
			{
				index = firstIndex;
			}
			
			if(index != -1)
			{
				ClosetDataManager.instance.current = index;
				ClosetDataManager.instance.request(current);
			}
		}
		
		private function getUnlockId(type:int):int
		{
			switch(type)
			{
				case ConstEquipCell.TYPE_HUANWU:
					return UnlockFuncId.ROLE_CLOSET_0;
					break;
				case ConstEquipCell.TYPE_SHIZHUANG:
					return UnlockFuncId.ROLE_CLOSET_1;
					break;
				case ConstEquipCell.TYPE_CHIBANG:
					return UnlockFuncId.ROLE_CLOSET_2;
					break;
				case ConstEquipCell.TYPE_DOULI:
					return UnlockFuncId.ROLE_CLOSET_3;
					break;
				case ConstEquipCell.TYPE_ZUJI:
					return UnlockFuncId.ROLE_CLOSET_4;
					break;
			}
			
			return 0;
		}
	}
}
class PrivateClass{}