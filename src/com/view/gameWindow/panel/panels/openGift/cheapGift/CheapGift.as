package com.view.gameWindow.panel.panels.openGift.cheapGift
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.openActivity.McCheapGift;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class CheapGift extends Sprite
	{
		public var skin:McCheapGift;
		private var _viewHandler:CheapGiftViewHandle;
		private var _mouseHandler:CheapGiftMouseHandle;
        public var defaultIndex:int = -1;
		public function CheapGift()
		{
			super();
			initSkin();
			initData();
		}
		
		public function get mouseHandler():CheapGiftMouseHandle
		{
			return _mouseHandler;
		}

		public function get viewHandler():CheapGiftViewHandle
		{
			return _viewHandler;
		}

		private function initData():void
		{
			// TODO Auto Generated method stub
			_viewHandler =  new CheapGiftViewHandle(this);
			_mouseHandler = new CheapGiftMouseHandle(this);
		}
		
		private function initSkin():void
		{
			// TODO Auto Generated method stub
			skin = new McCheapGift();
			addChild(skin);
			var _rsrLoader:RsrLoader = new RsrLoader();
			addCallBack(_rsrLoader);
			_rsrLoader.load(skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
		}
		
		
		
		private function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			rsrLoader.addCallBack(skin.btnEquip.btn,function (mc:MovieClip):void
			{
                if (defaultIndex == -1)
                {
                    viewHandler.dealSelectTab();
                }
			});
			rsrLoader.addCallBack(skin.btnGet,function (mc:MovieClip):void
			{
			});
		}
		
		
		public function destroy():void
		{
			_viewHandler.destroy();
			_mouseHandler.destroy();
			removeChild(skin);
		}
	}
}