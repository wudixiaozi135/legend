package com.view.gameWindow.panel.panels.activitys.loongWar.tabApply
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	/**
	 * 龙城争霸报名页
	 * @author Administrator
	 */	
	public class TabLoongWarApply extends TabBase
	{
		internal var viewHandle:TabLoongWarApplyViewHandle;
		internal var mouseHandle:TabLoongWarApplyMousehandle;
		
		public function TabLoongWarApply()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McLoongWarApply = new McLoongWarApply();
			_skin = skin;
			addChild(skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McLoongWarApply = _skin as McLoongWarApply;
			rsrLoader.addCallBack(skin.mcScrollBarAttack,function(mc:MovieClip):void
			{
				viewHandle.initScrollBar(mc);
			});
			rsrLoader.addCallBack(skin.mcScrollBarUion,function(mc:MovieClip):void
			{
				viewHandle.initScrollBar(mc,true);
			});
		}
		
		override protected function initData():void
		{
			//
			viewHandle = new TabLoongWarApplyViewHandle(this);
			viewHandle.initialize();
			mouseHandle = new TabLoongWarApplyMousehandle(this);
			mouseHandle.initialize();
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.update();
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