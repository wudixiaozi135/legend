package com.model.gameWindow.mem
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.propertyParse.PropertyData;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    public class MemEquipDataManager extends DataManagerBase
	{
		private static var _instance:MemEquipDataManager;
		private static function hideFun():void{}
		public static function get instance():MemEquipDataManager
		{
			if(!_instance)
				_instance = new MemEquipDataManager(hideFun);
			return _instance;
		}
		
		private var dic:Dictionary;
		
		public function MemEquipDataManager(fun:Function)
		{
			super();
			if(fun != hideFun)
				throw new Error("该类使用单例模式");
			DistributionManager.getInstance().register(GameServiceConstants.SM_MEM_UNIQUE_EQUIP_INFO,this);
			
			dic = new Dictionary();
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_MEM_UNIQUE_EQUIP_INFO:
					readData(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function readData(data:ByteArray):void
		{
			var job:int = RoleDataManager.instance.job;
			var size:int = data.readShort();
			while(size-- > 0)
			{
				var onlyId:int = data.readInt();
				var bornSid:int = data.readInt();
				if (!dic[bornSid])
				{
					dic[bornSid] = new Dictionary();
				}
				var memEquipData:MemEquipData = dic[bornSid][onlyId];
				if(!memEquipData)
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
                memEquipData.blessValue = data.readInt();//翅膀祝福值
				var attrRds:Vector.<AttrRandomData> = new Vector.<AttrRandomData>();
				var attrRdCount:int = data.readInt();
				memEquipData.attrRdCount = attrRdCount;
				memEquipData.attrRdStars = 0;
				var attrRdMaxStar:int;
				var attrRdMinStar:int=999;
				while(attrRdCount--)
				{
					var index:int = data.readByte();//洗炼属性的属性下标，为1字节有符号整形
					var star:int = data.readByte();//洗炼星级，为1字节有符号整形
					var type:int = data.readByte();//属性加成为1.值加成 2.百分比，为1字节有符号整形
					var addon_rate:int = data.readInt();//属性加成数，为4字节有符号整形
					if(index)
					{
						var attrRdDt:AttrRandomData = new AttrRandomData();
						attrRds.push(attrRdDt);
						attrRdDt.star = star;
						var attrDt:PropertyData = CfgDataParse.getPropertyDatas(index+":"+type+":"+addon_rate,false,null,job)[0];
						attrRdDt.attrDt = attrDt;
						memEquipData.attrRdStars += star;
						attrRdMaxStar < star ? attrRdMaxStar = star : null;
						if(star<attrRdMinStar)
						{
							attrRdMinStar=star;
						}
					}
					else
					{
						attrRdMinStar=0;
						attrRds.push(null);
					}
				}
				if(attrRdMinStar==999)attrRdMinStar=0;
				memEquipData.attrRdMaxStar = attrRdMaxStar;
				memEquipData.attrRdMinStar=attrRdMinStar;
				memEquipData.setAttrRds(attrRds);
			}
		}
		
		/**
		 * 获取已装备的同类数据 
		 * @param type
		 * @return 
		 */		
		public function equipedMemEquipDataByType(type:int,isHeroEquip:Boolean = false):MemEquipData
		{
			var equipDatas:Vector.<EquipData>;
			if(!isHeroEquip)
			{
				equipDatas = RoleDataManager.instance.equipDatas;
			}
			else
			{
				equipDatas = HeroDataManager.instance.equipDatas;
			}
			
			for each(var equipData:EquipData in equipDatas)
			{
				if(equipData.id == 0)
				{
					continue;
				}
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid, equipData.id);
				if(!memEquipData)
				{
					continue;
				}
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if(!equipCfgData)
				{
					continue;
				}
				if(equipCfgData && equipCfgData.type == type)
				{
					return memEquipData;
				}
			}
			return null;
		}
		
		public function memEquipData(bornSid:int, onlyId:int):MemEquipData
		{
			if (!dic[bornSid])
			{
				return null;
			}
			return dic[bornSid][onlyId];
		}
	}
}