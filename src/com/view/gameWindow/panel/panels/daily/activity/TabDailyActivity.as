package com.view.gameWindow.panel.panels.daily.activity
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class TabDailyActivity extends TabBase
	{
		internal var mouseHandle:TabDailyActivityMouseHandle;
		internal var viewHandle:TabDailyActivityViewHandle;
		
		public function TabDailyActivity()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McDailyActivity1 = new McDailyActivity1();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McDailyActivity1 = _skin as McDailyActivity1;
			rsrLoader.addCallBack(skin.mcScrollBar,function (mc:MovieClip):void
			{
				viewHandle.initScrollBar(mc);
			});
			rsrLoader.addCallBack(skin.mcItemOver,function (mc:MovieClip):void
			{
				mc.visible = false;
				mc.mouseChildren = false;
				mc.mouseEnabled = false;
			});
			rsrLoader.addCallBack(skin.mcItemSelect,function (mc:MovieClip):void
			{
				mc.mouseChildren = false;
				mc.mouseEnabled = false;
			});
			rsrLoader.addCallBack(skin.btn,function (mc:MovieClip):void
			{
				var txt:TextField = mc.txt as TextField;
				txt.text = StringConst.DAILY_PANEL_0029;
				txt.textColor = 0xd4a460;
			});
		}
		
		override protected function initData():void
		{
			viewHandle = new TabDailyActivityViewHandle(this);
			mouseHandle = new TabDailyActivityMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.refresh();
		}
		
		override public function destroy():void
		{
			if(viewHandle)
			{
				viewHandle.destroy();
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
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			super.detach();
		}
		
	}
}