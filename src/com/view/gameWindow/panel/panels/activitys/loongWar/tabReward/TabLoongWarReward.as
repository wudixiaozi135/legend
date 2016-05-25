package com.view.gameWindow.panel.panels.activitys.loongWar.tabReward
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	/**
	 * 龙城争霸奖励页
	 * @author Administrator
	 */	
	public class TabLoongWarReward extends TabBase
	{
		internal var viewhandle:TabLoongWarRewardViewHandle;
		internal var mouseHandle:TabLoongWarRewardMouseHandle;
		
		public function TabLoongWarReward()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McLoongWarReward = new McLoongWarReward();
			_skin = skin;
			_skin.mouseEnabled = false;
			addChild(skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McLoongWarReward = skin as McLoongWarReward;
			rsrLoader.addCallBack(skin.btnGet,function(mc:MovieClip):void
			{
				if(viewhandle)
				{
					viewhandle.updatebtnEnabled();
				}
			});
		}
		
		override protected function initData():void
		{
			viewhandle = new TabLoongWarRewardViewHandle(this);
			mouseHandle = new TabLoongWarRewardMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			if(proc != GameServiceConstants.SM_LONGCHENG_AWARD_INFO_LIST)
			{
				return;
			}
			viewhandle.update();
		}
		
		override public function destroy():void
		{
			if(viewhandle)
			{
				viewhandle.destroy();
				viewhandle = null;
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