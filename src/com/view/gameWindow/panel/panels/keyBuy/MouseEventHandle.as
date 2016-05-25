package com.view.gameWindow.panel.panels.keyBuy
{
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.GameConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuidesID;
	import com.view.gameWindow.panel.panels.npcshop.NpcShopDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;
	
	public class MouseEventHandle
	{
		
		private var _mc:McKeyBuyPanel;
		private var panel:KeyBuyPanel;
		public function MouseEventHandle()
		{
		}
		public function mouseEventHandle(mc:McKeyBuyPanel,_panel:KeyBuyPanel):void
		{
			_mc = mc;
			panel =  _panel;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_BAG_KEYBUY);
					break;
				case _mc.buyBtn_00:
					sendMessage(0);
					panel.hideEffect();
					break;
				case _mc.buyBtn_01:
					panel.hideEffect();
					sendMessage(1);
					break;
				case _mc.buyBtn_02:
					sendMessage(2);
					break;
				case _mc.buyBtn_03:
					sendMessage(3);
					break;
			}
		}
		
		private var closeGuide:GuideAction;
		private function createCloseGuide():void
		{
			if(!closeGuide)
			{
				closeGuide = GuideSystem.instance.createAction(GuidesID.KEY_BUY_CLOSE);
				if(closeGuide)
				{
					closeGuide.init();
					closeGuide.act();
				}
			}
		}
		private function sendMessage(index:int):void
		{
			var keyBuyPanel:KeyBuyPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG_KEYBUY) as KeyBuyPanel;
			var vectorId:Vector.<NpcShopCfgData> = keyBuyPanel.dataArr;
			var str:String;
			var myCoin:Number=BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind;
			if(vectorId[index].price_value>myCoin)
			{
				createCloseGuide();
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.TIP_COIN_NOT_ENOUGH);
				return;
			}
			var storage:int;
			if(KeyBuyPanel.HOR==GameConst.ROLE)
			{
				storage = ConstStorage.ST_CHR_BAG;
			}
			else if(KeyBuyPanel.HOR==GameConst.HERO)
			{
				storage = ConstStorage.ST_HERO_BAG;
			}
			
			createCloseGuide();
			NpcShopDataManager.instance.cmNpcShopBuy(vectorId[index].id,1,storage);
		}
		public function destoryEvent():void
		{
			if(closeGuide)
			{
				closeGuide.destroy();
				closeGuide = null;
			}
			_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
			_mc = null;
		}
	}
}