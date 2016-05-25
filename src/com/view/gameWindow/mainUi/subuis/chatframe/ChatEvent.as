package com.view.gameWindow.mainUi.subuis.chatframe
{
	
	/**
	 * @author wqhk
	 * 2015-2-3
	 */
	public class ChatEvent
	{
		public static const TRAILER_MEMBER_HELP:String = "trailerMemberHelp";
		public static const OPENPANEL:String = "openPanel";
		public static const CIDMENU:String = "cidMenu";
		public static const FLYSTALL:String = "flyStall";
		public static const STALL:String = "stall";
		public static const EQUIP:String = "equip";
		public static const BASEEQUIP:String = "baseEquip";
		public static const FLYMAP:String = "flyMap";
		public static const FLYNPC:String = "flyNPC";
		
		public static function createTrailerMemberHelpEventData(cid:int,sid:int):String
		{
			return cid + "|" + sid;
		}
		
		public static function parseData(txt:String):Array
		{
			if(txt)
			{
				return txt.split("|");
			}
			else
			{
				return null;
			}
		}
	}
}