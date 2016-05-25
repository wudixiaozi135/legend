package com.view.gameWindow.panel.panels.daily.taskdungeon
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	public class TabDailyTaskDgn extends TabBase
	{
		internal var viewHandle:TabDailyTaskDgnViewHandle;
		internal var mouseHandle:TabDailyTaskDgnMouseHandle;
		
		public function TabDailyTaskDgn()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McDailyTaskDungeon1 = new McDailyTaskDungeon1();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McDailyTaskDungeon1 = _skin as McDailyTaskDungeon1;
			var i:int,l:int = 3;
			for(i=0;i<l;i++)
			{
				var mcBtnTxt:McDailyTaskDgnBtnTxt1 = skin["mcItem"+i].mcBtnTxt;
				rsrLoader.addCallBack(mcBtnTxt.btnDo,function (mc:MovieClip):void
				{
					var mcBtnTxt:McDailyTaskDgnBtnTxt1 = mc.parent as McDailyTaskDgnBtnTxt1;
					if(mcBtnTxt)
					{
						viewHandle.itemDic[mcBtnTxt].initByTab();
					}
				});
				rsrLoader.addCallBack(mcBtnTxt.btnOneKey,function (mc:MovieClip):void
				{
					var mcBtnTxt:McDailyTaskDgnBtnTxt1 = mc.parent as McDailyTaskDgnBtnTxt1;
					if(mcBtnTxt)
					{
						viewHandle.itemDic[mcBtnTxt].initByTab();
					}
				});
				rsrLoader.addCallBack(skin.btnLeft,function (mc:MovieClip):void
				{
					viewHandle.refreshPageBtn();
				});
				rsrLoader.addCallBack(skin.btnRight,function (mc:MovieClip):void
				{
					viewHandle.refreshPageBtn();
				});
			}
		}
		
		override protected function initData():void
		{
			viewHandle = new TabDailyTaskDgnViewHandle(this);
			mouseHandle = new TabDailyTaskDgnMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.refresh();
		}
		
		override public function destroy():void
		{
			mouseHandle.destroy();
			mouseHandle = null;
			viewHandle.destroy();
			viewHandle = null;
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			DgnDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			DgnDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}