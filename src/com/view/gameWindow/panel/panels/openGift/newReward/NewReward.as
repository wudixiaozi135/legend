package com.view.gameWindow.panel.panels.openGift.newReward
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerNewRewardCfgData;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.openActivity.McOpenNew;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	
	import flash.display.Sprite;
	
	public class NewReward extends Sprite
	{
		private var _skin:McOpenNew;
		private var _view:NewRewardViewHandler;
		private var _mouse:NewRewardMouseHandler;
		private var _rsrLoader:RsrLoader;
		private var cfg:OpenServerNewRewardCfgData;
		public function NewReward()
		{
			initSkin();
			initData();
			super();
		}
		
		public function get viewHandler():NewRewardViewHandler
		{
			return _view;
		}
		
		public function get skin():McOpenNew
		{
			return _skin;
		}
		
		private function initSkin():void
		{
			// TODO Auto Generated method stub
			_skin = new McOpenNew();
			var day:int = OpenServiceActivityDatamanager.instance.curDay;
			cfg = ConfigDataManager.instance.OpenServerNewRewardData(day,day);
			addChild(_skin);
			skin.giftName.resUrl = "openGift/"+cfg.icon_show+ResourcePathConstants.POSTFIX_PNG;
			skin.mcPrice.resUrl = "openGift/"+cfg.gold+ResourcePathConstants.POSTFIX_PNG;
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
			_view = new NewRewardViewHandler(this);
			_mouse = new NewRewardMouseHandler(this);
		}
		
		public function destroy():void
		{
			// TODO Auto Generated method stub
			_view.destroy();
			_view = null;
			_mouse.destroy();
			_mouse = null;
			_rsrLoader.destroy();
			_rsrLoader = null;
			_skin.parent.removeChild(_skin);
			_skin = null;
		}
	}
}