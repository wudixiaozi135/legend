package com.view.gameWindow.panel.panels.school.complex.information.donate
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.InputHandler;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.information.MCdonate;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class DonateMouseHandler
	{

		private var panel:DonatePanel;
		private var skin:MCdonate;

		private var inputHandler:InputHandler;

		private var timeIndex:uint;
		public function DonateMouseHandler(panel:DonatePanel)
		{
			this.panel = panel;
			skin = panel.skin as MCdonate;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.txtv4.maxChars=9;
			inputHandler = new InputHandler(skin.txtv4,"1",1,oncallBack,onChanageFunc);
		}		
		
		private function onChanageFunc(textStr:String):void
		{
			clearTimeout(timeIndex);
			timeIndex = setTimeout(oncallBack,300);
		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			switch(event.target)
			{
				case skin.btnUp:
					onClickUP();
					break;
				case skin.btnDown:
					onClickDown();
					break;
				case skin.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_DONATE);
					break;
				case skin.btnMax:
					doMax();
					break;
				case skin.btnDonate:
					doDonate();
					break;
			}
		}		
		
		private function doDonate():void
		{
			// TODO Auto Generated method stub
			var value:int=int(skin.txtv4.text);
			if(BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind<value*1000)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_2010);	
				return;
			}
			var donateData:DonateData = SchoolElseDataManager.getInstance().donateData;
			if(value*1000>donateData.surplus)
			{
				value=donateData.surplus/1000;
			}
			if(value==0)
			{
				skin.txtv5.text=value+"";
				skin.txtv6.text=value+"";
				skin.txtv4.text=value+"";
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_2015);	
				return;
			}
		
			SchoolElseDataManager.getInstance().sendDonateRequest(value);
		}
		
		private function doMax():void
		{
			var donateData:DonateData = SchoolElseDataManager.getInstance().donateData;
			var value:int=donateData.surplus/1000;
			skin.txtv5.text=value+"";
			skin.txtv6.text=value+"";
			skin.txtv4.text=value+"";
		}
		
		private function onClickDown():void
		{
			var donateData:DonateData = SchoolElseDataManager.getInstance().donateData;
			var value:int=int(skin.txtv4.text);
			value+=1;
			if(value*1000>donateData.surplus)
			{
				value=donateData.surplus/1000;
			}
			skin.txtv4.text=value+"";
			skin.txtv5.text=value+"";
			skin.txtv6.text=value+"";
		}
		
		private function onClickUP():void
		{
			var value:int=int(skin.txtv4.text);
			value-=1;
			if(value<1)value=0;
			skin.txtv4.text=value+"";
			skin.txtv5.text=value+"";
			skin.txtv6.text=value+"";
		}
		
		private function oncallBack(textStr:String=null):void
		{
			var donateData:DonateData = SchoolElseDataManager.getInstance().donateData;
			var value:int=int(skin.txtv4.text);
//			if(value>1000)value-=value%1000;
//			if(value<1000)value*=1000;
			if(value*1000>donateData.surplus)
			{
				value=donateData.surplus/1000;
			}
			skin.txtv4.text=value+"";
			skin.txtv5.text=value+"";
			skin.txtv6.text=value+"";	
		}		
		
		public function destroy():void
		{
			inputHandler.destroy();
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}