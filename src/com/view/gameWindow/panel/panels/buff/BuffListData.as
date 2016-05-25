package com.view.gameWindow.panel.panels.buff
{
	
	/**
	 * @author wqhk
	 * 2014-9-13
	 */
	public class BuffListData
	{
		private var _entityType:int;
		private var _entityId:int;
		private var _list:Array;//
		private var _key:String;
		public function BuffListData(entityType:int,entityId:int)
		{
			_list = [];
			_entityType = entityType;
			_entityId = entityId;
			_key = getKey(_entityType,_entityId);
		}
		
		public function get key():String
		{
			return _key;
		}
		
		public function clearList():void
		{
			_list = [];
		}
		
		public function clearBoadcastList():void
		{
			for each(var item:BuffData in _list)
			{
				if(item.cfg.broadcast)
				{
					deleteBuff(item.id);
				}
			}
		}
		
		public function update(data:BuffData):void
		{
			var buff:BuffData = findBuff(data.id);
			
			if(buff)
			{
				buff.copy(data);
			}
			else
			{
				_list.push(data);
			}
		}
		
		public function deleteBuff(id:int):void
		{
			var index:int = findBuffIndex(id);
			
			if(index != -1)
			{
				_list.splice(index,1);
			}
		}
		
		public function findBuffIndex(id:int):int
		{
			var index:int = 0;
			for each(var item:BuffData in _list)
			{
				if(item.id == id)
				{
					return index;
				}
				
				++index
			}
			
			return -1;
		}
		
		public function findBuff(id:int):BuffData
		{
			for each(var item:BuffData in _list)
			{
				if(item.id == id)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function findBuffByGroupId(id:int):BuffData
		{
			for each(var item:BuffData in _list)
			{
				if(item.cfg && item.cfg.group == id)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function get list():Array
		{
			_list.sort(sortBuffOrder);
			return _list;
		}

		private function sortBuffOrder(a:BuffData,b:BuffData):int
		{
			if(a.cfg.order < b.cfg.order)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		public function get entityId():int
		{
			return _entityId;
		}

		public function get entityType():int
		{
			return _entityType;
		}

		public static function getKey(entityType:int,entityId:int):String
		{
			return entityType+"_"+entityId;
		}
	}
}