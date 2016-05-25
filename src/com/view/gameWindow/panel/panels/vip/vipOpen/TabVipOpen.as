package com.view.gameWindow.panel.panels.vip.vipOpen
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 开通vip选项卡类
	 * @author Administrator
	 */	
	public class TabVipOpen extends TabBase
	{
		internal var viewHandle:TabVipOpenViewHandle;
		internal var mouseHandle:TabVipOpenMouseHandle;
		
		public function TabVipOpen()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var mc:McVipOpen = new McVipOpen();
			_skin = mc;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McVipOpen = _skin as McVipOpen;
			rsrLoader.addCallBack(skin.mcSign,function(mc:MovieClip):void
			{
				if(mouseHandle)
				{
					var peerage:int = mouseHandle.peerage;
					mc.gotoAndStop(peerage);
				}
			});
			rsrLoader.addCallBack(skin.mcWord,function(mc:MovieClip):void
			{
				if(mouseHandle)
				{
					var peerage:int = mouseHandle.peerage;
					mc.gotoAndStop(peerage);
				}
			});
			rsrLoader.addCallBack(skin.btnGet,function(mc:MovieClip):void
			{
				var textField:TextField;
				var manager:VipDataManager = VipDataManager.instance;
				var isRewardGetted:Boolean = manager.isRewardGetted(manager.lv);
				if(isRewardGetted && manager.lv == VipDataManager.MAX_LV)
				{
					mc.btnEnabled = false;
					viewHandle.isRewardCanGet = false;
					textField = mc.txt as TextField;
					textField.text = StringConst.VIP_PANEL_0010;
					textField.textColor = 0xd4a460;
				}
				else
				{
					textField = mc.txt as TextField;
					textField.text = StringConst.VIP_PANEL_0010;
					textField.textColor = 0xd4a460;
				}
			});
			rsrLoader.addCallBack(skin.btnOpen,function(mc:MovieClip):void
			{
				viewHandle.refreshBtnOpen();
			});
			rsrLoader.addCallBack(skin.btnLeft,function (mc:MovieClip):void
			{
				viewHandle.refreshBtnLR();
			});
			rsrLoader.addCallBack(skin.btnRight,function (mc:MovieClip):void
			{
				viewHandle.refreshBtnLR();
			});
		}
		
		override protected function initData():void
		{
			viewHandle = new TabVipOpenViewHandle(this);
			mouseHandle = new TabVipOpenMouseHandle(this);
			viewHandle.refreshPeerageShow();
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.refreshVipShow();
			if(proc == GameServiceConstants.CM_NOBILITY_BUY)
			{
				showBuyTip();
			}
		}
		
		private function showBuyTip():void
		{
			var str:String;
			str = StringConst.PROMPT_PANEL_0016.replace("XX",VipDataManager.instance.peerageCfgData.name).replace("XX",VipDataManager.instance.peerageCfgData.gold) + StringConst.PROMPT_PANEL_0019;
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);
		}
		
		override public function destroy():void
		{
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			VipDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			VipDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}