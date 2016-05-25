package com.view.gameWindow.panel.panels.activitys.nightFight
{
	import com.model.consts.JobConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.util.UtilGetStrLv;

	public class DataNightFightRank
	{
		/**1字节有符号整形,当前排名，从1开始*/
		public var rank:int;
		/**4字节有符号整形，角色服务器id*/
		public var sid:int;
		/**4字节有符号整形，角色id*/
		public var cid:int;
		/**utf-8格式，角色名*/
		public var name:String;
		/**1字节有符号整形,转生*/
		public var reincarn:int;
		/**2字节有符号整形,等级*/
		public var level:int;
		/**1字节有符号整形,职业*/
		public var job:int;
		/**4字节有符号整形，积分*/
		public var score:int;
		/**非空*/
		public function get isNonNIL():Boolean
		{
			return sid != 0 && cid != 0;
		}
		
		public function get strName():String
		{
			return isNonNIL ? name : StringConst.PLACEHOLDER;
		}
		
		public function get strLv():String
		{
			var strReincarnLevel:String = UtilGetStrLv.strReincarnLevel(reincarn,level);
			return isNonNIL ? strReincarnLevel : StringConst.PLACEHOLDER;
		}
		
		public function get strJob():String
		{
			var jobName:String = JobConst.jobName(job);
			return isNonNIL ? jobName : StringConst.PLACEHOLDER;
		}
		
		public function get strScore():String
		{
			return isNonNIL ? score+"" : StringConst.PLACEHOLDER;
		}
		
		public function get textColor():uint
		{
			if(rank == 1)
			{
				return 0xe616b6;
			}
			else if(rank == 2)
			{
				return 0x00a2ff;
			}
			else if(rank == 3)
			{
				return 0x53b436;
			}
			else
			{
				return 0xd4a460;
			}
		}
		
		public function DataNightFightRank()
		{
		}
	}
}