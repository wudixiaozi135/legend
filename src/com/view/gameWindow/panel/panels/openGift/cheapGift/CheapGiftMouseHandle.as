package com.view.gameWindow.panel.panels.openGift.cheapGift
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.SpecialPreferenceRewordCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.charge.ChargeDataManager;
	import com.view.gameWindow.panel.panels.openActivity.McCheapGift;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.prompt.Panel2BtnPrompt;
	import com.view.gameWindow.panel.panels.prompt.Panel2BtnPromptData;
	import com.view.gameWindow.util.JsUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	public class CheapGiftMouseHandle
	{
		private var _panel:CheapGift;
		private var skin:McCheapGift;
		private var curIndex:int = -1;
		public function CheapGiftMouseHandle(panel:CheapGift)
		{
			_panel = panel;
			skin = panel.skin as McCheapGift;
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function setCur(index:int):void
		{
			curIndex = index;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			switch(event.target)
			{
				case skin.btnEquip:
					curIndex = 1;
					_panel.viewHandler.deal(skin.btnEquip,1)
					break;
				case skin.btnCloth:
					curIndex = 2;
					_panel.viewHandler.deal(skin.btnCloth,2)
					break;
				case skin.btnRing:
					curIndex = 4;
					_panel.viewHandler.deal(skin.btnRing,4)
					break;
				case skin.btnHead:
					curIndex = 3;
					_panel.viewHandler.deal(skin.btnHead,3)
					break;
				case skin.btnGet:
					dealGet();
					break;
			}
		}
		
		private function dealGet():void
		{
			// TODO Auto Generated method stub
			var cfg:SpecialPreferenceRewordCfgData = ConfigDataManager.instance.cheapReward(curIndex);
			var str:String;
			if(BagDataManager.instance.goldUnBind<cfg.cost_unbind)
			{
				if(BagDataManager.instance.unExtractGold>0)
				{
					Alert.show2(StringConst.PANEL_OPEN_GIFT_014,sureFunc2,null,StringConst.PROMPT_PANEL_0012,StringConst.PROMPT_PANEL_0013,null);
				}else
				{
					Alert.show2(StringConst.PANEL_OPEN_GIFT_009,sureFunc1,null,StringConst.PROMPT_PANEL_0012,StringConst.PROMPT_PANEL_0013,null);
				}
			}
			else
			{
				str = StringUtil.substitute(StringConst.PANEL_OPEN_GIFT_013,cfg.cost_unbind,cfg.name);
				Alert.show2(str,sureFunc,null,StringConst.PROMPT_PANEL_0012,StringConst.PROMPT_PANEL_0013,null);
			}
		}
		
		private function sureFunc():void
		{
			_panel.viewHandler.storeBitmaps();
			OpenServiceActivityDatamanager.instance.getSpecialReward(curIndex);
		}
		
		private function sureFunc1():void
		{
			JsUtils.callRecharge();
		}
		private function sureFunc2():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_MALL);
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
	}
}