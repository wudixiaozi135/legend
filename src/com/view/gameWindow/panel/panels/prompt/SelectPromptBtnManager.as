package com.view.gameWindow.panel.panels.prompt
{
	/**
	 * Created by Administrator on 2014/11/26.
	 * 今日不再提示选择管理
	 */
	public class SelectPromptBtnManager
	{
		private static var _selectPrayCoin:Boolean = false;//祈福金币
		private static var _selectPrayTicket:Boolean = false;//祈福礼券
		private static var _selectAuction:Boolean=false;// 竞拍排名
		private static var _selectCall:Boolean=false;// 竞拍排名
		private static var _selectTreasure1:Boolean = false;// 寻宝1次
		private static var _selectTreasure10:Boolean = false;// 寻宝10次
		private static var _selectTreasure50:Boolean = false;// 寻宝50次
		public static var _selectTreasureShop:Boolean = false;//寻宝商店
		public static var _selectAttack:Boolean=false; //宣战
        public static var _selectEquipEquipAlert:Boolean = false;//装备升级提示
        public static var _selectSchoolShop:Boolean = false;//帮会商店
		public static function setSelect(selectType:int, select:Boolean = true):void
		{
			switch (selectType) {
				default :
					break;
				case SelectPromptType.SELECT_PRAY_COIN:
					_selectPrayCoin = select;
					break;
				case SelectPromptType.SELECT_PRAY_TICKET:
					_selectPrayTicket = select;
					break;
				case SelectPromptType.SELECT_AUCTION_TICKET:
					_selectAuction = select;
					break;
				case SelectPromptType.SELEC_TTREASURE_1:
					_selectTreasure1 = select;
					break;
				case SelectPromptType.SELEC_TTREASURE_5:
					_selectTreasure10 = select;
					break;
				case SelectPromptType.SELEC_TTREASURE_10:
					_selectTreasure50 = select;
					break;
				case SelectPromptType.SELEC_TTREASURE_SHOP:
					_selectTreasureShop = select;
					break;
				case SelectPromptType.SELEC_TTREASURE_SHOP:
					_selectCall = select;
					break;
				case SelectPromptType.SELEC_TTREASURE_SHOP:
					_selectCall = select;
					break;
				case SelectPromptType.SELECT_ATTACK:
					_selectAttack = select;
					break;
                case SelectPromptType.SELECT_EQUIP_UPGRADE_ALERT:
                    _selectEquipEquipAlert = select;
                    break;
                case SelectPromptType.SELECT_SCHOOL_SHOP:
                    _selectSchoolShop = select;
                    break;
			}
		}

		public static function getSelect(selectType:int):Boolean
		{
			switch (selectType) {
				case SelectPromptType.SELECT_PRAY_COIN:
					return _selectPrayCoin;
				case SelectPromptType.SELECT_PRAY_TICKET:
					return _selectPrayTicket;
				case SelectPromptType.SELECT_AUCTION_TICKET:
					return _selectAuction;
				case SelectPromptType.SELEC_TTREASURE_1:
					return _selectTreasure1;
				case SelectPromptType.SELEC_TTREASURE_5:
					return _selectTreasure10;
				case SelectPromptType.SELEC_TTREASURE_10:
					return _selectTreasure50;
				case SelectPromptType.SELEC_TTREASURE_SHOP:
					return _selectTreasureShop;	
				case SelectPromptType.SELEC_TTREASURE_SHOP:
					return _selectCall;
				case SelectPromptType.SELECT_ATTACK:
					return _selectAttack;
                case SelectPromptType.SELECT_EQUIP_UPGRADE_ALERT:
                    return _selectEquipEquipAlert;
                case SelectPromptType.SELECT_SCHOOL_SHOP:
                    return _selectSchoolShop;
			}
			return false;
		}

		public static function reset():void
		{
			_selectPrayCoin = false;
			_selectPrayTicket = false;
			_selectAuction=false;
			_selectTreasure1 = false;
			_selectTreasure10 = false;
			_selectTreasure50 = false;
			_selectTreasureShop = false;
			_selectCall=false;
			_selectAttack=false;
            _selectEquipEquipAlert = false;
            _selectSchoolShop = false;
		}

		public function SelectPromptBtnManager()
		{
		}
	}
}

