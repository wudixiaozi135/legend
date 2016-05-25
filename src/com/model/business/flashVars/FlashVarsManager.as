package com.model.business.flashVars
{
	public class FlashVarsManager
	{
		private static var _instance:FlashVarsManager;
		
		private var _params:Object;
		
		public static function getInstance():FlashVarsManager
		{
			if (!_instance)
			{
				_instance = new FlashVarsManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function FlashVarsManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
		}
		
		public function init(params:Object):void
		{
			_params = params;
			//测试代码
			/*var flashvars:Object= new Object();
			flashvars.serverip = "192.168.1.109";
			flashvars.port = "443";
			flashvars.respath = "http://192.168.1.109/res/";
			flashvars.newMir = "NewMir.swf";
			flashvars.createRole = "CreateRole.swf";
			flashvars.selectRole = "SelectRole.swf";
			flashvars.gameWindow = "GameWindow.swf";
			_params = flashvars;*/
			//
		}
		
		public function get serverIp():String
		{
			return _params.serverip;
		}
		
		public function get port():int
		{
			return _params.port;
		}
		
		public function get resPath():String
		{
			return _params.respath;
		}
		
		public function get passport():String
		{
			return _params.passport;
		}
		
		public function get uid():String
		{
			return _params.uid;
		}
		
		public function get sid():int
		{
			return _params.sid;
		}
		
		public function get clientCtep():int
		{
			return _params.clientStep;
		}
		
		public function get token():String
		{
			return _params.token;
		}
		
		public function get newMir():String
		{
			return _params.newMir;
		}
		
		public function get createRole():String
		{
			return _params.createRole;
		}
		
		public function get selectRole():String
		{
			return _params.selectRole;
		}
		
		public function get gameWindow():String
		{
			return _params.gameWindow;
		}

		/**收藏地址*/
		public function get favoriteUrl():String
		{
			var str:String = _params.favoriteUrl;
			return replaceStr(str);
		}

        /**充值链接*/
        public function get payUrl():String
        {
			var str:String = _params.payUrl;
			return replaceStr(str);
        }
		
		/**微端链接*/
		public function get smartUrl():String
		{
			var str:String = _params.smartUrl;
			return replaceStr(str);
		}
		
		/**是否微端*/
		public function get isMini():int
		{
			return _params.mini;
		}

        public function get forumUrl():String
        {
			var str:String = _params.forumUrl;
			return replaceStr(str);;
        }
		
		public function get httpUrl():String
		{
			var str:String = _params.httpUrl;
			return replaceStr(str);
		}
		
		private function replaceStr(str:String):String
		{
			var oldStr:String = "@",newStr:String = "&";
			if(str)
			{
				var index:int = str.indexOf(oldStr);
				while(index!=-1)
				{
					str = str.replace(oldStr,newStr);
					index = str.indexOf(oldStr);
				}
				return str;
			}
			return null;
		}
	}
}

class PrivateClass{}