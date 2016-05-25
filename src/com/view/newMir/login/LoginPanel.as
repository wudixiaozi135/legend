package com.view.newMir.login
{
	import com.model.business.flashVars.FlashVarsManager;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class LoginPanel extends Sprite
	{
		private var _nameText:TextField;
		private var _serverText:TextField;
		private var _enterBtn:Sprite;
		
		public function init():void
		{
			opaqueBackground = 0xffffff;
			
			_nameText = new TextField();
			_nameText.backgroundColor = 0x888888;
			_nameText.background = true;
			_nameText.height = 16;
			_nameText.type = TextFieldType.INPUT;
			_nameText.x = (stage.stageWidth - _nameText.width) / 2.0;
			_nameText.y = stage.stageHeight / 2.0 - 30;
			_nameText.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandle, false, 0, true);
			_serverText = new TextField();
			_serverText.backgroundColor = 0x888888;
			_serverText.background = true;
			_serverText.height = 16;
			_serverText.text = "2";//2 8 4
			_serverText.type = TextFieldType.INPUT;
			_serverText.x = (stage.stageWidth - _nameText.width) / 2.0;
			_serverText.y = stage.stageHeight / 2.0;
			_serverText.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandle, false, 0, true);
			
			_enterBtn = new Sprite();
			_enterBtn.graphics.beginFill(0x000000);
			_enterBtn.graphics.drawRect(0, 0, 100, 15);
			_enterBtn.tabEnabled = true;
			_enterBtn.buttonMode = true;
			_enterBtn.x = (stage.stageWidth - _enterBtn.width) / 2.0;
			_enterBtn.y = stage.stageHeight / 2.0 + 30;
			_enterBtn.addEventListener(MouseEvent.CLICK, enterBtnClickHandle, false, 0, true);
			
			addChild(_nameText);
			addChild(_serverText);
			addChild(_enterBtn);
		}
		
		private function keyboardHandle(event:KeyboardEvent):void
		{
			if (event.keyCode == 13)//回车
			{
				enterHandle();
			}
		}
		
		private function enterBtnClickHandle(event:MouseEvent):void
		{
			enterHandle();
		}
		
		private function enterHandle():void
		{
			var nameText:String = _nameText.text;
			var serverId:int = parseInt(_serverText.text);
			if (nameText.length > 0 && serverId > 0)
			{
				_nameText.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardHandle);
				_serverText.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardHandle);
				_enterBtn.removeEventListener(MouseEvent.CLICK, enterBtnClickHandle);
				
				var flashVarsManager:FlashVarsManager = FlashVarsManager.getInstance();
				var serverIp:String = flashVarsManager.serverIp;
				var port:int = flashVarsManager.port;
				LoginMediator.getInstance().connectAndUserLogin(serverIp, port, nameText, serverId);
			}
		}
	}
}