package com.view.gameWindow.mainUi.subuis.bottombar.actBar
{
	/**
	 * 动作条数据类
	 * @author Administrator
	 */	
	public class ActionBarData
	{
		public var key:int;
		/**类型，使用ActionBarCellType中的常量*/		
		public var type:int;
		public var groupId:int;
		/**是否为预设数据(在获得新技能时使用，用于处理同时获得多个技能产生的问题)*/
		public var isPreinstall:Boolean;
		
		public function ActionBarData()
		{
			
		}
	}
}