package com.view.gameWindow.util
{
    import com.model.consts.StringConst;
    
    import flash.globalization.DateTimeFormatter;
    import flash.globalization.LocaleID;

    /**
	 * @author wqhk
	 * 2014-9-2
	 */
	public class TimeUtils
	{
		public static const TEN_YEAR_DAYS:int = 3650;//十年的天数
		/**
		 * @return obj: sec min hour day
		 */
		public static function calcTime(second:Number):Object
		{
			if(second < 0)
			{
				second = 0;
			}
			var re:Object = {};
			re.sec = int(second)%60;
			re.min = int(second/60)%60;
			re.hour = int(second/3600)%24;
			re.day = int(second/(3600*24));
			
			return re;
		}
		public static function calcTime3(second:Number):Object
		{
			if(second < 0)
			{
				second = 0;
			}
			var re:Object = {};
			re.sec = int(second)%60;
			re.min = int(second/60)%60;
			re.hour = int(second/3600);
			return re;
		}
		
		public static function calcTime4(minutes:Number):Object
		{
			if(minutes < 0)
			{
				minutes = 0;
			}
			var re:Object = {};
			re.sec = 0;
			re.min = int(minutes%60);
			re.hour = int(minutes/60);
			return re;
		}
		
		public static function calcTime2(second:Number):Object
		{
			if(second < 0)
			{
				second = 0;
			}
			var re:Object = {};
			re.sec = int(second)%60;
			re.min = int(second/60);
			 
			return re;
		}
		
		public static function formatClock(timeObj:Object):String
		{
			if(!timeObj)
			{
				return "00:00:00";
			}
			
			var re:String = "";
			
			if(timeObj.day > 0)
			{
				re += timeObj.day + ":";
			}
			
			re += fixNum(timeObj.hour) + ":" + fixNum(timeObj.min) + ":" + fixNum(timeObj.sec);
			
			return re;
		}
		/**
		 * 返回形如13:24:00的字符串
		 * @param second 秒数
		 * @param isDayTime 是否为当日0点为起始时间
		 * @param is24Hour 是否为24小时时制
		 * @return HH:MM:SS
		 */		
		public static function formatClock1(second:Number,isDayTime:Boolean = true,is24Hour:Boolean = true):String
		{
			if(second<0)return "00:00:00";
			var date:Date = new Date(second*1000);
			var hours:Number = isDayTime ? date.hoursUTC : date.hours;
			var hours1:String = fixNum(is24Hour ? hours : (hours >= 12 ? hours -= 12 : hours));
			var minutes:String = fixNum(isDayTime ? date.minutesUTC : date.minutes);
			var seconds:String = fixNum(isDayTime ? date.secondsUTC : date.seconds);
			return hours1+":"+minutes+":"+seconds;
		}
		
		public static function formatS(timeObj:Object):String
		{
			if(!timeObj)
			{
				return "";
			}
			
			var re:String = "";
			if(timeObj.day > 0)
			{
				re += timeObj.day + StringConst.DAY;
			}
			
			if(timeObj.hour > 0)
			{
				re += timeObj.hour + StringConst.HOUR_W;
			}
			
			if(timeObj.min > 0)
			{
				re += timeObj.min + StringConst.MINIUTE_W;
			}
			
			if(timeObj.sec > 0)
			{
				re += timeObj.sec + StringConst.SECOND;
			}
			
			return re;
		}
		
		
		public static function getDateString(time:Number):String
		{
			var date:Date=new Date();
			date.time=time;
			var dYear:String = String(date.getFullYear());
			
			var dMouth:String = String((date.getMonth() + 1 < 10) ? "0" : "") + (date.getMonth() + 1);
			
			var dDate:String = String((date.getDate() < 10) ? "0" : "") + date.getDate();
			
			var ret:String = "";
			
			ret += dYear + "-" + dMouth + "-" + dDate + " ";
			
			
			ret += ((date.getHours() < 10) ? "0" : "") + date.getHours()+":";
			
			ret += ((date.getMinutes() < 10) ? "0" : "") + date.getMinutes();
			
			// 想要获取秒的话，date.getSeconds() ，语句同小时、分
			return ret;
		}
		/**某年某月某日*/
		public static function getDateStringCh(time:Number):String
		{
			var date:Date=new Date();
			date.time=time;
			var dYear:String = String(date.getFullYear());
			
			var dMouth:String = String(date.getMonth()+ 1);
			
			var dDate:String = date.getDate().toString();
			
			var ret:String = "";
			
			ret += dYear + StringConst.YEAR + dMouth + StringConst.MONTH + dDate + StringConst.DATE;
			
			// 想要获取秒的话，date.getSeconds() ，语句同小时、分
			return ret;
		}

		public static function getTimeStrByStyle(time:Number,style:String="yyyy-MM-dd HH:mm"):String
		{
			var dateTimeFormatter:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
			dateTimeFormatter.setDateTimePattern(style);
			return dateTimeFormatter.format(new Date(time));
		}
		
		public static function formatS3(timeObj:Object):String
		{
			if(!timeObj)
			{
				return "";
			}
			
			var re:String = "";
  
			if(timeObj.hour > 0)
			{
				re += timeObj.hour + StringConst.HOUR_W;
			}
			if(timeObj.min > 0)
			{
				re += timeObj.min + StringConst.MINIUTE;
			}
			if(timeObj.sec > 0)
			{
				re += timeObj.sec + StringConst.SECOND;
			}
			return re;
		}
		public static function formatS2(timeObj:Object):String
		{
			if(!timeObj)
			{
				return "";
			}
			
			var re:String = "";
			
			if(timeObj.min > 0)
			{
				re += timeObj.min + StringConst.MINIUTE;
			}
			
			if(timeObj.sec > 0)
			{
				re += timeObj.sec + StringConst.SECOND;
			}
			
			return re;
		}
		
		public static function format(timeObj:Object):String
		{
			if(!timeObj)
			{
				return "";
			}
			
			var re:String = "";
			if(timeObj.day > 0)
			{
				re += timeObj.day + StringConst.DAY;
			}
			
			if(re!="" || timeObj.hour > 0)
			{
				re += fixNum(timeObj.hour) + StringConst.HOUR;
			}
			
			if(re!="" || timeObj.min > 0)
			{
				re += fixNum(timeObj.min) + StringConst.MINIUTE;
			}
			
			if(re!="" || timeObj.sec > 0)
			{
				re += fixNum(timeObj.sec) + StringConst.SECOND;
			}
			
			return re;
		}
		/**
		 * 获取当日零点时刻
		 * @param second 
		 * @return 
		 */		
		public static function dayZero(second:int):int
		{
			var date:Date = new Date(second);
			return second - date.seconds - date.minutes*60 - date.hours*3600;
		}
		
		/**
		 * 
		 * 确定时间是否在这个区间 true是不满足
		 */
		public static function checkTime(startTime:int,duration:int):Boolean
		{
			var localNow:Date = ServerTime.date;
			var minutes:int = localNow.hours * 60 + localNow.minutes;
			var endMinutes:int = startTime+duration;
			var isNoTime:Boolean = false;
			if (endMinutes >= 1440)
			{
				endMinutes -= 1440;
				if (minutes < startTime && minutes >= endMinutes)
				{
					isNoTime = true;
				}
			}
			else
			{
				if (minutes < startTime || minutes >= endMinutes)
				{
					isNoTime = true;
				}
			}
			return isNoTime;
		}
		
		/**
		 * 
		 * 确定时间是否在这个区间 true是不满足
		 */
		public static function checkTimeInterval(startTime:int,duration:int,interval:int):Boolean
		{
			var localNow:Date = ServerTime.date;
			var minutes:int = localNow.hours * 60 + localNow.minutes;
			var endMinutes:int = startTime+duration;
			var isNoTime:Boolean = false;
			if (endMinutes >= 1440)
			{
				endMinutes -= 1440;
				if (minutes < startTime && minutes >= endMinutes)
				{
					isNoTime = true;
				}
			}
			else
			{
				if (minutes < startTime || minutes >= endMinutes)
				{
					isNoTime = true;
				}
			}
			if(isNoTime==false)
			{
				if((minutes-startTime)%interval!=0)return true;
			}
			return isNoTime;
		}
		
		public static function fixNum(value:int):String
		{
			return value<10?"0"+value:value.toString();
		}

        /**
         * @param date xxxxmmdd
         * 年月日
         * 如： 20140101
         * true 超过
         * false 未超过
         * */
        public static function beyondTime(startDateStr:String, endDateStr:String):Boolean
        {
            var startYear:int = parseInt(startDateStr.substr(0, 4));
            var startMonth:int = parseInt(startDateStr.substr(4, 2));
            var startDay:int = parseInt(startDateStr.substr(6, 2));

            var endYear:int = parseInt(endDateStr.substr(0, 4));
            var endMonth:int = parseInt(endDateStr.substr(4, 2));
            var endDay:int = parseInt(endDateStr.substr(6, 2));

            var startDate:Date = new Date(startYear, startMonth - 1, startDay);
            var endDate:Date = new Date(endYear, endMonth - 1, endDay);

            var currentServeTime:Number = ServerTime.time;

            if (currentServeTime >= (startDate.time / 1000) && currentServeTime <= (endDate.time / 1000))
            {
                return false;
            }
            return true;
        }
	}
}