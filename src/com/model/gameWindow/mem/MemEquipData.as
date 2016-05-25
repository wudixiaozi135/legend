package com.model.gameWindow.mem
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.EquipPolishAttrCfgData;
    import com.model.configData.cfgdata.EquipPolishCfgData;
    import com.model.configData.cfgdata.EquipRefinedCfgData;
    import com.model.configData.cfgdata.EquipRefinedCostCfgData;
    import com.model.configData.cfgdata.EquipStrengthenAttrCfgData;
    import com.model.configData.cfgdata.EquipStrengthenCfgData;
    import com.model.consts.ConstStarsFlag;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.propertyParse.PropertyData;

    public class MemEquipData
	{
		/**单服唯一识别ID*/
		public var onlyId:int;
		/**服务器ID*/
		public var bornSid:int;
		/**配置信息ID*/
		public var baseId:int;
		/**耐久度*/
		public var duralibility:int;
		/**强化等级*/
		public var strengthen:int;
		/**打磨等级*/
		public var polish:int;
		/**打磨等级进度*/
		public var polishExp:int;
		/**绑定状态*/
		public var bind:int;
		/**是否是英雄装备数据*/
		public var isHero:Boolean;
		
		public var goodLuck:int;
		/**随机属性总数*/
		public var attrRdCount:int;
		/**随机属性池*/
		private var attrList:Vector.<AttrRandomData>;
		/**随机属性总星级*/
		public var attrRdStars:int;
		/**随机属性最大星级*/
		public var attrRdMaxStar:int;
		
		/**随机属性最小星*/
		public var attrRdMinStar:int;
		
		/** 总战斗力**/
		public var totalFightPower:int;
		private var isGetFightPower:Boolean =false;
		private var _basePropertyList:Vector.<PropertyData>;
        /**翅膀祝福值*/
        public var blessValue:int;
		public function MemEquipData()
		{
		}
		
		public function get equipCfgData():EquipCfgData
		{
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(baseId);
			return equipCfgData;
		}
		
		public function get equipStrengthenCfgData():EquipStrengthenCfgData
		{
			var equipStrengthenCfgData:EquipStrengthenCfgData = ConfigDataManager.instance.equipStrengthen(strengthen);
			return equipStrengthenCfgData;
		}
		
		public function get equipPolishCfgData():EquipPolishCfgData
		{
			var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(polish);
			return equipPolishCfgData;
		}
		
		public function get equipRefinedCfgData():EquipRefinedCfgData
		{
			var equipRefinedCfgData:EquipRefinedCfgData = null;
			if(equipCfgData)
			{
				equipRefinedCfgData = ConfigDataManager.instance.equipRefinedCfgData(equipCfgData.quality,equipCfgData.level);
			}
			return equipRefinedCfgData;
		}
		
		public function get equipRefinedCostCfgData():EquipRefinedCostCfgData
		{
			var equipRefinedCostCfgData:EquipRefinedCostCfgData = null;
			if(equipCfgData)
			{
				equipRefinedCostCfgData = ConfigDataManager.instance.equipRefinedCostCfgData(equipCfgData.level);
			}
			return equipRefinedCostCfgData;
		}
		
		public function setAttrRds(dts:Vector.<AttrRandomData>):void 
		{
			attrList = dts;
		}
		
		public function attrRdDt(index:int):AttrRandomData
		{
			return index < attrList.length ? attrList[index] : null;
		}
		
		public function copy(memEquipData:MemEquipData):void
		{
			onlyId = memEquipData.onlyId;
			bornSid = memEquipData.bornSid;
			baseId = memEquipData.baseId;
			duralibility = memEquipData.duralibility;
			strengthen = memEquipData.strengthen;
			polish = memEquipData.polish;
			polishExp = memEquipData.polishExp;
			goodLuck = memEquipData.goodLuck;
			bind = memEquipData.bind;
			attrRdCount = memEquipData.attrRdCount;
			attrList = memEquipData.attrList;
		}
		
		public function nextStrengthen(memEquipData:MemEquipData,isPolish:Boolean = false):MemEquipData
		{
			var newMemEquipData:MemEquipData = new MemEquipData();
			newMemEquipData.onlyId = memEquipData.onlyId;
			newMemEquipData.bornSid = memEquipData.bornSid;
			newMemEquipData.baseId = memEquipData.baseId;
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			newMemEquipData.strengthen = memEquipData.strengthen + (!isPolish && memEquipData.strengthen < equipCfgData.strengthen ? 1 : 0);
			newMemEquipData.polish = memEquipData.polish + (isPolish && memEquipData.polish < 9 ? 1 : 0);
			newMemEquipData.polishExp = memEquipData.polishExp;
			newMemEquipData.goodLuck = memEquipData.goodLuck;
			newMemEquipData.bind = memEquipData.bind;
			newMemEquipData.attrRdCount = memEquipData.attrRdCount;
			newMemEquipData.attrList = memEquipData.attrList;
			return newMemEquipData;
		}
		/**
		 * 
		 * @return 以位数为长度的星级原件帧值数组
		 */		
		public function strengthenStars():Vector.<String>
		{
			var strengthen2:int = strengthen;
			var numSun:int = strengthen2 * .04;
			strengthen2 = strengthen2 % 25;
			var numMoon:int = strengthen2 * .2;
			var numStar:int = strengthen2 % 5;
			var vector:Vector.<String> = new Vector.<String>();
			while(numSun--)
			{
				vector.push(ConstStarsFlag.SUN_FRAME);
			}
			while(numMoon--)
			{
				vector.push(ConstStarsFlag.MOON_FRAME);
			}
			while(numStar--)
			{
				vector.push(ConstStarsFlag.STAR_FRAME);
			}
			return vector;
		}
		
		public function getTotalFightPower():int
		{
			totalFightPower = 0;
			var val:int,jobflag:Boolean;
			val = getbasicFightPower();
			totalFightPower += val;
			val = getStrengthPropertyFightPower();
			totalFightPower += val;
			val = getPolishPropertyFightPower();
			totalFightPower += val;
			val = getRdPropertyFightPower();
			totalFightPower += val;
			return totalFightPower;
		}
		/**
		 * 基础属性
		 * @return 
		 */		
		public function getbasicFightPower():int
		{
			_basePropertyList = CfgDataParse.getPropertyDatas(equipCfgData.attr,false,null,isHero?HeroDataManager.instance.job:RoleDataManager.instance.job);
			var dt:PropertyData;
			var fightPower:Number = 0;
			for each(dt in _basePropertyList)
			{
				fightPower += dt.fightPower; 
			}
			return fightPower;
		}
		/**
		 *  强化属性 
		 * @param equipCfgData
		 */		
		private function getStrengthPropertyFightPower():int
		{
			var strengthenAttr:EquipStrengthenAttrCfgData,val:int;
			if(strengthen <= 0)
			{
				return 0;
			}
			strengthenAttr = ConfigDataManager.instance.equipStrengthenAttr(equipCfgData.type,strengthen); 
			if(!strengthenAttr)
			{
				return 0;
			}
			var job:int =  isHero?HeroDataManager.instance.job:RoleDataManager.instance.job;
			var propertyDatas:Vector.<PropertyData> = CfgDataParse.getPropertyDatas(strengthenAttr.attr,false,null,job);
			var equipPolishAttrCfgData:EquipPolishAttrCfgData,value:Number,index:int;
			for each(var propertyData:PropertyData in propertyDatas)
			{
				index = indexOfProperty(propertyData.propertyId,_basePropertyList);
				if(index != -1)
				{
					equipPolishAttrCfgData = ConfigDataManager.instance.equipPolishAttrCfgData(equipCfgData.type,polish);
					value = propertyData.fightPower * (1 + (equipPolishAttrCfgData ? equipPolishAttrCfgData.attr_rate*.001 : 0));
					val += value;
				}
			}
			return val; 
		}
		/**
		 * 打磨属性 
		 * @param equipCfgData
		 */		
		private function getPolishPropertyFightPower():int
		{
			var equipPolishAttrCfgData:EquipPolishAttrCfgData = ConfigDataManager.instance.equipPolishAttrCfgData(equipCfgData.type,polish);
			if(!equipPolishAttrCfgData)
			{
				return 0;
			}
			
			var job:int =  isHero?HeroDataManager.instance.job:RoleDataManager.instance.job;
			var propertyDatas:Vector.<PropertyData> = CfgDataParse.getPropertyDatas(equipPolishAttrCfgData.attr,false,null,job);
			var val:int,index:int;
			for each(var propertyData:PropertyData in propertyDatas)
			{
				index = indexOfProperty(propertyData.propertyId,_basePropertyList);
				if(index != -1)
				{
					val += propertyData.fightPower;
				}
			}
			return val; 
		}
		/**
		 *  随机属性 
		 * @param memEquipData
		 */		
		private function getRdPropertyFightPower():int
		{
			var i:int,val:int;
			for (i=0;i<attrRdCount;i++) 
			{
				var attrRdDt1:AttrRandomData = attrRdDt(i);
				var attrDt:PropertyData = attrRdDt1 ? attrRdDt1.attrDt : null;
				if (attrRdDt1 && attrDt)
				{
					val += attrDt.fightPower;
				}
			}
			return val;	
		}
		
		private function indexOfProperty(propertyId:int,list:Vector.<PropertyData>):int
		{
			var index:int = -1;
			for each(var data:PropertyData in list)
			{
				++index;
				if(data && (propertyId == data.propertyId || (data.isMain && data.propertyId+1 == propertyId)))
				{
					return index;
				}
			}
			return -1;
		}
	}
}