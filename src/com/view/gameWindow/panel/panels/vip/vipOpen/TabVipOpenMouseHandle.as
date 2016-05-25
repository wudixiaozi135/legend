package com.view.gameWindow.panel.panels.vip.vipOpen
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.PeerageCfgData;
    import com.model.consts.StringConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.TimeUtils;

    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    /**
	 * 开通vip页鼠标相关处理类
	 * @author Administrator
	 */	
	internal class TabVipOpenMouseHandle
	{
		private var _tab:TabVipOpen;
		private var _skin:McVipOpen;
		/**爵位值*/
		internal var peerage:int = 3;
		internal var total:int = 3;
		
		public function TabVipOpenMouseHandle(tab:TabVipOpen)
		{
			_tab = tab;
			_skin = _tab.skin as McVipOpen;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(_skin.btnOpen.contains(event.target as DisplayObject))
			{
				dealOpen();
				return;
			}
			switch(event.target)
			{
				case _skin.btnLeft:
					dealLeft();
					break;
				case _skin.btnRight:
					dealRight();
					break;
				case _skin.btnGet:
					dealGet();
					break;
				default:
					break;
			}
		}
		
		private function dealLeft():void
		{
			if(peerage < total)
			{
				peerage++;
				_tab.viewHandle.refreshPeerageShow();
			}
		}
		
		private function dealRight():void
		{
			if(peerage > 1)
			{
				peerage--;
				_tab.viewHandle.refreshPeerageShow();
			}
		}
		
		private function dealGet():void
		{
			var manager:VipDataManager = VipDataManager.instance;
			var isRewardCanGet:Boolean = _tab.viewHandle.isRewardCanGet;
			if(!isRewardCanGet)
			{
				var lv:int = manager.lv;
				if(lv == 0)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.VIP_PANEL_0006);
				}
				else
				{
					var replace:String = StringConst.VIP_PANEL_0007.replace("&x",lv+1);
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,replace);
				}
				return;
			}
			
			if(BagDataManager.instance.remainCellNum == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0029);
				return;
			}
            _tab.viewHandle.storeBmps();
			var getLv:int = int(_tab.viewHandle.lv);
			manager.vipGiftGet(getLv);
		}
		
		private function dealOpen():void
		{
			var data:PeerageCfgData = ConfigDataManager.instance.peerageCfgData(peerage);
			var content:String = "";
			var manager:VipDataManager = VipDataManager.instance;
			if(manager.peerageCfgData && manager.peerageCfgData.order >= peerage)
			{
				var calcTime:Object = TimeUtils.calcTime(data.remain*60);
				content = StringConst.VIP_PANEL_0009.replace("&x",data.gold).replace("&y",calcTime.day);
			}
			else
			{
				content = StringConst.VIP_PANEL_0008.replace("&x",data.gold).replace("&y",data.name);
			}
			Alert.show2(content,function (peerage:int):void
			{
				var data:PeerageCfgData = ConfigDataManager.instance.peerageCfgData(peerage);
				var goldUnBind:int = BagDataManager.instance.goldUnBind;
				if(goldUnBind < data.gold)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.TIP_GOLD_NOT_ENOUGHS);
					return;
				}
				VipDataManager.instance.peerageBuy(peerage);
			},peerage,"","",null,"left");
		}
		
		internal function destroy():void
		{
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			_tab = null;
		}
	}
}