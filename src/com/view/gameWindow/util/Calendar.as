package  com.view.gameWindow.util
{
	//xiaoyu
	public class Calendar
	{
		private const cellNum:int = 42;
		private var dates:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];
		public var calender:Array = [];
		public var currentMonthDates:Array;
		private var preMonthDates:Array;
		public var currentDate:Date;
		public var currentDateIndex:int;
		private var currentyear:int
		private var currentMonth:int

		public var lastMonthRemainNums:int;
		public var currentMonthNums:int;
		public var nextMonthNeedNums:int;

		private static var _instance:Calendar;
		public static function get instance():Calendar
		{
			return _instance ||= new Calendar(new PrivateClass());
		}

		public function Calendar(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error("该类使用单例模式");
			}
		}


		public function checkCalendar():void
		{
			getCurrent();
			lastMonthRemainNums = getlastMonthLeft(currentyear, currentMonth);
			currentMonthNums = getCountDays(currentyear, currentMonth);
			currentMonthDates = dates.slice(0, currentMonthNums);
			calender = currentMonthDates.concat();

			var predayNum:int = getCountDays(currentyear, premonthHandler(currentMonth));
			preMonthDates = dates.slice(0, predayNum);

			var headArr:Array = preMonthDates.slice(preMonthDates.length - lastMonthRemainNums, preMonthDates.length);
			nextMonthNeedNums = cellNum - calender.length - lastMonthRemainNums;
			//calender.unshift(headArr);
			unshift(calender, headArr);
			//calender = calender.concat(dates.slice(0,nextMonthNeedNums)); 
			calender = concat(calender, dates.slice(0, nextMonthNeedNums));
			currentDateIndex = lastMonthRemainNums + currentDate.date - 1;
		}

		private function unshift(data:Array, source:Array):void
		{
			for (var i:int = source.length - 1; i >= 0; i--)
			{
				data.unshift(source[i]);
			}
		}

		private function concat(data:Array, source:Array):Array
		{
			for each(var d:int in source)
			{
				data = data.concat(d);
			}
			return data;
		}

		public function getCalendar():Array
		{
			return calender;
		}

		private function getCurrent():void
		{
			currentDate = ServerTime.date;
			currentyear = currentDate.fullYear;
			currentMonth = currentDate.month;
		}

		private function getCountDays(year:int, month:int):int
		{
			var curDate:Date = new Date(year, month);
			var curMonth:int = curDate.getMonth();
			curDate.setMonth(curMonth + 1);
			curMonth = curDate.getMonth();
			curDate.setDate(0);
			return curDate.getDate();
		}

		private function getlastMonthLeft(year:int, month:int):int
		{
			var date:Date = new Date(year, month);
			date.date = 1;
			var a:int = date.day == 0 ? 7 : date.day;
			return a;
		}


		private function premonthHandler(month:int):int
		{
			if (month > 0)
			{
				month -= 1;
			}
			else
			{
				month = 11;
				currentyear -= 1;
			}
			return month;
		}

		private function nextmonthHandler(month:int):int
		{
			if (month < 11)
			{
				month += 1;
			}
			else
			{
				month = 0;
				currentyear += 1;
			}
			return month;
		}

		public function destroy():void
		{
			dates.length = 0;
			//dates = null;
			calender.length = 0;
			calender = null;
			currentMonthDates.length = 0;
			currentMonthDates = null;
			preMonthDates.length = 0;
			preMonthDates = null;
		}
	}

}

class PrivateClass
{
}