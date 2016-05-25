package com.view.gameWindow.util
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.view.gameWindow.util.cell.ThingsData;

    public class UtilItemParse
	{
		public function UtilItemParse()
		{
		}
		/**
		 * 根据传入的字符串解析出对应的物品字符串
		 * @param str 形如x:x:x|y:y:y
		 * @param isCountShow 是否显示数量
		 * @return 
		 */		
		public static function getItemStr(str:String,isCountShow:Boolean = true,splitMark:String = " "):String
		{
			var strReward:String = "";
			var dts:Vector.<ThingsData> = UtilItemParse.getThingsDatas(str);
			var i:int,l:int = dts.length;
			for (i=0;i<l;i++) 
			{
				var cfgDt:ItemCfgData = dts[i].itemCfgData;
				var name:String = cfgDt.name;
				var count:int = dts[i].count;
				var color:int = ItemType.getColorByQuality(cfgDt.quality);
				var createHtmlStr:String = HtmlUtils.createHtmlStr(color,name+(isCountShow ? "*"+count : "")+splitMark);
				strReward += createHtmlStr;
			}
			return strReward;
		}
		/**
		 * 根据传入的字符串解析出对应的数据信息列表
		 * @param str 形如x:x:x|y:y:y
		 * @return 解析成的数据信息列表
		 */		
		public static function getThingsDatas(str:String):Vector.<ThingsData>
		{
			var vector:Vector.<ThingsData> = new Vector.<ThingsData>();
			var thingsStrs:Array,i:int,l:int,dt:ThingsData;
			thingsStrs = str.split("|");
			l = thingsStrs.length;
			for(i=0;i<l;i++)
			{
				dt = getThingsData(thingsStrs[i]);
				vector.push(dt);
			}
			return vector;
		}
		/**
		 * 根据传入的字符串解析出对应的过滤后的数据信息列表
		 * @param str 形如x:x:x|y:y:y
		 * @param filter 过滤函数,function(dt:ThingsData):Boolean<br>返回true时，值将被过滤
		 * @return 解析成的数据信息列表
		 */		
		public static function getThingsDatasByFilter(str:String,filter:Function):Vector.<ThingsData>
		{
			var vector:Vector.<ThingsData> = new Vector.<ThingsData>();
			var thingsStrs:Array,i:int,l:int,dt:ThingsData;
			thingsStrs = str.split("|");
			l = thingsStrs.length;
			for(i=0;i<l;i++)
			{
				dt = getThingsData(thingsStrs[i]);
				if(!filter(dt))
				{
					vector.push(dt);
				}
			}
			return vector;
		}
		/**
		 * 根据传入的字符串解析出对应的数据信息
		 * @param str 形如x:x:x
		 * @return 解析成的数据信息
		 */		
		public static function getThingsData(str:String):ThingsData
		{
			var split:Array = str.split(":");
			var id:int = int(split[0]);
			var type:int = int(split[1]);
			var count:int = int(split[2]);
			var dt:ThingsData = new ThingsData();
			dt.id = id;
			dt.type = type;
			dt.count = count;
			return dt;
		}
		/**
		 * 根据传入的字符串解析出对应的物品信息
		 * @param reward 字符串，3个：分隔
		 * @return 数组，0：颜色，1物品名，2数量，3物品id,4类型
		 */		
		public static function getItemString(reward:String):Array
		{
			var color:int,name:String = "";
			var split:Array = reward.split(":");
			var id:int = int(split[0]);
			var type:int = int(split[1]);
			var count:int = int(split[2]);
			if(type == SlotType.IT_EQUIP)
			{
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
				color = ItemType.getColorByQuality(equipCfgData.quality);
				name = equipCfgData.name;
			}
			else
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
				color = ItemType.getColorByQuality(itemCfgData.quality);
				name = itemCfgData.name;
			}
			return [color,name,count,id,type];
		}

        /*
         *  130500:2:1:3:0:20
         *  id:type:count:job:sex:强化等级
         * */
        public static function getFirstChargeReward(reward:String):Array
        {
            var arr:Array = reward.split(":");
            return [int(arr[0]), int(arr[1]), int(arr[2]), int(arr[3]), int(arr[4]), int(arr[5])];
        }

        /*
         *  累计登陆奖励
         *  130500:2:1:3:0
         *  id:type:count:job:sex
         * */
        public static function getLoginReward(reward:String):Array
        {
            var arr:Array = reward.split(":");
            return [int(arr[0]), int(arr[1]), int(arr[2]), int(arr[3]), int(arr[4])];
        }
	}
}