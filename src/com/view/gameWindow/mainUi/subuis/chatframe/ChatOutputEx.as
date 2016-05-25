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
	import de.polygonal.ds.DListNode;
	
	
	/**
	 * @author wqhk
	 * 2014-2-13
	 * 
	 * 2.13优化 聊天加各频道的消息数量限制
	 * 
	 * 聊天输出框
	 */
	public class ChatOutputEx extends Sprite implements IChatOutput
	{
		public static const MAX_HEIGHT:int = 4000;
//		public static const MAX_LINK:int = 2000;
		public static const MAX_MESSAGE_ON_ONE_CHANNEL:int = 20;
		public static const MAX_MESSAGE_TOTAL_CHANNEL:int = 50;//不知为何设大后会有错误。 可能和getHeight函数有关
		public static const CHANNEL_COMPLEX:int = 0;
		public static const CHANNEL_TOTAL:int = 1111;
		public static const STORE_SYSTEM:int = 2000;
		private var inited:Boolean = false;
		//		private var msgUnitList:Vector.<MsgUnit>;
		private var msgUnitList:DLinkedList;
		//		private var currentMsgUnitList:Vector.<MsgUnit>;
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
		
		public function ChatOutputEx(numOneChannel:int = 0,numTotal:int = 0)
		{
			super();
			
			maxNumMsgOnOneChannel = numOneChannel == 0 ? MAX_MESSAGE_ON_ONE_CHANNEL : numOneChannel;
			
			if(numOneChannel != 0 && numTotal < numOneChannel)
			{
				numTotal = numOneChannel;
			}
			
			maxNumMsgTotal = numTotal == 0 ? MAX_MESSAGE_TOTAL_CHANNEL : numTotal;
			
			ctner = new Sprite();
			addChild(ctner);
			
			msgUnitList = new DLinkedList();
			currentMsgUnitList = new DLinkedList();
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
			
			currentMsgUnitList.clear();
			
			var iter:DListIterator;
			var msgUnit:MsgUnit;
			var index:int
			if(channelType == CHANNEL_COMPLEX)
			{
				var numSystem:int = 0;
				var maxSystem:int = getMaxNumMsgOneChannel(MessageCfg.CHANNEL_SYSTEM);
				for(iter = msgUnitList.getListIterator(); iter.valid();)
				{
					msgUnit = iter.data;
					
					if(msgUnit.isDestroy)
					{
						iter.remove();
					}
					else
					{
						if(msgUnit.channelType == MessageCfg.CHANNEL_SYSTEM)
						{
							++numSystem;
						}
						
						var curNode:DListNode = currentMsgUnitList.append(iter.data);
						iter.forth();
					}
				}
				
				//自动删除多的系统消息 因为系统消息没有单独的频道
				if(numSystem > maxSystem)
				{
					index = numSystem - maxSystem;
					iter = currentMsgUnitList.getListIterator();
					while(iter.valid() && index > 0)
					{
						if(iter.data.channelType == MessageCfg.CHANNEL_SYSTEM)
						{
							destroyMsg(iter.data);
							iter.remove();
							--index;
						}
						else
						{
							iter.forth();
						}
					}
				}
			}
			else
			{
				for(iter = msgUnitList.getListIterator(); iter.valid(); iter.forth())
				{
					var msg:MsgUnit = iter.data as MsgUnit;
					if(msg && msg.channelType == channelType)
					{
						currentMsgUnitList.append(iter.data);
					}
				}
			}
			
			var maxMsg:int = getMaxNumMsgOneChannel(channelType == CHANNEL_COMPLEX ? CHANNEL_TOTAL : channelType);
			var numMsg:int = currentMsgUnitList.size;
			index = numMsg - maxMsg;
			iter = currentMsgUnitList.getListIterator();
			
			//清掉超出的message
			while(index > 0 && iter.valid())
			{
				destroyMsg(iter.data,channelType != CHANNEL_COMPLEX);
				iter.remove();
				--index;
			}
			
			numMsgRecord[channelType == CHANNEL_COMPLEX ? CHANNEL_TOTAL : channelType] = currentMsgUnitList.size;
			currentIter = currentMsgUnitList.getListIterator();
			tryShowMsg();
		}
		
		private function destroyMsg(msg:MsgUnit,isAbs:Boolean = true):void
		{
			if(isAbs)
			{
				msg.isDestroy = true;
			}
			
			if(msg.messageView)
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
//				msgUnit.messageView = createMsg(msgUnit.channelType,msgUnit.roughData,msgUnit.color);
				
//				if(msgUnit.messageView)
//				{
					//加入数据
					msgUnitList.append(msgUnit);
					
					var numMsg:int;
					var maxMsg:int;
					if(channelType == CHANNEL_COMPLEX)
					{
						appendCurrentMsg(msgUnit,CHANNEL_TOTAL,currentMsgUnitList,false);
						
						numMsg = int(numMsgRecord[CHANNEL_TOTAL]);
						maxMsg = getMaxNumMsgOneChannel(CHANNEL_TOTAL);
						if(numMsg < maxMsg)
						{
							numMsgRecord[CHANNEL_TOTAL] = ++numMsg;
						}
						
						//
						if(!currentIter)
						{
							currentIter = currentMsgUnitList.getListIterator();
						}
						else if(!currentIter.valid())
						{
							currentIter.end();
						}
					}
					else if(channelType == msgUnit.channelType)
					{
						appendCurrentMsg(msgUnit,channelType,currentMsgUnitList,true);
						
						numMsg = int(numMsgRecord[channelType]);
						maxMsg = getMaxNumMsgOneChannel(channelType);
						if(numMsg < maxMsg)
						{
							numMsgRecord[channelType] = ++numMsg;
						}
						
						//
						if(!currentIter)
						{
							currentIter = currentMsgUnitList.getListIterator();
						}
						else if(!currentIter.valid())
						{
							currentIter.end();
						}
					}
					
					
//				}
				
				//
				tryShowMsg();
			}
		}
		
		private function appendCurrentMsg(msgUnit:MsgUnit,curChannelType:int,list:DLinkedList,needDestroy:Boolean):void
		{
			var numMsg:int = int(numMsgRecord[curChannelType]);
			var maxMsg:int = getMaxNumMsgOneChannel(curChannelType);
			
			var deleteMsgUnit:MsgUnit = null;
			if(numMsg >= maxMsg)
			{
				for(var iter:DListIterator = list.getListIterator(); iter.valid();)
				{
					deleteMsgUnit = MsgUnit(iter.data);
					destroyMsg(deleteMsgUnit,needDestroy);
					iter.remove();
					break;
				}
			}
			
			list.append(msgUnit);
		}
		
//		/**
//		 * @return isRemoved
//		 */
//		private function appendMsg(msgUnit:MsgUnit,curChannelType:int,list:DLinkedList,needDestroy:Boolean):void
//		{
//			var numMsg:int = int(numMsgRecord[curChannelType]);
//			var maxMsg:int = getMaxNumMsgOneChannel(curChannelType);
//			
//			var deleteMsgUnit:MsgUnit = null;
//			if(numMsg >= maxMsg)
//			{
//				for(var iter:DListIterator = list.getListIterator(); iter.valid();)
//				{
//					deleteMsgUnit = MsgUnit(iter.data);
//					
//					if(deleteMsgUnit.messageView)
//					{
//						deleteMsgUnit.messageView.destroy();
//						deleteMsgUnit.messageView = null;
//					}
//					else if(needDestroy)
//					{
//						iter.forth();
//						continue;
//					}
//					
//					if(needDestroy)
//					{
//						deleteMsgUnit.isDestroy = true;
//						iter.remove();
//					}
//					else
//					{
//						iter.forth();
//					}
//					
//					break;
//				}
//			}
//			
//			list.append(msgUnit);
//		}
		
		
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
	public var isDestroy:Boolean = false;
}