package com.view.gameWindow.panel.panels.roleProperty.role
{
	public class HideFactionData
	{
		public var hideHuanwu:int;
		public var hideShizhuang:int;
		public var hideChibang:int;
		public var hideDouli:int;
		
		public function HideFactionData()
		{
		}
		
		public function setData(value:int):void
		{
			this.hideHuanwu = (value >> 0) & 1;
			this.hideShizhuang = (value >> 1) & 1;
			this.hideChibang = (value >> 2) & 1;
			this.hideDouli = (value >> 3) & 1;
		}
		
		public function getData():int
		{
			var value1:int = this.hideHuanwu == 1?1:0;
			var value2:int = this.hideShizhuang == 1?2:0;
			var value3:int = this.hideChibang == 1?4:0;
			var value4:int = this.hideDouli == 1?8:0;
			return value1 + value2 + value3 + value4;
		}
	}
}