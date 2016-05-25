package com.model.business.gameService.serverMessageManager.subManages
{
	import com.model.business.gameService.serverMessageManager.dataManager.IDataManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * 错误消息管理器
	 * @author jhj
	 */
	public class ErrorMessageManager
	{
		private static var _instance:ErrorMessageManager;
		
		private var _errorMsgDataManagers:Dictionary;

		public static function getInstance():ErrorMessageManager
		{
			return _instance ||= new ErrorMessageManager(new PrivateClass());
		}
		
		public function ErrorMessageManager(cls:PrivateClass)
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
			var errId:int = data.readInt();
			var info:int = data.readInt();
			dealError(proc,errId,info);
			var dataManagers:Vector.<IDataManager> = _errorMsgDataManagers[errId];
			if (dataManagers)
			{
				for each (var dataManager:IDataManager in dataManagers)
				{
					data.position = 0;
					data.readByte();
					dataManager.resolveData(errId, data);
				}
			}
		}
		
		private function dealError(proc:int,errorId:int,info:int):void
		{
			ErrorDealManages.getInstance().dealError(errorId);
			trace("错误消息proc:"+proc + ",errId:" + errorId + ",info:" + info);
		}
	}
}

class PrivateClass{}