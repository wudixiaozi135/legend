package com.model.dataManager
{
	/**
	 * 数据管理者的观察者类
	 * @author Administrator
	 */	
	public class DataManagerManager
	{
		private static var _instance:DataManagerManager;
		
		private var _dataManagers:Vector.<DataManagerBase>;
		
		public static function getInstance():DataManagerManager
		{
			if (!_instance)
			{
				_instance = new DataManagerManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function DataManagerManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_dataManagers = new Vector.<DataManagerBase>();
		}
		/**注册数据管理者对象*/
		public function attach(dataManager:DataManagerBase):void
		{
			_dataManagers.push(dataManager);
		}
		/**清理所有数据管理者的数据*/
		public function clearAllDataManagers():void
		{
			for each (var dataManager:DataManagerBase in _dataManagers)
			{
				dataManager.clearDataManager();
			}
		}
	}
}

class PrivateClass{};