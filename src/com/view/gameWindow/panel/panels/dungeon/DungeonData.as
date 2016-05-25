package com.view.gameWindow.panel.panels.dungeon
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;

	public class DungeonData
	{
		private var _type : int;
		private var _id : int;
		private var _count : int;
		private var _icon:String;
		
		public function DungeonData()
		{
		}

		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}

		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}
		
		public var dgnId:int;//4字节有符号整形，副本id
		public var daily_enter_count:int;//1字节有符号整形，当日进入次数
		public var daily_complete_count:int;//1字节有符号整形，当日完成次数
		public var online_cleared:int; //1表示已清除过在线等待时间，0表示没有
		public function get dungeonCfgData():DungeonCfgData
		{
			var cfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dgnId);
			return cfgDt;
		}
	}
}