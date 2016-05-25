package com.model.business.gameService.serverMessageManager.subManages
{
	import com.model.business.gameService.serverMessageManager.dataManager.IDataManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class DistributionManager
	{
		private static var _instance:DistributionManager;
		
		private var _distributeDataManagers:Dictionary;
		
		public static function getInstance():DistributionManager
		{
			if (!_instance)
			{
				_instance = new DistributionManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function DistributionManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_distributeDataManagers = new Dictionary();
		}
		
		public function register(proc:int, dataManager:IDataManager):void
		{
			var dataManagers:Vector.<IDataManager> = _distributeDataManagers[proc] = _distributeDataManagers[proc] || new Vector.<IDataManager>();
			var index:int = dataManagers.indexOf(dataManager);
			if (index == -1)
			{
				dataManagers.push(dataManager);
			}
			else
			{
				trace("DistributionManager.register(proc, dataManager) 重复注册对象");
			}
		}
		
		public function dispatch(proc:int, data:ByteArray):void
		{
			var dataManagers:Vector.<IDataManager> = _distributeDataManagers[proc];
			if (dataManagers)
			{
				for each (var dataManager:IDataManager in dataManagers)
				{
					data.position = 0;
					dataManager.resolveData(proc, data);
				}
			}
		}
	}
}

class PrivateClass{}