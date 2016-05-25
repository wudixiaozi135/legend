package com.model.configData.cfgdata
{
	import com.model.consts.ItemType;

	public class ItemCfgData
	{
		public var id:int;
		public var name:String;
		public var desc:String;
		public var desc_short:String;
		public var use_method:String;
		public var effect:String;
		public function get effectValue():int
		{
			return effect.split(":")[1];
		}
		public var type:int;
		public var reincarn:int;
		public var level:int;
		public var entity:int;
		public var job:int;
		public var item_level:int;
		public var sell_value:int;
		public var quality:int;
		public var icon:String;
		public var drop_icon:String;
		public var overlay:int;
		public var can_sell:int;
		public var expire:int;
		public var isbroadcast:int;//是否广播
		public var broadcastid:int;//广播id
		
		public function get textColor():uint
		{
			var colorByQuality:int = ItemType.getColorByQuality(quality);
			return colorByQuality;
		}
		
		public function ItemCfgData()
		{
		}
	}
}