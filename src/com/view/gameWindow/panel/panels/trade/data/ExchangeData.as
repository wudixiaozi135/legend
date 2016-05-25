package com.view.gameWindow.panel.panels.trade.data
{
	/**
	 * Created by Administrator on 2014/12/16.
	 * 玩家交易信息有改变，向交易对象广播
	 *     cid，本角色id，4字节有符号整形，
	 *   sid，本角色的服务器id，4字节有符号整形
	 *   name，本角色名，字符串形
	 *   vip，本角色vip等级，1字节有符号整形
	 *   reincarn，本角色转生次数，1字节有符号整形
	 *   level，本角色玩家等级，2字节有符号整形
	 *   job，本角色职业，1字节有符号整形
	 *   mapId，本角色玩家所在地图id，4字节有符号整形
	 *   x，本角色玩家所在地图格子x坐标，2字节有符号整形
	 *   y，本角色玩家所在地图格子y坐标，2字节有符号整形
	 *   bagfreecount，本角色交易角色的包裹空位，4字节有符号整形
	 */
	public class ExchangeData
	{
		public var cid:int = 0;
		public var sid:int = 0;
		public var name:String = null;
		public var vip:int = 0;
		public var reincarn:int = 0;
		public var level:int = 0;
		public var mapId:int = 0;
		public var bagFreeCount:int = 0;

		public function ExchangeData()
		{
		}
	}
}
