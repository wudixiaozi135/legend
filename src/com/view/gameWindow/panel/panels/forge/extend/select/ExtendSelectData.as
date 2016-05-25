package com.view.gameWindow.panel.panels.forge.extend.select
{
	import com.view.gameWindow.util.cell.CellData;

	public class ExtendSelectData
	{
		/**0:未勾选，1：全选，2转移强化/打磨属性，3转移随机属性*/
		public static var filter:int = 2;
		/**原装备数据*/
		public static var cellData1:CellData = null;
		/**新装备数据*/
		public static var cellData2:CellData = null;
		
		public function ExtendSelectData()
		{
		}
	}
}