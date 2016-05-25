package com.view.gameWindow.panel.panels.buff
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.util.ServerTime;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	/**
	 * @author wqhk
	 * 2014-9-13
	 */
	public class BuffDataManager extends DataManagerBase
	{
		private static var _instance:BuffDataManager;
		public static function get instance():BuffDataManager
		{
			if(!_instance)
			{
				_instance = new BuffDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		private var _dict:Dictionary;
		
		public function BuffDataManager(value:PrivateClass)
		{
			super();
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_PLAYER_BUFF_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_UNITS_BUFF_LIST,this);
			
			_dict = new Dictionary();
		}
		
		public function deleteBuffForce(entityType:int,entityId:int,id:int):void
		{
			var list:BuffListData = getBuffList(entityType,entityId);
			list.deleteBuff(id);
		}
		
		public function clearInstance():void
		{
			
		}
	
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(proc == GameServiceConstants.SM_PLAYER_BUFF_LIST)
			{
				resolvePlayerBuffList(data);
			}
			else if(proc == GameServiceConstants.SM_UNITS_BUFF_LIST)
			{
				clearIdleBuffer();
				resolveUnitBuffList(data);
			}
			super.resolveData(proc,data);
		}
		
		//1、玩家角色自己buff列表
		private function resolvePlayerBuffList(data:ByteArray):void
		{
			var entity:IEntity = EntityLayerManager.getInstance().firstPlayer;
			
			var entityId:int = data.readInt();
			var count:int = data.readByte();
			
			resolveBufferList(EntityTypes.ET_PLAYER,entityId,count,data,false);
		}
		
		//2、他人（包括自己）buff列表
		private function resolveUnitBuffList(data:ByteArray):void
		{
			var total:int = data.readShort();
			
			for(var i:int = 0; i < total; ++i)
			{
				var eType:int = data.readByte();
				var eId:int = data.readInt();
				var count:int = data.readByte();
				resolveBufferList(eType,eId,count,data,true);
			}
			
		}
		
		private function clearIdleBuffer():void
		{
			for each(var item:BuffListData in _dict)
			{
				if(item.list.length == 0)
				{
					removeBufferTarget(item.key);
				}
			}
		}
		
		private function resolveBufferList(entityType:int,entityId:int,count:int,data:ByteArray,isBoadcast:Boolean):void
		{
//			trace("====resolveBufferList====");
//			trace(entityType+";"+entityId+";"+count+";"+isBoadcast);
			var buffList:BuffListData = findBufferTarget(BuffListData.getKey(entityType,entityId));
			var unit:ILivingUnit = null;
			unit = EntityLayerManager.getInstance().getEntity(entityType,entityId) as ILivingUnit;
				
			if(count == 0)
			{
				if(buffList)
				{
					if(isBoadcast)
					{
						buffList.clearBoadcastList();
					}
					else
					{
						buffList.clearList();
					}
				}
			}
			else
			{
				if(!buffList)
				{
					buffList = new BuffListData(entityType,entityId);
					addBufferTarget(buffList.key,buffList);
				}
				else
				{
					if(isBoadcast)
					{
						buffList.clearBoadcastList();
					}
					else
					{
						buffList.clearList();
					}
				}
				
				for(var i:int = 0; i < count; ++i)
				{
					var bData:BuffData = new BuffData();
					bData.id = data.readInt();
					bData.endtime = data.readInt();
					
					buffList.update(bData);
				}
			}
			if (unit)
			{
				unit.refreshBuffs();
			}
		}
		
		public function getBuffList(type:int,id:int):BuffListData
		{
			return findBufferTarget(BuffListData.getKey(type,id));
		}
		
		public function removeTarget(type:int,id:int):void
		{
			var key:String = BuffListData.getKey(type,id);
			removeBufferTarget(key);
		}
		
		private function removeBufferTarget(key:String):void
		{
			delete _dict[key];
		}
		
		private function findBufferTarget(key:String):BuffListData
		{
			return _dict[key];
		}
		
		private function addBufferTarget(key:String,data:BuffListData):void
		{
			_dict[key] = data;
		}
		
		/**
		 * @return 剩余时间 ： -1 永久
		 */
		public function getBufferTime(entityType:int,entityId:int,bufferId:int):int
		{
			var list:BuffListData = getBuffList(entityType,entityId);
			
			if(list)
			{
				var data:BuffData = list.findBuff(bufferId);
				if(data)
				{
					if(data.endtime>0)
					{
						var time:int = data.endtime - ServerTime.time;
						
						if(time<0)
						{
							time = 0;
						}
						
						return time;
					}
					else
					{
						return -1;
					}
				}
			}
			
			return 0;
		}
		
		public function get buffTriggerSkillId():int
		{
			var data:BuffData = triggerSkillBuff;
			if(data)
			{
				data.specialTriggerSkill;
			}
			
			return 0;
		}
		
		public function get triggerSkillBuff():BuffData
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var listDt:BuffListData = getBuffList(firstPlayer.entityType,firstPlayer.entityId);
			if(!listDt)
			{
				return null;
			}
			var dt:BuffData;
			for each(dt in listDt.list)
			{
				if(getBufferTime(firstPlayer.entityType,firstPlayer.entityId,dt.id) > 0 && dt.specialTriggerSkill)
				{
					return dt;
				}
			}
			return null;
		}
	}
}

class PrivateClass{}