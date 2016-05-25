package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.util.ServerTime;
	
	import flash.utils.Dictionary;

	public class ActivityCfgData
	{
		public var id:int;//11	序列
		public var name:String;//16	活动名
		public var type:int;//11	活动类型1:日常活动2:非日常活动
		public var func_type:int;
		public var reincarn:int;//11	转生次数
		public var level:int;//11	玩家等级
		public var npc:int;//11	传送npc
		public var born_region:int;//11	出生区域
		public var region:int;//11	活动区域
		public var exp:int;//11	经验奖励
		public var bind_coin:int;//11	绑定金币奖励
		public var reward:String;//64	实际奖励
		public var reward_view:String;//64	显示奖励
		public var week:int;//11	星期
		private var _vctDays:Vector.<Boolean>;
		/**0 代表星期日，1 代表星期一，依此类推*/
		public function get vctDays():Vector.<Boolean>
		{
			var days:Array = week.toString().split("");
			var i:int,l:int = days.length;
			//
			var isFirstLWDayOver:Boolean = ServerTime.isFirstLWDayOver;
			var firstLWDay:int = ServerTime.firstLWDay;
			if(!_vctDays)
			{
				_vctDays = new Vector.<Boolean>(7,true);
			}
			else
			{
				_vctDays.forEach(function (item:*, index:int, vector:Vector.<Boolean>):void
				{
					vector[index] = false;
				});
			}
			for(i=0;i<l;i++)
			{
				var index:int = days[i] == 7 ? 0 : days[i];
				if(!isFirstLWDayOver && func_type == ActivityFuncTypes.AFT_LOONG_WAR && index < firstLWDay)//删除第一次龙城活动前的活动日
				{
					continue;
				}
				if(!isFirstLWDayOver && func_type == ActivityFuncTypes.AFT_NIGHT_FIGHT && firstLWDay == index)//比奇夜战与龙城争霸冲突时，取消当日的比奇夜战活动
				{
					continue;
				}
				_vctDays[index] = true;
			}
			if(!isFirstLWDayOver && func_type == ActivityFuncTypes.AFT_LOONG_WAR)//插入第一次龙城活动的活动日
			{
				_vctDays[firstLWDay] = true;
			}
			return _vctDays;
		}
		
		public var begin_day:int;//11	起始日期
		public var end_day:int;//11	结束日期
		//public var start_time:int;//11	开始时间(分钟)
		//public var duration:int;//11	持续时间(分钟)
		public var desc:String;//256	玩法描述
		
		public function get start_time_str():String
		{
			var str:String = "";
			/*var count:int;
			var i:int,l:int = vctDays.length;
			str = StringConst.WEEK;//星期不在显示
			for(i=0;i<l;i++)
			{
				if(vctDays[i])
				{
					str += StringConst["WEEK"+i] + (i == l-1 ? "" : "、");
					count++;
				}
			}
			if(count == 7)
			{
				str = StringConst.EVERY_DAY;
			}*/
			str += today_start_to_end;
			return str;
		}
		
		public function get today_start_to_end():String
		{
			return currentActvTimeCfgDtToEnter.today_start_to_end;
		}
		
		public function get isEnterOpen():Boolean
		{
			if(secondToEnter <= 0 && secondToEnter != int.MIN_VALUE)
			{
				return true;
			}
			return false;
		}
		
		public function get isInActv():Boolean
		{
			if(secondToStart <= 0 && secondToStart != int.MIN_VALUE)
			{
				return true;
			}
			return false;
		}
		/**正数表示到该活动开始时刻的秒数，负数表示该活动开始的秒数，正最大值表示今日无该活动，负最大值表示活动已结束*/
		public function get secondToStart():int
		{
			if(vctDays[ServerTime.date.day])
			{
				return currentActvTimeCfgDtToStart.secondToStart;
			}
			return int.MAX_VALUE;
		}
		/**正数表示到该活动开始时刻的秒数，负数表示该活动开始的秒数，正最大值表示今日无该活动，负最大值表示活动已结束*/
		public function get secondToEnter():int
		{
			if(vctDays[ServerTime.date.day])
			{
				return currentActvTimeCfgDtToEnter.secondToEnter;
			}
			return int.MAX_VALUE;
		}
		/**剩余的描述，正最大值表示今日无该活动*/
		public function get secondRemain():int
		{
			if(vctDays[ServerTime.date.day])
			{
				return currentActvTimeCfgDtToStart.secondRemain;
			}
			return int.MAX_VALUE;
		}
		
		public function get actvMapRegionCfgDts():Dictionary
		{
			var cfgDts:Dictionary = ConfigDataManager.instance.activitytMapRegionCfgDatas(id);
			return cfgDts;
		}
		/**是否在活动区域内*/
		public function isIn(tileX:int, tileY:int):Boolean
		{
			var isIn:Boolean;
			var cfgDt:ActivityMapRegionCfgData;
			for each(cfgDt in actvMapRegionCfgDts)
			{
				isIn ||= cfgDt.isIn(tileX,tileY)
			}
			return isIn;
		}
		
		public function get mapIds():Vector.<int>
		{
			var vector:Vector.<int> = new Vector.<int>();
			var cfgDt:ActivityMapRegionCfgData;
			for each(cfgDt in actvMapRegionCfgDts)
			{
				vector.push(cfgDt.map_id);
			}
			return vector;
		}
		
		public function get actvTimeCfgDts():Dictionary
		{
			var activityTimeCfgDatas:Dictionary = ConfigDataManager.instance.activityTimeCfgDatas(id);
			return activityTimeCfgDatas;
		}
		
		public function get currentActvTimeCfgDtToStart():ActivityTimeCfgData
		{
			var actvTimeCfgDt:ActivityTimeCfgData,minActvTimeCfgDt:ActivityTimeCfgData;
			for each (actvTimeCfgDt in actvTimeCfgDts)
			{
				var boolean:Boolean = actvTimeCfgDt.secondToStart != int.MIN_VALUE && (!minActvTimeCfgDt || actvTimeCfgDt.secondToStart < minActvTimeCfgDt.secondToStart);
				if(boolean)
				{
					minActvTimeCfgDt = actvTimeCfgDt;
				}
			}
			return minActvTimeCfgDt ? minActvTimeCfgDt : actvTimeCfgDt;
		}
		
		public function get currentActvTimeCfgDtToEnter():ActivityTimeCfgData
		{
			var actvTimeCfgDt:ActivityTimeCfgData,minActvTimeCfgDt:ActivityTimeCfgData;
			for each (actvTimeCfgDt in actvTimeCfgDts)
			{
				var boolean:Boolean = actvTimeCfgDt.secondToEnter != int.MIN_VALUE && (!minActvTimeCfgDt || actvTimeCfgDt.secondToEnter < minActvTimeCfgDt.secondToStart);
				if(boolean)
				{
					minActvTimeCfgDt = actvTimeCfgDt;
				}
			}
			return minActvTimeCfgDt ? minActvTimeCfgDt : actvTimeCfgDt;
		}
		
		public function ActivityCfgData()
		{
		}
	}
}