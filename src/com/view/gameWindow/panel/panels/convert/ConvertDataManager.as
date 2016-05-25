package com.view.gameWindow.panel.panels.convert
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipExchangeCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.configData.constants.ConfigType;
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.util.cell.CellData;
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * @author wqhk
	 * 2014-8-27
	 */
	public class ConvertDataManager extends DataManagerBase implements IObserver
	{
		private static var _instance:ConvertDataManager;
		public static function get instance():ConvertDataManager
		{
			if(!_instance)
			{
				_instance = new ConvertDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		public var list0:Vector.<EquipExchangeCfgData>;//龙
		public var list1_0:Vector.<EquipExchangeCfgData>;//戒 
		public var list1_1:Vector.<EquipExchangeCfgData>;//戒 英雄
		public var list1:Vector.<EquipExchangeCfgData>;
		public var list2:Vector.<EquipExchangeCfgData>;//盾
		private var list0Index:Array = new Array();
		private var list2Index:Array = new Array();
		
		public var id0:CellData;
		public var id1:CellData;
		public var id2:CellData;
		public var id3:CellData;
		private static const MAX:int = 4;
		private static const MIN:int = 0;
		
		
		public function update(proc:int = 0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_BAG_ITEMS:
				case GameServiceConstants.SM_BAG_CHANGE:
					checkBag();
					notify(proc);
					break;
				case GameServiceConstants.SM_CHR_INFO:
					checkRole();
					notify(proc);
					break;
				case GameServiceConstants.SM_HERO_INFO:
					checkHero();
					notify(proc);
					break;
				case GameServiceConstants.CM_EQUIP_EXCHANGE:
					initCfg();
					notify(proc);
					break;
			}
		}
		
		private function clearCell(storageType:int):void
		{
			if(id0 && id0.storageType == storageType)
			{
				id0 = null;
			}
			
			if(id1 && id1.storageType == storageType)
			{
				id1 = null;
			}
			
			if(id2 && id2.storageType == storageType)
			{
				id2 = null;
			}
			
			if(id3 && id3.storageType == storageType)
			{
				id3 = null;
			}
		}
		
		public function indexOfData(id:int,list:Vector.<EquipExchangeCfgData>):int
		{
			var index:int = -1;
			for each(var item:EquipExchangeCfgData in list)
			{
				++index;
				if(item.id == id)
				{
					return index;
				}
			}
			
			return -1;
		}
		
		public function dataToEquipCfg(data:EquipExchangeCfgData):EquipCfgData
		{
			var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(data.id);
			return equip;
		}
		
		public function requestConvert(type:int,slot:int):void
		{
			var data:ByteArray = new ByteArray();
			data.writeByte(type);
			data.writeByte(slot);
			
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_EXCHANGE,data);
		}
		
		public function isOwn(id:int):Boolean
		{
			var exCfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeNextCfgData(id);
			
			if(!exCfg)
			{
				return false;
			}
			
			var cellData:CellData = getCell(exCfg);
			
			if(!cellData)
			{
				return false;
			}
			
			var list:Vector.<EquipExchangeCfgData> = getListByData(exCfg);
			
			var mem:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData.bornSid,cellData.id);
			var curEquip:EquipCfgData = ConfigDataManager.instance.equipCfgData(mem.baseId);
			
			var curOwnIndex:int = indexOfData(curEquip.id,list);
			var index:int = indexOfData(id,list);
			
			if(index <= curOwnIndex+1)
			{
				return true;
			}  
			
			return false;
		}
		
		public function canConvert(id:int,type:int):Boolean
		{
			var exCfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
			var curCfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(RoleDataManager.instance.getFireHeartId(type));
			if(!exCfg||!curCfg)
			{
				return false;
			}
			if(exCfg.id!=curCfg.next_id)
				return false;
			if(RoleDataManager.instance.reincarn<curCfg.player_reincarn||
				RoleDataManager.instance.reincarn==curCfg.player_reincarn && RoleDataManager.instance.lv<curCfg.player_level)
			{
				return false;
			}
			
			if(BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind < curCfg.coin)
			{
				return false;
			}
			
			if(RoleDataManager.instance.reputation<curCfg.zhuangyuanshengwang)
			{
				return false;
			}
			
			if(RoleDataManager.instance.shendunzhili<curCfg.shendunzhili)
			{
				return false;
			}
			
			if(RoleDataManager.instance.getFireHeartId(type)!=curCfg.id)
				return false;
			
			if(curCfg.item!=0){
				var num:int = BagDataManager.instance.getItemNumById(curCfg.item)
				if(num < curCfg.item_count)
				{
					return false;
				}
			}
			
			if(HeroDataManager.instance.lv < curCfg.hero_grade)
			{
				return false;
			}
			
			if(HeroDataManager.instance.love < curCfg.hero_love)
			{
				return false;
			}
			
			return true;
		}
		
		public function canConvertNew(id:int,type:int):Boolean
		{
			var exCfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
			
			if(!exCfg)
			{
				return false;
			}
			if(exCfg.id == exCfg.next_id)
				return false;
			
			if(RoleDataManager.instance.reincarn<exCfg.player_reincarn||
				RoleDataManager.instance.reincarn==exCfg.player_reincarn && RoleDataManager.instance.lv<exCfg.player_level)
			{
				return false;
			}
			
			if(BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind < exCfg.coin)
			{
				return false;
			}
			
			if(RoleDataManager.instance.reputation<exCfg.zhuangyuanshengwang)
			{
				return false;
			}
			
			if(RoleDataManager.instance.shendunzhili<exCfg.shendunzhili)
			{
				return false;
			}
			
			if(RoleDataManager.instance.getFireHeartId(type)!=exCfg.id)
				return false;
			
			if(exCfg.item!=0){
				var num:int = BagDataManager.instance.getItemNumById(exCfg.item)
				if(num < exCfg.item_count)
				{
					return false;
				}
			}
			
			if(HeroDataManager.instance.lv < exCfg.hero_grade)
			{
				return false;
			}
			
			if(HeroDataManager.instance.love < exCfg.hero_love)
			{
				return false;
			}
			
			return true;
			
		}
		
		public function getListByData(data:EquipExchangeCfgData):Vector.<EquipExchangeCfgData>
		{
			var equip:EquipCfgData = dataToEquipCfg(data);
			
			if(equip.type == ConstEquipCell.TYPE_HUANJIE)
			{
				return list1;
			}
			else if(equip.type == ConstEquipCell.TYPE_DUNPAI)
			{
				return list2;
			}
			else if(equip.type == ConstEquipCell.TYPE_HUOLONGZHIXIN)
			{
				return list0;
			}
			
			return null;
		}
		
		public function getCell(data:EquipExchangeCfgData):CellData
		{
			var equip:EquipCfgData = dataToEquipCfg(data);
			
			if(equip.type == ConstEquipCell.TYPE_HUANJIE)
			{
				if(equip.entity == EntityTypes.ET_PLAYER)
				{
					return id1;
				}
				else if(equip.entity == EntityTypes.ET_HERO)
				{
					return id2;
				}
			}
			else if(equip.type == ConstEquipCell.TYPE_DUNPAI)
			{
				return id3;
			}
			else if(equip.type == ConstEquipCell.TYPE_HUOLONGZHIXIN)
			{
				return id0;
			}
			
			return null;
		}
		
		
		public function getNextData(equipExc:EquipExchangeCfgData,type:int):EquipExchangeCfgData
		{
			var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipExc.id);
			var curId:int = RoleDataManager.instance.getFireHeartId(type);
			var preEquipExc:EquipExchangeCfgData = null;
			var preEquip:EquipCfgData;
//			if(equipExc.step<10)
//			{
//				nextEquipExc = ConfigDataManager.instance.equipExchangeCfgData(equipExc.next_id);
//				preEquip = ConfigDataManager.instance.equipCfgData(nextEquipExc.id);
//				if(equip.entity != preEquip.entity)
//				{
//					nextEquipExc = null;
//				}
//			}
//			else
//			{
//				if(equipExc.next_id == equipExc.id)
//					preEquipExc = null;
//				else
//				{
					preEquipExc = ConfigDataManager.instance.equipExchangeCfgData(curId);
					if(preEquipExc){
						preEquip = ConfigDataManager.instance.equipCfgData(preEquipExc.id);
						if(equip.entity == EntityTypes.ET_PLAYER){
							if(equip.entity != preEquip.entity)
							{
								preEquipExc = null;
							}else{
								if(equipExc.id != preEquipExc.next_id||equipExc.id == preEquipExc.id)
									preEquipExc = null;
							}
						}else if(equip.entity == EntityTypes.ET_HERO)
						{
							curId = HeroDataManager.instance.getRings();
							preEquipExc = ConfigDataManager.instance.equipExchangeCfgData(curId);
							if(preEquipExc)
							{
								if(equipExc.id != preEquipExc.next_id||equipExc.id == preEquipExc.id)
									preEquipExc = null;
							}
						}
					}
//				}
//			}
			
			return preEquipExc;
		}
		
		public function isTypeGet(id:int):Boolean
		{
			var cfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
			
			var cell:CellData = getCell(cfg);
			
			return cell != null;
		}
		
		public function getNpcShopCfgData(id:int):NpcShopCfgData
		{
			var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
			
			if(equip)
			{
				
				var dict:Dictionary = ConfigDataManager.instance.npcShopCfgDatas(2);
				for each(var data:NpcShopCfgData in dict)
				{
					if(data.base == equip.id)
					{
						return data;
					}
				}
			}
			
			return null;
		}
		
		public function getIconUrl(cfg:EquipExchangeCfgData):String
		{
			var index:int;
			var mid:String = "";
			var type:int = ConfigDataManager.instance.equipCfgData(cfg.id).type;
			if(cfg.step>0&&type == ConstEquipCell.TYPE_HUOLONGZHIXIN){
				mid = "convert_dragon_"+(cfg.step-1);
				return "convert/" + mid + ResourcePathConstants.POSTFIX_SWF;	
			}
			else if(cfg.step>0&&type == ConstEquipCell.TYPE_DUNPAI){
				mid = "convert_dp_"+(cfg.step-1);
				return "convert/" + mid + ResourcePathConstants.POSTFIX_SWF;	
			}
			var id:int = cfg.id;
			index = indexOfData(id,list1_0);
			if(index != -1)
			{
				mid = "convert_ring_"+index;
				return "convert/" + mid + ResourcePathConstants.POSTFIX_SWF;
			}
			
			index = indexOfData(id,list1_1);
			if(index != -1)
			{
				mid = "convert_ring_"+(index+5);
				return "convert/" + mid + ResourcePathConstants.POSTFIX_SWF;
			}
			
			index = indexOfData(id,list2);
			if(index != -1)
			{
				mid = "convert_dp_"+index;
				return "convert/" + mid + ResourcePathConstants.POSTFIX_SWF;
			}
			
			return ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+mid+ResourcePathConstants.POSTFIX_PNG;
		}
		
		public function getIconSize(id:int):Rectangle
		{
			var index:int;
			
			index = indexOfData(id,list0);
			if(index != -1)
			{
				return new Rectangle(0,0,202,183);
			}
			
			index = indexOfData(id,list1_0);
			if(index != -1)
			{
				return new Rectangle(0,0,100,112);
			}
			
			index = indexOfData(id,list1_1);
			if(index != -1)
			{
				return new Rectangle(0,0,100,112);
			}
			
			index = indexOfData(id,list2);
			if(index != -1)
			{
				return new Rectangle(0,0,195,232);
			}
			
			return new Rectangle(0,0,100,112);
		}
		
		public function getStartItemInfo(index:int):ConvertStartData
		{
			var cells:Array = [id1,id2,id3,id0];
			
			var cfgListList:Array = [list1_0,list1_1,list2,list0];
			
			var cellData:CellData = cells[index];
			var cfgList:Vector.<EquipExchangeCfgData> = cfgListList[index];
			
			if(!cfgList)
				return null;
			
			var item:ConvertStartData = new ConvertStartData();
			
			if(cfgList.length>0)
			{
				var equipEx:EquipExchangeCfgData = cfgList[0];
				
				var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipEx.id);
				
				item.id = equip.id;
				item.name = equip.name;
				item.url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equip.icon+ResourcePathConstants.POSTFIX_PNG;
				if(cellData)
				{
					item.isGet = true;
					item.stateDes = StringConst.CONVERT_016;
					
					var mem:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData.bornSid,cellData.id);
					var curEquip:EquipCfgData = ConfigDataManager.instance.equipCfgData(mem.baseId);
					item.curId = curEquip.id;
				}
				else
				{
					item.isGet = false;
					item.stateDes = StringConst.CONVERT_017;
					item.curId = 0;
				}
			}
			
			return item;
		}
		
		private function checkBag():void
		{
			clearCell(ConstStorage.ST_CHR_BAG);
			for each(var cell:BagData in BagDataManager.instance.bagCellDatas)
			{
				if(cell && cell.type == SlotType.IT_EQUIP)
				{
					checkIds(cell);
				}
			}
		}
		
		private function checkRole():void
		{
			clearCell(ConstStorage.ST_CHR_EQUIP);
			for each(var equip:EquipData in RoleDataManager.instance.equipDatas)
			{
				checkIds(equip);
			}
		}
		
		private function checkHero():void
		{
			clearCell(ConstStorage.ST_HERO_EQUIP);
			for each(var equip:EquipData in HeroDataManager.instance.equipDatas)
			{
				checkIds(equip);
			}
			
			clearCell(ConstStorage.ST_HERO_BAG);
			for each(var cell:BagData in HeroDataManager.instance.bagCellDatas)
			{
				if(cell && cell.type == SlotType.IT_EQUIP)
				{
					checkIds(cell);
				}
			}
		}
		
		private function checkIds(item:CellData):void
		{
			if(!item || !item.id)
			{
				return;
			}
			
			var mem:MemEquipData = MemEquipDataManager.instance.memEquipData(item.bornSid,item.id);
			
			if(!mem)
			{
				return;
			}
			
			var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(mem.baseId);
			if(!equip)
			{
				return;
			}
			if(equip.type == ConstEquipCell.TYPE_HUANJIE)
			{
				if(equip.entity == EntityTypes.ET_PLAYER)
				{
					id1 = item;
				}
				else if(equip.entity == EntityTypes.ET_HERO)
				{
					id2 = item;
				}
			}
			else if(equip.type == ConstEquipCell.TYPE_DUNPAI)
			{
				id3 = item;
			}
			else if(equip.type == ConstEquipCell.TYPE_HUOLONGZHIXIN)
			{
				id0 = item;
			}
		}
		
		/**
		 * ConvertListPanel 中的数据
		 */
		public function initCfg():void
		{
			list0 = new Vector.<EquipExchangeCfgData>;
			list1_0 = new Vector.<EquipExchangeCfgData>;
			list1_1 = new Vector.<EquipExchangeCfgData>;
			list2 = new Vector.<EquipExchangeCfgData>;
			
			ConfigDataManager.instance.forEach([ConfigType.keyEquipExchange],initEquipExchangeData);
			
			list0 = sortList0(list0);
			list1_0 = sortList(list1_0);
			list1_1 = sortList(list1_1);
			list2 = sortList0(list2);
			
			list1 = list1_0.concat(list1_1);
		}
		
		public function getListByIndex(index:int):Vector.<EquipExchangeCfgData>
		{
			switch(index)
			{
				case 0:
					return getCur(list0);
				case 2:
					return list1;
				case 1:
					return list2;
			}
			
			return null;
		}
		
		private function getCur(list:Vector.<EquipExchangeCfgData>):Vector.<EquipExchangeCfgData>
		{
			// TODO Auto Generated method stub
			var id:int = RoleDataManager.instance.getFireHeartId();
			var cfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
			var count:int = 6;
			if(cfg)
			{
				if(cfg.step>=5&&cfg.step<7)
					count = 8;
				else if(cfg.step>=7)
					count = 10
			}
			return list.slice(0,count);
		}
		
		private function sortList(list:Vector.<EquipExchangeCfgData>):Vector.<EquipExchangeCfgData>
		{
			var re:Vector.<EquipExchangeCfgData> = new Vector.<EquipExchangeCfgData>();
			
			var num:int = 0;
			var remain:Vector.<EquipExchangeCfgData> = list.concat();
			
			while(remain.length>0)
			{
				var item:Object = remain.shift();
				
				if(re.length == 0)
				{
					re.push(item);
					item = null;
				}
				else
				{
					for(var index:int = 0; index < re.length;++index)
					{
						if(index == 0 )
						{
							if(item.next_id == re[0].id)
							{
								re.unshift(item);
								item = null;
								break;
							}
							
						}
						else
						{
							if(re[index-1].next_id == item.id && item.next_id == re[index].id)
							{
								re.splice(index,0,item);
								item = null;
								break;
							}
						}
						
						if(index == re.length - 1 && re[index].next_id == item.id)
						{
							re.push(item);
							item = null;
							break;
						}
					}
				}
				
				if(item)
				{
					remain.push(item);
					++num;
				}
				else
				{
					num = 0;
				}
				
				if(num == remain.length)
				{
					break;
				}
				
			}
			
			return re;
		}
		
		private function sortList0(list:Vector.<EquipExchangeCfgData>):Vector.<EquipExchangeCfgData>
		{
			var num:int = 0;
			var remain:Vector.<EquipExchangeCfgData> = list.concat();
			var temp:EquipExchangeCfgData;
			for(var i:int = 0;i<remain.length;i++)
			{
				for(var j:int = i;j<remain.length;j++)
				{
					if(remain[i].step>remain[j].step)
					{
						temp = remain[i];
						remain[i] = remain[j];
						remain[j] = temp;
					}
				}
			}
			
			return remain;
		}
		
		public function getEquipExchangeStep(id:int,step:int,is_last:Boolean):EquipExchangeCfgData
		{
			var dic:Dictionary = ConfigDataManager.instance.equipExchangeCfgDataByStep(id,step);
			var re:EquipExchangeCfgData;
			var min:int = int.MIN_VALUE;
			var max:int = int.MAX_VALUE;
			if(is_last)
			{
				for each(var cfg:EquipExchangeCfgData in dic)
				{
					if(cfg.id>min){
						re = cfg;
						min = cfg.id;
					}
				}
			}
			else
			{
				for each(cfg in dic)
				{
					if(cfg.id<max){
						re = cfg;
						max = cfg.id;
					}
				}
			}
			return re;
		}
		
		private function initEquipExchangeData(item:EquipExchangeCfgData):void
		{
			var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(item.id);
			var type:int = equipCfg.type-10;
			if(type == 1)
				type =2;
			else if(type == 2)
				type =1;
			var b:Boolean;
			var s:String;
			var id:int = RoleDataManager.instance.getFireHeartId(type);
			var cfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
//			if(id == 0)return;
			if(equipCfg.type == ConstEquipCell.TYPE_HUOLONGZHIXIN)
			{
				if(list0Index.indexOf(item.step)==-1){
					if(cfg&&cfg.step== item.step)
					{
						list0Index.push(item.step);
						list0.push(cfg);
					}else
					{
						b = cfg&&cfg.step>item.step;
						s = item.id.toString();
						if(b){
							if(int(s.charAt(s.length-2)) == MAX){
								list0Index.push(item.step);
								list0.push(item)
							}
						}else{
							if(int(s.charAt(s.length-2)) == MIN){
								list0Index.push(item.step);
								list0.push(item)
							}
						}
					}
				}
				
			}
			else if(equipCfg.type == ConstEquipCell.TYPE_HUANJIE)
			{
				if(equipCfg.entity == EntityTypes.ET_PLAYER)
				{
					list1_0.push(item);
				}
				else if(equipCfg.entity == EntityTypes.ET_HERO)
				{
					list1_1.push(item);
				}
				
			}
			else if(equipCfg.type == ConstEquipCell.TYPE_DUNPAI)
			{
				if(list2Index.indexOf(item.step)==-1){
					if(cfg&&cfg.step== item.step)
					{
						list2Index.push(item.step);
						list2.push(cfg);
					}else
					{
						b = cfg&&cfg.step>item.step;
						s = item.id.toString();
						if(b){
							if(int(s.charAt(s.length-2)) == MAX){
								list2Index.push(item.step);
								list2.push(item)
							}
						}else{
							if(int(s.charAt(s.length-2)) == MIN){
								list2Index.push(item.step);
								list2.push(item)
							}
						}
					}
				}
			}
		}
		
		public function getDesc(type:int):String
		{
			if(type == RoleDataManager.HLZX)
			{
				return ConfigDataManager.instance.equipExchangeCfgData(1000100).des;
			}
			else if(type == RoleDataManager.HUANJIE)
			{
				return ConfigDataManager.instance.equipExchangeCfgData(1100100).des;
			}
			else
			{
				return ConfigDataManager.instance.equipExchangeCfgData(1200100).des;
			}
		}
		
		public function canConvertNewNum(_id:int,type:int):int
		{
			var cfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(_id);
			if(!cfg)
			{
				return 0;
			}
			if(cfg.id == cfg.next_id)
				return 0;
			var coin:int = BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind;
			var reputation:int = RoleDataManager.instance.reputation;
			var shendunzhili:int = RoleDataManager.instance.shendunzhili;
			var heroLove:int = HeroDataManager.instance.love;
			var count:int,id:int;
			id = _id;
			while(coin>=0&&reputation>=0&&shendunzhili>=0&&heroLove>=0)
			{
				var exCfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
				if(!exCfg)
					break;
				if(id == exCfg.next_id)
					break;
				if(RoleDataManager.instance.reincarn<exCfg.player_reincarn||
					RoleDataManager.instance.reincarn==exCfg.player_reincarn && RoleDataManager.instance.lv<exCfg.player_level)
				{
					break;
				}
				
				if(coin < exCfg.coin)
				{
					break;
				}
				
				if(reputation<exCfg.zhuangyuanshengwang)
				{
					break;
				}
				
				if(shendunzhili<exCfg.shendunzhili)
				{
					break;
				}
				
				if(HeroDataManager.instance.lv < exCfg.hero_grade)
				{
					break;
				}
				
				if(heroLove < exCfg.hero_love)
				{
					break;
				}
				coin-=exCfg.coin;
				reputation-=exCfg.zhuangyuanshengwang;
				shendunzhili-=exCfg.shendunzhili;
				heroLove-=exCfg.hero_love;
				count++;
				id = exCfg.next_id;
			}
			return count;
		}
		
		public function clearInstance():void
		{
			
		}
		
		public function ConvertDataManager(pc:PrivateClass)
		{
			super();
			
			if(!pc)
			{
				throw new Error("该类使用的单例模式");
			}
			
			
			BagDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			
//			BagDataManager.instance;
//			RoleDataManager.instance;
//			HeroDataManager.instance;
			
//			DistributionManager.getInstance().register(GameServiceConstants.SM_BAG_ITEMS,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_BAG_CHANGE,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_CHR_INFO,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EQUIP_EXCHANGE,this);
		}
	}
}

class PrivateClass{};