package com.view.gameWindow.panel.panels.specialRing.upgrade
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingData;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * 特戒升级标签页类
	 * @author Administrator
	 */	
	public class TabSpecialRingUpgrade extends TabBase
	{
		internal var viewHandle:TabSpecialRingUpViewHandle;
		internal var mouseHandle:TabSpecialRingUpMouseHandle;
		
		public function TabSpecialRingUpgrade()
		{
			super();
			SpecialRingDataManager.instance.initialize();
		}
		
		override protected function initSkin():void
		{
			var skin:McSpecialRingUpgrade = new McSpecialRingUpgrade();
			initBtnUrls(skin);
			_skin = skin;
			addChild(_skin);
		}
		
		private function initBtnUrls(skin:McSpecialRingUpgrade):void
		{
			var dt:SpecialRingData;
			var datas:Dictionary = SpecialRingDataManager.instance.datas;
			for each (dt in datas)
			{
				skin["mcRing"+dt.ringIndex].resUrl = "ring/ring"+dt.ringId+".swf";
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McSpecialRingUpgrade = _skin as McSpecialRingUpgrade;
			var i:int,l:int = 8,j:int,jl:int = 10;
			rsrLoader.addCallBack(skin.btnUse,function (mc:MovieClip):void
			{
				viewHandle.refreshChangeRing(false);
			})
			for(i=0;i<l;i++)
			{
				rsrLoader.addCallBack(skin["mcRing"+(i+1)],function(mc:MovieClip):void
				{
					viewHandle.refreshRingBtns(mc);
				});
			}
			for(j=0;j<jl;j++)
			{
				rsrLoader.addCallBack(skin.mcUpgrade.mcStarsBtns["btn"+(j+1)],starsBtnsCallBack(j));
			}
			
			rsrLoader.addCallBack(skin.mcName,function (mc:MovieClip):void
			{
				var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
				mc.gotoAndStop(manager.select);
			});
		}
		
		private function starsBtnsCallBack(index:int):Function
		{
			var func:Function = function(mc:MovieClip):void
			{
				viewHandle.updateBtn(mc,index);
				viewHandle.updateLocation(mc,index);
				viewHandle.addStarTip(mc);
				
				InterObjCollector.autoCollector.add(mc,PanelConst.TYPE_SPECIAL_RING);
			};
			return func;
		}
		
		override protected function initData():void
		{
			viewHandle = new TabSpecialRingUpViewHandle(this);
			mouseHandle = new TabSpecialRingUpMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.refreshRingBtns();
			viewHandle.refreshGoldChip();
			viewHandle.refreshChangeRing();
		}
		
		override public function destroy():void
		{
			InterObjCollector.autoCollector.removeByGroupId(PanelConst.TYPE_SPECIAL_RING);
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
			BagDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			BagDataManager.instance.detach(this);
			SpecialRingDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}