package com.view.gameWindow.panel.panels.activitys.loongWar.tabApply
{
	import com.model.consts.StringConst;

	public class DataLoongWarApplyGuild
	{
		public var familyName:String = "";// utf8
		public var familyId:int;//  4字节有符号整形  
		public var familySid:int;// 4字节有符号整形
		public var familyIdLeague:int;//  4字节有符号整形    联盟的帮会id  if（familyIdLeague == familyId）就是盟主帮  
		public var familySidLeague:int;//  4字节有符号整形   联盟的帮会sid
		public var familyNameLeague:String = "";// utf   联盟的帮会名称
		/**完整联盟名称*/
		public function get familyNameLeagueFull():String
		{
			var str:String = familyNameLeague ? "("+familyNameLeague+StringConst.LOONG_WAR_0068+")" : "";
			return str;
		}
		/**是否为盟主帮*/
		public function get isLeader():Boolean
		{
			return familySidLeague && familyIdLeague && familySid == familySidLeague && familyId == familyIdLeague;
		}
		
		public var textColor:int;
		
		public function DataLoongWarApplyGuild()
		{
		}
	}
}