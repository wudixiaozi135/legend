package com.model.consts
{
	public class DungeonConst
	{
		public static const DGN_ID_TOWER:int = 541;
		public static const DGN_ID_PRIVATE_BOSS1:int = 701;
		public static const DGN_ID_PRIVATE_BOSS2:int = 702;
		public static const DGN_ID_PRIVATE_BOSS3:int = 703;
		public static const DGN_ID_PRIVATE_BOSS4:int = 704;
		
		public static const DUNGEON_SINGLE:int = 1;
		public static const DUNGEON_TEAM:int = 2;
		
		public static const RESULT_TYPE_NONE:int = 0;
		public static const RESULT_TYPE_EQUIP:int = 1;
		public static const RESULT_TYPE_MONEY:int = 2;
		public static const RESULT_TYPE_EXP:int = 3;
		public static const RESULT_TYPE_MATERIAL:int = 4;
		
		public static const FUNC_TYPE_NORMAL:int = 1;
		public static const FUNC_TYPE_TOWER:int = 2;
		public static const FUNC_TYPE_PRIVATE:int = 3;
		public static const FUNC_TYPE_MAIN:int = 4;
		public static const FUNC_TYPE_REINCARN:int = 5;
		public static const FUNC_TYPE_MAIN_TOWER:int = 6;
		public static const FUNC_TYPE_SPECIAL_RING:int = 8;
		
		public static const CONTENT_TYPE_MIAN:int = 1;
		public static const CONTENT_TYPE_BOSS:int = 2;
		public static const CONTENT_TYPE_REINCARN:int = 3;
		public static const CONTENT_TYPE_SINGLE_TOWER:int = 4;
		public static const CONTENT_TYPE_TEAM_TOWER:int = 5;
		public static const CONTENT_TYPE_GANG:int = 6;
		public static const CONTENT_TYPE_BABEL:int = 7;
		public static const CONTENT_TYPE_VIP:int = 8;
		public static const CONTENT_TYPE_SPCIAL_RING:int = 9;
		public static const CONTENT_TYPE_HERO_UP:int = 10;
		
		/**
		 * dungeon_event  trigger_type
		 */
		public static const TRIGGER_TIME:int = 1;
		public static const TRIGGER_KILL_MULTI_M:int = 2;
		public static const TRIGGER_KILL_SINGLE_RATE:int = 3;
		public static const TRIGGER_KILL_SINGLE_M_LIMIT:int = 4;
		public static const TRIGGER_KILL_SINGLE_RATE_LIMIT:int = 5;
		public static const TRIGGER_TRAP_MULTI:int = 6;
		public static const TRIGGER_ITEM:int = 7;
		public static const TRIGGER_COLLECT:int = 8;
		public static const TRIGGER_REGION:int = 9;
		
		public static const TRIGGER_EVENT_ADD_MONSTERS:int = 3;
		
		public function DungeonConst()
		{
			
		}
		
		public static function getType(type:int):String
		{
			return "";
		}
		
		public static function getResultType(type:int):String
		{
			var str:String;
			switch(type)
			{
				case RESULT_TYPE_EQUIP:
					str = StringConst.DUNGEON_PANEL_0013;
					break;
				case RESULT_TYPE_MONEY:
					str = StringConst.DUNGEON_PANEL_0014;
					break;
				case RESULT_TYPE_EXP:
					str = StringConst.DUNGEON_PANEL_0015;
					break;
				case RESULT_TYPE_MATERIAL:
					str = StringConst.DUNGEON_PANEL_0016;
					break;
				default :
					break;
			}
			return str;
		}
	}
}