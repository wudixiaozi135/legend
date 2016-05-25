package com.view.gameWindow.panel.panels.forge.degree
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipDegreeCfgData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	
	/**
	 * 进阶过滤工具
	 * @author 丁强强
	 */	
	public class DegreeFilterUtil
	{
		public function DegreeFilterUtil()
		{
			
		}
		/**
		 * 过滤人物装备符合进阶条件的装备
		 * @return 
		 */		
		public static function getSatisfyDegreeRoleEquips():Vector.<EquipData>
		{
			var roleLv:int = RoleDataManager.instance.lv;
			var degreeDatas:Vector.<EquipData> = new Vector.<EquipData>();
			var datas:Vector.<EquipData> = RoleDataManager.instance.getDegreeEquipDatas();
			
			for each(var element:EquipData in datas)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(element.bornSid, element.id);
				if (!memEquipData) continue;
				
				var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
				var equipCfgData0:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.id);
				var equipCfgData1:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.next_id);
				if (!equipCfgData0 || !equipCfgData1)
				{
					continue;
				}
				var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(equipCfgData1.reincarn, equipCfgData1.level);
				if (!checkReincarnLevel) continue;
				
				if (equipCfgData1.level > roleLv)
					continue;
				
				degreeDatas.push(element);
			}
			return degreeDatas;
		}
		/**
		 * 过滤英雄装备符合进阶条件的装备
		 * @return 
		 */		
		public static function getSatisfyDegreeHeroEquips():Vector.<EquipData>
		{
			var roleLv:int = HeroDataManager.instance.lv;
			var degreeDatas:Vector.<EquipData> = new Vector.<EquipData>();
			var datas:Vector.<EquipData> = HeroDataManager.instance.getDegreeEquipDatas();
			
			for each(var element:EquipData in datas)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(element.bornSid, element.id);
				if (!memEquipData) continue;
				
				var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
				var equipCfgData0:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.id);
				var equipCfgData1:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.next_id);
				if (!equipCfgData0 || !equipCfgData1)
				{
					continue;
				}
				var checkReincarnLevel:Boolean = HeroDataManager.instance.checkReincarnLevel(equipCfgData1.reincarn, equipCfgData1.level);
				if (!checkReincarnLevel) continue;
				
				if (equipCfgData1.level > roleLv)
					continue;
				
				degreeDatas.push(element);
			}
			return degreeDatas;
		}
		/**
		 * 过滤背包装备符合进阶条件的装备
		 * @return 
		 */		
		public static function getSatisfyDegreeBagEquips():Vector.<BagData>
		{
			var roleLv:int = RoleDataManager.instance.lv;
			var degreeDatas:Vector.<BagData> = new Vector.<BagData>();
			var datas:Vector.<BagData> = BagDataManager.instance.getDegreeEquipDatas();
			
			for each(var element:BagData in datas)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(element.bornSid, element.id);
				if (!memEquipData) continue;
				
				var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
				var equipCfgData0:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.id);
				var equipCfgData1:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.next_id);
				if (!equipCfgData0 || !equipCfgData1)
				{
					continue;
				}
				var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(equipCfgData1.reincarn, equipCfgData1.level);
				if (!checkReincarnLevel) continue;
				
				if (equipCfgData1.level > roleLv)
					continue;
				
				degreeDatas.push(element);
			}
			return degreeDatas;
		}
	}
}
