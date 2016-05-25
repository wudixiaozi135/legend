package com.view.gameWindow.panel.panels.mall.coupon
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.utils.ByteArray;

	import mx.utils.StringUtil;

	/**
	 * Created by Administrator on 2014/11/23.
	 */
	public class CouponDataManager extends DataManagerBase
	{
		/**从背包里使用优惠券的物品数据*/
		public static var itemCfg:ItemCfgData;
		public static var bagData:BagData;
		public static var shopCfg:GameShopCfgData;

		private static var _instance:CouponDataManager = null;

		public static function get instance():CouponDataManager
		{
			if (_instance == null)
			{
				_instance = new CouponDataManager();
			}
			return _instance;
		}

		public function CouponDataManager()
		{
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BUY_PREFERENTIAL_SHOP, this);
		}

		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.CM_BUY_PREFERENTIAL_SHOP:
					successHandler();
					break;
				default :
					break;
			}
			super.resolveData(proc, data);
		}

		private function successHandler():void
		{
			var msg:String = StringUtil.substitute(StringConst.MALL_BUY_MESSAGE_8, itemCfg.name.concat("X1"), shopCfg.preferential_price);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, msg);
			itemCfg = null;
			shopCfg = null;
		}

		override public function clearDataManager():void
		{
			_instance = null;
		}
	}
}
