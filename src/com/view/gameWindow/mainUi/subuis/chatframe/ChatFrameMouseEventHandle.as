package com.view.gameWindow.mainUi.subuis.chatframe
{
	import com.view.gameWindow.mainUi.subclass.McChatFrame;
	import com.view.gameWindow.panel.panels.menus.ChatChannelMenu;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.events.Request;

	public class ChatFrameMouseEventHandle
	{
		private var _skin:McChatFrame;
		private var _chatFrame:IChatFrame;
		private var _channelMenu:ChatChannelMenu;
		
		public function set chatFrame(value:IChatFrame):void
		{
			_chatFrame = value;
			
			_chatFrame.view.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			_chatFrame.view.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
		}
		
		public function get chatFrame():IChatFrame
		{
			return _chatFrame;
		}
		
		public function ChatFrameMouseEventHandle()
		{
			
		}
		
		
		public function addEvent(skin:McChatFrame):void
		{
			_skin = skin;
			skin.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		
		private function rollOverHandler(e:MouseEvent):void
		{
			chatFrame.showBg();
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
//			var input:IChatInput = chatFrame.input;
//			if(input && input.isFocus)
//			{
//				return;
//			}
			
			chatFrame.hideBg();
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			
			var mc:MovieClip = evt.target as MovieClip;
			var lastBtn:MovieClip;
			switch(mc)
			{
				case _skin.btn_00:
					initBtn();
					_skin.btn_00.selected = true;
					chatFrame.changeChannel(chatFrame.getChannelByIndex(0));
					break;
				case _skin.btn_01:
					initBtn();
					_skin.btn_01.selected = true;
					chatFrame.changeChannel(chatFrame.getChannelByIndex(1));
					break;
				case _skin.btn_02:
					initBtn();
					_skin.btn_02.selected = true;
					chatFrame.changeChannel(chatFrame.getChannelByIndex(2));
					break;
				case _skin.btn_03:
					initBtn();
					_skin.btn_03.selected = true;
					chatFrame.changeChannel(chatFrame.getChannelByIndex(3));
					break;
				case _skin.btn_04:
					initBtn();
					_skin.btn_04.selected = true;
					chatFrame.changeChannel(chatFrame.getChannelByIndex(4));
					break;
				case _skin.btn_05:
					initBtn();
					_skin.btn_05.selected = true;
					chatFrame.changeChannel(chatFrame.getChannelByIndex(5));
					break;
				case _skin.btn_06:
					initBtn();
					_skin.btn_06.selected = true;
					chatFrame.changeChannel(chatFrame.getChannelByIndex(6));
					break;
				case _skin.btn_07:
					
//					Panel1BtnPromptData.strName = StringConst.PROMPT_PANEL_0005;
//					Panel1BtnPromptData.strContent = StringConst.PROMPT_PANEL_0007;
//					Panel1BtnPromptData.strBtn = StringConst.PROMPT_PANEL_0003;
//					PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
					
					
					evt.stopImmediatePropagation();
					if(!_channelMenu)
					{
						var pos:Point =/* _skin.localToGlobal(*/new Point(_skin.btn_07.x,_skin.btn_07.y)/*)*/;
						_channelMenu = new ChatChannelMenu();
						_channelMenu.initView();
						chatFrame.view.addChild(_channelMenu);
						_channelMenu.x = pos.x;
						_channelMenu.y = pos.y - _channelMenu.height;
						_channelMenu.addEventListener(Event.SELECT,menuChangeHandler);
					}
					break;
				case _skin.btn_08:
					//发送 test
					if(chatFrame)
					{
						chatFrame.input.sendTalk();
					}
					break;
				default:
					break;	
			}
		}
		
		private function menuChangeHandler(e:Request):void
		{
			var type:int = int(e.value);
			if(type != -1)
			{
				chatFrame.changeInputChannel(type);
			}
			
			_channelMenu.destroy();
			_channelMenu.parent.removeChild(_channelMenu);
			
			_channelMenu.removeEventListener(Event.CHANGE,menuChangeHandler);
			_channelMenu = null;
		}
		
		private function initBtn():void
		{
			_skin.btn_00.selected = false;
			_skin.btn_01.selected = false;
			_skin.btn_02.selected = false;
			_skin.btn_03.selected = false;
			_skin.btn_04.selected = false;
			_skin.btn_05.selected = false;
			_skin.btn_06.selected = false;
		}
	}
}