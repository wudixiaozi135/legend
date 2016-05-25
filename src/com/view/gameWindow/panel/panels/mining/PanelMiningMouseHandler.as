package com.view.gameWindow.panel.panels.mining
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;

	internal class PanelMiningMouseHandler
	{
		private var _panel:PanelMining;
		private var _skin:McMining;
		
		internal var isAutoSell:Boolean;
		
		public function PanelMiningMouseHandler(panel:PanelMining)
		{
			_panel = panel;
			_skin = _panel.skin as McMining;
			initialize();
		}
		
		private function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				default:
					break;
				case _skin.btnClose:
					dealClose();
					break;
				case _skin.btnSell:
					dealSell();
					break;
				case _skin.btnSelectSell:
					dealSelectSell();
					break;
			}
		}
		
		private function dealSelectSell():void
		{
			var manager:VipDataManager = VipDataManager.instance;
			if(!manager.vipCfgData.auto_sell_strongstone)
			{
				var lvCanAutoSellStrongstone:int = manager.lvCanAutoSellStrongstone;
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.MINING_PANEL_0009.replace("&x",lvCanAutoSellStrongstone));
				_skin.btnSelectSell.selected = false;
				return;
			}
			isAutoSell = !isAutoSell;
		}
		/**出售普通矿石*/
		internal function dealSell():void
		{
			var manager:BagDataManager = BagDataManager.instance;
			var sellDts:Vector.<BagData> = new Vector.<BagData>();
			var minerals:Array = _panel.viewHandler.minerals.slice(0,5);
			var itemId:int;
			for each (itemId in minerals) 
			{
				var tempDts:Vector.<BagData> = manager.getItemVectorById(itemId);
				sellDts = sellDts.concat(tempDts);
			}
			manager.sendSellDatas(sellDts);
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_MINING);
		}
		
		internal function destroy():void
		{
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
			}
			_skin = null;
			_panel = null;
		}
	}
}