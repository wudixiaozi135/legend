package com.view.gameWindow.panel.panels.npcshop
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UtilMouse;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * NPC商店点击事件处理类
	 * @author Administrator
	 */	
	public class PanelNpcShopClickHandle
	{
		private var _mc:McPanelNpcShop;
		
		public function PanelNpcShopClickHandle(mc:McPanelNpcShop)
		{
			_mc = mc;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mc.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_NPC_SHOP);
					break;
				case _mc.btnPurchase:
					setSelected(_mc.btnPurchase,StringConst.NPC_SHOP_PANEL_0002,_mc.btnBuy,StringConst.NPC_SHOP_PANEL_0003);
					break;
				case _mc.btnBuy:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
					setSelected(_mc.btnPurchase,StringConst.NPC_SHOP_PANEL_0002,_mc.btnBuy,StringConst.NPC_SHOP_PANEL_0003);
					/*setSelected(_mc.btnBuy,StringConst.NPC_SHOP_PANEL_0003,_mc.btnPurchase,StringConst.NPC_SHOP_PANEL_0002);*/
					break;
				case _mc.btnOneFix:
					LastingDataMananger.getInstance().isRepair=!LastingDataMananger.getInstance().isRepair;
					UtilMouse.setMouseRpair(LastingDataMananger.getInstance().isRepair);
					break;
				case _mc.btnAllFix:
					LastingDataMananger.getInstance().oneKeyRepair();
					break;
			}
		}
		
		private function setSelected(lastMc:MovieClip,text1:String,nowMc:MovieClip,text2:String):void
		{
			var textField:TextField;
			
			lastMc.selected = true;
			lastMc.mouseEnabled = false;
			textField = lastMc.txt as TextField;
			textField.text = text1;
			textField.textColor = 0xffe1aa;
			
			nowMc.selected = false;
			nowMc.mouseEnabled = true;
			textField = nowMc.txt as TextField;
			textField.text = text2;
			textField.textColor = 0x675138;
		}
		
		public function destroy():void
		{
			if(_mc)
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
			_mc = null;
		}
	}
}