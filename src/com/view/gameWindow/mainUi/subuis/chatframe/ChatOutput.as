package com.view.gameWindow.mainUi.subuis.chatframe
{
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.IMessageFactory;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.Message;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.MessageFactory;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.MessageFactoryArea;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.MessageFactoryLoud;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.MessageFactoryNotice;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.MessageFactoryPrivate;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.MessageFactoryWorld;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.utils.Dictionary;
	
	
	/**
	 * @author wqhk
	 * 2014-8-7
	 * 
	 * 聊天输出框
	 */
	public class ChatOutput extends Sprite implements IChatOutput
	{
		private var inited:Boolean = false;
		
		private var msgUnitList:Vector.<MsgUnit>;
		private var currentMsgUnitList:Vector.<MsgUnit>;
		
		private var currentIndex:int = -1;
		private var ctner:Sprite;
		private var channelType:int = 0; //0 综合 1
//		private var completeCallback:Function;
		private var showHandler:Function;
		private var createExpHandler:Function;
		public static const MAX_HEIGHT:int = 2000;
		public static const MAX_LINK:int = 1000;
		public static const MAX_MESSAGE_ON_ONE_CHANNEL:int = 500;
		private var maxLine:int; //未处理 不要忘了 。
		public function ChatOutput(maxLine:int = 0)
		{
			super();
			
			this.maxLine = maxLine;
			ctner = new Sprite();
			addChild(ctner);
			
			msgUnitList = new Vector.<MsgUnit>();
			currentMsgUnitList = new Vector.<MsgUnit>();
		}
		
		/**
		 * @inherit
		 */
		public function setExpCreateFunc(createHandler:Function):void
		{
			createExpHandler = createHandler;
			
			MessageFactory.createExpressionHandler = createExpHandler;
		}
		
		/**
		 * showHandler(ctner:DisplayObjectContainer,currentMsg:Message,lastMsg:Message):void
		 */
		public function init(showHandler:Function/*callback:Function*/):void
		{
//			completeCallback = callback;
//			MessageCfg.initImg(initImgComplete);
			this.showHandler = showHandler;
			
			initImgComplete();
		}
		
		public function get view():DisplayObject
		{
			return this;
		}
		
		public function changeChannel(type:int):void
		{
			while(ctner.numChildren)
			{
				ctner.removeChildAt(0);
			}
			ctner.y = 0;
			channelType = type;
			
			currentMsgUnitList = new Vector.<MsgUnit>();
			
			if(channelType == 0)
			{
				currentMsgUnitList = msgUnitList.concat();
				
			}
			else
			{
				for each(var msg:MsgUnit in msgUnitList)
				{
					if(msg && msg.channelType == channelType)
					{
						currentMsgUnitList.push(msg);
					}
				}
				
			}
			
			currentIndex = -1;
			tryShowMsg();
		}
		
		//滚动条需要用到
		public function getHeight():Number
		{
			if(!currentMsgUnitList || currentMsgUnitList.length == 0)
				return 0;
			
			var last:Message = currentMsgUnitList[currentMsgUnitList.length - 1].messageView;
			var totalHeight:Number = last.y + last.totalHeight + MessageCfg.LINE_SPACE*2;
			
			if(totalHeight>MAX_HEIGHT)
			{
				ctner.y = MAX_HEIGHT - totalHeight;
				return MAX_HEIGHT;
			}
			
			return totalHeight;
		}
		
		public function pushData(data:String,color:uint = 0):void
		{
			var pattern:RegExp = /^\/(\d+) (.*)$/;
			var result:Object = pattern.exec(data);
			
			if(result)
			{
				var msgUnit:MsgUnit = new MsgUnit();
				msgUnit.channelType = result[1];
				msgUnit.roughData = result[2];
				msgUnit.messageView = createMsg(msgUnit.channelType,msgUnit.roughData,color);
				
				if(msgUnit.messageView)
				{
					msgUnitList.push(msgUnit);
					
					if(channelType == 0 || channelType == msgUnit.channelType)
					{
						currentMsgUnitList.push(msgUnit);
					}
				}
				
				tryShowMsg();
			}
		}
		
		
		private function tryShowMsg():void //以后改为遍历 
		{
			if(inited && currentMsgUnitList.length>0
							&& currentIndex<currentMsgUnitList.length-1)
			{
				++currentIndex;
			
				var msg:Message = currentMsgUnitList[currentIndex].messageView;
				
				showHandler(ctner,msg,currentIndex == 0 ? null : currentMsgUnitList[currentIndex-1].messageView);
				
				msg.addEvents();
				
				if(currentIndex >  MAX_LINK)
				{
					currentMsgUnitList[currentIndex - MAX_LINK].messageView.removeEvents();
				}
				
				tryShowMsg();
			}
		}
		
		private function createMsg(type:int,msgData:String,color:uint = 0):Message
		{
			var msg:Message;
			var fac:IMessageFactory;
			switch(type)
			{
				case MessageCfg.CHANNEL_SYSTEM:
					fac = new MessageFactoryNotice();
					break;
				case MessageCfg.CHANNEL_WOLD:
					fac = new MessageFactoryWorld();
					break;
				case MessageCfg.CHANNEL_AREA:
					fac = new MessageFactoryArea();
					break;
				case MessageCfg.CHANNEL_WOLD_SUPER:
					fac = new MessageFactoryLoud();
					break;
				case MessageCfg.CHANNEL_PRIVATE:
					fac = new MessageFactoryPrivate();
					break;
				case MessageCfg.CHANNEL_FAMILY:
					fac = new MessageFactoryWorld();
					break;
				case MessageCfg.CHANNEL_TEAM:
					fac = new MessageFactoryWorld();
					break;
			}
			
			if(fac)
			{
				msg = fac.createMessage(msgData,type,color);
			}
			
			return msg;
		}
		
		private function initImgComplete():void
		{
			inited = true;
//			if(completeCallback!=null)
//			{
//				completeCallback();
//			}
			tryShowMsg();
		}
	}
}

import com.view.gameWindow.mainUi.subuis.chatframe.msg.Message;

class MsgUnit
{
	public var channelType:int;
	public var roughData:String;
	public var messageView:Message;
}