package com.view.gameWindow.panel.panels.daily.pep
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	public class TabDailyPep extends TabBase
	{
		internal var viewHandle:TabDailyPepViewHandle;
		internal var mouseHandle:TabDailyPepMouseHandle;
		
		public function TabDailyPep()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McDailyPep = new McDailyPep();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skin.mcScrollBar,function (mc:MovieClip):void//滚动条资源加载完成后构造滚动条控制类
			{
				if(viewHandle)
				{
					viewHandle.initScrollBar(mc);
				}
			});
			var i:int,l:int = 4;
			for(i=0;i<l;i++)
			{
				rsrLoader.addCallBack(_skin["mcReward"+i].mcMaskbtn.btn,function (mc:MovieClip):void
				{
					if(viewHandle)
					{
						viewHandle.initRewardItems(false);
						viewHandle.refreshRewardItems();
					}
				});
			}
		}
		
		override protected function initData():void
		{
			viewHandle = new TabDailyPepViewHandle(this);
			mouseHandle = new TabDailyPepMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.refreshItems();
			viewHandle.refreshPep();
			viewHandle.refreshRewardItems();
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
			DailyDataManager.instance.attach(this);
			DgnDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			DgnDataManager.instance.detach(this);
			DailyDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}