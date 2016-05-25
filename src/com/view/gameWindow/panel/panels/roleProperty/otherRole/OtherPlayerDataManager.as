package com.view.gameWindow.panel.panels.roleProperty.otherRole
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.ConstStorage;
    import com.model.dataManager.DataManagerBase;
    import com.model.gameWindow.mem.AttrRandomData;
    import com.model.gameWindow.mem.MemEquipData;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.propertyParse.PropertyData;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    public class OtherPlayerDataManager extends DataManagerBase
	{
		private static var _instance:OtherPlayerDataManager;


		public function get memDic():Dictionary
		{
			return _memDic;
		}

		private static function hideFun():void{}
		public static function get instance():OtherPlayerDataManager
		{
			if(!_instance)
				_instance = new OtherPlayerDataManager(hideFun);
			return _instance;
		}
		
		private var dic:Dictionary;
		public var equipDatas:Vector.<EquipData>;
		private var _memDic:Dictionary;
		public var _infoDic:Dictionary;
		
		public function OtherPlayerDataManager(fun:Function)
		{
			super();
			if(fun != hideFun)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_OTHER_PLAYER_INFO,this);	
			dic = new Dictionary();
			equipDatas = new Vector.<EquipData>();
			_memDic = new Dictionary();
			_infoDic = new Dictionary();
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_QUERY_OTHER_PLAYER_INFO:
					readData(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		public var cid:int;
		public var sid:int;
		public var name:String;
		public var sex:int;
		public var job:int;
		public var reincarn:int;
		public var level:int;
		public var fightPower:int;
		public var familyId:int;
		public var familySid:int;
		public var familyName:String;
		
		
		private function readData(data:ByteArray):void
		{
			cid = data.readInt();//cid
			sid = data.readInt();//sid
			var job:int = RoleDataManager.instance.job;
			equipDatas.length = 0;
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_WUQI,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_TOUKUI,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_XIANGLIAN,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_YIFU,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_SHOUZHUO,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_SHOUZHUO,data,1);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_JIEZHI,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_JIEZHI,data,1);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_YAODAI,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_XIEZI,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_XUNZHANG,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_HUOLONGZHIXIN,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_HUANJIE,data);
			setMemDataDic(cid,sid,ConstEquipCell.TYPE_DUNPAI,data);
            setMemDataDic(cid, sid, ConstEquipCell.TYPE_DUNPAI, data);//翅膀

			//读取时装、斗笠、翅膀、足迹的Id
			setDic(cid,sid,ConstEquipCell.TYPE_SHIZHUANG,data);
            setDic(cid, sid, ConstEquipCell.TYPE_DOULI, data);
//			setDic(cid,sid,ConstEquipCell.TYPE_CHIBANG,data);
			setDic(cid,sid,ConstEquipCell.TYPE_ZUJI,data);
			setDic(cid,sid,ConstEquipCell.TYPE_HUANWU,data);
			//设置基础属性
			setInfoDic(cid,sid,data);
			
		}
		
		private function setInfoDic(cid:int,sid:int,data:ByteArray):void
		{
			var object:Object = {};
			if(!_infoDic[cid])
			{
				_infoDic[cid] = new Dictionary();
			}
			_infoDic[cid][sid] = object;
			object["name"] = data.readUTF();
			object["sex"] = data.readByte();
			object["job"] = data.readByte();
			object["reincarn"] = data.readByte();
			object["level"] = data.readShort();
			object["fightPower"] = data.readInt();
			object["idHide"] = data.readInt();//时装隐藏状态
			object["familyId"] = data.readInt();	
			object["familySid"] = data.readInt();
			object["familyName"] = data.readUTF();
		}
		
		private function setMemDataDic(cid:int,sid:int,slot:int,data:ByteArray,type:int = 0):void
		{
			var onlyId:int = data.readInt();
			var bornSid:int = data.readInt();
			if (!dic[bornSid])
			{
				dic[bornSid] = new Dictionary();
			}
			if(!_memDic[cid])
			{
				_memDic[cid] = new Dictionary();
			}
			if(!_memDic[cid][sid])
			{
				_memDic[cid][sid] = new Dictionary();
			}
			if(!_memDic[cid][sid][type])
			{
				_memDic[cid][sid][type] = new Dictionary();
			}
			var equipData:EquipData = new EquipData();
			equipData.id = onlyId;
			equipData.bornSid = bornSid;
			equipData.slot = slot;
			equipData.storageType = ConstStorage.ST_CHR_EQUIP;
			equipDatas.push(equipData);
			var memEquipData:MemEquipData = dic[bornSid][onlyId];
			if(!memEquipData)
			{
				memEquipData = new MemEquipData();
				memEquipData.onlyId = onlyId;
				memEquipData.bornSid = bornSid;
				dic[memEquipData.bornSid][memEquipData.onlyId] = memEquipData;
			}
			_memDic[cid][sid][type][slot] = memEquipData;
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
				}
				else
				{
					attrRds.push(null);
				}
			}
			memEquipData.attrRdMaxStar = attrRdMaxStar;
			memEquipData.setAttrRds(attrRds);
		}
		
		private function setDic(cid:int,sid:int,slot:int,data:ByteArray,type:int = 0):void 
		{
			_memDic[cid][sid][type][slot] = data.readInt();
		}
		
		public function sendData(cid:int,sid:int):void
		{
			var byteArry:ByteArray = new ByteArray();
			byteArry.endian = Endian.LITTLE_ENDIAN;
			byteArry.writeInt(cid);
			byteArry.writeInt(sid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OTHER_PLAYER_INFO,byteArry);
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