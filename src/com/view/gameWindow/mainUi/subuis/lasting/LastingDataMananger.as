package com.view.gameWindow.mainUi.subuis.lasting
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;
	
	public class LastingDataMananger extends DataManagerBase
	{
		public function LastingDataMananger()
		{
			super();
		}
		
		private static var _instance:LastingDataMananger;
		private var _repairCoinCount:int;
		public var isRepair:Boolean;
		public var lasting:Boolean;
		public var roleLasting:Boolean;
		public var heroLasting:Boolean;
		
		public static function getInstance():LastingDataMananger
		{
			if(_instance==null)
			{
				_instance=new LastingDataMananger();		
			}
			return _instance;
		}
		
		public function oneKeyRepair():void
		{
			_repairCoinCount=0;
			checkRoleEquip();
			checkHeroEquip();
			if(checkRepairCount()==false)return;
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.LASTING_STRING_0005,_repairCoinCount));
			sendOneKeyRepairRequest();
		}
		
		public function repairEquip(equip:EquipCell):void
		{
			_repairCoinCount=0;
			var equipMem:MemEquipData=MemEquipDataManager.instance.memEquipData(equip.bornSid,equip.onlyId);
			var equipCfg:EquipCfgData=ConfigDataManager.instance.equipCfgData(equipMem.baseId);
			if(equipMem.duralibility<equipCfg.durability)
			{
				_repairCoinCount+=(equipCfg.durability/100-equipMem.duralibility)*250;
			}
			
			if(checkRepairCount()==false)return;
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.LASTING_STRING_0005,_repairCoinCount));
			sendRepairRequst(equip.storageType,equip.slot);
		}
		
		public function repairBagEquip(bagcell:BagCell):void
		{
			_repairCoinCount=0;
			var equipMem:MemEquipData=MemEquipDataManager.instance.memEquipData(bagcell.bornSid,bagcell.id);
			var equipCfg:EquipCfgData=ConfigDataManager.instance.equipCfgData(equipMem.baseId);
			if(equipMem.duralibility<equipCfg.durability)
			{
				_repairCoinCount+=(equipCfg.durability/100-equipMem.duralibility)*250;
			}
			
			if(checkRepairCount()==false)return;
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringUtil.substitute(StringConst.LASTING_STRING_0005,_repairCoinCount));
			sendRepairRequst(bagcell.storageType,bagcell.bagData.slot);
		}
			
		
		private function checkRepairCount():Boolean
		{
			if(_repairCoinCount<=0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.LASTING_STRING_0003);
				return false;
			}
			if(_repairCoinCount>BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.LASTING_STRING_0004);
				return false;
			}
			return true;
		}
		
		private function checkRoleEquip():void
		{
			var  equipDatas:Vector.<EquipData>=RoleDataManager.instance.equipDatas;
			for each(var equip:EquipData in equipDatas)
			{
				if(equip.id==0)continue;
				var equipMem:MemEquipData=MemEquipDataManager.instance.memEquipData(equip.bornSid,equip.id);
				var equipCfg:EquipCfgData=ConfigDataManager.instance.equipCfgData(equipMem.baseId);
				if(equipMem.duralibility<equipCfg.durability)
				{
					_repairCoinCount+=(equipCfg.durability/100-equipMem.duralibility)*250;
				}
			}
		}
		
		private function checkHeroEquip():void
		{
			var  equipDatas:Vector.<EquipData>=HeroDataManager.instance.equipDatas;
			for each(var equip:EquipData in equipDatas)
			{
				if(equip.id==0)continue;
				var equipMem:MemEquipData=MemEquipDataManager.instance.memEquipData(equip.bornSid,equip.id);
				if(equipMem==null)continue;
				var equipCfg:EquipCfgData=ConfigDataManager.instance.equipCfgData(equipMem.baseId);
				if(equipMem.duralibility<equipCfg.durability)
				{
					_repairCoinCount+=(equipCfg.durability/100-equipMem.duralibility)*250;
				}
			}
		}
		
		private function sendOneKeyRepairRequest():void
		{
			var byte:ByteArray=new ByteArray();
			byte.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_REPAIR_ALL,byte);
		}
		
		private function sendRepairRequst(storage:int,slot:int):void
		{
			var byte:ByteArray=new ByteArray();
			byte.endian=Endian.LITTLE_ENDIAN;
			byte.writeByte(storage);
			byte.writeByte(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_REPAIR,byte);
		}
	}
}