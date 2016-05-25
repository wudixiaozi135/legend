package com.view.gameWindow.panel.panels.school.simpleness
{
	public class SchoolBasicData
	{
		public function SchoolBasicData()
		{
		}
		
		public var schoolId:int;
		public var schoolSid:int;
		public var schoolName:String;
		public var schoolPosition:int;
		/**是否为正副帮主*/
		public function get isMainViceLeader():Boolean
		{
			return schoolPosition == 1 || schoolPosition == 2;
		}
		/**是否为帮主*/
		public function get isMainLeader():Boolean
		{
			return schoolPosition == 1;
		}
		
		public function isSameFamily(id:int,sid:int):Boolean
		{
			return schoolId == id && schoolSid == sid;
		}
	}
}