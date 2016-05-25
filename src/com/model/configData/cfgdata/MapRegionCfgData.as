package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;
	import com.model.consts.MapRegionType;
	
	import flash.geom.Point;

	public class MapRegionCfgData
	{
		public var id:int;
		public var name:String;
		public var type:int;
		/**区域所属地图id*/
		public var map_id:int;
		public var shape:int;
		public var x_min:int;
		public var y_min:int;
		public var x_max:int;
		public var y_max:int;
		public var exp_base_ratio:int;
		public var exp_cd:int;
		public var activity_id:int;
		
		public function get centerPoint():Point
		{
			var x:int;
			var y:int;
			
			x = (x_max - x_min)/2 + x_min;
			y = (y_max - y_min)/2 + y_min;
			
			return new Point(x,y);
		}
		
		public function get randomPoint():Point
		{
			var x:int;
			var y:int;
			if(shape == MapRegionType.SHAPE_DIA)//菱形一定是正菱形
			{
				var rMaxOffset:Number = (x_max + y_max - x_min - y_min)*.5;
				var lMaxOffset:Number = (y_max - x_max - y_min + x_min)*.5;
				var rOffset:Number = Math.random()*rMaxOffset;
				var lOffset:Number = Math.random()*lMaxOffset;
				x = x_min + rOffset - lOffset;
				y = y_min + rOffset + lOffset;
			}
			else if(shape == MapRegionType.SHAPE_RECT)
			{
				x = Math.random() * (x_max - x_min) + x_min;
				y = Math.random() * (y_max - y_min) + y_min;
			}
			return new Point(x,y);
		}
		/**是否在区域内*/
		public function isIn(tileX:int,tileY:int):Boolean
		{
			if(shape == MapRegionType.SHAPE_DIA)
			{
				var rOf:int = (tileX + tileY - x_min - y_min)/2;
				var lOf:int = (tileY - tileX - y_min + x_min)/2;
				var rMxOf:int = (x_max + y_max - x_min - y_min)/2;
				var lMxOf:int = (y_max - x_max - y_min + x_min)/2;
				if(rOf >= 0 && rOf <= rMxOf && lOf >= 0 && lOf <= lMxOf)
				{
					return true;
				}
			}
			else if(shape == MapRegionType.SHAPE_RECT)
			{
				if(tileX >= x_min && tileX <= x_max && tileY >= y_min && tileY <= y_max)
				{
					return true;
				}
			}
			return false;
		}
		
		public function get mapCfgData():MapCfgData
		{
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(map_id);
			return mapCfgData;
		}
		
		public function MapRegionCfgData()
		{
		}
	}
}