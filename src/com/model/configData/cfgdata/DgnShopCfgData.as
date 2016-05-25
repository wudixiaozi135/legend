package com.model.configData.cfgdata
{
	import com.view.gameWindow.util.UtilNumChange;

	/**
	 * 
	 * @author Administrator
	 */	
	public class DgnShopCfgData
	{
		public var dungeon_id:int;//11	副本id
		public var item_id:int;//11	道具id
		public var exp:int;//11	需要经验数
		
		public function get strExp():String
		{
			var utilNumChange:UtilNumChange = new UtilNumChange();
			var changeNum:String = utilNumChange.changeNum(exp);
			return changeNum;
		}
		
		public function DgnShopCfgData()
		{
		}
	}
}