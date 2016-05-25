package com.view.gameWindow.mainUi.subuis.lasting
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;

	/**
	 * 耐久处理类
	 * @author Administrator
	 */	
	public class LastingHandler
	{
		private static var _lastingArrRole:Array = [];
		private static var _lastingArrHero:Array = [];
		public function LastingHandler()
		{
		}
		
		public static function refreshData():int
		{
			_lastingArrRole.splice(0,_lastingArrRole.length);
			_lastingArrHero.splice(0,_lastingArrHero.length);
			checkRoleEquip();
			checkHeroEquip();
			LastingDataMananger.getInstance().lasting=_lastingArrRole.length>0||_lastingArrHero.length>0;
			return _lastingArrRole.length+_lastingArrHero.length;
		}
		
		private static function checkRoleEquip():void
		{
			LastingDataMananger.getInstance().roleLasting=false;
			var  equipDatas:Vector.<EquipData>=RoleDataManager.instance.equipDatas;
			for each(var equip:EquipData in equipDatas)
			{
				if(equip.id==0)
				{
					continue;
				}
				var equipMem:MemEquipData=MemEquipDataManager.instance.memEquipData(equip.bornSid,equip.id);
				if(!equipMem)
				{
					continue;
				}
				var equipCfg:EquipCfgData=ConfigDataManager.instance.equipCfgData(equipMem.baseId);
				if(!equipCfg)
				{
					continue;
				}
				if(equipMem.duralibility>1)
				{
					continue;
				}
				LastingDataMananger.getInstance().roleLasting=true;
				_lastingArrRole.push({name:equipCfg.name,num1:equipMem.duralibility,num2:equipCfg.durability,type:EntityTypes.ET_PLAYER});
			}
		}
		
		public static function checkEquipDuralibity():int
		{
			var count:int = getEquipDuralibility(HeroDataManager.instance.equipDatas);
			count+=getEquipDuralibility(RoleDataManager.instance.equipDatas);
			return count*250;
		}
		
		private static function getEquipDuralibility(equipDatas:Vector.<EquipData>):int
		{
			var count:int=0;
			for each(var equip:EquipData in equipDatas)
			{
				if(equip.id==0)
				{
					continue;
				}
				var equipMem:MemEquipData=MemEquipDataManager.instance.memEquipData(equip.bornSid,equip.id);
				if(!equipMem)
				{
					continue;
				}
				var equipCfg:EquipCfgData=ConfigDataManager.instance.equipCfgData(equipMem.baseId);
				if(!equipCfg)
				{
					continue;
				}
				count+=equipCfg.durability/100-equipMem.duralibility;
			}
			return count;
		}
		
		private static function checkHeroEquip():void
		{
			LastingDataMananger.getInstance().heroLasting=false;
			var  equipDatas:Vector.<EquipData>=HeroDataManager.instance.equipDatas;
			for each(var equip:EquipData in equipDatas)
			{
				if(equip.id==0)
				{
					continue;
				}
				var equipMem:MemEquipData=MemEquipDataManager.instance.memEquipData(equip.bornSid,equip.id);
				if(!equipMem)
				{
					continue;
				}
				var equipCfg:EquipCfgData=ConfigDataManager.instance.equipCfgData(equipMem.baseId);
				if(!equipCfg)
				{
					continue;
				}
				if(equipMem.duralibility>1)
				{
					continue;
				}
				LastingDataMananger.getInstance().heroLasting=true;
				_lastingArrHero.push({name:equipCfg.name,num1:equipMem.duralibility,num2:equipCfg.durability,type:EntityTypes.ET_HERO});
			}
		}

		public static function get lastingArrRole():Array
		{
			return _lastingArrRole;
		}
		
		public static function get lastingArrHero():Array
		{
			return _lastingArrHero;
		}

	}
}