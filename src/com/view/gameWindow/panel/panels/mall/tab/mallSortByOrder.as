package com.view.gameWindow.panel.panels.mall.tab
{
	import com.model.configData.cfgdata.GameShopCfgData;

	/**
	 * Created by Administrator on 2014/11/24.
	 * 商城物品排序
	 */
	public function mallSortByOrder(sortVec:Vector.<GameShopCfgData>):void
	{
		var func:Function = function (a:GameShopCfgData, b:GameShopCfgData):int
		{
			if (a.order > b.order)
			{
				return 1;
			} else if (a.order < b.order)
			{
				return -1;
			} else
			{
				return 0;
			}
			return 0;
		};
		sortVec.sort(func);
	}
}
