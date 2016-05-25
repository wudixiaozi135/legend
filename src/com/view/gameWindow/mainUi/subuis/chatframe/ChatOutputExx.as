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
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	
	
	/**
	 * @author wqhk
	 * 2014-3-6
	 * 
	 * 由两个队列改成多个队列
	 * 
	 * 聊天输出框
	 */
	public class ChatOutputExx extends Sprite implements IChatOutput
	{
		public static const MAX_HEIGHT:int = 4000;
		//		public static const MAX_LINK:int = 2000;
		public static const MAX_MESSAGE_ON_ONE_CHANNEL:int = 20;
		public static const MAX_MESSAGE_TOTAL_CHANNEL:int = 30;//不知为何设大后会有错误。 可能和getHeight函数有关
		public static const CHANNEL_COMPLEX:int = 0;
		public static const CHANNEL_TOTAL:int = 1111;
		public static const STORE_SYSTEM:int = 2000;
		private var inited:Boolean = false;
		
		private var currentMsgUnitList:DLinkedList;
		
		private var currentIndex:int = -1;
		private var ctner:Sprite;
		private var channelType:int = 0; //0 综合 1
		//		private var completeCallback:Function;
		private var showHandler:Function;
		private var createExpHandler:Function;
		private var maxNumMsgOnOneChannel:int; //未处理 不要忘了 。
		private var maxNumMsgTotal:int;
		private var currentIter:DListIterator;
		private var numMsgRecord:Dictionary;
		private var msgStore:Dictionary;
		
		public function ChatOutputExx(numOneChannel:int = 0,numTotal:int = 0)
		{
			super();
			
			msgStore = new Dictionary();
			
			maxNumMsgOnOneChannel = numOneChannel == 0 ? MAX_MESSAGE_ON_ONE_CHANNEL : numOneChannel;
			
			if(numOneChannel != 0 && numTotal < numOneChannel)
			{
				numTotal = numOneChannel;
			}
			
			maxNumMsgTotal = numTotal == 0 ? MAX_MESSAGE_TOTAL_CHANNEL : numTotal;
			
			ctner = new Sprite();
			addChild(ctner);
			
			currentMsgUnitList = getMsgList(CHANNEL_TOTAL);
			numMsgRecord = new Dictionary();
		}
		
		private function getMaxNumMsgOneChannel(type:int):int
		{
			if(CHANNEL_TOTAL == type)
			{
				return maxNumMsgTotal;
			}
			
			return maxNumMsgOnOneChannel;
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
		public function init(showHandler:Function):void
		{
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
			
			var iter:DListIterator;
			var msgUnit:MsgUnit;
			var index:int
			
			currentMsgUnitList = getMsgList(channelType == CHANNEL_COMPLEX ? CHANNEL_TOTAL : channelType);
			for(iter = currentMsgUnitList.getListIterator(); iter.valid();)
			{
				msgUnit = iter.data;
				
				if(!msgUnit || msgUnit.useCount == 0)
				{
					iter.remove();
				}
				else
				{
					iter.forth();
				}
			}
			
			numMsgRecord[channelType == CHANNEL_COMPLEX ? CHANNEL_TOTAL : channelType] = currentMsgUnitList.size;
			currentIter = currentMsgUnitList.getListIterator();
			tryShowMsg();
		}
		
		private function destroyMsg(msg:MsgUnit):void
		{
			if(msg.useCount > 0)
			{
				--msg.useCount;
			}
			
			if(msg.useCount == 0 && msg.messageView)
			{
				msg.messageView.destroy();
				msg.messageView = null;
			}
		}
		
		//滚动条需要用到
		public function getHeight():Number
		{
			if(currentMsgUnitList.isEmpty())
			{
				return 0;
			}
			
			var data:MsgUnit = currentMsgUnitList.tail.data;
			
			if(!data)
			{
				return 0;
			}
			
			var last:Message = data.messageView;
			
			if(!last)
			{
				return 0;
			}
			
			var iter:DListIterator = currentMsgUnitList.getListIterator();
			
			while(iter.valid() && !iter.data.messageView)
			{
				iter.forth();
			}
			
			var headY:int = iter.valid() ? iter.data.messageView.y : 0;
			
			var totalHeight:Number = last.y + last.totalHeight + MessageCfg.LINE_SPACE*2 - headY;
			ctner.y = -headY;
			
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
				msgUnit.color = color;
				
				appendMsg(msgUnit,CHANNEL_TOTAL);
				appendMsg(msgUnit,msgUnit.channelType);
				
				if(channelType == CHANNEL_COMPLEX || channelType == msgUnit.channelType)
				{
					if(!currentIter)
					{
						currentIter = currentMsgUnitList.getListIterator();
					}
					else if(!currentIter.valid())
					{
						currentIter.end();
					}
					
					tryShowMsg();
				}
			}
		}
		
		private function getMsgList(storeChannelKey:int):DLinkedList
		{
			if(!msgStore[storeChannelKey])
			{
				msgStore[storeChannelKey] = new DLinkedList();
			}
			
			return msgStore[storeChannelKey];
		}
		
		private function appendMsg(msgUnit:MsgUnit,storeChannelKey:int):void
		{
			var numMsg:int = int(numMsgRecord[storeChannelKey]);
			var maxMsg:int = getMaxNumMsgOneChannel(storeChannelKey);
			
			var list:DLinkedList = getMsgList(storeChannelKey);
			if(numMsg < maxMsg)
			{
				++numMsg;
				numMsgRecord[storeChannelKey] = numMsg;
			}
			else if(numMsg > 0)
			{
				var deleteMsgUnit:MsgUnit = null;
				for(var iter:DListIterator = list.getListIterator(); iter.valid();)
				{
					deleteMsgUnit = MsgUnit(iter.data);
					destroyMsg(deleteMsgUnit);
					iter.remove();
					break;
				}
			}
			msgUnit.useCount++;
			list.append(msgUnit);
		}
		
		private function tryShowMsg():void //以后改为遍历 
		{
			if(!inited)
			{
				return;
			}
			
			if(currentIter && currentIter.valid()&&currentMsgUnitList.size)
			{
				var data:MsgUnit = currentIter.data as MsgUnit;
				if(data)
				{
					if(!data.messageView)
					{
						data.messageView = createMsg(data.channelType,data.roughData,data.color);
					}
					
					if(data.messageView)
					{
						var preMsg:Message = null;
						
						if(currentIter.node != currentMsgUnitList.head)
						{
							currentIter.back();
							preMsg = currentIter.data.messageView;
							currentIter.forth();
						}
						
						showHandler(ctner,data.messageView, preMsg);
						
						data.messageView.addEvents();
					}
				}
				
				currentIter.forth();
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
	public var color:uint;
	public var useCount:int = 0;
}