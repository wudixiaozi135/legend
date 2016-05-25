package com.view.gameWindow.panel.panels.specialRing.dungeon
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.util.LoaderCallBackAdapter;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	/**
	 * 特戒副本标签页类
	 * @author Administrator
	 */	
	public class TabSpecialRingDungeon extends TabBase
	{
		internal var viewHandle:TabSpecialRingDgnViewHandle;
		internal var mouseHandle:TabSpecialRingDgnMouseHandle;
		
		public function TabSpecialRingDungeon()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McSpecialRingDungeon = new McSpecialRingDungeon();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McSpecialRingDungeon = _skin as McSpecialRingDungeon;
			rsrLoader.addCallBack(skin.btn,function (mc:MovieClip):void
			{
				viewHandle.btnOk = true;
				viewHandle.refershBtn();
			});
			rsrLoader.addCallBack(skin.mcRate,function (mc:MovieClip):void
			{
				viewHandle.beginRota=true;
			});
			
			var loaderCallBackAdapter:LoaderCallBackAdapter = new LoaderCallBackAdapter();
			loaderCallBackAdapter.addCallBack(rsrLoader,function ():void{
				skin.mcNote1.load=skin.mcNote2.load=skin.mcNote3.load=skin.mcNote4.load=skin.mcNote5.load=true;
				viewHandle.setRota();
			},skin.mcNote1,skin.mcNote2,skin.mcNote3,skin.mcNote4,skin.mcNote5);
		}
		
		override protected function initData():void
		{
			viewHandle = new TabSpecialRingDgnViewHandle(this);
			mouseHandle = new TabSpecialRingDgnMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_RING_INFO:
					viewHandle.refreshIcon();
					break;
				case GameServiceConstants.SM_CHR_INFO:
					viewHandle.refreshVit();
					break;
				default:
					viewHandle.refreshIcon();
					viewHandle.refreshVit();
					break;
			}
		}
		
		override public function destroy():void
		{
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			SpecialRingDataManager.instance.attach(this);
			DailyDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			DailyDataManager.instance.detach(this);
			SpecialRingDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}