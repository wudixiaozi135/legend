package com.view.gameWindow.panel.panels.keySell
{
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;

	/**
	 * 一键出售数据类
	 * @author Administrator
	 */	
	public class KeySellDataManager extends DataManagerBase
	{
		public static const NUM_PAGE_CELL:int = 15;
		
		private static var _instance:KeySellDataManager;
		public static function get instance():KeySellDataManager
		{
			return _instance ||= new KeySellDataManager(new PrivateClass());
		}
		
		private var _datas:Vector.<BagData>;
		
		public function KeySellDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
		}
		
		public function dealSell():void
		{
			BagDataManager.instance.sendSellDatas(datas);
		}
		/**获取所有可出售道具*/
		public function dealBagItems():void
		{
			_datas = BagDataManager.instance.getKeySellDatas();
			var temp:Vector.<BagData> = HeroDataManager.instance.getKeySellDatas();
			_datas && temp ? _datas = _datas.concat(temp) : null;
		}

		public function get datas():Vector.<BagData>
		{
			return _datas;
		}
	}
}
class PrivateClass{}