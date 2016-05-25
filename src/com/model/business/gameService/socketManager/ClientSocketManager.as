package com.model.business.gameService.socketManager
{
	import com.model.business.gameService.serverMessageManager.ServerMessagesManager;
	import com.model.consts.StringConst;
	import com.view.gameWindow.util.DebugUI;
	import com.view.gameWindow.util.HttpServiceUtil;
	import com.view.newMir.NewMirMediator;
	import com.view.newMir.prompt.PanelPromptData;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public final class ClientSocketManager
	{
		//包类型
		public static const PACK_PROC:int = 1;
		public static const PACK_PROCREPLY:int = 2;
		public static const PACK_DISPATCH:int = 3;
		
		private static var _instance:ClientSocketManager;
		private static var _codeBytes:ByteArray;
		
		//收发数据所需变量
		private var _mState:int;	//当前接收状态，０表示等待rpc头，１表示等待数据
		private var _sState:int;//当前拆包状态，０表示等待rpc头，１表示等待数据
		private var _procType:int;	//包的类型，是proc的返回还是服务器dispatch的包,2表示proc返回消息，3表示服务器分发
		private var _proc:int;
		private var _dataLength:int; //当前包需要的数据长度
		private var _procLength:int;//当前指令需要的数据长度
		private var _socket:Socket;
		
		private var _host:String;
		private var _port:int;
		private var _isConnected:Boolean;
		
		private var _isCompress:int;
		private var _procData:ByteArray;
		private var _receivedData:ByteArray;
		private var _sendData:ByteArray;
		private var _autoIncrease:int;
		
		private var _loginProc:int;
		private var _loginBytes:ByteArray;
		
		public static function getInstance():ClientSocketManager
		{
			if (!_instance)
			{
				_instance = new ClientSocketManager(new PrivateClass());
				_instance.init();
			}
			return _instance;
		}
		
		public function ClientSocketManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			
			_codeBytes = new ByteArray();
			_codeBytes.writeUTFBytes("MwKH53zURHhpWf3GYpGRW2AWwkdOvP9w");
			
			_procData = new ByteArray();
			_procData.endian = Endian.LITTLE_ENDIAN;
			_receivedData = new ByteArray();
			_receivedData.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function init():void
		{
			_isConnected = false;
			
			_socket = new Socket();
			_socket.endian = Endian.LITTLE_ENDIAN;
			_socket.addEventListener(Event.CONNECT, onConnect);	// 连接成功
			_socket.addEventListener(Event.CLOSE, onServerClose);	// 服务器断开链接
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			_autoIncrease = 1;
			_sendData = new ByteArray();
			_sendData.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function connect(host:String, port:int, loginProc:int, loginBytes:ByteArray):void
		{
			if(!host || host == "" || port > 65535 || port < 0)
			{
				trace("主机IP或端口错误");
				return;
			}
			
			_loginProc = loginProc;
			_loginBytes = loginBytes;
			
			if(_isConnected)
			{
				onConnect(null);
			}
			else
			{
				_host = host;
				_port = port;
				_socket.connect(host, port);
				HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP2,1);
			}
		}
		
		public function close():void
		{
			_isConnected = false;
			_socket.timeout = 10000;
			_socket.removeEventListener(Event.CONNECT, onConnect);	// 连接成功
			_socket.removeEventListener(Event.CLOSE, onServerClose);	// 服务器断开链接
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onData);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			if (_socket.connected)
			{
				_socket.close();
			}
		}
		
		private function onConnect(event:Event):void
		{
			_isConnected = true;
			_mState = 0;
			
			if(event != null)
			{
				var data:ByteArray = new ByteArray();
				data.length = 23;
				_socket.writeBytes(data, 0, 23);
				_socket.flush();
			}
			HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP3,1);
			asyncCall(_loginProc, _loginBytes);
			HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP4,1);
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			_isConnected = false;
			/**dm.onSocketClose();*/
			if(NewMirMediator.getInstance().iNewMir!=null)
			{
				showOffLine();
			}
			else
			{
				/*NewMirMediator.getInstance().showPromptDialog(InternationalConstants.getGameString(11017),InternationalConstants.getGameString(10041),"",refreshWindow,null,false);
				setTimeout(refreshWindow,1000);*/
			}
			HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP3,0);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{ 
			_isConnected = false;
			/**dm.onSocketClose();*/
			if(NewMirMediator.getInstance().iNewMir!=null)
			{
				showOffLine();
			}
			else
			{
				/*NewMirMediator.getInstance().showPromptDialog(InternationalConstants.getGameString(11017),InternationalConstants.getGameString(10041),"",refreshWindow,null,false);
				setTimeout(refreshWindow,1000);*/
			}
			HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP3,0);
		}
		
		public function refreshWindow():void
		{
			navigateToURL(new URLRequest("javascript:window.location.reload(false);"), "_self");
		}
	
		private function onData(event:ProgressEvent):void
		{
			if(!_isConnected)
				return;
			
			do
			{
				if (_mState == 0 && _socket.bytesAvailable >= 4)
				{
					_dataLength = _socket.readShort();
					_isCompress = _socket.readShort();
					_mState = 1;
				}
				if (_mState == 1 && _socket.bytesAvailable >= _dataLength - 4)
				{
					_receivedData.clear();
					_socket.readBytes(_receivedData, 0, _dataLength - 4);
					if (_isCompress)
					{
						_receivedData.uncompress();
					}
					splitByteArray();
					_mState=0;
				}
			}
			while(_socket.connected && _mState == 0 && _socket.bytesAvailable >= 4);
		}
		
		public function splitByteArray():void
		{
			var position:int = _procData.position;
			_receivedData.readBytes(_procData, _procData.length, _receivedData.bytesAvailable);
			_procData.position = position;
			_receivedData.clear();
			_procData.readBytes(_receivedData, 0, _procData.bytesAvailable);
			_receivedData.position = 0;
			var bytes:ByteArray = _procData;
			_procData = _receivedData;
			_receivedData = bytes;
			do
			{
				if (_sState == 0 && _procData.bytesAvailable >= 7)
				{
					_procType = _procData.readByte();
					_proc = _procData.readShort();
					_procLength = _procData.readInt();
					_sState = 1;
				}
				if (_sState == 1 && _procData.bytesAvailable >= _procLength)
				{ 
					var sendBytes:ByteArray = new ByteArray();
					sendBytes.endian = Endian.LITTLE_ENDIAN;
					_procData.readBytes(sendBytes, 0, _procLength);
					ServerMessagesManager.getInstance().addMessage(_procType, _proc, sendBytes);
					_sState = 0;
				}
				if (DEF::CLIENTLOGIN)
				{
					DebugUI.instance.print("receive:", [_proc], 0x00ff00);
				}
			}
			while(_sState == 0 && _procData.bytesAvailable >= 7);
		}
	
		private function onServerClose(event:Event):void
		{
			_isConnected = false;
			/*dm.onSocketClose();*/
			if(NewMirMediator.getInstance().iNewMir!=null)
			{
				showOffLine();
			}
			else
			{
				/*NewMirMediator.getInstance().showPromptDialog(InternationalConstants.getGameString(11017),InternationalConstants.getGameString(10041),"",refreshWindow,null,false);
				setTimeout(refreshWindow,1000);*/
			}
		}
		
		private function showOffLine():void
		{
			PanelPromptData.txtName = StringConst.PROMPT_PANEL_0005;
			PanelPromptData.txtContent = StringConst.PROMPT_PANEL_0006;
			PanelPromptData.txtBtn = StringConst.PROMPT_PANEL_0003;
			NewMirMediator.getInstance().showOffLine(true);
		}
		
		public function encrypt(data:ByteArray):void
		{
			var xlen:int = data.length;
			var KeyLen:int = _codeBytes.length;
			for (var i:int = 0; i < xlen; i++)
			{
				var ndata:int = _codeBytes[(i + 6) % KeyLen];
				data[i] ^= ndata;
			}
		}
		
		public function asyncCall(proc:int,data:ByteArray):void
		{
			if(_isConnected)
			{
                if(DEF::CLIENTLOGIN){
                    DebugUI.instance.print("send:",[proc],0xffff00);
                }
				_autoIncrease++;
				_socket.writeByte(PACK_PROC); 
				_socket.writeShort(proc);
				
				_sendData.clear();
				_sendData.writeBytes(data, 0, data.length);
				_sendData.writeInt(_autoIncrease);
				_sendData.position = 0;
				var checkByte:int = 0;
				while (_sendData.position < _sendData.length)
				{
					checkByte ^= (_sendData.readByte() & 0xFF)
				}
				_sendData.writeByte(checkByte);
				_socket.writeInt(_sendData.length);
				
				encrypt(_sendData);
				_socket.writeBytes(_sendData, 0, _sendData.length);
				_socket.flush();
			}
		}
		
	}
}

class PrivateClass{}