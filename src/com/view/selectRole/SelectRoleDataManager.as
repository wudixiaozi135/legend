package com.view.selectRole
{
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	import flash.utils.ByteArray;

	public class SelectRoleDataManager
	{
		private static var _instance:SelectRoleDataManager;
		
		private var _selectCid:int;
		private var _selectSid:int;
		
		public function set selectRoleDatas(value:Vector.<SelectRoleData>):void
		{
			_selectRoleDatas = value;
		}

		public static function getInstance():SelectRoleDataManager
		{
			if (!_instance)
			{
				_instance = new SelectRoleDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function SelectRoleDataManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
		}
		
		private var _selectRoleDatas:Vector.<SelectRoleData>;
		
		public function readData(data:ByteArray,count:int):void
		{
			_selectRoleDatas = new Vector.<SelectRoleData>();
			while(count)
			{
				var selectRoleData:SelectRoleData = new SelectRoleData();
				selectRoleData.cId = data.readInt();
				selectRoleData.sid = data.readInt();
				selectRoleData.name = data.readUTF();
				selectRoleData.sex = data.readInt();
				selectRoleData.head = data.readInt();
				selectRoleData.job = data.readInt();
				selectRoleData.rein=data.readInt();
				selectRoleData.level = data.readInt(); 
				selectRoleData.mapId = data.readInt();
				selectRoleData.mapX = data.readInt();
				selectRoleData.mapY = data.readInt();
				_selectRoleDatas.push(selectRoleData);
				count--;
			}
						
			 
				_selectCid = _selectRoleDatas[0].cId;
				_selectSid = _selectRoleDatas[0].sid;
			 
			//	_selectCid = _selectRoleDatas[_selectRoleDatas.length-1].cId;
			//	_selectSid = _selectRoleDatas[_selectRoleDatas.length-1].sid;
			
		}
		
		public function isSelf(cid:int,sid:int):Boolean
		{
			if(selectCid == cid && selectSid == sid)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function isFirstPlayer(e:IPlayer):Boolean
		{
			if(!e)
			{
				return false;
			}
			return isSelf(e.cid,e.sid);
		}
		
		public function get selectCid():int
		{
			return _selectCid;
		}
		
		public function get selectSid():int
		{
			return _selectSid;
		}

		public function get selectRoleDatas():Vector.<SelectRoleData>
		{
			return _selectRoleDatas;
		}
		
		public function selectRoleData():SelectRoleData
		{
			var dt:SelectRoleData;
			for each (dt in _selectRoleDatas) 
			{
				if(dt.cId == _selectCid && dt.sid == _selectSid)
				{
					return dt;
				}
			}
			return null;
		}

		public function set selectCid(value:int):void
		{
			_selectCid = value;
		}

	}
}

class PrivateClass{}