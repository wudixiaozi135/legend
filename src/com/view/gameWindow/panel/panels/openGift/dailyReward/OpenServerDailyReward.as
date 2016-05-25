package com.view.gameWindow.panel.panels.openGift.dailyReward
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.openActivity.McOpenDailyReward;
	
	import flash.display.Sprite;
	
	public class OpenServerDailyReward extends Sprite
	{
		private var _skin:McOpenDailyReward;
		private var _rsrLoader:RsrLoader;
		private var _viewHandler:OpenServerDailyRewardViewHandler;
		public function OpenServerDailyReward()
		{
			initSkin();
			initData();
			super();
		}
		
		public function get viewHandler():OpenServerDailyRewardViewHandler
		{
			return _viewHandler;
		}

		public function get skin():McOpenDailyReward
		{
			return _skin;
		}

		private function initSkin():void
		{
			// TODO Auto Generated method stub
			_skin = new McOpenDailyReward();
			addChild(_skin);
			_rsrLoader = new RsrLoader();
			addCallBack(_rsrLoader);
			_rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
		}
		
		private function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
		}
		
		private function initData():void
		{
			// TODO Auto Generated method stub
			_viewHandler = new OpenServerDailyRewardViewHandler(this);
		}
		
		public function destroy():void
		{
			// TODO Auto Generated method stub
			_viewHandler.destroy();
			_viewHandler = null;
			_skin.parent.removeChild(_skin);
			_skin = null;
		}
	}
}