package com.view.gameWindow.panel.panels.task.linkText.item
{
	public class LinkTextItem
	{
		public static const TYPE_TO_MAP:int = 1;
		public static const TYPE_TO_NPC:int = 2;
		public static const TYPE_TO_MONSTER:int = 3;
		public static const TYPE_TO_PLANT:int = 4;
		public static const TYPE_TO_DUNGEON : int = 5;
		public static const TYPE_TO_OPEN_PANEL : int = 6;
		public static const TYPE_TO_SHOW_ITEM_TIP : int = 7;
		public static const TYPE_TO_MAP_MINE : int = 8;
		public static const TYPE_TO_TELEPORT : int = 9;
		public static const TYPE_TO_MAPREGION : int = 10;
		
		private var _type:int;
		
		private var _mapId:int;
		private var _xPos:int;
		private var _yPos:int;
		
		private var _npcId:int;
		private var _monsterId:int;
		private var _plantId:int;
		private var _regionId:int;
		
		private var _kingdomID:int;
		
		private var _dungeonId : int;
		private var _teleportId:int;
		private var _mapRegion:int;
		
		private var _panelName : String;
		private var _panelId : int;
		private var _panelPage : int;
		
		private var _itemid:int;
        private var _subTabIndex:int;//子标签页

		public function get mapRegion():int
		{
			return _mapRegion;
		}

		public function set mapRegion(value:int):void
		{
			_mapRegion = value;
		}

		public function get panelId():int
		{
			return _panelId;
		}

		public function set panelId(value:int):void
		{
			_panelId = value;
		}

		public function get type():int
		{
			return _type;
		}
		
		public function get mapId():int
		{
			return _mapId;
		}
		
		public function get xPos():int
		{
			return _xPos;
		}
		
		public function get yPos():int
		{
			return _yPos;
		}
		
		public function get npcId():int
		{
			return _npcId;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		public function set mapId(value:int):void
		{
			_mapId = value;
		}
		
		public function set xPos(value:int):void
		{
			_xPos = value;
		}
		
		public function set yPos(value:int):void
		{
			_yPos = value;
		}
		
		public function set npcId(value:int):void
		{
			_npcId = value;
		}
		public function get monsterId():int
		{
			return _monsterId;
		}
		
		public function set monsterId(value:int):void
		{
			_monsterId = value;
		}
		
		public function get plantId():int
		{
			return _plantId;
		}
		
		public function set plantId(value:int):void
		{
			_plantId = value;
		}
		
		public function get kingdomID():int
		{
			return _kingdomID;
		}
		
		public function set kingdomID(value:int):void
		{
			_kingdomID=value;
		}

		public function get dungeonId():int
		{
			return _dungeonId;
		}

		public function set dungeonId(value:int):void
		{
			_dungeonId = value;
		}

		public function get panelName():String
		{
			return _panelName;
		}

		public function set panelName(value:String):void
		{
			_panelName = value;
		}

		public function get panelPage():int
		{
			return _panelPage;
		}

		public function set panelPage(value:int):void
		{
			_panelPage = value;
		}

		public function get itemid():int
		{
			return _itemid;
		}

		public function set itemid(value:int):void
		{
			_itemid = value;
		}

		public function get regionId():int
		{
			return _regionId;
		}

		public function set regionId(value:int):void
		{
			_regionId = value;
		}
		
		public function get teleportId():int
		{
			return _teleportId;
		}
		
		public function set teleportId(value:int):void
		{
			_teleportId = value;
		}

        public function get subTabIndex():int
        {
            return _subTabIndex;
        }

        public function set subTabIndex(value:int):void
        {
            _subTabIndex = value;
        }
    }
}