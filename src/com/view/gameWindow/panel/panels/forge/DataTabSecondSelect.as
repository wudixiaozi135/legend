package com.view.gameWindow.panel.panels.forge
{
	public class DataTabSecondSelect
	{
		/**通知刷新二级分页及选中*/
		public static const NOTIFY_UPDATE_TAB_SECOND:int = -10000;
		public var isNotifyUpdateTabSecond:Boolean;
		internal var _typeSecond:int;
		/**二级分页类别(若存在二级分页)<br>使用ConstStorage中的常量*/
		public function get typeSecond():int
		{
			return _typeSecond;
		}
		internal var _selectId:int;
		/**选中装备的唯一id*/
		public function get selectId():int
		{
			return _selectId;
		}
		internal var _selectSid:int;
		public function get selectSid():int
		{
			return _selectSid;
		}
		
		public function DataTabSecondSelect()
		{
		}
	}
}