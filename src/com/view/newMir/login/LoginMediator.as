package com.view.newMir.login
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class LoginMediator
	{
		private static var _instance:LoginMediator;
		
		private var _nameText:String;
		
		public static function getInstance():LoginMediator
		{
			if (!_instance)
			{
				_instance = new LoginMediator(new PrivateClass());
			}
			return _instance;
		}
		
		public function LoginMediator(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
		}
		
		public function connectAndUserLogin(serverIp:String, port:int, nameText:String, serverId:int):void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.writeUTF(nameText);
			bytes.writeInt(serverId);
			ClientSocketManager.getInstance().connect(serverIp, port, GameServiceConstants.CM_USER_LOGIN, bytes);
			
			_nameText = nameText;
		}
		
		public function connectAndGateLogin(serverIp:String, port:int, uid:String, serverId:int, token:String):void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.writeUTF(uid);
			bytes.writeInt(serverId);
			bytes.writeUTF(token);
			ClientSocketManager.getInstance().connect(serverIp, port, GameServiceConstants.CM_GATE_LOGIN, bytes);
			
			_nameText = nameText;
		}
		
		public function gateLogin(uid:String, sid:int, token:String):void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.writeUTF(uid);
			bytes.writeInt(sid);
			bytes.writeUTF(token);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GATE_LOGIN, bytes);
		}
		
		public function get nameText():String
		{
			return _nameText;
		}
		
		public function set nameText(value:String):void
		{
			_nameText = value;
		}
	}
}

class PrivateClass{}