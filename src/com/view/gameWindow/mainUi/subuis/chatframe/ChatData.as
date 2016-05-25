package com.view.gameWindow.mainUi.subuis.chatframe
{
	
	/**
	 * @author wqhk
	 * 2014-8-9
	 * 
	 * 	channel，为1字节有符号整形，频道
		cid，4字节有符号整形，角色id
		sid，4字节有符号整形，服务器id
		sex，1字节有符号整形，性别
		name，utf-8，玩家名字
	 */
	public class ChatData
	{
		public var channel:int;
		public var cid:int;
		public var sid:int;
		public var sex:int;
		public var name:String;
		public var buff:String;
		
		public var toCid:int;
		public var toSid:int;
		public var toSex:int;
		public var toName:String;
		public var color:uint = 0;
	}
}