package com.view.gameWindow.panel.panels.rank.data
{
	public class RankMemberData
	{
		public function RankMemberData()
		{

		}
		
		public var rank:int//2字节有符号整形，排行，（真正的排行，从1开始）
		public var sid:int//4字节有符号整形，服务器id
		public var cid:int//4字节有符号整形，角色id
		public var name:String//utf-8格式，玩家名
		public var reincarn:int//1字节有符号整形，转生数
		public var level:int//2字节有符号整形，等级
		public var job:int//1字节有符号整形，职业
		public var familySid:int//4字节有符号整形，家族的服务器id
		public var familyId:int//4字节有符号整形，家族id
		public var familyName:String//utf-8格式，家族名
		public var vip:int//1字节有符号整形，vip等级
		public var sex:int;
		public var attackPower:int;
		public var position:int;
		public var unbindCoin:int;
		public var isOnLine:int;
	}
}