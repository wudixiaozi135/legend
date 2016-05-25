package com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo
{
	public class DataLoongWarInfo
	{
		public static const POSITION_MAIN:int = 1;
		public static const POSITION_VICE:int = 2;
		public static const POSITION_GENERAL:int = 3;
		public static const POSITION_ZS:int = 4;
		public static const POSITION_FS:int = 5;
		public static const POSITION_DS:int = 6;
		
		public var cid:int;//  4字节有符号整形
		public var sid:int;//  4字节有符号整形
		public var namePlayer:String;//	utf8	名字
		public var sex:int;//  1字节有符号整形	性别
		public var level:int;// 4字节有符号整形 等级
		public var fightPower:int;// 4字节有符号整形 战斗力
		public var position:int;// 4字节有符号整形 沙城职位 1:城主 2:副城主 3:大将军 4:圣战 5:圣法 6:圣道
		public var clothesId:int;// 4字节有符号整形 衣服装备baseId
		public var weaponId:int;//  4字节有符号整形 武器装备baseId
		public var shieldId:int;//  4字节有符号整形 盾牌装备baseId

        /**0 时装,1斗笠，2足迹，3幻武*/
		public var fashionIds:Vector.<int>;
        public var wing:int;//翅膀
		
		public function DataLoongWarInfo()
		{
			fashionIds = new Vector.<int>();
		}
	}
}