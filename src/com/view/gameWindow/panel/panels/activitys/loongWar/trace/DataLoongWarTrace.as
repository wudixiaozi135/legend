package com.view.gameWindow.panel.panels.activitys.loongWar.trace
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;

	public class DataLoongWarTrace
	{
		public static const TYPE_NONE:int = 0;
		public static const TYPE_FAMILY:int = 1;
		public static const TYPE_UNION:int = 2;
		
		/**帮派名字 （"" 无所属）*/
		public var familyName:String;// utf8 
		/**0.当前无所属 1.单独的帮会 2.是联盟的*/
		public var type:int;// 1字节有符号整形 
		/**完成帮会名称*/
		public function get familyNameFull():String
		{
			var str:String = "";
			switch(type)
			{
				case TYPE_NONE:
					str = StringConst.SCHOOL_PANEL_00331;
					break;
				case TYPE_FAMILY:
					str = familyName;
					break;
				case TYPE_UNION:
					str = familyName + StringConst.LOONG_WAR_0068;
					break;
				default:
					break;
			}
			return str;
		}
		/**类型文字*/
		public function get textType():String
		{
			var str:String = "";
			switch(type)
			{
				case TYPE_NONE:
				case TYPE_FAMILY:
					str = StringConst.LOONG_WAR_TRACE_0001 +　StringConst.LOONG_WAR_TRACE_0002;
					break;
				case TYPE_UNION:
					str = StringConst.LOONG_WAR_TRACE_0001 +　StringConst.LOONG_WAR_TRACE_0003;
					break;
				default:
					break;
			}
			return str;
		}
		/**占领的时间点*/
		public var time:int;//  4字节有符号整形   
		/**占领时间文本*/
		public function get textOccupyTime():String
		{
			if(!time)
			{
				return StringConst.SCHOOL_PANEL_00331;
			}
			var second:int = ServerTime.time - time;
			return TimeUtils.format(TimeUtils.calcTime(second));
		}
		/**区域经验倍数*/
		public var expRatio:Number = 1;
		/**累计经验*/
		public var exp:int;// 4字节有符号整形 
		/**帮会排行列表*/
		public var dtsFamilyRank:Vector.<DataLoongWarFamilyRank>;
		/**个人积分*/
		public var score:int;//  4字节有符号整形   
		/**个人当前排名*/
		public var rank:int;// 4字节有符号整形  
		
		public function DataLoongWarTrace()
		{
			dtsFamilyRank = new Vector.<DataLoongWarFamilyRank>();
		}
	}
}