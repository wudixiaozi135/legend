package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactType;
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.RoleMenu;
	import com.view.gameWindow.panel.panels.menus.handlers.ChatHandler;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	import com.view.newMir.NewMirMediator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mx.events.Request;
	
	
	/**
	 * @author wqhk
	 * 2014-8-13
	 */
	public class LinkWordView extends Sprite implements IToolTipClient
	{
		private var data:LinkWord;
		private var highlightFilter:Array;
		private var _width:Number;
		private var _height:Number;
		private var _removed:Boolean = false;
		
		public function getWidth():Number
		{
			return _width;
		}
		
		public function getHeight():Number
		{
			return _height;
		}
		
		public function LinkWordView(data:LinkWord)
		{
			super();
			
			this.data = data;
			
			
			switch(data.type)
			{
				case LinkWord.TYPE_ITEM:
				case LinkWord.TYPE_EQUIP:
				case LinkWord.TYPE_ROLE_NAME:
				case LinkWord.TYPE_CUSTOM:
					var txt:TextField = new TextField;
					txt.text = data.getDescription();
					txt.setTextFormat(
						new TextFormat(MessageCfg.FONT_NAME,MessageCfg.FONT_SIZE,data.getColor(),
								null,null,data.getUnderline(),null,null,TextAlign.LEFT));
					txt.width = txt.textWidth + 3;
					txt.height = txt.textHeight+ 4;
					_width = txt.width; 
					_height = txt.height;
					txt.selectable = false;
					txt.mouseEnabled = false;
					addChild(txt);
					
					
					if(data.getUnderline())
					{
						this.useHandCursor = true;
						this.buttonMode = true;
					}
					else
					{
						this.useHandCursor = false;
						this.buttonMode = false;
					}
					break;
			}
			
			_removed = true;
			addEvents();
		}
		
		public function addEvents():void
		{
			if(!_removed)
			{
				return;
			}
			
			if(data)
			{
				if(data.needTooltip)
				{
					ToolTipManager.getInstance().attach(this);
				}
				
				if(isInteractive(data.type))
				{
					addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
					addEventListener(MouseEvent.ROLL_OVER,rollOverHandler,false,0,true);
					addEventListener(MouseEvent.ROLL_OUT,rollOutHandler,false,0,true);
				}
			}
			
			_removed = false;
		}
		
		public function removeEvents():void
		{
			if(_removed)
			{
				return;
			}
			
			if(data)
			{
				if(data.needTooltip)
				{
					ToolTipManager.getInstance().detach(this);
				}
				
				if(isInteractive(data.type))
				{
					removeEventListener(MouseEvent.CLICK,clickHandler);
					removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
					removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
				}
			}
			
			_removed = true;
		}
		
		private function isInteractive(type:int):Boolean
		{
			if(type == LinkWord.TYPE_ITEM||
				type ==  LinkWord.TYPE_EQUIP||
				type ==  LinkWord.TYPE_ROLE_NAME ||
				type == LinkWord.TYPE_CUSTOM)
			{
				return true;
			}
			
			return false;
				
		}
		
		private function rollOverHandler(e:MouseEvent):void
		{
			if(!highlightFilter)
			{
				var colorFilter:ColorMatrixFilter=new ColorMatrixFilter();
				colorFilter.matrix = [1,0,0,0,100,
									  0,1,0,0,100,
									  0,0,1,0,100,
									  0,0,0,1,0];
				highlightFilter = [colorFilter];
			}
			this.filters = highlightFilter;
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			this.filters = null;
		}
		
		private var roleMenu:RoleMenu;
		private function clickHandler(e:MouseEvent):void
		{
			switch(data.type)
			{
				case LinkWord.TYPE_ROLE_NAME:
					if(data.getUnderline())
					{
						//弹出人物选项
						if(!roleMenu)
						{
							e.stopImmediatePropagation();
							roleMenu = new RoleMenu(new ChatHandler(data.toObject()));
							roleMenu.addEventListener(Event.SELECT,roleMenuSelectHandler);
							MenuMediator.instance.showMenu(roleMenu);
							
							roleMenu.x = e.stageX + 10;
							roleMenu.y = e.stageY - roleMenu.height - 10;
						}
						
					}
					break;
				case LinkWord.TYPE_CUSTOM:
					var event:String = data.getEventName();
					var eventData:String = data.getEventData();
					if(event)
					{
						ChatDataManager.instance.onClickCustomLink(event,eventData,e);
					}
			}
		}
		
		private function roleMenuSelectHandler(e:Request):void
		{
			roleMenu.removeEventListener(Event.SELECT,roleMenuSelectHandler);
			MenuMediator.instance.hideMenu(roleMenu);
			roleMenu = null;
			
//			var index:int = int(e.value);
//			
//			switch(index)
//			{
//				case 0://私聊
//					NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.changeInputChannel(MessageCfg.CHANNEL_PRIVATE);
//					NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.input.setPrivateTarget(data.toObject());
//					break;
//				case 2://加友
//					var friend:Object = data.toObject();
//					if(ContactDataManager.instance.requestAddContact(friend.sid,friend.cid,ContactType.FRIEND))
//					{
//						Alert.warning(StringConst.TIP_FRIEND_EXIST);
//					}
//					break;
//			}
		}
		
		
		public function getTipData():Object
		{
			if(data)
			{
				return data.getTooltipData();
			}
			else
			{
				return {};
			}
		}
		
		public function getTipType():int
		{
			if(data)
			{
				return data.getTooltipType();
			}
			
			return 0;
		}
		
		public function getTipCount():int
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
	}
}