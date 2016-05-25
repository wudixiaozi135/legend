package com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo
{
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	/**
	 * 龙城争霸信息页
	 * @author Administrator
	 */	
	public class TabLoongWarInfo extends TabBase
	{
		internal var viewHandle:TabLoongWarInfoViewHandle;
		internal var mouseHandle:TabLoongWarInfoMouseHandle;
		
		public function TabLoongWarInfo()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McLoongWarInfo = new McLoongWarInfo();
			_skin = skin;
			addChild(skin);
		}
		
		override protected function initData():void
		{
			//
			viewHandle = new TabLoongWarInfoViewHandle(this);
			mouseHandle = new TabLoongWarInfoMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.update();
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
			ActivityDataManager.instance.loongWarDataManager.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			ActivityDataManager.instance.loongWarDataManager.detach(this);
			super.detach();
		}
		
	}
}