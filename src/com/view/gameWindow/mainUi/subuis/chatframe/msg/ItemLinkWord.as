package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.BagData;
	
	/**
	 * @author wqhk
	 * 2014-8-14
	 */
	public class ItemLinkWord extends LinkWord
	{
		public function ItemLinkWord()
		{
			super();
		}
		
		override public function getDescription():String
		{
			var parts:Array = LinkWord.splitData(data);
			var item:ItemCfgData =  ConfigDataManager.instance.itemCfgData(parseInt(parts[0]));
			
			return "["+item.name+"]";
		}
		
		override public function getTooltipData():Object
		{
			var parts:Array = LinkWord.splitData(data);
			var re:BagData = new BagData();
			re.id = parseInt(parts[0]);
			re.bind = parseInt(parts[1]);
			
			return re;
		}
		
		override public function getColor():uint
		{
			var parts:Array = LinkWord.splitData(data);
			var item:ItemCfgData =  ConfigDataManager.instance.itemCfgData(parseInt(parts[0]));
			
			return ItemType.getColorByQuality(item.quality)
		}
		
		override public function getTooltipType():int
		{
			return ToolTipConst.ITEM_BASE_TIP;
		}
		
		override public function get needTooltip():Boolean
		{
			return true;
		}
	}
}