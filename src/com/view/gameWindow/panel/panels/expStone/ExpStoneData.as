package com.view.gameWindow.panel.panels.expStone
{
	import com.model.configData.cfgdata.ItemCfgData;
	
	/**
	 * @author wqhk
	 * 2014-11-14
	 */
	public class ExpStoneData
	{
		public var storage:int;
		public var slot:int;
		public var exp:int;
		public var item:ItemCfgData;
		
		public function get maxExp():int
		{
			return getMaxExp(item);
		}
		
		public static function getMaxExp(item:ItemCfgData):int
		{
			if(item)
			{
				if(item.effect)
				{
					var re:Array = item.effect.split(":");
					if(re && re.length>0)
					{
						return re[0];
					}
				}
			}
			
			return 0;
		}
		
		public static function getGold(item:ItemCfgData):int
		{
			if(item)
			{
				if(item.effect)
				{
					var re:Array = item.effect.split(":");
					if(re && re.length == 2)
					{
						return re[1];
					}
				}
			}
			
			return 0;
		}
		
		public function get VIP():int
		{
			if(item)
			{
				if(item.effect)
				{
					var re:Array = item.effect.split(":");
					if(re && re.length == 2)
					{
						return re[1];
					}
				}
			}
			
			return 0;
		}
	}
}