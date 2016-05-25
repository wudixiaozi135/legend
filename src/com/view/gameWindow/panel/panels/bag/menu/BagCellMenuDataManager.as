package com.view.gameWindow.panel.panels.bag.menu
{
	import com.model.dataManager.DataManagerBase;

	public class BagCellMenuDataManager extends DataManagerBase
	{
		private static var _instance:BagCellMenuDataManager;
		
		public static function get instance():BagCellMenuDataManager
		{
			return _instance ||= new BagCellMenuDataManager(new PrivateClass());
		}
		
		private function clearInstance():void
		{
			_instance = null;
		}
		
		private var _list:Vector.<int>;
		
		public function BagCellMenuDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式")
			}
		}

		public function get list():Vector.<int>
		{
			var _list2:Vector.<int> = _list;
			_list = null;
			return _list2;
		}

		public function set list(value:Vector.<int>):void
		{
			_list = value;
		}
	}
}
class PrivateClass{}