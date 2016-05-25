package com.view.gameWindow.mainUi.subuis.activityTrace
{
	import flash.utils.ByteArray;

	public class ActivityData
	{
		/**活动id，4字节有符号整形*/
		public var activityId:int;
		/**阶段，1字节有符号整形*/
		public var step:int;
		/**事件id，4字节有符号整形*/
		public var triggerId:int;
		/**涉及时间时，4字节有符号整形，这个表示终止时间的unix时间戳*/
		public var endTime:int;
		/**循环数，主要是波数，为1字节有符号整形*/
		public var count:int;
		
		private var _countDatas:Vector.<CountData>;
		
		public function set countData(byteArray:ByteArray):void
		{
			if(null == _countDatas)
			{
				_countDatas = new Vector.<CountData>();
			}
			var tempCount:int = count;
			while(tempCount--)
			{
				var countData:CountData = new CountData();
				countData.wave = byteArray.readInt();
				countData.finish = byteArray.readShort();
				countData.total = byteArray.readShort();
				_countDatas.push(countData);
			}
		}
		
		public function countWave(index:int):int
		{
			if(index < _countDatas.length)
			{
				return _countDatas[index].wave;
			}
			return 0;
		}
		
		public function countFinish(index:int):int
		{
			if(index < _countDatas.length)
			{
				return _countDatas[index].finish;
			}
			return 0;
		}
		
		public function countTotal(index:int):int
		{
			if(index < _countDatas.length)
			{
				return _countDatas[index].total;
			}
			return 0;
		}
		
		public function ActivityData()
		{
		}
	}
}
//下面缩进部分表示依照count数量循环的数据
class CountData
{
	/**波次，4字节有符号整形<br>@see MapMonsterCfgData*/
	public var wave:int;
	/**完成量，2字节有符号整形*/
	public var finish:int;
	/**总量，2字节有符号整形*/
	public var total:int;
}