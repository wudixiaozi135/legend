package com.view.gameWindow.tips.toolTip
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	
	/**
	 * @author jhj
	 */
	public class ShopItemTip extends ItemBaseTip
	{
		public function ShopItemTip()
		{
			super();
		}
		
		override public function setData(obj:Object):void
		{
			var npcShopCfgData:NpcShopCfgData = obj as NpcShopCfgData;
			if(!npcShopCfgData)
			{
				return;
			}
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(npcShopCfgData.base);
			if(!itemCfgData)
			{
				return;
			}
			super.setData(itemCfgData);
			_data = obj;
		}
	}
}