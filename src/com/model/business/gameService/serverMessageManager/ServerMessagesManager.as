package com.model.business.gameService.serverMessageManager
{
	import com.model.business.gameService.serverMessageManager.item.ServerMessage;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.dataManager.LoginDataManager;
	
	import flash.utils.ByteArray;

	public final class ServerMessagesManager
	{
		private static var _instance:ServerMessagesManager;
		private var _msgQueue:Vector.<ServerMessage>;
		private var _blocked:Boolean;
		
		private var _distributionManager:DistributionManager;
		private var _errorMsgManager:ErrorMessageManager;
		private var _successMessageManager:SuccessMessageManager;
		
		public static function getInstance():ServerMessagesManager
		{
			if (!_instance)
			{
				_instance = new ServerMessagesManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function ServerMessagesManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_msgQueue = new Vector.<ServerMessage>();
			_blocked = false;
			
			_distributionManager = DistributionManager.getInstance();
			_errorMsgManager = ErrorMessageManager.getInstance();
			_successMessageManager = SuccessMessageManager.getInstance();
			LoginDataManager.instance;
		}
		
		public function set blocked(value:Boolean):void
		{
			_blocked = value;
		}
		
		public function addMessage(type:int, proc:int, data:ByteArray):void
		{
			var msg:ServerMessage = new ServerMessage(type, proc, data);
			_msgQueue.push(msg);
		}
		
		public function checkMsgQueue():void
		{
			if (_blocked)
			{
				return;
			}
			while (_msgQueue.length > 0)
			{
				var msg:ServerMessage = _msgQueue.shift();
//				trace(msg.type+"type"+msg.proc)
				var data:ByteArray = msg.data;
				if (msg.type == ClientSocketManager.PACK_PROCREPLY)
				{
					var isSuccess : int = data.readUnsignedByte();
					if(isSuccess == 0)
					{
						replyError(msg.proc, data);
					} 
					else
					{
						replySuccess(msg.proc, data);
					}
				}
				else
				{
					_distributionManager.dispatch(msg.proc, data);
				}
			}
		}
		
		private function replySuccess(proc:int, data:ByteArray):void
		{
			_successMessageManager.dispatch(proc,data);
		}
		
		private function replyError(proc:int, data:ByteArray):void
		{
			_errorMsgManager.dispatch(proc,data);
		}
	}
}

class PrivateClass{};
