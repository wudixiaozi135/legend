package com.view.gameWindow.panel.panels.prompt
{
	/**
	 * Created by Administrator on 2014/11/26.
	 * 今日不再提示类型
	 */
	public class SelectPromptType
	{
		/**祈福金币不再提示*/
		public static const SELECT_PRAY_COIN:int = 1;
		/**祈福礼券不再提示*/
		public static const SELECT_PRAY_TICKET:int = 2;
		/**竞拍排名*/
		public static const SELECT_AUCTION_TICKET:int = 3;
		/**寻宝1次*/
		public static const SELEC_TTREASURE_1:int = 4;
		/**寻宝10次*/
		public static const SELEC_TTREASURE_5:int = 5;
		/**寻宝50次*/
		public static const SELEC_TTREASURE_10:int = 6;
		/**寻宝商店购买*/
		public static const SELEC_TTREASURE_SHOP:int = 7;
		/**召唤*/
		public static const SELEC_CALL:int = 8;
		
		public static const SELECT_ATTACK:int=9;
		
		public static const SELECT_TRAILER_GOLD:int=10;

        public static const SELECT_EQUIP_UPGRADE_ALERT:int = 11;//装备升级提示
        /**帮会商店购买*/
        public static const SELECT_SCHOOL_SHOP:int = 12;
		public function SelectPromptType()
		{
		}
	}
}
