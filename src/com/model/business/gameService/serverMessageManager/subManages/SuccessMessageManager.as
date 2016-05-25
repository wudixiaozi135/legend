package com.model.business.gameService.serverMessageManager.subManages
{
	import com.model.business.gameService.serverMessageManager.dataManager.IDataManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * @author jhj
	 */
	public class SuccessMessageManager
	{
		private static var _instance:SuccessMessageManager;
		private var _errorMsgDataManagers:Dictionary;
		
		public static function getInstance():SuccessMessageManager
		{
			return _instance ||= new SuccessMessageManager(new PrivateClass());
		}
		
		public function SuccessMessageManager(cls:PrivateClass)
		{
			_errorMsgDataManagers = new Dictionary();
		}
		
		public function register(proc:int, dataManager:IDataManager):void
		{
			var dataManagers:Vector.<IDataManager> = _errorMsgDataManagers[proc] = _errorMsgDataManagers[proc] || new Vector.<IDataManager>();
			dataManagers.push(dataManager);
		}
		
		public function dispatch(proc:int, data:ByteArray):void
		{
			var dataManagers:Vector.<IDataManager> = _errorMsgDataManagers[proc];
			if (dataManagers)
			{
				for each (var dataManager:IDataManager in dataManagers)
				{
					data.position = 0;
					data.readByte();
					dataManager.resolveData(proc, data);
				}
			}
		}
	}
}
class PrivateClass{}