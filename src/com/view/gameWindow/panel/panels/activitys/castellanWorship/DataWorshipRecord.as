package com.view.gameWindow.panel.panels.activitys.castellanWorship
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.util.TimeUtils;

	/**
	 * 膜拜操作数据类
	 * @author Administrator
	 */	
	public class DataWorshipRecord
	{
		/**时间*/
		public var time:int;//       4字节有符号整形  
		/**操作时刻*/
		public function get strTime():String
		{
			var str:String = TimeUtils.getTimeStrByStyle(time*1000);
			return str;
		}
		/**帮会名称*/
		public var familyName:String;// utf8             
		/**玩家名字*/
		public var name:String;//	   utf8
		/**4:养护  5:泼硫酸*/
		public var type:int;//       1字节有符号整形  
		/**雕像尊严值的变化*/
		public var value:int;//      4字节有符号整形  
		
		public function get strInfos():String
		{
			var textType:String = DataWorshipInfo.textType(type);
			var textChange:String = value > 0 ? StringConst.WORSHIP_INFOS_0005 : StringConst.WORSHIP_INFOS_0006;
			var textChangeValue:String = Math.abs(value) + StringConst.WORSHIP_INFOS_0007;
			var str:String = StringConst.WORSHIP_INFOS_0004.replace("&a",familyName).replace("&b",name).replace("&c",textType).replace("&d",textChange).replace("&e",textChangeValue);
			return str;
		}
		
		public function DataWorshipRecord()
		{
		}
	}
}